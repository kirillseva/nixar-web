module.exports = (repo, p)->
  commands: (callback)->
    commands = repo.commands.filter(-> it.name isnt \nixar)
    repo.docs.for-each (item)->
      apply = (command)->
        command.examples = item.files
      commands |> p.filter (-> it.name is item.name)
                    |> p.each apply
    callback commands