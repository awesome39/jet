module.exports= (log) -> class AuditService

    constructor: () ->

        log= log.namespace '[AuditService]'
        log 'Created.', do process.hrtime



        audit= (something) ->
            log 'Created middleware.', do process.hrtime

            (req, res, next) ->

                log 'Audit It!', something
                do next



        audit.sign= (something) ->

            return if not something



        @constructor.prototype.__proto__= audit.__proto__
        audit.__proto__= AuditService.prototype

        return audit

