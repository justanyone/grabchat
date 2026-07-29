from pathlib import Path
import subprocess
import sys
import textwrap


REPO_ROOT = Path(__file__).resolve().parents[1]


def test_installer_uses_github_prompt_layout_without_overwriting_existing_files(tmp_path: Path) -> None:
    target = tmp_path / "someproject"
    (target / ".github").mkdir(parents=True)
    (target / ".github" / "copilot-instructions.md").write_text(
        "# existing instructions\n",
        encoding="utf-8",
    )
    existing_prompt = target / ".github" / "prompts"
    existing_prompt.mkdir(parents=True)
    existing_target = existing_prompt / "existing.prompt.md"
    existing_target.write_text("keep me\n", encoding="utf-8")

    result = subprocess.run(
        ["bash", str(REPO_ROOT / "scripts" / "install_grabchat.sh"), str(target)],
        cwd=REPO_ROOT,
        capture_output=True,
        text=True,
        check=False,
    )

    assert result.returncode == 0, result.stderr
    installed_prompt = target / ".github" / "prompts" / "grabchat.prompt.md"
    assert installed_prompt.exists()
    assert existing_target.read_text(encoding="utf-8") == "keep me\n"
    assert (target / ".github" / "copilot-instructions.md").read_text(encoding="utf-8") == "# existing instructions\n"
