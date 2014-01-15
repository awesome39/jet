module.exports= (log) -> class AutchenticateService

    constructor: () ->

        log= log.namespace '[AutchenticateService]'
        log do process.hrtime, 'Created.'



        authenticate= () ->
            log do process.hrtime, 'Created middleware.'

            (req, res, next) ->

                log 'Authenticate!'
                do next



        return authenticate
