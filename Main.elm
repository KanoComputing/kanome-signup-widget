module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Attribute, Html, a, button, div, fieldset, form, h1, h2, h4, input, label, p, section, text)
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


viewTitle : Model -> Html Msg
viewTitle model =
    div [ class "column is-mobile" ]
        [ div [ class "field" ]
            [ h1 [ class "newsletter-headline" ]
                [ text "Sign up for Kano Updates" ]
            , h4 [ class "newsletter-subheadline" ]
                [ text "You'll also receive the latest news, offers and projects straight to your inbox." ]
            ]
        ]


viewSignupContent : Model -> Html Msg
viewSignupContent model =
    div [ class "column is-mobile" ]
        [ div [ class "field" ]
            [ div [ class "newsletterSubmission" ]
                [ div [ class "formInput" ]
                    [ viewValidation model
                    , input [ class "input email", placeholder "Enter your email", value model.email, onInput Email ] []
                    , button [ class "button", onClick Submit ]
                        [ text "SIGN ME UP" ]
                    ]
                ]
            , label [ class "checkbox-control" ]
                [ input [ class "checkbox", type_ "checkbox", onClick ToggleNotifications ] []
                , p [ class "checkbox-message" ]
                    [ text "By ticking here you are opting-in to receive the latest news, offers, promotions and competitions from Kano. "
                    , a [ href "https://kano.me/privacy-policy/uk" ]
                        [ text "Take a peak" ]
                    , p [ class "checkbox-message" ] [ text "at how we are using your data." ]
                    ]
                ]
            ]
        ]


view : Model -> Html Msg
view model =
    section
        [ class "kano-newsletter-section" ]
        [ div [ class "container is-fluid" ]
            [ div [ class "columns is-vcentered" ]
                [ viewTitle model
                , viewSignupContent model
                ]
            ]
        ]
