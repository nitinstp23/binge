module Binge
  class Model
    include ActiveModel::Model

    attr_accessor :class_name

    def base_class_name
      class_name.split('::').last
    end

    def titleized_name
      base_class_name.titlecase
    end

    def parameterized_class_name
      base_class_name.underscore
    end

    def humanized_name
      parameterized_class_name.humanize.downcase
    end

    def klass
      @klass ||= class_name.constantize
    end

    def columns
      # This should not be done for each row. #optimize
      @columns ||= Binge::Attributes.const_get("For#{klass}").all
    rescue NameError => ex
      []
    end

    def column_names
      @column_names ||= columns.map(&:name)
    end

    def ==(other)
      self.class_name == other.class_name
    end

    def mapped_attributes(attributes)
      # This should not be done for each row. #optimize
      mapper_klass ||= Binge::Mappers.const_get("For#{base_class_name}")
      mapper_klass.new(attributes).to_hash
    rescue NameError => ex
      attributes
    end

    def create(attributes)
      attributes = mapped_attributes(attributes)
      instance = klass.new(attributes)
      instance.save if instance.valid?
      instance
    end

    def validate(attributes)
      attributes = mapped_attributes(attributes)
      instance = klass.new(attributes)
      instance.valid?
      instance
    end

    def self.all
      Binge.import_classes.collect {|class_name| Model.new(class_name: class_name)}
    end

    def self.first
      all.first
    end

    def self.find(class_name)
      all.find {|model| model.class_name == class_name || model.parameterized_class_name == class_name}
    end
  end
end
