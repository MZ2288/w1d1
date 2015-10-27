class Array
  def my_each(&blk)
    i = 0
    while i < length
      blk.call(self[i])
      i += 1
    end
  end

  def my_select(&blk)
    [].tap { |truthy| self.my_each { |el| truthy << el if blk.call(el) } }
  end

  def my_reject(&blk)
    [].tap { |truthy| self.my_each { |el| truthy << el unless blk.call(el) } }
  end

  def my_any?(&blk)
    self.my_each { |el| return true if blk.call(el) }
    false
  end

  def my_flatten
    [].tap do |result|
      self.my_each do |el|
        if el.is_a?(Array)
          result.concat(el.my_flatten)
        else
          result << el
        end
      end
    end
  end

  def my_zip(*args)
    [].tap do |result|
      length.times do |i|
        index_array = [self[i]]
        args.each do |sub_array|
          index_array << sub_array[i]
        end
        result << index_array
      end
    end
  end

  def my_rotate(num = 1)
    new_arr = self.dup
    if num > 0
      num.times do
        el = new_arr.shift
        new_arr.push(el)
      end
    elsif num < 0
      (num*-1).times do
        el = new_arr.pop
        new_arr.unshift(el)
      end
    end
    new_arr
  end

  def my_join(str = "")
    result = ""
    self.my_each do |el|
      result << el.to_s + str
    end
    str == "" ? result : result[0..-2]
  end

  def my_reverse
    new_arr = []
    1.upto(length) do |i|
      new_arr << self[-i]
    end
    new_arr
  end



end
