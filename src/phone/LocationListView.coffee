define [ 'LocationView', 'backbone' ], ( LocationView ) ->
  Backbone.View.extend

    initialize: ->
      dat = @
      @collection.on 'add', ( location ) ->
        dat.render( location )
      @collection.on 'reset', ->
        dat.reset( )

    reset: ->
      @$el.html ''

    render: ( location ) ->
      locationView = new LocationView { model: location }
      @$el.append locationView.render( ).$el
