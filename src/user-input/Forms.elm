import Html exposing(..)
import Html.App as Html
import Html.Attributes exposing(..)
import Html.Events exposing(onInput)

main =
  Html.beginnerProgram {model = model, view = view, update = update}

-- MODEL
type alias Model =
  { name: String
  , password: String
  , passwordAgain: String
  }

model: Model
model =
  Model "" "" ""

-- UPDATE
type Msg
  = Name String
  | Password String
  | PasswordAgain String

update: Msg -> Model -> Model
update msg model =
  case msg of
    Name name ->
      { model | name = name}
    Password password ->
      { model | password = password }
    PasswordAgain passwordAgain ->
      { model | passwordAgain = passwordAgain}

-- VIEW
view: Model -> Html Msg
view model =
  div[]
  -- type' escaping the keyword "type" so type' is function
  [ input [type' "text", placeholder "Name", onInput Name ][]
  , input [type' "password", placeholder "Password", onInput Password ][]
  , input [type' "password", placeholder "Password Again", onInput PasswordAgain ][]
  , viewValidation model
  ]

viewValidation: Model -> Html msg
viewValidation model =
  let
    (color, message) =
      if model.password == model.passwordAgain then
        ("green", "OK")
      else
        ("red", "Password do not match!")
  in
    div [style[("color", color)]] [text message]