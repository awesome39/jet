deferred= require 'deferred'
crypto= require 'crypto'

#
# Account Model Factory
#
# @author Michael F <tehfreak@awesome39.com>
#
module.exports= (log) -> class Account

    @table: 'profile_account'



    constructor: (data) ->

        @id= data.id
        @profileId= data.profileId
        @name= data.name
        @pass= data.pass



    @serialize: (account, db, done) ->
        log 'serialize account', account
        done null, account

    @deserialize: (account, db, done) ->
        log 'deserialize account', account
        done null, account



    @auth: (account, db, done) ->
        dfd= do deferred

        err= null
        if not account
            err= Error 'account cannot be null'
        if not account.name or not account.pass
            err= Error 'account credentials cannot be null'

        if err
            if done
                process.nextTick ->
                    done err, account
            return dfd.reject err

        db.query "
            SELECT
                Account.*
              FROM
                ?? as Account
             WHERE
                Account.name= ?
               AND
                Account.pass= ?
            "
        ,   [@table, account.name, account.pass]
        ,   (err, rows) =>
                account= null

                if not err
                    if rows.length
                        account= new @ rows.shift()
                    dfd.resolve account
                else
                    dfd.reject err

                if done instanceof Function
                    process.nextTick ->
                        done err, account

        dfd.promise





    @create: (profileId, data, db, done) ->
        dfd= do deferred

        process.nextTick =>
            try

                if not profileId
                    throw new @create.BadValueError 'profileId cannot be null'

                if not data
                    throw new @create.BadValueError 'data cannot be null'

                data= new @ data
                data.pass= @sha1 data.pass

                db.query """
                    INSERT
                        ??
                    SET
                        profileId= ?,
                        name= ?,
                        pass= ?
                    ;

                    SELECT
                        Account.*

                    FROM
                        ?? AS Account

                    WHERE
                        Account.id= LAST_INSERT_ID()
                    """
                ,   [@table, profileId, data.name, data.pass, @table]
                ,   (err, res) =>
                        if not err
                            if res[0].affectedRows == 1 and res[1].length == 1
                                data= new @ res[1][0]
                                dfd.resolve data
                            else
                                throw new Error 'account not created'
                        else
                            dfd.reject err

            catch err
                dfd.reject err

        dfd.promise

    @create.BadValueError= class CreateBadValueError extends Error
        constructor: (message) ->
            @message= message





    @query: (query, db, done) ->
        accounts= []

        dfd= do deferred

        setTimeout =>

            dfd.resolve accounts
            if done instanceof Function
                process.nextTick ->
                    done null, accounts

        ,   1023

        dfd.promise



    @get: (id, db, done) ->
        dfd= do deferred

        account= null
        process.nextTick =>

            try
                if not id
                    throw new @get.BadValueError 'id cannot be null'


                db.query """
                    SELECT
                        Account.*

                    FROM
                        ?? AS Account

                    WHERE
                        Account.id = ?
                    """
                ,   [@table, id]
                ,   (err, rows) =>

                        if not err and rows.length == 0
                            throw new @get.NotFoundError 'account not found'

                        if err
                            throw new Error err

                        account= new @ rows.shift()
                        dfd.resolve account

            catch err
                dfd.reject err

        dfd.promise

    @get.BadValueError= class GetByIdBadValueError extends Error
        constructor: (message) ->
            @message= message

    @get.NotFoundError= class GetByIdNotFoundError extends Error
        constructor: (message) ->
            @message= message





    @update: (id, data, db, done) ->
        dfd= do deferred

        err= null
        if not id
            err= Error 'id cannot be null'

        if not data
            err= Error 'data cannot be null'

        oldPass= @sha1 data.oldPass
        data= @filterDataForUpdate data

        if err
            dfd.reject err
            if done and err
                process.nextTick ->
                    done err
        if not err
            db.query "
                UPDATE
                    ??
                   SET
                    ?
                 WHERE
                    id= ?
                   AND
                    pass= ?
                "
            ,   [@table, data, id, oldPass]
            ,   (err, res) =>

                    if not err
                        if res.affectedRows == 1
                            dfd.resolve data
                        else
                            dfd.reject err
                    else
                        dfd.reject err

                    if done instanceof Function
                        process.nextTick ->
                            done err, data

        dfd.promise

    @filterDataForUpdate: (data) ->
        data=
            pass: @sha1 data.pass



    @sha1: (pass) ->
        sha1= crypto.createHash 'sha1'
        sha1.update pass
        sha1.digest 'hex'
