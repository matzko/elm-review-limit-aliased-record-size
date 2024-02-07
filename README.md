# elm-review-limit-aliased-record-size

Provides [`elm-review`](https://package.elm-lang.org/packages/jfmengels/elm-review/latest/) rules to REPLACEME.

## Provided rules

- [`LimitAliasedRecordSize`](https://package.elm-lang.org/packages/matzko/elm-review-limit-aliased-record-size/1.0.0/LimitAliasedRecordSize) - Reports REPLACEME.

## Configuration

```elm
module ReviewConfig exposing (config)

import LimitAliasedRecordSize
import Review.Rule exposing (Rule)

config : List Rule
config =
    [ LimitAliasedRecordSize.rule
    ]
```

## Try it out

You can try the example configuration above out by running the following command:

```bash
elm-review --template matzko/elm-review-limit-aliased-record-size/example
```
