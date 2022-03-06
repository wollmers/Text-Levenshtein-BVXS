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
       'TL::BVXS_uni' => sub {
            Text::Levenshtein::BVXS::distance(@strings_uni)
        },
       'TL::BVXS_l52' => sub {
            Text::Levenshtein::BVXS::distance(@strings2)
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


