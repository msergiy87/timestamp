var http = require("http");
var moment = require("moment");

var server = http.createServer(function(req, res) {

  var time = moment().unix()

  res.write("<p>" + time + "</p>");

  res.end();

}).listen(8081);
