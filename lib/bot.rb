class Bot
  load 'lib/random.rb'
  load 'lib/config/config.rb'
  @@r = Rand.new(YAML.load_file('data/quotes.yml').size)
  @@s3 = Aws::S3::Client.new(profile: S3PROFILE, region: S3REGION)
end