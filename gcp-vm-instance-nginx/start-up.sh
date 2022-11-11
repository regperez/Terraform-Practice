/bin/cat <<EOM >/mnt/stateful_partition/nginx.conf
events {
    worker_connections  4096;  ## Default: 1024
}

stream {
    server {
        listen 9501;
        proxy_pass 192.168.64.2:9501;
    }
    server {
        listen 443;
        proxy_pass 192.168.64.2:443;
    }
}
EOM
ip route add 10.8.0.0/14 via 10.142.0.1 dev eth1
docker run -d --restart=always --name proxy-ppc -p 9501:9501 -p 443:443 -v /mnt/stateful_partition/nginx.conf:/etc/nginx/nginx.conf nginx
