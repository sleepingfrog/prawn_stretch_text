# frozen_string_literal: true

module PrawnStretch
  def stretch_to_full_text_box(string, options = {})
    raise if options[:width].nil? || options[:height].nil?

    width = width_of(string)
    height = height_of(string, width: Float::INFINITY)

    x_factor = if width.zero?
                 1
               else
                 options[:width].fdiv(width)
               end
    y_factor = if height.zero?
                 1
               else
                 options[:height].fdiv(height)
               end
    transform_scale_text_box(string, **options.merge({ transform_scale: [x_factor, y_factor]}))
  end

  def compress_text_box(string, options = {})
    raise if options[:width].nil?

    width = width_of(string)
    if width.zero? || width <= options[:width]
      text_box(string, **options)
    else
      x_factor = options[:width].fdiv(width)
      transform_scale_text_box(string, **options.merge({ transform_scale: [x_factor, 1] }))
    end
  end

  def transform_scale_text_box(string, options = {})
    if options[:transform_scale].nil?
      text_box(string, **options)
    else
      x_factor, y_factor = options[:transform_scale]
      text_options = options.dup
      text_options[:height] /= y_factor unless text_options[:height].nil?
      text_options[:width] /= x_factor unless text_options[:width].nil?

      x, y = if options[:at].nil?
               [bounds.left + bounds.absolute_left, bounds.top + bounds.absolute_bottom]
             else
               [options[:at][0] + bounds.absolute_left, options[:at][1] + bounds.absolute_bottom]
             end

      translate((1 - x_factor) * x, (1 - y_factor) * y) do
        transformation_matrix(x_factor, 0, 0, y_factor, 0, 0) do
          text_box(string, text_options)
        end
      end
    end
  end
end
