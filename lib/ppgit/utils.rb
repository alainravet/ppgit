
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

NO_COLOUR="\033[0m"
RED      ="\033[31m"
LRED      ="\033[1;31m"
BLUE     ="\033[34m"
GREEN    ="\033[32m"
YELLOW   ="\033[1;33m"

def red(   str) [RED,    str, NO_COLOUR].join  end
def lred(   str) [LRED,    str, NO_COLOUR].join  end
def blue(  str) [BLUE,   str, NO_COLOUR].join  end
def green( str) [GREEN,  str, NO_COLOUR].join  end
def yellow(str) [YELLOW, str, NO_COLOUR].join  end
