package Encode::UTF8Mac;
use 5.008001;
use strict;
use warnings;
our $VERSION = '0.02';

use Encode ();
use Unicode::Normalize::Mac;
use base qw(Encode::Encoding);

__PACKAGE__->Define(qw(utf-8-mac));

my $utf8 = Encode::find_encoding('utf-8');

sub decode($$;$) {
    my ($self, $octets, $check) = @_;
    return unless defined $octets;
    my $string = $utf8->decode($octets, $check || Encode::FB_DEFAULT);
    $string = Unicode::Normalize::Mac::NFC($string);
}

sub encode($$;$) {
    my ($self, $string, $check) = @_;
    return unless defined $string;
    $string .= '' if ref $string;
    $string = Unicode::Normalize::Mac::NFD($string);
    $utf8->encode($string, $check || Encode::FB_DEFAULT);
}

1;
__END__

=encoding utf-8

=head1 NAME

Encode::UTF8Mac - "utf-8-mac" encoding, a variant utf-8 used by Mac OSX

=head1 SYNOPSIS

  use Encode;
  use Encode::UTF8Mac;
  
  my ($filename) = <*.txt>;

  $filename = Encode::decode('utf-8', $filename);
  # => "poke\x{0301}mon.txt" (NFD é)

  $filename = Encode::decode('utf-8-mac', $filename);
  # => "pok\x{00E9}mon.txt" (NFC é)

=head1 DESCRIPTION

Encode::UTF8Mac provides a encoding called "utf-8-mac" for Mac OSX.

On Mac OSX, utf-8 encoding is used and it is NFD (Normalization Form
canonical Decomposition). If you want to get NFC (Normalization Form
canonical Composition) character you need to use L<Unicode::Normalize>'s
C<NFC()>.

However, Mac OSX filesystem does not follow the exact specification.
Specifically, the following ranges are not decomposed.

  U+2000-U+2FFF
  U+F900-U+FAFF
  U+2F800-U+2FAFF

L<http://developer.apple.com/library/mac/#qa/qa2001/qa1173.html>

In iconv (bundled Mac), this encoding can be using as "utf-8-mac".
This module adds "utf-8-mac" encoding for L<Encode>, it encode/decode text
with that rule in mind. This will help when you decode file name on Mac.

See more specific example:
L<http://perl-users.jp/articles/advent-calendar/2010/english/24>

=head1 ENCODING

=over 4

=item utf-8-mac

=over 4

=item * Encode::decode('utf-8-mac', $octets)

Decode as utf-8, and normalize form C except special range
using Unicode::Normalize.

=item * Encode::encode('utf-8-mac', $string)

Normalize form D except special range using Unicode::Normalize,
and encode as utf-8.

OSX file system change NFD automatically. So actually, this is not necessary.

=back

=back

=head1 COOKBOOK

  use Encode;
  use Encode::Locale;
  
  # change locale_fs "utf-8" to "utf-8-mac"
  if ($^O eq 'darwin') {
      require Encode::UTF8Mac;
      $Encode::Locale::ENCODING_LOCALE_FS = 'utf-8-mac';
  }
  
  $filename = Encode::decode('locale_fs', $filename);

If you are using L<Encode::Locale>, you may want to do this.

=head1 SEE ALSO

L<Encode::Locale> - provides usefull "magic" encoding.

L<Unicode::Normalize::Mac> - contains "utf-8-mac" logic.

=head1 AUTHOR

Naoki Tomita E<lt>tomita@cpan.orgE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
