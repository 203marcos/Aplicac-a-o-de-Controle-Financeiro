defmodule TrabalhoAv3Web.Router do
  use TrabalhoAv3Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TrabalhoAv3Web.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug CORSPlug
  end

  pipeline :api_auth do
    plug TrabalhoAv3Web.Auth.Pipeline
  end

  scope "/", TrabalhoAv3Web do
    pipe_through :browser

    #get "/", PageController, :home
    #post "/login", AuthController, :login
    #resources "/users", UserController, except: [:new, :edit]
  end

  scope "/api", TrabalhoAv3Web do
    pipe_through :api

    post "/login", SessionController, :create
    resources "/users", UserController, except: [:new, :edit]
    get "/users/:id/tags", UserController, :tags
    resources "/tags", TagController, except: [:new, :edit]
    get "/tags/:id/transacoes", TagController, :transacoes
    get "/tags/:iduser", TagController, :tags_by_user

    # Rotas protegidas por JWT
    scope "/" do
      pipe_through :api_auth

      resources "/transacoes", TransacaoController, except: [:new, :edit]
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:trabalhoAv3, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TrabalhoAv3Web.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
