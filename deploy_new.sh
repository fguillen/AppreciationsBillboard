#!/bin/bash
# New Dalia Deploy Script
# Cheanges from the old one:
# Unified style
# - - moved from backticks to $( https://github.com/koalaman/shellcheck/wiki/SC2006
# - - Grepping for * is problematic because its a regex special char, therefor moved to 'grep -F "*"' where neccessary
# - changed the way we get the actual git branch
# - extended all the git rm with "--ignore-unmatch" to make it more error resistant
# - check if file exists before moving it
# - moved preparation phase to switch case
# - moved environment_name variable initialisation out of the individual preparation sections
# - moved the deploy phase out of the the individual sections
# - Moved envvars_extra out of the individual sections
# - moved the cleanup part out of the individual sections

# ToDo:
# - we remove the cron.staging.yaml from activejosb but not from the web, could it be that we can just leave it in every instance?
#
# We could unify a lot by running:
#
#for I in $(ls .ebextensions_extra/*.${environment}.config);
#  do
#    git mv $I $(echo $I | sed 's/.$environment//g' | sed 's/.ebextensions_extra/.ebextensions/g' )
#  done
#
#for I in $(ls .ebextensions_extra/*.$sub_environment.config);
#  do
#    git mv $I $(echo $I | sed 's/.$sub_environment//g' | sed 's/.ebextensions_extra/.ebextensions/g' )
#  done
#
#But i am not sure if there is a probem if we deploy the cronjobs instance together with the load balancer config, for example
#


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
commit_id=$(git log -n1 --format="%h")
actual_branch=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)


#
# deploy branch
#

if [[ $(git branch --list deploy) ]]; then
  git branch -D deploy
fi

git checkout -b deploy


git rm --ignore-unmatch .elasticbeanstalk/config.yml


if [ -f ".ebextensions_extra/config.${environment}.yml" ]; then
  git mv ".elasticbeanstalk/config.${environment}.yml" .elasticbeanstalk/config.yml
fi

if [ -f ".ebextensions_extra/00_instance.${environment}.config" ]; then
  git mv ".ebextensions_extra/00_instance.${environment}.config" .ebextensions/00_instance.config
fi

if [ -f ".ebextensions_extra/06_envvars.${environment}.config" ]; then
  git mv ".ebextensions_extra/06_envvars.${environment}.config" .ebextensions/06_envvars.config
fi

if [ -f ".ebextensions_extra/07_migrations.$sub_environment.config" ]; then
  git mv ".ebextensions_extra/07_migrations.$sub_environment.config" .ebextensions/07_migrations.config
fi

if [ -f ".ebextensions_extra/09_filebeat.${environment}.config" ]; then
  git mv ".ebextensions_extra/09_filebeat.${environment}.config"  .ebextensions/09_filebeat.config
fi

if [ -f ".ebextensions_extra/12_newrelic.${environment}.config" ]; then
  git mv ".ebextensions_extra/12_newrelic.${environment}.config"  .ebextensions/12_newrelic.config
fi



git commit -m "Preparing to commit to deploy branch"

environment_name=$(eb list | grep -F "*" | sed "s/\\* //")

if [[ $(git branch --list "${sub_environment}") ]]; then
    git branch -D "${sub_environment}"
  fi
git checkout -b "${sub_environment}"



if [ -f "06_envvars_extra.${sub_environment}.config" ]; then
  git mv ".ebextensions_extra/06_envvars_extra.${sub_environment}.config" .ebextensions/06_envvars_extra.config
fi


case $sub_environment in
  web*)
    # preparing web config
    git mv ".ebextensions_extra/01_load_balancer.${environment}.config" .ebextensions/01_load_balancer.config
    git commit -m "Preparing to commit to web branch"
    ;;

  cronjobs*)
    # preparing cronjobs config
    git rm --ignore-unmatch .ebextensions/10_threshold.config
    git mv "cron.${environment}.yaml" cron.yaml
    git commit -m "Preparing to commit to cronjobs branch"
    ;;

  activejobs*)
    # preparing activejobs config
    git mv ".ebextensions_extra/30_queue_url_for_activejobs_enviroment.${environment}.config" .ebextensions/
    git rm --ignore-unmatch cron.staging.yaml
    git rm --ignore-unmatch cron.production.yaml
    git commit -m "Preparing to commit to activejobs branch"
    ;;

  dev*)
    # preparing dev config
    git mv ".ebextensions_extra/01_load_balancer.${environment}.config" .ebextensions/01_load_balancer.config
    git commit -m "Preparing to commit to dev branch"
    ;;

  *)
    echo "I don't have anything specific for this environment"
    ;;
esac


# Deploy phase

git checkout deploy
git branch -D "$sub_environment"


# create environment if it doesn't exist
# deploy if it exists
if ! [[ "${environment_name}" ]]; then
  environment_name="${app}-${environment}-${sub_environment}"
  eb create --cfg "${environment_name}" "${environment_name}"
else
  eb deploy --timeout 100 --label "${commit_id}-${environment_name}"
fi

#
# Clean garbage
#
git checkout "${actual_branch}"
git branch -D deploy
