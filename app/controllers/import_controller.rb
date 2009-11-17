class ImportController < ApplicationController
  def import
    @log = "INICIO DE IMPORTACION \n"
    begin
      @log += "Intentando acceder a Carreras.txt \n"
      c = File::read('importer/Carreras.txt')
      @log += "Acceso logrado... Leyendo... \n Se encontraron #{c.lines.count} registros... \n"
      c.each_line do |line|
        nueva_carrera = Carrera.new
        nueva_carrera.codigo = line[0..-2].split(';').collect[0]
        nueva_carrera.nombre = line[0..-2].split(';').collect[1].strip
        if Carrera.find(:all, :conditions => {:codigo => nueva_carrera.codigo, :nombre => nueva_carrera.nombre}).empty?
          nueva_carrera.save!
          @log += "Registro [#{nueva_carrera.codigo} #{nueva_carrera.nombre}] agregado! \n"
        else
          @log += "Registro [#{nueva_carrera.codigo} #{nueva_carrera.nombre}] ya existe, no agregado \n"
        end
      end
      @log += "Carreras.txt procesado correctamente \n"
   rescue => e
      @log += "Error: Carreras.txt corrupto, inexistente o malformateado. No se pudo imporar. \n"
   end
    begin
      @log += "Intentando acceder a Planes.txt... \n"
      p = File::read('importer/Planes.txt')
      @log += "Acceso logrado... Leyendo... \n Se encontraron #{p.lines.count} registros... \n"
      p.each_line do |line|
        nuevo_plan = Plan.new
        nuevo_plan.codigo_carrera = line[0..-2].split(';').collect[0]
        nuevo_plan.codigo = line[0..-2].split(';').collect[1]
        nuevo_plan.nombre = line[0..-2].split(';').collect[2].strip
        if Plan.find(:all, :conditions => {:codigo => nuevo_plan.codigo, :codigo_carrera => nuevo_plan.codigo_carrera, :nombre => nuevo_plan.nombre}).empty?
          nuevo_plan.save!
          @log += "Registro [#{nuevo_plan.codigo} #{nuevo_plan.codigo_carrera} #{nuevo_plan.nombre}] agregado! \n"
        else
          @log += "Registro [#{nuevo_plan.codigo} #{nuevo_plan.codigo_carrera} #{nuevo_plan.nombre}] ya existe, no agregado \n"
        end
      end
      @log += "Planes.txt fue procesado correctamente \n"
    rescue => e
      @log += "Error: Planes.txt corrupto, inexistente o malformateado. No se pudo imporar. \n"
    end
    begin
      @log += "Intentando acceder a Materias.txt... \n"
      m = File::read('importer/Materias.txt')
      @log += "Acceso logrado... Leyendo... \n Se encontraron #{m.lines.count} registros... \n"
      m.each_line do |line|
        nueva_materia = Materia.new
        nueva_materia.codigo_carrera = line[0..-2].split(';').collect[0]
        nueva_materia.codigo_plan = line[0..-2].split(';').collect[1]
        nueva_materia.codigo = line[0..-2].split(';').collect[2]
        nueva_materia.nombre = line[0..-2].split(';').collect[3].strip
        if Materia.find(:all, :conditions => {:codigo_carrera => nueva_materia.codigo_carrera, :codigo_plan => nueva_materia.codigo_plan, :codigo => nueva_materia.codigo, :nombre => nueva_materia.nombre}).empty?
          nueva_materia.save!
          @log += "Registro [#{nueva_materia.codigo} #{nueva_materia.codigo_plan} #{nueva_materia.codigo_carrera} #{nueva_materia.nombre}] agregado! \n"
        else
          @log += "Registro [#{nueva_materia.codigo} #{nueva_materia.codigo_plan} #{nueva_materia.codigo_carrera} #{nueva_materia.nombre}] ya existe, no agregado \n"
        end
      end
      @log += "Materias.txt fue procesado correctamente \n"
    rescue => e
      @log += "Error: Materias.txt corrupto, inexistente o malformateado. No se pudo imporar.\n"
    end
    @log += "FIN DE LA IMPORTACION"
    render :action => 'import'
  end
end
