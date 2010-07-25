
class NilClass
  def blank?
    true
  end
end

class String
  def blank?
    0 == self.strip.length
  end
end

def argv_value_of(prefix)
  if (idx = ARGV.index(prefix))
    ARGV.delete_at(idx)             # ex: remove '--files'
    the_value = ARGV.delete_at(idx)
  end
end
