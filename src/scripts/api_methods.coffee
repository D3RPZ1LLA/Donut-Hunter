define [], ->
  {

    getCurrentLocation: ( callback, error ) ->
      options = {
        enableHighAccuracy: true,
        maximumAge: 0
      }
      navigator.geolocation.getCurrentPosition( callback.bind(@), error.bind(@), options)

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

    geocodeFromAddress: ( geocoder, address, callback ) ->
      geocoder.geocode { address: address }, ( results, status ) ->
        if status == google.maps.GeocoderStatus.OK
          callback( results )
  }
