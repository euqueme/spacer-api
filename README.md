<!-- place all the badges here -->
![release badge](https://img.shields.io/github/v/release/euqueme/spacer-api)
![license badge](https://img.shields.io/github/license/euqueme/spacer-api)
![followers](https://img.shields.io/github/followers/euqueme?style=social)
![stars](https://img.shields.io/github/stars/euqueme/spacer-api?style=social)

# Spacer Repetition API

[live version](https://spacer-repetition-api.herokuapp.com/v1)

This is the backend for a flashcards application that uses the
[spaced memorization technique](https://en.wikipedia.org/wiki/Spaced_repetition).

Here the [live version for the frontend]().

## Table of contents

- [Requirements](https://github.com/euqueme/spacer-api#requirements)
- [Setup](https://github.com/euqueme/spacer-api#setup)
- [Collaboration](https://github.com/euqueme/spacer-api#collaboration)
- [License](https://github.com/euqueme/spacer-api#license)
- [Contributors](https://github.com/euqueme/spacer-api#contributors)

## Requirements

- [Ruby](https://www.ruby-lang.org/en/) (2.6.5)
- [Bundler](https://bundler.io/v2.1/#getting-started) (~> 2.1.4)
- [Yarn](https://yarnpkg.com/getting-started/install) (~> 1.22.4)
- [SQLite3](https://www.sqlite.org/index.html) (~> 3.28)
- [Node](https://nodejs.org/en/) (~> v14.5.0)

## Setup

First, clone (or fork) this repository.

```sh
git clone https://github.com/euqueme/spacer-api.git && cd spacer-api
```

Then, install the dependencies.

```sh
bundle install && yarn install --check-files
```

Once you are done with the previous steps, create the database tables.

```sh
rails db:migrate
```

To start the server locally and make some API requests run `rails s`, after that
you will have the API base URI as
[localhost at port 3000](http://localhost:3000), to learn how to use the
endpoints you should
[read the wiki](https://github.com/euqueme/spacer-api/wiki).

## Collaboration

To collaborate to this project first fork the repository, after that, create a
new branch based on
[develop](https://github.com/euqueme/spacer-api/tree/Development)
(using [Git-flow](https://nvie.com/posts/a-successful-git-branching-model/)
is recommended), push your branch to your forked repository and create a PR
(Pull Request) from your branch to the develop branch of the original
repository.

## License

Specify the license. You can [read the license here](LICENSE).

## Contributors

- [euqueme](https://github.com/euqueme)
- [santiago-rodrig](https://github.com/santiago-rodrig)

