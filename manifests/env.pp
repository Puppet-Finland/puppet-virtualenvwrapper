# @summary create a new virtualenv 
#
# Create a new virtualenv optionally with hooks
#
# @param user
#   System username to create virtualenv for
# @param shell
#   Path to shell to use
# @postactivate_content
#   Content of the postactivate hook
# @postdeactivate_content
#   Content of the postdeactivate hook
#
# @example
#   virtualenvwrapper::env { 'namevar': }
define virtualenvwrapper::env
(
  String           $user,
  String           $shell = '/bin/bash',
  Optional[String] $postactivate_content = undef,
  Optional[String] $postdeactivate_content = undef,
)
{

  $virtualenv = $title

  $home = $user ? {
    'root'  => '/root',
    default => "/home/${user}"
  }

  exec { $virtualenv:
    command     => "${shell} -c \'. /usr/share/virtualenvwrapper/virtualenvwrapper.sh; mkvirtualenv ${virtualenv}\'",
    user        => $user,
    environment => ["HOME=${home}"],
    creates     => "${home}/.virtualenvs/${virtualenv}",
  }
}