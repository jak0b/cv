"""Update pinned build dependencies and their documented versions from GitHub releases."""

import json
import os
from pathlib import Path
import re
import urllib.request

ROOT = Path(__file__).resolve().parents[1]
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


def latest_versions():
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
    return versions


def update(root, latest):
    manifest = root / ".github/dependencies.json"
    current = json.loads(manifest.read_text())
    # Validate everything before writing any files. Never downgrade a pin.
    replacements = {}
    for name, old in current.items():
        new = latest[name]
        if version_tuple(new) > version_tuple(old):
            replacements[name] = (old, new)
            current[name] = new
            print(f"{name}: {old} -> {new}")
    if not replacements:
        print("All dependencies are up to date.")
        return
    for filename in ("README.md", "AGENTS.md"):
        path = root / filename
        text = path.read_text()
        for name, (old, new) in replacements.items():
            text = re.sub(
                "(" + DOCUMENT_PREFIXES[name] + ")" + re.escape(old) + r"(?![\d.])",
                lambda match: match[1] + new,
                text,
            )
        path.write_text(text)
    manifest.write_text(json.dumps(current, indent=2) + "\n")


if __name__ == "__main__":
    update(ROOT, latest_versions())
