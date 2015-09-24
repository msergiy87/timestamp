package sDatetime;
use nginx;
sub handler {
my $r = shift;
$r->send_http_header("text/html");
return OK if $r->header_only;
$r->print(time);
return OK;
}
1;
__END__
