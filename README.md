# elm-review-limit-aliased-record-size

Provides an [`elm-review`](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/) rule to make sure aliased records don't get too large.

Experience has shown that having large record aliases (for me, more than 40 fields) can lead to large memory usage when compiling (sometimes up to 10GB).

The purpose of this rule is to identify large alias records, so they can be replaced.

## Provided rules

- [`LimitAliasedRecordSize`](https://package.elm-lang.org/packages/matzko/elm-review-limit-aliased-record-size/1.0.0/LimitAliasedRecordSize) - Reports aliased records that are larger than the given configured size.

## Configuration

```elm
module ReviewConfig exposing (config)

import LimitAliasedRecordSize
import Review.Rule exposing (Rule)

config : List Rule
config =
    [ LimitAliasedRecordSize.rule
        (20 |> LimitAliasedRecordSize.maxRecordSize)
    ]
```

## Examples

### ✅ Good: not too many fields

```
type alias MyRecord =
    { oneField : Int
    , anotherField : String
    , yetAnotherField : Bool
    }
```

### ❌ Bad: too many fields

```
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
```

### How to fix

One simple approach is just to change the record into a custom type. For example, the above bad example can be changed to:

```
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
```

## Try it out

You can try the example configuration above out by running the following command:

```bash
elm-review --template matzko/elm-review-limit-aliased-record-size/example
```
