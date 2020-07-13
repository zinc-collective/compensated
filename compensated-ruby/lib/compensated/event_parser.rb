module Compensated
  class EventParser
    def parse(request)
      transform(request.data)
    end

    def parses?(_request)
      raise NotImplementedError('Implement in Child')
    end

    def transform(_data)
      raise NotImplementedError('Implement in Child')
    end

    # <b>DEPRECATED:</b> Please use <tt>transform</tt> instead.
    def normalize(data)
      warn '[DEPRECATION] `normalize` is deprecated.  Please use `transform` instead.'
      transform(data)
    end

    def extract(_data)
      raise NotImplementedError('Implement in Child')
    end
  end
end
