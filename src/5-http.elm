import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Json
import Task

main =
  Html.program
    { init = init "cats"
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

-- MODEL
type alias Model =
  { topic: String
  , gifUrl: String
  , errorMessage: String
  }

init: String -> (Model, Cmd Msg)
init topic =
  ( Model topic "waiting.gif" ""
  , getRandomGif topic
  )

-- UPDATE

type Msg
  = MorePlease
  | NewTopic String
  | FetchSucceed String
  | FetchFail Http.Error

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    MorePlease ->
      (model, getRandomGif model.topic)

    NewTopic newTopic ->
      let
        model = { model | topic = newTopic}
      in
        (model, Cmd.none)

    FetchSucceed newUrl ->
      (Model model.topic newUrl "", Cmd.none)

    FetchFail error ->
      let
        message =
          case error of
            Http.Timeout ->
              "Timeout Error"
            Http.NetworkError ->
              "Network Error"
            Http.UnexpectedPayload s ->
              s
            Http.BadResponse code s ->
              s
        model = {model | errorMessage = message }
      in
        (model, Cmd.none)

-- VIEW
view : Model -> Html Msg
view model  =
  div []
  [ h2 [] [text model.topic]
  , button [onClick MorePlease] [ text "More Please"]
  , input [type' "topic", placeholder "New Topic", onInput NewTopic ][]
  , h3 [] [ text model.errorMessage ]
  , select []
    [ option [][]
    ]
  , br [] []
  , img [src model.gifUrl] []
  ]

-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none

-- HTTP
getRandomGif : String -> Cmd Msg
getRandomGif topic =
  let
    url =
      "http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ topic

      -- Pretend Bad URL
      --"http://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC___&tag=" ++ topic
  in
    Task.perform FetchFail FetchSucceed (Http.get decodeGifUrl url)

decodeGifUrl : Json.Decoder String
decodeGifUrl =
  Json.at ["data", "image_url"] Json.string