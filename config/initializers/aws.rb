#Aws.config.update({
#  credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_SECRET_ACCESS_KEY'])
#})
client = Aws::S3::Client.new(
  region: ENV['AWS_REGION'],
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
)
s3 = Aws::S3::Resource.new(client: client)
S3_BUCKET = s3.bucket(ENV['S3_BUCKET_NAME'])
