class Commands
    def sergebox(bot)     
        bot.command(:reparsequotedb) do |event|
            yml = YAML.load_file 'data/quotes.yml'
            yml2 = {}
            File.open("data/quotes.yml", "w") do |file|
            yml.keys.each_with_index do |var,i|
                yml2[i] = yml[var]
            end
            file.write(yml2.to_yaml)
            end
            r.size = yml.size
            event.respond "Reparsed DB"
        end
    end
end