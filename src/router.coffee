define [
  'backbone'
], () ->
  Backbone.Router.extend
    initialize: ->
      @$rootEl = $ '<main>'
      $('body').append @$rootEl

    routes:
      '*default': 'default'

    default: ->
