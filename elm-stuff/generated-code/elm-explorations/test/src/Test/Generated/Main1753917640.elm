module Test.Generated.Main1753917640 exposing (main)

import MainTest

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    [     Test.describe "MainTest" [MainTest.flagsTest,
    MainTest.signupTest,
    MainTest.validateCredentials] ]
        |> Test.concat
        |> Test.Runner.Node.run { runs = Nothing, report = (ConsoleReport UseColor), seed = 117572072934272, processes = 4, paths = ["/Users/natasharamburrun/kano/elm-widget/tests/MainTest.elm"]}