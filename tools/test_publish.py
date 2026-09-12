# SPDX-License-Identifier: GPL-3.0-only
import json
from pathlib import Path
from tempfile import TemporaryDirectory
import unittest
from publish import validate, validate_publication


class PublishTests(unittest.TestCase):
    def setUp(self):
        self.temp = TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        for arch in ("amd64", "arm64"):
            folder = self.root / ("alpinevpn-" + arch)
            folder.mkdir()
            record = {"repository": "edbfi/base-image", "branch": "alpinevpn", "arch": arch,
                      "revision": "a" * 40, "tags": ["alpinevpn"]}
            (folder / "metadata.json").write_text(json.dumps(record))
            for name in ("image.tar", "result.txt", "packages.txt"):
                (folder / name).write_text("fixture")

    def validate(self):
        return validate(self.root, "edbfi/base-image", "alpinevpn")

    def test_complete_pair(self):
        self.assertEqual(self.validate()["revision"], "a" * 40)

    def test_missing_smoke_evidence(self):
        (self.root / "alpinevpn-amd64/result.txt").unlink()
        with self.assertRaises(ValueError): self.validate()

    def test_mixed_revisions(self):
        path = self.root / "alpinevpn-arm64/metadata.json"
        record = json.loads(path.read_text()); record["revision"] = "b" * 40
        path.write_text(json.dumps(record))
        with self.assertRaises(ValueError): self.validate()

    def test_other_repository(self):
        path = self.root / "alpinevpn-arm64/metadata.json"
        record = json.loads(path.read_text()); record["repository"] = "other/image"
        path.write_text(json.dumps(record))
        with self.assertRaises(ValueError): self.validate()


class PublicationPolicyTests(unittest.TestCase):
    def setUp(self):
        self.data = {"revision": "a" * 40}
        self.live = {"commit": {"sha": "a" * 40}, "protected": False}
        self.runs = [{"head_sha": "a" * 40, "head_branch": "alpinevpn",
                      "event": "push", "status": "completed", "conclusion": "success"}]

    def check(self, ref="refs/heads/alpinevpn", sha="a" * 40):
        validate_publication(self.data, "alpinevpn", self.live, self.runs, ref, sha)

    def test_unprotected_reviewed_branch_passes(self):
        self.check()

    def test_wrong_workflow_branch_rejected(self):
        with self.assertRaises(ValueError): self.check(ref="refs/heads/workflows")

    def test_wrong_workflow_revision_rejected(self):
        with self.assertRaises(ValueError): self.check(sha="b" * 40)

    def test_moved_live_branch_rejected(self):
        self.live["commit"]["sha"] = "b" * 40
        with self.assertRaises(ValueError): self.check()

    def test_missing_ci_rejected(self):
        self.runs = []
        with self.assertRaises(ValueError): self.check()

    def test_unsuitable_ci_rejected(self):
        for key, value in [("head_sha", "b" * 40), ("head_branch", "noblevpn"),
                           ("event", "pull_request"), ("status", "in_progress"),
                           ("conclusion", "failure"), ("conclusion", "skipped")]:
            with self.subTest(key=key, value=value):
                old = self.runs[0][key]
                self.runs[0][key] = value
                with self.assertRaises(ValueError): self.check()
                self.runs[0][key] = old
