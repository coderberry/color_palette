# frozen_string_literal: true

require_relative "color_palette"

colors = ColorPalette.generate(30)

colors.each_with_index do |color, index|
  puts "#{index + 1}: #{color}"
end