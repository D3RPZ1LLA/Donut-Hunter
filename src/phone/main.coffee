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
  new Router( )
  Backbone.history.start()
