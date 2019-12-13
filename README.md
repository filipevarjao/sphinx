# Sphinx

Sphinx is a Slack bot which helps storing and presenting questions and answers.

The idea of Sphinx is that when it is invokes with `@sphinx` on Slack, it can search for past questions and give you the answered if they have been answered or stores your new questions and your peers' answer for future inquires.

Sphinx uses [Elixir-slack](https://github.com/BlakeWilliams/Elixir-Slack), please check their [documentation](http://hexdocs.pm/slack/) for Slack-related operations.

To start Sphinx, you'll need a Slack API token which can be retrieved by following the [Token Generation Instructions](https://hexdocs.pm/slack/token_generation_instructions.html) or by creating a new [bot integration](https://my.slack.com/services/new/bot) or if your Slack workspace already has one for this application, contact the responsible person for the Token.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `sphinx` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:sphinx, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/sphinx](https://hexdocs.pm/sphinx).

## Start Application

Sphinx is started automatically with `mix run --no-halt`

## Invoke Sphinx

Start the application and on Slack, make sure your channel has already have the bot installed, start message with `@sphinx` to invoke the bot.

Example:

```
@sphinx How do I open an Elixir shell?
```
