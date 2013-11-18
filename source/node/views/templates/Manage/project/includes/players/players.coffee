app= angular.module 'project.players', ['ngResource','ngRoute'], ($routeProvider, AppServiceProvider) ->





###

Ресурсы

###



# Список игроков
app.factory 'PlayerList', ($resource) ->
    $resource '/api/v1/players', {}



# Платежи
app.factory 'Payment', ($resource) ->
    $resource '/api/v1/players/payment/:paymentId', {},
        update:
            method: 'put'
            params:
                paymentId: '@id'



# Игрок
app.factory 'Player', ($resource) ->
    $resource '/api/v1/players/player/:playerId', {},
        create:
            method: 'post'

        update:
            method: 'put'
            params:
                playerId: '@id'

        delete:
            method: 'delete'
            params:
                playerId: '@id'



# Активация игрока
app.factory 'PlayerActivate', ($resource) ->
    $resource '/api/v1/players/player/activate/:playerId', {},
        activate:
            method: 'get'
            params:
                playerId: '@id'



# Деактивация игрока
app.factory 'PlayerDeactivate', ($resource) ->
    $resource '/api/v1/players/player/deactivate/:playerId', {},
        deactivate:
            method: 'get'
            params:
                playerId: '@id'



# Рассылка почты
app.factory 'PlayerSenderMail', ($resource) ->
    $resource '/api/v1/sender/mail', {},
        send:
            method: 'post'



# Рассылка смс
app.factory 'PlayerSenderSms', ($resource) ->
    $resource '/api/v1/sender/sms', {},
        send:
            method: 'post'





###

Контроллеры

###



# Контроллер панели управления.
app.controller 'PlayersDashboardCtrl', ($scope, debug) ->
    if debug then debug.groupCollapsed('PlayersDashboardCtrl...')

    $scope.state= 'loaded'

    if debug then debug.groupEnd()



# Контроллер списка игроков.
app.controller 'PlayersPlayerListCtrl', ($rootScope, $scope, Player, PlayerActivate, PlayerDeactivate, debug) ->
    if debug then debug.groupCollapsed('PlayersPlayerListCtrl...')

    $scope.state= 'loaded'

    load= ->
        $scope.players= Player.query ->
            null
        , (res) ->
            $rootScope.error= res

    do load

    $scope.activate= (player) ->
        doActivatePlayer= new PlayerActivate player
        doActivatePlayer.$activate ->
            do load
        , (res) ->
            $rootScope.error= res

    $scope.deactivate= (player) ->
        doActivatePlayer= new PlayerDeactivate player
        doActivatePlayer.$deactivate ->
            do load
        , (res) ->
            $rootScope.error= res

    $scope.showDetails= (player) ->
        if player
            $scope.view.dialog.playerId= player.id
        else
            $scope.view.dialog.playerId= null
        $scope.showViewDialog 'player'

    $scope.hideDetails= ->
        $scope.view.dialog.playerId= null
        do $scope.hideViewDialog

    $scope.reload= ->
        do load

    if debug then debug.groupEnd()



app.controller 'PlayersPlayerDialogCtrl', ($rootScope, $scope, $route, $location, Player) ->
    if $scope.view.dialog.playerId
        $scope.player= Player.get $scope.view.dialog, ->
            $scope.action= 'update'
        , (res) ->
            $rootScope.error= res
            do $scope.hideViewDialog
    else
        $scope.player= new Player
        $scope.action= 'create'


    # Действия
    $scope.create= ->
        $scope.player.$create ->
            $location.path '/players/player/list'
        , (res) ->
            $rootScope.error= res

    $scope.update= ->
        $scope.player.$update ->
            $location.path '/players/player/list'
        , (res) ->
            $rootScope.error= res

    $scope.delete= ->
        $scope.player.$delete ->
            $location.path '/players/player/list'
        , (res) ->
            $rootScope.error= res



# Контроллер списка платежей.
app.controller 'PlayersPaymentListCtrl', ($rootScope, $scope, Payment) ->
    $scope.state= 'loaded'

    load= ->
        $scope.payments= Payment.query ->
            $scope.paymentStatuses= [
                'pending'
                'success'
                'failure'
            ]
        , (res) ->
            $rootScope.error= res

    do load

    # Дествие
    $scope.change= (payment) ->
        doChangePayment= new Payment payment
        doChangePayment.$update ->
            do load
        , (res) ->
            $rootScope.error= res

    $scope.reload= ->
        do load



# Контроллер рассылки на почту
app.controller 'PlayersSenderMailCtrl', ($rootScope, $scope, $location, Player, PlayerSenderMail) ->
    $scope.state= 'loaded'
    $scope.mail= new PlayerSenderMail

    load= ->
        $scope.players= Player.query ->
            null
        , (res) ->
            $rootScope.error= res

    do load

    $scope.togglePlayer= (player) ->
        player.selected= !player.selected

    # Отправка
    $scope.send= ->
        $scope.mail.to= []
        $scope.players.map (val, i) ->
            if val.selected == true
                $scope.mail.to.push val.email

        $scope.mail.$send ->
            $location.path '/players/player/list'
        , (res) ->
            $rootScope.error= res

    $scope.reload= ->
        do load



# Контроллер рассылки смс
app.controller 'PlayersSenderSmsCtrl', ($rootScope, $scope, $location, Player, PlayerSenderSms) ->
    $scope.players= {}
    $scope.sms= new PlayerSenderSms
    $scope.state= 'loaded'

    load= ->
        $scope.players= Player.query ->
            null
        , (res) ->
            $rootScope.error= res

    do load

    $scope.togglePlayer= (player) ->
        player.selected= !player.selected

    # Отправка
    $scope.send= ->
        $scope.sms.to= []
        $scope.players.map (val, i) ->
            if val.selected == true
                $scope.sms.to.push val.phone

        $scope.sms.$send ->
            $location.path '/players/player/list'
        , (res) ->
            $rootScope.error= res

    $scope.reload= ->
        do load
