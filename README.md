# SimpleAnalytics
[![Build Status](https://secure.travis-ci.org/Djo/simple_analytics.png "Build Status")](http://travis-ci.org/Djo/simple_analytics)

*SimpleAnalytics* gem provides accessing Google Analytics Export Api. It uses Version 3.0 of the Google Core Reporting API with JSON. You can find the google documentation [here](http://code.google.com/apis/analytics/docs/gdata/v3/gdataGettingStarted.html).

## Getting Started

You can add it to your Gemfile with:

```ruby
gem 'simple_analytics'
```

Authentication using the *ClientLogin*:

```ruby
analytics = SimpleAnalytics::Api.authenticate('user@gmail.com', 'password')
```

The `authenticate` method sets an `auth_token` in the analytics service object. Then you can fetch the report data:

```ruby
analytics.fetch(
  'ids'        => 'ga:id',
  'metrics'    => 'ga:visitors',
  'dimensions' => 'ga:country',
  'start-date' => '2012-01-01',
  'end-date'   => '2012-01-10'
)
# => [["United States","24451"], ["Brazil","15616"], ["Spain","3966"]]
```

The `fetch` method sets and returns rows. Required query parameters are used to configure which data to return from the Google Analytics:

* **ids** — The profile IDs from which to access data.
* **start-date** — The beginning of the date range.
* **end-date** — The end of the date range.
* **metrics** — The numeric values to return.

For more detailed information about the parameters see [google REST docs](http://code.google.com/apis/analytics/docs/gdata/v3/exportRest.html).

## Authentication

For the authentication it uses gem [google_client_login](https://github.com/fortuity/google_client_login) based on the *ClientLogin*. You can also pass extra parameters which allows the gem (see the gem's [README](https://github.com/fortuity/google_client_login)):

```ruby
options = { :accountType => 'GOOGLE', :source => 'company-app-version' }
analytics = SimpleAnalytics::Api.authenticate('user@gmail.com', 'password', options)
```

### Authentication Token

You can set yourself the `auth_token` to use it in the fetching:

```ruby
analytics.auth_token = 'your-token-from-oauth'
```

## Example

All parameters are escaped before a request. For date format you can use the next tip: `Date.today.strftime("%Y-%m-%d")`.

```ruby
analytics = SimpleAnalytics::Api.authenticate('user@gmail.com', 'password')

analytics.fetch(
  'ids'        => 'ga:id',
  'metrics'    => 'ga:visitors',
  'dimensions' => 'ga:country',
  'start-date' => '2012-01-01',
  'end-date'   => '2012-01-10'
)
# => [["United States","24451"], ["Brazil","15616"], ["Spain","3966"]]

analytics.rows
# => [["United States","24451"], ["Brazil","15616"], ["Spain","3966"]]

analytics.body
# => returns the parsed response body (hash), where you can get other info, see google docs.

analytics.fetch(
  'ids'        => 'ga:another-id',
  'metrics'    => 'ga:visitors,ga:newVisits',
  'dimensions' => 'ga:pagePath',
  'filters'    => 'ga:pagepath=~/articles/[\w-]+\z'
  'start-date' => '2012-01-01',
  'end-date'   => '2012-01-10'
)
# => [["/articles/first-post","12", "2"], ["/articles/second-post","2", "1"]]

analytics.rows
# => [["/articles/first-post","12", "2"], ["/articles/second-post","2", "1"]]
```


## Dependencies

* Ruby 1.8.7 or later
