angular
  .module \app
  .controller do
      * \app
      * ($scope, $xonom, content, scroll, $location)->
          goto-anchor = (x)->
            #$location.hash x
            scroll.to x
          $scope.active = null
          $scope.activate = (node)->
            $scope.active = node
            goto-anchor node.text
          $scope.menu = content
          