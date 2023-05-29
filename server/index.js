const express = require("express");
var getIP = require("ipware")().get_ip;

const app = express();
app.use(express.json());
const port = 4001;

app.post("/oddity", (req, res) => {
  var ts = new Date();
  console.log(
    "POST: " +
      ts.getMonth() +
      "/" +
      ts.getDate() +
      "-" +
      ts.getHours() +
      ":" +
      ts.getMinutes() +
      ":" +
      ts.getSeconds(),
    req.body,
    ", IP:",
    getIP(req).clientIp.replace("::ffff:", "")
  );
  res.send("OK");
});

app.listen(port, () => console.log(`The server is listening on port ${port}`));
