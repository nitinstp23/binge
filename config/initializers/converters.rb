require 'csv'

CSV::HeaderConverters[:to_attribute] = lambda do |header|
  header.strip.downcase.to_sym
end

CSV::Converters[:strip] = lambda do |field|
  field.blank? ? nil : field.strip
end

CSV::Converters[:downcase] = lambda do |field|
  field.blank? ? nil : field.downcase
end
