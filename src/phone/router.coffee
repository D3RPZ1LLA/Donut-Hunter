define ['LocationListView', 'backbone'], ( LocationList ) ->
  Backbone.Router.extend
    Google_API_KEY: 'AIzaSyB0cV8zMYlRl3W9mNrsdsjqR5B6uMEdpbg'

    error: (err) ->
      console.warn('ERROR(' + err.code + '): ' + err.message)

    initialize:  ->
      @locationList = new LocationList { el: $( '.location-list' ) }
      if !!navigator.geolocation
        @getCurrentLocation @createMapAndStartSearch, @error
      else
        console.warn 'geolocation IS NOT available'

    createMapAndStartSearch: ( position ) ->
      radius = 5000
      @center = {
        lat: position.coords.latitude,
        lng: position.coords.longitude
      }
      @createMap( )
      @searchDonutsByRadius radius, @buildMapMarkersAndList
      @createCurrentLocationMarker( )

    buildMapMarkersAndList: ( results, status ) ->
      dat = @
      # console.log results[0].photos[0].getUrl({ maxWidth: 200})

      if status == google.maps.places.PlacesServiceStatus.OK
        service = new google.maps.places.PlacesService @map

        for i in [ 0...results.length ]
          service.getDetails {
            placeId: results[ i ].place_id
          }, ( place, status ) ->
              if status == google.maps.places.PlacesServiceStatus.OK
                dat.createMarker place
                dat.createListItem place

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

    createMap: ->
      dat = @
      @map = new google.maps.Map document.getElementById('map-canvas'), {
        center: @center,
        zoom: 14
      }
      @infowindow = new google.maps.InfoWindow( )

    createCurrentLocationMarker: ->
      marker = new google.maps.Marker {
        map: @map,
        position: @center,
        icon: '/images/donut_hunter_bust.png'
      }

      dat = @
      google.maps.event.addListener marker, 'click', ->
        dat.infowindow.setContent "You are here !"
        dat.infowindow.open dat.map, @

    searchDonutsByRadius: ( radius, callback ) ->
      service = new google.maps.places.PlacesService( @map )

      service.nearbySearch {
        key: @Google_API_KEY,
        location: @center,
        radius: radius,
        keyword: [ 'donuts' ]
      }, callback.bind( @ )

    createMarker: ( place ) ->
      dat = @
      placeLoc = place.geometry.location
      marker = new google.maps.Marker {
        map: @map,
        position: place.geometry.location,
        icon: '/images/donut_icon.png'
      }

      google.maps.event.addListener marker, 'click', ->
        dat.infowindow.setContent place.name
        dat.infowindow.open dat.map, @

    createListItem: ( place ) ->
      @locationList.addLocation place
