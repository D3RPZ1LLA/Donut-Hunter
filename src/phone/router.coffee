define ['HeaderView', 'LocationListView', 'text!info_window.html', 'backbone'], ( Header, LocationList, InfoWindowTemplate ) ->
  Backbone.Router.extend
    Google_API_KEY: 'AIzaSyB0cV8zMYlRl3W9mNrsdsjqR5B6uMEdpbg'

    error: (err) ->
      console.warn('ERROR(' + err.code + '): ' + err.message)

    initialize:  ->
      @setMapDimensions( )
      @geocoder = new google.maps.Geocoder( )

      @header = new Header { el: $( '.header-view' ) }
      @header.on 'search', @geocodeFromAddress, @
      @locationList = new LocationList { el: $( '.location-list' ) }

      if !!navigator.geolocation
        @getCurrentLocation @initMap, @error
      else
        console.warn 'geolocation IS NOT available'

    initMap: ( position ) ->
      @createMapAndStartSearch {
        lat: position.coords.latitude,
        lng: position.coords.longitude
      }

    createMapAndStartSearch: ( center, radius ) ->
      @center = center
      radius ||= 5000
      @createMap( )
      @createCurrentLocationMarker( )
      @searchDonutsByRadius radius, @buildMapMarkersAndList

    geocodeFromAddress: ( address ) ->
      dat = @
      @geocoder.geocode { address: address }, ( results, status ) ->
        if status == google.maps.GeocoderStatus.OK
          center = {
            lat: results[0].geometry.location.lat(),
            lng: results[0].geometry.location.lng()
          }
          dat.createMapAndStartSearch( center )

    buildMapMarkersAndList: ( results, status ) ->
      dat = @

      if status == google.maps.places.PlacesServiceStatus.OK
        service = new google.maps.places.PlacesService @map

        for i in [ 0...results.length ]
          service.getDetails {
            placeId: results[ i ].place_id
          }, ( place, status ) ->
              if status == google.maps.places.PlacesServiceStatus.OK
                dat.createMarker place
                dat.createListItem place

    setMapDimensions: ->
      headerHeight = $( 'header' ).outerHeight( )
      windowHeight  = window.innerHeight
      $( '#map-canvas' ).css( 'height', windowHeight - headerHeight )

    routes:
      'list': 'list'
      '*default': 'map'

    list: ->
      $('#map-canvas').removeClass 'active'
      $('.location-list').addClass 'active'

    map: ->
      $('.location-list').removeClass 'active'
      $('#map-canvas').addClass 'active'
      @list()

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
        zoom: 13
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
        dat.infowindow.setContent _.template( InfoWindowTemplate )( place: place )
        dat.infowindow.open dat.map, @

    createListItem: ( place ) ->
      @locationList.addLocation place
