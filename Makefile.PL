use 5.008;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'          => 'Text::Levenshtein::BVXS',
    'VERSION_FROM'	=> 'lib/Text/Levenshtein/BVXS.pm', # finds $VERSION
    'PREREQ_PM'		=> {},                             # e.g., Module::Name => 1.1
    ($] >= 5.005 ?                   ## Add these new keywords supported since 5.005
        (ABSTRACT_FROM => 'lib/Text/Levenshtein/BVXS.pm', # retrieve abstract from module
        AUTHOR         => 'Helmut Wollmersdorfer <helmut.wollmersdorfer@gmail.com>') : ()),
    'LICENSE'          => 'perl_5',
    'MIN_PERL_VERSION' => '5.10.1',
    'LIBS'             => [''],     # e.g., '-lm'
    'DEFINE'           => '',       # e.g., '-DHAVE_SOMETHING'
    'INC'              => '-I.',    # e.g., '-I. -I/usr/include/other'
    # https://metacpan.org/dist/ExtUtils-MakeMaker/view/lib/ExtUtils/MakeMaker/FAQ.pod
    'XSMULTI' => 1,
    # Un-comment this if you add C files to link with later:
    #'OBJECT'		=> '$(O_FILES)', # link all the C files too
    'TEST_REQUIRES'		=> {
        "Text::Levenshtein" => "0",
        "Test::Deep"        => "0",
        "Test::More"        => "0.88",
    },
);
