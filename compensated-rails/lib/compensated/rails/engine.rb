module Compensated
  module Rails
    class Engine < ::Rails::Engine
      isolate_namespace Compensated::Rails
    end
  end
end
