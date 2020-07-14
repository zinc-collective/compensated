# frozen_string_literal: true

module Compensated
  # Parent class for Commands. Commands are organized as a tree, with `Command` as
  #  a trunk, with it's children for each command that can be executed by Compensated and
  # TODO: Not sure if this is best with parent -> child inheritence or as a mixin.
  #       Goal is to make it possible to have Commands that have different
  #       implementations for each payment processor.
  class Command
    attr_accessor :options, :configuration

    def initialize(options, configuration)
      self.options = options
      self.configuration = configuration
    end

    def execute
      children.each do |child|
        child.new(options, configuration).execute
      end
    end

    def children
      self.class.children_registry
    end

    def self.children_registry
      @children_registry ||= []
    end

    def self.inherited(child)
      children_registry << child
    end
  end

  # Applies the Compensated configuration to each Payment Processor
  # Individual Payment Processors Adapters should inherit from this
  # class in order to support the Apply command
  class ApplyCommand < Command; end
end
