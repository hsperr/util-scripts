use strict;
use warnings;

# return a minimum edit distance path with the following notation, plus cost
#  d=delete i=insert s=substitute e=equal
sub levenshtein {
    my ($s, $t) = @_;
    my (@sc, $m, @tc, $n, %d, %str, $i, $j, $id, $cost, $type, $aid, $bid, $cid, $c);
    @sc = split(/ +/, $s);
    $m = @sc;
    @tc = split(/ +/, $t);
    $n = @tc;
    # initialize
    %d = (); %str = {};
    foreach $i (0 .. $m) { $id = pack('S2', $i, 0); $d{$id} = $i; $str{$id} = 'd'x$i; }
    foreach $j (1 .. $n) { $id = pack('S2', 0, $j); $d{$id} = $j; $str{$id} = 'i'x$j; }

    foreach $i (1 .. $m) {
        foreach $j (1 .. $n) {
            if($sc[$i-1] eq $tc[$j-1]) {
                $cost = 0; $type = 'e'; # equal
            } else {
                $cost = 1.1; $type = 's'; # substitution
            }

            $aid = pack('S2', $i-1, $j); $a = $d{$aid} + 1; # deletion
            $bid = pack('S2', $i, $j-1); $b = $d{$bid} + 1; # insertion
            $cid = pack('S2', $i-1, $j-1); $c = $d{$cid} + $cost; # insertion

            $id = pack('S2', $i, $j);

            # we want matches to come at the end, so do deletions/insertions first
            if($a <= $b and $a <= $c) {
                $d{$id} = $a;
                $type = 'd';
                $str{$id} = $str{$aid}.'d';
            }
            elsif($b <= $c) {
                $d{$id} = $b;
                $type = 'i';
                $str{$id} = $str{$bid}.'i';
            }
            else {
                $d{$id} = $c;
                $str{$id} = $str{$cid}.$type;
            }

            delete $d{$cid};
            delete $str{$cid};
            # print "".$sc[$i-1]." ".$tc[$j-1]." $i $j $a $b $c $d[$id] $type\n"
        }
    }

    $id = pack('S2', $m, $n);
    return ($str{$id}, $d{$id});
}

1
