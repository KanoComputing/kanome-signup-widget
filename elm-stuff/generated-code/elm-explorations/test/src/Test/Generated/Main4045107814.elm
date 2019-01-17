module Test.Generated.Main4045107814 exposing (main)

import MainTest

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "MainTest" [MainTest.signupMain,
    MainTest.testMain] ]
        |> Test.concat
        |> Test.Runner.Node.run { runs = Nothing, report = (ConsoleReport UseColor), seed = 124954017385931, processes = 4, paths = ["/Users/natasharamburrun/kano/elm-widget/tests/MainTest.elm"]}