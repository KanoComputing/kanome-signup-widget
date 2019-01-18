module MainTest exposing (flagsTest, signupTest, validateCredentials)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Json.Decode as Decode
import Json.Encode as Encode
import Main exposing (..)
import Test exposing (..)


flagsTest : Test
flagsTest =
    describe "init flags"
        [ test "init flags returns nothing" <|
            \_ ->
                let
                    nothingFlags =
                        Nothing

                    ( initNothing, _ ) =
                        init nothingFlags
                in
                Expect.equal initNothing.flags initFlags
        , test "init returns custom flags" <|
            \_ ->
                let
                    okFlags =
                        Flags "star wars" "kano" "test" "button" True

                    ( initOK, _ ) =
                        init <| Just okFlags
                in
                Expect.equal initOK.flags okFlags
        ]


signupTest : Test
signupTest =
    describe "test encoder and decoder"
        [ test "conversion between signupDecoder/signupEncoder" <|
            \_ ->
                let
                    signup =
                        Signup "test@test.com" True

                    json =
                        signupEncoder signup

                    decoded =
                        Decode.decodeValue signupDecoder json
                in
                Decode.decodeValue signupDecoder json
                    |> Expect.equal
                        (Ok signup)
        ]


validateCredentials : Test
validateCredentials =
    describe "Email test"
        [ test "Test that model accepts valid credentials" <|
            \_ ->
                let
                    credential =
                        "test@test.com"

                    model =
                        initModel initFlags

                    model_ =
                        { model | email = credential }

                    validated =
                        validateEmail model_
                in
                validateEmail model_
                    |> Expect.equal ValidationOK
        ]
