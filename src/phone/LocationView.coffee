define [ 'text!location_view.html', 'backbone' ], ( template ) ->
  Backbone.View.extend
    className: 'donut-location'

    render: ->
      @$el.html _.template( template )( model: @model )
      @
