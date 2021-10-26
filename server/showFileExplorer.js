const showFileExplorer = (filePath) => {
  require("child_process").exec(`start ${process.cwd()}/${filePath}`);
};

exports.showFileExplorer = showFileExplorer;
