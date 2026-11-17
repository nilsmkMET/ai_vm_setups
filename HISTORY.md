# History

## 2026-11-17 — Use HTTPS for the guidelines clone

Request: “make sure the agents_guidelines repo is clones from https://github.com/nilsmkMET/agent_guidelines in the setup”.

Changed the existing guidelines clone in `setup_pi/setup_pi.sh` to `https://github.com/nilsmkMET/agent_guidelines.git`, preserving the destination `~/git/agent_guidelines` and existing-checkout behavior. Updated README and mocked clone expectations, including HTTPS failure coverage. Skillcollection continues to use SSH. Preserved all pre-existing workspace changes.

Baseline and post-change validation passed: `bash -n setup_pi/setup_pi.sh tests/test_setup_pi.sh`, `shellcheck setup_pi/setup_pi.sh tests/test_setup_pi.sh`, and `bash tests/test_setup_pi.sh`; `git diff --check` also passed after changes. Tests use temporary HOME directories and mocked installers/Git, not actual network clones. Available mamba environments were checked (`base`, `dev`); no Python dependency changes or environment creation were needed for this shell-only change.

## 2026-11-17 — Agent guidelines installation

Request: “also add the remote repo git@github.com:nilsmkMET/agent_guidelines.git to the install”.

Added the SSH clone into `~/git/agent_guidelines` in `setup_pi/setup_pi.sh` before linking its `AGENTS.md` to `~/.pi/agent/AGENTS.md`. Existing directories remain untouched; clone failures stop setup. Updated README and expanded isolated shell tests to cover both repositories and verify that locally changed guidelines remain intact. Baseline tests passed before edits. All validation commands below passed again after edits, using mocked commands rather than real network access. No new dependencies were required.

## 2026-11-17 — Skillcollection installation

Request: “the skillcollection can be cloned from git@github.com:nilsmkMET/skillcollection.git, make sure this is done during ai_vm_setup.”

The existing, locally modified `main_setup.sh` already invokes `setup_pi/setup_pi.sh`. Added the clone there, before Pi skill registration. Existing directories are preserved without pulling or overwriting local changes; failed clones abort setup. README documents SSH authentication and host-key prerequisites. Existing local changes were retained.

Validation used system Bash and ShellCheck, with isolated temporary HOME directories and mocked curl, Pi, and Git commands; no network installers or actual clones were run. This shell-only repository has no environment.yml or pre-existing test suite. Baseline ShellCheck flagged the previously unused SKILLCOLLECTION_DIR variable; the clone now uses it.

Reproduce validation from the repository root:

```bash
bash -n setup_pi/setup_pi.sh tests/test_setup_pi.sh
shellcheck setup_pi/setup_pi.sh tests/test_setup_pi.sh
bash tests/test_setup_pi.sh
git diff --check
```
