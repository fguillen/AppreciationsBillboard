# RailsSkeleton

## Usage

This application is meant to be
the basis for any new Rails application
that need that standard Dalia boilerplate.

### Creating a new App

  - `$ mkdir MyNewAwesomeDaliaAPP`
  - `$ cd MyNewAwesomeDaliaAPP`
  - `$ git init`
  - `$ git remote add skeleton git@github.com:DaliaResearch/RailsSkeleton.git`
  - `$ git pull skeleton master`
  - Replace occurrences of RailsSkeleton with your app name, in this example MyNewAwesomeDaliaAPP
  - `$ bin/setup` VERY IMPORTANT, will create your database and load the schema

#### Deploying

  - ACTIVATE DEVOPS:
  - Whitelist the new app domain in the Google Developer Console
    (don't forget the `.pizza` domain).

This step is necessary for the *Login with google* feature.

### Adding something to the Skeleton

Keep in mind that this project
should only host code that
is to be used by all Rails apps.

If one changes something in this project
the "based on this" apps can benefit from
those changes using:

  - `$ cd MyNewAwesomeDaliaAPP`
  - `$ git fetch skeleton`
  - `$ git merge skeleton/master`

#### ⚠️⚠️ Conflicts Happen! ⚠️⚠️

When merging with `skeleton/master`
you are probably going to face conflicts on files
that you don't expect.
Mainly the files that have the `RailsSekelton` placeholder.

Let's think about great ways of
making this better for everyone! \o/
