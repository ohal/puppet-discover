##
class test () {
  if $test_variable == false {
    $test_variable = 'Hello World'
  }
  notify {$test_variable:}
}
