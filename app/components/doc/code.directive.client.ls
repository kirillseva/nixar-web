angular
  .module \app
  .directive do 
    * \code
    * ->
        restrict: \E
        link: (scope, element)->
          console.log element