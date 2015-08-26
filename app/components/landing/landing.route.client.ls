angular
  .module \app
  .config ($state-provider, $url-router-provider) ->
       $state-provider.state do
          * \landing
          * url: 'landing'
            parent: \root
            views:
               'content' :
                  template-url: \landing
                  controller: \landing