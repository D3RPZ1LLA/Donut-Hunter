define [ 'views/Location/view', 'backbone' ], ( LocationView ) ->
  Backbone.View.extend

    initialize: ( options ) ->
      dat = @
      @center = options.center

      @collection.on 'add', ( location ) ->
        dat.render( location )
      @collection.on 'reset', ->
        dat.reset( )

    reset: ->
      @$el.html ''

    render: ( location ) ->
      locationView = new LocationView { model: location, center: @center }
      @$el.append locationView.render( ).$el
