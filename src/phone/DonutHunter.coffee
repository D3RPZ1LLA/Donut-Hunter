define [ 'backbone' ], () ->
  Backbone.View.extend
    API_KEY: 'AIzaSyDv_insHb8qwr4qDAaTZRikfoAi9Kbm_Ck'

    initialize: ->
      return
      @findDonuts()
      dat = @
      if navigator.geolocation && false
        @renderButton()

      else
        @renderInput()

    renderButton: ->

    findGeolocateDonuts: ->
      navigator.geolocation.getCurrentPosition( ( position ) ->
        dat.findDonuts( {
            lat: position.coords.latitude,
            lng: position.coords.longitude
          } )
      , ( err ) ->
        console.warn( 'ERROR(' + err.code + '): ' + err.message )
      )

    renderInput: ->
      $( '#current_text' ).removeClass( 'invisible' )
      $( '#input' ).removeClass( 'invisible' )

    events:
      'submit form': 'findNearbyDonuts'

    findNearbyDonuts: ( e ) ->
      dat = @
      e.preventDefault( )

      mapsQueryStr =  'address=' + ( $( '#current' ).val() ).replace( /\s/, '+' )
      console.log mapsQueryStr
      $.ajax {
        type: 'GET'
        url: 'https://maps.googleapis.com/maps/api/geocode/json?' + mapsQueryStr,
        dataType: 'json',
        success: ( resp ) ->
          if resp.status == google.maps.places.PlacesServiceStatus.OK
            dat.findDonuts resp.results[0].geometry.location
          else
            console.error 'geocode fail'
      }

    findDonuts: ( center ) ->
      @createMap( center || {lat: 40.7537947, lng: -73.9936639} )

    createMap: ( center ) ->
      dat = @
      @map = new google.maps.Map document.getElementById('map-canvas'), {
        center: center,
        zoom: 13
      }

      @infowindow = new google.maps.InfoWindow( )
      service = new google.maps.places.PlacesService( @map )
      service.nearbySearch {
        location: center,
        radius: 1800,
        keyword: [ 'donuts' ]
      }, ( results, status ) ->
        window.derp = results
        dat.mapDonuts( results, status )

    mapDonuts: ( results, status ) ->
      if status == google.maps.places.PlacesServiceStatus.OK
        for i in [ 0...results.length ]
          @createMarker results[ i ]

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
