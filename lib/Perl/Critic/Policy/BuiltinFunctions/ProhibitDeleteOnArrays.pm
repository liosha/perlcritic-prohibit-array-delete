package Perl::Critic::Policy::BuiltinFunctions::ProhibitDeleteOnArrays;

use 5.006001;
use strict;
use warnings;
use Readonly;

use Perl::Critic::Utils qw{ :severities :classification :ppi };
use base 'Perl::Critic::Policy';


#-----------------------------------------------------------------------------

Readonly::Scalar my $DESC => q{"delete" on array};
Readonly::Scalar my $EXPL => q{Calling delete on array values is strongly discouraged};

#-----------------------------------------------------------------------------

sub supported_parameters { return ()                       }
sub default_severity     { return $SEVERITY_LOW            }
sub default_themes       { return qw(maintenance)          }
sub applies_to           { return 'PPI::Token::Word'       }

#-----------------------------------------------------------------------------

sub violates {
    my ( $self, $elem, undef ) = @_;
    return if $elem ne 'delete';
    return if ! is_function_call( $elem );

    my @args = parse_arg_list($elem);
    return if !@args;
    my $arg = shift @args;

#    use YAML; say STDERR Dump($arg);
    my $subscr = $arg->[-1];
    return if !$subscr;
    return if !$subscr->isa("PPI::Structure::Subscript") && !$subscr->isa("PPI::Structure::Constructor");

    if ($subscr->start->content eq q#[#) {
        return $self->violation( $DESC, $EXPL, $elem );
    }

    return;
}


1;

__END__

#-----------------------------------------------------------------------------

=pod

=head1 NAME

Perl::Critic::Policy::BuiltinFunctions::ProhibitDeleteOnArrays - Do not use
C<delete> on arrays.

=head1 DESCRIPTION

Calling delete on array values is strongly discouraged. See
L<http://perldoc.perl.org/functions/delete.html>.

=head1 CONFIGURATION

This Policy is not configurable except for the standard options.

=head1 AUTHOR

Aleksey Korabelshchikov L<mailto:xliosha@gmail.com>

=cut

