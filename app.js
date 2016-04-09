var port = process.env.PORT || 3000
  , app = require('express')()
  , favicon = require('serve-favicon')
  , device = require('express-device')
  , server = require('http').Server(app);

app.use( device.capture() );

server.listen(port);
console.log('\nϟϟϟ Serving on port ' + port + ' ϟϟϟ\n');

app.get('/', function (req, res) {
  console.log(req.device.type)
  res.sendfile('dist/' + req.device.type + '/index.html');
});

app.get('/*' , function( req, res, next ) {
    console.log(req.device.type)
    console.log(req.originalUrl)
    var file = req.params[0];
    res.sendfile( __dirname + '/' + file );
});

// var port = process.env.PORT || 3000
//   , express = require('express')
//   , app = express()
//   , server = require('http').Server(app)
//   , qs = require( 'querystring' )
//   , favicon = require('serve-favicon')
//   , mailer = require('express-mailer')
//   , device = require('express-device');

// app.use(express.favicon('./assets/images/favicon.ico'));
// app.use( device.capture() );

// app.set('views', __dirname + '/src/templates');
// app.set('view engine', 'jade');


// app.get('/', function (req, res) {
//   device_path = req.device.type == 'desktop' ? 'desktop' : 'mobile'
//   res.sendfile( 'dist/pages/' + device_path + '/landing_page.html' );
// });
