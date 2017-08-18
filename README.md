# gscout
This is a container version of the gscout utility from [here](https://www.nccgroup.trust/us/about-us/newsroom-and-events/blog/2017/august/introducing-g-scout/).

It is specifically aimed at running gscout against a single project, not multiple, not organisations, as this was my use case.

## Use
Pretty simple really:

 - `git clone https://github.com/Stono/gscout`
 - `cd gscout`
 - `docker-compose run gscout your-project-here`

### Authentication
gscout requires a service account with the `roles/viewer` and `roles/iam.securityReviewer` to run.  This script will authenticate the gcloud CLI using some command line prompts, generate that service eaccount and generate a service key for gscout to use.  Once the scan is complete, the account is deleted.

**NOTE**: As there is a volume mount in `docker-compose.override.yml` which mounts the home directory of the container user - you'll only need to authenticate the gcloud cli once. 

```
$ docker-compose run gscout peopledata-product-team
Running gscout for peopledata-product-team
Setting project
Updated property [core/project].
Exiting gscout account detected, removing it
deleted service account [gscout@peopledata-product-team.iam.gserviceaccount.com]
Creating new gscout account
Created service account [gscout].
Assigning roles to gscout@peopledata-product-team.iam.gserviceaccount.com
Creating service key
created key [82347d99392741f76f158b4d10a2343bf082844c] of type [json] as [keyfile.json] for [gscout@peopledata-product-team.iam.gserviceaccount.com]
Running scan
('Scouting ', u'peopledata-product-team')
Cleaning up service account
deleted service account [gscout@peopledata-product-team.iam.gserviceaccount.com]
Scan complete, results can be found in the ./results folder
```

As the output says, you'll find it in `./results`
