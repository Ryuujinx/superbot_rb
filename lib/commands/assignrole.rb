class Commands
  def assignrolequote(bot)        
    bot.command(:assignrole, min_args: 1) do |event, *args|
      if event.channel.name == ROLE_CHANNEL
        roles = event.server.roles.map {|role| [role.name.downcase, role]}.to_h
        role_check = ROLE_BLACKLIST.map(&:downcase)
        added_roles = []
        args.each do |role|
          if ! role_check.include?(role.downcase)
            event.user.add_role(roles[role.downcase])
            added_roles << role
          end
        end
        event.respond "Added #{added_roles.join(', ')} to #{event.user.username}"
      end
    end
  end
end