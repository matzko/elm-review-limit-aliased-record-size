# elm-review-limit-aliased-record-size

## Motivation for the Rule

`LimitAliasedRecordSize` provides an [`elm-review`](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/) rule to make sure aliased records don't get too large.

Experience has shown that having large record aliases (for me, more than 40 fields) can lead to large memory usage when compiling (sometimes up to 10GB).

The purpose of this rule is to identify large alias records, so they can be replaced.

### How to tell if you might need this rule

Compile your application and look at the verbose output like so:

```bash
elm make src/Main.elm --output=/dev/null +RTS -s -w
```

If garbage collection (GC) time is multiple seconds, or if the "bytes allocated in the heap" run to many gigabytes, you might benefit from this rule.

After compilation, run

```bash
du -hs elm-stuff/0.19.1/* | sort -h | tail -n 60 | tac
```

If the largest `.elmi` files are run more than a few megabytes, you might benefit from this rule.

### When not to use this rule

If neither of the above commands indicates a problem, and you have not experienced problems with slow build times or exhausted memory when compiling, you probably don't need this rule.

## Provided rules

- [`LimitAliasedRecordSize`](https://package.elm-lang.org/packages/matzko/elm-review-limit-aliased-record-size/1.0.1/LimitAliasedRecordSize/) - Reports aliased records that are larger than the given configured size.

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

```elm
type alias MyRecord =
    { oneField : Int
    , anotherField : String
    , yetAnotherField : Bool
    }
```

### ❌ Bad: too many fields

```elm
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
```

### How to fix

One simple approach is just to change the record into a custom type. For example, the above bad example can be changed to:

```elm
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
