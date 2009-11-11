class SimpEvent
  def starts_at
    @starts_at
  end

  def starts_at=(data)
    @starts_at = data
  end

  def ends_at
    @ends_at
  end

  def ends_at=(data)
    @ends_at = data
  end

  def name
    @name
  end

  def name=(data)
    @name = data
  end

  def original_id
    @original_id
  end

  def original_id=(data)
    @original_id = data
  end

  def location
    @location
  end

  def location=(data)
    @location = data
  end

  attr_accessor :anio

end
