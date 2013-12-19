#
# Manage OpenCobol Embedded SQL Precompiler
#
class vb_ocesql::install {

    # Other Debian standard tools should already be installed

    # yacc och flex compatible tools
    package { "bison"        : ensure => installed }
    package { "flex"         : ensure => installed }

    
    # standard autotools
    package { "automake"     : ensure => installed }
    package { "autoconf"     : ensure => installed }
    package { "libtool"      : ensure => installed }
     
}