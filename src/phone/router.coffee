define ['backbone'], (  ) ->
  Backbone.Router.extend

    initialize:  ->

    routes:
      '': 'derp'
      '*default': 'default'

    derp: ->

    default: ->
      @setView( 'default', DefaultAdminView )
