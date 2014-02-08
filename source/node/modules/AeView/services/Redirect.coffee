#
# Authenticate Service Factory
#
# @author Michael F <tehfreak@awesome39.com>
#
module.exports= (log) -> class RedirectService

    constructor: ->

        log= log.namespace '[RedirectService]'



        check= (there) ->
            log do process.hrtime, 'Created middleware.'

            (req, res) ->
                res.redirect there


        return check
