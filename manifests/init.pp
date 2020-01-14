# @summary setup virtualenvwrapper 
#
# Install virtualenvwrapper
#
# @example
#   include virtualenvwrapper
class virtualenvwrapper {
  package { 'virtualenvwrapper':
    ensure => 'present',
  }
}
