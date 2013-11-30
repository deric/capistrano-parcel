# Capistrano::Parcel

Distributed building tool, originally inspired by Python's Parcel, just written in Ruby and with many improvements. Parcel is taking advantage of [Capistrano 3](https://github.com/capistrano/capistrano), [SSHkit](https://github.com/capistrano/sshkit) and [FPM](https://github.com/jordansissel/fpm).

The idea is simple:

  * we want to deploy native packages packed with all dependencies
  * support multiple releases/distribution
  * fast and reliable deployment
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

### Build process

Each phase is a separate Rake task. You can use `before` and `after` hooks to execute any code before/after.

 1. starting
 2. updating
 3. compiling
 4. packaging
 5. finishing


### Plugins

Plugins are usually simple tasks that are executed in several steps during building process. Plugins can't rely on each other, rather use variables, that are accessible with `set(:var)` and for reading `fetch(:var)`.

Each plugin can be enabled in `Capfile`:

```ruby
require 'capistrano/parcel/plugin_name'
```

#### fpm

Used for packaging whole directory as a deb package. Could be used also for RPM or other packages.

#### uwsgi

Simple application server configuration.

Enable with:

```ruby
require 'capistrano/parcel/uwsgi'
```

#### nginx

Currently allows only intialization of nginx scripts.

Enable with:

```ruby
require 'capistrano/parcel/nginx'
```
#### supervisor

(experimental)

#### virtualenv

(experimental)


### Package metadata

Meta information about package is fetched from a `package.yml` file which must be located on local filesystem (in directory where is `cap` command executed).

```yml
version: '0.0.1'
arch: 'all'
license: 'MIT'
category: 'misc'
maintainer: 'john.doe@example.com'
vendor: 'Jon Doe et al.'
description: 'Package description'
url: 'http://example.com'
```


## Installation

requirements:

  * some version of Ruby (> 1.8.7 is recommended)
  * Bundler (`gem install bundler`)

Create a `Gemfile` with following content:

```ruby
source 'https://rubygems.org'

gem 'capistrano-parcel', github: 'deric/capistrano-parcel'
```

and run `bundle install`
