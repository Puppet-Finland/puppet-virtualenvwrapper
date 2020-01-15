# @summary create a new virtualenv 
#
# Create a new virtualenv optionally with hooks
#
# @param user
#   System username to create virtualenv for
# @param python_path
#   Absolute path to the Python binary to use. Defaults to 2.x version of Python.
# @param shell
#   Path to shell to use
# @env_variables
#   A hash of environment variables to set in the virtualenv
# @postactivate_content
#   Content of the postactivate hook
# @postdeactivate_content
#   Content of the postdeactivate hook
#
# @example
#   virtualenvwrapper::env { 'namevar': }
define virtualenvwrapper::env
(
  String                        $user,
  String                        $shell = '/bin/bash',
  Optional[String]              $python_path = undef,
  Optional[Hash[String,String]] $env_variables = undef,
  Optional[String]              $postactivate_content = undef,
  Optional[String]              $postdeactivate_content = undef,
)
{

  if ($env_variables) and (($postactivate_content) or ($postdeactivate_content)) {
    fail('ERROR: you cannot use env_variables and postactivate_content/postdeactivate_content parameters at the same time!')
  }

  $virtualenv = $title

  $home = $user ? {
    'root'  => '/root',
    default => "/home/${user}"
  }

  $python_opt = $python_path ? {
    undef   => '',
    default => "--python=${python_path}",
  }

  exec { $virtualenv:
    command     => "${shell} -c \'. /usr/share/virtualenvwrapper/virtualenvwrapper.sh; mkvirtualenv ${python_opt} ${virtualenv}\'",
    user        => $user,
    environment => ["HOME=${home}"],
    creates     => "${home}/.virtualenvs/${virtualenv}",
    require     => Package['virtualenvwrapper'],
  }

  $activate = "${home}/.virtualenvs/${virtualenv}/bin/postactivate"
  $deactivate = "${home}/.virtualenvs/${virtualenv}/bin/postdeactivate"

  $hook_defaults = {
    'ensure'  => 'present',
    'owner'   => $user,
    'group'   => $user,
    'mode'    => '0600',
    'require' => Exec[$virtualenv],
  }

  if $env_variables {
    file { $activate:
      * => $hook_defaults,
    }

    file { $deactivate:
      * => $hook_defaults,
    }

    $env_variables.each |$var| {
      file_line { "${title}-export-${var}":
        path    => $activate,
        line    => "export ${var[0]}=${var[1]}",
        match   => "^export\ ${var[0]}\=",
        require => File[$activate],
      }
      file_line { "${title}-unset-${var}":
        path    => $deactivate,
        line    => "unset ${var[0]}",
        match   => "^unset\ ${var[0]}",
        require => File[$deactivate],
      }
    }
  }

  if $postactivate_content {
    file { $activate:
      content => $postactivate_content,
      *       => $hook_defaults,
    }
  }

  if $postdeactivate_content {
    file { $deactivate:
      content => $postdeactivate_content,
      *       => $hook_defaults,
    }
  }
}
