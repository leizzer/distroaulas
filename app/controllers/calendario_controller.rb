class CalendarioController < ApplicationController
  require 'ri_cal'

  # GET /calendario/create
  def create
    calendar = RiCal.Calendar
      data << calendar.export
    end 

  end

  def load
    File.open("distroaulas-calendario.cal", "r") do |data|
      cal_import = data
    end
    calendar = RiCal.parse_string(cal_import)
    return calendar[0]
  end

  def new_event
    calendar = load
    event = RiCal.event

    # cargar datos del evento nuevo

    calendar.add_subcomponent(event)

    # guardar
  end

  def save
  end

end

