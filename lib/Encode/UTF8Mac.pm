package Encode::UTF8Mac;
use 5.008001;
use strict;
use warnings;
our $VERSION = '0.01';

use Encode ();
use Unicode::Normalize;
use base qw(Encode::Encoding);

__PACKAGE__->Define(qw(utf-8-mac));

my $utf8 = Encode::find_encoding('utf-8');

# http://developer.apple.com/library/mac/#qa/qa2001/qa1173.html
my $decompose = qr/([^\x{2000}-\x{2FFF}\x{F900}-\x{FAFF}\x{2F800}-\x{2FAFF}]*)/;

sub decode($$;$){
    my ($self, $bytes, $check) = @_;
    my $unicode = $utf8->decode($bytes, $check);
    $unicode =~ s/$decompose/Unicode::Normalize::NFC($1)/eg;
    $unicode;
}

sub encode($$;$) {
    my ($self, $unicode, $check) = @_;
    return unless defined $unicode;
    $unicode .= '' if ref $unicode;
    $unicode =~ s/$decompose/Unicode::Normalize::NFD($1)/eg;
    $utf8->encode($unicode, $check);
}

1;
__END__

=encoding utf-8

=head1 NAME

Encode::UTF8Mac -

=head1 SYNOPSIS

  use Encode::UTF8Mac;

=head1 DESCRIPTION

Encode::UTF8Mac is

http://developer.apple.com/library/mac/#qa/qa2001/qa1173.html

=head1 METHODS

=over 4

=item new

=item foo

=back

=head1 SEE ALSO

L<Encode::UTF8Mac>

=head1 AUTHOR

Naoki Tomita E<lt>tomita@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
