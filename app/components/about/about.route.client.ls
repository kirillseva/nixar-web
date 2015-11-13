angular
  .module \app
  .config ($state-provider, $url-router-provider) ->
       $state-provider.state do
          * \about
          * url: \/about
            parent: \root
            views:
               'content':
                  template-url: \about
                  controller: \about
                  