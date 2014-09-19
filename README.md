# Tangocard

Ruby Wrapper for Tango Card RaaS API.

Tango Card provides a RaaS API for developers (https://github.com/tangocarddev/RaaS). This gem provides commonsense Ruby
objects to wrap the JSON endpoints of the RaaS API.

## Information

* RDoc documentation [available on RubyDoc.info](http://rubydoc.info/github/bonusly/tangocard/master/frames)
* Source code [available on GitHub](https://github.com/bonusly/tangocard)

## Getting Help

* Please report bugs on the [issue tracker](https://github.com/bonusly/tangocard/issues)

## Installation

Add the `tangocard` gem to your `Gemfile`:

```
gem 'tangocard'
```

Create an initializer, e.g. `config/initializers/tangocard.rb`:

```
Tangocard.configure do |c|
  c.name = "BonuslyXYZ"
  c.key = "Dnv9ehvff29"
  c.base_uri = "https://sandbox.tangocard.com"
end
```

There are three required configuration parameters:

 * `name` - The API account name you receive from Tango Card
 * `key` - The API account key you receive from Tango Card
 * `base_uri` - This defaults to the Tango Card sandbox.  For production, you must specify the base URI for the production RaaS API. Make sure not to include any trailing slashes.

There are also three optional configuration parameters:

 * `default_brands` - An array of strings for the brands you want to retrieve with `Tangocard::Brand.default_brands`. The strings should match the unique brand `description` fields exactly.
 * `local_images` - An array of local image names/URIs that you want to display instead of the default Tango Card-provided `image_url`. `image_url` is sometimes blank, so this can be handy in those cases.
 * `sku_blacklist` - Reward SKUs that are blacklisted, ie. should never be returned as a purchasable reward.

## Getting Started

This gem provides two tools:

1. A simple wrapper for the Tango Card RaaS API, consisting of two classes: `Tangocard::Raas` and `Tangocard::Response`.
2. Models for each of the Tango Card objects: `Tangocard::Account`, `Tangocard::Brand`, `Tangocard::Reward`, and `Tangocard::Order`. These provide a greater level of abstraction and ease of use.

## Notes and Credits

This project is developed and maintained by Smartly, Inc. - makers of http://bonus.ly.

This project uses the MIT-LICENSE.
