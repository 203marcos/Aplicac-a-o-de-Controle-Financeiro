defmodule TrabalhoAv3Web.Auth.Guardian do
  use Guardian, otp_app: :trabalhoAv3

  alias TrabalhoAv3.Accounts

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_user!(id) do
      user -> {:ok, user}
      _ -> {:error, :not_found}
    end
  end
end

defmodule TrabalhoAv3Web.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :trabalhoAv3,
    module: TrabalhoAv3Web.Auth.Guardian,
    error_handler: TrabalhoAv3Web.Auth.ErrorHandler

  plug Guardian.Plug.VerifyHeader, scheme: "Bearer"
  plug Guardian.Plug.LoadResource, allow_blank: false
end
