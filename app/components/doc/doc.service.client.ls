angular
  .module \app
  .service do
      * \doc
      * ($xonom)->
          commands = []
          $xonom.doc.commands (err, cmds)->
            cmds.for-each (item)->
              commands.push item
          commands: commands