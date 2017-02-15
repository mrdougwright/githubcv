Aws.eager_autoload! # to fix sidekiq bug?
s3 = Aws::S3::Resource.new(region: ENV['AWS_REGION'])
S3_BUCKET = s3.bucket(ENV['S3_BUCKET_NAME'])
