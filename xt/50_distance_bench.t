#!perl
use 5.006;

use strict;
use warnings;
use utf8;

use open qw(:locale);

use lib qw(
../lib/
./lib/
/Users/helmut/github/perl/Levenshtein-Simple/lib
);

#use Test::More;

use Benchmark qw(:all) ;
use Data::Dumper;

#use Text::Levenshtein::BV;
use Text::Levenshtein::BVXS;
#use Text::Levenshtein::XS qw(distance);
use Text::Levenshtein::XS;
use Text::Levenshtein;
use Text::Levenshtein::Flexible;

#use Text::Levenshtein::BVmyers;
#use Text::Levenshtein::BVhyrr;
use Levenshtein::Simple;

##use Text::LevenshteinXS;
use Text::Fuzzy;

#use LCS::BV;

my @data_ascii = (
  [split(//,'Chrerrplzon')],
  [split(//,'Choerephon')]
);

# ehorſ 5 letters ſhoer
my @data_uni = (
  [split(//,'Chſerſplzon')],
  [split(//,'Choerephon')]
);

my @strings_ascii = qw(Chrerrplzon Choerephon);
my @strings_uni   = qw(Chſerſplzon Choerephon);

my @data2 = (
  [split(//,'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXY')],
  [split(//, 'bcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')]
);

my @strings2 = qw(
abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXY
bcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ
);

my @data_l68 = (
  [split(//,'abcdefghijklmnopqrstuvwxyz0123456789!"$%&/()=?ABCDEFGHIJKLMNOPQRSTUVY')],
  [split(//, 'bcdefghijklmnopqrstuvwxyz0123456789!"$%&/()=?ABCDEFGHIJKLMNOPQRSTUVYZ')]
);

my @strings_l68 = qw(
abcdefghijklmnopqrstuvwxyz0123456789!"$%&/()=?ABCDEFGHIJKLMNOPQRSTUVY
bcdefghijklmnopqrstuvwxyz0123456789!"$%&/()=?ABCDEFGHIJKLMNOPQRSTUVYZ
);

my @data3 = ([qw/a b d/ x 50], [qw/b a d c/ x 50]);

my @strings3 = map { join('',@$_) } @data3;

my $tf_ascii = Text::Fuzzy->new($data_ascii[0]);
my $tf_uni   = Text::Fuzzy->new($data_uni[0]);

#print STDERR 'S::Similarity: ',similarity(@strings),"\n";
#print STDERR 'Text::Levenshtein::BV:       ',Text::Levenshtein::BV->distance(@data),"\n";
#print STDERR 'Text::Levenshtein::BVXS:     ',Text::Levenshtein::BVXS::distance(@strings),"\n";
#print STDERR 'Text::Levenshtein::BV2:      ',Text::Levenshtein::BV->distance2(@data),"\n";
#print STDERR 'Text::Levenshtein::XS:       ',&Text::Levenshtein::XS::distance(@strings),"\n";
#print STDERR 'Text::Levenshtein:           ',&Text::Levenshtein::distance(@strings),"\n";
#print STDERR 'Text::Levenshtein::Flexible: ',&Text::Levenshtein::Flexible::levenshtein(@strings),"\n";
#print STDERR 'Text::Fuzzy:                 ',$tf->distance($data[1]),"\n";
#print STDERR 'Text::LevenshteinXS:         ',&Text::LevenshteinXS::distance(@strings),"\n";


if (1) {
    cmpthese( -1, {
       'TL::BVXS_ascii' => sub {
            Text::Levenshtein::BVXS::distance(@strings_ascii)
        },
       'TL::BVXS_simple' => sub {
            Text::Levenshtein::BVXS::simple(@strings_ascii)
        },
       'TL::BVXS_uni' => sub {
            Text::Levenshtein::BVXS::distance(@strings_uni)
        },
       'TL::BVXS_l52' => sub {
            Text::Levenshtein::BVXS::distance(@strings2)
        },
        'TL::BVXS_l68' => sub {
            Text::Levenshtein::BVXS::distance(@strings_l68)
        },
        'TL::Flex_ascii' => sub {
            &Text::Levenshtein::Flexible::levenshtein(@strings_ascii)
        },
        'TL::Flex_uni' => sub {
            &Text::Levenshtein::Flexible::levenshtein(@strings_uni)
        },
        'TL::Flex_l52' => sub {
            &Text::Levenshtein::Flexible::levenshtein(@strings2)
        },
        'TL::Flex_l68' => sub {
            &Text::Levenshtein::Flexible::levenshtein(@strings_l68)
        },
    });
}

if (1) {
    cmpthese( -1, {
       'TL::BVXS_arr_ascii' => sub {
            Text::Levenshtein::BVXS::distance_arr(@data_ascii)
        },
       #'TL::BVXS_arr_simple' => sub {
       #     Text::Levenshtein::BVXS::simple_arr(@data_ascii)
       # },
       'TL::BVXS_arr_uni' => sub {
            Text::Levenshtein::BVXS::distance_arr(@data_uni)
        },
       'TL::BVXS_arr_l52' => sub {
            Text::Levenshtein::BVXS::distance_arr(@data2)
        },
        'TL::BVXS_arr_l68' => sub {
            Text::Levenshtein::BVXS::distance_arr(@data_l68)
        },
        'TL::Flex_ascii' => sub {
            &Text::Levenshtein::Flexible::levenshtein(@strings_ascii)
        },
        'TL::Flex_uni' => sub {
            &Text::Levenshtein::Flexible::levenshtein(@strings_uni)
        },
        'TL::Flex_l52' => sub {
            &Text::Levenshtein::Flexible::levenshtein(@strings2)
        },
        'TL::Flex_l68' => sub {
            &Text::Levenshtein::Flexible::levenshtein(@strings_l68)
        },
    });
}

=pod
version 0.06
Text::Levenshtein::BV:       4
Text::Levenshtein::BVXS:     4
Text::Levenshtein:           4
Text::Levenshtein::Flexible: 4
Text::Fuzzy:                 5
                 Rate     TL Lev::Simple TL::BV LCS::BV T::Fuzz TL::BVXS TL::Flex
TL             6636/s     --        -78%   -95%    -96%   -100%    -100%    -100%
Lev::Simple   29537/s   345%          --   -77%    -84%    -98%     -99%     -99%
TL::BV       130326/s  1864%        341%     --    -30%    -91%     -96%     -96%
LCS::BV      187398/s  2724%        534%    44%      --    -87%     -94%     -94%
T::Fuzz     1434347/s 21514%       4756%  1001%    665%      --     -51%     -55%
TL::BVXS    2940717/s 44214%       9856%  2156%   1469%    105%       --      -8%
TL::Flex    3206187/s 48214%      10755%  2360%   1611%    124%       9%       --

version 0.07 'elsif'

                 Rate     TL Lev::Simple TL::BV LCS::BV T::Fuzz TL::BVXS TL::Flex
TL             5999/s     --        -79%   -95%    -97%   -100%    -100%    -100%
Lev::Simple   28980/s   383%          --   -77%    -84%    -98%     -99%     -99%
TL::BV       124842/s  1981%        331%     --    -33%    -91%     -96%     -96%
LCS::BV      185579/s  2993%        540%    49%      --    -87%     -93%     -94%
T::Fuzz     1402911/s 23285%       4741%  1024%    656%      --     -50%     -55%
TL::BVXS    2831802/s 47104%       9672%  2168%   1426%    102%       --      -9%
TL::Flex    3113701/s 51803%      10644%  2394%   1578%    122%      10%       --

                 Rate     TL Lev::Simple TL::BV LCS::BV T::Fuzz TL::BVXS TL::Flex
TL             6515/s     --        -79%   -95%    -97%   -100%    -100%    -100%
Lev::Simple   30351/s   366%          --   -76%    -84%    -98%     -99%     -99%
TL::BV       129152/s  1882%        326%     --    -34%    -91%     -96%     -96%
LCS::BV      194606/s  2887%        541%    51%      --    -86%     -93%     -94%
T::Fuzz     1379705/s 21076%       4446%   968%    609%      --     -53%     -54%
TL::BVXS    2940717/s 45034%       9589%  2177%   1411%    113%       --      -2%
TL::Flex    2998379/s 45919%       9779%  2222%   1441%    117%       2%       --

'mask per table'
                 Rate     TL Lev::Simple TL::BV LCS::BV T::Fuzz TL::BVXS TL::Flex
TL             6636/s     --        -78%   -95%    -97%   -100%    -100%    -100%
Lev::Simple   30075/s   353%          --   -78%    -85%    -98%     -99%     -99%
TL::BV       137845/s  1977%        358%     --    -30%    -90%     -95%     -96%
LCS::BV      196495/s  2861%        553%    43%      --    -86%     -94%     -94%
T::Fuzz     1420284/s 21302%       4622%   930%    623%      --     -53%     -56%
TL::BVXS    3028065/s 45530%       9968%  2097%   1441%    113%       --      -6%
TL::Flex    3215551/s 48355%      10592%  2233%   1536%    126%       6%       --

perl 5.32.0
                  Rate      TL Lev::Simple TL::BV LCS::BV T::Fuzz TL::Flex TL::BVXS
TL              6826/s      --        -83%   -96%    -97%    -99%    -100%    -100%
Lev::Simple    40573/s    494%          --   -77%    -84%    -97%     -99%    -100%
TL::BV        173769/s   2446%        328%     --    -32%    -87%     -95%     -99%
LCS::BV       254485/s   3628%        527%    46%      --    -80%     -93%     -98%
T::Fuzz      1291788/s  18825%       3084%   643%    408%      --     -66%     -89%
TL::Flex     3814985/s  55791%       9303%  2095%   1399%    195%       --     -69%
TL::BVXS    12287999/s 179925%      30186%  6971%   4729%    851%     222%       --

BVXS ascii

                  Rate      TL Lev::Simple TL::BV LCS::BV T::Fuzz TL::Flex TL::BVXS
TL              6576/s      --        -79%   -95%    -97%   -100%    -100%    -100%
Lev::Simple    30632/s    366%          --   -78%    -84%    -98%     -99%    -100%
TL::BV        138400/s   2005%        352%     --    -28%    -90%     -96%     -99%
LCS::BV       190934/s   2803%        523%    38%      --    -86%     -94%     -98%
T::Fuzz      1377633/s  20849%       4397%   895%    622%      --     -56%     -88%
TL::Flex     3099675/s  47035%      10019%  2140%   1523%    125%       --     -72%
TL::BVXS    11062957/s 168129%      36015%  7893%   5694%    703%     257%       --

BVXS uni sequential
Text::Levenshtein::BVXS:     3
Text::Levenshtein::Flexible: 3
Text::Fuzzy:                 3
                    Rate   T::Fuzz  TL::Flex TL::BVXS TL::BVXSnoop TL::BVXSnoutf
T::Fuzz        1279827/s        --      -51%     -54%         -61%          -96%
TL::Flex       2621439/s      105%        --      -5%         -21%          -92%
TL::BVXS       2759410/s      116%        5%       --         -17%          -91%
TL::BVXSnoop   3308308/s      158%       26%      20%           --          -90%
TL::BVXSnoutf 31638068/s     2372%     1107%    1047%         856%            --

BVXS utf8-i sequential

                    Rate   T::Fuzz  TL::Flex TL::BVXSnoop TL::BVXS TL::BVXSnoutf
T::Fuzz        1291788/s        --      -49%         -62%     -85%          -96%
TL::Flex       2541562/s       97%        --         -25%     -70%          -92%
TL::BVXSnoop   3398162/s      163%       34%           --     -60%          -89%
TL::BVXS       8574803/s      564%      237%         152%       --          -72%
TL::BVXSnoutf 30247384/s     2242%     1090%         790%     253%            --

~/github/perl/Text-Levenshtein-BVXS/xt$ perl 50_distance_bench.t
                     Rate T::Fuzz_ascii T::Fuzz_uni TL::Flex_uni TL::Flex_ascii TL::BVXS_uni TL::BVXS_ascii
T::Fuzz_ascii   1279827/s            --         -1%         -48%           -68%         -85%           -89%
T::Fuzz_uni     1298354/s            1%          --         -48%           -67%         -85%           -89%
TL::Flex_uni    2473057/s           93%         90%           --           -38%         -71%           -79%
TL::Flex_ascii  3978971/s          211%        206%          61%             --         -54%           -67%
TL::BVXS_uni    8652585/s          576%        566%         250%           117%           --           -27%
TL::BVXS_ascii 11883483/s          829%        815%         381%           199%          37%             --

# uni codepoints sequential

helmut@mbp:~/github/perl/Text-Levenshtein-BVXS/xt$ perl 50_distance_bench.t
                     Rate T::Fuzz_ascii T::Fuzz_uni TL::BVXS_uni TL::Flex_uni TL::Flex_ascii TL::BVXS_ascii
T::Fuzz_ascii   1268085/s            --         -2%         -51%         -53%           -67%           -90%
T::Fuzz_uni     1291788/s            2%          --         -50%         -52%           -66%           -90%
TL::BVXS_uni    2572440/s          103%         99%           --          -5%           -33%           -79%
TL::Flex_uni    2698541/s          113%        109%           5%           --           -29%           -78%
TL::Flex_ascii  3817631/s          201%        196%          48%          41%             --           -69%
TL::BVXS_ascii 12365282/s          875%        857%         381%         358%           224%             --


TL::uni_noop    3398162/s
TL::utf8_noop  30247384/s

TL::BVXS_uni    2572440/s
TL::BVXS_utf8   8652585/s
TL::BVXS_ascii 12365282/s

# prefix/suffix
helmut@mbp:~/github/perl/Text-Levenshtein-BVXS$ perl xt/50_distance_bench.t
                     Rate T::Fuzz_ascii T::Fuzz_uni TL::Flex_uni TL::Flex_ascii TL::BVXS_uni TL::BVXS_ascii
T::Fuzz_ascii   1303272/s            --         -1%         -49%           -66%         -84%           -91%
T::Fuzz_uni     1310719/s            1%          --         -49%           -66%         -84%           -90%
TL::Flex_uni    2572440/s           97%         96%           --           -33%         -69%           -81%
TL::Flex_ascii  3817631/s          193%        191%          48%             --         -54%           -72%
TL::BVXS_uni    8265802/s          534%        531%         221%           117%           --           -40%
TL::BVXS_ascii 13762560/s          956%        950%         435%           260%          66%             --

helmut@mbp:~/github/perl/Text-Levenshtein-BVXS$ perl xt/50_distance_bench.t
                     Rate T::Fuzz_ascii T::Fuzz_uni TL::Flex_uni TL::Flex_ascii TL::BVXS_uni TL::BVXS_ascii
T::Fuzz_ascii   1303975/s            --         -2%         -48%           -67%         -83%           -91%
T::Fuzz_uni     1329051/s            2%          --         -47%           -67%         -83%           -90%
TL::Flex_uni    2530597/s           94%         90%           --           -36%         -68%           -82%
TL::Flex_ascii  3978971/s          205%        199%          57%             --         -49%           -71%
TL::BVXS_uni    7841914/s          501%        490%         210%            97%           --           -43%
TL::BVXS_ascii 13762559/s          955%        936%         444%           246%          76%             --

helmut@mbp:~/github/perl/Text-Levenshtein-BVXS/src$ ./levtest
[dist_asci] iters: 20 M Elapsed: 0.799409 s Rate: 25.0 (M/sec) 4
[dist_utf8_ucs] iters: 20 M Elapsed: 1.995221 s Rate: 10.0 (M/sec) 4
[dist_uni] iters: 20 M Elapsed: 1.106825 s Rate: 18.1 (M/sec) 4
Total: 3.901455 seconds

helmut@mbp:~/github/perl/Text-Levenshtein-BVXS/src$ ./levtest
[dist_asci]     iters: 20 M Elapsed: 0.803021 s Rate: 24.9 (M/sec) 4
[dist_utf8_ucs] iters: 20 M Elapsed: 1.913089 s Rate: 10.5 (M/sec) 4
[dist_uni]      iters: 20 M Elapsed: 1.084475 s Rate: 18.4 (M/sec) 4
[dist_hybrid]   iters: 20 M Elapsed: 0.873442 s Rate: 22.9 (M/sec) 4

using hybrid for uni
helmut@mbp:~/github/perl/Text-Levenshtein-BVXS$ perl xt/50_distance_bench.t
                     Rate TL::Flex_l52 TL::Flex_uni TL::Flex_ascii TL::BVXS_l52 TL::BVXS_uni TL::BVXS_ascii
TL::Flex_l52     211861/s           --         -91%           -94%         -95%         -97%           -98%
TL::Flex_uni    2383127/s        1025%           --           -35%         -42%         -71%           -81%
TL::Flex_ascii  3684085/s        1639%          55%             --         -10%         -56%           -71%
TL::BVXS_l52    4110496/s        1840%          72%            12%           --         -50%           -68%
TL::BVXS_uni    8303203/s        3819%         248%           125%         102%           --           -36%
TL::BVXS_ascii 12877248/s        5978%         440%           250%         213%          55%             --

2022-03-05 scan ascii first, minimize construction of non-ascii

helmut@mbp:~/github/perl/Text-Levenshtein-BVXS/src$ ./levtest
[dist_asci]     iters: 20 M Elapsed: 0.800581 s Rate: 25.0 (M/sec) 4
[dist_utf8_ucs] iters: 20 M Elapsed: 1.803164 s Rate: 11.1 (M/sec) 4
[dist_uni]      iters: 20 M Elapsed: 1.129935 s Rate: 17.7 (M/sec) 4
[dist_hybrid]   iters: 20 M Elapsed: 0.948622 s Rate: 21.1 (M/sec) 4
Total: 4.682302 seconds

helmut@mbp:~/github/perl/Text-Levenshtein-BVXS$ perl xt/50_distance_bench.t
                     Rate TL::Flex_l52 TL::Flex_uni TL::Flex_ascii TL::BVXS_l52 TL::BVXS_uni TL::BVXS_ascii
TL::Flex_l52     227556/s           --         -91%           -94%         -94%         -97%           -98%
TL::Flex_uni    2502283/s        1000%           --           -33%         -37%         -69%           -82%
TL::Flex_ascii  3747463/s        1547%          50%             --          -6%         -53%           -73%
TL::BVXS_l52    3989148/s        1653%          59%             6%           --         -50%           -71%
TL::BVXS_uni    7989875/s        3411%         219%           113%         100%           --           -43%
TL::BVXS_ascii 13912027/s        6014%         456%           271%         249%          74%             --

helmut@mbp:~/github/perl/Text-Levenshtein-BVXS/src$ ./levtest
[dist_asci]     distance: 4 expect: 4
[dist_utf8_ucs] distance: 4 expect: 4
[dist_uni]      distance: 4 expect: 4
[dist_hybrid]   distance: 4 expect: 4
[dist_asci]     iters: 20 M Elapsed: 0.809687 s Rate: 24.7 (M/sec) 4
[dist_utf8_ucs] iters: 20 M Elapsed: 1.824845 s Rate: 11.0 (M/sec) 4
[dist_uni]      iters: 20 M Elapsed: 1.140782 s Rate: 17.5 (M/sec) 4
[dist_hybrid]   iters: 20 M Elapsed: 0.953847 s Rate: 21.0 (M/sec) 4
Total: 4.729161 seconds

helmut@mbp:~/github/perl/Text-Levenshtein-BVXS/src$ ./levtestcpp
[dist_asci]     distance: 4 expect: 4
[dist_utf8_ucs] distance: 4 expect: 4
[dist_uni]      distance: 4 expect: 4
[dist_hybrid]   distance: 4 expect: 4
[dist_asci]     iters: 20 M Elapsed: 0.793727 s Rate: 25.2 (M/sec) 4
[dist_utf8_ucs] iters: 20 M Elapsed: 1.809635 s Rate: 11.1 (M/sec) 4
[dist_uni]      iters: 20 M Elapsed: 1.168586 s Rate: 17.1 (M/sec) 4
[dist_hybrid]   iters: 20 M Elapsed: 0.948328 s Rate: 21.1 (M/sec) 4
Total: 4.720276 seconds

helmut@mbp:~/github/perl/Text-Levenshtein-BVXS$ perl xt/50_distance_bench.t
                    Rate TL::Flex_l68 TL::Flex_l52 TL::BVXS_l68 TL::BVXS_l52 TL::Flex_uni TL::Flex_ascii TL::BVXS_uni TL::BVXS_ascii
TL::Flex_l68    124842/s           --         -44%         -84%         -95%         -95%           -97%         -98%           -99%
TL::Flex_l52    223417/s          79%           --         -72%         -90%         -91%           -94%         -97%           -97%
TL::BVXS_l68    793688/s         536%         255%           --         -66%         -69%           -79%         -90%           -91%
TL::BVXS_l52   2338582/s        1773%         947%         195%           --          -7%           -37%         -70%           -73%
TL::Flex_uni   2525240/s        1923%        1030%         218%           8%           --           -32%         -67%           -71%
TL::Flex_ascii 3714590/s        2875%        1563%         368%          59%          47%             --         -52%           -58%
TL::BVXS_uni   7699334/s        6067%        3346%         870%         229%         205%           107%           --           -13%
TL::BVXS_ascii 8822153/s        6967%        3849%        1012%         277%         249%           138%          15%             --

helmut@mbp:~/github/perl/Text-Levenshtein-BVXS$ time perl xt/50_distance_bench.t
                     Rate TL::Flex_l68 TL::Flex_l52 TL::BVXS_l68 TL::Flex_uni TL::BVXS_l52 TL::Flex_ascii TL::BVXS_simple TL::BVXS_uni TL::BVXS_ascii
TL::Flex_l68     129153/s           --         -42%         -84%         -94%         -95%           -97%            -98%         -98%           -98%
TL::Flex_l52     222694/s          72%           --         -72%         -90%         -91%           -94%            -96%         -97%           -97%
TL::BVXS_l68     793688/s         515%         256%           --         -64%         -67%           -80%            -85%         -90%           -91%
TL::Flex_uni    2219767/s        1619%         897%         180%           --          -9%           -43%            -58%         -72%           -74%
TL::BVXS_l52    2434193/s        1785%         993%         207%          10%           --           -37%            -54%         -69%           -71%
TL::Flex_ascii  3884984/s        2908%        1645%         389%          75%          60%             --            -27%         -50%           -54%
TL::BVXS_simple 5293291/s        3998%        2277%         567%         138%         117%            36%              --         -32%           -38%
TL::BVXS_uni    7839820/s        5970%        3420%         888%         253%         222%           102%             48%           --            -7%
TL::BVXS_ascii  8469267/s        6458%        3703%         967%         282%         248%           118%             60%           8%             --

helmut@mbp:~/github/perl/Text-Levenshtein-BVXS$ time perl xt/50_distance_bench.t
                     Rate TL::Flex_l68 TL::Flex_l52 TL::BVXS_l68 TL::BVXS_l52 TL::Flex_uni TL::Flex_ascii TL::BVXS_simple TL::BVXS_uni TL::BVXS_ascii
TL::Flex_l68     127999/s           --         -43%         -83%         -94%         -95%           -97%            -98%         -98%           -98%
TL::Flex_l52     225467/s          76%           --         -71%         -90%         -91%           -94%            -96%         -97%           -97%
TL::BVXS_l68     771011/s         502%         242%           --         -66%         -71%           -81%            -85%         -89%           -91%
TL::BVXS_l52    2248784/s        1657%         897%         192%           --         -15%           -43%            -56%         -69%           -72%
TL::Flex_uni    2632788/s        1957%        1068%         241%          17%           --           -33%            -49%         -64%           -68%
TL::Flex_ascii  3957601/s        2992%        1655%         413%          76%          50%             --            -23%         -46%           -51%
TL::BVXS_simple 5144882/s        3919%        2182%         567%         129%          95%            30%              --         -29%           -37%
TL::BVXS_uni    7281777/s        5589%        3130%         844%         224%         177%            84%             42%           --           -11%
TL::BVXS_ascii  8143526/s        6262%        3512%         956%         262%         209%           106%             58%          12%             --
                        Rate TL::BVXS_arr_l68 TL::BVXS_arr_l52 TL::Flex_l68 TL::Flex_l52 TL::BVXS_arr_ascii TL::BVXS_arr_uni TL::Flex_uni TL::Flex_ascii
TL::BVXS_arr_l68     44246/s               --             -58%         -66%         -80%               -96%             -96%         -98%           -99%
TL::BVXS_arr_l52    104261/s             136%               --         -19%         -54%               -91%             -91%         -96%           -97%
TL::Flex_l68        129153/s             192%              24%           --         -43%               -89%             -89%         -95%           -97%
TL::Flex_l52        224877/s             408%             116%          74%           --               -80%             -80%         -91%           -94%
TL::BVXS_arr_ascii 1124391/s            2441%             978%         771%         400%                 --              -0%         -55%           -70%
TL::BVXS_arr_uni   1124392/s            2441%             978%         771%         400%                 0%               --         -55%           -70%
TL::Flex_uni       2502283/s            5555%            2300%        1837%        1013%               123%             123%           --           -33%
TL::Flex_ascii     3714590/s            8295%            3463%        2776%        1552%               230%             230%          48%             --

real	0m35.012s
user	0m34.962s
sys	0m0.043s

helmut@mbp:~/github/perl/Text-Levenshtein-BVXS/src$ ./levtestarr
[dist_array]      distance: 5 expect: 5
[dist_simple_arr] distance: 5 expect: 5
[dist_array]      iters: 20 M Elapsed: 3.224419 s Rate: 6.2 (M/sec) 5
[dist_simple_arr] iters: 20 M Elapsed: 4.897053 s Rate: 4.1 (M/sec) 5

helmut@mbp:~/github/perl/Text-Levenshtein-BVXS/src$ ./levtest
[dist_asci]     distance: 4 expect: 4
[dist_utf8_ucs] distance: 4 expect: 4
[dist_uni]      distance: 4 expect: 4
[dist_hybrid]   distance: 4 expect: 4
strlen(utf_str1_l52): 51
strlen(utf_str2_l52): 51
a_chars_l52: 51
b_chars_l52: 51
[dist_hybrid_l52] distance: 2 expect: 2

strlen(utf_str1_l68): 69
strlen(utf_str2_l68): 69
a_chars_l68: 69
b_chars_l68: 69
[dist_hybrid_l68] distance: 2 expect: 2

[dist_asci]     iters: 20 M Elapsed: 0.773462 s Rate: 25.9 (M/sec) 4
[dist_utf8_ucs] iters: 20 M Elapsed: 1.662071 s Rate: 12.0 (M/sec) 4
[dist_uni]      iters: 20 M Elapsed: 1.087365 s Rate: 18.4 (M/sec) 4
[dist_hybrid]   iters: 20 M Elapsed: 0.905256 s Rate: 22.1 (M/sec) 4 ***
[dist_simple]   iters: 20 M Elapsed: 2.260686 s Rate: 8.8 (M/sec) 4
[dist_hybrid_l52] iters: 1 M Elapsed: 0.229030 s Rate: 4.4 (M/sec) 2 ***
[dist_simple_l52] iters: 1 M Elapsed: 3.083937 s Rate: 0.3 (M/sec) 2
[dist_hybrid_l68] iters: 1 M Elapsed: 1.071402 s Rate: 0.9 (M/sec) 2 ===
[dist_simple_l68] iters: 1 M Elapsed: 5.350672 s Rate: 0.2 (M/sec) 2
Total: 16.423881 seconds

# faster setpos
[dist_asci]     iters: 20 M Elapsed: 0.777691 s Rate: 25.7 (M/sec) 4
[dist_utf8_ucs] iters: 20 M Elapsed: 1.700036 s Rate: 11.8 (M/sec) 4
[dist_uni]      iters: 20 M Elapsed: 1.092066 s Rate: 18.3 (M/sec) 4
[dist_hybrid]   iters: 20 M Elapsed: 0.935848 s Rate: 21.4 (M/sec) 4
[dist_simple]   iters: 20 M Elapsed: 2.326360 s Rate: 8.6 (M/sec) 4
[dist_hybrid_l52] iters: 1 M Elapsed: 0.223211 s Rate: 4.5 (M/sec) 2
[dist_simple_l52] iters: 1 M Elapsed: 3.136501 s Rate: 0.3 (M/sec) 2
[dist_hybrid_l68] iters: 1 M Elapsed: 1.031224 s Rate: 1.0 (M/sec) 2
[dist_simple_l68] iters: 1 M Elapsed: 5.255143 s Rate: 0.2 (M/sec) 2

helmut@mbp:~/github/perl/Text-Levenshtein-BVXS$ perl xt/50_distance_bench.t
                     Rate TL::Flex_l68 TL::Flex_l52 TL::BVXS_l68 TL::BVXS_l52 TL::BVXS_uni TL::BVXS_ascii TL::Flex_uni TL::Flex_ascii TL::BVXS_simple
TL::Flex_l68     129152/s           --         -42%         -84%         -90%         -94%           -95%         -95%           -97%            -97%
TL::Flex_l52     223417/s          73%           --         -72%         -83%         -90%           -91%         -91%           -94%            -96%
TL::BVXS_l68     801547/s         521%         259%           --         -38%         -63%           -66%         -69%           -78%            -84%
TL::BVXS_l52    1291788/s         900%         478%          61%           --         -40%           -45%         -49%           -65%            -75%
TL::BVXS_uni    2138703/s        1556%         857%         167%          66%           --            -9%         -16%           -42%            -58%
TL::BVXS_ascii  2360644/s        1728%         957%         195%          83%          10%             --          -7%           -36%            -54%
TL::Flex_uni    2545086/s        1871%        1039%         218%          97%          19%             8%           --           -31%            -51%
TL::Flex_ascii  3709584/s        2772%        1560%         363%         187%          73%            57%          46%             --            -28%
TL::BVXS_simple 5144882/s        3884%        2203%         542%         298%         141%           118%         102%            39%              --
                        Rate TL::BVXS_arr_l68 TL::BVXS_arr_l52 TL::Flex_l68 TL::Flex_l52 TL::BVXS_arr_ascii TL::BVXS_arr_uni TL::Flex_uni TL::Flex_ascii
TL::BVXS_arr_l68     43442/s               --             -59%         -65%         -81%               -96%             -96%         -98%           -99%
TL::BVXS_arr_l52    106454/s             145%               --         -15%         -52%               -91%             -91%         -96%           -97%
TL::Flex_l68        125754/s             189%              18%           --         -44%               -89%             -89%         -95%           -97%
TL::Flex_l52        223417/s             414%             110%          78%           --               -81%             -81%         -91%           -94%
TL::BVXS_arr_ascii 1151307/s            2550%             982%         816%         415%                 --              -0%         -54%           -68%
TL::BVXS_arr_uni   1151308/s            2550%             982%         816%         415%                 0%               --         -54%           -68%
TL::Flex_uni       2502283/s            5660%            2251%        1890%        1020%               117%             117%           --           -31%
TL::Flex_ascii     3640889/s            8281%            3320%        2795%        1530%               216%             216%          46%             --

# with ascii
helmut@mbp:~/github/perl/Text-Levenshtein-BVXS$ perl xt/50_distance_bench.t
                      Rate TL::Flex_l68 TL::Flex_l52 TL::BVXS_l68 TL::Flex_uni TL::BVXS_l52 TL::Flex_ascii TL::BVXS_simple TL::BVXS_uni TL::BVXS_ascii
TL::Flex_l68      127999/s           --         -43%         -82%         -95%         -97%           -97%            -98%         -98%           -99%
TL::Flex_l52      225467/s          76%           --         -69%         -91%         -94%           -94%            -96%         -97%           -98%
TL::BVXS_l68      721308/s         464%         220%           --         -71%         -81%           -82%            -87%         -90%           -94%
TL::Flex_uni     2473056/s        1832%         997%         243%           --         -35%           -37%            -55%         -67%           -79%
TL::BVXS_l52     3814985/s        2880%        1592%         429%          54%           --            -3%            -31%         -50%           -68%
TL::Flex_ascii   3920956/s        2963%        1639%         444%          59%           3%             --            -29%         -48%           -67%
TL::BVXS_simple  5553898/s        4239%        2363%         670%         125%          46%            42%              --         -27%           -54%
TL::BVXS_uni     7561845/s        5808%        3254%         948%         206%          98%            93%             36%           --           -37%
TL::BVXS_ascii  11993516/s        9270%        5219%        1563%         385%         214%           206%            116%          59%             --
                        Rate TL::BVXS_arr_l68 TL::BVXS_arr_l52 TL::Flex_l68 TL::Flex_l52 TL::BVXS_arr_uni TL::BVXS_arr_ascii TL::Flex_uni TL::Flex_ascii
TL::BVXS_arr_l68     37397/s               --             -63%         -71%         -83%             -97%               -97%         -99%           -99%
TL::BVXS_arr_l52    102399/s             174%               --         -21%         -54%             -91%               -91%         -96%           -97%
TL::Flex_l68        129153/s             245%              26%           --         -42%             -89%               -89%         -95%           -96%
TL::Flex_l52        221405/s             492%             116%          71%           --             -80%               -81%         -91%           -94%
TL::BVXS_arr_uni   1124391/s            2907%             998%         771%         408%               --                -6%         -56%           -69%
TL::BVXS_arr_ascii 1194347/s            3094%            1066%         825%         439%               6%                 --         -53%           -68%
TL::Flex_uni       2536172/s            6682%            2377%        1864%        1045%             126%               112%           --           -31%
TL::Flex_ascii     3682290/s            9746%            3496%        2751%        1563%             227%               208%          45%             --

[dist_bytes]      iters: 20 M Elapsed: 0.794973 s Rate: 25.2 (M/sec) elRate 276.7 4
[dist_utf8_ucs]   iters: 20 M Elapsed: 1.637388 s Rate: 12.2 (M/sec) elRate 134.4 4
[dist_hybrid]     iters: 20 M Elapsed: 0.896534 s Rate: 22.3 (M/sec) elRate 245.4 4
[dist_simple]     iters: 20 M Elapsed: 2.299277 s Rate:  8.7 (M/sec) elRate  95.7 4
[dist_hybrid_l52] iters:  1 M Elapsed: 0.217549 s Rate:  4.6 (M/sec) elRate 234.4 2
[dist_simple_l52] iters:  1 M Elapsed: 2.755184 s Rate:  0.4 (M/sec) elRate  18.5 2
[dist_hybrid_l68] iters:  1 M Elapsed: 1.040587 s Rate:  1.0 (M/sec) elRate  66.3 2
[dist_simple_l68] iters:  1 M Elapsed: 4.985688 s Rate:  0.2 (M/sec) elRate  13.8 2

# with faster utf-8 decode ~ +13%

helmut@mbp:~/github/perl/Text-Levenshtein-BVXS$ perl xt/50_distance_bench.t
                      Rate TL::Flex_l68 TL::Flex_l52 TL::BVXS_l68 TL::Flex_uni TL::Flex_ascii TL::BVXS_l52 TL::BVXS_simple TL::BVXS_uni TL::BVXS_ascii
TL::Flex_l68      127242/s           --         -43%         -87%         -95%           -97%         -97%            -98%         -99%           -99%
TL::Flex_l52      222695/s          75%           --         -78%         -91%           -94%         -95%            -96%         -97%           -98%
TL::BVXS_l68      998734/s         685%         348%           --         -59%           -73%         -76%            -84%         -88%           -92%
TL::Flex_uni     2429401/s        1809%         991%         143%           --           -34%         -42%            -60%         -71%           -81%
TL::Flex_ascii   3670015/s        2784%        1548%         267%          51%             --         -12%            -39%         -57%           -71%
TL::BVXS_l52     4170472/s        3178%        1773%         318%          72%            14%           --            -31%         -51%           -67%
TL::BVXS_simple  6056132/s        4660%        2619%         506%         149%            65%          45%              --         -29%           -52%
TL::BVXS_uni     8495407/s        6577%        3715%         751%         250%           131%         104%             40%           --           -33%
TL::BVXS_ascii  12743110/s        9915%        5622%        1176%         425%           247%         206%            110%          50%             --
                        Rate TL::BVXS_arr_l68 TL::BVXS_arr_l52 TL::Flex_l68 TL::Flex_l52 TL::BVXS_arr_ascii TL::BVXS_arr_uni TL::Flex_uni TL::Flex_ascii
TL::BVXS_arr_l68     35544/s               --             -65%         -72%         -84%               -97%             -97%         -99%           -99%
TL::BVXS_arr_l52    102399/s             188%               --         -19%         -54%               -91%             -91%         -96%           -97%
TL::Flex_l68        126867/s             257%              24%           --         -42%               -89%             -89%         -95%           -97%
TL::Flex_l52        220553/s             521%             115%          74%           --               -80%             -81%         -91%           -94%
TL::BVXS_arr_ascii 1113476/s            3033%             987%         778%         405%                 --              -2%         -55%           -70%
TL::BVXS_arr_uni   1135524/s            3095%            1009%         795%         415%                 2%               --         -54%           -69%
TL::Flex_uni       2453219/s            6802%            2296%        1834%        1012%               120%             116%           --           -33%
TL::Flex_ascii     3674915/s           10239%            3489%        2797%        1566%               230%             224%          50%             --

[dist_bytes]      iters: 20 M Elapsed: 0.775099 s Rate: 25.8 (M/sec) elRate 283.8 4
[dist_utf8_ucs]   iters: 20 M Elapsed: 1.373599 s Rate: 14.6 (M/sec) elRate 160.2 4
[dist_hybrid]     iters: 20 M Elapsed: 0.902721 s Rate: 22.2 (M/sec) elRate 243.7 4
[dist_simple]     iters: 20 M Elapsed: 2.262337 s Rate:  8.8 (M/sec) elRate  97.2 4
[dist_hybrid_l52] iters:  1 M Elapsed: 0.231926 s Rate:  4.3 (M/sec) elRate 219.9 2
[dist_simple_l52] iters:  1 M Elapsed: 2.805825 s Rate:  0.4 (M/sec) elRate  18.2 2
[dist_hybrid_l68] iters:  1 M Elapsed: 1.076955 s Rate:  0.9 (M/sec) elRate  64.1 2
[dist_simple_l68] iters:  1 M Elapsed: 5.153448 s Rate:  0.2 (M/sec) elRate  13.4 2
Total: 14.581910 seconds
