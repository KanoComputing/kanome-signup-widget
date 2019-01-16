module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Attribute, Html, a, button, div, fieldset, form, h1, h2, h4, input, label, p, pre, section, text, textarea)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode
import Json.Encode as Encode


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }


init : Maybe Flags -> ( Model, Cmd Msg )
init flags =
    case flags of
        Nothing ->
            ( initModel initFlags, Cmd.none )

        Just flags_ ->
            ( initModel flags_, Cmd.none )



-- MODEL


type alias Flags =
    { campaign : String
    , title : String
    , description : String
    , button : String
    , checkbox : Bool
    }


initFlags : Flags
initFlags =
    Flags "newsletter" "Sign up for Kano updates" "You'll also receive the latest news, offers and projects straight to your inbox." "SIGN ME UP" False


type alias Model =
    { flags : Flags
    , email : String
    , notifications : Bool
    , validationResults : ValidationResults
    , error : String
    }


type alias Signup =
    { email : String
    , notifications : Bool
    }


type ValidationResults
    = Null
    | Error String
    | ValidationOK


initModel : Flags -> Model
initModel flags =
    Model flags "" False Null ""


signupEncoder : Signup -> Encode.Value
signupEncoder signup =
    Encode.object
        [ ( "email", Encode.string signup.email )
        , ( "notifications", Encode.bool signup.notifications )
        ]


modelToJson : Model -> String
modelToJson model =
    let
        signup =
            Signup model.email model.notifications
    in
    Encode.encode 2 (signupEncoder signup)


signupDecoder : Decode.Decoder Signup
signupDecoder =
    Decode.map2 Signup
        (Decode.field "email" Decode.string)
        (Decode.field "notification" Decode.bool)



-- UPDATE


type Msg
    = Email String
    | ToggleNotifications
    | Submit
    | Submitted (Result Http.Error String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Email newEmail ->
            ( { model | email = newEmail }, Cmd.none )

        ToggleNotifications ->
            ( { model | notifications = not model.notifications }, Cmd.none )

        Submit ->
            ( { model | validationResults = validateEmail model }, Cmd.none )

        Submitted (Ok _) ->
            ( initModel model.flags, Cmd.none )

        Submitted (Err _) ->
            ( { model | error = "Oops, there is an error, please try again later." }, Cmd.none )


createPostRequest : Signup -> Cmd Msg
createPostRequest signup =
    Http.post
        { body = Http.jsonBody <| signupEncoder signup
        , expect = Http.expectString Submitted
        , url = "/api/signup"
        }



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


viewTitle : Model -> Html Msg
viewTitle model =
    let
        flags =
            model.flags
    in
    div [ class "column is-mobile" ]
        [ div [ class "field" ]
            [ h1 [ class "newsletter-headline" ]
                [ text flags.title ]
            , h4 [ class "newsletter-subheadline" ]
                [ text flags.description ]
            ]
        ]


viewSignupContent : Model -> Html Msg
viewSignupContent model =
    let
        flags =
            model.flags
    in
    div [ class "column is-mobile" ]
        [ div [ class "field" ]
            [ div [ class "newsletterSubmission" ]
                [ div [ class "formInput" ]
                    [ viewValidation model
                    , viewSubmission model.error
                    , input [ type_ "hidden", name "campaign", value flags.campaign ] []
                    , input [ class "input email", name "email", placeholder "Enter your email", value model.email, onInput Email ] []
                    , button [ class "button", onClick Submit ]
                        [ text flags.button ]
                    ]
                ]
            , case flags.checkbox of
                True ->
                    div [ class "consent-checkbox" ]
                        [ input [ class "checkbox", type_ "checkbox", name "opt_in", id "opt_in", onClick ToggleNotifications ] []
                        , label [ attribute "for" "opt_in" ]
                            [ text "By ticking here you are opting-in to receive the latest news, offers, promotions and competitions from Kano. "
                            , a [ href "https://kano.me/privacy-policy/uk" ] [ text "Take a peak " ]
                            , text "at how we are using your data."
                            ]
                        ]

                False ->
                    text ""
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


viewSubmission : String -> Html Msg
viewSubmission error =
    text error
