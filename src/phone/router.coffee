define ['LocationListView', 'backbone'], ( LocationList ) ->
  Backbone.Router.extend
    error: (err) ->
      console.warn('ERROR(' + err.code + '): ' + err.message)

    initialize:  ->
      @locationList = new LocationList { el: $('body').find( '.location-list' ) }
      if !!navigator.geolocation
        @getCurrentLocation @createMapAndStartSearch, @error
      else
        console.warn 'geolocation IS NOT available'

    createMapAndStartSearch: ( position ) ->
      radius = 5000
      center = {
        lat: position.coords.latitude,
        lng: position.coords.longitude
      }
      @createMap center
      @searchDonutsByRadius center, radius, @buildMapMarkersAndList

    buildMapMarkersAndList: ( results, status ) ->
      if status == google.maps.places.PlacesServiceStatus.OK
        for i in [ 0...results.length ]
          @createMarker results[ i ]
          @createListItem results[ i ]

    routes:
      'list': 'list'
      'map': 'map'

    list: ->

    map: ->

    getCurrentLocation: ( callback, error ) ->
      options = {
        enableHighAccuracy: true,
        maximumAge: 0
      }
      navigator.geolocation.getCurrentPosition( callback.bind(@), error.bind(@), options)

    createMap: ( center ) ->
      dat = @
      @map = new google.maps.Map document.getElementById('map-canvas'), {
        center: center,
        zoom: 12
      }

    searchDonutsByRadius: ( center, radius, callback ) ->
      @infowindow = new google.maps.InfoWindow( )
      service = new google.maps.places.PlacesService( @map )
      service.nearbySearch {
        location: center,
        radius: radius,
        keyword: [ 'donuts' ]
      }, callback.bind( @ )

    createMarker: ( place ) ->
      dat = @
      placeLoc = place.geometry.location
      marker = new google.maps.Marker {
        map: @map,
        position: place.geometry.location
      }

      google.maps.event.addListener marker, 'click', ->
        dat.infowindow.setContent place.name
        dat.infowindow.open dat.map, @

    createListItem: ( place ) ->
      @locationList.addLocation place
