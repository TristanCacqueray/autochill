-- | The extension preferences schema
let Prelude =
      https://prelude.dhall-lang.org/v17.0.0/package.dhall sha256:10db3c919c25e9046833df897a8ffe2701dc390fa0893d958c3430524be5a43e

let extension = ../extension.dhall

let schema =
      Prelude.XML.element
        { name = "schema"
        , attributes = toMap
            { id = "org.gnome.shell.extensions.${extension.name}"
            , path = "/org/gnome/shell/extensions/${extension.name}/"
            }
        , content = extension.options
        }

in      ''
        <?xml version="1.0" encoding="UTF-8"?>
        ''
    ++  Prelude.XML.render
          ( Prelude.XML.element
              { name = "schemalist"
              , attributes = Prelude.XML.emptyAttributes
              , content = [ schema ]
              }
          )
