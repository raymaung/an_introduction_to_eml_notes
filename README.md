# An Introduction To EML

* EML is a functional language that compiles to Javascrtip
* Compete with projects like *React*
* Elm has strong emphasis on simplicity, ease of use and quality tooling

## Set Up And Running 

* Require ELM 0.17
* `elm-reactor` to run in the browser
* `elm-package install` to install ELM packages

# Why a *functional* language?

* No runtime errors - no `null`, `undefined`
* Friendly error messages
* Well-architected code
* Automatically enforced semantic versioning for all ELM packages

# Core Language

* `elm-repl` to start REPL

## Values

```
> "hello"
> "hello" ++ "world"
```

* `(++)` operator to put strings together

```
> 2 + 3 * 4
14

> (2 + 3) * 4
20

> 9 / 2
4.5

> 9 // 2
4
```
* `(/)` for floating point division
* `(//)` for integer division


## Functions

```
> isNegative n = n < 0
<function>

> isNegative 4
False

> isNegative -7
True

> isNegative (-3 * -4)
False
```

* Use spacess to apply the function

## `If` Expressions

```
> if True then "hello" else "world"
"hello"`

> if False then "hello" else "world"
"world"
```
* Do not need any parentheses or curly braces
* Elm doesn't have a notion of *truthiness*
    * numbers, strings and list cannot be used as boolean values

```
> over9000 powerLevel = \
|   if powerLevel > 9000 then "It's over 9000" else "meh"
<function>

> over9000 42
"meh"
```

* Using backlash `\` to split things on to multiple lines in REPL
* Best practice to bring the body of a function down a line

## Lists

* `names = ["Alice", "Bob", "Chuck"]`
* `List.isEmpty names` returns `False`
* `List.length names` returns `3`
* `List.reverse names` returns `["Chuck", "Bob", "Alice"]`
* `List.sort`

```
numbers = [1, 4, 3, 2]
double n = n * 2

List.map double numbers
```

## Tuples

* Can hold a fixed number of values
* Each value can have any type
* Common usage: when need to return more than one values

```
import String

goodName name =
  if String.length name <= 20 then
    (True, "name accepted")
  else
    (False, "name was too long; please limit to 20 characters"
```

## Records

```
point = { x = 3, y = 4 }
point.x

bill = {name = "Gates", age = 57 }
bill.name
```

* A record is a set of key-value paris - similar to objects in JavaScript
* Create using curly braces `{...}` syntax
* By starting the variable with a dot, it means *please access the field with the following name*
    * `.name` is a function that gets the `name` field of the record
    * `.name bill` works too; same as `bill.name`


```
under70 {age} = age < 70

under70 bill
``` 
* Can do some pattern matching to make thing lighter

### Updating Record

* `bill = { bill | name = "Nye"}`
* No destructive updates - create a new record rather than overwriting the existing one
* Elm makes this efficient by sharing much content as possible

### Comparing Records and Objects

* Similar to objects in Javascript but some crucial differences
* You cannot ask for a field that doesn't exist
* No field will ever by `undefined` or `null`
* You cannot create recursive records with a `this`or `self` keyword

Elm encourages a strict separations of data and logic and the ability to say `this`is primarily used to break this separation. It is a systemic problem in Object Oriented Languages that Elm is purposely avoiding

Records supports *structual typing*, it means Elm's records can be used in any situations as long as the necessary field exists - providing flexibility without compromising reliability

## The Elm Architecture

* Simple pattern for nestable components
    * modularity
    * code reuse
    * testing
* *Redux* translate the Elm arthitecture into JavaScript directly

## The Basic Pattern

```
import Html exposing(..)

-- MODEL
type alias Model = { ... }

-- UPDATE
type Msg = Reset | ...

update: Msg -> Model -> Model
update msg model =
  case msg of
    Reset -> ...
    ...
    
-- VIEW
view: Model -> Html Msg
view model =
  ...
```
* **Model** the state of your application
* **Update** a way to update your state
* **View** a way to view your state as HTMl

## The Elm Architecture + User Input

* Buttons
* Text Fields
* Check Boxes
* Radio Buttons
* etc..

### Buttons

### Text Fields

* `onInput` function takes one argument
    * in the example case, `Change` function which was created when `Msg` was declared

### Forms

## The Elm Arthitecture + Effects

### Commands

* A command i a way of demanding some effect
    * ie. Asking for random numbers
    * Making an Http Request
    * Anything where you are asking for some value and the answer may be different depending on what is going on

### Subscriptions

* A subscription lets you register that you are interested in something.
    * ie. Geolocation changes
    * Messages coming in on a web socket
* Subscriptions let you sit passively and only get updates when they exist

*Commands* and *Subscriptions* make it possible for Elm components to talk to the outside world.

## Extending the Architecture Skeleton

```
-- MODEL
type alias Model =
  { ...
  }

-- UPDATE
type Msg = Submit | ...

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
  ...

-- VIEW
view: Model -> Html Msg
view model =
  ...

-- SUBSCRIPTIONS
subscriptions: Model -> Sub Msg
subscriptions model =
  ...

-- INIT
init: (Model, Cmd Msg)
init =
  ...
```
* `update` noew returns more than just a new model
    * returns a nwe model and some commands you want to run
    * the *commands* are going to produce `Msg` values that will get fed right back into `update` function 
* `subscriptions` let you declare any event sources you declare any event sources you need to subscribe to given the current model. Just like `Html Msg` and `Cmd Msg`, these subscriptions will produce `Msg` values that get fed right into our `update` function
* `init` now produces both a model and some commands like like the new `update`.This lets us provide a starting value and kick off any HTTP requests or whatever that need for initialization.

> **Aside**: `commands` and `subscriptions` are *data*. When you create 
> a command, you do not actually *do* it. Same with commands.
> 
> You hand *commands* and *subscriptions* to Elm to actually run them,
> giving elm a chance to log all of this information. In the end, *effects-as-data*
> means Elm can
>
> - Hava general purpose time-travel debugger
> - Keep the *same input, same output* guarantee for all Elm functions.
> - Avoid setup/teardown phases when testing `update` logic.
> - Cache and batch effects, minimizing HTTP connections or other resources
> 
> All the nice gurantees and tools in Elm come from the choice to treat effects as data
> 

### Random Number

* `Cmd.none` means *I have no commands, do nothing*

### HTTP

* `Http.get` to GET some json from `url`
* `Json.at ["data", "image_url"] Json.string` reads as
    * Try to get the value at `json.data.image_url` and should be a sring
* `Task.perform` is to clarifying what to do with the result
    * First argument `FetchFail` is when the GET fails
    * Second argument is `FetchSuccess` for the GET success