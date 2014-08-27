package Plack::Debugger::Panel::Parameters;

use strict;
use warnings;

use Plack::Request;

use parent 'Plack::Debugger::Panel';

sub new {
    my $class = shift;
    my %args  = @_ == 1 && ref $_[0] eq 'HASH' ? %{ $_[0] } : @_;

    $args{'after'} = sub {
        my $self = shift;
        my $r    = Plack::Request->new( shift );
        $self->set_result({
            get     => $r->query_parameters->as_hashref_mixed,
            cookies => $r->cookies,
            post    => $r->body_parameters->as_hashref_mixed,
            headers => { map { $_ => $r->headers->header( $_ ) } $r->headers->header_field_names },
            ($r->env->{'psgix.session'} 
                ? (session => $r->env->{'psgix.session'})
                : ()),
        });
    };

    $class->SUPER::new( \%args );
}


1;

__END__