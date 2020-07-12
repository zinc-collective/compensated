const fs = require("fs");
const { execSync } = require("child_process");
const { v4: uuidv4 } = require("uuid");

/*
 * A Sandbox lets us create and destroy our testing environment
 * programmatically. At present, Compensated is a command-line
 * program, so the sandbox is going to be a local directory on
 * the filesystem that we can dump temporary files in.
 */
module.exports = class ClientSandbox {
  constructor(paymentGateway) {
    this.paymentGateway = paymentGateway;
    this.runId = uuidv4();

    this.createTempDirectory();

    this.createFileSync("Gemfile", gemfileTemplate);
    this.executeSync("bundle");
  }

  /*
   * The location where the Sandbox stores any files useful at runtime
   */
  get temporaryDirectory() {
    return `${sandboxDir}/${this.paymentGateway}-${this.runId}`;
  }

  /*
   * Create a file in the test sandbox synchronously.
   */
  createFileSync(fileName, contents) {
    return fs.writeFileSync(`${this.temporaryDirectory}/${fileName}`, contents);
  }

  /*
   * Create a file in the test sandbox synchronously.
   */
  executeSync(command) {
    return execSync(command, { cwd: this.temporaryDirectory });
  }

  createTempDirectory() {
    if (!fs.existsSync(this.temporaryDirectory)) {
      fs.mkdirSync(this.temporaryDirectory);
    }
  }
};

// Location to store sandbox files
const sandboxDir = "./tmp";
if (!fs.existsSync(sandboxDir)) {
  fs.mkdirSync(sandboxDir);
}

// Default gemfile for the compensated sandbox
const gemfileTemplate = `
source "https://rubygems.org"
gem "compensated", path: "../../compensated-ruby"
`;
