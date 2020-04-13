class Commands
  def grepquote(bot)
    bot.command(:grepquote, min_args: 1) do |event, *args|
      yml = YAML.load_file 'data/quotes.yml'
      cnt = 0
      matches_hash = Hash.new
      yml.each_pair do |key, value|
        if value.downcase =~ /#{args.join(' ').downcase}/
          cnt += 1
          matches_hash[key] = value
        end
      end
      if cnt == 0
        event.respond "No matches found for #{args.join(' ')}, try again."
      elsif cnt < 10
        matches = "Match found:\n"
        matches_hash.each_pair do |key, value|
          matches = matches + "#{key}: #{value}\n"
        end
        event.respond "#{matches}"
      else
        File.open("tmp/grepquote-#{event.message.id}.txt", "w") do |file|
          file.write(matches_hash.to_yaml)
        end
        event.respond "More then 10 matches found, uploading text."
        File.open("tmp/grepquote-#{event.message.id}.txt", "rb") do |file|
          s3.put_object(bucket: S3BUCKET, key: "grepquote-#{event.message.id}.txt", body: file)
        end
        File.delete("tmp/grepquote-#{event.message.id}.txt")
        event.respond "https://#{S3BUCKET}.s3-#{S3REGION}.amazonaws.com/grepquote-#{event.message.id}.txt"
      end
    end    
  end
end