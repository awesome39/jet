app= angular.module 'engine'
,   ['engine.users', 'ngResource', 'ngRoute']
,   ($routeProvider) ->

        $routeProvider.otherwise
            redirectTo: '/'
