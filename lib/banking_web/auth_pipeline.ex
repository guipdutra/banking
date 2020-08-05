defmodule Banking.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :banking,
    module: Banking.Auth,
    error_handler: Banking.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
