module Binge
  class FileUploader < Shrine

    plugin :determine_mime_type
    plugin :validation_helpers

    Attacher.validate do
      validate_extension_inclusion ['csv', 'CSV']
      validate_mime_type_inclusion ['text/csv']
    end

  end
end
