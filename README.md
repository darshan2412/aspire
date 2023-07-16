# Instructions for set up

* Clone the repository to your local system
* Once the repository is cloned, we need to build docker images. For this, run the below comand inside aspire folder (This might take a while):
```shell
docker compose build
```
* Once the docker images are built, run the below command to start rails server along with db server inside docker:
```shell
docker compose up
```
* Run migrations to create tables in development environment
```shell
docker compose run app rake db:migrate
```
After this, we should be able to hit the APIs in development environment

* Run migrations in test environment
```shell
docker compose run app rake db:migrate RAILS_ENV=test
```
After this, we should be able to run tests
