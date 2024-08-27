class Array
  # new default value: '\0'
  NEW_DEFAULT = '\0'.freeze

  # alias methods used
  alias_method :original_get, :[]

  # custom [] method that uses the new default method
  def [](i)
    # if in valid range use [] normally
    if (i.is_a?(Integer))
      if ((i >= -size) && (i < size))
        original_get(i)
      else
        NEW_DEFAULT
      end
    # out of range, so return new default value: '\0'
    elsif i.is_a?(Range)
      inRange = false
      result = []
      start = i.begin
      end_idx = i.end

      if (i.exclude_end?)
        end_idx -= 1
      end

      for j in start..end_idx
        if (j >= -size) && (j < size)
          result << original_get(j)
          inRange = true
        end
      end
      if (inRange)
        result
      else
        NEW_DEFAULT
      end
    end
  end
end
  
class Array
  # custom map method with two parameters: range and the block
  def map(range = nil, &block)
    # if no range is given, use normal map in Array class
    if (range.nil?)
      super(&block)
    # must customize the new map with range
    else
      # determine if the range is a range right away
      if (range.is_a?(Range))
        if range.exclude_end?
          end_idx -= 1
        end
        # first check the beginning of the range
        if (range.begin.abs > size)
          # beginning is out of range and negative: start from -size
          if (range.begin.negative?)
            start_index = -size
          # beginning is out of range and positive: start from size - 1
          else
            start_index = size - 1
          end
        else
          # beginning is in range and greater than size - 1: start from size - 1
          if (range.begin > size - 1)
            start_index = size - 1
          else
            # beginning is in range and less than or equal to size - 1 and negative: start from beginning + size
            if (range.begin.negative?)
              start_index = range.begin + size
            # beginning is in range and less than or equal to size - 1 and positive: start from beginning
            else
              start_index = range.begin
            end
          end
        end

        # check end of the range
        if (range.end.abs > size)
          # ending is out of range and negative: end at -size
          if (range.end.negative?)
            end_index = -size
          # ending is out of range and positive: end at size - 1
          else
            end_index = size - 1
          end
        else
          # ending is in range and greater than size - 1: end at size - 1
          if (range.end > size - 1)
            end_index = size - 1
          else
            # ending is in range and less than or equal to size - 1 and negative: end at ending + size
            if (range.end.negative?)
            end_index = range.end + size
            # ending is in range and less than or equal to size - 1 and positive: end at ending
            else
            end_index = range.end
            end
          end
        end

        # now using the previously created range, yield the block appropriately
        arr = []
        (start_index..end_index).each do |i|
          element = self[i]
          if (element)
            arr << yield(element)
          end
        end
        arr
      else
        []
      end
    end
  end
end
  
# Test Cases
  
a = [1,2,34,5]
print a[0..5], "\n" # \0
print a[4..10], "\n" # \0
print a[1..3], "\n" # [2, 34, 5]
print a[1], "\n" # 2
print a[10], "\n" # '\0'
puts a[2]  # Should print 34
puts a[-2]  # Should print 34
puts a[5]  # Should print '\0' (default value)
puts a[-6]  # Should print '\0' (default value)
puts a[-4]  # Should print 1
puts a[3]   # Should print 5
print a.map(2..4) { |i| i.to_f}, "\n" #  [34.0, 5.0]
print a.map { |i| i.to_f}, "\n" # [1.0, 2.0, 34.0, 5.0]
print a.map(-3..10) { |i| i.to_f}, "\n" # [2.0, 34.0, 5.0]

b = ["cat","bat","mat","sat"]
print b[-1], "\n" # "sat"
print b[5], "\n" # '\0'
print b.map(2..10) { |x| x[0].upcase + x[1,x.length] }, "\n" # ["Mat", "Sat"]
print b.map(2..4) { |x| x[0].upcase + x[1,x.length] }, "\n" # ["Mat", "Sat"]
print b.map(-3..-1) { |x| x[0].upcase + x[1,x.length] }, "\n" # ["Bat", "Mat", "Sat"]
print b.map { |x| x[0].upcase + x[1,x.length] }, "\n" # ["Cat", "Bat", "Mat", "Sat"]
print b.map(1..-3) { |x| x[0].upcase + x[1,x.length] }, "\n" # ["Bat"]
print b.map(-10..10) { |x| x[0].upcase + x[1,x.length] }, "\n" # ["Cat", "Bat", "Mat", "Sat", "Cat", "Bat", "Mat", "Sat"]
print b.map(-1..0) { |x| x[0].upcase + x[1,x.length] }, "\n" # []
print b.map(-2..-1) { |x| x[0].upcase + x[1,x.length] }, "\n" # ["Mat", "Sat"]
print b.map(3..2) { |x| x[0].upcase + x[1,x.length] }, "\n" # []
print b.map(-10..-5) { |x| x[0].upcase + x[1,x.length] }, "\n" # ["Cat"]
print b.map(115..10) { |x| x[0].upcase + x[1,x.length] }, "\n" # ["Sat"]
print b.map(-2..10) { |x| x[0].upcase + x[1,x.length] }, "\n" # ["Mat", "Sat"]
print b.map(10..-10) { |x| x[0].upcase + x[1,x.length] }, "\n" # []