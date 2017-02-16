require('aws-sdk')

Aws.eager_autoload! # to fix sidekiq bug?
s3 = Aws::S3::Resource.new(region: ENV['AWS_REGION'], client: Aws::S3::Client.new(http_wire_trace: true))
S3_BUCKET = s3.bucket(ENV['S3_BUCKET_NAME'])
