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

sub decode($$;$) {
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

=head1 NAME

Encode::UTF8Mac - "utf-8-mac" encoding, a variant utf-8 used by Mac OSX

=head1 SYNOPSIS

  use Encode;
  use Encode::UTF8Mac;
  
  my $filename = Encode::encode('utf-8-mac', "\x{3054}\x{FA19}\x{4F53}");
  # => \xE3\x81\x93\xE3\x82\x99\xEF\xA8\x99\xE4\xBD\x93
  # note:
  # Unicode utf-8(hex)    NFD()            MacOS
  # U+3054  \xE3\x81\x94  U+3053 + U+3099  decompose
  # U+3053  \xE3\x81\x93  (no-op)
  # U+3099  \xE3\x82\x99  (no-op)
  # U+FA19  \xEF\xA8\x99  U+795E           not decompose
  # U+4F53  \xE4\xBD\x93  (no-op)
  
  $filename = Encode::decode('utf-8-mac', $filename);
  # => \x{3054}\x{FA19}\x{4F53}

=head1 DESCRIPTION

Encode::UTF8Mac provides a encoding called "utf-8-mac" used in Mac OSX.

On Mac OSX, utf-8 encoding is used and it is normalized form D
(characters are decomposed). However, not follow the exact specification.

L<http://developer.apple.com/library/mac/#qa/qa2001/qa1173.html>

Specifically, the following ranges are not decomposed.

  U+2000-U+2FFF
  U+F900-U+FAFF
  U+2F800-U+2FAFF

In iconv (bundled Mac), this encoding can be using as "utf-8-mac".

This module adds "utf-8-mac" encoding for L<Encode>, it encode/decode text
with that rule in mind. This will help when you decode file name on Mac.

=head1 ENCODING

=over 4

=item utf-8-mac

=over 4

=item * Encode::decode('utf-8-mac', $bytes)

Decode as utf-8, and normalize form C except special range
using Unicode::Normalize.

=item * Encode::encode('utf-8-mac', $unicode)

Normalize form D except special range using Unicode::Normalize,
and encode as utf-8.

=back

=back

=head1 SEE ALSO

L<Encode>, L<Encode::Locale>, L<Unicode::Normalize>

=head1 AUTHOR

Naoki Tomita E<lt>tomita@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
