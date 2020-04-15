module Compensated
  class EventParser
    def parse(request)
      normalize(request.data)
    end

    def parses?(request)
      raise NotImplementedError("Implement in Child")
    end

    def normalize(data)
      raise NotImplementedError("Implement in Child")
    end

    def pretransformed_data(data)
      raise NotImplementedError("Implement in Child")
    end
  end
end
