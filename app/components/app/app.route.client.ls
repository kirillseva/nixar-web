angular
  .module \app
  .config ($state-provider, $url-router-provider) ->
       $url-router-provider.otherwise \landing
       $state-provider.state do
          * \root
          * url: \/
            views:
               '' :
                  template-url: \app
                  controller: \app