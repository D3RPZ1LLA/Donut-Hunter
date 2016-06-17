define [ 'text!location_view.html', 'backbone' ], ( template ) ->
  Backbone.View.extend
    className: 'donut-location'

    initialize: ->
      rating = Math.round( @model.get( 'rating' ) ) || 0
      @model.set 'rating', rating

      if !!@model.get( 'photos' )
        @photo = @model.get( 'photos')[0].getUrl( maxWidth: 140)
      else
        @photo = 'https://lh5.googleusercontent.com/-tOmyPlHHXF0/VsnunKXkrpI/AAAAAAAACaQ/MtodKeESfVgCbrKuDr_KXUKljDQ6Z-Mgw/w500-k/'

    render: ->
      @$el.html _.template( template )( attributes: @model.attributes, photo: @photo )
      rating = @model.get( 'rating' )
      window.derp = @$el.find( '.' + rating + '-stars' )
      @$el.find( '.' + rating + '-stars' ).addClass  'active'
      @
