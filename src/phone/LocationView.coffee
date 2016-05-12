define [ 'text!location_view.html', 'backbone' ], ( template ) ->
  Backbone.View.extend
    className: 'donut-location'

    initialize: ->
      if !!@model.get( 'photos')
        photo = @model.get( 'photos')[0].getUrl( maxWidth: 500)
      else
        photo = '/images/donut_medium.png'
        # http://orig03.deviantart.net/af88/f/2015/046/9/9/donut_cartoon_by_thegoldenbox-d8i3l4q.png

      @$el.html _.template( template )( attributes: @model.attributes, photo: photo )
