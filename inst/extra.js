function getToken() {
    var ca = document.cookie.split(';')
    for(var i=0; i < ca.length; i++) {
        var c = $.trim(ca[i])
        if (c.indexOf('token=') === 0) {
            return decodeURIComponent(c.substring(6, c.length))
        }
    }
    return null
}

$(document).ready(function() {
    $("#token").val(getToken())
})

// $(document).on('shiny:connected', function(event) {
//     var token = getToken()
//     Shiny.onInputChange('token', token)
//     console.log("Token set")
// })
