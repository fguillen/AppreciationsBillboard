# AppreciationsBillboard

Simple application to deliver some appreciation to your colleges

# Set up the development environment

```
bundle
rake db:setup
rake test
```


# Icons

Special thanks to the icons creators

- https://icons8.com/icon/pack/animals/flat_round
- <a target="_blank" href="https://icons8.com/icons/set/bird--v1">Bird</a>, <a target="_blank" href="https://icons8.com/icons/set/falcon">Falcon</a> and other icons by <a target="_blank" href="https://icons8.com">Icons8</a>
- https://freeicons.io/animal-icons/bird-icon-29545

# Production configuration

Check all the ENVARS in `.env.development` all of them have to be in your production envvars

## Heroku ClearDB

Check this post for the special envvar `DATABASE_URL`:

- https://medium.com/@emersonthis/running-rails-with-mysql-on-heroku-4765df033428

You can set all ENVVARS at once in heroku:

    heroku config:push -a appreciationsbillboard -f .env.production -o

## Google Auth

We have to add the callbacks, check here:

- https://asktheteam.daliaresearch.com/t/cant-login-with-google-oauth-on-my-development-environment/425/2

## Amazon S3

We have to create the bucket, the IAM User, the Policy and the Group:

- https://medium.com/@shamnad.p.s/how-to-create-an-s3-bucket-and-aws-access-key-id-and-secret-access-key-for-accessing-it-5653b6e54337


# Slack App

The notifications are sent via this Slack App:

- https://api.slack.com/apps/A012GPEULUD/general?
