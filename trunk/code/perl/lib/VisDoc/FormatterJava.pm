package VisDoc::FormatterJava;
use base 'VisDoc::FormatterBase';

use strict;

=pod

=cut

sub new {
    my ($class) = @_;
    my VisDoc::FormatterJava $this = $class->SUPER::new();

    $this->{LANGUAGE} = 'java';
	$this->{syntax} = {
		keywords => '\bwhile\b|\bvolatile\b|\bvoid\b|\btry\b|\btransient\b|\bthrows\b|\bthrow\b|\bthis\b|\bsynchronized\b|\bswitch\b|\bsuper\b|\bstrictfp\b|\bstatic\b|\bshort\b|\breturn\b|\bpublic\b|\bprotected\b|\bprivate\b|\bpackage\b|\bnew\b|\bnative\b|\blong\b|\binterface\b|\bint\b|\binstanceof\b|\bimport\b|\bimplements\b|\bif\b|\bgoto\b|\bfor\b|\bfloat\b|\bfinally\b|\bfinal\b|\bextends\b|\benum\b|\belse\b|\bdouble\b|\bdo\b|\bdefault\b|\bcontinue\b|\bconst\b|\bclass\b|\bchar\b|\bcatch\b|\bcase\b|\bbyte\b|\bbreak\b|\bboolean\b|\bassert\b|\babstract\b',
		identifiers => '',
		properties => '',
	};
    bless $this, $class;
    return $this;
}

1;
