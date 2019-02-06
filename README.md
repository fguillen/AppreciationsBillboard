# RailsSkeleton

## Usage

This application is meant to be
the basis for any new Rails application
that need that standard Dalia boilerplate.

### Creating a new App

Clone and renaming:

    mkdir MyNewAwesomeDaliaApp
    cd MyNewAwesomeDaliaApp
    git init
    git remote add skeleton git@github.com:DaliaResearch/RailsSkeleton.git
    git pull skeleton master

    # Install gsed if needed
    command -v gsed
    if [ $? -ne 0 ]
    then
      brew install gnu-sed
    fi

    find ./ -type f -exec gsed -i 's/RailsSkeleton/MyNewAwesomeDaliaApp/' {} \;
    find ./ -type f -exec gsed -i 's/railsskeleton/mynewawesomedaliaapp/' {} \;
    git add .
    git commit -m "Renaming Project"

Settig up App:

    bin/setup

#### Set up CodeClimate

Follow the instructions here to customize the configuration and to activate CodeClimate:

- https://asktheteam.daliaresearch.com/t/how-can-i-set-up-codeclimate-in-a-ruby-project/117

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

  - `$ cd MyNewAwesomeDaliaApp`
  - `$ git fetch skeleton`
  - `$ git merge skeleton/master`

#### ⚠️⚠️ Conflicts Happen! ⚠️⚠️

When merging with `skeleton/master`
you are probably going to face conflicts on files
that you don't expect.
Mainly the files that have the `RailsSekelton` placeholder.

Let's think about great ways of
making this better for everyone! \o/
