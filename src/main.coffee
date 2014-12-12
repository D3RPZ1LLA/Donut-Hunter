require.config
  paths:
    images: '../images/',
    text: '../vendor/text',
    marionette: '../node_modules/backbone.marionette/lib/backbone.marionette',
    backbone: '../node_modules/backbone/backbone',
    underscore: '../node_modules/underscore/underscore',
    jquery: '../node_modules/jquery/dist/jquery.min'

  shim:
    marionette:
      deps: ['backbone', 'underscore']
      exports: 'Marionette'
    backbone:
      deps: ['underscore', 'jquery']
      exports: 'Backbone'
    underscore:
      exports: '_'
    jquery:
      exports: '$'

define ['router', 'backbone'], (Router) ->
  new Router()
  Backbone.history.start()
