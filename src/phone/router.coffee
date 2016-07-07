define ['HeaderView', 'LocationListView', 'text!info_window.html', 'backbone'], ( Header, LocationList, InfoWindowTemplate ) ->
  Backbone.Router.extend
    Google_API_KEY: 'AIzaSyB0cV8zMYlRl3W9mNrsdsjqR5B6uMEdpbg'

    error: (err) ->
      console.warn( err )

    initialize:  ->
      dat = @
      @setMapDimensions( )
      @geocoder = new google.maps.Geocoder( )

      @header = new Header { el: $( '.header-view' ) }
      @header.on 'error', @error
      @header.on 'search', @geocodeFromAddress, @
      @header.on 'setResultsDisplay', @setDisplay, @

      @locations = new Backbone.Collection
      @locationList = new LocationList { el: $( '.location-list' ), collection: @locations }
      @locations.on 'add', ( place ) ->
        dat.createMarker place

      @locationList.on 'error', @error

      if !!navigator.geolocation
        @getCurrentLocation @initMap, @error
      else
        console.warn 'geolocation IS NOT available'

    initMap: ( position ) ->
      @center = {
        lat: position.coords.latitude,
        lng: position.coords.longitude
      }
      @createMapAndStartSearch( )

    createMapAndStartSearch: ->
      @createMap( )
      @createCurrentLocationMarker( )
      @searchDonuts( )

    geocodeFromAddress: ( address ) ->
      dat = @
      @geocoder.geocode { address: address }, ( results, status ) ->
        if status == google.maps.GeocoderStatus.OK
          center = {
            lat: results[0].geometry.location.lat(),
            lng: results[0].geometry.location.lng()
          }
          dat.center = center
          dat.createMapAndStartSearch( )

    buildMapMarkersAndList: ( results ) ->
      dat = @

    setMapDimensions: ->
      headerHeight = $( 'header' ).outerHeight( )
      windowHeight  = window.innerHeight
      $( '#map-canvas' ).css( 'height', windowHeight - headerHeight )

    routes:
      'list': 'showList'
      '*default': 'showMap'

    setDisplay: ( displayType ) ->
      if displayType == 'map'
        @showMap( )
      else if displayType == 'list'
        @showList( )
      else
        @error 'Router.setResultsDisplay was called with invalid display type: ' + displayType

    showMap: ->
      $('.location-list').removeClass 'active'
      $('#map-canvas').addClass 'active'
      @header.setDisplay 'map'

    showList: ->
      $('#map-canvas').removeClass 'active'
      $('.location-list').addClass 'active'
      @header.setDisplay 'list'


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
        dat.deleteDefaultMarkerUI( )

    searchDonuts: ->
      dat = @
      $.ajax
        url: '/search'
        data:
          ll: @center.lat + ',' + @center.lng
          category_filter: 'donuts'
        dataType: 'json'
        success: ( results ) ->
          dat.locations.reset( )
          dat.locations.add results
        error: ( e ) ->
          console.error e

    deleteDefaultMarkerUI: ->
      iwOuter = $('.gm-style-iw')
      iwBackground = iwOuter.prev()
      iwBackground.children(':nth-child(2)').css( {'display' : 'none'} )
      iwBackground.children(':nth-child(4)').css( {'display' : 'none'} )
      iwBackground.children(':nth-child(3)').find('div').children().css( {
      'display': 'none'
      } )
      iwCloseBtn = iwOuter.next()
      $(iwCloseBtn).addClass 'default-close-button'

    createMarker: ( place ) ->
      dat = @
      placeLoc = place.get( 'location' ).coordinate
      marker = new google.maps.Marker {
        map: @map,
        position: {
          lat: placeLoc.latitude,
          lng: placeLoc.longitude
        }
        icon: '/images/donut_icon.png'
      }

      google.maps.event.addListener marker, 'click', ->
        dat.infowindow.setContent _.template( InfoWindowTemplate )( model: place )
        dat.infowindow.open dat.map, @
        dat.deleteDefaultMarkerUI( )

