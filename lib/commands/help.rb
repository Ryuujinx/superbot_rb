class Commands < Bot
  def help(bot)
    bot.command(:help, min_args: 0) do |event|
    event.respond "Commands:
    #{PREFIX}help: Prints this information
    #{PREFIX}quote [<ID>]: Gets a quote, if ID is specified retrieves the requested quote ID.
    #{PREFIX}addquote <QUOTE>: Adds a quote to the database.
    #{PREFIX}grepquote <QUERY>: Searches the database for <QUERY>, maximum of 10 results will be returned. Supports regex.
    #{PREFIX}sergequote: Gets a random serge quote.
    #{PREFIX}deletequote <ID>: Starts the process to delete a quote.
    #{PREFIX}sergebox: Gives you a sergebox.
    #{PREFIX}achallengerappears: Gives you a challenger.
    #{PREFIX}gdq: Gives a random GDQ quote.
    #{PREFIX}listroles: Gives a list of roles.
    #{PREFIX}assignrole <ROLE>: Assigns a role to yourself, takes multiple space seperated roles as an argument.
    #{PREFIX}removerole <ROLE>: Removes the given role from yourself"
    end
  end
end

