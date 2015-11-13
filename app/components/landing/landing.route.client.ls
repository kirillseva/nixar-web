angular
  .module \app
  .config ($state-provider, $url-router-provider) ->
     $urlRouterProvider.otherwise \/
     $stateProvider.state do 
         * \landing
         *  url: \/
            parent: \root
            views:
              'content':
                templateUrl: \landing
                controller: \landing
     