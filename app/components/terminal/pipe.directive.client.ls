angular
  .module \app
  .directive do 
    * \pipe
    * ->
        restrict: \A
        link: ($scope, $element, $attrs)->
           $attrs.$observe \pipe, (value)->
               tagsToReplace =
                    '&': '&amp;'
                    '<': '&lt;'
                    '>': '&gt;'
               escape = (tag)->
                    #console.log \replaceTag, tag
                    tagsToReplace[tag] ? tag
               transform = (value, index)->
                  if index is 0 
                      " #value "
                  else
                      " <span class='pipe'>#value</span> "
               $element.html value.replace(/[&<>]/g, escape).split(\|).map(-> it.trim!.split(' ').map(transform).join(' ')).join(\|)