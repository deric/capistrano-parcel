# Capistrano::Parcel

Simple building tool inspired by Python's Parcel, just written in Ruby and with many improvements.

Parcel is taking advantage of [Capistrano 3](https://github.com/capistrano/capistrano), [SSHkit](https://github.com/capistrano/sshkit) and [FPM](https://github.com/jordansissel/fpm).

The idea is simple:

  * we want to deploy native packages packed with all dependencies
  * updating N production servers with `git pull` + package dependencies doesn't scale well
  * package should be tested before going to production


Project structure looks like this:

```
├── lib
├── config
│   ├── deploy
│   │   ├── build.rb
│   │   ├── production.rb
│   │   └── staging.rb
│   └── deploy.rb
├── Capfile
├── Gemfile
├── Gemfile.lock

```
In `Capfile` we specify which plugins should be used during package making process.

Capfile: (note: we're not using standard Capistrano `deploy` task)
```ruby
# Load DSL and Setup Up Stages
require 'capistrano/setup'
require 'capistrano/parcel'
# build package with fpm
require 'capistrano/parcel/fpm'
```

Basic scenario expects few categories of servers:

  * build - for each distribution you can have one
  * staging
  * production

For each category you can you different settings (ssh keys, user account, etc.)

This will build package on remote server and transfer package back to your machnine (over `scp`)

```
$ cap build parcel
```

## Installation

requirements:

  * some version of Ruby
  * Bundler (`gem install bundler`)

Create a `Gemfile` with following content:

```ruby
source 'https://rubygems.org'

gem 'capistrano-parcel', github: 'deric/capistrano-parcel'
```

and run `bundle install`