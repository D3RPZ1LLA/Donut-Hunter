define [ 'LocationView', 'backbone' ], ( LocationView ) ->
  Backbone.View.extend

    initialize: ->
      dat = @
      @locationList = new Backbone.Collection
      @locationList.on 'add', ( location ) ->
        dat.render( location )

    addLocation: ( location ) ->
      @locationList.add new Backbone.Model location

    reset: ->
      @locationList.reset [ ]
      @$el.html ''

    render: ( location ) ->
      locationView = new LocationView { model: location }
      @$el.append locationView.render( ).$el
