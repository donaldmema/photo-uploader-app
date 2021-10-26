const fs = require("fs");

const express = require("express");

const bodyParser = require("body-parser");

const { StatusCodes } = require("http-status-codes");

const { showFileExplorer } = require("./showFileExplorer");

const app = express();
app.use(express.json({ limit: "50mb" }));

const port = 3000;

app.get("/", (req, res) => {
  return res.status(StatusCodes.OK).send("Hello World!");
});

app.post("/upload", (req, res) => {
  try {
    let realFile = Buffer.from(req.body.image, "base64");

    fs.writeFileSync(`./downloaded_images/${req.body.name}`, realFile, "utf8");

    showFileExplorer("./downloaded_images");

    res
      .status(StatusCodes.CREATED)
      .send({ message: "Image successfully saved on server" });
  } catch (e) {
    console.log(e);

    res
      .status(StatusCodes.INTERNAL_SERVER_ERROR)
      .send({ message: "You done goofed" });
  }
});

app.listen(port, () => console.log("Started on PORT 3000"));
