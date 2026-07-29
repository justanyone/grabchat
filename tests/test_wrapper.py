from pathlib import Path
import subprocess
import sys


REPO_ROOT = Path(__file__).resolve().parents[1]


def test_wrapper_help_invokes_script() -> None:
    result = subprocess.run(
        [sys.executable, str(REPO_ROOT / "scripts" / "grabchat.py"), "--help"],
        cwd=REPO_ROOT,
        capture_output=True,
        text=True,
        check=False,
    )

    assert result.returncode == 0, result.stderr
    assert "Usage:" in result.stdout
    assert "grabchat" in result.stdout.lower()
