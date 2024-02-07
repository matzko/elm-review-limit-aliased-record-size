module LimitAliasedRecordSize exposing
    ( LimitRecordSizeConfig
    , maxRecordSize
    , rule
    )

{-|


# Configuration

@docs LimitRecordSizeConfig
@docs maxRecordSize


# LimitAliasedRecordSize Rule Usage

@docs rule

-}

import Elm.Syntax.Declaration exposing (Declaration(..))
import Elm.Syntax.Node as Node exposing (Node)
import Elm.Syntax.TypeAnnotation exposing (TypeAnnotation(..))
import Review.Rule as Rule exposing (Rule)


{-| Configure the rule in your `elm-review` configuration:

    import LimitAliasedRecordSize
    import Review.Rule exposing (Rule)

    config : List Rule
    config =
        [ LimitAliasedRecordSize.rule
            (20 |> LimitAliasedRecordSize.maxRecordSize)
        ]


## Examples


### ✅ Good: not too many fields

    type alias MyRecord =
        { oneField : Int
        , anotherField : String
        , yetAnotherField : Bool
        }


### ❌ Bad: too many fields

    type alias MyRecord =
        { oneField : Int
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


### How to fix

One simple approach is just to change the record into a custom type. For example, the above bad example can be changed to:

    type MyRecord
        = MyRecord
            { oneField : Int
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


## Try it out

You can try the example configuration above out by running the following command:

```bash
elm-review --template matzko/elm-review-limit-aliased-record-size/example
```

-}
rule : LimitRecordSizeConfig -> Rule
rule config =
    Rule.newModuleRuleSchemaUsingContextCreator "LimitAliasedRecordSize" (initialContext config)
        |> Rule.withDeclarationEnterVisitor declarationVisitor
        |> Rule.fromModuleRuleSchema


{-| The context for the rule.
-}
type alias Context =
    { config : { maxSize : Int }
    }


{-| `LimitRecordSizeConfig` gets passed to `rule` to configure the rule. You can't contruct this type directly, but you can use the `maxRecordSize` function to create a configuration value:

    import LimitAliasedRecordSize
    import Review.Rule exposing (Rule)

    config : List Rule
    config =
        [ LimitAliasedRecordSize.rule
            (20 |> LimitAliasedRecordSize.maxRecordSize)
        ]

-}
type LimitRecordSizeConfig
    = LimitRecordSizeConfig { maxSize : Int }


{-| Assign the max record size allowed when configuring this rule.

    import LimitAliasedRecordSize
    import Review.Rule exposing (Rule)

    config : List Rule
    config =
        [ LimitAliasedRecordSize.rule
            (20 |> LimitAliasedRecordSize.maxRecordSize)
        ]

-}
maxRecordSize : Int -> LimitRecordSizeConfig
maxRecordSize maxSize =
    LimitRecordSizeConfig { maxSize = maxSize }


{-| The initial context for the rule.
-}
initialContext : LimitRecordSizeConfig -> Rule.ContextCreator () Context
initialContext (LimitRecordSizeConfig { maxSize }) =
    Rule.initContextCreator
        (\() ->
            { config = { maxSize = maxSize } }
        )


{-| A visitor for starting to parse declarations.
-}
declarationVisitor : Node Declaration -> Context -> ( List (Rule.Error {}), Context )
declarationVisitor node ({ config } as context) =
    case Node.value node of
        AliasDeclaration { name, typeAnnotation } ->
            case typeAnnotation |> Node.value of
                Record recordDefinition ->
                    if List.length recordDefinition > config.maxSize then
                        let
                            message : String
                            message =
                                "Type alias `" ++ (name |> Node.value) ++ "` has " ++ String.fromInt (List.length recordDefinition) ++ " fields, which exceeds the maximum of " ++ String.fromInt config.maxSize ++ "."

                            details : List String
                            details =
                                [ "Type aliases with too many fields can cause performance issues at compile time."
                                , "Consider changing the alias to a custom type, e.g. type " ++ (name |> Node.value) ++ " = " ++ (name |> Node.value) ++ " { ... }"
                                ]
                        in
                        ( [ Rule.error { message = message, details = details } (Node.range node) ], context )

                    else
                        ( [], context )

                _ ->
                    ( [], context )

        _ ->
            ( [], context )
