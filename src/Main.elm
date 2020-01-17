module Main exposing (..)

import Browser
import Browser.Events exposing (onKeyDown)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode
import Misc exposing (..)
import String
import Time exposing (Month(..), Weekday(..))
import Time.Extra exposing (Interval(..), Parts)



---- MODEL ----


type alias JsonHoliday =
    { id : String
    , name : String
    }


type alias Holiday =
    { id : Parts
    , name : String
    }


type alias Model =
    { year : Int
    , holidays : List Holiday
    }


init : List JsonHoliday -> ( Model, Cmd Msg )
init jholidays =
    let
        getHoliday jh =
            Holiday (getTimeParts jh.id) jh.name

        holidays =
            List.map getHoliday jholidays
    in
    ( Model 2019 holidays, Cmd.none )



---- UPDATE ----


type Msg
    = Increment
    | Decrement
    | None


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Decrement ->
            ( { model | year = model.year - 10 }, Cmd.none )

        Increment ->
            ( { model | year = model.year + 10 }, Cmd.none )

        _ ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


keyDecoder : Decode.Decoder Msg
keyDecoder =
    let
        toKey string =
            case string of
                "ArrowLeft" ->
                    Decrement

                "ArrowRight" ->
                    Increment

                _ ->
                    None
    in
    Decode.map toKey (Decode.field "key" Decode.string)


subscriptions : Model -> Sub Msg
subscriptions model =
    onKeyDown keyDecoder



---- VIEW ----


viewDay year month day =
    let
        klass =
            case getNumOfWeekday year month day of
                Sat ->
                    "saturday"

                Sun ->
                    "sunday"

                _ ->
                    ""

        daystr =
            case day of
                0 ->
                    ""

                _ ->
                    String.fromInt day
    in
    td [ class "day", class klass ] [ text daystr ]


viewMonth year month =
    let
        weeks =
            getWeeks year month

        viewWeek w =
            tr [] (List.map (viewDay year month) w)
    in
    div [ class "month" ]
        [ table [ class "mtable" ]
            (weeks |> List.map viewWeek)
        , h1 [ class "mbg" ] [ text (month |> monthToNum |> String.fromInt) ]
        ]


viewYear year =
    div []
        [ h5 [ class "yheader" ]
            [ text (String.fromInt year)
            ]
        , div []
            (List.map
                (viewMonth year)
                months
            )
        , hr [] []
        ]


view : Model -> Html Msg
view model =
    div []
        [ div []
            (let
                years =
                    List.range model.year (model.year + 10)
             in
             List.map viewYear years
            )
        ]


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }
