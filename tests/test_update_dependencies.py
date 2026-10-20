import importlib.util
import json
from pathlib import Path
import tempfile
import unittest

SPEC = importlib.util.spec_from_file_location(
    "updater", Path(__file__).resolve().parents[1] / "scripts/update-dependencies.py"
)
updater = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(updater)


class UpdateTests(unittest.TestCase):
    def test_only_stable_releases_with_expected_font_assets(self):
        release = {
            "draft": False, "prerelease": False, "tag_name": "v3.5.0",
            "assets": [{"name": "Iosevka.tar.xz"}],
        }
        self.assertEqual(updater.release_version(release, "Iosevka.tar.xz"), "3.5.0")
        for changes in (
            {"draft": True}, {"prerelease": True}, {"tag_name": "v3.5.0-rc1"},
            {"assets": []},
        ):
            with self.subTest(changes=changes), self.assertRaises(ValueError):
                updater.release_version(release | changes, "Iosevka.tar.xz")

    def test_update_docs_and_manifest_and_repeat_without_changes(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / ".github").mkdir()
            initial = {"typst": "0.14.2", "nerd-fonts": "3.4.0", "font-awesome": "7.0.1"}
            (root / ".github/dependencies.json").write_text(json.dumps(initial))
            (root / "README.md").write_text(
                "Typst 0.14.2, Iosevka Nerd Fonts\n3.4.0, Font Awesome Free 7.0.1\n"
                "nerd-fonts/releases/tag/v3.4.0 Font-Awesome/releases/tag/7.0.1\n"
            )
            (root / "AGENTS.md").write_text(
                "Typst (0.14.2 matches CI), Iosevka Nerd Fonts 3.4.0, "
                "Font Awesome Free 7.0.1"
            )
            newer = {"typst": "0.15.1", "nerd-fonts": "3.5.0", "font-awesome": "7.1.0"}
            updater.update(root, newer)
            self.assertEqual(json.loads((root / ".github/dependencies.json").read_text()), newer)
            readme = (root / "README.md").read_text()
            self.assertIn("releases/tag/v3.5.0", readme)
            self.assertIn("releases/tag/7.1.0", readme)
            self.assertIn("Typst 0.15.1", readme)
            self.assertIn("Typst (0.15.1 matches CI)", (root / "AGENTS.md").read_text())
            before = {p: p.read_bytes() for p in root.rglob("*") if p.is_file()}
            updater.update(root, newer)
            updater.update(root, {"typst": "0.14.2", "nerd-fonts": "3.4.0", "font-awesome": "7.0.1"})
            self.assertEqual(before, {p: p.read_bytes() for p in before})

    def test_dependencies_with_same_version_update_independently(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / ".github").mkdir()
            (root / ".github/dependencies.json").write_text(json.dumps(
                {name: "1.0.0" for name in updater.DEPENDENCIES}
            ))
            for filename in ("README.md", "AGENTS.md"):
                (root / filename).write_text(
                    "Typst 1.0.0, Iosevka Nerd Fonts 1.0.0, Font Awesome Free 1.0.0"
                )
            updater.update(root, {"typst": "2.0.0", "nerd-fonts": "3.0.0", "font-awesome": "4.0.0"})
            self.assertEqual(
                (root / "README.md").read_text(),
                "Typst 2.0.0, Iosevka Nerd Fonts 3.0.0, Font Awesome Free 4.0.0",
            )

    def test_invalid_release_leaves_files_untouched(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / ".github").mkdir()
            manifest = root / ".github/dependencies.json"
            original = (updater.ROOT / ".github/dependencies.json").read_bytes()
            manifest.write_bytes(original)
            with self.assertRaises(ValueError):
                updater.update(root, {"typst": "0.15.1", "nerd-fonts": "bad", "font-awesome": "7.1.0"})
            self.assertEqual(manifest.read_bytes(), original)


if __name__ == "__main__":
    unittest.main()
