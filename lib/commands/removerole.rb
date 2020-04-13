class Commands
  def removerole(bot)        
    bot.command(:removerole, min_args: 1) do |event, *args|
      if event.channel.name == ROLE_CHANNEL
        roles = event.server.roles.map {|role| [role.name.downcase, role]}.to_h
        removed_roles = Array.new
        args.each do |role|
          if event.user.role?(roles[role.downcase])
          event.user.remove_role(roles[role.downcase])
          removed_roles << role
          end
        end
        event.respond "Removed \"#{removed_roles.join(', ')}\" from #{event.user.username}"
      end
    end
  end
end