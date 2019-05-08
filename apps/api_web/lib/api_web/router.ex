defmodule ApiWeb.Router do
  use ApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug ApiWeb.Plugs.EnsureAuthenticatedPlug
    plug ApiWeb.Plugs.FetchUserPlug
  end

  pipeline :fetch_available_user do
    plug Guardian.Plug.Pipeline,
      module: Api.Guardian,
      error_handler: Api.Guardian.AuthErrorHandler

    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource, allow_blank: true
    plug ApiWeb.Plugs.FetchAvailableUserPlug
    plug ApiWeb.Plugs.ReformatParamsPlug
  end

  # auth required
  scope "/api", ApiWeb do
    pipe_through [:api, :authenticated]

    get "/me", UserController, :me
    get "/me/teams", TeamController, :get_my_teams
    get "/me/notifications", InvitationController, :index

    # teams
    post "/teams", TeamController, :create
    patch "/teams/:id", TeamController, :update
    put "/teams/:id", TeamController, :update
    delete "/teams/:id", TeamController, :delete
    post "/teams/add_game", TeamController, :add_new_game
    # end of teams

    # create new invitation
    post "/team/:id/invitation/", InvitationController, :create
    # accepts an invitation
    patch "/team/:id/invitation/:id/accept", InvitationController, :accept_invitation
    # deletes an invitation
    delete "/team/:id/invitation/:id/cancel", InvitationController, :delete_invitation
    # reject an invitation
    patch "/team/:id/invitation/:id/reject", InvitationController, :reject_invitation

    scope "/profile" do
      get "/owned_games", ProfileController, :get_owned_games
      post "/owned_games", ProfileController, :add_owned_games
      post "/set_avatar", UserController, :set_avatar

      get "/games", ProfileController, :get_available_games
    end
  end

  # auth not required
  scope "/api" do
    pipe_through :api

    forward "/graphql", Absinthe.Plug, schema: ApiWeb.Schema

    if Mix.env() == :dev do
      forward(
        "/graphiql",
        Absinthe.Plug.GraphiQL,
        schema: ApiWeb.Schema,
        context: %{pubsub: ApiWeb.Endpoint}
      )
    end

    # thirdparty
    scope "/auth" do
      pipe_through :fetch_available_user
      post "/:provider", AuthController, :callback
    end

    # authentication
    post "/login", UserController, :login
    post "/register", UserController, :register

    # teams
    get "/teams", TeamController, :index
    get "/teams/:tag", TeamController, :show

    # user
    patch "/user", UserController, :update
    put "/user", UserController, :update
    get "/profile/:uuid", UserController, :show

    # games
    get "/games", GameController, :show
    # find players
    get "/players", UserController, :index
  end
end
