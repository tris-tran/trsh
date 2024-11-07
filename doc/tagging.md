# Functions
- [@deprecated](@deprecated)
- [@function](@function)
- [@log](@log)
- [@print_trace](@print_trace)
- [@print_trace_source](@print_trace_source)
- [@suppress_warning](@suppress_warning)
- [@warning](@warning)
- [_load.load_once](_load.load_once)
- [_tagging.get_function](_tagging.get_function)
- [require](require)
# @suppress_warning

# @deprecated
 You can deprecated a functionality to show log
 The idea is to call this function in the first 
 line of a deprecated function. So every time is
 called it shows deprecated log.
 Also shows all the stack trace of the call

# @warning
 Prints a warning with all the stack trace of the call

# @log
 Prints a dugging log (instead of echo)
 and shows the line and file of the source
 usefull when debugin and later to delete all
 logs

# @print_trace_source
 Prints (without new line) the source of a call
 with one level of indirection @see @log

# @print_trace
 Prints the trace of the call, all the files
 functions and line numbrers

# @function
 Sample for a tag of a function that get
 the function declaration

# _tagging.get_function
 Obtains with one level of indirection the
 tagged function

