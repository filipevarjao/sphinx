defmodule SphinxRtm.Messages.Parser do
  use Slack
  alias Sphinx.SlackUtils

  @spec mention_sphinx?(String.t()) :: boolean()
  def mention_sphinx?(text) do
    with true <- String.match?(text, ~r/^[<@](.)*[>]/) do
      [mention_id | _content] = String.split(text, ["<@", ">"], trim: true)
      is_sphinx_id?(mention_id)
    else
      false -> false
    end
  end

  @spec is_sphinx_id?(String.t()) :: boolean()
  defp is_sphinx_id?(id) do
    user_name = SlackUtils.get_user_name(id)
    String.contains?(user_name, ["sphinx"])
  end

  @spec trim_mention(String.t()) :: String.t()
  def trim_mention(text), do: String.replace(text, ~r/[<@](.)*[>]\s/, "")
end
