class window.LocationManager
  geoCode: (address, cb) ->
    add_str = ''
    add_str += "#{address.street},%20" if address.street
    add_str += "#{address.city},%20#{address.state}%20" if address.city and address.state
    add_str += "#{address.zip}" if address.zip
    url = "http://maps.googleapis.com/maps/api/geocode/json?sensor=false&address=#{add_str}"
    $.get(url).done (data) ->
      result = data.results[0]
      return cb "No Results" if !result?

      cb null,
        lat: result.geometry.location.lat
        lon: result.geometry.location.lng
        address: address

  reverseGeoCode: (lat, lng, cb) ->
    geocoder = new google.maps.Geocoder
    latLng = new google.maps.LatLng 1*lat, 1*lng

    geocoder.geocode
      latLng: latLng
      , (results, status) ->
        if status == google.maps.GeocoderStatus.OK
          result = results[0]

          # TODO: Handle no results

          findComponent = (key, returnname='long_name') ->
            winner = _.find result.address_components, (component) ->
              component.types.indexOf(key) != -1
            if winner? then winner[returnname] else null

          zip = findComponent 'postal_code'
          city = findComponent('sublocality') || findComponent('locality')
          state = findComponent 'administrative_area_level_1', 'short_name'

          cb null, 
            zip:    zip
            city:   city
            state:  state
        else
          # Return blank data, log error
