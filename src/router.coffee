define ['scripts/api_methods', 'views/Header/view', 'views/Menu/view', 'views/LocationList/view', 'text!views/InfoWindow/template.html', 'text!views/InfoWindow/you_are_here.html', 'backbone'], ( APIMethods, Header, Menu, LocationList, InfoWindowTemplate, YouAreHereTemplate ) ->
  Backbone.Router.extend
    Google_API_KEY: 'AIzaSyB0cV8zMYlRl3W9mNrsdsjqR5B6uMEdpbg'

    error: (err) ->
      console.warn( err )

    initialize:  ->
      dat = @
      @center = { }
      @setMapDimensions( )
      @geocoder = new google.maps.Geocoder( )
      @header = new Header { el: $( '.header-view' ) }
      @menu = new Menu { el: $('.menu') }
      @locations = new Backbone.Collection
      @locationList = new LocationList { el: $( '.location-list' ), collection: @locations, center: @center }

      @locations.on 'add', ( place ) ->
        dat.createMarker place
      @locationList.on 'error', @error

      @header.on 'error', @error
      @header.on 'search', (address) ->
        APIMethods.geocodeFromAddress( @geocoder, address, ( results ) ->
          center = {
            lat: results[0].geometry.location.lat(),
            lng: results[0].geometry.location.lng()
          }
          dat.createMapAndStartSearch( center )
        )
      , @
      @header.on 'setResultsDisplay', @setDisplay, @
      @header.on 'openMenu', ->
        dat.menu.open( )

      if !!navigator.geolocation
        APIMethods.getCurrentLocation ( position ) ->
          center = {
            lat: position.coords.latitude
            lng: position.coords.longitude
          }
          dat.createMapAndStartSearch( center )
        , @error
      else
        console.warn 'geolocation IS NOT available'

    createMapAndStartSearch: ( center ) ->
      @center = center
      @createMap( )
      @createCurrentLocationMarker( )
      @searchDonuts( )

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

    createMap: ->
      dat = @
      @map = new google.maps.Map document.getElementById('map-canvas'), {
        center: @center,
        zoom: 13,
        disableDefaultUI: true
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
        dat.infowindow.setContent _.template( YouAreHereTemplate )( )
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
        dat.infowindow.setContent _.template( InfoWindowTemplate )( model: place, center: dat.center )
        dat.infowindow.open dat.map, @
        dat.deleteDefaultMarkerUI( )

