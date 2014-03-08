{Module}= require 'di'
localConfig= require './package'

#
# Awesome Profiles API
#
# @author Michael F <tehfreak@awesome39.com>
#
module.exports= class ProfilesApi extends Module

    constructor: ->
        super





        #
        # Api Profiles Handler
        #
        @factory 'ApiProfiles', require './handlers/Api/V1/Profiles'



        #
        # Api Profiles Accounts Handler
        #
        @factory 'ApiProfilesAccounts', require './handlers/Api/V1/ProfilesAccounts'



    #
    # Initialize module with injector.
    #
    # @public
    #
    init: (app, db, ApiProfiles, ApiProfilesAccounts) ->

        app.use '/api/v1/users', new ApiProfiles

        app.use '/api/v1/users', new ApiProfilesAccounts
