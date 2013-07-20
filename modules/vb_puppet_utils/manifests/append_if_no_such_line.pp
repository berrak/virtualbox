##
## Appends a line to file unless it already exists in file.
##
define vb_puppet_utils::append_if_no_such_line( $file, $line ) {
    
    exec { "/bin/echo '$line' >> '$file'" :
        unless => "/bin/grep -Fx '$line' '$file'",
    
    }
    
}