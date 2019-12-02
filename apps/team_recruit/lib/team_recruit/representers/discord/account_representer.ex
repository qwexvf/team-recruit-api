defmodule TeamRecruit.Representer.DiscordRepresenter do
  use TeamRecruit.Representer.Map

  property :provider
  property :email
  property :name, as: :username
  property :avatar
  property :uid, as: :id
end