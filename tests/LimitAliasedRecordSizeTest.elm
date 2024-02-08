module LimitAliasedRecordSizeTest exposing (all)

import LimitAliasedRecordSize exposing (maxRecordSize, rule)
import Review.Test
import Test exposing (Test, describe, test)


all : Test
all =
    describe "LimitAliasedRecordSize"
        [ test "should not report an error when there are not many fields" <|
            \() ->
                """module A exposing (..)

type alias MyRecord =
    { oneField : Int
    , anotherField : String
    , yetAnotherField : Bool
    }
"""
                    |> Review.Test.run (rule (maxRecordSize 3))
                    |> Review.Test.expectNoErrors
        , test "should report an error when there are too many fields" <|
            \() ->
                """module A exposing (..)


type alias MyRecord = {
    oneField : Int
    , anotherField : String
    , yetAnotherField : Bool
    , andAnotherField : Int
    , andAnotherField2 : Int
    , andAnotherField3 : Int
    , andAnotherField4 : Int
    , andAnotherField5 : Int
    , andAnotherField6 : Int
    , andAnotherField7 : Int
    , andAnotherField8 : Int
    , andAnotherField9 : Int
    , andAnotherField10 : Int
    , andAnotherField11 : Int
    , andAnotherField12 : Int
    , andAnotherField13 : Int
}
"""
                    |> Review.Test.run (rule (maxRecordSize 3))
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Type alias `MyRecord` has 16 fields, which exceeds the maximum of 3."
                            , details =
                                [ "Type aliases with too many fields can cause performance issues at compile time."
                                , "Consider changing the alias to a custom type, e.g. type MyRecord = MyRecord { ... }"
                                ]
                            , under = "MyRecord"
                            }
                        ]
        , test "should report an error when there are too many fields in an extensible record" <|
            \() ->
                """module A exposing (..)

type alias MyRecord a =
    { a
        | oneField : Int
        , anotherField : String
        , yetAnotherField : Bool
        , andAnotherField : Int
        , andAnotherField2 : Int
        , andAnotherField3 : Int
        , andAnotherField4 : Int
        , andAnotherField5 : Int
        , andAnotherField6 : Int
        , andAnotherField7 : Int
        , andAnotherField8 : Int
        , andAnotherField9 : Int
        , andAnotherField10 : Int
        , andAnotherField11 : Int
        , andAnotherField12 : Int
        , andAnotherField13 : Int
    }
"""
                    |> Review.Test.run (rule (maxRecordSize 3))
                    |> Review.Test.expectErrors
                        [ Review.Test.error
                            { message = "Type alias `MyRecord` has 16 fields, which exceeds the maximum of 3."
                            , details =
                                [ "Type aliases with too many fields can cause performance issues at compile time."
                                , "Consider changing the alias to a custom type, e.g. type MyRecord = MyRecord { ... }"
                                ]
                            , under = "MyRecord"
                            }
                        ]
        , test "should not report an error when there are a lot of fields but the max is higher" <|
            \() ->
                """module A exposing (..)


type alias MyRecord = {
    oneField : Int
    , anotherField : String
    , yetAnotherField : Bool
    , andAnotherField : Int
    , andAnotherField2 : Int
    , andAnotherField3 : Int
    , andAnotherField4 : Int
    , andAnotherField5 : Int
    , andAnotherField6 : Int
    , andAnotherField7 : Int
    , andAnotherField8 : Int
    , andAnotherField9 : Int
    , andAnotherField10 : Int
    , andAnotherField11 : Int
    , andAnotherField12 : Int
    , andAnotherField13 : Int
}
"""
                    |> Review.Test.run (rule (maxRecordSize 16))
                    |> Review.Test.expectNoErrors
        , test "should not report an error when the alias isn't a record" <|
            \() ->
                """module A exposing (..)

type alias MyRecord = ( Int, String, Bool )
"""
                    |> Review.Test.run (rule (maxRecordSize 2))
                    |> Review.Test.expectNoErrors
        ]
