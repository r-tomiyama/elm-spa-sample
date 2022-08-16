module Pages.Home_ exposing (Model, Msg, page)

import Gen.Params.Home_ exposing (Params)
import Html exposing (a, p, text)
import Html.Attributes exposing (href)
import Page
import Request
import Shared
import Task
import Time
import View exposing (View)


page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init
        , update = update
        , view = view shared
        , subscriptions = subscriptions
        }



-- INIT


type alias Model =
    { timeMaybe : Maybe Time.Posix }


init : ( Model, Cmd Msg )
init =
    ( { timeMaybe = Nothing
      }
    , Task.perform GotTime Time.now
    )



-- UPDATE


type Msg
    = GotTime Time.Posix


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotTime posix ->
            ( { model | timeMaybe = Just posix }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


toTimeText : Time.Zone -> Time.Posix -> String
toTimeText zone posix =
    let
        hourText =
            String.fromInt <| Time.toHour zone posix

        minutesText =
            String.fromInt <| Time.toMinute zone posix

        secondsText =
            String.fromInt <| Time.toSecond zone posix
    in
    hourText ++ ":" ++ minutesText ++ ":" ++ secondsText


view : Shared.Model -> Model -> View Msg
view shared model =
    { title = "Shared Test"
    , body =
        [ p [] [ text "home" ]
        , case model.timeMaybe of
            Just time ->
                p [] [ text <| toTimeText shared.timezone time ]

            Nothing ->
                text ""
        ]
    }
