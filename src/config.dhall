-- | Dhall helpers to manage extension schema
let Prelude =
      https://prelude.dhall-lang.org/v17.0.0/package.dhall sha256:10db3c919c25e9046833df897a8ffe2701dc390fa0893d958c3430524be5a43e

let option =
      \(name : Text) ->
      \(type : Text) ->
      \(default : Text) ->
        Prelude.XML.element
          { name = "key"
          , attributes = toMap { name, type }
          , content =
            [ Prelude.XML.element
                { name = "default"
                , attributes = Prelude.XML.emptyAttributes
                , content = [ Prelude.XML.text default ]
                }
            ]
          }

let intOption =
      \(name : Text) ->
      \(default : Natural) ->
        option name "i" (Natural/show default)

let floatOption =
      \(name : Text) ->
      \(default : Double) ->
        option name "d" (Double/show default)

in  { intOption, floatOption }
