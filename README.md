# Toot Trend

## Getting Start
### Build
```bash
$ docker-compose build
```

### Set up .env
```bash
$ docker-compose run --rm web rails secret
```

```.env
SECRET_KEY_BASE=[Paste secret]
RAILS_SERVE_STATIC_FILES=true
PWD=/var/www/html/app
```

### Remove comment out docker-compose.yml for production mode
```yaml:docker-compose.yml
services:
  web:
    command: rails s -p 3000 -b '0.0.0.0' #-e production
```

to like this.

```yaml:docker-compose.yml
services:
  web:
    command: rails s -p 3000 -b '0.0.0.0' -e production
```

### Migration and Asset Precompile
```bash
$ docker-compose run --rm web rails seed:admin email=your.email@example.com password=passowrd RAILS_ENV=production
$ docker-compose run --rm web rails assets:precompile RAILS_ENV=production
```

### Start Running
```bash
$ docker-compose up -d
```
### Set up Nginx
```
server {
  listen 80;
  server_name mstdn.trend.ho-chi-minh.info;
  return 301 https://$host$request_uri;
}

server {
  listen 443 ssl http2;
  listen [::]:443 ssl http2;
  server_name mstdn.trend.ho-chi-minh.info;

  ssl_certificate     /etc/letsencrypt/live/mstdn.trend.ho-chi-minh.info/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/mstdn.trend.ho-chi-minh.info/privkey.pem;

  location / {
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-Server $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_hide_header X-Powered-By;
    proxy_set_header X-Forwarded-Proto https;
    proxy_ignore_headers Expires;
    proxy_pass      http://127.0.0.1:9182;
  }
}
```

### Cron Refresh
#### toots:fetch
Refresh data which last update is more than 3 days ago. 

## License
MIT