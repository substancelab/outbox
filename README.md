# Outbox

## Configuration

### HTTP Basic Authentication

The web UI can be protected with HTTP Basic authentication by setting both environment variables:

```
HTTP_BASIC_AUTH_USERNAME=<username>
HTTP_BASIC_AUTH_PASSWORD=<password>
```

When either variable is absent, Basic authentication is disabled and the application is publicly accessible.

The API endpoints (e.g. `POST /send/message`) are not affected by this setting — they use API key authentication instead.

---

# Substance Lab Rails Application Boilerplate

A solid foundation for how we want to build Rails applications anno 2026.

## Features

* RSpec tests
* View Components
* Vite for Javascript assets
* Stimulus for clientside interactions
* Turbo for serverside interactions
* Tailwind for styling
* Flowbite as a UI kit via flowbite-components
* Rubocop with Substance Lab Style
* Solid Queue for background jobs
>>>>>>> fc5ff803c697ff3acd4ca1bec4df1a2aa733ac09

## How to use this repository?

1. `cd path/to/where/you/want/the/new/app`
2. `export NEW_APP_NAME=<name of app>`
3. `git clone git@github.com:substancelab/rails-boilerplate.git $NEW_APP_NAME`
4. `cd $NEW_APP_NAME`
5. `rm -rf .git .circleci`
6. Replace all occurrences of "Boilerplate" with YourAppName": `find . -type f -print0 | xargs -0 sed -i '' 's/Boilerplate/YourAppName/g'`
7. Replace all occurrences of "boilerplate" with "your_app_name": `find . -type f -print0 | xargs -0 sed -i '' 's/boilerplate/your_app_name/g'`
8. `mv README_APP.md README.md`
9. `rm -rf script/boilerplate`

... and you're off to the races.

Typical next steps:

### Set up the new repo

1. `git init`
2. `git remote add origin GIT_REMOTE`
3. `git add .`
4. `git commit -m "Initial import from rails-boilerplate"`
5. `git push --set-upstream origin main`

### Set up the application

1. `cp config/database.yml.example config/database.yml` # edit as necessary
2. `script/setup`
