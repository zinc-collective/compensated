const { spawn } = require("child-process-promise");

/*
 * The ContributorSandbox allows us to execute commands on a
 * per project basis. At present, it's used to execute tests
 * against multiple language versions, but it could also be
 * used to bootstrap a contributors developer machine
 * programmatically and other such nonsense.
 */
module.exports = class ContributorSandbox {
  constructor(language, project) {
    this.language = language;
    this.project = project;
  }

  /*
   * Spawns a process within the project directory.
   */
  async spawn(command) {
    const promise = spawn(command, [], {
      cwd: this.project,
      shell: true,
      capture: ["stdout", "stderr"],
      env: { ...process.env, ...this.env },
    });

    try {
      return promise;
    } catch (e) {
      return console.error(e.stdout, e.stderr, this.env);
    }
  }

  /*
   * Overrides process.env in spawned processes.
   *
   * Useful for injecting different environment flags
   * when feature testing.
   */
  get env() {
    return { RBENV_VERSION: this.language.ruby };
  }
};
