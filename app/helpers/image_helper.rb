module ImageHelper
  
  def process_stroke(stroke)
    stroke_json = stroke.as_json(only: [:points, :color, :width, :shape])
    # FIXME do it in one or two passes...
    points = stroke_json['points'].scan(/\d+,\d+/).map{ |p| p.split(',') }.map{ |p| p.map{|e| e.to_i} }
    stroke_json['points'] = points
    stroke_json
  end
end
