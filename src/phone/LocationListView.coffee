define [ 'LocationView', 'text!location_view.html', 'backbone' ], ( LocationView, template ) ->
  Backbone.View.extend

    initialize: ->
      console.log @el

    addLocation: ( place ) ->
      console.log place
