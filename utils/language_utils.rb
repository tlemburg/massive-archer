class Integer
    def seconds
        self
    end

    def minutes
        seconds * 60
    end

    def hours
        minutes * 60
    end

    def days
        hours * 24
    end

    def weeks
        days * 7
    end

    alias_method :second, :seconds
    alias_method :minute, :minutes
    alias_method :hour, :hours
    alias_method :day, :days
    alias_method :week, :weeks
end