# Log-ActiveUsers

You can pipe the tail of your logfile into this script to get an idea of how many users are currently using your web application (if you're logging their IP addresses on each request).

It will add each IP to a set and expire it after 60 seconds if it there isn't other requests from that IP. It's an easy and fast way to get an idea of how popular is your app.

### Usage

```
tail -f production.log | ruby active_users.rb
```

Or if you use Heroku

```
heroku logs -t | ruby active_users.rb
```
