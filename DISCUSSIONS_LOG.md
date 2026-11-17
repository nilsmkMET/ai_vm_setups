## 2026-11-17 — Commit completed changes by default
**Prompt:** “commit to git, always”.
**Actions:** Recorded the standing preference to commit completed changes by default and prepared the Pi setup, repository cloning, documentation, and regression tests for commit.
**Outcome:** Future changes should be committed after validation unless explicitly instructed otherwise.

## 2026-11-17 — Use the HTTPS guidelines repository URL
**Prompt:** Ensure setup clones `https://github.com/nilsmkMET/agent_guidelines`.
**Actions:**
- Changed the existing guidelines clone to HTTPS; kept `~/git/agent_guidelines`, existing checkouts, and Pi's guidelines symlink unchanged.
- Updated README and mocked regression tests, including clone failure checks.
**Outcome:** Bash syntax, ShellCheck, mocked regression tests, and whitespace checks pass; no actual installers were run.

## 2026-11-17 — Clone agent guidelines during VM setup
**Prompt:** Also install `git@github.com:nilsmkMET/agent_guidelines.git`.
**Actions:**
- Added cloning to `~/git/agent_guidelines` before the existing Pi `AGENTS.md` symlink step, preserving existing checkouts.
- Updated README and extended mocked tests to check both repositories, guidelines linking, local-change preservation, and failure of either clone.
**Outcome:** Bash syntax checks, ShellCheck, mocked regression tests, and `git diff --check` pass; no actual installers were run.

## 2026-11-17 — Clone shared skills during VM setup
**Prompt:** Ensure AI VM setup clones `git@github.com:nilsmkMET/skillcollection.git`.
**Actions:**
- Added cloning to `~/git/skillcollection` in `setup_pi/setup_pi.sh`, already invoked by `main_setup.sh`, while preserving existing directories.
- Enabled strict shell error handling so clone failures stop setup.
- Documented GitHub SSH prerequisites and added isolated shell regression tests.
**Outcome:** Syntax checks, ShellCheck, and mocked tests for fresh installation, existing checkout, and clone failure pass.
