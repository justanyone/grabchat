# grabchat

[![Python Tests](https://github.com/kevin/grabchat/actions/workflows/python-tests.yml/badge.svg)](https://github.com/kevin/grabchat/actions/workflows/python-tests.yml)

Grabchat exports a Claude Code session transcript into a readable Markdown file and saves it under a local .chat_history directory.

It is designed to be useful as a slash command from within copilot or claude code.  This allows a simple command like:

```bash
/grabchat tuesday_test.md
```

and the entire chat history for that chat session will be copied into the file tuesday_test.md and that file place in a .chat_history/ subdirectory - either as a subdir of .claude or wherever else you want to put it (configurable in grabchat.ini file).

Existing chat export consumes tokens.  Adding this as a slash command ("/grabchat") makes it almost free to execute.  Note this is most useful in VSCode and the source directory *might* differ when using pycharm or claude code directly, users will need to configure that if their setup differs.

## Typical workflow

This repository is meant to support a very practical install flow:

1. A user discovers grabchat.
2. They clone the repo into a local directory such as mycode.
3. They have another repository inside that same local directory, such as someproject.
4. They run an installer script that copies grabchat’s important files into someproject without overwriting anything the user already has.
5. If someproject already has a .claude directory, the grabchat assets are added there.
6. If someproject has a .github directory and a copilot-instructions.md file, grabchat’s GitHub Copilot integration files are installed under .github with compatible naming.
7. In either case, the target project gains slash-command support so the user can invoke /grabchat inside Claude or Copilot-driven workflows.

## What it does

- Reads Claude Code session logs stored as .jsonl files
- Filters out noisy or internal system artifacts
- Renders the conversation into a clean Markdown document
- Writes the export to .chat_history/ by default
- Optionally opens the resulting Markdown in a browser after export
- Can install Claude/Copilot integration files into another project without overwriting existing user content

## Requirements

- Python 3.9+
- Access to a Claude Code project directory under ~/.claude/projects/
- Bash for the installer script

## Installation

Clone the repository and run the CLI from the repo root:

```bash
git clone https://github.com/yourname/grabchat.git
cd grabchat
python3 scripts/grabchat.py --help
```

If you want to install it as a package in the current environment, you can also use:

```bash
pip install .
```

After installation, the command-line entry point becomes:

```bash
grabchat --help
```

## Installing into another project

From the grabchat repo root, run:

```bash
bash scripts/install_grabchat.sh /path/to/someproject
```

This copies the grabchat support files into the destination project while preserving any existing files. Existing files are never overwritten. The installer only adds files that are missing, and it will create the target directory if it does not already exist.

For the exact mycode/someproject workflow, you can use the convenience wrapper:

```bash
bash scripts/install_for_mycode.sh /path/to/mycode
```

That command creates or reuses /path/to/mycode/someproject and installs grabchat into it.

### What gets installed

- Into .claude/:
  - scripts/grabchat.py
  - scripts/grabchat.ini
  - skills/ (if present)
  - commands/grabchat.md
  - commands/grabchat/README.md
- Into .github/ when applicable:
  - prompts/grabchat.prompt.md
  - instructions/grabchat.instructions.md
- It also appends a small note to CLAUDE.md or copilot-instructions.md when those files already exist, so the project learns about /grabchat.

## Usage

Typical commands:

```bash
python3 scripts/grabchat.py
python3 scripts/grabchat.py --list
python3 scripts/grabchat.py myfile
python3 scripts/grabchat.py -o path/to/out.md
```

### How the output is named

By default, exports are written to .chat_history/ using names like:

```text
.chat_history/chat_20260703_175255_exp_20260703_192115.md
```

You can also preserve a simpler filename by editing the configuration file described below.

## Configuration

A sample configuration file is included at [.claude/scripts/grabchat.ini](.claude/scripts/grabchat.ini). It controls things such as:

- timestamp rendering style
- how many exports are retained
- whether the latest export keeps a fixed filename
- whether the browser opens automatically

## Repository layout

- [.claude/scripts/grabchat.py](.claude/scripts/grabchat.py) — main implementation
- [scripts/grabchat.py](scripts/grabchat.py) — repo-friendly wrapper entry point
- [scripts/install_grabchat.sh](scripts/install_grabchat.sh) — installer for another project
- [.claude/scripts/grabchat.ini](.claude/scripts/grabchat.ini) — default configuration
- [.claude/skills/grabchat_skill.md](.claude/skills/grabchat_skill.md) — Claude skill instructions
- [.claude/commands/grabchat.md](.claude/commands/grabchat.md) — slash-command definition
- [.github/prompts/grabchat.prompt.md](.github/prompts/grabchat.prompt.md) — Copilot prompt entry
- [.github/instructions/grabchat.instructions.md](.github/instructions/grabchat.instructions.md) — Copilot instruction entry

## Development

Run the test suite with:

```bash
pytest
```

If you are running tests locally in this environment, it is easiest to use a virtual environment so you do not hit system Python package restrictions:

```bash
python3 -m venv .venv
. .venv/bin/activate
pip install pytest
pytest -q
```

## Notes

- The script is intentionally simple and dependency-light so it is easy to copy into another project.
- The browser auto-open feature is best-effort and only works when a browser binary is available.
- The installer intentionally avoids overwriting existing files so it works well with user-managed project setups.

## Debugging Tests

You may need to enable Ubuntu to unrestrict unpriviledged userns (user namespaces) to get tests to execute, in which case you'd need to:

```bash
echo "kernel.apparmor_restrict_unprivileged_userns=0" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

