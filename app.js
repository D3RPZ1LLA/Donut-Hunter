var port = process.env.PORT || 3000
  , app = require('express')()
  , favicon = require('serve-favicon')
  , device = require('express-device')
  , server = require('http').Server(app);

var http = require('http');

app.use( device.capture() );

server.listen(port);
console.log('\nϟϟϟ Serving on port ' + port + ' ϟϟϟ\n');

app.get('/', function (req, res) {
  console.log(req.device.type)
  res.sendfile('dist/' + 'phone' + '/index.html');
});

/** OAuth Start **/

var CONSUMER_KEY = 'VjrUuxp296z6hJQQlgI3rA';
var CONSUMER_SECRET = '5qMPPiyphL699SQSOxxD-j0_saU';
var TOKEN = 'DtmWbmQ7pmm6E4Zu8t-ri47LmXQSavBb';
var TOKEN_SECRET = 'zczCW-TvwgEUhEbkkWwEprl_xsg';

var HttpMethod = 'GET';
var API_URL = 'https://api.yelp.com/v2/search/';
var DEFAULT_TERM = 'dinner';
var DEFAULT_LOCATION = 'San Francisco, CA';
var SEARCH_LIMIT = 3;

var hmacsha1 = require('hmacsha1');

// var OAuthToken = function ( token, secret ) {
//   this.token = token;
//   this.secret = secret;
// };

// var OAuthConsumer = function ( key, secret, callback_url ) {
//   this.key = key;
//   this.secret = secret;
// };

// signature is hmacsha1( httpMethod & API_URL &
// params_with%_and& sorted_by_lexicographical_byte_value;
// includes oauth params except signature )

// var oAuthToken = new OAuthToken( TOKEN, TOKEN_SECRET );

// var OAuthRequest = function ( http_method, url, parameters ) {
//   this.http_method = http_method;
//   this.url = url;
//   this.parameters = parameters;
//   this.version = '1.0'
// };

app.get('/test', function (req, res) {
  var timestamp = Math.floor( ( new Date() ).getTime() / 1000 ).toString( )
  var nouce = hmacsha1( TOKEN, timestamp );
  console.log( nouce );
  var options = {
    host: 'localhost',
    port: 3000,
    path: '/',
    method: 'GET',
    headers: {
        accept: 'application/html'
    }
  };
  var x = http.request(options,function(result){
      console.log("Connected");
      result.on('data',function(data){
          console.log(data);
          res.send( data)
      });
  });

  x.end();
});

/** OAuth End **/

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
