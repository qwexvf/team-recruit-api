defmodule TeamRecruitWeb.AuthController do
  use TeamRecruitWeb, :controller

  alias TeamRecruit.Accounts
  alias TeamRecruit.Accounts.User
  alias TeamRecruit.Guardian

  action_fallback TeamRecruitWeb.FallbackController

  def register(conn, params) do
    with {:ok, %User{} = user} <- Accounts.create_user(params["user"]),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      render(conn, "authenticated_user.json", %{token: token, user: user})
    end
  end

  def login(conn, %{"user" => params}) do
    with %User{} = user <- Accounts.get_user_by_email!(params["email"]),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      render(conn, "authenticated_user.json", %{token: token, user: user})
    end
  end
end