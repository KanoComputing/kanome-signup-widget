module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Attribute, Html, a, button, div, fieldset, h2, i, input, label, p, section, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)


main =
    Browser.sandbox { init = init, update = update, view = view }



-- MODEL


type alias Model =
    { title : String
    , email : String
    , notifications : Bool
    , validationResults : ValidationResults
    }


type ValidationResults
    = Null
    | Error String
    | ValidationOK


init : Model
init =
    Model "" "" False Null



-- UPDATE


type Msg
    = Title String
    | Email String
    | ToggleNotifications
    | Submit


update : Msg -> Model -> Model
update msg model =
    case msg of
        Title newTitle ->
            { model | title = newTitle }

        Email newEmail ->
            { model | email = newEmail }

        ToggleNotifications ->
            { model | notifications = not model.notifications }

        Submit ->
            { model | validationResults = validateEmail model }



-- VIEW


viewValidation : Model -> Html Msg
viewValidation model =
    case model.validationResults of
        Null ->
            p [ class "message" ] [ text "" ]

        Error message ->
            p [ class "message" ] [ text "Sorry, that email address isn't valid. Please try again." ]

        ValidationOK ->
            p [ class "message" ] [ text "Thank you for your subscription!" ]


validateEmail : Model -> ValidationResults
validateEmail model =
    if String.contains "@" model.email && String.contains "." model.email then
        ValidationOK

    else
        Error "Sorry, that email address isn't valid. Please try again."


checkbox : msg -> Html msg
checkbox model =
    label []
        [ input [ type_ "checkbox" ] []
        ]


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ div [ class "field" ]
            [ label [ class "label" ]
                [ text "Enter your email to subscribe to our newsletter" ]
            , viewValidation model
            , div [ class "control" ]
                [ input [ class "input email", placeholder "Enter your email", value model.email, onInput Email ] []
                , a [ class "icon is-small", onClick Submit ]
                    [ i [ class "fas fa-arrow-right" ] [] ]
                ]
            , label [ class "checkbox-control" ]
                [ input [ class "checkbox", type_ "checkbox", onClick ToggleNotifications ] []
                , p [ class "checkbox-message" ]
                    [ text "Tick here to receive the latest news, offers and promotions from Kano. "
                    , a [ href "https://kano.me/privacy-policy/uk" ]
                        [ text "Take a peak" ]
                    , p [ class "checkbox-message2" ] [ text "at how we are using your data. Or see our " ]
                    , a [ href "https://kano.me/terms-and-conditions/uk" ] [ text "terms and conditions." ]
                    ]
                ]
            ]
        ]
