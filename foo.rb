require 'prawn'
require './prawn_stretch.rb'

class Foo
  include Prawn::View
  include PrawnStretch

  def build
    DATA.each_line.with_index do |text_line, i|
      left, top = bounds.top_left
      top -= 22 * i

      bounding_box([left, top], width: 160, height: 20) do
        stroke_color '080888'
        stroke_bounds
        text_box(text_line, width: bounds.width, height: bounds.height, overflow: :shrink_to_fit, valign: :center)
      end

      bounding_box([left + 170, top], width: 160, height: 20) do
        stroke_color '088800'
        stroke_bounds
        compress_text_box(text_line, width: bounds.width, height: bounds.height, valign: :center)
      end

      bounding_box([left + 340, top], width: 160, height: 20) do
        stroke_color '880808'
        stroke_bounds

        width = width_of(text_line)
        x_factor = if width.zero?
                     1
                   else
                     bounds.width.fdiv(width)
                   end
        transform_scale_text_box(text_line, width: bounds.width, height: bounds.height, valign: :center, transform_scale: [x_factor, 1])
      end

      bounding_box([left, bounds.top - 100 - (72 * i)], width: 160, height: 70) do
        stroke_color '080808'
        stroke_bounds
        stretch_to_full_text_box(text_line, width: bounds.width, height: bounds.height, valign: :center)
      end
    end
  end
end

foo = Foo.new
foo.build
foo.save_as('foo.pdf')

__END__
abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ
foobar
irohanihoheto
