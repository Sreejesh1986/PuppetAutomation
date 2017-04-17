ec2_instance { 'Ubuntu-Agent-1':
  ensure        => present,
  region        => 'us-east-1',
  image_id      => 'ami-f4cc1de2', # you need to select your own AMI
  subnet        => 'Subnet-1',
  instance_type => 't2.micro',
  key_name          => 'northvirginiakey', # This is my aws key. 
  user_data   => template('/home/ubuntu/setup.sh'),
  tags => {
  tag_name => 'test',
  },
}