extend= require 'extend'



module.exports= (log) -> class ConfigJoinService

    constructor: ->

        log= log.namespace '[ConfigJoinService]'



        join= (primary, secondary, env) ->
            out= {}

            extend true, out, secondary.default or {}

            if secondary[env]
                extend true, out, secondary[env]

            extend true, out, primary


            out



        return join
