deferred= require 'deferred'

module.exports= (Account, log) -> class AccountGithub extends Account
    @table: 'user_account_github'



    constructor: (data) ->
        @id= data.id
        @userId= data.userId
        @provider= 'github'
        @providerId= data.providerId
        @providerName= data.providerName



    @auth: (account, db, done) ->
        dfd= do deferred

        err= null
        if not account
            dfd.reject err= Error 'account is not be null'

        if done and err
            return process.nextTick ->
                done err, account

        db.query "
            SELECT
                Account.*
              FROM
                ?? as Account
             WHERE
                Account.providerId= ?
            "
        ,   [@table, account.providerId]
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



    @get: (id, db, done) ->
        account= null

        log 'найти аккаунт гитхабера', id

        dfd= do deferred

        setTimeout =>

            account= accounts[id]

            dfd.resolve account
            if done instanceof Function
                process.nextTick ->
                    done null, accounts

        ,   1023

        dfd.promise
