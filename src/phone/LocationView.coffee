define [ 'text!location_view.html', 'backbone' ], ( template ) ->
  Backbone.View.extend
    className: 'donut-location'

    initialize: ( options ) ->
      @center = options.center

    render: ->
      @$el.html _.template( template )( model: @model, center: @center )
      @
