module Input

  include Terminal


  global :action,
         :quit


  def self.init
    @delay = 0
  end


  def self.read
    @action = nil

    return unless Terminal.has_input?

    @key = Terminal.read
    @chr = Terminal.state(TK_CHAR).chr

    special_actions

    if @disabled
      @delay -= 1
      enable if @delay <= 0
    end

    return if @disabled

    @chr = convert_key
    @action = interprete_chr
  end


  def self.enable;  @disabled = false end
  def self.disable; @disabled = true end


  def self.disable_for delay
    @delay = delay
    disable
  end


  def self.special_actions
    case @key
    when TK_CLOSE,
         TK_ESCAPE
      @quit = true

    when TK_KP_MINUS
      Display.decrease_font_size

    when TK_KP_PLUS
      Display.increase_font_size

    when TK_RESIZED
      width  = Terminal.state TK_WIDTH
      height = Terminal.state TK_HEIGHT
      Display.window_resize width, height

    end
  end


  def self.convert_key
    case @key
    when TK_LEFT  then 'h'
    when TK_DOWN  then 'j'
    when TK_UP    then 'k'
    when TK_RIGHT then 'l'
    when TK_KP_4  then 'h'
    when TK_KP_2  then 'j'
    when TK_KP_8  then 'k'
    when TK_KP_6  then 'l'
    when TK_KP_7  then 'y'
    when TK_KP_9  then 'u'
    when TK_KP_1  then 'b'
    when TK_KP_3  then 'n'
    else @chr
    end
  end


  def self.interprete_chr
    case @chr
    when 'h' then :go_west
    when 'j' then :go_south
    when 'k' then :go_north
    when 'l' then :go_east
    when 'y' then :go_north_west
    when 'u' then :go_north_east
    when 'b' then :go_south_west
    when 'n' then :go_south_east
    else nil
    end
  end


  def self.shift?;   Terminal.state(TK_SHIFT)   == 1 end
  def self.control?; Terminal.state(TK_CONTROL) == 1 end
  def self.alt?;     Terminal.state(TK_ALT)     == 1 end

end
