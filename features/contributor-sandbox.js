const { spawn } = require('child-process-promise')

module.exports = class DeveloperSandbox {
  constructor (language, project) {
    this.language = language
    this.project = project
  }

  async spawn (command) {
    const promise = spawn(command, [], {
      cwd: this.project,
      shell: true,
      capture: ['stdout', 'stderr'],
      env: { ...process.env, ...this.env }
    })

    try {
      return promise
    } catch (e) {
      return console.error(e.stdout, e.stderr, this.env)
    }
  }

  get env () {
    return { RBENV_VERSION: this.language.ruby }
  }
}
