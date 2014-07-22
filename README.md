# Wechat::Adapter

[![Build Status](https://travis-ci.org/luj1985/wechat-adapter.svg?branch=master)](https://travis-ci.org/luj1985/wechat-adapter)
[![Gem Version](https://badge.fury.io/rb/wechat-adapter.svg)](http://badge.fury.io/rb/wechat-adapter)
[![Coverage Status](https://coveralls.io/repos/luj1985/wechat-adapter/badge.png)](https://coveralls.io/r/luj1985/wechat-adapter)

A wrapper for Tencent Wechat JSON API, currently only "menu" operation are tested, others should work also.

## Installation

Add this line to your application's Gemfile:

    gem 'wechat-adapter'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wechat-adapter

## Usage

```ruby
require 'wechat/adapter'

appid = "wxb3fae34df644fbf7"
appsecret = "d0aae6a89949c8c789068397f9e1c59c"
api = WechatAPI.new(appid, appsecret)

api.get 'menu/get'
```
