module Compass::SassExtensions::Functions::CrossBrowserSupport
  # Check if any of the arguments passed require a vendor prefix.
  def prefixed(prefix, *args)
    aspect = prefix.value.sub(/^-/,"")
    needed = args.any?{|a| a.respond_to?(:supports?) && a.supports?(aspect)}
    Sass::Script::Bool.new(needed)
  end

  %w(webkit moz o ms svg pie css2).each do |prefix|
    class_eval <<-RUBY, __FILE__, __LINE__ + 1
      # Syntactic sugar to apply the given prefix
      # -moz($arg) is the same as calling prefix(-moz, $arg)
      def _#{prefix}(*args)
        prefix("#{prefix}", *args)
      end
    RUBY
  end

  def prefix(prefix, *objects)
    prefix = prefix.value if prefix.is_a?(Sass::Script::String)
    prefix = prefix[1..-1] if prefix[0] == ?-
    if objects.size > 1
      self.prefix(prefix, Sass::Script::List.new(objects, :comma))
    else
      object = objects.first
      if object.is_a?(Sass::Script::List)
        Sass::Script::List.new(object.value.map{|e|
          self.prefix(prefix, e)
        }, object.separator)
      elsif object.respond_to?(:supports?) && object.supports?(prefix) && object.respond_to?(:"to_#{prefix}")
        object.options = options
        object.send(:"to_#{prefix}")
      else
        object
      end
    end
  end

end
