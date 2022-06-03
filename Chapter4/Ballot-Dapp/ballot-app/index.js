const express = require("express");
const app = express();
const port = 3000;
app.use(express.static("src"));
app.use(express.static("../ballot-contract/build/contracts"));
app.get("/", (req, res) => {
  res.render("index.html");
});

app.listen(port, () => {
  console.log("Listening...");
});
