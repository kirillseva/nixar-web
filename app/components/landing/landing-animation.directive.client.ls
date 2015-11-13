angular
  .module \app
  .directive do 
    * \landingAnimation
    * ->
        restrict: \C
        link: ($scope, $element)->
           win = $(window)
           win.scroll ->
              pos = win.scroll-top!
              if pos < 100 
              then
                $(\.fixed).remove-class(\active)
              else
                $(\.fixed).add-class(\active)