define [ 'LocationView', 'backbone' ], ( LocationView ) ->
  Backbone.View.extend

    initialize: ->
      @locationList = [ ]

    addLocation: ( place ) ->
      model = new Backbone.Model place
      locationView = new LocationView { model: model }
      @locationList.push locationView
      @$el.append locationView.$el
