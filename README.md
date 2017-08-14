# Ubuntu with Apache in docker

## Test it, the output is hostname/Container ID
Verify the image.
```sh
docker run -d -p 5000:80 hikriss/mysite
```
Then, use Chrome/IE/Firefox to browse to 'http://localhost:5000'

## Share local folder
To share local folder with friends.
```sh
docker run -d -p <port_exposed>:80 -v <local folder>:/var/www hikriss/mysite
```

