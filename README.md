# Capistrano::Parcel

Simple building tool inspired by Python's Parcel, just written in Ruby and with many improvements.

Parcel is taking advantage of Capistrano and SSHkit.

Basic scenario expects few categories of servers:

  * build - for each distribution you can have one
  * staging
  * production

For each category you can you different settings (ssh keys, user account, etc.)

This will build package on remote server and transfer package back to your machnine (over `scp`)

```
$ cap build parcel
```