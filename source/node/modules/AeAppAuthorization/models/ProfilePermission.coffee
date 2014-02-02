deferred= require 'deferred'

#
# Profile Permission Model Factory
#
# @author Michael F <tehfreak@awesome39.com>
#
module.exports= (Permission, log) -> class ProfilePermission extends Permission

    @table= 'profile_permission'

    @Permission: Permission
