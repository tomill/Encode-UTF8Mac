use inc::Module::Install;
all_from 'lib/Encode/UTF8Mac.pm';

requires 'Unicode::Normalize';

test_requires 'Test::More' => 0.94; # subtest

author_tests 'xt';

readme_from 'lib/Encode/UTF8Mac.pm';
resources(
    repository => 'http://github.com/tomi-ru/Encode-UTF8Mac',
    bugtracker => 'http://github.com/tomi-ru/Encode-UTF8Mac/issues',
);

WriteAll;
