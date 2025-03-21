# Rails-App-Vue3

## Introduction

This is an experimental SPA using Vite Ruby(include Ruby on Rails 7) with Vue 3, it may be the template repo for further development for Full-stack project.

## Features
1. Basic Token Based (JWT) Authentication

(To be added for further development...)

## Technical information

### Backend

#### Database

**PostgreSQL 15** is used on this repo

#### Ruby

**Ruby 3.2.7** is used on this repo

#### Rails

**Rails 7.2** is used on this repo

### Frontend

#### Javascript Framework

**Vue 3.3.4** is used on this repo

#### CSS Framework

**TailwindCSS 3.3.3** is used on this repo

## Others

**Pinia** and **Vue-router 4** are used on this repo

## Setup the environment on Docker

### Prerequisites

1. [Docker Desktop](https://docs.docker.com/get-started/get-docker/).

2. [Git client](https://git-scm.com/downloads).

3. IDE or a text editor to edit files. Docker recommends using [Visual Studio Code](https://code.visualstudio.com/).

### Initialization

1. Clone this repo by Github using command line prompt:

```bash
git clone https://github.com/southparkstan123/book-store-vue3.git
```

2. Environment variables

You can add the .env files to store the configuration value for different environments , the example file is in ```.env.template```, just copy this file for specific environment, for example ```.env.development.local``` file. 

**Caution!!!**

**Avoid to commit the ```.env``` file which may contains the sensitive information such as API keys, credentials, etc.**


3. Run the following command to prepare the Docker image and start the PostgresSQL, Rails and Vite services:

```bash
docker-compose up --build && docker-compose exec web bundle exec vite install && docker-compose exec web bundle exec yarn install
```

or specify an env file for several environment such as ```.env.development.local```.

```bash
# depends on .env.development.local
docker compose --env-file ./.env.development.local up --build 
```

4. After create the images, migration the database by following command:
```bash
docker-compose exec web bundle exec rails db:migrate
```

5. (Optional) Seeding of a database with data by following command:
```bash
docker-compose exec web bundle exec rails db:seed
```

6. Wait a moment and access ```http://localhost:3000``` on Web browser.

### Useful commands after establish the environment:

### Start and End the container

1. Run the following command to start the app:
```bash
# depends on .env by default
docker compose up
```

or specify an env file for several environment such as ```.env.development.local```.

```bash
# depends on .env.development.local
docker compose --env-file ./.env.development.local up
```

Start the app for only certain containers and without <b>```hot modules replacement (HMR)```</b> by following command:

```bash
docker compose up postgres web
```

2. Run the following command to restart the app:
```bash
docker compose restart
```

3. Run the following command to shutdown the app:
```bash
docker compose down
```

4. Run the following command to clean up old unused builds to keep my system clean:
```bash
docker system prune --all
```

5. Run the following command to install dependencies for frontend
```bash
docker-compose exec web bundle exec yarn install 
```

#### Rails

1. Run the following command to access rails console:
```bash
docker-compose exec web bundle exec rails c
```

2. Migration the database by following command:
```bash
docker-compose exec web bundle exec rails db:migrate:<up or down> VERSION=<VERSION_WITH_DATETIME>
```

3. Rollback the migration the database by following command:
```bash
docker-compose exec web bundle exec rails db:rollback STEP=<ROLLBACK_TIMES> 
```

4. Seeding of a database with data by following command:
```bash
docker-compose exec web bundle exec rails db:seed
```

5. Run the following command to switch the application's database, such as PostgreSQL and MySQL, etc.:
```bash
docker-compose exec web bundle exec rails db:system:change --to=postgresql
# Another value such as mysql, sqlite3, etc...
```

#### Troubleshooting for refuse connect to database

**Caution: You will lose all corresponding data**

1. Clear the volumes which were created using ```docker-compose down --volumes```.

2. Run ```docker-compose up --build``` to rebuild the images for the project.

#### Database

1. Run the following command to verify the version of PostgreSQL:
```bash
docker exec my-postgres psql -V
```

2. Run the following command to show databases:
```bash
docker exec my-postgres psql -U postgres -c "\l"
```

**Remark** If you want to run the app on virtual macine such as Homestead, you must comment the key ```host``` on ```config/database.yml```:

```yml
# config/database.yml
host: <%= ENV.fetch("DATABASE_HOST") { "postgres" } %>
```

Happy Coding!!!!!
