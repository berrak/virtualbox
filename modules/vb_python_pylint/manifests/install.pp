#
# Install Python Lint checker
#
class vb_python_pylint::install {

    package { "pylint" : ensure => installed }

}