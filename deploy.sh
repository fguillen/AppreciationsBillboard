#!/bin/bash
set -e
set -x

if ! [[ $1 ]] || ! [[ $2 ]]; then
  echo "use: $0 <environment {production, staging}> <sub_environment {web, cronjobs, activejobs}>"
  exit 1
fi

environment=$1
sub_environment=$2
app=$(git remote -v |\
  grep origin |\
  sed -E 's/.*github.com.?.*\/(.*)\.git.*/\1/' |\
  head -n 1 |\
  tr '[:upper:]' '[:lower:]')
commit_id=`git log -n1 --format="%h"`
actual_branch=`git branch | grep "*" | sed "s/\\* //"`


#
# deploy branch
#
if [[ `git branch --list deploy` ]]; then
  git branch -D deploy
fi

git checkout -b deploy

git rm --ignore-unmatch .elasticbeanstalk/config.yml
git mv .elasticbeanstalk/config.$environment.yml .elasticbeanstalk/config.yml
git mv .ebextensions_extra/00_instance.$environment.config .ebextensions/00_instance.config
git mv .ebextensions_extra/06_envvars.$environment.config .ebextensions/06_envvars.config
git mv .ebextensions_extra/04_datadog.$environment.config .ebextensions/04_datadog.config

if [ -f .ebextensions_extra/07_migrations.$sub_environment.config ]; then
  git mv .ebextensions_extra/07_migrations.$sub_environment.config  .ebextensions/07_migrations.config
fi

if [ -f .ebextensions_extra/09_filebeat.$environment.config ]; then
  git mv .ebextensions_extra/09_filebeat.$environment.config  .ebextensions/09_filebeat.config
fi

if [ -f .ebextensions_extra/12_newrelic.$environment.config ]; then
  git mv .ebextensions_extra/12_newrelic.$environment.config  .ebextensions/12_newrelic.config
fi

git commit -m "Preparing to commit to deploy branch"

#
# web
#
if [[ $sub_environment == "web" ]]; then
  if [[ `git branch --list web` ]]; then
    git branch -D web
  fi

  git checkout -b web
  environment_name=`eb list | grep "*" | sed "s/\\* //"`

  # preparing web config
  git mv .ebextensions_extra/01_load_balancer.$environment.config .ebextensions/01_load_balancer.config
  git mv .ebextensions_extra/06_envvars_extra.$sub_environment.config .ebextensions/06_envvars_extra.config
  git commit -m "Preparing to commit to web branch"

  # create environment if it doesn't exist
  # deploy if it exists
  if ! [[ $environment_name ]]; then
    environment_name=$app-$environment-web
    eb create --cfg $environment_name $environment_name
  else
    eb deploy --timeout 100 --label $commit_id-$environment_name
  fi

  git checkout deploy
  git branch -D web
fi

#
# cronjobs
#
if [[ $sub_environment == "cronjobs" ]]; then
  if [[ `git branch --list cronjobs` ]]; then
    git branch -D cronjobs
  fi

  git checkout -b cronjobs
  environment_name=`eb list | grep "*" | sed "s/\\* //"`

  # preparing cronjobs config
  git rm .ebextensions/10_threshold.config
  git mv .ebextensions_extra/06_envvars_extra.$sub_environment.config .ebextensions/06_envvars_extra.config
  git mv cron.$environment.yaml cron.yaml
  git commit -m "Preparing to commit to cronjobs branch"

  # create environment if it doesn't exist
  # deploy if it exists
  if ! [[ $environment_name ]]; then
    environment_name=$app-$environment-cronjobs
    eb create --cfg $environment_name $environment_name
  else
    eb deploy --timeout 100 --label $commit_id-$environment_name
  fi

  # clean garbage
  git checkout deploy
  git branch -D cronjobs
fi

#
# activejobs
#
if [[ $sub_environment == "activejobs" ]]; then
  if [[ `git branch --list activejobs` ]]; then
    git branch -D activejobs
  fi

  git checkout -b activejobs
  environment_name=`eb list | grep "*" | sed "s/\\* //"`

  # preparing activejobs config
  git mv .ebextensions_extra/30_queue_url_for_activejobs_enviroment.$environment.config .ebextensions/
  git mv .ebextensions_extra/06_envvars_extra.$sub_environment.config .ebextensions/06_envvars_extra.config
  git rm cron.staging.yaml
  git rm cron.production.yaml
  git commit -m "Preparing to commit to activejobs branch"

  # create environment if it doesn't exist
  # deploy if it exists
  if ! [[ $environment_name ]]; then
    environment_name=$app-$environment-activejobs
    eb create --cfg $environment_name $environment_name
  else
    eb deploy --timeout 100 --label $commit_id-$environment_name
  fi

  # clean garbage
  git checkout deploy
  git branch -D activejobs
fi

#
# dev
#
if [[ $sub_environment == "dev" ]]; then
  if [[ `git branch --list dev` ]]; then
    git branch -D dev
  fi

  git checkout -b dev
  environment_name=`eb list | grep "*" | sed "s/\\* //"`

  # preparing dev config
  git mv .ebextensions_extra/01_load_balancer.$environment.config .ebextensions/01_load_balancer.config
  git mv .ebextensions_extra/06_envvars_extra.$sub_environment.config .ebextensions/06_envvars_extra.config
  git commit -m "Preparing to commit to dev branch"

  # create environment if it doesn't exist
  # deploy if it exists
  if ! [[ $environment_name ]]; then
    environment_name=$app-$environment-dev
    eb create --cfg $environment_name $environment_name
  else
    eb deploy --timeout 100 --label $commit_id-$environment_name
  fi

  git checkout deploy
  git branch -D dev
fi


#
# Clean garbage
#
git checkout $actual_branch
git branch -D deploy
