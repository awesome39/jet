module.exports= (App, Account, AccountGithub, $audit, $authenticate, $authorize, db, log) ->
    class ProfilesAccountsApi extends App

        constructor: () ->
            app= super



            app.set 'log', log= log.namespace '[ProfilesAccountsApi]'



            app.get '/:userId(\\d+)/accounts'
            ,   $authenticate('user')
            ,   $authorize('profiles.accounts.select.github')
            ,   $audit('Get personal information')
            ,   (req, res) ->
                    res.json
                        accounts: true



            ###
            Отдает указанного пользователя.
            ###
            app.get '/:userId(\\d+)/accounts/github'
            ,   $authenticate('user')
            ,   $authorize('profiles.accounts.select.github')
            ,   $audit('Get personal information')

            ,   ProfilesAccountsApi.queryAccountGithub('userId')

            ,   (req, res, next) ->
                    try
                        req.accounts (accounts) ->
                                log 'selected profile accounts resolved', accounts
                                res.json accounts
                        ,   (err) ->
                                log 'selected profile accounts rejected', err
                                next err
                    catch err
                        next new ProfilesAccountsApiError

            return app



        @queryAccountGithub: (paramProfileId) -> (req, res, next) ->
            query= req.query

            req.accounts= AccountGithub.query { id:req.param paramProfileId }, query, req.maria
            req.accounts (accounts) ->
                    res.accounts= accounts
                    next()
            ,   (err) ->
                    next(err)







class ProfilesAccountsApiError extends Error

    constructor: (message= 'Awesome Profiles Accounts API Error') ->
        @message= message
