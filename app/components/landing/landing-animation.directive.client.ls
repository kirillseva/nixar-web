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
              h = -80 + pos / 5
              $(\.fixed).css(\top, if h < 0 then h else 0)
              s = 450 - pos * 2
              $(\.demo-terminal).css(\height, if s > 0 then s else 0)