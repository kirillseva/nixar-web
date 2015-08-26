angular
  .module \app
  .controller do
      * \landing
      * ($scope, $xonom, scroll, $location, $timeout , doc)->
          
          $scope.commands = doc.commands
          rand = (start, end)->
            Math.floor(Math.random! * end) + start
          $scope.command-style = ->
            top:  rand 30, 300
            left: rand 300, 1800
          
          textWidth = (text, font)->
             if (!textWidth.fakeEl) 
               textWidth.fakeEl = $('<span>').hide!.appendTo(document.body)
             textWidth.fakeEl.text(text or @val! or @text!).css('font', font or @css('font'))
             textWidth.fakeEl.width!
          
          $scope.style = (demo)->
            speed = Math.round(demo.body.length / 20)
            width: textWidth(demo.body, '23px Varela Round')
            animation-duration: "#{speed}s" 
          
          $scope.is-svg = (name)->
            [\linux].index-of(name) > -1
          
          $scope.examples = 
            * desc: 'Print highlighted javascript file'
              body: 'cat server.js'
              result:
                  * "var http = require(colored('http'));"
                  * "http.createServer(function (req, res) {"
                  * " res.writeHead(200, {colored('Content-Type'): colored('text/plain')});"
                  * " res.end(colored('Hello World\n'));"
                  * "}).listen(1337, colored('127.0.0.1'));"
                  * "console.log(colored('Server running at http://127.0.0.1:1337/'));"
            * desc: 'Highlight log file'
              body: 'cat big-server.log | mark error'
              result:
                  * "info: some info message"
                  * "info: some info message"
                  * "colored(error): something wrong happened"
                  * "info: some info message"
                  * "info: some info message"
                  * "info: some info message"
                  * "colored(error): something wrong happened"
                  * "info: some info message"
                  * "info: some info message"
                  * "colored(error): something wrong happened"
            * desc: 'Find 5 biggest files'
              body: 'fs all | file size | sort 1 | reverse | take 5'
              result:
                  * 'db1.log colored(2990000) bytes'
                  * 'db2.log colored(2500000) bytes'
                  * 'db3.log colored(2000000) bytes'
                  * 'db4.log colored(1900000) bytes'
                  * 'db5.log colored(1500000) bytes'
            * desc: 'Fine latest changed files'
              body: 'fs all | file modified | sort 1 | take 5'
              result:
                  * 'db1.log colored(5) days ago'
                  * 'db2.log colored(5) days ago'
                  * 'db3.log colored(4) days ago'
                  * 'db4.log colored(3) days ago'
                  * 'db5.log colored(2) days ago'
            * desc: 'Fine file recursively by part of filename and content'
              body: 'fs **/u*r.js | file lines | filter word'
              result: 
                  * 'colored(user.js): this colored(word) is found inside user.js file'
                  * 'colored(user.js): this colored(word) is found inside user.js file'
                  * 'colored(user.js): this colored(word) is found inside user.js file'
            * desc: 'Generate scripts'
              body: "fs *.js | map '<script src=\"*\"></script>'"
              result: 
                  * '<script type="colored(user.js)"></script>'
                  * '<script type="colored(profile.js)"></script>'
                  * '<script type="colored(hotel.js)"></script>'
            * desc: 'Skip first line and then take 5 lines from file'
              body: "cat filename.js | drop 1 | take 5"
              result: 
                  * 'line 2'
                  * 'line 3'
                  * 'line 4'
                  * 'line 5'
                  * 'line 6'
          $scope.demo = $scope.examples.0
          $scope.terminal-class = "animate"
          switch-demo = ->
            $timeout do 
              * ->
                  ex = $scope.examples
                  index = 
                    ex.index-of($scope.demo)
                  next = if index < ex.length - 1 then index + 1 else 0
                  $scope.demo = ex[next]
                  switch-demo!
                  $scope.terminal-class = ""
                  $timeout ->
                    $scope.terminal-class = "animate"
              * 10 * 1000
          switch-demo!
          $scope.benefits =
            * title: 'Cross Platform'
              desc: 'Runs on linux, mac and windows'
              icon: 
                * \apple
                * \windows
                * \linux
            * title: 'Open source'
              desc: 'Public github repository'
              icon: 
                * \github
                ...
            * title: 'Customizable'
              desc: 'Written on javascript'
              icon: 
                * \cogs
                ...