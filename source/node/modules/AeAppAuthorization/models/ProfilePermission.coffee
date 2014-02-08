deferred= require 'deferred'

#
# Profile Permission Model Factory
#
# @author Michael F <tehfreak@awesome39.com>
#
module.exports= (Permission, log) -> class ProfilePermission extends Permission

    @table= 'profile_permission'

    @Permission: Permission



    constructor: (data) ->

        @id= data.id
        @profileId= data.profileId
        @permissionId= data.permissionId

        @value= data.value

        @enabledAt= data.enabledAt
        @updatedAt= data.updatedAt





    @createByName: (profileId, name, db) ->
        dfd= do deferred

        process.nextTick =>
            try

                if not profileId
                    throw new @createByName.BadValueError 'profileId cannot be null'

                if not name
                    throw new @createByName.BadValueError 'name cannot be null'


                db.query """
                    INSERT
                        ??
                    SET
                        profileId= ?,
                        permissionId= (
                            SELECT
                                Permission.id

                            FROM
                                ?? AS Permission

                            WHERE
                                Permission.name = ?
                        )
                    ;

                    SELECT
                        ProfilePermission.*

                    FROM
                        ?? AS ProfilePermission

                    WHERE
                        ProfilePermission.id= LAST_INSERT_ID()
                    """
                ,   [@table, profileId, @Permission.tablePermission, name, @table]
                ,   (err, res) =>
                        if err
                            throw new Error err

                        if res[0].affectedRows == 1 and res[1].length == 1
                            data= new @ res[1][0]
                            dfd.resolve data
                        else
                            throw new Error 'profile permission not created'

            catch err
                dfd.reject err

        dfd.promise

    @createByName.BadValueError= class CreateBadValueError extends Error
        constructor: (message) ->
            @message= message





    @enable: (id, enabled, db) ->
        dfd= do deferred

        process.nextTick =>
            try

                if not id
                    throw new @enable.BadValueError 'id cannot be null'


                enabled= enabled|0

                db.query """
                    UPDATE
                        ??
                       SET
                        enabledAt= IF(?, IF(enabledAt, enabledAt, NOW()), NULL)
                     WHERE
                        id= ?
                    ;
                    SELECT
                        enabledAt
                      FROM
                        ??
                     WHERE
                        id= ?
                    """
                ,   [@table, enabled, id, @table, id]
                ,   (err, res) =>
                        if err
                            throw new Error err

                        enabledAt= res[1][0].enabledAt
                        enabled= !!enabledAt
                        dfd.resolve
                            enabledAt: enabledAt
                            enabled: enabled

            catch err
                dfd.reject err

        dfd.promise

    @enable.BadValueError= class EnableBadValueError extends Error
        constructor: (message) ->
            @message= message

    @enable.NotFoundError= class EnableNotFoundError extends Error
        constructor: (message) ->
            @message= message
