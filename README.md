# Order Processing System

This README provides information on setting up, configuring, and running the application.

## Table of Contents

- [Ruby Version](#ruby-version)
- [System Dependencies](#system-dependencies)
- [Configuration](#configuration)
- [Database Setup](#database-setup)
  - [Database Creation](#database-creation)
  - [Database Initialization](#database-initialization)
- [Running the Test Suite](#running-the-test-suite)

## Ruby Version

This project is built using Ruby version 3.0.0.

## System Dependencies

This application relies on the following gems:

- [dry-monads](https://github.com/dry-rb/dry-monads)
- [figaro](https://github.com/laserlemon/figaro)
- [annotate](https://github.com/ctran/annotate_models)
- [rubocop](https://github.com/rubocop/rubocop)
- [rubocop-performance](https://github.com/rubocop/rubocop-performance)
- [rubocop-rails](https://github.com/rubocop/rubocop-rails)
- [faker](https://github.com/faker-ruby/faker)

Make sure to install these gems by running:

```bash
bundle install
```

# Database Creation

To create the database, run the following commands:

```bash
rails db:create
```

# Database Initialization

To seed the database with initial data, run:

```bash
rails db:seed
```

# Running the Test Suite
