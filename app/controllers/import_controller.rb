class ImportController < ApplicationController
  def import
    c = File::read('Carreras.txt')
    p = File::read('Planes.txt')
    m = File::read('Materias.txt')

    c.each_line do |line|
      nueva_carrera = Carrera.new
      nueva_carrera.codigo = line[0..-2].split(';').collect[0]
      nueva_carrera.nombre = line[0..-2].split(';').collect[1]
      debugger
      nueva_carrera.save!
    end

    p.each_line do |line|
      nuevo_plan = Plan.new
      nuevo_plan.codigo_carrera = line[0..-2].split(';').collect[0]
      nuevo_plan.codigo = line[0..-2].split(';').collect[1]
      nuevo_plan.nombre = line[0..-2].split(';').collect[2]
      nuevo_plan.save!
    end

    m.each_line do |line|
      nueva_materia = Materia.new
      nueva_materia.codigo_carrera = line[0..-2].split(';').collect[0]
      nueva_materia.codigo_plan = line[0..-2].split(';').collect[1]
      nueva_materia.codigo = line[0..-2].split(';').collect[2]
      nueva_materia.nombre = line[0..-2].split(';').collect[3]
      nueva_materia.save!
    end

  end

end
