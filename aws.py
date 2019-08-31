import terrascript
import terrascript.aws
import terrascript.aws.r

config = terrascript.Terrascript()

#:config += terrascript.aws.aws(version='~> 2.0', region='us-east-1')
config += terrascript.aws.r.aws_vpc('example', cidr_block='10.0.0.0/16')

fp = open('config.tf.json','wt')
fp.write(str(config))

print(config.dump())
