angular
  .module \app
  .controller do
      * \doc
      * ($scope, scroll, $location, doc)->
          goto-anchor = (x)->
            #$location.hash x
            scroll.to x
          $scope.activate = (text)->
            goto-anchor text
          $scope.menu = doc.commands
            