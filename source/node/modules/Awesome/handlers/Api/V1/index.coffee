module.exports= (App, Account, AccountGithub, Group, Profile, ProfileSession, auth, log) ->
    class AwesomeApi extends App



        @loadProfile: () -> (req, res, next) ->

            hrtime= do process.hrtime
            req.time=
                start: (hrtime[0] * 1e9 + hrtime[1])

            if req.isAuthenticated()
                profileId= req.account.profileId or 1
                req.profile= Profile.getByIdFromRedis profileId, req.redis
                req.profile (profile) ->

                        hrtime= do process.hrtime
                        req.time.end= (hrtime[0] * 1e9 + hrtime[1])
                        #log 'resoled from redis', profile.id, (req.time.end - req.time.start) / 1e6 , 'ms'

                        profile= null # КЕШ ВЫКЛЮЧЕН

                        if not profile
                            req.profile= Profile.getById profileId, req.maria
                            req.profile (profile) ->
                                    log 'resoled from maria', profile.id
                                    if not profile
                                        res.profile= profile
                                        req.user= res.profile # LEGACY
                                        next()
                                    else
                                        req.profile= Profile.cacheIntoRedis profile, req.redis
                                        req.profile (profile) ->
                                                log 'cached profile resolved', profile.id
                                                res.profile= profile
                                                req.user= res.profile # LEGACY
                                                next()
                                        ,   (err) ->
                                                log 'cached profile rejected', err
                                                res.profile= profile
                                                req.user= res.profile # LEGACY
                                                next()
                            ,   (err) ->
                                    next(err)
                        else
                            res.profile= profile
                            req.user= res.profile # LEGACY
                            next()
                ,   (err) ->
                        next(err)
            else
                req.profile= Profile.getByName 'anonymous', req.maria
                req.profile (profile) ->
                        res.profile= profile
                        req.user= res.profile # LEGACY
                        next()
                ,   (err) ->
                        next(err)



        @loadProfileSessions: (param) -> (req, res, next) ->
            profileId= req.param param

            req.profile= {}
            req.profile.sessions= ProfileSession.queryMaria profileId, req.query, req.maria
            req.profile.sessions (sessions) ->
                    res.sessions= sessions
                    next()
            ,   (err) ->
                    res.errors.push res.error= err
                    next(err)



        @authUser: () -> (req, res, next) ->
            log 'AUTH LOCAL', req.body
            handler= auth.authenticate 'local', (err, account) ->
                log 'AUTH LOCAL', arguments
                if not account
                    return res.json 400, account
                account= Account.auth account, req.maria
                account (account) ->
                    if not account
                        return res.json 400, account
                    req.login account, (err) ->
                        headers= JSON.stringify
                            'referer': req.headers['referer']
                            'user-agent': req.headers['user-agent']
                            'accept': req.headers['accept']
                            'accept-encoding': req.headers['accept-encoding']
                            'accept-language': req.headers['accept-language']
                        session= ProfileSession.insertMaria req.account.profileId, req.sessionID, req.ip, headers, req.maria
                        session (session) ->
                                res.redirect '/'
                        ,   (err) ->
                                do req.logout
                                next err
            return handler req, res, next



        @authUserGithub: () -> (req, res, next) ->
            handler= auth.authenticate 'github', (err, account) ->
                account= AccountGithub.auth account, req.maria
                account (account) ->
                    if not account
                        res.json 400, account
                    else
                        req.login account, (err) ->
                            next err
            handler req, res, next



        @queryProfile: () -> (req, res, next) ->
            query= req.query
            req.profiles= Profile.query query, req.maria
            req.profiles (profiles) ->
                    res.profiles= profiles
                    next()
            ,   (err) ->
                    next(err)



        @getProfile: (param) -> (req, res, next) ->
            profileId= req.param param
            req.profile= Profile.getById profileId, req.maria
            req.profile (profile) ->
                    res.profile= profile
                    next()
            ,   (err) ->
                    next(err)



        @createProfile: () -> (req, res, next) ->
            req.profile= Profile.create req.body, req.maria
            req.profile (profile) ->
                    res.profile= profile
                    next()
            ,   (err) ->
                    next(err)

        @createProfileEmails: () -> (req, res, next) ->
            req.profile (profile) ->
                req.profile.emails= Profile.createEmails profile.id, req.body.emails or [], req.maria
                req.profile.emails (emails) ->
                        res.profile.emails= emails
                        next()
                ,   (err) ->
                        next(err)

        @createProfilePhones: () -> (req, res, next) ->
            req.profile (profile) ->
                req.profile.phones= Profile.createPhones profile.id, req.body.phones or [], req.maria
                req.profile.phones (phones) ->
                        res.profile.phones= phones
                        next()
                ,   (err) ->
                        next(err)



        @updateProfile: (paramProfileId) -> (req, res, next) ->
            profileId= req.param paramProfileId
            req.profile= Profile.update profileId, req.body, req.maria
            req.profile (profile) ->
                    res.profile= profile
                    next()
            ,   (err) ->
                    next(err)

        @updateProfileEmails: () -> (req, res, next) ->
            req.profile (profile) ->
                    req.profile.emails= Profile.updateEmails profile, req.body.emails or [], req.maria
                    req.profile.emails (emails) ->
                            profile.emails= emails
                            next()
                    ,   (err) ->
                            next(err)

        @updateProfilePhones: () -> (req, res, next) ->
            req.profile (profile) ->
                    req.profile.phones= Profile.updatePhones profile, req.body.phones or [], req.maria
                    req.profile.phones (phones) ->
                            profile.phones= phones
                            next()
                    ,   (err) ->
                            next(err)



        @deleteProfile: (paramProfileId) -> (req, res, next) ->
            profileId= req.param paramProfileId
            req.profile= Profile.delete profileId, req.maria
            req.profile (profile) ->
                    res.profile= profile
                    next()
            ,   (err) ->
                    if err instanceof Profile.delete.BadValueError then res.status 400
                    if err instanceof Profile.delete.NotFoundError then res.status 404
                    next(err)



        @enableProfile: (paramProfileId) -> (req, res, next) ->
            profileId= req.param paramProfileId
            req.profile= Profile.enable profileId, req.body.enabled, req.maria
            req.profile (profile) ->
                    res.profile= profile
                    next()
            ,   (err) ->
                    if err instanceof Profile.enable.BadValueError then res.status 400
                    if err instanceof Profile.enable.NotFoundError then res.status 404
                    next(err)



        @queryGroup: () -> (req, res, next) ->
            query= req.query

            req.groups= Group.query query, req.maria
            req.groups (groups) ->
                    res.groups= groups
            ,   (err) ->
                    res.errors.push res.error= err

            do next



        @updateAccount: () -> (req, res, next) ->
            accountId= req.user.id

            req.account= Account.update accountId, req.body, req.maria
            req.account (account) ->
                    res.account= account
            ,   (err) ->
                    res.errors.push res.error= err

            do next
