midi_out = function ( self, x, y, frame, grid )
  self.name = '%'
  self.y = y
  self.x = x
  self:spawn(self.ports[self.name])
  local note = 'C'
  local channel = util.clamp( self:listen( self.x + 1, self.y ) or 0, 0, 16 )
  local octave = util.clamp( self:listen( self.x + 2, self.y ) or 3, 0, 8 )
  local vel = util.clamp( self:listen( self.x + 4, self.y ) or 0, 0, 16 )
  local length = util.clamp( self:listen( self.x + 5, self.y ) or 0, 0, 16 )
  local transposed = self.transpose( self.chars[self:listen( self.x + 3, self.y )], octave )
  local oct = transposed[4]
  local n = math.floor( transposed[1] )
  local velocity = math.floor(( vel / 16 ) * 127 )
  if self.banged( self.x, self.y ) then
    if grid.active_notes_mono ~= nil then 
      self.all_notes_off_mono( channel )
    end
    grid.params[y][x].lit_out = false
    self.midi_out_device:note_on( n, velocity, channel )
    self:add_note_mono(n)
  else
    grid.params[self.y][self.x].lit_out = true
  end
end

return midi_out