#!/bin/bash
apt update
apt install -y apt-transport-https ca-certificates curl software-properties-common
apt-get install curl
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

apt update
apt-cache policy docker-ce
apt install -y docker-ce

docker run -dit --name idwall-apache-app -p 80:80 -p 443:443 -v "$PWD":/usr/local/apache2/htdocs/ httpd:2.4
echo "<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>IDwall</title>
</head>
<body>
 <center>
    <div>
    	<img src="https://idwall.co/img/logo-idwall-black.png" />
    </div>
  </center>
</body>
</html>" > $PWD/index.html