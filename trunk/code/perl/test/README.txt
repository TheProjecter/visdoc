VisDoc Unit Tests


======================================================================
RUN ALL TESTS

cd <PATH_TO_VISDOC>/code/perl/test/unit
perl ../bin/TestRunner.pl HashUtilsTests.pm StringUtilsTests.pm JavadocParserTests.pm FileParserTests.pm ParserTests.pm VisDocTests.pm MemberFormatterTests.pm FormatterTests.pm

======================================================================
RUN TEST FILES

VisDocTests
cd <PATH_TO_VISDOC>/code/perl/test/unit
perl ../bin/TestRunner.pl VisDocTests.pm

FileParserTests
cd <PATH_TO_VISDOC>/code/perl/test/unit
perl ../bin/TestRunner.pl FileParserTests.pm

ParserTest
cd <PATH_TO_VISDOC>/code/perl/test/unit
perl ../bin/TestRunner.pl ParserTests.pm

StringUtilsTests
cd <PATH_TO_VISDOC>/code/perl/test/unit
perl ../bin/TestRunner.pl StringUtilsTests.pm

HashUtilsTests
cd <PATH_TO_VISDOC>/code/perl/test/unit
perl ../bin/TestRunner.pl HashUtilsTests.pm

JavadocParserTests
cd <PATH_TO_VISDOC>/code/perl/test/unit
perl ../bin/TestRunner.pl JavadocParserTests.pm

MemberFormatterTests
cd <PATH_TO_VISDOC>/code/perl/test/unit
perl ../bin/TestRunner.pl MemberFormatterTests.pm

FormatterTests
cd <PATH_TO_VISDOC>/code/perl/test/unit
perl ../bin/TestRunner.pl FormatterTests.pm