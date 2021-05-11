let Prelude =
      https://prelude.dhall-lang.org/v17.0.0/package.dhall sha256:10db3c919c25e9046833df897a8ffe2701dc390fa0893d958c3430524be5a43e

let info = (./metadata.dhall).info

let schema =
      Prelude.XML.element
        { name = "schema"
        , attributes = toMap
            { id = "org.gnome.shell.extensions.${info.name}"
            , path = "/org/gnome/shell/extensions/${info.name}/"
            }
        , content =
          [ Prelude.XML.element
              { name = "key"
              , attributes = toMap { name = "duration", type = "i" }
              , content =
                [ Prelude.XML.element
                    { name = "default"
                    , attributes = Prelude.XML.emptyAttributes
                    , content = [ Prelude.XML.text "45" ]
                    }
                ]
              }
          ]
        }

let schemas =
      Prelude.XML.render
        ( Prelude.XML.element
            { name = "schemalist"
            , attributes = Prelude.XML.emptyAttributes
            , content = [ schema ]
            }
        )

in      ''
        <?xml version="1.0" encoding="UTF-8"?>
        ''
    ++  schemas
