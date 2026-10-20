"""Update build dependencies from GitHub releases and the Typst package index."""

import json
import os
from pathlib import Path
import re
import urllib.request

ROOT = Path(__file__).resolve().parents[1]
PACKAGE_INDEX = "https://packages.typst.org/preview/index.json"
PACKAGE_IMPORT = re.compile(
    r'(?m)^\s*#import\s+"@preview/([a-z0-9-]+):([^"\s]+)"'
)
DEPENDENCIES = {
    "typst": ("typst/typst", None),
    "nerd-fonts": ("ryanoasis/nerd-fonts", "Iosevka.tar.xz"),
    "font-awesome": (
        "FortAwesome/Font-Awesome", "fontawesome-free-{version}-desktop.zip"
    ),
}
DOCUMENT_PREFIXES = {
    "typst": r"Typst \(?",
    "nerd-fonts": r"(?:Iosevka Nerd Fonts\s+|nerd-fonts/releases/tag/v)",
    "font-awesome": r"(?:Font Awesome Free |Font-Awesome/releases/tag/)",
}


def version_tuple(version):
    if not re.fullmatch(r"\d+\.\d+\.\d+", version):
        raise ValueError(f"Unsupported release version: {version!r}")
    return tuple(map(int, version.split(".")))


def release_version(release, asset):
    if release["draft"] or release["prerelease"]:
        raise ValueError("Expected a stable published release")
    version = release["tag_name"].removeprefix("v")
    version_tuple(version)
    if asset and asset.format(version=version) not in {
        item["name"] for item in release["assets"]
    }:
        raise ValueError(f"Required font archive missing from release {version}")
    return version


def package_versions(root):
    versions = {}
    for path in root.glob("*.typ"):
        for name, version in PACKAGE_IMPORT.findall(path.read_text()):
            version_tuple(version)
            if name in versions and versions[name] != version:
                raise ValueError(f"Conflicting import versions for @preview/{name}")
            versions[name] = version
    return versions


def latest_package_versions(index, names):
    versions = {}
    for name in names:
        stable = [
            entry["version"] for entry in index
            if entry["name"] == name
            and not entry.get("yanked", False)
            and re.fullmatch(r"\d+\.\d+\.\d+", entry["version"])
        ]
        if not stable:
            raise ValueError(f"No stable release found for @preview/{name}")
        versions[name] = max(stable, key=version_tuple)
    return versions


def latest_versions(root=ROOT):
    versions = {}
    for name, (repository, asset) in DEPENDENCIES.items():
        headers = {"Accept": "application/vnd.github+json", "User-Agent": "cv-dependency-updater"}
        if token := os.environ.get("GH_TOKEN"):
            headers["Authorization"] = f"Bearer {token}"
        request = urllib.request.Request(
            f"https://api.github.com/repos/{repository}/releases/latest", headers=headers
        )
        with urllib.request.urlopen(request, timeout=30) as response:
            versions[name] = release_version(json.load(response), asset)
    packages = package_versions(root)
    if packages:
        with urllib.request.urlopen(PACKAGE_INDEX, timeout=30) as response:
            versions.update(latest_package_versions(json.load(response), packages))
    return versions


def update(root, latest):
    manifest = root / ".github/dependencies.json"
    current = json.loads(manifest.read_text())
    packages = package_versions(root)
    # Validate everything before writing any files. Never downgrade a pin.
    replacements = {}
    for name, old in (current | packages).items():
        new = latest[name]
        if version_tuple(new) > version_tuple(old):
            replacements[name] = (old, new)
            if name in current:
                current[name] = new
            print(f"{name}: {old} -> {new}")
    if not replacements:
        print("All dependencies are up to date.")
        return
    for filename in ("README.md", "AGENTS.md"):
        path = root / filename
        text = path.read_text()
        for name, (old, new) in replacements.items():
            if name not in DOCUMENT_PREFIXES:
                continue
            text = re.sub(
                "(" + DOCUMENT_PREFIXES[name] + ")" + re.escape(old) + r"(?![\d.])",
                lambda match: match[1] + new,
                text,
            )
        path.write_text(text)
    for path in root.glob("*.typ"):
        text = path.read_text()
        updated = PACKAGE_IMPORT.sub(
            lambda match: match[0].replace(
                f"@preview/{match[1]}:{match[2]}",
                f"@preview/{match[1]}:{replacements[match[1]][1]}",
            ) if match[1] in replacements else match[0],
            text,
        )
        if updated != text:
            path.write_text(updated)
    manifest.write_text(json.dumps(current, indent=2) + "\n")


if __name__ == "__main__":
    update(ROOT, latest_versions())
