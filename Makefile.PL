use inc::Module::Install;
all_from 'lib/Encode/UTF8Mac.pm';
readme_from;

requires 'Unicode::Normalize';

test_requires 'Test::More' => 0.96; # subtest/done_testing
auto_include_deps;

tests_recursive;

repository 'http://github.com/tomi-ru/Encode-UTF8Mac';
bugtracker 'http://github.com/tomi-ru/Encode-UTF8Mac/issues';

WriteAll;
