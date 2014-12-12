var port = process.env.PORT || 3000
  , app = require('express')()
  , server = require('http').Server(app);
  

server.listen(port);
console.log('\nϟϟϟ Serving on port ' + port + ' ϟϟϟ\n');

app.get('/', function (req, res) {
  res.sendfile('dist/index.html');
});

app.get('/*' , function( req, res, next ) {
    var file = req.params[0];
    res.sendfile( __dirname + '/' + file );
});
