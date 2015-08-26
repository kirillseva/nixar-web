angular
  .module \app
  .directive do 
    * \colored
    * ->
        restrict: \A
        link: ($scope, $element, $attrs)->
           $attrs.$observe \colored, (value)->
               tagsToReplace =
                    '&': '&amp;'
                    '<': '&lt;'
                    '>': '&gt;'
               escape = (tag)->
                    #console.log \replaceTag, tag
                    tagsToReplace[tag] ? tag
               
               
               code = (group)->
                  "<span class='colored code'>#group</span>"
               colored = (str, group)->
                  "<span class='colored'>#group</span>"
               space = (str)->
                  "<span class='space'></span>"
               $element.html value.replace(/[&<>]/g, escape).replace(/ /g, space).replace(/colored\(([^)]+)\)/g, colored).replace(/[(){}]/g, code)