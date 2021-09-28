#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo systemctl start nginx.service
echo -e 'user nginx;\n worker_processes auto;\n error_log /var/log/nginx/error.log;\n pid /run/nginx.pid;\n include /usr/share/nginx/modules/*.conf;\n events {\n worker_connections 1024;\n }\n http {\n log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '\n '$status $body_bytes_sent "$http_referer" '\n '"$http_user_agent" "$http_x_forwarded_for"';\n access_log  /var/log/nginx/access.log  main;\n sendfile on;\n tcp_nopush on;\n tcp_nodelay on;\n keepalive_timeout 65;\n types_hash_max_size 4096;\n include /etc/nginx/mime.types;\n default_type application/octet-stream;\n include /etc/nginx/conf.d/*.conf;\n server {\n listen 8888;\n server_name  _;\n root /usr/share/nginx/html;\n include /etc/nginx/default.d/*.conf;\n error_page 404 /404.html;\n location = /404.html {\n }\n error_page 500 502 503 504 /50x.html;\n location = /50x.html {\n }\n }\n }\n ' | sudo tee /etc/nginx/nginx.conf
export MY_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
export MY_REGION=$(curl http://169.254.169.254/latest/meta-data/placement/region)
export MY_AZ=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)
echo -e "<center><h2>IP: $MY_IP</h2><br><h2>REGION: $MY_REGION</h2><br><h2>AZ: $MY_AZ</h2></center>" | sudo tee /usr/share/nginx/html/index.html
sudo useradd -m -G adm -s /bin/bash teacher
sudo mkdir /home/teacher/.ssh
echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCkBIEsfJD6d0J4tqTnVq4z3Ve0bop71b+27j75gncRsLdAokiUqGyt1fmvS+VkoBWxOFiAOsfdSdTwJWyGs0kplZouOh93cRc/9mp16mNcR5B86+ORLrMZCq3ZGVj2F3YjtoeK4b+RvEtpRmJaC/no9yjTeDTnBYVsV+vQvxiaaeLzkbPRhd0Ovlayoz/gXqI4DOCaQTfISHxG7X+NLfpWR6LsfaHYKG/5WmaA3LOnYAqV+S7nq2WQVQ2Z5bzpJC9s= andrey@MBP-Andrey' | sudo tee /home/teacher/.ssh/authorized_keys
sudo chown -R teacher:teacher /home/teacher/.ssh
sudo systemctl reload nginx.service
sudo systemctl enable nginx.service
