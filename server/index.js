const fs = require("fs");
const express = require("express");
const { StatusCodes } = require("http-status-codes");

const app = express();
const port = 3000;

app.post("/upload", (req, res) => {
  let realFile = Buffer.from(req.body.image, "base64");

  fs.writeFileSync(req.body.name, realFile, "utf8");

  res
    .status(StatusCodes.CREATED)
    .send({ message: "Image successfully saved on server" });
});

app.listen(port, () => console.log("Started on PORT 3000"));
