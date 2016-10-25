var port = process.env.PORT || 3000
  , app = require('express')()
  , favicon = require('serve-favicon')
  , device = require('express-device')
  , server = require('http').Server(app)
  , yelp = require("node-yelp");

var yelpClient = yelp.createClient({
  oauth: {
    "consumer_key": 'VjrUuxp296z6hJQQlgI3rA',
    "consumer_secret": '5qMPPiyphL699SQSOxxD-j0_saU',
    "token": 'DtmWbmQ7pmm6E4Zu8t-ri47LmXQSavBb',
    "token_secret": 'zczCW-TvwgEUhEbkkWwEprl_xsg'
  },

  // Optional settings:
  httpClient: {
    maxSockets: 25  // ~> Default is 10
  }
});

app.use( device.capture() );

server.listen(port);
console.log('\nϟϟϟ Serving on port ' + port + ' ϟϟϟ\n');

app.get('/', function (req, res) {
  res.sendfile('dist/index.html');
});

app.get('/mobile-demo', function (req, res) {
  res.sendfile( 'dist/mobile_demo.html');
});

app.get('/search', function (req, res) {
  yelpClient.search( req.query ).then(function (data) {
    var businesses = data.businesses;
    res.send( data.businesses );
  });
});

app.get('/*' , function( req, res, next ) {
    var file = req.params[0];
    res.sendfile( __dirname + '/' + file );
});
