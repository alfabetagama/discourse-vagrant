grep -q "swapfile" /etc/fstab

# if not then create it
if [ $? -ne 0 ]; then
  fallocate -l 4G /swapfile
  chmod 0600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile none swap sw 0 0' >> /etc/fstab
else
  echo 'swapfile found. No changes made.'
fi

  