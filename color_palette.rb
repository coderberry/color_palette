# frozen_string_literal: true

class ColorPalette
  DEFAULT_BASE = 3
  DEFAULT_SATURATION = 0.5
  DEFAULT_LIGHTNESS_MIN = 0.4
  DEFAULT_LIGHTNESS_MAX = 0.8
  DEFAULT_LIGHTNESS_DECAY = 20

  # Generate a color scheme with a given number of colors.
  # @param [Integer] count The number of colors to generate.
  # @param [Float] base The base number to use for the color scheme.
  # @param [Float] saturation The saturation of the colors. Between 0 and 1.
  # @param [Float] lightness_min The minimum lightness of the colors. Between 0 and 1.
  # @param [Float] lightness_max The maximum lightness of the colors. Between 0 and 1.
  # @param [Float] lightness_decay The lightness decay of the colors.
  # @returns [Array<String>] An array of hex color strings.
  def self.generate(
    count,
    base: DEFAULT_BASE,
    saturation: DEFAULT_SATURATION,
    lightness_min: DEFAULT_LIGHTNESS_MIN,
    lightness_max: DEFAULT_LIGHTNESS_MAX,
    lightness_decay: DEFAULT_LIGHTNESS_DECAY
  )
    colors = []
    count.times do |i|
      tmp = i.to_s(base).chars.reverse.join
      hue = (360 * tmp.to_i(base)).to_f / (base ** tmp.length)

      # rubocop:disable Lint/AmbiguousOperatorPrecedence
      lightness =
        lightness_min +
          (lightness_max - lightness_min) * (1 - Math.exp(-i.to_f / lightness_decay))

      # rubocop:enable Lint/AmbiguousOperatorPrecedence
      hex = hsl_to_hex([hue, saturation, lightness])
      colors << hex
    end
    colors
  end

  # Convert an array of HSL values to a hex string.
  # @param [Array<Float>] hsl An array of HSL values.
  # @returns [String] A hex string.
  def self.hsl_to_hex(hsl_arr)
    rgb = hsl_to_rgb(hsl_arr)
    rgb_to_hex(rgb)
  end

  # Convert an array of HSL values to an array of RGB values.
  # @param [Array<Float>] hsl An array of HSL values.
  # @returns [Array<Integer>] An array of RGB values.
  def self.hsl_to_rgb(hsl_arr)
    hue, saturation, lightness = hsl_arr.map(&:to_f)
    a = saturation * [lightness, 1 - lightness].min
    rgb = [0, 8, 4]
    rgb.map! do |channel|
      k = (channel + (hue / 30)) % 12
      channel = lightness - (a * [-1, [k - 3, 9 - k, 1].min].max)
      (channel * 255).round
    end
    rgb
  end

  # Convert an array of RGB values to a hex string.
  # @param [Array<Integer>] rgb An array of RGB values.
  # @returns [String] A hex string.
  def self.rgb_to_hex(rgb)
    if rgb.size == 3
      format('#%02x%02x%02x', *rgb)
    else
      rgb[3] = (rgb[3] * 255).round
      format('#%02X%02X%02X%02X', *rgb)
    end
  end
end
