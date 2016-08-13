require.config
  paths:
    images: '../../assets/images',
    text: '../../vendor/text',
    backbone: '../../node_modules/backbone/backbone',
    underscore: '../../node_modules/underscore/underscore',
    jquery: '../../node_modules/jquery/dist/jquery.min'

  shim:
    backbone:
      deps: ['underscore', 'jquery']
      exports: 'Backbone'
    underscore:
      exports: '_'
    jquery:
      exports: '$'

define ['router', 'backbone'], ( Router ) ->
  if window.location.hostname != "localhost" && !window.location.href.match(/https/)
    window.location = 'https://donut-hunter.herokuapp.com' + window.location.pathname
  else
    new Router( )
    Backbone.history.start()
