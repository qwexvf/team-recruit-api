defmodule Api.Representer do
  alias Api.Representer.{
    SteamRepresenter,
    GoogleRepresenter,
    TwitterRepresenter,
    DiscordRepresenter,
    LocalRepresenter
  }

  alias Api.Representer.{
    SteamStruct,
    GoogleStruct,
    TwitterStruct,
    DiscordStruct,
    LocalStruct
  }

  def to_map(params) do
    params["provider"]
    |> String.to_atom()
    |> to_map(params)
  end

  def to_map(:local, profile) do
    LocalRepresenter.to_map(profile, as: %LocalStruct{})
  end

  def to_map(:steam, profile) do
    SteamRepresenter.to_map(profile, as: %SteamStruct{})
  end

  def to_map(:google, profile) do
    GoogleRepresenter.to_map(profile, as: %GoogleStruct{})
  end

  def to_map(:twitter, profile) do
    TwitterRepresenter.to_map(profile, as: %TwitterStruct{})
  end

  def to_map(:discord, profile) do
    DiscordRepresenter.to_map(profile, as: %DiscordStruct{})
  end
end
