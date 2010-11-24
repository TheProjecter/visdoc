####################################################################
#
#    This file was generated using Parse::Yapp version 1.05.
#
#        Don't edit this file, use source file instead.
#
#             ANY CHANGE MADE HERE WILL BE LOST !
#
####################################################################
package Foswiki::Plugins::FreeMarkerPlugin::FreeMarkerParser;
use vars qw ( @ISA );
use strict;

@ISA= qw ( Parse::Yapp::Driver::FreeMarkerParser );
#Included Parse/Yapp/Driver.pm file----------------------------------------
{
#
# Module Parse::Yapp::Driver::FreeMarkerParser
#
# This module is part of the Parse::Yapp package available on your
# nearest CPAN
#
# Any use of this module in a standalone parser make the included
# text under the same copyright as the Parse::Yapp module itself.
#
# This notice should remain unchanged.
#
# (c) Copyright 1998-2001 Francois Desarmenien, all rights reserved.
# (see the pod text in Parse::Yapp module for use and distribution rights)
#

package Parse::Yapp::Driver::FreeMarkerParser;

require 5.004;

use strict;

use vars qw ( $VERSION $COMPATIBLE $FILENAME );

$VERSION = '1.05';
$COMPATIBLE = '0.07';
$FILENAME=__FILE__;

use Carp;

#Known parameters, all starting with YY (leading YY will be discarded)
my(%params)=(YYLEX => 'CODE', 'YYERROR' => 'CODE', YYVERSION => '',
			 YYRULES => 'ARRAY', YYSTATES => 'ARRAY', YYDEBUG => '');
#Mandatory parameters
my(@params)=('LEX','RULES','STATES');

sub new {
    my($class)=shift;
	my($errst,$nberr,$token,$value,$check,$dotpos);
    my($self)={ ERROR => \&_Error,
				ERRST => \$errst,
                NBERR => \$nberr,
				TOKEN => \$token,
				VALUE => \$value,
				DOTPOS => \$dotpos,
				STACK => [],
				DEBUG => 0,
				CHECK => \$check };

	_CheckParams( [], \%params, \@_, $self );

		exists($$self{VERSION})
	and	$$self{VERSION} < $COMPATIBLE
	and	croak "Yapp driver version $VERSION ".
			  "incompatible with version $$self{VERSION}:\n".
			  "Please recompile parser module.";

        ref($class)
    and $class=ref($class);

    bless($self,$class);
}

sub YYParse {
    my($self)=shift;
    my($retval);

	_CheckParams( \@params, \%params, \@_, $self );

	if($$self{DEBUG}) {
		_DBLoad();
		$retval = eval '$self->_DBParse()';#Do not create stab entry on compile
        $@ and die $@;
	}
	else {
		$retval = $self->_Parse();
	}
    $retval
}

sub YYData {
	my($self)=shift;

		exists($$self{USER})
	or	$$self{USER}={};

	$$self{USER};
	
}

sub YYErrok {
	my($self)=shift;

	${$$self{ERRST}}=0;
    undef;
}

sub YYNberr {
	my($self)=shift;

	${$$self{NBERR}};
}

sub YYRecovering {
	my($self)=shift;

	${$$self{ERRST}} != 0;
}

sub YYAbort {
	my($self)=shift;

	${$$self{CHECK}}='ABORT';
    undef;
}

sub YYAccept {
	my($self)=shift;

	${$$self{CHECK}}='ACCEPT';
    undef;
}

sub YYError {
	my($self)=shift;

	${$$self{CHECK}}='ERROR';
    undef;
}

sub YYSemval {
	my($self)=shift;
	my($index)= $_[0] - ${$$self{DOTPOS}} - 1;

		$index < 0
	and	-$index <= @{$$self{STACK}}
	and	return $$self{STACK}[$index][1];

	undef;	#Invalid index
}

sub YYCurtok {
	my($self)=shift;

        @_
    and ${$$self{TOKEN}}=$_[0];
    ${$$self{TOKEN}};
}

sub YYCurval {
	my($self)=shift;

        @_
    and ${$$self{VALUE}}=$_[0];
    ${$$self{VALUE}};
}

sub YYExpect {
    my($self)=shift;

    keys %{$self->{STATES}[$self->{STACK}[-1][0]]{ACTIONS}}
}

sub YYLexer {
    my($self)=shift;

	$$self{LEX};
}


#################
# Private stuff #
#################


sub _CheckParams {
	my($mandatory,$checklist,$inarray,$outhash)=@_;
	my($prm,$value);
	my($prmlst)={};

	while(($prm,$value)=splice(@$inarray,0,2)) {
        $prm=uc($prm);
			exists($$checklist{$prm})
		or	croak("Unknow parameter '$prm'");
			ref($value) eq $$checklist{$prm}
		or	croak("Invalid value for parameter '$prm'");
        $prm=unpack('@2A*',$prm);
		$$outhash{$prm}=$value;
	}
	for (@$mandatory) {
			exists($$outhash{$_})
		or	croak("Missing mandatory parameter '".lc($_)."'");
	}
}

sub _Error {
	print "Parse error.\n";
}

sub _DBLoad {
	{
		no strict 'refs';

			exists(${__PACKAGE__.'::'}{_DBParse})#Already loaded ?
		and	return;
	}
	my($fname)=__FILE__;
	my(@drv);
	open(DRV,"<$fname") or die "Report this as a BUG: Cannot open $fname";
	while(<DRV>) {
                	/^\s*sub\s+_Parse\s*{\s*$/ .. /^\s*}\s*#\s*_Parse\s*$/
        	and     do {
                	s/^#DBG>//;
                	push(@drv,$_);
        	}
	}
	close(DRV);

	$drv[0]=~s/_P/_DBP/;
	eval join('',@drv);
}

#Note that for loading debugging version of the driver,
#this file will be parsed from 'sub _Parse' up to '}#_Parse' inclusive.
#So, DO NOT remove comment at end of sub !!!
sub _Parse {
    my($self)=shift;

	my($rules,$states,$lex,$error)
     = @$self{ 'RULES', 'STATES', 'LEX', 'ERROR' };
	my($errstatus,$nberror,$token,$value,$stack,$check,$dotpos)
     = @$self{ 'ERRST', 'NBERR', 'TOKEN', 'VALUE', 'STACK', 'CHECK', 'DOTPOS' };

#DBG>	my($debug)=$$self{DEBUG};
#DBG>	my($dbgerror)=0;

#DBG>	my($ShowCurToken) = sub {
#DBG>		my($tok)='>';
#DBG>		for (split('',$$token)) {
#DBG>			$tok.=		(ord($_) < 32 or ord($_) > 126)
#DBG>					?	sprintf('<%02X>',ord($_))
#DBG>					:	$_;
#DBG>		}
#DBG>		$tok.='<';
#DBG>	};

	$$errstatus=0;
	$$nberror=0;
	($$token,$$value)=(undef,undef);
	@$stack=( [ 0, undef ] );
	$$check='';

    while(1) {
        my($actions,$act,$stateno);

        $stateno=$$stack[-1][0];
        $actions=$$states[$stateno];

#DBG>	print STDERR ('-' x 40),"\n";
#DBG>		$debug & 0x2
#DBG>	and	print STDERR "In state $stateno:\n";
#DBG>		$debug & 0x08
#DBG>	and	print STDERR "Stack:[".
#DBG>					 join(',',map { $$_[0] } @$stack).
#DBG>					 "]\n";


        if  (exists($$actions{ACTIONS})) {

				defined($$token)
            or	do {
				($$token,$$value)=&$lex($self);
#DBG>				$debug & 0x01
#DBG>			and	print STDERR "Need token. Got ".&$ShowCurToken."\n";
			};

            $act=   exists($$actions{ACTIONS}{$$token})
                    ?   $$actions{ACTIONS}{$$token}
                    :   exists($$actions{DEFAULT})
                        ?   $$actions{DEFAULT}
                        :   undef;
        }
        else {
            $act=$$actions{DEFAULT};
#DBG>			$debug & 0x01
#DBG>		and	print STDERR "Don't need token.\n";
        }

            defined($act)
        and do {

                $act > 0
            and do {        #shift

#DBG>				$debug & 0x04
#DBG>			and	print STDERR "Shift and go to state $act.\n";

					$$errstatus
				and	do {
					--$$errstatus;

#DBG>					$debug & 0x10
#DBG>				and	$dbgerror
#DBG>				and	$$errstatus == 0
#DBG>				and	do {
#DBG>					print STDERR "**End of Error recovery.\n";
#DBG>					$dbgerror=0;
#DBG>				};
				};


                push(@$stack,[ $act, $$value ]);

					$$token ne ''	#Don't eat the eof
				and	$$token=$$value=undef;
                next;
            };

            #reduce
            my($lhs,$len,$code,@sempar,$semval);
            ($lhs,$len,$code)=@{$$rules[-$act]};

#DBG>			$debug & 0x04
#DBG>		and	$act
#DBG>		and	print STDERR "Reduce using rule ".-$act." ($lhs,$len): ";

                $act
            or  $self->YYAccept();

            $$dotpos=$len;

                unpack('A1',$lhs) eq '@'    #In line rule
            and do {
                    $lhs =~ /^\@[0-9]+\-([0-9]+)$/
                or  die "In line rule name '$lhs' ill formed: ".
                        "report it as a BUG.\n";
                $$dotpos = $1;
            };

            @sempar =       $$dotpos
                        ?   map { $$_[1] } @$stack[ -$$dotpos .. -1 ]
                        :   ();

            $semval = $code ? &$code( $self, @sempar )
                            : @sempar ? $sempar[0] : undef;

            splice(@$stack,-$len,$len);

                $$check eq 'ACCEPT'
            and do {

#DBG>			$debug & 0x04
#DBG>		and	print STDERR "Accept.\n";

				return($semval);
			};

                $$check eq 'ABORT'
            and	do {

#DBG>			$debug & 0x04
#DBG>		and	print STDERR "Abort.\n";

				return(undef);

			};

#DBG>			$debug & 0x04
#DBG>		and	print STDERR "Back to state $$stack[-1][0], then ";

                $$check eq 'ERROR'
            or  do {
#DBG>				$debug & 0x04
#DBG>			and	print STDERR 
#DBG>				    "go to state $$states[$$stack[-1][0]]{GOTOS}{$lhs}.\n";

#DBG>				$debug & 0x10
#DBG>			and	$dbgerror
#DBG>			and	$$errstatus == 0
#DBG>			and	do {
#DBG>				print STDERR "**End of Error recovery.\n";
#DBG>				$dbgerror=0;
#DBG>			};

			    push(@$stack,
                     [ $$states[$$stack[-1][0]]{GOTOS}{$lhs}, $semval ]);
                $$check='';
                next;
            };

#DBG>			$debug & 0x04
#DBG>		and	print STDERR "Forced Error recovery.\n";

            $$check='';

        };

        #Error
            $$errstatus
        or   do {

            $$errstatus = 1;
            &$error($self);
                $$errstatus # if 0, then YYErrok has been called
            or  next;       # so continue parsing

#DBG>			$debug & 0x10
#DBG>		and	do {
#DBG>			print STDERR "**Entering Error recovery.\n";
#DBG>			++$dbgerror;
#DBG>		};

            ++$$nberror;

        };

			$$errstatus == 3	#The next token is not valid: discard it
		and	do {
				$$token eq ''	# End of input: no hope
			and	do {
#DBG>				$debug & 0x10
#DBG>			and	print STDERR "**At eof: aborting.\n";
				return(undef);
			};

#DBG>			$debug & 0x10
#DBG>		and	print STDERR "**Dicard invalid token ".&$ShowCurToken.".\n";

			$$token=$$value=undef;
		};

        $$errstatus=3;

		while(	  @$stack
			  and (		not exists($$states[$$stack[-1][0]]{ACTIONS})
			        or  not exists($$states[$$stack[-1][0]]{ACTIONS}{error})
					or	$$states[$$stack[-1][0]]{ACTIONS}{error} <= 0)) {

#DBG>			$debug & 0x10
#DBG>		and	print STDERR "**Pop state $$stack[-1][0].\n";

			pop(@$stack);
		}

			@$stack
		or	do {

#DBG>			$debug & 0x10
#DBG>		and	print STDERR "**No state left on stack: aborting.\n";

			return(undef);
		};

		#shift the error token

#DBG>			$debug & 0x10
#DBG>		and	print STDERR "**Shift \$error token and go to state ".
#DBG>						 $$states[$$stack[-1][0]]{ACTIONS}{error}.
#DBG>						 ".\n";

		push(@$stack, [ $$states[$$stack[-1][0]]{ACTIONS}{error}, undef ]);

    }

    #never reached
	croak("Error in driver logic. Please, report it as a BUG");

}#_Parse
#DO NOT remove comment

1;

}
#End of include--------------------------------------------------




sub new {
        my($class)=shift;
        ref($class)
    and $class=ref($class);

    my($self)=$class->SUPER::new( yyversion => '1.05',
                                  yystates =>
[
	{#State 0
		ACTIONS => {
			'tag_else' => 9,
			"<#" => 10,
			"whitespace" => 18,
			'variable_verbatim' => 15,
			'string' => 8,
			"\${" => 20
		},
		DEFAULT => -17,
		GOTOS => {
			'tag_assign' => 3,
			'tag_ftl' => 2,
			'whitespace' => 1,
			'content_item' => 5,
			'variable' => 4,
			'tmp_tag_condition' => 16,
			'tag_list' => 6,
			'tag_if' => 17,
			'content' => 7,
			'tag_macro' => 11,
			'tag_open_start' => 19,
			'tag_macro_call' => 12,
			'tag' => 13,
			'tag_comment' => 14
		}
	},
	{#State 1
		ACTIONS => {
			"<\@" => 21
		},
		GOTOS => {
			'tag_macro_open_start' => 22
		}
	},
	{#State 2
		DEFAULT => -14
	},
	{#State 3
		DEFAULT => -7
	},
	{#State 4
		DEFAULT => -4
	},
	{#State 5
		ACTIONS => {
			'variable_verbatim' => 15,
			'string' => 8,
			'tag_else' => 9,
			"<#" => 10,
			"whitespace" => 18,
			"<\@" => -17,
			"\${" => 20
		},
		DEFAULT => -1,
		GOTOS => {
			'tag_assign' => 3,
			'tag_ftl' => 2,
			'whitespace' => 1,
			'content_item' => 5,
			'variable' => 4,
			'tmp_tag_condition' => 16,
			'tag_list' => 6,
			'tag_if' => 17,
			'content' => 23,
			'tag_macro' => 11,
			'tag_open_start' => 19,
			'tag_macro_call' => 12,
			'tag' => 13,
			'tag_comment' => 14
		}
	},
	{#State 6
		DEFAULT => -10
	},
	{#State 7
		ACTIONS => {
			'' => 24
		}
	},
	{#State 8
		DEFAULT => -6
	},
	{#State 9
		DEFAULT => -12
	},
	{#State 10
		DEFAULT => -94
	},
	{#State 11
		DEFAULT => -8
	},
	{#State 12
		DEFAULT => -9
	},
	{#State 13
		DEFAULT => -3
	},
	{#State 14
		DEFAULT => -15
	},
	{#State 15
		DEFAULT => -5
	},
	{#State 16
		DEFAULT => -13
	},
	{#State 17
		DEFAULT => -11
	},
	{#State 18
		DEFAULT => -16
	},
	{#State 19
		ACTIONS => {
			"if" => 26,
			"list" => 30,
			"ftl" => 28,
			"assign" => 32,
			"_if_" => 25,
			"macro" => 33,
			"--" => 27
		},
		GOTOS => {
			'directive_assign' => 29,
			'directive_macro' => 31
		}
	},
	{#State 20
		DEFAULT => -143,
		GOTOS => {
			'@21-1' => 34
		}
	},
	{#State 21
		DEFAULT => -95
	},
	{#State 22
		DEFAULT => -122,
		GOTOS => {
			'@9-2' => 35
		}
	},
	{#State 23
		DEFAULT => -2
	},
	{#State 24
		DEFAULT => 0
	},
	{#State 25
		DEFAULT => -132,
		GOTOS => {
			'@16-2' => 36
		}
	},
	{#State 26
		DEFAULT => -129,
		GOTOS => {
			'@14-2' => 37
		}
	},
	{#State 27
		DEFAULT => -141,
		GOTOS => {
			'@20-2' => 38
		}
	},
	{#State 28
		DEFAULT => -135,
		GOTOS => {
			'@18-2' => 39
		}
	},
	{#State 29
		ACTIONS => {
			'DATA_KEY' => 40
		},
		GOTOS => {
			'expr_assignments' => 42,
			'expr_assignment' => 41
		}
	},
	{#State 30
		DEFAULT => -125,
		GOTOS => {
			'@11-2' => 43
		}
	},
	{#State 31
		ACTIONS => {
			'DATA_KEY' => 44
		}
	},
	{#State 32
		DEFAULT => -107
	},
	{#State 33
		DEFAULT => -112
	},
	{#State 34
		ACTIONS => {
			"-" => 47,
			".." => 45,
			".vars" => 57,
			"+" => 50,
			'DATA_KEY' => 49,
			"{" => 58,
			'string' => 51,
			"(" => 64,
			'VAR' => 67,
			"r" => 66,
			"false" => 68,
			"true" => 52,
			"[" => 53,
			'NUMBER' => 54
		},
		GOTOS => {
			'exp' => 55,
			'array_str' => 46,
			'hash_op' => 56,
			'array_pos' => 48,
			'type_op' => 59,
			'data' => 60,
			'func_op' => 61,
			'array_op' => 63,
			'hash' => 62,
			'string_op' => 65
		}
	},
	{#State 35
		ACTIONS => {
			'DATA_KEY' => 69
		}
	},
	{#State 36
		ACTIONS => {
			"-" => 47,
			".." => 45,
			".vars" => 57,
			"+" => 50,
			'DATA_KEY' => 49,
			"{" => 58,
			'string' => 51,
			"(" => 73,
			"!" => 70,
			'VAR' => 67,
			"r" => 66,
			"false" => 68,
			"true" => 52,
			"[" => 53,
			'NUMBER' => 54
		},
		GOTOS => {
			'exp' => 55,
			'array_str' => 46,
			'hash_op' => 56,
			'array_pos' => 48,
			'type_op' => 59,
			'data' => 72,
			'func_op' => 61,
			'array_op' => 63,
			'hash' => 62,
			'string_op' => 65,
			'exp_logic' => 71
		}
	},
	{#State 37
		ACTIONS => {
			"(" => 80,
			"!" => 76,
			'string' => 75,
			'NUMBER' => 78
		},
		GOTOS => {
			'exp_logic_unexpanded' => 77,
			'exp_condition_unexpanded' => 79,
			'exp_condition_var_unexpanded' => 74
		}
	},
	{#State 38
		ACTIONS => {
			'string' => 81
		}
	},
	{#State 39
		ACTIONS => {
			'DATA_KEY' => 82
		},
		GOTOS => {
			'expr_ftl_assignments' => 84,
			'expr_ftl_assignment' => 83
		}
	},
	{#State 40
		ACTIONS => {
			"=" => 85
		},
		DEFAULT => -104,
		GOTOS => {
			'@5-3' => 86
		}
	},
	{#State 41
		ACTIONS => {
			'DATA_KEY' => 87
		},
		DEFAULT => -91,
		GOTOS => {
			'expr_assignments' => 88,
			'expr_assignment' => 41
		}
	},
	{#State 42
		DEFAULT => -102,
		GOTOS => {
			'@4-3' => 89
		}
	},
	{#State 43
		ACTIONS => {
			"-" => 47,
			".." => 45,
			".vars" => 57,
			"+" => 50,
			'DATA_KEY' => 49,
			"{" => 58,
			'string' => 51,
			"(" => 64,
			'VAR' => 67,
			"r" => 66,
			"false" => 68,
			"true" => 52,
			"[" => 53,
			'NUMBER' => 54
		},
		GOTOS => {
			'exp' => 55,
			'array_str' => 46,
			'hash_op' => 56,
			'array_pos' => 48,
			'type_op' => 59,
			'data' => 90,
			'func_op' => 61,
			'array_op' => 63,
			'hash' => 62,
			'string_op' => 65
		}
	},
	{#State 44
		ACTIONS => {
			'DATA_KEY' => 91
		},
		DEFAULT => -117,
		GOTOS => {
			'macroparams' => 92,
			'macroparam' => 93
		}
	},
	{#State 45
		ACTIONS => {
			'DATA_KEY' => 95,
			'NUMBER' => 96
		},
		GOTOS => {
			'array_pos' => 94
		}
	},
	{#State 46
		DEFAULT => -208
	},
	{#State 47
		ACTIONS => {
			"-" => 47,
			'VAR' => 67,
			"+" => 50,
			"false" => 68,
			"true" => 52,
			'NUMBER' => 97
		},
		GOTOS => {
			'exp' => 98
		}
	},
	{#State 48
		ACTIONS => {
			".." => 99
		}
	},
	{#State 49
		ACTIONS => {
			".." => -212,
			"(" => 100
		},
		DEFAULT => -145
	},
	{#State 50
		ACTIONS => {
			"-" => 47,
			'VAR' => 67,
			"+" => 50,
			"false" => 68,
			"true" => 52,
			'NUMBER' => 97
		},
		GOTOS => {
			'exp' => 101
		}
	},
	{#State 51
		DEFAULT => -196
	},
	{#State 52
		DEFAULT => -24
	},
	{#State 53
		ACTIONS => {
			"-" => 47,
			"+" => 50,
			"{" => 58,
			'string' => 104,
			'VAR' => 67,
			"false" => 68,
			"true" => 52,
			"[" => 105,
			'NUMBER' => 97,
			"]" => 106
		},
		GOTOS => {
			'hash' => 62,
			'exp' => 107,
			'array_str' => 102,
			'sequence_item' => 109,
			'hash_op' => 108,
			'sequence' => 103,
			'hashes' => 110
		}
	},
	{#State 54
		ACTIONS => {
			".." => -211
		},
		DEFAULT => -21
	},
	{#State 55
		ACTIONS => {
			"-" => 111,
			"+" => 112,
			"%" => 113,
			"^" => 114,
			"*" => 115,
			"/" => 116
		},
		DEFAULT => -152
	},
	{#State 56
		ACTIONS => {
			"+" => 117
		},
		DEFAULT => -149
	},
	{#State 57
		DEFAULT => -146
	},
	{#State 58
		ACTIONS => {
			'string' => 118
		},
		GOTOS => {
			'hashvalue' => 119,
			'hashvalues' => 120
		}
	},
	{#State 59
		DEFAULT => -148
	},
	{#State 60
		ACTIONS => {
			"}" => 121,
			"!=" => 129,
			"?" => 130,
			"+" => 122,
			"gte" => 131,
			"==" => 124,
			"lte" => 123,
			"??" => 132,
			"!" => 125,
			"*" => 126,
			"gt" => 133,
			"[" => 127,
			"." => 134,
			"lt" => 128
		}
	},
	{#State 61
		DEFAULT => -151
	},
	{#State 62
		DEFAULT => -202
	},
	{#State 63
		DEFAULT => -150
	},
	{#State 64
		ACTIONS => {
			"-" => 47,
			".." => 45,
			".vars" => 57,
			"+" => 50,
			'DATA_KEY' => 49,
			"{" => 58,
			'string' => 51,
			"(" => 64,
			'VAR' => 67,
			"r" => 66,
			"false" => 68,
			"true" => 52,
			"[" => 53,
			'NUMBER' => 54
		},
		GOTOS => {
			'exp' => 55,
			'array_str' => 46,
			'hash_op' => 56,
			'array_pos' => 48,
			'type_op' => 59,
			'data' => 135,
			'func_op' => 61,
			'array_op' => 63,
			'hash' => 62,
			'string_op' => 65
		}
	},
	{#State 65
		ACTIONS => {
			"+" => 136
		},
		DEFAULT => -147
	},
	{#State 66
		ACTIONS => {
			'string' => 137
		}
	},
	{#State 67
		ACTIONS => {
			"=" => 138
		},
		DEFAULT => -22
	},
	{#State 68
		DEFAULT => -25
	},
	{#State 69
		ACTIONS => {
			'DATA_KEY' => 139
		},
		DEFAULT => -121,
		GOTOS => {
			'macro_assignments' => 140,
			'macro_assignment' => 141
		}
	},
	{#State 70
		ACTIONS => {
			"-" => 47,
			".." => 45,
			".vars" => 57,
			"+" => 50,
			'DATA_KEY' => 49,
			"{" => 58,
			'string' => 51,
			"(" => 73,
			"!" => 70,
			'VAR' => 67,
			"r" => 66,
			"false" => 68,
			"true" => 52,
			"[" => 53,
			'NUMBER' => 54
		},
		GOTOS => {
			'exp' => 55,
			'array_str' => 46,
			'hash_op' => 56,
			'array_pos' => 48,
			'type_op' => 59,
			'data' => 72,
			'func_op' => 61,
			'array_op' => 63,
			'hash' => 62,
			'string_op' => 65,
			'exp_logic' => 142
		}
	},
	{#State 71
		ACTIONS => {
			"!" => 143,
			"&&" => 145,
			"||" => 144
		},
		DEFAULT => -133,
		GOTOS => {
			'@17-4' => 146
		}
	},
	{#State 72
		ACTIONS => {
			"+" => 122,
			"==" => 124,
			"lte" => 123,
			"!" => 125,
			"*" => 126,
			"[" => 127,
			"lt" => 128,
			"!=" => 129,
			"?" => 130,
			"gte" => 131,
			"??" => 132,
			"gt" => 133,
			"." => 134
		},
		DEFAULT => -34
	},
	{#State 73
		ACTIONS => {
			"-" => 47,
			".." => 45,
			".vars" => 57,
			"+" => 50,
			'DATA_KEY' => 49,
			"{" => 58,
			'string' => 51,
			"(" => 73,
			"!" => 70,
			'VAR' => 67,
			"r" => 66,
			"false" => 68,
			"true" => 52,
			"[" => 53,
			'NUMBER' => 54
		},
		GOTOS => {
			'exp' => 55,
			'array_str' => 46,
			'hash_op' => 56,
			'array_pos' => 48,
			'type_op' => 59,
			'data' => 148,
			'func_op' => 61,
			'array_op' => 63,
			'hash' => 62,
			'string_op' => 65,
			'exp_logic' => 147
		}
	},
	{#State 74
		ACTIONS => {
			"!=" => 152,
			"gte" => 153,
			"==" => 150,
			"lte" => 149,
			"=" => 155,
			"??" => 154,
			"gt" => 156,
			"lt" => 151
		},
		DEFAULT => -46
	},
	{#State 75
		ACTIONS => {
			"?" => 157
		},
		DEFAULT => -58
	},
	{#State 76
		ACTIONS => {
			"(" => 80,
			"!" => 76,
			'string' => 75,
			'NUMBER' => 78
		},
		GOTOS => {
			'exp_logic_unexpanded' => 158,
			'exp_condition_unexpanded' => 79,
			'exp_condition_var_unexpanded' => 74
		}
	},
	{#State 77
		ACTIONS => {
			"!" => 159,
			"&&" => 161,
			"||" => 160
		},
		DEFAULT => -130,
		GOTOS => {
			'@15-4' => 162
		}
	},
	{#State 78
		DEFAULT => -60
	},
	{#State 79
		DEFAULT => -40
	},
	{#State 80
		ACTIONS => {
			"(" => 80,
			"!" => 76,
			'string' => 75,
			'NUMBER' => 78
		},
		GOTOS => {
			'exp_logic_unexpanded' => 163,
			'exp_condition_unexpanded' => 79,
			'exp_condition_var_unexpanded' => 74
		}
	},
	{#State 81
		ACTIONS => {
			"--" => 164
		}
	},
	{#State 82
		ACTIONS => {
			"=" => 165
		}
	},
	{#State 83
		ACTIONS => {
			'DATA_KEY' => 82
		},
		DEFAULT => -138,
		GOTOS => {
			'expr_ftl_assignments' => 166,
			'expr_ftl_assignment' => 83
		}
	},
	{#State 84
		DEFAULT => -136,
		GOTOS => {
			'@19-4' => 167
		}
	},
	{#State 85
		ACTIONS => {
			"-" => 47,
			".." => 45,
			".vars" => 57,
			"+" => 50,
			'DATA_KEY' => 49,
			"{" => 58,
			'string' => 51,
			"(" => 64,
			'VAR' => 67,
			"r" => 66,
			"false" => 68,
			"true" => 52,
			"[" => 53,
			'NUMBER' => 54
		},
		GOTOS => {
			'exp' => 55,
			'array_str' => 46,
			'hash_op' => 56,
			'array_pos' => 48,
			'type_op' => 59,
			'data' => 168,
			'func_op' => 61,
			'array_op' => 63,
			'hash' => 62,
			'string_op' => 65
		}
	},
	{#State 86
		ACTIONS => {
			">" => 170
		},
		GOTOS => {
			'tag_open_end' => 169
		}
	},
	{#State 87
		ACTIONS => {
			"=" => 85
		}
	},
	{#State 88
		DEFAULT => -92
	},
	{#State 89
		ACTIONS => {
			">" => 170
		},
		GOTOS => {
			'tag_open_end' => 171
		}
	},
	{#State 90
		ACTIONS => {
			"!=" => 129,
			"?" => 130,
			"+" => 122,
			"gte" => 131,
			"==" => 124,
			"lte" => 123,
			"??" => 132,
			"!" => 125,
			"*" => 126,
			"gt" => 133,
			"[" => 127,
			"as" => 172,
			"." => 134,
			"lt" => 128
		}
	},
	{#State 91
		DEFAULT => -116
	},
	{#State 92
		DEFAULT => -109,
		GOTOS => {
			'@7-4' => 173
		}
	},
	{#State 93
		ACTIONS => {
			'DATA_KEY' => 91
		},
		DEFAULT => -114,
		GOTOS => {
			'macroparams' => 174,
			'macroparam' => 93
		}
	},
	{#State 94
		DEFAULT => -210
	},
	{#State 95
		DEFAULT => -212
	},
	{#State 96
		DEFAULT => -211
	},
	{#State 97
		DEFAULT => -21
	},
	{#State 98
		ACTIONS => {
			"-" => 111,
			"+" => 112,
			"%" => 113,
			"^" => 114,
			"*" => 115,
			"/" => 116
		},
		DEFAULT => -30
	},
	{#State 99
		ACTIONS => {
			'DATA_KEY' => 95,
			'NUMBER' => 96
		},
		GOTOS => {
			'array_pos' => 175
		}
	},
	{#State 100
		ACTIONS => {
			'string' => 176
		}
	},
	{#State 101
		ACTIONS => {
			"-" => 111,
			"+" => 112,
			"%" => 113,
			"^" => 114,
			"*" => 115,
			"/" => 116
		},
		DEFAULT => -31
	},
	{#State 102
		DEFAULT => -83
	},
	{#State 103
		ACTIONS => {
			"]" => 177
		}
	},
	{#State 104
		DEFAULT => -85
	},
	{#State 105
		ACTIONS => {
			"-" => 47,
			"+" => 50,
			'string' => 104,
			'VAR' => 67,
			"false" => 68,
			"true" => 52,
			"[" => 105,
			'NUMBER' => 97,
			"]" => 106
		},
		GOTOS => {
			'exp' => 107,
			'array_str' => 102,
			'sequence_item' => 109,
			'sequence' => 103
		}
	},
	{#State 106
		DEFAULT => -88
	},
	{#State 107
		ACTIONS => {
			"-" => 111,
			"+" => 112,
			"/" => 116,
			"%" => 113,
			"^" => 114,
			"*" => 115
		},
		DEFAULT => -84
	},
	{#State 108
		ACTIONS => {
			"+" => 117
		},
		DEFAULT => -200
	},
	{#State 109
		ACTIONS => {
			"," => 178
		},
		DEFAULT => -86
	},
	{#State 110
		ACTIONS => {
			"," => 179,
			"]" => 180
		}
	},
	{#State 111
		ACTIONS => {
			"-" => 47,
			'VAR' => 67,
			"+" => 50,
			"false" => 68,
			"true" => 52,
			'NUMBER' => 97
		},
		GOTOS => {
			'exp' => 181
		}
	},
	{#State 112
		ACTIONS => {
			"-" => 47,
			'VAR' => 67,
			"+" => 50,
			"false" => 68,
			"true" => 52,
			'NUMBER' => 97
		},
		GOTOS => {
			'exp' => 182
		}
	},
	{#State 113
		ACTIONS => {
			"-" => 47,
			'VAR' => 67,
			"+" => 50,
			"false" => 68,
			"true" => 52,
			'NUMBER' => 97
		},
		GOTOS => {
			'exp' => 183
		}
	},
	{#State 114
		ACTIONS => {
			"-" => 47,
			'VAR' => 67,
			"+" => 50,
			"false" => 68,
			"true" => 52,
			'NUMBER' => 97
		},
		GOTOS => {
			'exp' => 184
		}
	},
	{#State 115
		ACTIONS => {
			"-" => 47,
			'VAR' => 67,
			"+" => 50,
			"false" => 68,
			"true" => 52,
			'NUMBER' => 97
		},
		GOTOS => {
			'exp' => 185
		}
	},
	{#State 116
		ACTIONS => {
			"-" => 47,
			'VAR' => 67,
			"+" => 50,
			"false" => 68,
			"true" => 52,
			'NUMBER' => 97
		},
		GOTOS => {
			'exp' => 186
		}
	},
	{#State 117
		ACTIONS => {
			"{" => 58
		},
		GOTOS => {
			'hash' => 187
		}
	},
	{#State 118
		ACTIONS => {
			":" => 188
		}
	},
	{#State 119
		DEFAULT => -205
	},
	{#State 120
		ACTIONS => {
			"}" => 189,
			"," => 190
		}
	},
	{#State 121
		DEFAULT => -144
	},
	{#State 122
		ACTIONS => {
			"-" => 47,
			".." => 45,
			".vars" => 57,
			"+" => 50,
			'DATA_KEY' => 49,
			"{" => 58,
			'string' => 51,
			"(" => 64,
			'VAR' => 67,
			"r" => 66,
			"false" => 68,
			"true" => 52,
			"[" => 53,
			'NUMBER' => 54
		},
		GOTOS => {
			'exp' => 55,
			'array_str' => 46,
			'hash_op' => 56,
			'array_pos' => 48,
			'type_op' => 59,
			'data' => 191,
			'func_op' => 61,
			'array_op' => 63,
			'hash' => 62,
			'string_op' => 65
		}
	},
	{#State 123
		ACTIONS => {
			"-" => 47,
			".." => 45,
			".vars" => 57,
			"+" => 50,
			'DATA_KEY' => 49,
			"{" => 58,
			'string' => 51,
			"(" => 64,
			'VAR' => 67,
			"r" => 66,
			"false" => 68,
			"true" => 52,
			"[" => 53,
			'NUMBER' => 54
		},
		GOTOS => {
			'exp' => 55,
			'array_str' => 46,
			'hash_op' => 56,
			'array_pos' => 48,
			'type_op' => 59,
			'data' => 192,
			'func_op' => 61,
			'array_op' => 63,
			'hash' => 62,
			'string_op' => 65
		}
	},
	{#State 124
		ACTIONS => {
			"-" => 47,
			".." => 45,
			".vars" => 57,
			"+" => 50,
			'DATA_KEY' => 49,
			"{" => 58,
			'string' => 51,
			"(" => 64,
			'VAR' => 67,
			"r" => 66,
			"false" => 68,
			"true" => 52,
			"[" => 53,
			'NUMBER' => 54
		},
		GOTOS => {
			'exp' => 55,
			'array_str' => 46,
			'hash_op' => 56,
			'array_pos' => 48,
			'type_op' => 59,
			'data' => 193,
			'func_op' => 61,
			'array_op' => 63,
			'hash' => 62,
			'string_op' => 65
		}
	},
	{#State 125
		ACTIONS => {
			"-" => 47,
			".." => 45,
			".vars" => 57,
			"+" => 50,
			'DATA_KEY' => 49,
			"{" => 58,
			'string' => 51,
			"(" => 64,
			'VAR' => 67,
			"r" => 66,
			"false" => 68,
			"true" => 52,
			"[" => 53,
			'NUMBER' => 54
		},
		GOTOS => {
			'exp' => 55,
			'array_str' => 46,
			'hash_op' => 56,
			'array_pos' => 48,
			'type_op' => 59,
			'data' => 194,
			'func_op' => 61,
			'array_op' => 63,
			'hash' => 62,
			'string_op' => 65
		}
	},
	{#State 126
		ACTIONS => {
			"-" => 47,
			".." => 45,
			".vars" => 57,
			"+" => 50,
			'DATA_KEY' => 49,
			"{" => 58,
			'string' => 51,
			"(" => 64,
			'VAR' => 67,
			"r" => 66,
			"false" => 68,
			"true" => 52,
			"[" => 53,
			'NUMBER' => 54
		},
		GOTOS => {
			'exp' => 55,
			'array_str' => 46,
			'hash_op' => 56,
			'array_pos' => 48,
			'type_op' => 59,
			'data' => 195,
			'func_op' => 61,
			'array_op' => 63,
			'hash' => 62,
			'string_op' => 65
		}
	},
	{#State 127
		ACTIONS => {
			".." => 196,
			"-" => 47,
			'DATA_KEY' => 198,
			"+" => 50,
			'string' => 199,
			'VAR' => 67,
			"false" => 68,
			"true" => 52,
			'NUMBER' => 54,
			"]" => 200
		},
		GOTOS => {
			'exp' => 201,
			'array_pos' => 197
		}
	},
	{#State 128
		ACTIONS => {
			"-" => 47,
			".." => 45,
			".vars" => 57,
			"+" => 50,
			'DATA_KEY' => 49,
			"{" => 58,
			'string' => 51,
			"(" => 64,
			'VAR' => 67,
			"r" => 66,
			"false" => 68,
			"true" => 52,
			"[" => 53,
			'NUMBER' => 54
		},
		GOTOS => {
			'exp' => 55,
			'array_str' => 46,
			'hash_op' => 56,
			'array_pos' => 48,
			'type_op' => 59,
			'data' => 202,
			'func_op' => 61,
			'array_op' => 63,
			'hash' => 62,
			'string_op' => 65
		}
	},
	{#State 129
		ACTIONS => {
			"-" => 47,
			".." => 45,
			".vars" => 57,
			"+" => 50,
			'DATA_KEY' => 49,
			"{" => 58,
			'string' => 51,
			"(" => 64,
			'VAR' => 67,
			"r" => 66,
			"false" => 68,
			"true" => 52,
			"[" => 53,
			'NUMBER' => 54
		},
		GOTOS => {
			'exp' => 55,
			'array_str' => 46,
			'hash_op' => 56,
			'array_pos' => 48,
			'type_op' => 59,
			'data' => 203,
			'func_op' => 61,
			'array_op' => 63,
			'hash' => 62,
			'string_op' => 65
		}
	},
	{#State 130
		ACTIONS => {
			"sort" => 205,
			"reverse" => 204,
			"xhtml" => 206,
			"replace" => 209,
			"string" => 208,
			"upper_case" => 207,
			"length" => 210,
			"eval" => 211,
			"seq_contains" => 212,
			"lower_case" => 213,
			"html" => 214,
			"substring" => 215,
			"join" => 216,
			"uncap_first" => 217,
			"cap_first" => 218,
			"first" => 219,
			"seq_index_of" => 221,
			"word_list" => 220,
			"sort_by" => 223,
			"last" => 222,
			"size" => 224,
			"capitalize" => 225
		}
	},
	{#State 131
		ACTIONS => {
			"-" => 47,
			".." => 45,
			".vars" => 57,
			"+" => 50,
			'DATA_KEY' => 49,
			"{" => 58,
			'string' => 51,
			"(" => 64,
			'VAR' => 67,
			"r" => 66,
			"false" => 68,
			"true" => 52,
			"[" => 53,
			'NUMBER' => 54
		},
		GOTOS => {
			'exp' => 55,
			'array_str' => 46,
			'hash_op' => 56,
			'array_pos' => 48,
			'type_op' => 59,
			'data' => 226,
			'func_op' => 61,
			'array_op' => 63,
			'hash' => 62,
			'string_op' => 65
		}
	},
	{#State 132
		DEFAULT => -191
	},
	{#State 133
		ACTIONS => {
			"-" => 47,
			".." => 45,
			".vars" => 57,
			"+" => 50,
			'DATA_KEY' => 49,
			"{" => 58,
			'string' => 51,
			"(" => 64,
			'VAR' => 67,
			"r" => 66,
			"false" => 68,
			"true" => 52,
			"[" => 53,
			'NUMBER' => 54
		},
		GOTOS => {
			'exp' => 55,
			'array_str' => 46,
			'hash_op' => 56,
			'array_pos' => 48,
			'type_op' => 59,
			'data' => 227,
			'func_op' => 61,
			'array_op' => 63,
			'hash' => 62,
			'string_op' => 65
		}
	},
	{#State 134
		ACTIONS => {
			'DATA_KEY' => 228
		}
	},
	{#State 135
		ACTIONS => {
			"!=" => 129,
			"?" => 130,
			"+" => 122,
			"gte" => 131,
			"==" => 124,
			"lte" => 123,
			"??" => 132,
			"!" => 125,
			"*" => 126,
			"gt" => 133,
			"[" => 127,
			"." => 134,
			")" => 229,
			"lt" => 128
		}
	},
	{#State 136
		ACTIONS => {
			"-" => 47,
			".." => 45,
			".vars" => 57,
			"+" => 50,
			'DATA_KEY' => 49,
			"{" => 58,
			'string' => 51,
			"(" => 64,
			'VAR' => 67,
			"r" => 66,
			"false" => 68,
			"true" => 52,
			"[" => 53,
			'NUMBER' => 54
		},
		GOTOS => {
			'exp' => 55,
			'array_str' => 46,
			'hash_op' => 56,
			'array_pos' => 48,
			'type_op' => 59,
			'data' => 230,
			'func_op' => 61,
			'array_op' => 63,
			'hash' => 62,
			'string_op' => 65
		}
	},
	{#State 137
		DEFAULT => -198
	},
	{#State 138
		ACTIONS => {
			"-" => 47,
			'VAR' => 67,
			"+" => 50,
			"false" => 68,
			"true" => 52,
			'NUMBER' => 97
		},
		GOTOS => {
			'exp' => 231
		}
	},
	{#State 139
		ACTIONS => {
			"=" => 232
		}
	},
	{#State 140
		DEFAULT => -123,
		GOTOS => {
			'@10-5' => 233
		}
	},
	{#State 141
		ACTIONS => {
			'DATA_KEY' => 139
		},
		DEFAULT => -118,
		GOTOS => {
			'macro_assignments' => 234,
			'macro_assignment' => 141
		}
	},
	{#State 142
		ACTIONS => {
			"!" => 143,
			"&&" => 145,
			"||" => 144
		},
		DEFAULT => -38
	},
	{#State 143
		ACTIONS => {
			"-" => 47,
			".." => 45,
			".vars" => 57,
			"+" => 50,
			'DATA_KEY' => 49,
			"{" => 58,
			'string' => 51,
			"(" => 73,
			"!" => 70,
			'VAR' => 67,
			"r" => 66,
			"false" => 68,
			"true" => 52,
			"[" => 53,
			'NUMBER' => 54
		},
		GOTOS => {
			'exp' => 55,
			'array_str' => 46,
			'hash_op' => 56,
			'array_pos' => 48,
			'type_op' => 59,
			'data' => 72,
			'func_op' => 61,
			'array_op' => 63,
			'hash' => 62,
			'string_op' => 65,
			'exp_logic' => 235
		}
	},
	{#State 144
		ACTIONS => {
			"-" => 47,
			".." => 45,
			".vars" => 57,
			"+" => 50,
			'DATA_KEY' => 49,
			"{" => 58,
			'string' => 51,
			"(" => 73,
			"!" => 70,
			'VAR' => 67,
			"r" => 66,
			"false" => 68,
			"true" => 52,
			"[" => 53,
			'NUMBER' => 54
		},
		GOTOS => {
			'exp' => 55,
			'array_str' => 46,
			'hash_op' => 56,
			'array_pos' => 48,
			'type_op' => 59,
			'data' => 72,
			'func_op' => 61,
			'array_op' => 63,
			'hash' => 62,
			'string_op' => 65,
			'exp_logic' => 236
		}
	},
	{#State 145
		ACTIONS => {
			"-" => 47,
			".." => 45,
			".vars" => 57,
			"+" => 50,
			'DATA_KEY' => 49,
			"{" => 58,
			'string' => 51,
			"(" => 73,
			"!" => 70,
			'VAR' => 67,
			"r" => 66,
			"false" => 68,
			"true" => 52,
			"[" => 53,
			'NUMBER' => 54
		},
		GOTOS => {
			'exp' => 55,
			'array_str' => 46,
			'hash_op' => 56,
			'array_pos' => 48,
			'type_op' => 59,
			'data' => 72,
			'func_op' => 61,
			'array_op' => 63,
			'hash' => 62,
			'string_op' => 65,
			'exp_logic' => 237
		}
	},
	{#State 146
		ACTIONS => {
			">" => 170
		},
		GOTOS => {
			'tag_open_end' => 238
		}
	},
	{#State 147
		ACTIONS => {
			"!" => 143,
			"&&" => 145,
			"||" => 144,
			")" => 239
		}
	},
	{#State 148
		ACTIONS => {
			"+" => 122,
			"==" => 124,
			"lte" => 123,
			"!" => 125,
			"*" => 126,
			"[" => 127,
			")" => 229,
			"lt" => 128,
			"!=" => 129,
			"?" => 130,
			"gte" => 131,
			"??" => 132,
			"gt" => 133,
			"." => 134
		},
		DEFAULT => -34
	},
	{#State 149
		ACTIONS => {
			"-" => 47,
			'VAR' => 67,
			"+" => 50,
			"false" => 68,
			"true" => 52,
			'NUMBER' => 97
		},
		GOTOS => {
			'exp' => 240
		}
	},
	{#State 150
		ACTIONS => {
			"-" => 47,
			'VAR' => 67,
			"+" => 50,
			"false" => 68,
			"true" => 52,
			'string' => 241,
			'NUMBER' => 97
		},
		GOTOS => {
			'exp' => 242
		}
	},
	{#State 151
		ACTIONS => {
			"-" => 47,
			'VAR' => 67,
			"+" => 50,
			"false" => 68,
			"true" => 52,
			'NUMBER' => 97
		},
		GOTOS => {
			'exp' => 243
		}
	},
	{#State 152
		ACTIONS => {
			"-" => 47,
			'VAR' => 67,
			"+" => 50,
			"false" => 68,
			"true" => 52,
			'string' => 244,
			'NUMBER' => 97
		},
		GOTOS => {
			'exp' => 245
		}
	},
	{#State 153
		ACTIONS => {
			"-" => 47,
			'VAR' => 67,
			"+" => 50,
			"false" => 68,
			"true" => 52,
			'NUMBER' => 97
		},
		GOTOS => {
			'exp' => 246
		}
	},
	{#State 154
		DEFAULT => -57
	},
	{#State 155
		ACTIONS => {
			"-" => 47,
			'VAR' => 67,
			"+" => 50,
			"false" => 68,
			"true" => 52,
			'string' => 247,
			'NUMBER' => 97
		},
		GOTOS => {
			'exp' => 248
		}
	},
	{#State 156
		ACTIONS => {
			"-" => 47,
			'VAR' => 67,
			"+" => 50,
			"false" => 68,
			"true" => 52,
			'NUMBER' => 97
		},
		GOTOS => {
			'exp' => 249
		}
	},
	{#State 157
		ACTIONS => {
			"sort" => 251,
			"reverse" => 250,
			"xhtml" => 252,
			"upper_case" => 255,
			"string" => 254,
			"replace" => 253,
			"length" => 256,
			"eval" => 257,
			"seq_contains" => 258,
			"lower_case" => 259,
			"html" => 260,
			"substring" => 261,
			"join" => 262,
			"first" => 263,
			"cap_first" => 264,
			"uncap_first" => 265,
			"word_list" => 267,
			"seq_index_of" => 266,
			"sort_by" => 269,
			"last" => 268,
			"size" => 270,
			"capitalize" => 271
		},
		GOTOS => {
			'op' => 272
		}
	},
	{#State 158
		ACTIONS => {
			"!" => 159,
			"&&" => 161,
			"||" => 160
		},
		DEFAULT => -43
	},
	{#State 159
		ACTIONS => {
			"(" => 80,
			"!" => 76,
			'string' => 75,
			'NUMBER' => 78
		},
		GOTOS => {
			'exp_logic_unexpanded' => 273,
			'exp_condition_unexpanded' => 79,
			'exp_condition_var_unexpanded' => 74
		}
	},
	{#State 160
		ACTIONS => {
			"(" => 80,
			"!" => 76,
			'string' => 75,
			'NUMBER' => 78
		},
		GOTOS => {
			'exp_logic_unexpanded' => 274,
			'exp_condition_unexpanded' => 79,
			'exp_condition_var_unexpanded' => 74
		}
	},
	{#State 161
		ACTIONS => {
			"(" => 80,
			"!" => 76,
			'string' => 75,
			'NUMBER' => 78
		},
		GOTOS => {
			'exp_logic_unexpanded' => 275,
			'exp_condition_unexpanded' => 79,
			'exp_condition_var_unexpanded' => 74
		}
	},
	{#State 162
		ACTIONS => {
			">" => 170
		},
		GOTOS => {
			'tag_open_end' => 276
		}
	},
	{#State 163
		ACTIONS => {
			"!" => 159,
			"&&" => 161,
			"||" => 160,
			")" => 277
		}
	},
	{#State 164
		ACTIONS => {
			">" => 279
		},
		GOTOS => {
			'tag_close_end' => 278
		}
	},
	{#State 165
		ACTIONS => {
			"-" => 47,
			".." => 45,
			".vars" => 57,
			"+" => 50,
			'DATA_KEY' => 49,
			"{" => 58,
			'string' => 51,
			"(" => 64,
			'VAR' => 67,
			"r" => 66,
			"false" => 68,
			"true" => 52,
			"[" => 53,
			'NUMBER' => 54
		},
		GOTOS => {
			'exp' => 55,
			'array_str' => 46,
			'hash_op' => 56,
			'array_pos' => 48,
			'type_op' => 59,
			'data' => 280,
			'func_op' => 61,
			'array_op' => 63,
			'hash' => 62,
			'string_op' => 65
		}
	},
	{#State 166
		DEFAULT => -139
	},
	{#State 167
		ACTIONS => {
			">" => 170
		},
		GOTOS => {
			'tag_open_end' => 281
		}
	},
	{#State 168
		ACTIONS => {
			"+" => 122,
			"==" => 124,
			"lte" => 123,
			"!" => 125,
			"*" => 126,
			"[" => 127,
			"lt" => 128,
			"!=" => 129,
			"?" => 130,
			"gte" => 131,
			"??" => 132,
			"gt" => 133,
			"." => 134
		},
		DEFAULT => -93
	},
	{#State 169
		DEFAULT => -105,
		GOTOS => {
			'@6-5' => 282
		}
	},
	{#State 170
		DEFAULT => -96,
		GOTOS => {
			'@1-1' => 283
		}
	},
	{#State 171
		DEFAULT => -103
	},
	{#State 172
		DEFAULT => -126,
		GOTOS => {
			'@12-5' => 284
		}
	},
	{#State 173
		ACTIONS => {
			">" => 170
		},
		GOTOS => {
			'tag_open_end' => 285
		}
	},
	{#State 174
		DEFAULT => -115
	},
	{#State 175
		DEFAULT => -209
	},
	{#State 176
		ACTIONS => {
			")" => 286
		}
	},
	{#State 177
		DEFAULT => -89
	},
	{#State 178
		ACTIONS => {
			"-" => 47,
			"+" => 50,
			'string' => 104,
			'VAR' => 67,
			"true" => 52,
			"false" => 68,
			"[" => 105,
			'NUMBER' => 97
		},
		GOTOS => {
			'exp' => 107,
			'array_str' => 102,
			'sequence_item' => 109,
			'sequence' => 288
		}
	},
	{#State 179
		ACTIONS => {
			"{" => 58
		},
		GOTOS => {
			'hash' => 62,
			'hash_op' => 289
		}
	},
	{#State 180
		DEFAULT => -207
	},
	{#State 181
		ACTIONS => {
			"%" => 113,
			"^" => 114,
			"*" => 115,
			"/" => 116
		},
		DEFAULT => -27
	},
	{#State 182
		ACTIONS => {
			"%" => 113,
			"^" => 114,
			"*" => 115,
			"/" => 116
		},
		DEFAULT => -26
	},
	{#State 183
		ACTIONS => {
			"^" => 114
		},
		DEFAULT => -33
	},
	{#State 184
		DEFAULT => -32
	},
	{#State 185
		ACTIONS => {
			"^" => 114
		},
		DEFAULT => -28
	},
	{#State 186
		ACTIONS => {
			"^" => 114
		},
		DEFAULT => -29
	},
	{#State 187
		DEFAULT => -203
	},
	{#State 188
		ACTIONS => {
			"-" => 47,
			".." => 45,
			"+" => 50,
			'DATA_KEY' => 95,
			'string' => 290,
			'VAR' => 67,
			"false" => 68,
			"true" => 52,
			"[" => 53,
			'NUMBER' => 54
		},
		GOTOS => {
			'array_op' => 293,
			'exp' => 291,
			'array_str' => 46,
			'array_pos' => 48,
			'value' => 292
		}
	},
	{#State 189
		DEFAULT => -199
	},
	{#State 190
		ACTIONS => {
			'string' => 118
		},
		GOTOS => {
			'hashvalue' => 294
		}
	},
	{#State 191
		ACTIONS => {
			"==" => 124,
			"lte" => 123,
			"*" => 126,
			"[" => 127,
			"lt" => 128,
			"!=" => 129,
			"?" => 130,
			"gte" => 131,
			"??" => 132,
			"gt" => 133,
			"." => 134
		},
		DEFAULT => -156
	},
	{#State 192
		ACTIONS => {
			"==" => 124,
			"lte" => undef,
			"[" => 127,
			"lt" => undef,
			"!=" => 129,
			"?" => 130,
			"gte" => undef,
			"??" => 132,
			"gt" => undef
		},
		DEFAULT => -195
	},
	{#State 193
		ACTIONS => {
			"==" => undef,
			"[" => 127,
			"!=" => undef,
			"?" => 130,
			"??" => 132
		},
		DEFAULT => -189
	},
	{#State 194
		ACTIONS => {
			"+" => 122,
			"==" => 124,
			"lte" => 123,
			"!" => 125,
			"*" => 126,
			"[" => 127,
			"lt" => 128,
			"!=" => 129,
			"?" => 130,
			"gte" => 131,
			"??" => 132,
			"gt" => 133,
			"." => 134
		},
		DEFAULT => -188
	},
	{#State 195
		ACTIONS => {
			"==" => 124,
			"lte" => 123,
			"[" => 127,
			"lt" => 128,
			"!=" => 129,
			"?" => 130,
			"gte" => 131,
			"??" => 132,
			"gt" => 133
		},
		DEFAULT => -155
	},
	{#State 196
		ACTIONS => {
			'DATA_KEY' => 95,
			'NUMBER' => 96
		},
		GOTOS => {
			'array_pos' => 295
		}
	},
	{#State 197
		ACTIONS => {
			".." => 296
		}
	},
	{#State 198
		ACTIONS => {
			"]" => 297
		},
		DEFAULT => -212
	},
	{#State 199
		ACTIONS => {
			"]" => 298
		}
	},
	{#State 200
		DEFAULT => -157
	},
	{#State 201
		ACTIONS => {
			"-" => 111,
			"^" => 114,
			"*" => 115,
			"+" => 112,
			"/" => 116,
			"%" => 113,
			"]" => 299
		}
	},
	{#State 202
		ACTIONS => {
			"==" => 124,
			"lte" => undef,
			"[" => 127,
			"lt" => undef,
			"!=" => 129,
			"?" => 130,
			"gte" => undef,
			"??" => 132,
			"gt" => undef
		},
		DEFAULT => -194
	},
	{#State 203
		ACTIONS => {
			"==" => undef,
			"[" => 127,
			"!=" => undef,
			"?" => 130,
			"??" => 132
		},
		DEFAULT => -190
	},
	{#State 204
		DEFAULT => -170
	},
	{#State 205
		DEFAULT => -165
	},
	{#State 206
		DEFAULT => -177
	},
	{#State 207
		DEFAULT => -186
	},
	{#State 208
		ACTIONS => {
			"(" => 300
		},
		DEFAULT => -181
	},
	{#State 209
		ACTIONS => {
			"(" => 301
		}
	},
	{#State 210
		DEFAULT => -178
	},
	{#State 211
		DEFAULT => -175
	},
	{#State 212
		ACTIONS => {
			"(" => 302
		}
	},
	{#State 213
		DEFAULT => -179
	},
	{#State 214
		DEFAULT => -176
	},
	{#State 215
		ACTIONS => {
			"(" => 303
		}
	},
	{#State 216
		ACTIONS => {
			"(" => 304
		}
	},
	{#State 217
		DEFAULT => -185
	},
	{#State 218
		DEFAULT => -173
	},
	{#State 219
		DEFAULT => -172
	},
	{#State 220
		DEFAULT => -187
	},
	{#State 221
		ACTIONS => {
			"(" => 305
		}
	},
	{#State 222
		DEFAULT => -171
	},
	{#State 223
		ACTIONS => {
			"(" => 306
		}
	},
	{#State 224
		DEFAULT => -166
	},
	{#State 225
		DEFAULT => -174
	},
	{#State 226
		ACTIONS => {
			"==" => 124,
			"lte" => undef,
			"[" => 127,
			"lt" => undef,
			"!=" => 129,
			"?" => 130,
			"gte" => undef,
			"??" => 132,
			"gt" => undef
		},
		DEFAULT => -193
	},
	{#State 227
		ACTIONS => {
			"==" => 124,
			"lte" => undef,
			"[" => 127,
			"lt" => undef,
			"!=" => 129,
			"?" => 130,
			"gte" => undef,
			"??" => 132,
			"gt" => undef
		},
		DEFAULT => -192
	},
	{#State 228
		DEFAULT => -153
	},
	{#State 229
		DEFAULT => -154
	},
	{#State 230
		ACTIONS => {
			"==" => 124,
			"lte" => 123,
			"*" => 126,
			"[" => 127,
			"lt" => 128,
			"!=" => 129,
			"?" => 130,
			"gte" => 131,
			"??" => 132,
			"gt" => 133,
			"." => 134
		},
		DEFAULT => -197
	},
	{#State 231
		DEFAULT => -23
	},
	{#State 232
		ACTIONS => {
			"-" => 47,
			".." => 45,
			".vars" => 57,
			"+" => 50,
			'DATA_KEY' => 49,
			"{" => 58,
			'string' => 51,
			"(" => 64,
			'VAR' => 67,
			"r" => 66,
			"false" => 68,
			"true" => 52,
			"[" => 53,
			'NUMBER' => 54
		},
		GOTOS => {
			'exp' => 55,
			'array_str' => 46,
			'hash_op' => 56,
			'array_pos' => 48,
			'type_op' => 59,
			'data' => 307,
			'func_op' => 61,
			'array_op' => 63,
			'hash' => 62,
			'string_op' => 65
		}
	},
	{#State 233
		ACTIONS => {
			"/" => 308
		}
	},
	{#State 234
		DEFAULT => -119
	},
	{#State 235
		ACTIONS => {
			"!" => 143,
			"&&" => 145,
			"||" => 144
		},
		DEFAULT => -37
	},
	{#State 236
		DEFAULT => -36
	},
	{#State 237
		ACTIONS => {
			"||" => 144
		},
		DEFAULT => -35
	},
	{#State 238
		DEFAULT => -134
	},
	{#State 239
		DEFAULT => -39
	},
	{#State 240
		ACTIONS => {
			"-" => 111,
			"+" => 112,
			"/" => 116,
			"%" => 113,
			"^" => 114,
			"*" => 115
		},
		DEFAULT => -52
	},
	{#State 241
		DEFAULT => -50
	},
	{#State 242
		ACTIONS => {
			"-" => 111,
			"+" => 112,
			"/" => 116,
			"%" => 113,
			"^" => 114,
			"*" => 115
		},
		DEFAULT => -48
	},
	{#State 243
		ACTIONS => {
			"-" => 111,
			"+" => 112,
			"/" => 116,
			"%" => 113,
			"^" => 114,
			"*" => 115
		},
		DEFAULT => -54
	},
	{#State 244
		DEFAULT => -56
	},
	{#State 245
		ACTIONS => {
			"-" => 111,
			"+" => 112,
			"/" => 116,
			"%" => 113,
			"^" => 114,
			"*" => 115
		},
		DEFAULT => -55
	},
	{#State 246
		ACTIONS => {
			"-" => 111,
			"+" => 112,
			"/" => 116,
			"%" => 113,
			"^" => 114,
			"*" => 115
		},
		DEFAULT => -51
	},
	{#State 247
		DEFAULT => -49
	},
	{#State 248
		ACTIONS => {
			"-" => 111,
			"+" => 112,
			"/" => 116,
			"%" => 113,
			"^" => 114,
			"*" => 115
		},
		DEFAULT => -47
	},
	{#State 249
		ACTIONS => {
			"-" => 111,
			"+" => 112,
			"/" => 116,
			"%" => 113,
			"^" => 114,
			"*" => 115
		},
		DEFAULT => -53
	},
	{#State 250
		DEFAULT => -79
	},
	{#State 251
		DEFAULT => -75
	},
	{#State 252
		DEFAULT => -69
	},
	{#State 253
		DEFAULT => -66
	},
	{#State 254
		DEFAULT => -65
	},
	{#State 255
		DEFAULT => -62
	},
	{#State 256
		DEFAULT => -68
	},
	{#State 257
		DEFAULT => -71
	},
	{#State 258
		DEFAULT => -78
	},
	{#State 259
		DEFAULT => -67
	},
	{#State 260
		DEFAULT => -70
	},
	{#State 261
		DEFAULT => -64
	},
	{#State 262
		DEFAULT => -81
	},
	{#State 263
		DEFAULT => -82
	},
	{#State 264
		DEFAULT => -73
	},
	{#State 265
		DEFAULT => -63
	},
	{#State 266
		DEFAULT => -77
	},
	{#State 267
		DEFAULT => -61
	},
	{#State 268
		DEFAULT => -80
	},
	{#State 269
		DEFAULT => -74
	},
	{#State 270
		DEFAULT => -76
	},
	{#State 271
		DEFAULT => -72
	},
	{#State 272
		DEFAULT => -59
	},
	{#State 273
		ACTIONS => {
			"!" => 159,
			"&&" => 161,
			"||" => 160
		},
		DEFAULT => -44
	},
	{#State 274
		DEFAULT => -42
	},
	{#State 275
		ACTIONS => {
			"||" => 160
		},
		DEFAULT => -41
	},
	{#State 276
		ACTIONS => {
			'tag_else' => 9,
			"<#" => 10,
			"whitespace" => 18,
			'variable_verbatim' => 15,
			'string' => 8,
			"\${" => 20
		},
		DEFAULT => -17,
		GOTOS => {
			'tag_assign' => 3,
			'tag_ftl' => 2,
			'whitespace' => 1,
			'content_item' => 5,
			'variable' => 4,
			'tmp_tag_condition' => 16,
			'tag_list' => 6,
			'tag_if' => 17,
			'content' => 309,
			'tag_macro' => 11,
			'tag_open_start' => 19,
			'tag_macro_call' => 12,
			'tag' => 13,
			'tag_comment' => 14
		}
	},
	{#State 277
		DEFAULT => -45
	},
	{#State 278
		DEFAULT => -142
	},
	{#State 279
		DEFAULT => -100,
		GOTOS => {
			'@3-1' => 310
		}
	},
	{#State 280
		ACTIONS => {
			"+" => 122,
			"==" => 124,
			"lte" => 123,
			"!" => 125,
			"*" => 126,
			"[" => 127,
			"lt" => 128,
			"!=" => 129,
			"?" => 130,
			"gte" => 131,
			"??" => 132,
			"gt" => 133,
			"." => 134
		},
		DEFAULT => -140
	},
	{#State 281
		DEFAULT => -137
	},
	{#State 282
		ACTIONS => {
			'string' => 311
		}
	},
	{#State 283
		DEFAULT => -97,
		GOTOS => {
			'@2-2' => 312
		}
	},
	{#State 284
		ACTIONS => {
			'string' => 313
		}
	},
	{#State 285
		DEFAULT => -110,
		GOTOS => {
			'@8-6' => 314
		}
	},
	{#State 286
		DEFAULT => -213
	},
	{#State 287
		ACTIONS => {
			"[" => 105
		},
		GOTOS => {
			'array_str' => 315
		}
	},
	{#State 288
		DEFAULT => -87
	},
	{#State 289
		ACTIONS => {
			"+" => 117
		},
		DEFAULT => -201
	},
	{#State 290
		DEFAULT => -20
	},
	{#State 291
		ACTIONS => {
			"-" => 111,
			"+" => 112,
			"/" => 116,
			"%" => 113,
			"^" => 114,
			"*" => 115
		},
		DEFAULT => -19
	},
	{#State 292
		DEFAULT => -204
	},
	{#State 293
		DEFAULT => -18
	},
	{#State 294
		DEFAULT => -206
	},
	{#State 295
		ACTIONS => {
			"]" => 316
		}
	},
	{#State 296
		ACTIONS => {
			'DATA_KEY' => 95,
			"]" => 318,
			'NUMBER' => 96
		},
		GOTOS => {
			'array_pos' => 317
		}
	},
	{#State 297
		DEFAULT => -163
	},
	{#State 298
		DEFAULT => -162
	},
	{#State 299
		DEFAULT => -158
	},
	{#State 300
		ACTIONS => {
			'string' => 319
		}
	},
	{#State 301
		ACTIONS => {
			'string' => 320
		}
	},
	{#State 302
		ACTIONS => {
			"-" => 47,
			".." => 45,
			"+" => 50,
			'DATA_KEY' => 95,
			'string' => 290,
			'VAR' => 67,
			"false" => 68,
			"true" => 52,
			"[" => 53,
			'NUMBER' => 54
		},
		GOTOS => {
			'array_op' => 293,
			'exp' => 291,
			'array_str' => 46,
			'array_pos' => 48,
			'value' => 321
		}
	},
	{#State 303
		ACTIONS => {
			'NUMBER' => 322
		}
	},
	{#State 304
		ACTIONS => {
			'string' => 323
		}
	},
	{#State 305
		ACTIONS => {
			"-" => 47,
			".." => 45,
			"+" => 50,
			'DATA_KEY' => 95,
			'string' => 290,
			'VAR' => 67,
			"false" => 68,
			"true" => 52,
			"[" => 53,
			'NUMBER' => 54
		},
		GOTOS => {
			'array_op' => 293,
			'exp' => 291,
			'array_str' => 46,
			'array_pos' => 48,
			'value' => 324
		}
	},
	{#State 306
		ACTIONS => {
			"-" => 47,
			".." => 45,
			"+" => 50,
			'DATA_KEY' => 95,
			'string' => 290,
			'VAR' => 67,
			"false" => 68,
			"true" => 52,
			"[" => 53,
			'NUMBER' => 54
		},
		GOTOS => {
			'array_op' => 293,
			'exp' => 291,
			'array_str' => 46,
			'array_pos' => 48,
			'value' => 325
		}
	},
	{#State 307
		ACTIONS => {
			"+" => 122,
			"==" => 124,
			"lte" => 123,
			"!" => 125,
			"*" => 126,
			"[" => 127,
			"lt" => 128,
			"!=" => 129,
			"?" => 130,
			"gte" => 131,
			"??" => 132,
			"gt" => 133,
			"." => 134
		},
		DEFAULT => -120
	},
	{#State 308
		ACTIONS => {
			">" => 170
		},
		GOTOS => {
			'tag_open_end' => 326
		}
	},
	{#State 309
		ACTIONS => {
			"</#" => 327
		},
		GOTOS => {
			'tag_close_start' => 328
		}
	},
	{#State 310
		ACTIONS => {
			"whitespace" => 18
		},
		DEFAULT => -17,
		GOTOS => {
			'whitespace' => 329
		}
	},
	{#State 311
		ACTIONS => {
			"</#" => 327
		},
		GOTOS => {
			'tag_close_start' => 330
		}
	},
	{#State 312
		ACTIONS => {
			"whitespace" => 18
		},
		DEFAULT => -17,
		GOTOS => {
			'whitespace' => 331
		}
	},
	{#State 313
		ACTIONS => {
			">" => 170
		},
		GOTOS => {
			'tag_open_end' => 332
		}
	},
	{#State 314
		ACTIONS => {
			'tag_else' => 9,
			"<#" => 10,
			"whitespace" => 18,
			'variable_verbatim' => 15,
			'string' => 8,
			"\${" => 20
		},
		DEFAULT => -17,
		GOTOS => {
			'tag_assign' => 3,
			'tag_ftl' => 2,
			'whitespace' => 1,
			'content_item' => 5,
			'variable' => 4,
			'tmp_tag_condition' => 16,
			'tag_list' => 6,
			'tag_if' => 17,
			'content' => 333,
			'tag_macro' => 11,
			'tag_open_start' => 19,
			'tag_macro_call' => 12,
			'tag' => 13,
			'tag_comment' => 14
		}
	},
	{#State 315
		DEFAULT => -90
	},
	{#State 316
		DEFAULT => -161
	},
	{#State 317
		ACTIONS => {
			"]" => 334
		}
	},
	{#State 318
		DEFAULT => -160
	},
	{#State 319
		ACTIONS => {
			"," => 335
		}
	},
	{#State 320
		ACTIONS => {
			"," => 336
		}
	},
	{#State 321
		ACTIONS => {
			")" => 337
		}
	},
	{#State 322
		ACTIONS => {
			"," => 338,
			")" => 339
		}
	},
	{#State 323
		ACTIONS => {
			")" => 340
		}
	},
	{#State 324
		ACTIONS => {
			")" => 341
		}
	},
	{#State 325
		ACTIONS => {
			")" => 342
		}
	},
	{#State 326
		DEFAULT => -124
	},
	{#State 327
		DEFAULT => -99
	},
	{#State 328
		ACTIONS => {
			"if" => 343
		}
	},
	{#State 329
		DEFAULT => -101
	},
	{#State 330
		ACTIONS => {
			"assign" => 345
		},
		GOTOS => {
			'directive_assign_end' => 344
		}
	},
	{#State 331
		DEFAULT => -98
	},
	{#State 332
		DEFAULT => -127,
		GOTOS => {
			'@13-8' => 346
		}
	},
	{#State 333
		ACTIONS => {
			"</#" => 327
		},
		GOTOS => {
			'tag_close_start' => 347
		}
	},
	{#State 334
		DEFAULT => -159
	},
	{#State 335
		ACTIONS => {
			'string' => 348
		}
	},
	{#State 336
		ACTIONS => {
			'string' => 349
		}
	},
	{#State 337
		DEFAULT => -169
	},
	{#State 338
		ACTIONS => {
			'NUMBER' => 350
		}
	},
	{#State 339
		DEFAULT => -183
	},
	{#State 340
		DEFAULT => -164
	},
	{#State 341
		DEFAULT => -168
	},
	{#State 342
		DEFAULT => -167
	},
	{#State 343
		ACTIONS => {
			">" => 279
		},
		GOTOS => {
			'tag_close_end' => 351
		}
	},
	{#State 344
		ACTIONS => {
			">" => 279
		},
		GOTOS => {
			'tag_close_end' => 352
		}
	},
	{#State 345
		DEFAULT => -108
	},
	{#State 346
		ACTIONS => {
			'tag_else' => 9,
			"<#" => 10,
			"whitespace" => 18,
			'variable_verbatim' => 15,
			'string' => 8,
			"\${" => 20
		},
		DEFAULT => -17,
		GOTOS => {
			'tag_assign' => 3,
			'tag_ftl' => 2,
			'whitespace' => 1,
			'content_item' => 5,
			'variable' => 4,
			'tmp_tag_condition' => 16,
			'tag_list' => 6,
			'tag_if' => 17,
			'content' => 353,
			'tag_macro' => 11,
			'tag_open_start' => 19,
			'tag_macro_call' => 12,
			'tag' => 13,
			'tag_comment' => 14
		}
	},
	{#State 347
		ACTIONS => {
			"macro" => 355
		},
		GOTOS => {
			'directive_macro_end' => 354
		}
	},
	{#State 348
		ACTIONS => {
			")" => 356
		}
	},
	{#State 349
		ACTIONS => {
			")" => 357
		}
	},
	{#State 350
		ACTIONS => {
			")" => 358
		}
	},
	{#State 351
		DEFAULT => -131
	},
	{#State 352
		DEFAULT => -106
	},
	{#State 353
		ACTIONS => {
			"</#" => 327
		},
		GOTOS => {
			'tag_close_start' => 359
		}
	},
	{#State 354
		ACTIONS => {
			">" => 279
		},
		GOTOS => {
			'tag_close_end' => 360
		}
	},
	{#State 355
		DEFAULT => -113
	},
	{#State 356
		DEFAULT => -182
	},
	{#State 357
		DEFAULT => -180
	},
	{#State 358
		DEFAULT => -184
	},
	{#State 359
		ACTIONS => {
			"list" => 361
		}
	},
	{#State 360
		DEFAULT => -111
	},
	{#State 361
		ACTIONS => {
			">" => 279
		},
		GOTOS => {
			'tag_close_end' => 362
		}
	},
	{#State 362
		DEFAULT => -128
	}
],
                                  yyrules  =>
[
	[#Rule 0
		 '$start', 2, undef
	],
	[#Rule 1
		 'content', 1, undef
	],
	[#Rule 2
		 'content', 2,
sub
#line 45 "FreeMarkerGrammar.yp"
{
								$_[1] = '' if !defined $_[1];
								$_[2] = '' if !defined $_[2];
								return "$_[1]$_[2]";
							}
	],
	[#Rule 3
		 'content_item', 1, undef
	],
	[#Rule 4
		 'content_item', 1, undef
	],
	[#Rule 5
		 'content_item', 1, undef
	],
	[#Rule 6
		 'content_item', 1, undef
	],
	[#Rule 7
		 'tag', 1,
sub
#line 62 "FreeMarkerGrammar.yp"
{ '' }
	],
	[#Rule 8
		 'tag', 1,
sub
#line 65 "FreeMarkerGrammar.yp"
{ '' }
	],
	[#Rule 9
		 'tag', 1, undef
	],
	[#Rule 10
		 'tag', 1, undef
	],
	[#Rule 11
		 'tag', 1, undef
	],
	[#Rule 12
		 'tag', 1, undef
	],
	[#Rule 13
		 'tag', 1, undef
	],
	[#Rule 14
		 'tag', 1, undef
	],
	[#Rule 15
		 'tag', 1, undef
	],
	[#Rule 16
		 'whitespace', 1, undef
	],
	[#Rule 17
		 'whitespace', 0, undef
	],
	[#Rule 18
		 'value', 1,
sub
#line 88 "FreeMarkerGrammar.yp"
{ $_[1] }
	],
	[#Rule 19
		 'value', 1, undef
	],
	[#Rule 20
		 'value', 1,
sub
#line 93 "FreeMarkerGrammar.yp"
{ $_[1] }
	],
	[#Rule 21
		 'exp', 1, undef
	],
	[#Rule 22
		 'exp', 1,
sub
#line 99 "FreeMarkerGrammar.yp"
{ $_[0]->{_data}->{$_[1]} }
	],
	[#Rule 23
		 'exp', 3,
sub
#line 102 "FreeMarkerGrammar.yp"
{ $_[0]->{_data}->{$_[1]} = $_[3] }
	],
	[#Rule 24
		 'exp', 1,
sub
#line 105 "FreeMarkerGrammar.yp"
{ 1 }
	],
	[#Rule 25
		 'exp', 1,
sub
#line 108 "FreeMarkerGrammar.yp"
{ 0 }
	],
	[#Rule 26
		 'exp', 3,
sub
#line 110 "FreeMarkerGrammar.yp"
{ $_[1] + $_[3] }
	],
	[#Rule 27
		 'exp', 3,
sub
#line 112 "FreeMarkerGrammar.yp"
{ $_[1] - $_[3] }
	],
	[#Rule 28
		 'exp', 3,
sub
#line 114 "FreeMarkerGrammar.yp"
{ $_[1] * $_[3] }
	],
	[#Rule 29
		 'exp', 3,
sub
#line 116 "FreeMarkerGrammar.yp"
{ $_[1] / $_[3] }
	],
	[#Rule 30
		 'exp', 2,
sub
#line 118 "FreeMarkerGrammar.yp"
{ -$_[2] }
	],
	[#Rule 31
		 'exp', 2,
sub
#line 120 "FreeMarkerGrammar.yp"
{ $_[2] }
	],
	[#Rule 32
		 'exp', 3,
sub
#line 122 "FreeMarkerGrammar.yp"
{ $_[1] ** $_[3] }
	],
	[#Rule 33
		 'exp', 3,
sub
#line 126 "FreeMarkerGrammar.yp"
{ $_[1] % $_[3] }
	],
	[#Rule 34
		 'exp_logic', 1, undef
	],
	[#Rule 35
		 'exp_logic', 3,
sub
#line 132 "FreeMarkerGrammar.yp"
{ $_[1] && $_[3] }
	],
	[#Rule 36
		 'exp_logic', 3,
sub
#line 135 "FreeMarkerGrammar.yp"
{ $_[1] || $_[3] }
	],
	[#Rule 37
		 'exp_logic', 3,
sub
#line 138 "FreeMarkerGrammar.yp"
{ $_[1] && !$_[3] }
	],
	[#Rule 38
		 'exp_logic', 2,
sub
#line 141 "FreeMarkerGrammar.yp"
{ !$_[2] }
	],
	[#Rule 39
		 'exp_logic', 3,
sub
#line 144 "FreeMarkerGrammar.yp"
{ $_[2] }
	],
	[#Rule 40
		 'exp_logic_unexpanded', 1, undef
	],
	[#Rule 41
		 'exp_logic_unexpanded', 3,
sub
#line 150 "FreeMarkerGrammar.yp"
{ "$_[1] && $_[3]" }
	],
	[#Rule 42
		 'exp_logic_unexpanded', 3,
sub
#line 153 "FreeMarkerGrammar.yp"
{ "$_[1] || $_[3]" }
	],
	[#Rule 43
		 'exp_logic_unexpanded', 2,
sub
#line 156 "FreeMarkerGrammar.yp"
{ "!$_[2]" }
	],
	[#Rule 44
		 'exp_logic_unexpanded', 3,
sub
#line 159 "FreeMarkerGrammar.yp"
{ "$_[1] && !$_[3]" }
	],
	[#Rule 45
		 'exp_logic_unexpanded', 3,
sub
#line 162 "FreeMarkerGrammar.yp"
{ "($_[2])" }
	],
	[#Rule 46
		 'exp_condition_unexpanded', 1, undef
	],
	[#Rule 47
		 'exp_condition_unexpanded', 3,
sub
#line 168 "FreeMarkerGrammar.yp"
{ "$_[1] == $_[3]" }
	],
	[#Rule 48
		 'exp_condition_unexpanded', 3,
sub
#line 171 "FreeMarkerGrammar.yp"
{ "$_[1] == $_[3]" }
	],
	[#Rule 49
		 'exp_condition_unexpanded', 3,
sub
#line 174 "FreeMarkerGrammar.yp"
{ "$_[1] = $_[3]" }
	],
	[#Rule 50
		 'exp_condition_unexpanded', 3,
sub
#line 177 "FreeMarkerGrammar.yp"
{ "$_[1] == $_[3]" }
	],
	[#Rule 51
		 'exp_condition_unexpanded', 3,
sub
#line 180 "FreeMarkerGrammar.yp"
{ "$_[1] gte $_[3]" }
	],
	[#Rule 52
		 'exp_condition_unexpanded', 3,
sub
#line 183 "FreeMarkerGrammar.yp"
{ "$_[1] lte $_[3]" }
	],
	[#Rule 53
		 'exp_condition_unexpanded', 3,
sub
#line 186 "FreeMarkerGrammar.yp"
{ "$_[1] gt $_[3]" }
	],
	[#Rule 54
		 'exp_condition_unexpanded', 3,
sub
#line 189 "FreeMarkerGrammar.yp"
{ "$_[1] lt $_[3]" }
	],
	[#Rule 55
		 'exp_condition_unexpanded', 3,
sub
#line 192 "FreeMarkerGrammar.yp"
{ "$_[1] != $_[3]" }
	],
	[#Rule 56
		 'exp_condition_unexpanded', 3,
sub
#line 195 "FreeMarkerGrammar.yp"
{ "$_[1] != $_[3]" }
	],
	[#Rule 57
		 'exp_condition_unexpanded', 2,
sub
#line 198 "FreeMarkerGrammar.yp"
{ "$_[1]??" }
	],
	[#Rule 58
		 'exp_condition_var_unexpanded', 1,
sub
#line 202 "FreeMarkerGrammar.yp"
{ "$_[1]" }
	],
	[#Rule 59
		 'exp_condition_var_unexpanded', 3,
sub
#line 205 "FreeMarkerGrammar.yp"
{ "$_[1]?$_[3]" }
	],
	[#Rule 60
		 'exp_condition_var_unexpanded', 1, undef
	],
	[#Rule 61
		 'op', 1, undef
	],
	[#Rule 62
		 'op', 1, undef
	],
	[#Rule 63
		 'op', 1, undef
	],
	[#Rule 64
		 'op', 1, undef
	],
	[#Rule 65
		 'op', 1, undef
	],
	[#Rule 66
		 'op', 1, undef
	],
	[#Rule 67
		 'op', 1, undef
	],
	[#Rule 68
		 'op', 1, undef
	],
	[#Rule 69
		 'op', 1, undef
	],
	[#Rule 70
		 'op', 1, undef
	],
	[#Rule 71
		 'op', 1, undef
	],
	[#Rule 72
		 'op', 1, undef
	],
	[#Rule 73
		 'op', 1, undef
	],
	[#Rule 74
		 'op', 1, undef
	],
	[#Rule 75
		 'op', 1, undef
	],
	[#Rule 76
		 'op', 1, undef
	],
	[#Rule 77
		 'op', 1, undef
	],
	[#Rule 78
		 'op', 1, undef
	],
	[#Rule 79
		 'op', 1, undef
	],
	[#Rule 80
		 'op', 1, undef
	],
	[#Rule 81
		 'op', 1, undef
	],
	[#Rule 82
		 'op', 1, undef
	],
	[#Rule 83
		 'sequence_item', 1, undef
	],
	[#Rule 84
		 'sequence_item', 1, undef
	],
	[#Rule 85
		 'sequence_item', 1, undef
	],
	[#Rule 86
		 'sequence', 1, undef
	],
	[#Rule 87
		 'sequence', 3,
sub
#line 227 "FreeMarkerGrammar.yp"
{
								my $seq = '';
								$seq .= $_[1] if defined $_[1];
								$seq .= ', ' if defined $_[1] && defined $_[3];
								$seq .= $_[3] if defined $_[3];
								return $seq;
							}
	],
	[#Rule 88
		 'array_str', 2,
sub
#line 236 "FreeMarkerGrammar.yp"
{ '' }
	],
	[#Rule 89
		 'array_str', 3,
sub
#line 239 "FreeMarkerGrammar.yp"
{ "[$_[2]]" }
	],
	[#Rule 90
		 'array_str', 5,
sub
#line 242 "FreeMarkerGrammar.yp"
{
								(my $items = $_[5]) =~ s/^\[(.*)\]$/$1/;
								return "[$_[2], $items]";
							}
	],
	[#Rule 91
		 'expr_assignments', 1, undef
	],
	[#Rule 92
		 'expr_assignments', 2, undef
	],
	[#Rule 93
		 'expr_assignment', 3,
sub
#line 254 "FreeMarkerGrammar.yp"
{ $_[0]->{_data}->{$_[1]} = $_[3] }
	],
	[#Rule 94
		 'tag_open_start', 1,
sub
#line 259 "FreeMarkerGrammar.yp"
{ $_[0]->_pushContext('tagParams') }
	],
	[#Rule 95
		 'tag_macro_open_start', 1,
sub
#line 263 "FreeMarkerGrammar.yp"
{ $_[0]->_pushContext('tagParams') }
	],
	[#Rule 96
		 '@1-1', 0,
sub
#line 268 "FreeMarkerGrammar.yp"
{ $_[0]->_popContext('tagParams') }
	],
	[#Rule 97
		 '@2-2', 0,
sub
#line 269 "FreeMarkerGrammar.yp"
{ $_[0]->_pushContext('whitespace') }
	],
	[#Rule 98
		 'tag_open_end', 4,
sub
#line 271 "FreeMarkerGrammar.yp"
{ $_[0]->_popContext('whitespace') }
	],
	[#Rule 99
		 'tag_close_start', 1, undef
	],
	[#Rule 100
		 '@3-1', 0,
sub
#line 279 "FreeMarkerGrammar.yp"
{ $_[0]->_pushContext('whitespace') }
	],
	[#Rule 101
		 'tag_close_end', 3,
sub
#line 281 "FreeMarkerGrammar.yp"
{ $_[0]->_popContext('whitespace') }
	],
	[#Rule 102
		 '@4-3', 0,
sub
#line 289 "FreeMarkerGrammar.yp"
{ $_[0]->_popContext('assignment') }
	],
	[#Rule 103
		 'tag_assign', 5, undef
	],
	[#Rule 104
		 '@5-3', 0,
sub
#line 295 "FreeMarkerGrammar.yp"
{ $_[0]->_popContext('assignment') }
	],
	[#Rule 105
		 '@6-5', 0,
sub
#line 297 "FreeMarkerGrammar.yp"
{ $_[0]->_pushContext( 'assign' ); }
	],
	[#Rule 106
		 'tag_assign', 10,
sub
#line 302 "FreeMarkerGrammar.yp"
{
								$_[0]->{_data}->{_unquote($_[3])} = $_[7];
								$_[0]->_popContext( 'assign' );
							}
	],
	[#Rule 107
		 'directive_assign', 1,
sub
#line 308 "FreeMarkerGrammar.yp"
{ $_[0]->_pushContext('assignment') }
	],
	[#Rule 108
		 'directive_assign_end', 1, undef
	],
	[#Rule 109
		 '@7-4', 0,
sub
#line 316 "FreeMarkerGrammar.yp"
{ $_[0]->_popContext('assignment') }
	],
	[#Rule 110
		 '@8-6', 0,
sub
#line 318 "FreeMarkerGrammar.yp"
{ $_[0]->_pushContext( 'macrocontents' ); }
	],
	[#Rule 111
		 'tag_macro', 11,
sub
#line 323 "FreeMarkerGrammar.yp"
{
								use Data::Dumper;
								$_[0]->{_data}->{macros}->{$_[3]}->{contents} = $_[8];
								$_[0]->_popContext( 'macrocontents' );
								return '';
							}
	],
	[#Rule 112
		 'directive_macro', 1,
sub
#line 332 "FreeMarkerGrammar.yp"
{ $_[0]->_pushContext('assignment') }
	],
	[#Rule 113
		 'directive_macro_end', 1, undef
	],
	[#Rule 114
		 'macroparams', 1, undef
	],
	[#Rule 115
		 'macroparams', 2,
sub
#line 339 "FreeMarkerGrammar.yp"
{
								my $seq = '';
								$seq .= $_[1] if defined $_[1];
								$seq .= ' ' if defined $_[1] && defined $_[2];
								$seq .= $_[2] if defined $_[2];
								return $seq;
							}
	],
	[#Rule 116
		 'macroparam', 1, undef
	],
	[#Rule 117
		 'macroparam', 0, undef
	],
	[#Rule 118
		 'macro_assignments', 1, undef
	],
	[#Rule 119
		 'macro_assignments', 2, undef
	],
	[#Rule 120
		 'macro_assignment', 3,
sub
#line 357 "FreeMarkerGrammar.yp"
{
								if (_isString($_[3])) {
									$_[0]->{_data}->{$_[1]} = $_[0]->_parse($_[3]);
								} else {
									$_[0]->{_data}->{$_[1]} = $_[3];
								}
							}
	],
	[#Rule 121
		 'macro_assignment', 0, undef
	],
	[#Rule 122
		 '@9-2', 0,
sub
#line 369 "FreeMarkerGrammar.yp"
{ $_[0]->_pushContext('assignment') }
	],
	[#Rule 123
		 '@10-5', 0,
sub
#line 372 "FreeMarkerGrammar.yp"
{ $_[0]->_popContext('assignment') }
	],
	[#Rule 124
		 'tag_macro_call', 8,
sub
#line 375 "FreeMarkerGrammar.yp"
{
								return  $_[0]->_parse( $_[0]->{_data}->{macros}->{$_[4]}->{contents} );
							}
	],
	[#Rule 125
		 '@11-2', 0,
sub
#line 382 "FreeMarkerGrammar.yp"
{
								$_[0]->{_workingData}->{nestedLevel}++;
								$_[0]->_pushContext('listParams');
							}
	],
	[#Rule 126
		 '@12-5', 0,
sub
#line 388 "FreeMarkerGrammar.yp"
{ $_[0]->_popContext('listParams') }
	],
	[#Rule 127
		 '@13-8', 0,
sub
#line 391 "FreeMarkerGrammar.yp"
{ $_[0]->_pushContext( 'list' ) }
	],
	[#Rule 128
		 'tag_list', 13,
sub
#line 396 "FreeMarkerGrammar.yp"
{
								$_[0]->_popContext( 'list' );
								$_[0]->{_workingData}->{nestedLevel}--;
								my $key = $_[7];
								my $format = $_[10];
								my $result = $_[0]->_renderList( $key, $_[4], $format );
								return $result;
							}
	],
	[#Rule 129
		 '@14-2', 0,
sub
#line 408 "FreeMarkerGrammar.yp"
{
								$_[0]->{_workingData}->{ifLevel}++;
								$_[0]->_pushContext('condition');
							}
	],
	[#Rule 130
		 '@15-4', 0,
sub
#line 413 "FreeMarkerGrammar.yp"
{
								$_[0]->_popContext('condition');
							}
	],
	[#Rule 131
		 'tag_if', 10,
sub
#line 421 "FreeMarkerGrammar.yp"
{
								$_[0]->{_workingData}->{ifLevel}--;
								$_[7] =~ s/[[:space:]]+$//s;
								my $block = "<#_if_ $_[4]>$_[7]";
								if ( $_[0]->{_workingData}->{ifLevel} == 0 ) {
									# to prevent parsing of nested if blocks first, first parse level 0, and after that nested if blocks
									return $_[0]->_parseIfBlock( $block );
								} else {
									my $ifBlock = '<#if ' . $_[4] . '>' . $_[7] . '</#if>';
									
									push (@{$_[0]->{_workingData}->{ifBlocks}}, $ifBlock); 
									my $ifBlockId = scalar @{$_[0]->{_workingData}->{ifBlocks}} - 1;
									return '___ifblock' . $ifBlockId . '___';
								}
							}
	],
	[#Rule 132
		 '@16-2', 0,
sub
#line 440 "FreeMarkerGrammar.yp"
{ $_[0]->_pushContext('evalcondition') }
	],
	[#Rule 133
		 '@17-4', 0,
sub
#line 442 "FreeMarkerGrammar.yp"
{ $_[0]->_popContext('evalcondition') }
	],
	[#Rule 134
		 'tmp_tag_condition', 6,
sub
#line 444 "FreeMarkerGrammar.yp"
{
								return $_[4] == 1 ? 1 : 0;
							}
	],
	[#Rule 135
		 '@18-2', 0,
sub
#line 451 "FreeMarkerGrammar.yp"
{ $_[0]->_pushContext('assignment') }
	],
	[#Rule 136
		 '@19-4', 0,
sub
#line 453 "FreeMarkerGrammar.yp"
{ $_[0]->_popContext('assignment') }
	],
	[#Rule 137
		 'tag_ftl', 6,
sub
#line 455 "FreeMarkerGrammar.yp"
{ '' }
	],
	[#Rule 138
		 'expr_ftl_assignments', 1, undef
	],
	[#Rule 139
		 'expr_ftl_assignments', 2, undef
	],
	[#Rule 140
		 'expr_ftl_assignment', 3,
sub
#line 462 "FreeMarkerGrammar.yp"
{ $_[0]->{_data}->{_ftlData}->{$_[1]} = $_[3] }
	],
	[#Rule 141
		 '@20-2', 0,
sub
#line 467 "FreeMarkerGrammar.yp"
{ $_[0]->_pushContext( 'comment' ) }
	],
	[#Rule 142
		 'tag_comment', 6,
sub
#line 471 "FreeMarkerGrammar.yp"
{
								$_[0]->_popContext( 'comment' );
								$_[0]->_popContext('tagParams');
								return '';
							}
	],
	[#Rule 143
		 '@21-1', 0,
sub
#line 479 "FreeMarkerGrammar.yp"
{ $_[0]->_pushContext('variableParams') }
	],
	[#Rule 144
		 'variable', 4,
sub
#line 482 "FreeMarkerGrammar.yp"
{
								$_[0]->_popContext('variableParams');
								undef $_[0]->{_workingData}->{tmpData};
								return $_[0]->_parse( $_[3] );
							}
	],
	[#Rule 145
		 'data', 1,
sub
#line 490 "FreeMarkerGrammar.yp"
{ $_[0]->_value($_[1]) }
	],
	[#Rule 146
		 'data', 1,
sub
#line 493 "FreeMarkerGrammar.yp"
{ $_[0]->{_data} }
	],
	[#Rule 147
		 'data', 1, undef
	],
	[#Rule 148
		 'data', 1, undef
	],
	[#Rule 149
		 'data', 1, undef
	],
	[#Rule 150
		 'data', 1, undef
	],
	[#Rule 151
		 'data', 1, undef
	],
	[#Rule 152
		 'data', 1, undef
	],
	[#Rule 153
		 'type_op', 3,
sub
#line 510 "FreeMarkerGrammar.yp"
{
								my $d = $_[0]->{_workingData}->{tmpData};
								$d = $_[0]->{_data} if !defined $d;
								my $value = $d->{ _unquote( $_[3] ) };
								$_[0]->{_workingData}->{tmpData} = $value;
								return $value;
							}
	],
	[#Rule 154
		 'type_op', 3,
sub
#line 519 "FreeMarkerGrammar.yp"
{ $_[2] }
	],
	[#Rule 155
		 'type_op', 3,
sub
#line 522 "FreeMarkerGrammar.yp"
{ $_[1] * $_[3] }
	],
	[#Rule 156
		 'type_op', 3,
sub
#line 526 "FreeMarkerGrammar.yp"
{
								if ( UNIVERSAL::isa( $_[1], "ARRAY" ) && UNIVERSAL::isa( $_[3], "ARRAY" ) ) {
									my @list = ( @{$_[1]}, @{$_[3]} );
									return \@list;
								} else {
								    # not an array
									return $_[1] + $_[3];
								}
							}
	],
	[#Rule 157
		 'type_op', 3,
sub
#line 537 "FreeMarkerGrammar.yp"
{ undef }
	],
	[#Rule 158
		 'type_op', 4,
sub
#line 540 "FreeMarkerGrammar.yp"
{
								if ( $_[0]->_context() eq 'listParams' ) {
									my $value = $_[1]->[$_[3]];
									my @list = ($value);
									return \@list;
								} else {
									my $value = $_[1][$_[3]];
									$_[0]->{_workingData}->{tmpData} = $value;
									return $value;
								}
							}
	],
	[#Rule 159
		 'type_op', 6,
sub
#line 553 "FreeMarkerGrammar.yp"
{
								my @list;
								if ( $_[3] > $_[5] ) {
									@list = @{$_[1]}[$_[5]..$_[3]];
									@list = reverse(@list);
								} else {
									@list = @{$_[1]}[$_[3]..$_[5]];
								}
								return \@list;
							}
	],
	[#Rule 160
		 'type_op', 5,
sub
#line 565 "FreeMarkerGrammar.yp"
{
								my $maxlength = scalar @{$_[1]} - 1;
								my @list = @{$_[1]}[$_[3]..$maxlength];
								return \@list;
							}
	],
	[#Rule 161
		 'type_op', 5,
sub
#line 572 "FreeMarkerGrammar.yp"
{
								my @list = @{$_[1]}[0..$_[4]];
								return \@list;
							}
	],
	[#Rule 162
		 'type_op', 4,
sub
#line 578 "FreeMarkerGrammar.yp"
{
								my $d = $_[0]->{_workingData}->{tmpData};
								$d = $_[0]->{_data} if !defined $d;
								my $value = $d->{ _unquote( $_[3] ) };
								$_[0]->{_workingData}->{tmpData} = $value;
								my @list = ($value);
								return \@list;
							}
	],
	[#Rule 163
		 'type_op', 4,
sub
#line 588 "FreeMarkerGrammar.yp"
{
								my $d = $_[0]->{_workingData}->{tmpData};
								$d = $_[0]->{_data} if !defined $d;
								my $value = $d->{ _unquote( $_[3] ) };
								$_[0]->{_workingData}->{tmpData} = $value;
								return $value;
							}
	],
	[#Rule 164
		 'type_op', 6,
sub
#line 597 "FreeMarkerGrammar.yp"
{ join ( _unquote($_[5]), @{$_[1]} ) }
	],
	[#Rule 165
		 'type_op', 3,
sub
#line 600 "FreeMarkerGrammar.yp"
{
								my $sorted = _sort( $_[1] );
								return $sorted;
							}
	],
	[#Rule 166
		 'type_op', 3,
sub
#line 606 "FreeMarkerGrammar.yp"
{ scalar @{$_[1]} }
	],
	[#Rule 167
		 'type_op', 6,
sub
#line 609 "FreeMarkerGrammar.yp"
{
								my $key = _unquote($_[5]);								
								my $isStringSort = 1;
								for (@{$_[1]}) {
									if ( _isNumber($_->{$key}) ) {
										$isStringSort = 0;
										last;
									}
								}
								my @sorted;
								if ($isStringSort) {
									@sorted = sort { lc $$a{$key} cmp lc $$b{$key} } @{$_[1]};
								} else {
									@sorted = sort { $$a{$key} <=> $$b{$key} } @{$_[1]};
								}
								return \@sorted;
							}
	],
	[#Rule 168
		 'type_op', 6,
sub
#line 628 "FreeMarkerGrammar.yp"
{
								# differentiate between numbers and strings
								# this is not fast
								$_[0]->{_workingData}->{$_[1]}->{'seqData'} ||=
								_arrayAsHash($_[1], 1);
    							my $index =  $_[0]->{_workingData}->{$_[1]}->{'seqData'}->{ $_[5] };
    							return -1 if !defined $index;
    							return $index;
							}
	],
	[#Rule 169
		 'type_op', 6,
sub
#line 639 "FreeMarkerGrammar.yp"
{
								# differentiate between numbers and strings
								# this is not fast
								$_[0]->{_workingData}->{$_[1]}->{'seqData'} ||=
								_arrayAsHash($_[1], 1);
    							return 1 if defined $_[0]->{_workingData}->{$_[1]}->{'seqData'}->{ $_[5] };
    							return 0;
							}
	],
	[#Rule 170
		 'type_op', 3,
sub
#line 649 "FreeMarkerGrammar.yp"
{
								my @reversed = reverse @{$_[1]};
								return \@reversed;
							}
	],
	[#Rule 171
		 'type_op', 3,
sub
#line 655 "FreeMarkerGrammar.yp"
{ @{$_[1]}[-1] }
	],
	[#Rule 172
		 'type_op', 3,
sub
#line 658 "FreeMarkerGrammar.yp"
{ @{$_[1]}[0] }
	],
	[#Rule 173
		 'type_op', 3,
sub
#line 662 "FreeMarkerGrammar.yp"
{ _capfirst( $_[1] ) }
	],
	[#Rule 174
		 'type_op', 3,
sub
#line 665 "FreeMarkerGrammar.yp"
{ _capitalize( $_[1] ) }
	],
	[#Rule 175
		 'type_op', 3,
sub
#line 668 "FreeMarkerGrammar.yp"
{ $_[0]->_parse('${' . $_[1] . '}') }
	],
	[#Rule 176
		 'type_op', 3,
sub
#line 671 "FreeMarkerGrammar.yp"
{ _html($_[1]) }
	],
	[#Rule 177
		 'type_op', 3,
sub
#line 674 "FreeMarkerGrammar.yp"
{ _xhtml($_[1]) }
	],
	[#Rule 178
		 'type_op', 3,
sub
#line 677 "FreeMarkerGrammar.yp"
{ return defined $_[1] ? length( $_[1] ) : 0 }
	],
	[#Rule 179
		 'type_op', 3,
sub
#line 680 "FreeMarkerGrammar.yp"
{ lc $_[1] }
	],
	[#Rule 180
		 'type_op', 8,
sub
#line 683 "FreeMarkerGrammar.yp"
{ _replace( $_[1], _unquote($_[5]), _unquote($_[7]) ) }
	],
	[#Rule 181
		 'type_op', 3,
sub
#line 686 "FreeMarkerGrammar.yp"
{ $_[1] }
	],
	[#Rule 182
		 'type_op', 8,
sub
#line 689 "FreeMarkerGrammar.yp"
{ $_[1] ? _unquote($_[5]) : _unquote($_[7]) }
	],
	[#Rule 183
		 'type_op', 6,
sub
#line 692 "FreeMarkerGrammar.yp"
{ _substring( $_[1], $_[5] ) }
	],
	[#Rule 184
		 'type_op', 8,
sub
#line 695 "FreeMarkerGrammar.yp"
{ _substring( $_[1], $_[5], $_[7] ) }
	],
	[#Rule 185
		 'type_op', 3,
sub
#line 698 "FreeMarkerGrammar.yp"
{ _uncapfirst( $_[1] ) }
	],
	[#Rule 186
		 'type_op', 3,
sub
#line 701 "FreeMarkerGrammar.yp"
{ uc $_[1] }
	],
	[#Rule 187
		 'type_op', 3,
sub
#line 704 "FreeMarkerGrammar.yp"
{
								my @list = _wordlist( $_[1] );
								return \@list;
							}
	],
	[#Rule 188
		 'type_op', 3,
sub
#line 710 "FreeMarkerGrammar.yp"
{ _unquote($_[3]) }
	],
	[#Rule 189
		 'type_op', 3,
sub
#line 713 "FreeMarkerGrammar.yp"
{ 
								if (_isString($_[3])) {
									return $_[1] eq $_[3];
								} else {
									return $_[1] == $_[3];
								}
							}
	],
	[#Rule 190
		 'type_op', 3,
sub
#line 722 "FreeMarkerGrammar.yp"
{ 
								if (_isString($_[3])) {
									return $_[1] ne $_[3];
								} else {
									return $_[1] != $_[3];
								}
							}
	],
	[#Rule 191
		 'type_op', 2,
sub
#line 731 "FreeMarkerGrammar.yp"
{ return defined $_[1] }
	],
	[#Rule 192
		 'type_op', 3,
sub
#line 734 "FreeMarkerGrammar.yp"
{ return 0 if !defined $_[1]; $_[1] > $_[3] }
	],
	[#Rule 193
		 'type_op', 3,
sub
#line 737 "FreeMarkerGrammar.yp"
{ return 0 if !defined $_[1]; $_[1] >= $_[3] }
	],
	[#Rule 194
		 'type_op', 3,
sub
#line 740 "FreeMarkerGrammar.yp"
{ return 0 if !defined $_[1]; $_[1] < $_[3] }
	],
	[#Rule 195
		 'type_op', 3,
sub
#line 743 "FreeMarkerGrammar.yp"
{ return 0 if !defined $_[1]; $_[1] <= $_[3] }
	],
	[#Rule 196
		 'string_op', 1,
sub
#line 747 "FreeMarkerGrammar.yp"
{ _unquote( $_[1] ) }
	],
	[#Rule 197
		 'string_op', 3,
sub
#line 750 "FreeMarkerGrammar.yp"
{
								if (defined $_[3]) {
									return $_[1] . $_[3];
								} else {
									return $_[1];
								}
							}
	],
	[#Rule 198
		 'string_op', 2,
sub
#line 759 "FreeMarkerGrammar.yp"
{ _protect(_unquote( $_[2] )) }
	],
	[#Rule 199
		 'hash', 3,
sub
#line 763 "FreeMarkerGrammar.yp"
{ $_[2] }
	],
	[#Rule 200
		 'hashes', 1,
sub
#line 766 "FreeMarkerGrammar.yp"
{
								$_[0]->{_workingData}->{'hashes'} ||= ();
								push @{$_[0]->{_workingData}->{'hashes'}}, $_[1];
							}
	],
	[#Rule 201
		 'hashes', 3,
sub
#line 772 "FreeMarkerGrammar.yp"
{	
								$_[0]->{_workingData}->{'hashes'} ||= ();
								push @{$_[0]->{_workingData}->{'hashes'}}, $_[3];
							}
	],
	[#Rule 202
		 'hash_op', 1, undef
	],
	[#Rule 203
		 'hash_op', 3,
sub
#line 780 "FreeMarkerGrammar.yp"
{
								my %merged = (%{$_[1]}, %{$_[3]});
								return \%merged;
							}
	],
	[#Rule 204
		 'hashvalue', 3,
sub
#line 786 "FreeMarkerGrammar.yp"
{
								my $local = {
									_unquote($_[1]) => _unquote($_[3])
								};
								return $local;
							}
	],
	[#Rule 205
		 'hashvalues', 1, undef
	],
	[#Rule 206
		 'hashvalues', 3,
sub
#line 796 "FreeMarkerGrammar.yp"
{
								my %merged = (%{$_[1]}, %{$_[3]});
								return \%merged;
							}
	],
	[#Rule 207
		 'array_op', 3,
sub
#line 803 "FreeMarkerGrammar.yp"
{
								my @list = @{$_[0]->{_workingData}->{'hashes'}};
								undef $_[0]->{_workingData}->{'hashes'};
								return \@list;
							}
	],
	[#Rule 208
		 'array_op', 1,
sub
#line 810 "FreeMarkerGrammar.yp"
{ _toList($_[1]) }
	],
	[#Rule 209
		 'array_op', 3,
sub
#line 813 "FreeMarkerGrammar.yp"
{
								my @list;
								if ( $_[1] > $_[3] ) {
									@list = ($_[3]..$_[1]);
									@list = reverse(@list);
								} else {
									@list = ($_[1]..$_[3]);
								}
								return \@list;
							}
	],
	[#Rule 210
		 'array_op', 2,
sub
#line 825 "FreeMarkerGrammar.yp"
{
								my @list = (0..$_[2]);
								return \@list;
							}
	],
	[#Rule 211
		 'array_pos', 1, undef
	],
	[#Rule 212
		 'array_pos', 1,
sub
#line 834 "FreeMarkerGrammar.yp"
{ $_[0]->_value($_[1]) }
	],
	[#Rule 213
		 'func_op', 4,
sub
#line 838 "FreeMarkerGrammar.yp"
{
								my $function = $_[0]->_value($_[1]);
								return undef if !$function;
								my $parameters = $_[0]->_parse( $_[3] );
								
								my @params = ();
								while ($parameters =~ s/(([']+)([^']*)([']+))|((["]+)([^"]*)(["]+))/push @params,_unquote($3||$5)/ge) {}
								
								return &$function(@params);
							}
	]
],
                                  @_);
    bless($self,$class);
}

#line 849 "FreeMarkerGrammar.yp"



use strict;
use warnings;

use Text::Balanced qw (
  gen_delimited_pat
);
my $p_quotes                = gen_delimited_pat(q{'"});    # generates regex
my $PATTERN_PRESERVE_QUOTES = qr/($p_quotes)/;
my $p_number =
'(?:(?i)(?:[+-]?)(?:(?=[0123456789]|[.])(?:[0123456789]*)(?:(?:[.])(?:[0123456789]{0,}))?)(?:(?:[E])(?:(?:[+-]?)(?:[0123456789]+))|))'
  ; #created with: use Regexp::Common 'RE_ALL'; $PATTERN_NUMBER = $RE{num}{real};
my $PATTERN_NUMBER = qr/($p_number)/;

=pod

Initialization of instance variables - not in sub 'new' as this is defined by the parser compiler.

=cut

sub _init {
    my ( $this, $dataRef ) = @_;

    $this->{_context} = undef;
    @{ $this->{_context} } = ();
    $this->{_data} ||= $dataRef;

    # values set in template directive 'ftl'
    $this->{_data}->{_ftlData}                     ||= {};
    $this->{_data}->{_ftlData}->{encoding}         ||= undef;
    $this->{_data}->{_ftlData}->{strip_whitespace} ||= 1;
    $this->{_data}->{_ftlData}->{attributes}       ||= {};

    $this->{_workingData} ||= {};
    $this->{_workingData}->{tmpData}       ||= undef;
    $this->{_workingData}->{ifBlocks}      ||= ();    # array with block contents
    $this->{_workingData}->{ifLevel}       ||= 0;
    $this->{_workingData}->{nestedLevel}       ||= 0;
    $this->{_workingData}->{inTagBrackets} ||= 0;
}

sub _parseIfBlock {
    my ( $this, $text ) = @_;

    my @items = split( /(<#_if_|<#elseif|<#else)(.*?)>(.*?)/, $text );

    # remove first item
    splice @items, 0, 1;

    my $result = '';
    while ( scalar @items ) {

        my ( $tag, $condition, $tmp, $content ) = @items[ 0, 1, 2, 3 ];
        splice @items, 0, 4;

        if ( $this->{_data}->{_ftlData}->{strip_whitespace} == 1 ) {
            _stripWhitespaceAfterTag($content);
            _stripWhitespaceBeforeTag($content);
        }

        my $resultCondition = 0;
        if ( $tag eq '<#else' ) {
            $resultCondition = 1;
        }
        elsif ( defined $condition ) {

            # remove leading and trailing spaces
            _trimSpaces($condition);

            # create a dummy tag so we can use this same parser
            # and parse the conditon - it may contain variables
            $resultCondition = $this->_parse( "<#_if_ $condition >" );

        }
        if ($resultCondition) {
            $content =~
              s/___ifblock(\d+)___/$this->{_workingData}->{ifBlocks}[$1]/g;
            $result =
              $this->_parse( $content );

            last;
        }
    }

    # remove all if blocks
    $this->{_workingData}->{ifBlocks} = ()
      if $this->{_workingData}->{ifLevel} == 0;

    return $result;
}

sub _value {
    my ( $this, $key, $storeValue ) = @_;

	$storeValue = 1 if !defined $storeValue;
		
    my $value = $this->{_data}->{$key};
    if ( defined $value ) {
        if ( UNIVERSAL::isa( $value, "ARRAY" ) ) {
            $this->{_workingData}->{tmpData} = \@{$value} if $storeValue;
            return \@{$value};
        }
        else {
            $this->{_workingData}->{tmpData} = $value if $storeValue;
            return $value;
        }
    }
    my $d = $this->{_workingData}->{tmpData};
    $d                              = $this->{_data} if !defined $d;
    
    $value                          = $d->{$key};
    $this->{_workingData}->{tmpData} = $value if $storeValue;
    return $value;
}

=pod

Protects string from expansion: adds '<fmg_nop>' string before '{'.

=cut

sub _protect {
    my ($string) = @_;

    return '' if !defined $string;

    $string =~ s/\{/<fmg_nop>{/go;
    return $string;
}

=pod

_renderList( $key, \@list, $format ) -> $renderedList

=cut

sub _renderList {
    my ( $this, $key, $list, $format ) = @_;

	return $format if $_[0]->{_workingData}->{nestedLevel} > 0;

	if ( $this->{debug} || $this->{debugLevel} ) {
		print STDERR "_renderList; key=$key\n";
		print STDERR "nestedLevel=$_[0]->{_workingData}->{nestedLevel}\n";
		print STDERR "list=" . Dumper($list);
		print STDERR "format=$format\n";
	}
	
    my ( $spaceBeforeItems, $trimmedFormat, $spaceAfterEachItem ) =
      ( '', $format, '' );
	
    if ( $this->{_data}->{_ftlData}->{strip_whitespace} == 1 ) {
        ( $spaceBeforeItems, $trimmedFormat, $spaceAfterEachItem ) =
          $format =~ m/^(\s*?)(.*?)(\s*)$/s;
    }
	
    $trimmedFormat = _unquote($trimmedFormat);

    my $rendered = $spaceBeforeItems;

    foreach my $item ( @{$list} ) {
		
        # temporarily store key value in data
        $this->{_data}->{$key} = $item;

        my $parsedItem =
          $this->_parse( $trimmedFormat );

        # remove after use
        delete $this->{_data}->{$key};
		
        $rendered .= $parsedItem . $spaceAfterEachItem;
    }
    return $rendered;
}

sub _isInsideTag {
    my ($this) = @_;

    return scalar @{ $this->{_context} } > 0;
}

=pod

Takes a string and returns an array ref.

For example:
	my $str = '["whale", "Barbara", "zeppelin", "aardvark", "beetroot"]';
	my $listref = _toList($str);
	
=cut

sub _toList {
    my ($listString) = @_;

    my @list = @{ eval $listString };
    return \@list;
}

sub _pushContext {
    my ( $this, $context ) = @_;

    print STDERR "\t _pushContext:$context\n"
      if ( $this->{debug} || $this->{debugLevel} );

    push @{ $this->{_context} }, $context;
}

sub _popContext {
    my ( $this, $context ) = @_;

    print STDERR "\t _popContext:$context\n"
      if ( $this->{debug} || $this->{debugLevel} );

    if ( defined @{ $this->{_context} }[-1]
        && @{ $this->{_context} }[ $#{ $this->{_context} } ] eq $context )
    {
        pop @{ $this->{_context} };
    }
}

sub _context {
    my ($this) = @_;

    return '' if !defined $this->{_context} || !scalar @{ $this->{_context} };
    return $this->{_context}[-1];
}

# UTIL FUNCTIONS

sub _unquote {
    my ($string) = @_;

    return '' if !defined $string;

    $string =~ s/^(\"|\')(.*)(\1)$/$2/s;
    return $string;
}

# STRING OPERATIONS

sub _substring {
    my ( $str, $from, $to ) = @_;

    my $length = defined $to ? $to - $from : ( length $str ) - $from;
    return substr( $str, $from, $length );
}

sub _capfirst {
    my ($str) = @_;

    $str =~ s/^([[:space:]]*)(\w+)/$1\u$2/;
    return $str;
}

sub _capitalize {
    my ($str) = @_;

    $str =~ s/\b(\w+)\b/\u$1/g;
    return $str;
}

sub _html {
    my ($str) = @_;

    $str =~ s/&/&amp;/go;
    $str =~ s/</&lt;/go;
    $str =~ s/>/&gt;/go;
    $str =~ s/"/&quot;/go;
    return $str;
}

sub _xhtml {
    my ($str) = @_;

    $str =~ s/&/&amp;/go;
    $str =~ s/</&lt;/go;
    $str =~ s/>/&gt;/go;
    $str =~ s/"/&quot;/go;
    $str =~ s/'/&#39;/go;
    return $str;
}

sub _replace {
    my ( $str, $from, $to ) = @_;

    $str =~ s/$from/$to/g;
    return $str;
}

sub _uncapfirst {
    my ($str) = @_;

    $str =~ s/^([[:space:]]*)(\w+)/$1\l$2/;
    return $str;
}

sub _wordlist {
    my ($str) = @_;

    $str =~ s/^[[:space:]]+//so;    # trim at start
    return split( /[[:space:]]+/, $str );
}

# END STRING OPERATIONS

# LIST OPERATIONS

sub _sort {
    my ($listRef) = @_;

    my @sorted = sort { lc($a) cmp lc($b) } @{$listRef};
    return \@sorted;
}

=pod

=cut

sub _interpolateEscapes {
    my ($string) = @_;

    # escaped string: \"
    $string =~ s/\\"/"/go;

    # escaped string: \'
    $string =~ s/\\'/'/go;

    # escaped newline: \n
    $string =~ s/\\n/\n/go;

    # escaped carriage return: \r
    $string =~ s/\\r/\n/go;

    # escaped tab: \t
    $string =~ s/\\t/\t/go;

    # backspace at end of string: \b
    $string =~ s/\\b$/\b /go;

    # backspace: \b
    $string =~ s/\\b/\b/go;

    # form feed: \f
    $string =~ s/\\f/\f/go;

    # less than: \l
    $string =~ s/\\l/</go;

    # greater than: \g
    $string =~ s/\\g/>/go;

    # ampersand: \a
    $string =~ s/\\a/&/go;

    # unicode - not yet supported
    $string =~ s/\\x([0-9a-fA-FX]+)/\\x{$1}/go;

    # escaped backslash: \\
    $string =~ s/\\\\/\\/go;

    return $string;
}

=pod

=cut

sub _trimSpaces {

    #my $text = $_[0]

    $_[0] =~ s/^[[:space:]]+//so;    # trim at start
    $_[0] =~ s/[[:space:]]+$//so;    # trim at end
}

sub _isNumber {

    #my ($input) = @_;

	return ($_[0] =~ m/^$PATTERN_NUMBER/);
}

sub _isString {

    # my ($input) = @_;
	if ( UNIVERSAL::isa( $_[0], "ARRAY" ) ) {
		return 0;
	}
	if ( UNIVERSAL::isa( $_[0], "HASH" ) ) {
		return 0;
	}
    return ( $_[0] & ~$_[0] ) ? 1 : 0;
}

=pod

_arrayAsHash( \@array, $quoteStrings ) -> \%hash

Stores an array as hash with the array indices as values.

If $quoteStrings is set to 1, strings are quoted to tell them apart from numbers.

=cut

sub _arrayAsHash {
    my ( $list, $quoteStrings ) = @_;

    my $data  = {};
    my $index = 0;
    if ($quoteStrings) {
        for ( @{$list} ) {
            $data->{ _isString($_) ? "\"$_\"" : $_ } = $index;
            $index++;
        }
    }
    else {
        for ( @{$list} ) {
            $data->{$_} = $index;
            $index++;
        }
    }
    return $data;
}

=pod

Removes whitespace after tags.
Only if the line contains whitespace (spaces or newline).
Only strips the first newline.

=cut

sub _stripWhitespaceAfterTag {

    #my $text = $_[0]

    return ( $_[0] =~ s/^([ \t]+\r|[ \t]+\n|[ \t]+$|[\r\n]{1})//s );
}

sub _stripWhitespaceBeforeTag {

    #my $text = $_[0]

    return ( $_[0] =~ s/([ \t]+\r|[ \t]+\n|[ \t]+$|[\r\n]{1})$//s );
}

# PARSING

=pod

=cut

sub _lexer {

    #	my ( $parser ) = shift;

    return ( '', undef )
      if !defined $_[0]->YYData->{DATA} || $_[0]->YYData->{DATA} eq '';

    for ( $_[0]->YYData->{DATA} ) {

        my $isInsideTag = $_[0]->_isInsideTag();

        print STDERR "_lexer input=$_.\n" if ( $_[0]->{debug} || $_[0]->{debugLevel} );
        print STDERR "\t context=" . $_[0]->_context() . "\n"
          if ( $_[0]->{debug} || $_[0]->{debugLevel} );
        print STDERR "\t is inside tag=" . $isInsideTag . "\n"
          if ( $_[0]->{debug} || $_[0]->{debugLevel} );
        print STDERR "\t if level=" . $_[0]->{_workingData}->{ifLevel} . "\n"
          if ( $_[0]->{debug} || $_[0]->{debugLevel} );
		print STDERR "\t list level=" . $_[0]->{_workingData}->{nestedLevel} . "\n"
          if ( $_[0]->{debug} || $_[0]->{debugLevel} );
        print STDERR "\t inTagBrackets=" . $_[0]->{_workingData}->{inTagBrackets} . "\n"
          if ( $_[0]->{debug} || $_[0]->{debugLevel} );

        if ( $_[0]->_context() eq 'whitespace' ) {
            if ( $_[0]->{_data}->{_ftlData}->{strip_whitespace} == 1 ) {
                _stripWhitespaceAfterTag($_);
            }
            return ( 'whitespace', '' );
        }

        if ( $_[0]->_context() eq 'condition' || $_[0]->_context() eq 'evalcondition' ) {
            $_ =~ s/^[ \t]*//;
			
			if (s/^(\()\s*//) {

                # make rest of condition safe: convert '>' to 'gt'
                $_ =~ s/^(.*?)\>(.*?)\)/$1gt$2)/;
                return ( '(', $1 );
            }
            return ( ')', $1 ) if (s/^(\))\s*//);

			return ( '.',      $1 ) if (s/^(\.)\s*//);
            return ( 'NUMBER', $1 ) if (s/^$PATTERN_NUMBER//);
            return ( '==',     $1 ) if (s/^(\=\=)\s*//);
            return ( '==',     $1 ) if (s/^\b(eq)\b\s*//);
            return ( '&&',     $1 ) if (s/^(&&)\s*//);
            return ( '||',     $1 ) if (s/^(\|\|)\s*//);
            return ( 'gte',    $1 ) if (s/^(\>\=)\s*//);
            return ( 'gte',    $1 ) if (s/^\b(gte)\b\s*//);
            return ( 'gte',    $1 ) if (s/^(&gte;)\s*//);
            return ( 'lte',    $1 ) if (s/^(\<\=)\s*//);
            return ( 'lte',    $1 ) if (s/^\b(lte)\b\s*//);
            return ( 'lte',    $1 ) if (s/^(&lte;)\s*//);
            return ( 'gt',     $1 ) if (s/^\b(gt)\b\s*//);
            return ( 'gt',     $1 ) if (s/^(&gt;)\s*//);
            return ( 'lt',     $1 ) if (s/^(\<)\s*//);
            return ( 'lt',     $1 ) if (s/^\b(lt)\b\s*//);
            return ( 'lt',     $1 ) if (s/^(&lt;)\s*//);
            return ( '!=',     $1 ) if (s/^(\!\=)\s*//);
            return ( '!=',     $1 ) if (s/^\b(ne)\b\s*//);
            return ( '!',      $1 ) if (s/^(\!)\s*//);
            return ( '==',     $1 ) if (s/^(\=)\s*//);
			return ( '??',     $1 ) if (s/^(\?\?)\s*//);
            return ( '?',      $1 ) if (s/^(\?)\s*//);
            return ( '[', $1 ) if (s/^(\[)\s*//);
			return ( ']', $1 ) if (s/^(\])\s*//);

			if ($_[0]->_context() eq 'condition') {
				return ( 'string', $1 ) if (s/^([\w\.\[\]\"]+)//);
			}
              
            return ( 'string', _interpolateEscapes($1) )
              if (s/^$PATTERN_PRESERVE_QUOTES//);

            # string operations
            return ( $1, $1 )
              if (
s/^\b(word_list|upper_case|uncap_first|substring|string|replace|lower_case|length|xhtml|html|eval|capitalize|cap_first)\b\s*//
              );

            # sequence operations
            return ( $1, $1 )
              if (
s/^\b(sort_by|sort|size|seq_index_of|seq_contains|reverse|last|join|first)\b\s*//
              );
            
            return ( 'DATA_KEY', $1 ) if (s/^(\w+)//);

           #return ( 'gt', $1 ) if (s/^(\>)\s*//); # not supported by FreeMarker
        }

        # when inside an if block:
        # go deeper with <#if...
        # go up one level with </#if>
        # ignore all other tags, these will be parsed in _parseIfBlock
        if ( $_[0]->{_workingData}->{ifLevel} != 0 ) {
            return ( '>',      '' ) if (s/^\s*>//);
            if (s/^<\#\b(if)\b/$1/) {
	            $_[0]->{_workingData}->{inTagBrackets} = 1;
	            return ( '<#',     '' );
	        }
            return ( '</#',    '' ) if (s/^\s*<\/\#\b(if)\b/$1/);
            return ( 'if',     $1 ) if s/^\b(if)\b//;
            return ( 'string', $1 ) if (s/^(.*?)(<(\/?\#\bif\b))/$2/s);
        }

        # delay parsing of list contents
        if ( $_[0]->{_workingData}->{nestedLevel} != 0 ) {
        	return ( 'string', $1 ) if (s/^\s*(<#\blist\b.*?\/\#\blist\b>)//s);	
        }
        
        if ( $_[0]->_context() eq 'list' ) {
        #if ( $_[0]->{_workingData}->{nestedLevel} != 0 ) {
            return ( '>',      '' ) if (s/^\s*>//);
            if (s/^<\#\b(list)\b/$1/) {
            	$_[0]->{_workingData}->{inTagBrackets} = 1;
            	return ( '<#',     '' );
            }
            return ( '</#',    '' ) if (s/^\s*<\/\#\b(list)\b/$1/);
            return ( 'list',     $1 ) if s/^\b(list)\b//;
            return ( 'string', $1 ) if (s/^(.*?)(<(\/?\#\blist\b))/$2/s);
        }

        # delay parsing of macro contents
        if ( $_[0]->_context() eq 'macrocontents' ) {
            return ( '>',      '' ) if (s/^\s*>//);
            if (s/^<\#\b(macro)\b/$1/) {
	            $_[0]->{_workingData}->{inTagBrackets} = 1;
	            return ( '<#',     '' );
	        }
            return ( '</#',    '' ) if (s/^\s*<\/\#\b(macro)\b/$1/);
            return ( 'macro',     $1 ) if s/^\b(macro)\b//;
            return ( 'string', $1 ) if (s/^(.*?)(<(\/?\#\bmacro\b))/$2/s);
        }
        
        # delay parsing of assign contents
        if ( $_[0]->_context() eq 'assign' ) {
            return ( '>',      '' ) if (s/^\s*>//);
            if (s/^<\#\b(assign)\b/$1/) {
	            $_[0]->{_workingData}->{inTagBrackets} = 1;
	            return ( '<#',     '' );
	        }
            return ( '</#',    '' ) if (s/^\s*<\/\#\b(assign)\b/$1/);
            return ( 'assign',     $1 ) if s/^\b(assign)\b//;
            return ( 'string', $1 ) if (s/^(.*?)(<(\/?\#\bassign\b))/$2/s);
        }

        # tags

        if ( $_[0]->{_workingData}->{inTagBrackets} ) {
            return ( '--',     $1 ) if s/^(--)//;
            return ( 'assign', $1 ) if s/^\b(assign)\b//;
            return ( 'macro',  $1 ) if s/^\b(macro)\b//;
            return ( 'list',   $1 ) if s/^\b(list)\b//;
            return ( 'if',     $1 ) if s/^\b(if)\b//;
            return ( '_if_',   $1 ) if (s/^\b(_if_)\b//);
            return ( 'ftl',    $1 ) if (s/^\b(ftl)\b//);
        }

        if ( $_[0]->{_workingData}->{inTagBrackets} && s/^\s*>// ) {
            $_[0]->{_workingData}->{inTagBrackets} = 0;
            return ( '>', '' );
        }
        if (s/^(<(?:#|@))//) {
            $_[0]->{_workingData}->{inTagBrackets} = 1;
            return ( $1, '' );
        }
        if (s/^(<\/(?:#|@))//) {
            $_[0]->{_workingData}->{inTagBrackets} = 1;
            return ( $1, '' );
        }

        return ( 'as', $1 ) if s/^\s*\b(as)\b//;

        # variables
        if ( !$isInsideTag ) {
            return ( '${', '' ) if (s/^\$\{//);
            return ( '}',  '' ) if (s/^\}//);
        }

        if (   $_[0]->_context() eq 'tagParams'
            || $_[0]->_context() eq 'variableParams'
            || $_[0]->_context() eq 'listParams'
            || $_[0]->_context() eq 'assignment' )
        {
            $_ =~ s/^[[:space:]]*//;
            return ( 'NUMBER', $1 )
              if (s/^(\d+)(\.\.)\s*/$2/)
              ;   # with array access - prevent that first dot is seen as number
            return ( '.vars',  $1 ) if (s/^(\.vars)\s*//);
            return ( '..',     $1 ) if (s/^(\.\.)\s*//);
            return ( '.',      $1 ) if (s/^(\.)\s*//);
            return ( '+',      $1 ) if (s/^(\+)\s*//);
            return ( '-',      $1 ) if (s/^(\-)\s*//);
            return ( '*',      $1 ) if (s/^(\*)\s*//);
            return ( '/',      $1 ) if (s/^(\/)\s*//);
            return ( '%',      $1 ) if (s/^(%)\s*//);
            return ( '?',      $1 ) if (s/^(\?)\s*//);
            return ( 'true',   $1 ) if (s/^(\"*true\"*)\s*//);
            return ( 'false',  $1 ) if (s/^(\"*false\"*)\s*//);
            return ( 'NUMBER', $1 ) if (s/^$PATTERN_NUMBER//);

            # string operations
            return ( $1, $1 )
              if (
s/^\b(word_list|upper_case|uncap_first|substring|string|replace|lower_case|length|xhtml|html|eval|capitalize|cap_first)\b\s*//
              );

            # sequence operations
            return ( $1, $1 )
              if (
s/^(sort_by|sort|size|seq_index_of|seq_contains|reverse|last|join|first)\s*//
              );

            # other strings
            return ( 'string', _interpolateEscapes($1) )
              if (s/^$PATTERN_PRESERVE_QUOTES//);

            if (   $_[0]->_context() eq 'variableParams'
                || $_[0]->_context() eq 'listParams' )
            {
                return ( 'r',        $1 ) if (s/^\b(r)\b//);
                return ( '!',        $1 ) if (s/^(!)\s*//);
                return ( 'DATA_KEY', $1 ) if (s/^(\w+)//);
            }
            if ( $_[0]->_context() eq 'assignment' ) {
                return ( 'DATA_KEY', $1 ) if (s/^(\w+)//);
                return ( '=',   $1 ) if (s/^(\=)\s*//);
            }
            if ( $_[0]->_context() eq 'tagParams' ) {
                return ( 'string', $1 ) if (s/^(\w+)\s*//);
            }
            return ( '=', $1 ) if (s/^(\=)\s*//);
            return ( '[', $1 ) if (s/^(\[)\s*//);
            return ( ']', $1 ) if (s/^(\])\s*//);
            return ( '(', $1 ) if (s/^(\()\s*//);
            return ( ')', $1 ) if (s/^(\))\s*//);
            return ( '{', $1 ) if (s/^(\{)\s*//);
            return ( '}', $1 ) if (s/^(\})//);
            return ( ':', $1 ) if (s/^(:)\s*//);
            return ( ',', $1 ) if (s/^(,)\s*//);
        }

        if ($isInsideTag) {
            return ( 'string', $1 ) if (s/^(.*?)(-->|<\#|<\/\#)/$2/s);
        }
        else {
            return ( 'string', $1 )
              if (s/^(.*?)(<\#|<\@|\$\{)/$2/s);

			return ( 'string', $1 )
              if (s/^(\w+)(\>)/$2/s);
              
            return ( 'string', $1 )
              if (s/^(.*)$//s);
        }
    }
}

sub _error {
    exists $_[0]->YYData->{ERRMSG}
      and do {
        print STDERR $_[0]->YYData->{ERRMSG};
        delete $_[0]->YYData->{ERRMSG};
        return;
      };
    print STDERR "Syntax error\n";
}

sub _parse {
    #my ( $this, $input, $dataRef ) = @_;

    return '' if !defined $_[1] || $_[1] eq '';

    print STDERR "_parse:input=$_[1]\n" if ( $_[0]->{debug} || $_[0]->{debugLevel} );

    my $parser = new Foswiki::Plugins::FreeMarkerPlugin::FreeMarkerParser();

    $parser->{debugLevel}    = $_[0]->{debugLevel};
    $parser->{debug}         = $_[0]->{debug};
    $parser->{_data}         = $_[0]->{_data};
    if (keys %{$_[2]}) {
    	my %data = (%{$_[2]}, %{$parser->{_data}});
    	$parser->{_data} = \%data;
    }   
    $parser->{_workingData}   = $_[0]->{_workingData};

    return $parser->parse( $_[1] );
}

=pod

parse ($input, \%data)  -> $result

Takes an input string and returns the parsed result.

param $input: string
param \%data: optional hash of variables that are used with variable substitution


1.	Build data model from <#...></#...> directives (tags).
	All non-scalar data is stored as references.
2.	Invoke function calls (text substitution)
3.	Substitute ${...} variables based on data model

Lingo:

With the example:
	<#assign x>hello</#assign>

assign:		directive
x:			expression (a variable)
hello:		tag content

With the example:
	<#assign x="10">

assign:		operator
x="10":		expression (assignment)


Order of variable substitution is from top to bottom, as illustrated with this example:

	${mouse!"No mouse."}
	<#assign mouse="Jerry">
	${mouse!"No mouse."}  

The output will be:

	No mouse.
	Jerry  

=cut

sub parse {
    #my ( $this, $input, $dataRef ) = @_;

    return '' if !defined $_[1] || $_[1] eq '';
    
    $_[0]->_init( $_[2] );
    $_[0]->{debug} ||= 0;
    $_[0]->{debugLevel} ||= 0;

	use Data::Dumper;
    print STDERR "parse -- input data=" . Dumper($_[0]->{_data}) . "\n" if ( $_[0]->{debug} || $_[0]->{debugLevel} );
    
    print STDERR "parse:input=$_[1]\n" if ( $_[0]->{debug} || $_[0]->{debugLevel} );

    $_[0]->YYData->{DATA} = $_[1];
    my $result = $_[0]->YYParse(
        yylex   => \&_lexer,
        yyerror => \&_error,
        yydebug => $_[0]->{debugLevel}
    );
    $result = '' if !defined $result;
	
	# remove expansion protection
    $result =~ s/<fmg_nop>//go;
    
    print STDERR "parse:result=$result\n" if ( $_[0]->{debug} || $_[0]->{debugLevel} );

    undef $_[0]->{_workingData};
    $_[0]->{data} = $_[0]->{_data};
    undef $_[0]->{_data};
    return $result;
}

=pod

setDebugLevel( $debug, $debugLevel )

=debug=: number
=debugLevel=: number

Set debugging state and the level of debug messages.

Bit Value    Outputs
0x01         Token reading (useful for Lexer debugging)
0x02         States information
0x04         Driver actions (shifts, reduces, accept...)
0x08         Parse Stack dump
0x10         Error Recovery tracing

=cut

sub setDebugLevel {
    my ( $this, $debug, $debugLevel ) = @_;

	$this->{debug} = $debug;
	$this->{debugLevel} = $debugLevel;
}


1;
