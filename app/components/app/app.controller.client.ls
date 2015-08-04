angular
  .module \app
  .controller do
      * \app
      * ($scope, $xonom, content, scroll, $location)->
          goto-anchor = (x)->
            #$location.hash x
            scroll.to x
          $scope.activate = (text)->
            goto-anchor text
          $scope.menu = content
          