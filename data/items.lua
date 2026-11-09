-- The item logic's data for Dark Souls III 1.15.2 (areas, bosses, connections, item locations);
-- the grammar is in its header. logic.lua reads it.
return [==[
# Kindle randomizer data: Dark Souls III 1.15.2 (base game and both DLCs).
# Built by Kindle from the game's own files (map files, event and talk scripts, params) and
# checked against play. Ids only; names come from the game at runtime.
#
# area <id> [start] [dlc1|dlc2]           dlc1 Ashes of Ariandel, dlc2 The Ringed City
# boss <id> <area> <defeat flag> [needs <req>]
# flag <id> <area> needs <req>              a state the logic tracks (not an item)
# edge <from> <to> <req>
# goal <req>
# loc <lot|shop>:<id> <area> <items> [needs <req>] [shop] [missable] from=<source> [group=<id>]
#   source: map (pickups), boss (rewards), drop (one-time enemy drops), npc (NPC gifts and
#   drops), event (scripted rewards), handmaid (her shop), npcshop (other shops)
#   group: locations the game gives only one of (they share the flag that marks them taken or
#   sold: an event picking one lot of several, an NPC's drop and gift, the rows of an item an
#   NPC and the Handmaid both sell), all holding what the first gets; the id is that flag
#
# <req>: terms joined by " & " (all of), alternatives by " | " (any of; binds looser);
# a term is free, boss:<id>, flag:<id>, or an item: w:<id> weapon, a:<id> armor, r:<id> ring,
# g:<id> goods. <items>: comma-separated items, each with an optional x<count>.
# Locations tagged missable (NPC gifts and drops, scripted events, NPC shops) never get an
# item the logic needs.

area cemetery start
area firelink
area high_wall
area undead_settlement
area road_of_sacrifices
area cathedral
area farron_keep
area catacombs
area smouldering_lake
area irithyll
area anor_londo
area irithyll_dungeon
area profaned_capital
area archdragon_peak
area lothric_castle
area consumed_garden
area untended_graves
area grand_archives
area kiln
area painted_world dlc1
area dreg_heap dlc2
area ringed_city dlc2
area filianores_rest dlc2

boss iudex_gundyr cemetery 14000800
boss vordt high_wall 13000800
boss dancer high_wall 13000890 needs g:2117 | boss:abyss_watchers & boss:aldrich & boss:yhorm
boss greatwood undead_settlement 13100800
boss crystal_sage road_of_sacrifices 13300850
boss deacons cathedral 13500800
boss abyss_watchers farron_keep 13300800
boss wolnir catacombs 13800800
boss old_demon_king smouldering_lake 13800830
boss pontiff irithyll 13700850
boss aldrich anor_londo 13700800
boss yhorm profaned_capital 13900800 needs w:6370000
boss ancient_wyvern archdragon_peak 13200800
boss nameless_king archdragon_peak 13200850
boss dragonslayer_armour lothric_castle 13010800
boss oceiros consumed_garden 13000830
boss champion_gundyr untended_graves 14000830
boss twin_princes grand_archives 13410830
boss friede painted_world 14500800 needs g:2155
boss gravetender painted_world 14500860
boss demon_prince dreg_heap 15000800
boss halflight ringed_city 15100800
boss midir ringed_city 15100850
boss gael filianores_rest 15110800
boss soul_of_cinder kiln 14100800

flag path_of_the_dragon consumed_garden needs boss:oceiros

edge cemetery firelink boss:iudex_gundyr
edge firelink high_wall g:2137
edge high_wall undead_settlement g:2102
edge undead_settlement road_of_sacrifices free
edge road_of_sacrifices cathedral boss:crystal_sage
edge road_of_sacrifices farron_keep free
edge farron_keep catacombs boss:abyss_watchers
edge catacombs smouldering_lake free
edge catacombs irithyll boss:wolnir & g:2005
edge irithyll anor_londo boss:pontiff
edge irithyll irithyll_dungeon free
edge irithyll_dungeon profaned_capital free
edge irithyll_dungeon archdragon_peak flag:path_of_the_dragon
edge high_wall lothric_castle boss:dancer
edge lothric_castle consumed_garden free
edge consumed_garden untended_graves boss:oceiros
edge lothric_castle grand_archives boss:dragonslayer_armour & g:2014
edge firelink kiln g:2123 & g:2124 & g:2125 & g:2126
edge cathedral painted_world free
edge painted_world dreg_heap boss:friede
edge kiln dreg_heap free
edge dreg_heap ringed_city boss:demon_prince & g:2156
edge ringed_city filianores_rest boss:halflight

goal boss:soul_of_cinder

loc lot:3000000 consumed_garden g:2141 from=map
loc lot:3000010 high_wall g:260x2 from=map
loc lot:3000020 high_wall g:331x2 from=map
loc lot:3000030 high_wall g:402 from=map
loc lot:3000040 high_wall g:401 from=map
loc lot:3000060 high_wall w:14060000 from=map
loc lot:3000070 high_wall g:292x3 from=map
loc lot:3000090 high_wall g:310x8 from=map
loc lot:3000110 high_wall g:401 from=map
loc lot:3000120 high_wall w:8000000 from=map
loc lot:3000130 high_wall w:6020000 from=map
loc lot:3000140 high_wall g:500 from=map
loc lot:3000150 high_wall g:292x2 from=map
loc lot:3000160 high_wall g:1000 from=map
loc lot:3000170 high_wall g:296x2 from=map
loc lot:3000180 high_wall g:292x3 from=map
loc lot:3000210 high_wall g:2010 from=map
loc lot:3000230 high_wall g:500 from=map
loc lot:3000240 high_wall g:401 from=map
loc lot:3000250 high_wall w:10010000 from=map
loc lot:3000270 high_wall w:3010000 from=map
loc lot:3000280 high_wall g:1000 from=map
loc lot:3000290 high_wall w:3020000 from=map
loc lot:3000300 high_wall g:1000 from=map
loc lot:3000310 high_wall g:402 from=map
loc lot:3000320 high_wall g:297x3 from=map
loc lot:3000340 high_wall g:401 from=map
loc lot:3000360 high_wall g:500 from=map
loc lot:3000370 high_wall g:402 from=map
loc lot:3000380 high_wall g:371 from=map
loc lot:3000390 high_wall r:20210 from=map
loc lot:3000400 high_wall g:310x6 from=map
loc lot:3000410 high_wall g:401 from=map
loc lot:3000420 high_wall g:260x3 from=map
loc lot:3000430 consumed_garden a:81000000 from=map
loc lot:3000440 high_wall w:2020000 from=map
loc lot:3000450 high_wall g:401 from=map
loc lot:3000470 consumed_garden g:297x2 from=map
loc lot:3000480 consumed_garden w:11000000 from=map
loc lot:3000490 consumed_garden g:1002 from=map
loc lot:3000500 consumed_garden r:20830 from=map
loc lot:3000510 consumed_garden g:334 from=map
loc lot:3000520 high_wall g:1002 from=map
loc lot:3000530 consumed_garden g:1002 from=map
loc lot:3000540 high_wall g:407 from=map
loc lot:3000550 consumed_garden g:1190 from=map
loc lot:3000570 high_wall g:1020 from=map
loc lot:3000580 high_wall g:292x3 from=map
loc lot:3000610 high_wall g:401 from=map
loc lot:3000620 consumed_garden g:334x2 from=map
loc lot:3000630 consumed_garden g:1002 from=map
loc lot:3000640 consumed_garden r:20210 from=map
loc lot:3000800 consumed_garden g:1020 needs boss:oceiros from=map
loc lot:3000820 high_wall w:21240000 from=map
loc lot:3000830 high_wall w:2200000 from=map
loc lot:3000840 consumed_garden g:1020 needs boss:oceiros from=map
loc lot:51200 high_wall r:20180 from=npc missable group=50006120
loc lot:21205000 high_wall a:78500000 from=drop
loc lot:52300 high_wall g:2102 from=drop group=50006232
loc lot:3010000 lothric_castle w:14170000 from=map
loc lot:3010010 lothric_castle g:1020 from=map
loc lot:3010020 lothric_castle g:1002 from=map
loc lot:3010030 lothric_castle w:9080000 from=map
loc lot:3010040 lothric_castle g:1002 from=map
loc lot:3010050 lothric_castle g:1002 from=map
loc lot:3010060 lothric_castle w:20280000 from=map
loc lot:3010070 lothric_castle g:1002x2 from=map
loc lot:3010080 lothric_castle g:1120 from=map
loc lot:3010090 lothric_castle g:409 from=map
loc lot:3010100 lothric_castle g:2143 from=map
loc lot:3010110 lothric_castle g:300x3 from=map
loc lot:3010120 lothric_castle g:1002 from=map
loc lot:3010130 lothric_castle g:1002 from=map
loc lot:3010140 lothric_castle g:1002 from=map
loc lot:3010150 lothric_castle w:13240000 from=map
loc lot:3010160 lothric_castle g:300x6 from=map
loc lot:3010170 lothric_castle g:500 from=map
loc lot:3010180 lothric_castle g:1220 from=map
loc lot:3010190 lothric_castle g:297x3 from=map
loc lot:3010200 lothric_castle g:336 from=map
loc lot:3010210 lothric_castle g:408 from=map
loc lot:3010220 lothric_castle g:375 from=map
loc lot:3010230 lothric_castle g:409 from=map
loc lot:3010240 lothric_castle g:1002 from=map
loc lot:3010250 lothric_castle g:1020 from=map
loc lot:3010260 lothric_castle g:406 from=map
loc lot:3010270 lothric_castle r:20460 from=map
loc lot:3010280 lothric_castle g:500 from=map
loc lot:3010290 lothric_castle g:408 from=map
loc lot:3010300 lothric_castle g:500 from=map
loc lot:3010310 lothric_castle g:1030 from=map
loc lot:3010320 lothric_castle g:406 from=map
loc lot:3010330 lothric_castle g:500 from=map
loc lot:3010340 lothric_castle a:49000000 from=map
loc lot:3010350 lothric_castle g:455x2 from=map
loc lot:3010360 lothric_castle g:1003 from=map
loc lot:3010370 lothric_castle g:2120 from=map
loc lot:3010380 lothric_castle r:20170 from=map
loc lot:3010400 lothric_castle g:1030x2 from=map
loc lot:3010420 lothric_castle g:406 from=map
loc lot:3010500 lothric_castle g:1020x3 from=map
loc lot:3010520 lothric_castle g:1020 from=map
loc lot:3010530 lothric_castle a:61500000 from=map
loc lot:3010600 lothric_castle w:21260000 from=map
loc lot:3010610 lothric_castle g:1020 from=map
loc lot:3010620 lothric_castle g:1030 from=map
loc lot:3010640 lothric_castle g:1030x2 from=map
loc lot:21201100 lothric_castle a:78500000 from=drop
loc lot:21201000 lothric_castle a:78500000 from=drop
loc lot:3300580 undead_settlement g:3550000 from=map
loc lot:3300840 undead_settlement w:21180000 from=map
loc lot:3100700 undead_settlement g:2118 from=map
loc lot:3100710 undead_settlement a:24000000 from=map
loc lot:3100720 undead_settlement w:9030000 from=map
loc lot:3100730 undead_settlement r:20050 from=map
loc lot:3100740 undead_settlement w:20201401 from=map
loc lot:3100750 undead_settlement w:20010000 from=map
loc lot:3100760 undead_settlement g:373 from=map
loc lot:3100770 undead_settlement g:402 from=map
loc lot:3100800 undead_settlement g:290x9 from=map
loc lot:3100950 undead_settlement g:350 from=map missable
loc lot:3100000 undead_settlement r:20540 from=map
loc lot:3100010 undead_settlement g:2143 from=map
loc lot:3100020 undead_settlement g:294x2 from=map
loc lot:3100030 undead_settlement g:2107 from=map
loc lot:3100040 undead_settlement g:350x2 from=map
loc lot:3100050 undead_settlement w:20190000 from=map
loc lot:3100060 undead_settlement g:500 from=map
loc lot:3100070 undead_settlement g:403 from=map
loc lot:3100080 undead_settlement g:280x2 from=map
loc lot:3100090 undead_settlement g:350x2 from=map
loc lot:3100100 undead_settlement w:12060000 from=map missable
loc lot:3100110 undead_settlement g:1000 from=map
loc lot:3100120 undead_settlement w:21290000 from=map
loc lot:3100130 undead_settlement g:402 from=map
loc lot:3100140 undead_settlement g:500 from=map
loc lot:3100150 undead_settlement g:402 from=map
loc lot:3100160 undead_settlement g:1000 from=map
loc lot:3100170 undead_settlement g:294x2 from=map
loc lot:3100180 undead_settlement g:340x2 from=map
loc lot:3100190 undead_settlement w:21230000 from=map
loc lot:3100200 undead_settlement g:403 from=map
loc lot:3100210 undead_settlement g:330x2 from=map
loc lot:3100220 undead_settlement a:76503000 from=map
loc lot:3100230 undead_settlement g:340x2 from=map
loc lot:3100240 undead_settlement g:403 from=map
loc lot:3100250 undead_settlement g:1000 from=map
loc lot:3100260 undead_settlement w:10140000 from=map
loc lot:3100270 undead_settlement g:455x2 from=map
loc lot:3100280 undead_settlement w:11010000 from=map
loc lot:3100300 undead_settlement w:13290000 from=map
loc lot:3100310 undead_settlement g:294x3 from=map
loc lot:3100320 undead_settlement w:8060000 from=map
loc lot:3100330 undead_settlement g:1000 from=map
loc lot:3100340 undead_settlement g:1000 from=map
loc lot:3100350 undead_settlement g:400 from=map
loc lot:3100360 undead_settlement g:1000 from=map
loc lot:3100370 undead_settlement w:7000000 from=map
loc lot:3100380 undead_settlement g:403 from=map
loc lot:3100390 undead_settlement g:500 from=map
loc lot:3100400 undead_settlement a:86001000 from=map
loc lot:3100410 undead_settlement w:20210000 from=map
loc lot:3100420 undead_settlement g:459x2 from=map
loc lot:3100430 undead_settlement r:20010 from=map
loc lot:3100440 undead_settlement r:20510 from=map
loc lot:3100450 undead_settlement g:2141 from=map
loc lot:3100460 undead_settlement g:292x6 from=map
loc lot:3100490 undead_settlement w:12000000 from=map
loc lot:3100500 undead_settlement w:10000000 from=map
loc lot:3100540 undead_settlement g:350x2 from=map
loc lot:3100550 undead_settlement g:402 from=map
loc lot:3100570 undead_settlement g:500 from=map
loc lot:3100610 undead_settlement g:402 from=map
loc lot:3100620 undead_settlement g:400 from=map
loc lot:3100630 undead_settlement g:454 from=map
loc lot:3100640 undead_settlement g:500 from=map
loc lot:3100650 undead_settlement g:402 from=map
loc lot:3100660 undead_settlement g:454 from=map
loc lot:3100670 undead_settlement w:8030000 from=map
loc lot:3100680 undead_settlement g:405 from=map
loc lot:3100910 undead_settlement g:334x4 from=map
loc lot:51700 undead_settlement w:8290000 from=npc missable
loc lot:52100 undead_settlement a:74000000 from=npc missable group=50006217
loc lot:53100 undead_settlement g:350 from=npc missable group=50006311
loc lot:50800 undead_settlement w:13280000 from=npc missable
loc lot:51600 undead_settlement g:2015 from=npc missable
loc lot:51400 undead_settlement w:13400000 from=npc missable group=50006140
loc lot:3200380 archdragon_peak r:20040 from=map
loc lot:3200330 archdragon_peak g:1030x2 from=map
loc lot:3200340 archdragon_peak g:1030x2 from=map
loc lot:3200350 archdragon_peak g:1003 from=map
loc lot:3200360 archdragon_peak g:3561000 from=map
loc lot:3200370 archdragon_peak g:1003 from=map
loc lot:3200000 archdragon_peak r:20500 from=map
loc lot:3200010 archdragon_peak g:303x6 from=map
loc lot:3200020 archdragon_peak g:1002 from=map
loc lot:3200030 archdragon_peak g:1020 from=map
loc lot:3200040 archdragon_peak g:407 from=map
loc lot:3200050 archdragon_peak g:1002 from=map
loc lot:3200060 archdragon_peak g:1170 from=map
loc lot:3200070 archdragon_peak g:350x2 from=map
loc lot:3200080 archdragon_peak g:405 from=map
loc lot:3200090 archdragon_peak g:1002 from=map
loc lot:3200100 archdragon_peak g:500 from=map
loc lot:3200110 archdragon_peak g:408 from=map
loc lot:3200120 archdragon_peak g:406 from=map
loc lot:3200130 archdragon_peak g:300x4 from=map
loc lot:3200140 archdragon_peak w:404400x12 from=map
loc lot:3200150 archdragon_peak g:1002x2 from=map
loc lot:3200160 archdragon_peak g:293x3 from=map
loc lot:3200170 archdragon_peak g:1020 from=map
loc lot:3200180 archdragon_peak g:407 from=map
loc lot:3200190 archdragon_peak g:409 from=map
loc lot:3200200 archdragon_peak g:1002 from=map
loc lot:3200210 archdragon_peak g:500 from=map
loc lot:3200220 archdragon_peak r:20060 from=map
loc lot:3200230 archdragon_peak g:1020 from=map
loc lot:3200240 archdragon_peak g:500 from=map
loc lot:3200260 archdragon_peak w:20290000 from=map
loc lot:3200270 archdragon_peak g:410 from=map
loc lot:3200280 archdragon_peak g:2151 from=map
loc lot:3200290 archdragon_peak g:500 from=map
loc lot:3200700 archdragon_peak g:1020x3 from=map
loc lot:3200710 archdragon_peak g:1030x3 from=map
loc lot:57100 archdragon_peak w:8260000 from=drop
loc lot:3300940 farron_keep a:98001000 from=map
loc lot:3300000 road_of_sacrifices g:1000 from=map
loc lot:3300010 road_of_sacrifices g:1000 from=map
loc lot:3300020 road_of_sacrifices g:260x4 from=map
loc lot:3300030 road_of_sacrifices g:2141 from=map
loc lot:3300040 road_of_sacrifices r:20210 from=map
loc lot:3300050 road_of_sacrifices g:403 from=map
loc lot:3300060 road_of_sacrifices a:19000000 from=map
loc lot:3300070 road_of_sacrifices w:13170000 from=map
loc lot:3300080 farron_keep g:404 from=map
loc lot:3300090 farron_keep a:77500000 from=map
loc lot:3300100 road_of_sacrifices g:403 from=map
loc lot:3300110 road_of_sacrifices g:260x2 from=map
loc lot:3300120 farron_keep g:2127 from=map
loc lot:3300130 farron_keep g:350x2 from=map
loc lot:3300140 road_of_sacrifices g:1000 from=map
loc lot:3300150 farron_keep g:271x2 from=map
loc lot:3300160 farron_keep g:271x4 from=map
loc lot:3300170 farron_keep w:6050000 from=map
loc lot:3300180 road_of_sacrifices w:22100000 from=map
loc lot:3300190 farron_keep g:1240 from=map
loc lot:3300210 road_of_sacrifices g:400 from=map
loc lot:3300220 road_of_sacrifices a:30000000 from=map
loc lot:3300230 road_of_sacrifices r:20280 from=map
loc lot:3300240 farron_keep g:271x3 from=map
loc lot:3300270 farron_keep g:2143 from=map
loc lot:3300280 farron_keep g:3780000 from=map
loc lot:3300290 farron_keep g:1000 from=map
loc lot:3300300 farron_keep g:2430000 from=map
loc lot:3300310 road_of_sacrifices w:21200000 from=map
loc lot:3300320 farron_keep w:21250000 from=map
loc lot:3300340 farron_keep g:343x2 from=map
loc lot:3300350 farron_keep g:1000 from=map
loc lot:3300360 farron_keep g:457 from=map
loc lot:3300370 farron_keep a:71000000 from=map
loc lot:3300380 farron_keep g:1250 from=map
loc lot:3300390 farron_keep g:280x4 from=map
loc lot:3300400 farron_keep g:2140 from=map
loc lot:3300410 farron_keep g:2132 from=map
loc lot:3300420 farron_keep g:2108 from=map
loc lot:3300430 farron_keep g:1000 from=map
loc lot:3300440 farron_keep g:366 from=map
loc lot:3300450 farron_keep g:1311000 from=map
loc lot:3300460 farron_keep g:500 from=map
loc lot:3300470 farron_keep g:1000x2 from=map
loc lot:3300480 farron_keep g:1000 from=map
loc lot:3300490 farron_keep g:1000 from=map
loc lot:3300500 farron_keep g:461x3 from=map
loc lot:3300510 farron_keep g:343x4 from=map
loc lot:3300520 farron_keep g:1200 from=map
loc lot:3300530 farron_keep g:2141 from=map
loc lot:3300540 farron_keep g:1000 from=map
loc lot:3300550 farron_keep g:370x10 from=map
loc lot:3300560 road_of_sacrifices g:500 from=map
loc lot:3300570 farron_keep g:2104 from=map
loc lot:3300590 road_of_sacrifices g:458x2 from=map
loc lot:3300600 road_of_sacrifices g:403 from=map
loc lot:3300610 road_of_sacrifices g:1250 from=map
loc lot:3300620 road_of_sacrifices g:1000 from=map
loc lot:3300630 road_of_sacrifices w:16060000 from=map
loc lot:3300640 road_of_sacrifices g:2119 from=map
loc lot:3300650 road_of_sacrifices g:500 from=map
loc lot:3300680 farron_keep g:341x6 from=map
loc lot:3300690 farron_keep g:500 from=map
loc lot:3300700 farron_keep g:405 from=map
loc lot:3300710 farron_keep g:404 from=map
loc lot:3300720 farron_keep w:16000000 from=map
loc lot:3300730 farron_keep w:20270000 from=map
loc lot:3300740 road_of_sacrifices a:22000000 from=map
loc lot:3300750 road_of_sacrifices w:7020000 from=map
loc lot:3300760 road_of_sacrifices a:75500000 from=map
loc lot:3300770 road_of_sacrifices r:20250 from=map
loc lot:3300780 farron_keep a:21500000 from=map
loc lot:3300790 farron_keep g:2103 from=map
loc lot:3300800 farron_keep a:75000000 from=map missable
loc lot:3300810 farron_keep w:7050000 from=map
loc lot:3300820 farron_keep g:500 from=map
loc lot:3300830 farron_keep g:500 from=map
loc lot:3300525 farron_keep a:76500000 from=map
loc lot:3300535 farron_keep g:350x2 from=map
loc lot:3300545 farron_keep g:406 from=map
loc lot:3300555 farron_keep g:406 from=map
loc lot:57600 farron_keep w:6150000 from=npc missable
loc lot:57700 farron_keep w:8080000 from=npc missable
loc lot:58800 road_of_sacrifices w:7070000 from=npc missable
loc lot:51300 road_of_sacrifices g:2112 from=npc missable
loc lot:52600 road_of_sacrifices r:10070 from=npc missable
loc lot:51900 road_of_sacrifices w:2230000 from=npc missable group=50006030
loc lot:57000 lothric_castle g:2014 needs boss:dragonslayer_armour & boss:abyss_watchers & boss:aldrich & boss:yhorm from=map
loc lot:3410600 grand_archives g:1620000 from=map
loc lot:3410610 grand_archives r:20150 from=map
loc lot:3410620 grand_archives g:2143 from=map
loc lot:3410000 grand_archives g:1002 from=map
loc lot:3410010 grand_archives g:1002 from=map
loc lot:3410020 grand_archives g:409 from=map
loc lot:3410030 grand_archives g:1002 from=map
loc lot:3410040 grand_archives r:20130 from=map
loc lot:3410060 grand_archives g:409 from=map
loc lot:3410070 grand_archives g:405 from=map
loc lot:3410080 grand_archives w:13250000 from=map
loc lot:3410090 grand_archives g:1020 from=map
loc lot:3410100 grand_archives g:2141 from=map
loc lot:3410110 grand_archives g:350x3 from=map
loc lot:3410120 grand_archives g:1020 from=map
loc lot:3410130 grand_archives g:1002 from=map
loc lot:3410140 grand_archives g:1240 from=map
loc lot:3410150 grand_archives g:1020 from=map
loc lot:3410160 grand_archives g:1020 from=map
loc lot:3410180 grand_archives g:1020 from=map
loc lot:3410200 grand_archives g:1250 from=map
loc lot:3410210 grand_archives g:410 from=map
loc lot:3410220 grand_archives g:1002 from=map
loc lot:3410240 grand_archives g:1020x3 from=map
loc lot:3410250 grand_archives g:1002 from=map
loc lot:3410260 grand_archives g:407 from=map
loc lot:3410280 grand_archives g:1002 from=map
loc lot:3410290 grand_archives g:500 from=map
loc lot:3410300 grand_archives g:1230 from=map
loc lot:3410320 grand_archives g:1002x2 from=map
loc lot:3410330 grand_archives g:410 from=map
loc lot:3410350 grand_archives w:14090000 from=map
loc lot:3410360 grand_archives g:1002 from=map
loc lot:3410370 grand_archives r:20470 from=map
loc lot:3410380 grand_archives g:3720000 from=map
loc lot:3410410 grand_archives g:1002 from=map
loc lot:3410420 grand_archives g:2440000 from=map
loc lot:3410500 grand_archives g:240 from=map
loc lot:3410510 grand_archives g:1030x3 from=map
loc lot:3410520 grand_archives w:12040000 from=map
loc lot:3410530 grand_archives g:1003 from=map
loc lot:3410540 grand_archives g:1020x3 from=map
loc lot:58000 grand_archives w:21220000 from=npc missable
loc lot:58100 grand_archives w:13160000 from=npc missable
loc lot:57010 grand_archives w:16090000 from=npc missable
loc lot:3500950 cathedral a:66000000 needs boss:deacons from=map
loc lot:3500000 cathedral w:12050000 from=map
loc lot:3500010 cathedral g:1000 from=map
loc lot:3500020 cathedral w:6070000 from=map
loc lot:3500030 cathedral w:2220000 from=map
loc lot:3500040 cathedral g:2143 from=map
loc lot:3500050 cathedral w:22120000 from=map
loc lot:3500060 cathedral g:1000 from=map
loc lot:3500070 cathedral g:404 from=map
loc lot:3500080 cathedral g:2109 from=map
loc lot:3500090 cathedral w:14050000 from=map
loc lot:3500110 cathedral g:500 from=map
loc lot:3500130 cathedral g:500 from=map
loc lot:3500140 cathedral r:20110 from=map
loc lot:3500150 cathedral a:89001000 from=map
loc lot:3500160 cathedral g:500 from=map
loc lot:3500170 cathedral g:304x3 from=map
loc lot:3500180 cathedral g:3540000 from=map
loc lot:3500200 cathedral g:2141 from=map
loc lot:3500210 cathedral a:79500000 from=map
loc lot:3500220 cathedral g:373 from=map
loc lot:3500230 cathedral g:400 from=map
loc lot:3500240 cathedral g:1230 from=map
loc lot:3500260 cathedral g:459 from=map
loc lot:3500270 cathedral g:405 from=map
loc lot:3500280 cathedral g:304 from=map
loc lot:3500300 cathedral g:404 from=map
loc lot:3500310 cathedral g:500 from=map
loc lot:3500320 cathedral g:280x3 from=map
loc lot:3500330 cathedral g:404 from=map
loc lot:3500340 cathedral g:404 from=map
loc lot:3500370 cathedral g:296x3 from=map
loc lot:3500380 cathedral g:459x3 from=map
loc lot:3500390 cathedral g:1000 from=map
loc lot:3500400 cathedral g:1000 from=map
loc lot:3500420 cathedral g:455x2 from=map
loc lot:3500430 cathedral w:16130000 from=map
loc lot:3500450 cathedral a:89003000 from=map
loc lot:3500460 cathedral g:404 from=map
loc lot:3500470 cathedral g:373 from=map
loc lot:3500480 cathedral a:89002000 from=map
loc lot:3500490 cathedral g:405 from=map
loc lot:3500500 cathedral a:96000000 from=map missable
loc lot:3500540 cathedral w:404600x6 from=map
loc lot:3500550 cathedral r:20660 from=map
loc lot:3500560 cathedral g:405 from=map
loc lot:3500620 cathedral g:350x2 from=map
loc lot:3500630 cathedral g:1180 from=map
loc lot:3500680 cathedral g:1000 from=map
loc lot:3500690 cathedral g:404 from=map
loc lot:52000 cathedral w:9010000 from=npc missable group=50006202
loc lot:52010 cathedral r:20720 from=npc missable group=50006202
loc lot:50900 cathedral g:111x5 from=npc missable group=50006090
loc lot:57300 cathedral w:21190000 from=npc missable
loc lot:51910 cathedral w:2230000 from=npc missable group=50006030
loc lot:21200000 cathedral a:78500000 from=drop
loc lot:3700000 irithyll a:79000000 from=map missable
loc lot:3700010 irithyll g:350 from=map
loc lot:3700020 irithyll g:406 from=map
loc lot:3700030 irithyll g:1001 from=map
loc lot:3700040 irithyll g:407 from=map
loc lot:3700050 irithyll g:407 from=map
loc lot:3700060 irithyll g:276 from=map
loc lot:3700070 irithyll w:13190000 from=map
loc lot:3700080 irithyll g:1001 from=map
loc lot:3700090 anor_londo g:2141 from=map
loc lot:3700100 irithyll g:261 from=map
loc lot:3700110 irithyll g:276x2 from=map
loc lot:3700120 irithyll g:1001 from=map
loc lot:3700130 irithyll g:1001 from=map
loc lot:3700140 irithyll r:20251 from=map
loc lot:3700150 irithyll g:406 from=map
loc lot:3700160 irithyll g:1001 from=map
loc lot:3700170 irithyll g:1001 from=map
loc lot:3700180 irithyll g:407 from=map
loc lot:3700190 irithyll r:20490 from=map
loc lot:3700200 irithyll g:400 from=map
loc lot:3700210 irithyll g:400 from=map
loc lot:3700220 irithyll w:4090000 from=map
loc lot:3700230 irithyll g:350x3 from=map
loc lot:3700240 irithyll g:2143 from=map
loc lot:3700250 irithyll g:290x8 from=map
loc lot:3700260 irithyll g:457 from=map
loc lot:3700270 anor_londo a:84000000 from=map
loc lot:3700280 irithyll g:458x2 from=map
loc lot:3700290 irithyll g:1250 from=map
loc lot:3700300 irithyll g:367 from=map
loc lot:3700310 irithyll g:108 from=map
loc lot:3700320 irithyll g:1210 from=map
loc lot:3700330 irithyll g:260x3 from=map
loc lot:3700340 irithyll r:20210 from=map
loc lot:3700350 irithyll g:3502000 from=map
loc lot:3700360 irithyll g:406 from=map
loc lot:3700370 irithyll g:260x3 from=map
loc lot:3700380 irithyll g:293x3 from=map
loc lot:3700390 irithyll g:293x3 from=map
loc lot:3700400 irithyll g:2146 from=map
loc lot:3700410 anor_londo g:500 from=map
loc lot:3700420 irithyll g:1001 from=map
loc lot:3700430 irithyll g:406 from=map
loc lot:3700440 irithyll g:407 from=map
loc lot:3700450 irithyll g:1001 from=map
loc lot:3700460 irithyll g:458x2 from=map
loc lot:3700470 irithyll g:500 from=map
loc lot:3700480 irithyll g:1001 from=map
loc lot:3700490 irithyll g:1001 from=map
loc lot:3700500 irithyll g:407 from=map
loc lot:3700510 irithyll g:500 from=map
loc lot:3700520 irithyll g:500 from=map
loc lot:3700530 irithyll g:1001 from=map
loc lot:3700540 irithyll r:20080 from=map
loc lot:3700550 irithyll g:1001 from=map
loc lot:3700560 irithyll g:260 from=map
loc lot:3700600 irithyll g:1180 from=map
loc lot:3700610 irithyll g:1020 from=map
loc lot:3700620 anor_londo w:13600000 from=map
loc lot:3700630 anor_londo g:2152 from=map
loc lot:3700640 irithyll a:91000000 from=map
loc lot:3700660 anor_londo g:409 from=map
loc lot:3700670 irithyll g:1170 from=map
loc lot:3700690 anor_londo w:400500x6 from=map
loc lot:3700700 anor_londo g:372 from=map
loc lot:3700720 irithyll g:406 from=map
loc lot:3700740 irithyll g:407 from=map
loc lot:3700750 irithyll g:372 from=map
loc lot:3700760 irithyll g:457 from=map
loc lot:3700770 anor_londo g:408 from=map
loc lot:3700800 anor_londo g:2105 from=map
loc lot:3700900 irithyll g:240 from=map
loc lot:3700920 irithyll w:8270000 from=map
loc lot:3700940 anor_londo r:20740 from=map
loc lot:3700950 irithyll w:9190000 from=map
loc lot:3700960 irithyll r:20200 from=map
loc lot:58300 irithyll w:16100000 from=npc missable
loc lot:21204000 irithyll a:78500000 from=drop
loc lot:53010 anor_londo g:2139 from=drop group=50006301
loc lot:53000 irithyll g:1355000 from=drop
loc lot:3800900 catacombs g:2143 from=map
loc lot:3800910 catacombs g:1190 from=map
loc lot:3800000 catacombs g:335x2 from=map
loc lot:3800010 catacombs g:1110 from=map
loc lot:3800020 catacombs g:405 from=map
loc lot:3800030 catacombs g:1000x2 from=map
loc lot:3800040 catacombs g:270x3 from=map
loc lot:3800050 catacombs r:20450 from=map
loc lot:3800060 catacombs g:500 from=map
loc lot:3800070 catacombs g:335x3 from=map
loc lot:3800080 catacombs g:500 from=map
loc lot:3800090 catacombs r:20730 from=map
loc lot:3800100 catacombs g:1000x2 from=map
loc lot:3800110 catacombs g:1000x2 from=map
loc lot:3800120 catacombs g:500 from=map
loc lot:3800130 catacombs g:2128 from=map
loc lot:3800140 catacombs g:1001 from=map
loc lot:3800150 catacombs g:1001 from=map
loc lot:3800160 catacombs g:460x3 from=map
loc lot:3800170 catacombs g:406 from=map
loc lot:3800180 catacombs g:461x2 from=map
loc lot:3800190 catacombs g:2110 from=map
loc lot:3800200 smouldering_lake g:1001 from=map
loc lot:3800210 catacombs g:1001 from=map
loc lot:3800220 catacombs g:1001 from=map
loc lot:3800230 smouldering_lake g:1001 from=map
loc lot:3800240 smouldering_lake g:1001 from=map
loc lot:3800250 smouldering_lake g:1001 from=map
loc lot:3800260 catacombs g:460x2 from=map
loc lot:3800270 catacombs g:1001 from=map
loc lot:3800280 catacombs g:1001 from=map
loc lot:3800290 smouldering_lake g:1001 from=map
loc lot:3800300 smouldering_lake r:20090 from=map
loc lot:3800310 smouldering_lake g:350x2 from=map
loc lot:3800330 smouldering_lake g:500 from=map
loc lot:3800340 smouldering_lake g:1160 from=map
loc lot:3800350 smouldering_lake g:500 from=map
loc lot:3800360 smouldering_lake g:2129 from=map
loc lot:3800370 smouldering_lake w:6250000 from=map
loc lot:3800380 catacombs g:406 from=map
loc lot:3800390 catacombs a:26500000 from=map
loc lot:3800400 smouldering_lake g:500 from=map
loc lot:3800410 smouldering_lake g:2130 from=map
loc lot:3800420 smouldering_lake w:13200000 from=map
loc lot:3800430 smouldering_lake w:13300000 from=map
loc lot:3800440 smouldering_lake g:2421000 from=map
loc lot:3800450 smouldering_lake g:2143 from=map
loc lot:3800460 smouldering_lake g:1020 from=map
loc lot:3800470 catacombs g:405 from=map
loc lot:3800500 smouldering_lake g:2131 from=map group=53800500
loc lot:3800510 catacombs g:2131 needs boss:wolnir from=map group=53800500
loc lot:3800520 smouldering_lake w:21280000 from=map
loc lot:3800530 smouldering_lake g:409 from=map
loc lot:3800540 smouldering_lake g:500 from=map
loc lot:3800560 smouldering_lake g:2640000 from=map
loc lot:3800570 catacombs g:404 from=map
loc lot:3800580 smouldering_lake w:14070000 from=map
loc lot:3800590 smouldering_lake g:2141 from=map
loc lot:3800760 smouldering_lake g:1001x3 from=map
loc lot:58410 smouldering_lake r:20480 from=npc missable
loc lot:21202000 catacombs a:78500000 from=drop
loc lot:4600 profaned_capital w:6370000 from=map
loc lot:3900000 irithyll_dungeon g:1001 from=map
loc lot:3900010 irithyll_dungeon g:400 from=map
loc lot:3900030 irithyll_dungeon g:406 from=map
loc lot:3900040 irithyll_dungeon g:2007 from=map
loc lot:3900050 irithyll_dungeon g:336x2 from=map
loc lot:3900060 irithyll_dungeon g:1140 from=map
loc lot:3900070 irithyll_dungeon g:406 from=map
loc lot:3900080 irithyll_dungeon g:1001 from=map
loc lot:3900090 profaned_capital g:350x2 from=map
loc lot:3900100 irithyll_dungeon r:20231 needs g:2007 from=map
loc lot:3900110 irithyll_dungeon g:407 from=map
loc lot:3900120 irithyll_dungeon g:409 from=map
loc lot:3900130 irithyll_dungeon a:80000000 needs g:2008 from=map missable
loc lot:3900140 irithyll_dungeon w:404400x9 from=map
loc lot:3900150 irithyll_dungeon g:1001 from=map
loc lot:3900160 irithyll_dungeon g:2455000 from=map
loc lot:3900180 irithyll_dungeon g:1001 from=map
loc lot:3900190 irithyll_dungeon g:407 from=map
loc lot:3900200 irithyll_dungeon g:293x4 from=map
loc lot:3900210 profaned_capital g:274x3 from=map
loc lot:3900220 irithyll_dungeon g:500 from=map
loc lot:3900230 irithyll_dungeon g:500 from=map
loc lot:3900240 irithyll_dungeon g:2106 from=map
loc lot:3900250 irithyll_dungeon g:1001 from=map
loc lot:3900260 irithyll_dungeon a:77000000 needs g:2008 from=map
loc lot:3900270 profaned_capital g:408 from=map
loc lot:3900280 profaned_capital g:455x2 from=map
loc lot:3900290 profaned_capital g:457 from=map
loc lot:3900300 profaned_capital g:274 from=map
loc lot:3900310 profaned_capital r:20120 from=map
loc lot:3900320 profaned_capital g:1200 from=map
loc lot:3900330 profaned_capital g:1250 from=map
loc lot:3900340 profaned_capital w:400200x18 from=map
loc lot:3900350 profaned_capital g:380 from=map
loc lot:3900360 profaned_capital w:402300x8 from=map
loc lot:3900370 profaned_capital g:408 from=map
loc lot:3900380 profaned_capital g:455 from=map
loc lot:3900390 profaned_capital g:455 from=map
loc lot:3900400 irithyll_dungeon r:20390 needs g:2012 from=map
loc lot:3900410 profaned_capital g:272x3 from=map
loc lot:3900420 profaned_capital g:3531000 from=map
loc lot:3900430 irithyll_dungeon g:3590000 from=map
loc lot:3900440 irithyll_dungeon g:1001 from=map
loc lot:3900450 irithyll_dungeon g:455 from=map
loc lot:3900460 irithyll_dungeon r:20300 from=map
loc lot:3900470 irithyll_dungeon w:8250000 from=map
loc lot:3900480 irithyll_dungeon g:2148 from=map
loc lot:3900490 profaned_capital w:14140000 from=map
loc lot:3900500 irithyll_dungeon g:457 needs g:2008 from=map
loc lot:3900510 irithyll_dungeon g:1001 needs g:2007 from=map
loc lot:3900520 irithyll_dungeon g:2008 from=map
loc lot:3900750 irithyll_dungeon g:378 from=map
loc lot:3900800 profaned_capital a:29000000 from=map
loc lot:3900810 profaned_capital w:6370000 from=map
loc lot:3900820 irithyll_dungeon g:2147 needs g:2008 from=map
loc lot:3900590 profaned_capital g:500 from=map
loc lot:3900610 irithyll_dungeon g:2012 from=map
loc lot:51500 irithyll_dungeon a:99000000 from=npc missable
loc lot:58200 profaned_capital g:2133 from=npc missable
loc lot:52110 irithyll_dungeon a:74000000 from=npc missable group=50006217
loc lot:21203000 profaned_capital a:78500000 from=drop
loc lot:21203100 irithyll_dungeon a:78500000 from=drop
loc lot:21203030 profaned_capital a:78500000 from=drop
loc lot:21203010 irithyll_dungeon a:78500000 from=drop
loc lot:21203020 profaned_capital a:78500000 from=drop
loc lot:21203040 profaned_capital a:78500000 from=drop
loc lot:21203050 irithyll_dungeon a:78500000 from=drop
loc lot:4000010 cemetery w:2030000 from=map
loc lot:4000020 untended_graves g:401 from=map
loc lot:4000030 cemetery g:292x5 from=map
loc lot:4000050 cemetery g:1000 from=map
loc lot:4000060 firelink g:350 from=map
loc lot:4000070 firelink g:500 from=map
loc lot:4000080 firelink g:401 from=map
loc lot:4000090 firelink w:21150000 from=map
loc lot:4000100 firelink g:350 from=map
loc lot:4000110 untended_graves g:403 from=map
loc lot:4000120 firelink g:500 from=map
loc lot:4000140 firelink a:25500000 from=map missable
loc lot:4000160 firelink g:350x3 needs g:2013 from=map
loc lot:4000170 firelink r:20700 needs g:2013 from=map
loc lot:4000180 firelink g:2141 needs g:2013 from=map
loc lot:4000190 firelink g:390 needs g:2013 from=map
loc lot:4000200 untended_graves g:1250 from=map
loc lot:4000220 untended_graves g:1002 from=map
loc lot:4000230 untended_graves g:409 from=map
loc lot:4000240 untended_graves g:1002 from=map
loc lot:4000250 untended_graves r:20710 from=map
loc lot:4000260 untended_graves w:10150000 from=map
loc lot:4000270 untended_graves g:241 from=map
loc lot:4000280 untended_graves g:2138 from=map
loc lot:4000290 untended_graves g:409 from=map
loc lot:4000300 untended_graves w:8280000 from=map
loc lot:4000310 untended_graves w:5020000 from=map
loc lot:4000320 untended_graves g:2149 from=map missable
loc lot:4000330 untended_graves r:20380 from=map
loc lot:4000340 untended_graves g:351 from=map
loc lot:4000350 firelink a:68001000 needs g:2013 from=map
loc lot:4000700 firelink r:20400 needs g:2013 from=map
loc lot:57200 firelink w:5000000 from=npc missable
loc lot:50400 firelink w:5050000 from=npc missable
loc lot:50700 firelink g:1100 from=npc missable group=50006070
loc lot:50300 firelink r:20430 from=drop
loc lot:51100 firelink r:20160 from=drop
loc lot:4500000 painted_world g:276x2 from=map
loc lot:4500010 painted_world g:1200 from=map
loc lot:4500020 painted_world g:404 from=map
loc lot:4500030 painted_world w:9230000 from=map
loc lot:4500040 painted_world g:404 from=map
loc lot:4500050 painted_world g:350x6 from=map
loc lot:4500060 painted_world g:1230 from=map
loc lot:4500070 painted_world g:2154 from=map
loc lot:4500080 painted_world g:297x2 from=map
loc lot:4500090 painted_world g:1250 from=map
loc lot:4500100 painted_world w:14180000 from=map
loc lot:4500110 painted_world g:404 from=map
loc lot:4500120 painted_world g:455 from=map
loc lot:4500130 painted_world g:1001 from=map
loc lot:4500140 painted_world g:404 from=map
loc lot:4500150 painted_world w:16150000 from=map
loc lot:4500160 painted_world g:1140 from=map
loc lot:4500170 painted_world g:404 from=map
loc lot:4500180 painted_world a:55500000 from=map
loc lot:4500190 painted_world g:500 from=map
loc lot:4500200 painted_world g:1190 from=map
loc lot:4500220 painted_world g:404 from=map
loc lot:4500230 painted_world g:404 from=map
loc lot:4500240 painted_world g:457x3 from=map
loc lot:4500250 painted_world g:409 from=map
loc lot:4500260 painted_world g:3556000 from=map
loc lot:4500270 painted_world g:455x2 from=map
loc lot:4500280 painted_world g:454 from=map
loc lot:4500290 painted_world g:261x3 from=map
loc lot:4500300 painted_world w:11050000 from=map
loc lot:4500310 painted_world g:370x10 from=map
loc lot:4500320 painted_world g:1002 from=map
loc lot:4500330 painted_world g:1002 from=map
loc lot:4500340 painted_world w:20300000 from=map
loc lot:4500350 painted_world g:1001x2 needs g:2155 from=map
loc lot:4500360 painted_world w:8310000 needs g:2155 from=map
loc lot:4500370 painted_world g:500 from=map
loc lot:4500380 painted_world g:1001x2 from=map
loc lot:4500390 painted_world g:409 needs g:2155 from=map
loc lot:4500400 painted_world g:409 from=map
loc lot:4500410 painted_world g:410 from=map
loc lot:4500420 painted_world w:7180000 from=map
loc lot:4500430 painted_world w:23010000 from=map
loc lot:4500460 painted_world g:293x2 needs g:2155 from=map
loc lot:4500470 painted_world a:20000000 needs g:2155 from=map
loc lot:4500480 painted_world g:1210 needs g:2155 from=map
loc lot:4500490 painted_world g:1240 needs g:2155 from=map
loc lot:4500530 painted_world g:276x4 from=map
loc lot:4500540 painted_world w:4120000 needs g:2155 from=map
loc lot:4500550 painted_world g:500 needs g:2155 from=map
loc lot:4500560 painted_world g:1741000 needs g:2155 from=map
loc lot:4500570 painted_world w:13410000 from=map
loc lot:4500600 painted_world g:276 from=map
loc lot:4500610 painted_world g:404 from=map
loc lot:4500620 painted_world g:500 from=map
loc lot:4500630 painted_world g:1313000 from=map
loc lot:4500640 painted_world g:1003 needs g:2155 from=map
loc lot:4500650 painted_world g:350x2 needs g:2155 from=map
loc lot:4500660 painted_world g:404 from=map
loc lot:4500670 painted_world g:408 from=map
loc lot:4500680 painted_world g:404 from=map
loc lot:4500690 painted_world g:1100 from=map
loc lot:4500800 painted_world g:408 from=map
loc lot:4500810 painted_world w:7170000 from=map
loc lot:4500820 painted_world w:21300000 from=map
loc lot:4500830 painted_world g:407 from=map
loc lot:5000000 dreg_heap g:500 from=map
loc lot:5000010 dreg_heap g:407 from=map
loc lot:5000020 dreg_heap g:1002 from=map
loc lot:5000030 dreg_heap w:1140000 from=map
loc lot:5000040 dreg_heap g:1030 from=map
loc lot:5000050 dreg_heap w:1150000 from=map
loc lot:5000060 dreg_heap g:240 from=map
loc lot:5000070 dreg_heap r:20043 from=map
loc lot:5000080 dreg_heap g:409 from=map
loc lot:5000090 dreg_heap g:455x2 from=map
loc lot:5000100 dreg_heap g:1002 from=map
loc lot:5000110 dreg_heap w:13420000 from=map
loc lot:5000120 dreg_heap g:500 from=map
loc lot:5000130 dreg_heap g:1604000 from=map
loc lot:5000140 dreg_heap r:20403 from=map
loc lot:5000150 dreg_heap g:400 from=map
loc lot:5000160 dreg_heap g:1002 from=map
loc lot:5000170 dreg_heap g:350x3 from=map
loc lot:5000180 dreg_heap g:400 from=map
loc lot:5000190 dreg_heap g:300x4 from=map
loc lot:5000200 dreg_heap g:3557000 from=map
loc lot:5000210 dreg_heap g:408 from=map
loc lot:5000220 dreg_heap w:9250000 from=map
loc lot:5000230 dreg_heap g:1020 from=map
loc lot:5000300 dreg_heap g:297x4 from=map
loc lot:5000310 dreg_heap g:1002 from=map
loc lot:5000320 dreg_heap g:1030 from=map
loc lot:5000330 dreg_heap a:81501000 from=map
loc lot:5000340 dreg_heap g:1002x2 from=map
loc lot:5000350 dreg_heap w:16120000 from=map
loc lot:5000360 dreg_heap g:500 from=map
loc lot:5000370 dreg_heap a:81500000 from=map
loc lot:5000380 dreg_heap a:81502000 from=map
loc lot:5000390 dreg_heap a:81503000 from=map
loc lot:5000400 dreg_heap g:1020 from=map
loc lot:5000410 dreg_heap g:271x4 from=map
loc lot:5000420 dreg_heap r:20033 from=map
loc lot:5000430 dreg_heap g:1002 from=map
loc lot:5000440 dreg_heap g:408 from=map
loc lot:5000450 dreg_heap g:1003 from=map
loc lot:5000460 dreg_heap g:1002 from=map
loc lot:5000470 dreg_heap a:28503000 from=map
loc lot:5000480 dreg_heap g:1002 from=map
loc lot:5000490 dreg_heap g:408 from=map
loc lot:5000500 dreg_heap w:6380000 from=map
loc lot:5000510 dreg_heap g:350 from=map
loc lot:5000520 dreg_heap g:370x6 from=map
loc lot:5000530 dreg_heap a:81500000 from=map
loc lot:5000540 dreg_heap g:1030 from=map
loc lot:5000550 dreg_heap g:240 from=map
loc lot:5000560 dreg_heap g:500 from=map
loc lot:5000600 dreg_heap g:2156 from=map
loc lot:59500 dreg_heap g:2458000 from=npc missable
loc lot:56200 dreg_heap g:2153 from=npc missable
loc lot:56210 dreg_heap g:456 from=npc missable group=50006620
loc lot:56250 dreg_heap g:1003 from=npc missable group=50006621
loc lot:56600 dreg_heap g:2157 from=drop
loc lot:62400000 dreg_heap g:1030x2 from=drop
loc lot:62400010 dreg_heap g:1030x2 from=drop
loc lot:62400020 dreg_heap g:1030x2 from=drop
loc lot:5100000 ringed_city g:1020 from=map missable
loc lot:5100010 ringed_city a:80500000 from=map
loc lot:5100020 ringed_city g:261x2 from=map
loc lot:5100030 ringed_city g:1002x2 from=map
loc lot:5100040 ringed_city g:500 from=map
loc lot:5100050 ringed_city g:261x2 from=map
loc lot:5100060 ringed_city g:241 from=map
loc lot:5100070 ringed_city g:409 from=map
loc lot:5100080 ringed_city g:408 from=map
loc lot:5100090 ringed_city g:400x2 from=map
loc lot:5100100 ringed_city g:409 from=map
loc lot:5100110 ringed_city g:500 from=map
loc lot:5100120 ringed_city g:274x2 from=map
loc lot:5100130 ringed_city g:400 from=map
loc lot:5100140 ringed_city g:400 from=map
loc lot:5100150 ringed_city g:1240 from=map
loc lot:5100160 ringed_city g:1002 from=map
loc lot:5100170 ringed_city g:1030 from=map
loc lot:5100180 ringed_city g:1250 from=map
loc lot:5100190 ringed_city a:29500000 from=map
loc lot:5100200 ringed_city g:452x2 from=map
loc lot:5100210 ringed_city g:400 from=map
loc lot:5100220 ringed_city g:410 from=map
loc lot:5100230 ringed_city w:9240000 from=map
loc lot:5100240 ringed_city g:400 from=map
loc lot:5100250 ringed_city a:82500000 from=map
loc lot:5100260 ringed_city w:20310000 from=map
loc lot:5100270 ringed_city g:1002 from=map
loc lot:5100280 ringed_city g:452x2 from=map
loc lot:5100290 ringed_city g:410 from=map
loc lot:5100300 ringed_city r:20393 from=map
loc lot:5100310 ringed_city g:400 from=map
loc lot:5100320 ringed_city g:400 from=map
loc lot:5100330 ringed_city g:1002x2 from=map
loc lot:5100340 ringed_city g:400 from=map
loc lot:5100350 ringed_city g:1190 from=map
loc lot:5100360 ringed_city g:370x4 from=map
loc lot:5100370 ringed_city w:2250000 from=map
loc lot:5100380 ringed_city r:20023 from=map
loc lot:5100390 ringed_city g:1002 from=map
loc lot:5100400 ringed_city g:1030 from=map
loc lot:5100410 ringed_city g:400 from=map
loc lot:5100420 ringed_city g:407 from=map
loc lot:5100430 ringed_city w:13440000 from=map
loc lot:5100440 ringed_city g:380 from=map
loc lot:5100450 ringed_city g:1002 from=map
loc lot:5100460 ringed_city a:83500000 from=map
loc lot:5100470 ringed_city g:315 from=map
loc lot:5100480 ringed_city g:1030 from=map
loc lot:5100490 ringed_city g:400 from=map
loc lot:5100500 ringed_city g:400x2 from=map
loc lot:5100510 ringed_city g:409 from=map
loc lot:5100520 ringed_city a:68500000 from=map
loc lot:5100530 ringed_city g:400 from=map
loc lot:5100540 ringed_city g:1020 from=map
loc lot:5100550 ringed_city g:1020 from=map
loc lot:5100560 ringed_city w:21310000 from=map
loc lot:5100570 ringed_city g:1020x2 from=map
loc lot:5100580 ringed_city g:380 from=map
loc lot:5100590 ringed_city g:408 from=map
loc lot:5100600 ringed_city g:1020x2 from=map
loc lot:5100610 ringed_city g:1020 from=map
loc lot:5100620 ringed_city g:1170 from=map
loc lot:5100630 ringed_city g:1230 from=map
loc lot:5100640 ringed_city g:1140 from=map
loc lot:5100650 ringed_city g:408 from=map
loc lot:5100660 ringed_city g:3509000 from=map
loc lot:5100670 ringed_city r:20013 from=map
loc lot:5100680 ringed_city g:500 from=map
loc lot:5100690 ringed_city g:379 from=map
loc lot:5100700 ringed_city a:28501000 from=map
loc lot:5100710 ringed_city g:407 from=map
loc lot:5100720 ringed_city g:400 from=map
loc lot:5100730 ringed_city g:400 from=map
loc lot:5100740 ringed_city g:400 from=map
loc lot:5100750 ringed_city g:1030x2 from=map
loc lot:5100760 ringed_city g:650 from=map
loc lot:5100770 ringed_city g:261x3 from=map
loc lot:5100780 ringed_city g:400 from=map
loc lot:5100790 ringed_city g:400 from=map
loc lot:5100800 ringed_city g:1002 from=map
loc lot:5100810 ringed_city g:408 from=map
loc lot:5100820 ringed_city g:400 from=map
loc lot:5100830 ringed_city g:407 from=map
loc lot:5100840 ringed_city g:400 from=map
loc lot:5100850 ringed_city g:1020 from=map
loc lot:5100860 ringed_city g:409 from=map
loc lot:5100870 ringed_city w:14120000 from=map
loc lot:5100880 ringed_city g:1002 from=map
loc lot:5100890 ringed_city g:400 from=map
loc lot:5100900 ringed_city g:454 from=map
loc lot:5100910 ringed_city g:454 from=map
loc lot:5100920 ringed_city g:454 from=map
loc lot:56240 ringed_city g:456 from=npc missable group=50006622
loc lot:56220 ringed_city g:456 from=npc missable group=50006622
loc lot:56230 ringed_city g:456 from=npc missable group=50006622
loc lot:56300 ringed_city w:13430000 from=npc missable group=50006630
loc lot:21206000 ringed_city a:78500000 from=drop
loc lot:31600000 ringed_city a:67500000 from=drop
loc lot:56310 filianores_rest w:13430000 from=npc missable group=50006630
loc lot:2000 high_wall g:719 needs boss:vordt from=boss
loc lot:2010 high_wall g:714 needs boss:dancer from=boss
loc lot:2020 consumed_garden g:718 needs boss:oceiros from=boss
loc lot:2030 lothric_castle g:721 needs boss:dragonslayer_armour from=boss
loc lot:2040 grand_archives g:2126 needs boss:twin_princes from=boss
loc lot:2060 undead_settlement g:727 needs boss:greatwood from=boss
loc lot:2070 archdragon_peak g:377 needs boss:ancient_wyvern from=boss
loc lot:2080 archdragon_peak g:722 needs boss:nameless_king from=boss
loc lot:2090 road_of_sacrifices g:715 needs boss:crystal_sage from=boss
loc lot:2100 farron_keep g:2123 needs boss:abyss_watchers from=boss
loc lot:2110 cathedral g:2005 needs boss:deacons from=boss
loc lot:2120 irithyll g:724 needs boss:pontiff from=boss
loc lot:2130 anor_londo g:2124 needs boss:aldrich from=boss
loc lot:2140 catacombs g:726 needs boss:wolnir from=boss
loc lot:2150 smouldering_lake g:720 needs boss:old_demon_king from=boss
loc lot:2170 profaned_capital g:2125 needs boss:yhorm from=boss
loc lot:2180 cemetery g:2137 needs boss:iudex_gundyr from=boss
loc lot:2190 untended_graves g:712 needs boss:champion_gundyr from=boss
loc lot:2300 painted_world g:744 needs boss:friede from=boss
loc lot:2310 painted_world g:2153 needs boss:gravetender from=boss
loc lot:2330 dreg_heap g:746 needs boss:demon_prince from=boss
loc lot:2340 ringed_city g:1003 needs boss:halflight from=boss
loc lot:2350 ringed_city g:747 needs boss:midir from=boss
loc lot:2360 filianores_rest g:745 needs boss:gael from=boss
loc lot:60940 high_wall g:102 from=event missable
loc lot:31410000 high_wall g:1001 from=event missable
loc lot:62320 high_wall g:2117 from=event missable
loc lot:31411000 lothric_castle g:1002x2 from=event missable
loc lot:31411100 lothric_castle g:1002x2 from=event missable
loc lot:4530 undead_settlement g:374 from=event missable
loc lot:4210 undead_settlement r:10050 from=event missable
loc lot:3200900 archdragon_peak g:388 from=event missable
loc lot:3200910 archdragon_peak r:20600 from=event missable
loc lot:60710 road_of_sacrifices g:388 from=event missable
loc lot:12902200 grand_archives g:1003 from=event missable
loc lot:21800110 cathedral g:101 from=event missable
loc lot:60930 irithyll g:728 from=event missable
loc lot:4550 irithyll g:500 from=event missable
loc lot:22501010 irithyll r:20030 from=event missable
loc lot:61930 irithyll g:490x3 from=event missable
loc lot:63010 irithyll g:2139 from=event missable group=50006301
loc lot:3900900 irithyll_dungeon g:2143 from=event missable
loc lot:4000505 firelink g:191 from=event missable group=6600
loc lot:4000515 firelink g:193 from=event missable group=6600
loc lot:4000525 firelink g:195 from=event missable group=6600
loc lot:4000535 firelink g:197 from=event missable group=6600
loc lot:4000545 firelink g:199 from=event missable group=6600
loc lot:4000555 firelink g:201 from=event missable group=6600
loc lot:4000565 firelink g:203 from=event missable group=6600
loc lot:4000575 firelink g:205 from=event missable group=6600
loc lot:4000585 firelink g:207 from=event missable group=6600
loc lot:4000595 firelink g:209 from=event missable group=6600
loc lot:4000605 firelink g:211 from=event missable group=6600
loc lot:4000 firelink g:440 from=event missable
loc lot:4020 firelink g:119 from=event missable
loc lot:60200 firelink g:2138 from=event missable
loc lot:59200 painted_world g:2457000 from=event missable
loc lot:60300010 painted_world g:1001x3 from=event missable
loc lot:60300020 painted_world g:1001x3 from=event missable
loc lot:61300010 painted_world g:1130 from=event missable
loc lot:4700 painted_world g:1003 from=event missable
loc lot:55200 painted_world g:2155 from=event missable
loc shop:200000 cathedral w:1020000 from=npcshop shop missable
loc shop:200001 cathedral w:4010000 from=npcshop shop missable group=73501000
loc shop:200002 cathedral w:9010000 from=npcshop shop missable
loc shop:200003 cathedral a:78001000 from=npcshop shop missable
loc shop:200004 cathedral a:78002000 from=npcshop shop missable
loc shop:200005 cathedral a:78003000 from=npcshop shop missable
loc shop:200006 cathedral a:74000000 from=npcshop shop missable
loc shop:200007 cathedral a:74001000 from=npcshop shop missable
loc shop:200008 cathedral a:74002000 from=npcshop shop missable
loc shop:200009 cathedral a:74003000 from=npcshop shop missable
loc shop:200010 cathedral w:21140000 from=npcshop shop missable group=73501050
loc shop:200011 cathedral g:294 from=npcshop shop missable
loc shop:200012 cathedral g:297 from=npcshop shop missable
loc shop:200013 cathedral g:302 from=npcshop shop missable
loc shop:200014 cathedral g:334 from=npcshop shop missable
loc shop:200015 cathedral g:380 from=npcshop shop missable
loc shop:200016 cathedral g:455 from=npcshop shop missable
loc shop:200017 cathedral g:459 from=npcshop shop missable
loc shop:200018 cathedral w:400200 from=npcshop shop missable
loc shop:200100 cathedral g:500 from=npcshop shop missable group=73501060
loc shop:200200 cathedral g:241 from=npcshop shop missable group=73501070
loc shop:200300 cathedral r:20720 from=npcshop shop missable group=73501080
loc shop:40000 firelink w:11040000 from=npcshop shop missable group=73101050
loc shop:40001 firelink g:2145 from=npcshop shop missable group=73101060
loc shop:40002 firelink r:20210 from=npcshop shop missable group=73101070
loc shop:40003 firelink r:20440 from=npcshop shop missable group=73101080
loc shop:40004 firelink r:20560 from=npcshop shop missable group=73101090
loc shop:40005 firelink g:274 from=npcshop shop missable
loc shop:40006 firelink g:311 from=npcshop shop missable
loc shop:50000 firelink g:1300000 from=npcshop shop missable group=73101000
loc shop:50001 firelink g:1302000 from=npcshop shop missable group=73101010
loc shop:50002 firelink g:1310000 from=npcshop shop missable group=73101020
loc shop:50003 firelink g:1330000 from=npcshop shop missable group=73101030
loc shop:50100 firelink g:1374000 from=npcshop shop missable group=73101040
loc shop:110000 firelink w:1000000 from=handmaid shop
loc shop:110001 firelink w:2000000 from=handmaid shop
loc shop:110003 firelink w:4030000 from=handmaid shop
loc shop:110004 firelink w:10030000 from=handmaid shop
loc shop:110005 firelink w:13050000 from=handmaid shop
loc shop:110006 firelink w:13060000 from=handmaid shop
loc shop:110007 firelink w:20040000 from=handmaid shop
loc shop:110008 firelink w:20180000 from=handmaid shop
loc shop:110009 firelink w:20220000 from=handmaid shop
loc shop:110011 firelink w:20230000 from=handmaid shop
loc shop:110012 firelink w:23000000 from=handmaid shop
loc shop:110013 firelink a:70000000 from=handmaid shop
loc shop:110014 firelink a:70001000 from=handmaid shop
loc shop:110015 firelink a:70002000 from=handmaid shop
loc shop:110016 firelink a:70003000 from=handmaid shop
loc shop:110017 firelink g:271 from=handmaid shop missable
loc shop:110018 firelink g:280 from=handmaid shop missable
loc shop:110019 firelink g:292 from=handmaid shop missable
loc shop:110020 firelink g:350 from=handmaid shop
loc shop:110021 firelink g:370 from=handmaid shop
loc shop:110022 firelink g:100 from=handmaid shop group=6800
loc shop:110023 firelink g:385 from=handmaid shop group=6820
loc shop:110024 firelink g:500 from=handmaid shop
loc shop:110025 firelink g:2013 from=handmaid shop group=74001020
loc shop:110026 firelink g:1200000 from=handmaid shop
loc shop:110027 firelink g:1300000 from=handmaid shop
loc shop:110028 firelink g:3490000 from=handmaid shop
loc shop:110029 firelink w:400600 from=handmaid shop
loc shop:110030 firelink w:404300 from=handmaid shop
loc shop:110050 firelink g:294 from=handmaid shop missable
loc shop:110051 firelink g:330 from=handmaid shop missable
loc shop:110052 firelink g:334 from=handmaid shop missable
loc shop:110053 firelink g:340 from=handmaid shop missable
loc shop:110054 firelink g:500 from=handmaid shop missable
loc shop:110055 firelink g:2009 from=handmaid shop missable
loc shop:110100 firelink w:14020000 from=handmaid shop missable
loc shop:110101 firelink a:76001000 from=handmaid shop missable
loc shop:110102 firelink a:76002000 from=handmaid shop missable
loc shop:110103 firelink a:76003000 from=handmaid shop missable
loc shop:110104 firelink r:20000 from=handmaid shop missable
loc shop:110105 firelink g:260 from=handmaid shop missable
loc shop:110106 firelink g:331 from=handmaid shop missable
loc shop:110107 firelink g:341 from=handmaid shop missable
loc shop:110108 firelink g:343 from=handmaid shop missable
loc shop:110109 firelink g:461 from=handmaid shop missable
loc shop:110110 firelink w:400400 from=handmaid shop missable
loc shop:110111 firelink g:1000 from=handmaid shop missable
loc shop:110150 firelink w:8020000 from=handmaid shop missable
loc shop:110151 firelink w:7040000 from=handmaid shop missable
loc shop:110152 firelink w:13270000 from=handmaid shop missable
loc shop:110153 firelink r:20670 from=handmaid shop missable
loc shop:110154 firelink g:271 from=handmaid shop missable
loc shop:110155 firelink g:272 from=handmaid shop missable
loc shop:110156 firelink g:296 from=handmaid shop missable
loc shop:110157 firelink g:304 from=handmaid shop missable
loc shop:110200 firelink g:290 from=handmaid shop missable
loc shop:110201 firelink g:335 from=handmaid shop missable
loc shop:110202 firelink g:460 from=handmaid shop missable
loc shop:110203 firelink g:500 from=handmaid shop missable
loc shop:110204 firelink g:1000 from=handmaid shop missable
loc shop:110250 firelink g:272 from=handmaid shop missable
loc shop:110251 firelink g:293 from=handmaid shop missable
loc shop:110252 firelink g:303 from=handmaid shop missable
loc shop:110253 firelink g:458 from=handmaid shop missable
loc shop:110300 firelink g:276 from=handmaid shop missable
loc shop:110301 firelink g:336 from=handmaid shop missable
loc shop:110302 firelink a:99000000 from=handmaid shop missable
loc shop:110303 firelink a:99001000 from=handmaid shop missable
loc shop:110304 firelink a:99002000 from=handmaid shop missable
loc shop:110305 firelink a:99003000 from=handmaid shop missable
loc shop:110350 firelink g:331 from=handmaid shop missable
loc shop:110351 firelink g:341 from=handmaid shop missable
loc shop:110352 firelink g:454 from=handmaid shop missable
loc shop:110353 firelink a:23501000 from=handmaid shop missable
loc shop:110354 firelink a:23502000 from=handmaid shop missable
loc shop:110355 firelink a:23503000 from=handmaid shop missable
loc shop:110400 firelink g:274 from=handmaid shop missable
loc shop:110401 firelink g:311 from=handmaid shop missable
loc shop:110402 firelink r:20210 from=handmaid shop missable group=73101070
loc shop:110450 firelink g:500 from=handmaid shop missable
loc shop:110451 firelink g:1002 from=handmaid shop missable
loc shop:110452 firelink g:1020 from=handmaid shop missable
loc shop:110453 firelink g:1030 from=handmaid shop missable
loc shop:110500 firelink w:5010000 from=handmaid shop missable
loc shop:110502 firelink w:20240000 from=handmaid shop missable
loc shop:110503 firelink r:20140 from=handmaid shop missable
loc shop:110504 firelink a:82000000 from=handmaid shop missable
loc shop:110505 firelink a:82001000 from=handmaid shop missable
loc shop:110506 firelink a:82002000 from=handmaid shop missable
loc shop:110507 firelink a:82003000 from=handmaid shop missable
loc shop:110508 firelink w:400700 from=handmaid shop missable
loc shop:110509 firelink w:402300 from=handmaid shop missable
loc shop:110510 firelink g:1001 from=handmaid shop missable
loc shop:110511 firelink g:452 from=handmaid shop missable
loc shop:110550 firelink a:21000000 from=handmaid shop missable
loc shop:110551 firelink a:21001000 from=handmaid shop missable
loc shop:110552 firelink a:21002000 from=handmaid shop missable
loc shop:110553 firelink a:21003000 from=handmaid shop missable
loc shop:110600 firelink a:57000000 from=handmaid shop missable
loc shop:110601 firelink a:57001000 from=handmaid shop missable
loc shop:110602 firelink a:57002000 from=handmaid shop missable
loc shop:110603 firelink a:57003000 from=handmaid shop missable
loc shop:110650 firelink a:58000000 from=handmaid shop missable
loc shop:110651 firelink a:58001000 from=handmaid shop missable
loc shop:110652 firelink a:58002000 from=handmaid shop missable
loc shop:110653 firelink a:58003000 from=handmaid shop missable
loc shop:110700 firelink a:94000000 from=handmaid shop missable
loc shop:110701 firelink a:94001000 from=handmaid shop missable
loc shop:110702 firelink a:94002000 from=handmaid shop missable
loc shop:110703 firelink a:94003000 from=handmaid shop missable
loc shop:110750 firelink a:61000000 from=handmaid shop missable
loc shop:110751 firelink a:61001000 from=handmaid shop missable
loc shop:110752 firelink a:61002000 from=handmaid shop missable
loc shop:110753 firelink a:61003000 from=handmaid shop missable
loc shop:110800 firelink a:64000000 from=handmaid shop missable
loc shop:110801 firelink a:64001000 from=handmaid shop missable
loc shop:110802 firelink a:64002000 from=handmaid shop missable
loc shop:110803 firelink a:64003000 from=handmaid shop missable
loc shop:110850 firelink a:63000000 from=handmaid shop missable
loc shop:110851 firelink a:63001000 from=handmaid shop missable
loc shop:110852 firelink a:63002000 from=handmaid shop missable
loc shop:110853 firelink a:63003000 from=handmaid shop missable
loc shop:110900 firelink a:57500000 from=handmaid shop missable
loc shop:110950 firelink a:43000000 from=handmaid shop missable
loc shop:111000 firelink a:27500000 from=handmaid shop missable
loc shop:111001 firelink a:27501000 from=handmaid shop missable
loc shop:111002 firelink a:27502000 from=handmaid shop missable
loc shop:111003 firelink a:27503000 from=handmaid shop missable
loc shop:111050 firelink a:22500000 from=handmaid shop missable
loc shop:111051 firelink a:22501000 from=handmaid shop missable
loc shop:111052 firelink a:22502000 from=handmaid shop missable
loc shop:111053 firelink a:22503000 from=handmaid shop missable
loc shop:111100 firelink a:72000000 from=handmaid shop missable
loc shop:111101 firelink a:72001000 from=handmaid shop missable
loc shop:111102 firelink a:72002000 from=handmaid shop missable
loc shop:111103 firelink a:72003000 from=handmaid shop missable
loc shop:111150 firelink a:73000000 from=handmaid shop missable
loc shop:111151 firelink a:73001000 from=handmaid shop missable
loc shop:111152 firelink a:73002000 from=handmaid shop missable
loc shop:111153 firelink a:73003000 from=handmaid shop missable
loc shop:111200 firelink a:23000000 from=handmaid shop missable
loc shop:111201 firelink a:23001000 from=handmaid shop missable
loc shop:111250 firelink a:24500000 from=handmaid shop missable
loc shop:111251 firelink a:24501000 from=handmaid shop missable
loc shop:111252 firelink a:24502000 from=handmaid shop missable
loc shop:111253 firelink a:24503000 from=handmaid shop missable
loc shop:111301 firelink a:25001000 from=handmaid shop missable
loc shop:111302 firelink a:25002000 from=handmaid shop missable
loc shop:111303 firelink a:25003000 from=handmaid shop missable
loc shop:111350 firelink a:27000000 from=handmaid shop missable
loc shop:111351 firelink a:27001000 from=handmaid shop missable
loc shop:111352 firelink a:27002000 from=handmaid shop missable
loc shop:111353 firelink a:27003000 from=handmaid shop missable
loc shop:111400 firelink a:55000000 from=handmaid shop missable
loc shop:111401 firelink a:55001000 from=handmaid shop missable
loc shop:111402 firelink a:55002000 from=handmaid shop missable
loc shop:111403 firelink a:55003000 from=handmaid shop missable
loc shop:111450 firelink a:90000000 from=handmaid shop missable
loc shop:111451 firelink a:90001000 from=handmaid shop missable
loc shop:111452 firelink a:90002000 from=handmaid shop missable
loc shop:111453 firelink a:90003000 from=handmaid shop missable
loc shop:111500 firelink a:30101000 from=handmaid shop missable
loc shop:111550 firelink a:83000000 from=handmaid shop missable
loc shop:111551 firelink a:83001000 from=handmaid shop missable
loc shop:111552 firelink a:83002000 from=handmaid shop missable
loc shop:111553 firelink a:83003000 from=handmaid shop missable
loc shop:111560 firelink a:32000000 from=handmaid shop missable
loc shop:111561 firelink a:32001000 from=handmaid shop missable
loc shop:111562 firelink a:32002000 from=handmaid shop missable
loc shop:111563 firelink a:32003000 from=handmaid shop missable
loc shop:111600 firelink a:56500000 from=handmaid shop missable
loc shop:111601 firelink a:56501000 from=handmaid shop missable
loc shop:111602 firelink a:56503000 from=handmaid shop missable
loc shop:111650 firelink w:402400 from=handmaid shop missable
loc shop:111651 firelink a:60500000 from=handmaid shop missable
loc shop:111652 firelink a:60501000 from=handmaid shop missable
loc shop:111653 firelink a:60502000 from=handmaid shop missable
loc shop:111654 firelink a:60503000 from=handmaid shop missable
loc shop:111655 firelink g:1120 from=handmaid shop missable
loc shop:111656 firelink g:1020 from=handmaid shop missable
loc shop:111950 firelink g:241 from=handmaid shop missable
loc shop:111951 firelink g:262 from=handmaid shop missable
loc shop:111952 firelink g:1003 from=handmaid shop missable
loc shop:112000 firelink w:11040000 from=handmaid shop missable group=73101050
loc shop:112001 firelink g:2145 from=handmaid shop missable group=73101060
loc shop:112002 firelink r:20210 from=handmaid shop missable group=73101070
loc shop:112003 firelink r:20440 from=handmaid shop missable group=73101080
loc shop:112004 firelink r:20560 from=handmaid shop missable group=73101090
loc shop:112005 firelink g:274 from=handmaid shop missable
loc shop:112006 firelink g:311 from=handmaid shop missable
loc shop:112500 firelink g:1300000 from=handmaid shop missable group=73101000
loc shop:112501 firelink g:1302000 from=handmaid shop missable group=73101010
loc shop:112502 firelink g:1310000 from=handmaid shop missable group=73101020
loc shop:112503 firelink g:1330000 from=handmaid shop missable group=73101030
loc shop:112600 firelink g:1374000 from=handmaid shop missable group=73101040
loc shop:113000 firelink w:1010000 from=handmaid shop missable
loc shop:113001 firelink w:2010000 from=handmaid shop missable
loc shop:113002 firelink w:6000000 from=handmaid shop missable
loc shop:113003 firelink w:8010000 from=handmaid shop missable
loc shop:113004 firelink w:9000000 from=handmaid shop missable
loc shop:113005 firelink w:14040000 from=handmaid shop missable
loc shop:113006 firelink w:20000000 from=handmaid shop missable
loc shop:113007 firelink w:20030000 from=handmaid shop missable
loc shop:113008 firelink w:20120000 from=handmaid shop missable
loc shop:113009 firelink w:20170000 from=handmaid shop missable
loc shop:113010 firelink a:74500000 from=handmaid shop missable
loc shop:113011 firelink a:74501000 from=handmaid shop missable
loc shop:113012 firelink a:74502000 from=handmaid shop missable
loc shop:113013 firelink a:74503000 from=handmaid shop missable
loc shop:113014 firelink a:40200000 from=handmaid shop missable
loc shop:113015 firelink g:270 from=handmaid shop missable
loc shop:113016 firelink g:292 from=handmaid shop missable
loc shop:113017 firelink g:299 from=handmaid shop missable
loc shop:113018 firelink g:310 from=handmaid shop missable
loc shop:113019 firelink g:500 from=handmaid shop missable group=73001000
loc shop:113020 firelink w:400000 from=handmaid shop missable
loc shop:113021 firelink w:400100 from=handmaid shop missable
loc shop:113022 firelink w:404000 from=handmaid shop missable
loc shop:113100 firelink w:3000000 from=handmaid shop missable
loc shop:113101 firelink w:6040000 from=handmaid shop missable
loc shop:113102 firelink w:8240000 from=handmaid shop missable
loc shop:113103 firelink w:10020000 from=handmaid shop missable
loc shop:113104 firelink w:13220000 from=handmaid shop missable
loc shop:113105 firelink w:14010000 from=handmaid shop missable
loc shop:113106 firelink w:20160000 from=handmaid shop missable
loc shop:113107 firelink w:21040000 from=handmaid shop missable
loc shop:113108 firelink a:19500000 from=handmaid shop missable
loc shop:113109 firelink a:19501000 from=handmaid shop missable
loc shop:113110 firelink a:19502000 from=handmaid shop missable
loc shop:113111 firelink a:19503000 from=handmaid shop missable
loc shop:113112 firelink a:23002000 from=handmaid shop missable
loc shop:113113 firelink a:23003000 from=handmaid shop missable
loc shop:113114 firelink a:23101000 from=handmaid shop missable
loc shop:113115 firelink a:23100000 from=handmaid shop missable
loc shop:113116 firelink g:280 from=handmaid shop missable
loc shop:113117 firelink g:300 from=handmaid shop missable group=73001010
loc shop:113118 firelink g:500 from=handmaid shop missable group=73001020
loc shop:113119 firelink w:400300 from=handmaid shop missable
loc shop:113120 firelink w:404100 from=handmaid shop missable
loc shop:113121 firelink w:404200 from=handmaid shop missable
loc shop:113122 firelink g:240 from=handmaid shop missable group=73001030
loc shop:113124 firelink w:4070000 from=handmaid shop missable
loc shop:113125 firelink w:21060000 from=handmaid shop missable
loc shop:113200 firelink w:400500 from=handmaid shop missable
loc shop:113201 firelink w:402000 from=handmaid shop missable
loc shop:113202 firelink w:402200 from=handmaid shop missable
loc shop:113203 firelink w:404400 from=handmaid shop missable
loc shop:113204 firelink g:240 from=handmaid shop missable group=73001040
loc shop:113205 firelink g:241 from=handmaid shop missable group=73001050
loc shop:113206 firelink g:1020 from=handmaid shop missable group=73001060
loc shop:113207 firelink g:1030 from=handmaid shop missable group=73001070
loc shop:113208 firelink w:1070000 from=handmaid shop missable
loc shop:113209 firelink w:2060000 from=handmaid shop missable
loc shop:113210 firelink w:6100000 from=handmaid shop missable
loc shop:113211 firelink w:9090000 from=handmaid shop missable
loc shop:113212 firelink w:14100000 from=handmaid shop missable
loc shop:113213 firelink w:21010000 from=handmaid shop missable
loc shop:113214 firelink w:22010000 from=handmaid shop missable
loc shop:113300 firelink g:300 from=handmaid shop missable
loc shop:113301 firelink g:500 from=handmaid shop missable group=73001080
loc shop:113302 firelink w:404500 from=handmaid shop missable
loc shop:113303 firelink w:404600 from=handmaid shop missable
loc shop:114100 firelink g:1200000 from=handmaid shop missable group=73301100
loc shop:114101 firelink g:1300000 from=handmaid shop missable group=73301110
loc shop:114102 firelink g:1301000 from=handmaid shop missable group=73301120
loc shop:114103 firelink g:1302000 from=handmaid shop missable group=73301130
loc shop:114104 firelink g:1303000 from=handmaid shop missable group=73301180
loc shop:114105 firelink g:1310000 from=handmaid shop missable group=73301190
loc shop:114106 firelink g:1330000 from=handmaid shop missable group=73301200
loc shop:114107 firelink g:1374000 from=handmaid shop missable group=73301210
loc shop:114108 firelink g:1375000 from=handmaid shop missable group=73301140
loc shop:114109 firelink g:1354000 from=handmaid shop missable group=73301150
loc shop:114110 firelink g:1356000 from=handmaid shop missable group=73301160
loc shop:114200 firelink g:1740000 from=handmaid shop missable group=73301170
loc shop:114300 firelink g:1210000 from=handmaid shop missable group=73301220
loc shop:114301 firelink g:1350000 from=handmaid shop missable group=73301230
loc shop:114302 firelink g:1372000 from=handmaid shop missable group=73301240
loc shop:114303 firelink g:1651000 from=handmaid shop missable group=73301250
loc shop:114400 firelink g:1304000 from=handmaid shop missable group=73301260
loc shop:114401 firelink g:1306000 from=handmaid shop missable group=73301270
loc shop:114500 firelink g:1305000 from=handmaid shop missable group=73301280
loc shop:114501 firelink g:1307000 from=handmaid shop missable group=73301290
loc shop:114502 firelink g:1312000 from=handmaid shop missable group=73301300
loc shop:114600 firelink g:1340000 from=handmaid shop missable group=73301310
loc shop:114601 firelink g:1341000 from=handmaid shop missable group=73301320
loc shop:114602 firelink g:1353000 from=handmaid shop missable group=73301330
loc shop:115000 firelink a:28000000 from=handmaid shop missable
loc shop:115001 firelink a:28001000 from=handmaid shop missable
loc shop:115002 firelink a:28002000 from=handmaid shop missable
loc shop:115003 firelink a:28003000 from=handmaid shop missable
loc shop:115100 firelink g:2400000 from=handmaid shop missable group=73101200
loc shop:115101 firelink g:2405000 from=handmaid shop missable group=73101210
loc shop:115102 firelink g:2411000 from=handmaid shop missable group=73101220
loc shop:115103 firelink g:2431000 from=handmaid shop missable group=73101230
loc shop:115104 firelink g:2420000 from=handmaid shop missable group=73101240
loc shop:115200 firelink g:2402000 from=handmaid shop missable group=73101250
loc shop:115201 firelink g:2562000 from=handmaid shop missable group=73101260
loc shop:115202 firelink g:2620000 from=handmaid shop missable group=73101270
loc shop:115300 firelink g:2422000 from=handmaid shop missable group=73101280
loc shop:115301 firelink g:2435000 from=handmaid shop missable group=73101290
loc shop:115302 firelink g:2650000 from=handmaid shop missable group=73101300
loc shop:115400 firelink g:2450000 from=handmaid shop missable group=73101310
loc shop:115401 firelink g:2451000 from=handmaid shop missable group=73101320
loc shop:116100 firelink g:1603000 from=handmaid shop missable group=73901120
loc shop:116101 firelink g:1613000 from=handmaid shop missable group=73901130
loc shop:116200 firelink g:2452000 from=handmaid shop missable group=73901140
loc shop:116201 firelink g:2403000 from=handmaid shop missable group=73901150
loc shop:116202 firelink g:2436000 from=handmaid shop missable group=73901160
loc shop:116300 firelink g:2453000 from=handmaid shop missable group=73901170
loc shop:116301 firelink g:2610000 from=handmaid shop missable group=73901180
loc shop:116400 firelink g:3770000 from=handmaid shop missable group=73901190
loc shop:116401 firelink g:3554000 from=handmaid shop missable group=73901200
loc shop:116500 firelink g:3581000 from=handmaid shop missable group=73901210
loc shop:116501 firelink g:3640000 from=handmaid shop missable group=73901220
loc shop:116502 firelink g:3700000 from=handmaid shop missable group=73901230
loc shop:117000 firelink r:20310 from=handmaid shop missable group=73101600
loc shop:117100 firelink g:3500000 from=handmaid shop missable group=73101610
loc shop:117101 firelink g:3504000 from=handmaid shop missable group=73101620
loc shop:117102 firelink g:3508000 from=handmaid shop missable group=73101630
loc shop:117103 firelink g:3521000 from=handmaid shop missable group=73101640
loc shop:117200 firelink g:3501000 from=handmaid shop missable group=73101650
loc shop:117201 firelink g:3520000 from=handmaid shop missable group=73101660
loc shop:117202 firelink g:3530000 from=handmaid shop missable group=73101670
loc shop:117300 firelink g:3507000 from=handmaid shop missable group=73101680
loc shop:117301 firelink g:3560000 from=handmaid shop missable group=73101690
loc shop:117302 firelink g:3760000 from=handmaid shop missable group=73101700
loc shop:117400 firelink g:3770000 from=handmaid shop missable group=73101710
loc shop:117401 firelink g:3554000 from=handmaid shop missable group=73101720
loc shop:117500 firelink g:3581000 from=handmaid shop missable group=73101730
loc shop:117501 firelink g:3640000 from=handmaid shop missable group=73101740
loc shop:117502 firelink g:3700000 from=handmaid shop missable group=73101750
loc shop:118000 firelink w:1020000 from=handmaid shop missable
loc shop:118001 firelink w:4010000 from=handmaid shop missable group=73501000
loc shop:118002 firelink w:9010000 from=handmaid shop missable
loc shop:118003 firelink a:78001000 from=handmaid shop missable
loc shop:118004 firelink a:78002000 from=handmaid shop missable
loc shop:118005 firelink a:78003000 from=handmaid shop missable
loc shop:118011 firelink g:294 from=handmaid shop missable
loc shop:118012 firelink g:297 from=handmaid shop missable
loc shop:118013 firelink g:302 from=handmaid shop missable
loc shop:118014 firelink g:334 from=handmaid shop missable
loc shop:118015 firelink g:380 from=handmaid shop missable
loc shop:118016 firelink g:455 from=handmaid shop missable
loc shop:118017 firelink g:459 from=handmaid shop missable
loc shop:118018 firelink w:400200 from=handmaid shop missable
loc shop:118100 firelink g:500 from=handmaid shop missable group=73501060
loc shop:118200 firelink g:241 from=handmaid shop missable group=73501070
loc shop:118300 firelink r:20720 from=handmaid shop missable group=73501080
loc shop:119000 firelink w:10170000 from=handmaid shop missable group=75001000
loc shop:119001 firelink g:240 from=handmaid shop missable group=75001010
loc shop:119002 firelink g:241 from=handmaid shop missable group=75001020
loc shop:119003 firelink g:500 from=handmaid shop missable group=75001030
loc shop:119004 firelink g:455 from=handmaid shop missable
loc shop:119005 firelink g:457 from=handmaid shop missable group=75001040
loc shop:119900 untended_graves g:280 from=handmaid shop
loc shop:119901 untended_graves g:350 from=handmaid shop
loc shop:119902 untended_graves g:370 from=handmaid shop
loc shop:119903 untended_graves g:500 from=handmaid shop
loc shop:119904 untended_graves g:100 from=handmaid shop group=6800
loc shop:119905 untended_graves g:385 from=handmaid shop group=6820
loc shop:119906 untended_graves g:2013 from=handmaid shop group=74001020
loc shop:119907 untended_graves r:20160 from=handmaid shop
loc shop:119950 untended_graves a:92000000 from=handmaid shop missable
loc shop:119951 untended_graves a:92001000 from=handmaid shop missable
loc shop:119952 untended_graves a:92002000 from=handmaid shop missable
loc shop:119953 untended_graves a:92003000 from=handmaid shop missable
loc shop:120000 firelink w:1010000 from=npcshop shop missable
loc shop:120001 firelink w:2010000 from=npcshop shop missable
loc shop:120002 firelink w:6000000 from=npcshop shop missable
loc shop:120003 firelink w:8010000 from=npcshop shop missable
loc shop:120004 firelink w:9000000 from=npcshop shop missable
loc shop:120005 firelink w:14040000 from=npcshop shop missable
loc shop:120006 firelink w:20000000 from=npcshop shop missable
loc shop:120007 firelink w:20030000 from=npcshop shop missable
loc shop:120008 firelink w:20120000 from=npcshop shop missable
loc shop:120009 firelink w:20170000 from=npcshop shop missable
loc shop:120010 firelink a:74500000 from=npcshop shop missable
loc shop:120011 firelink a:74501000 from=npcshop shop missable
loc shop:120012 firelink a:74502000 from=npcshop shop missable
loc shop:120013 firelink a:74503000 from=npcshop shop missable
loc shop:120014 firelink a:40200000 from=npcshop shop missable
loc shop:120015 firelink g:270 from=npcshop shop missable
loc shop:120016 firelink g:292 from=npcshop shop missable
loc shop:120017 firelink g:299 from=npcshop shop missable
loc shop:120018 firelink g:310 from=npcshop shop missable
loc shop:120019 firelink g:500 from=npcshop shop missable group=73001000
loc shop:120020 firelink w:400000 from=npcshop shop missable
loc shop:120021 firelink w:400100 from=npcshop shop missable
loc shop:120022 firelink w:404000 from=npcshop shop missable
loc shop:120100 firelink w:3000000 from=npcshop shop missable
loc shop:120101 firelink w:6040000 from=npcshop shop missable
loc shop:120102 firelink w:8240000 from=npcshop shop missable
loc shop:120103 firelink w:10020000 from=npcshop shop missable
loc shop:120104 firelink w:13220000 from=npcshop shop missable
loc shop:120105 firelink w:14010000 from=npcshop shop missable
loc shop:120106 firelink w:20160000 from=npcshop shop missable
loc shop:120107 firelink w:21040000 from=npcshop shop missable
loc shop:120108 firelink a:19500000 from=npcshop shop missable
loc shop:120109 firelink a:19501000 from=npcshop shop missable
loc shop:120110 firelink a:19502000 from=npcshop shop missable
loc shop:120111 firelink a:19503000 from=npcshop shop missable
loc shop:120112 firelink a:23002000 from=npcshop shop missable
loc shop:120113 firelink a:23003000 from=npcshop shop missable
loc shop:120114 firelink a:23101000 from=npcshop shop missable
loc shop:120115 firelink a:23100000 from=npcshop shop missable
loc shop:120116 firelink g:280 from=npcshop shop missable
loc shop:120117 firelink g:300 from=npcshop shop missable group=73001010
loc shop:120118 firelink g:500 from=npcshop shop missable group=73001020
loc shop:120119 firelink w:400300 from=npcshop shop missable
loc shop:120120 firelink w:404100 from=npcshop shop missable
loc shop:120121 firelink w:404200 from=npcshop shop missable
loc shop:120122 firelink g:240 from=npcshop shop missable group=73001030
loc shop:120124 firelink w:4070000 from=npcshop shop missable
loc shop:120125 firelink w:21060000 from=npcshop shop missable
loc shop:120200 firelink w:400500 from=npcshop shop missable
loc shop:120201 firelink w:402000 from=npcshop shop missable
loc shop:120202 firelink w:402200 from=npcshop shop missable
loc shop:120203 firelink w:404400 from=npcshop shop missable
loc shop:120204 firelink g:240 from=npcshop shop missable group=73001040
loc shop:120205 firelink g:241 from=npcshop shop missable group=73001050
loc shop:120206 firelink g:1020 from=npcshop shop missable group=73001060
loc shop:120207 firelink g:1030 from=npcshop shop missable group=73001070
loc shop:120208 firelink w:1070000 from=npcshop shop missable
loc shop:120209 firelink w:2060000 from=npcshop shop missable
loc shop:120210 firelink w:6100000 from=npcshop shop missable
loc shop:120211 firelink w:9090000 from=npcshop shop missable
loc shop:120212 firelink w:14100000 from=npcshop shop missable
loc shop:120213 firelink w:21010000 from=npcshop shop missable
loc shop:120214 firelink w:22010000 from=npcshop shop missable
loc shop:120300 firelink g:300 from=npcshop shop missable
loc shop:120301 firelink g:500 from=npcshop shop missable group=73001080
loc shop:120302 firelink w:404500 from=npcshop shop missable
loc shop:120303 firelink w:404600 from=npcshop shop missable
loc shop:130100 firelink g:1200000 from=npcshop shop missable group=73301100
loc shop:130101 firelink g:1300000 from=npcshop shop missable group=73301110
loc shop:130102 firelink g:1301000 from=npcshop shop missable group=73301120
loc shop:130103 firelink g:1302000 from=npcshop shop missable group=73301130
loc shop:130104 firelink g:1303000 from=npcshop shop missable group=73301180
loc shop:130105 firelink g:1310000 from=npcshop shop missable group=73301190
loc shop:130106 firelink g:1330000 from=npcshop shop missable group=73301200
loc shop:130107 firelink g:1374000 from=npcshop shop missable group=73301210
loc shop:130108 firelink g:1375000 from=npcshop shop missable group=73301140
loc shop:130109 firelink g:1354000 from=npcshop shop missable group=73301150
loc shop:130110 firelink g:1356000 from=npcshop shop missable group=73301160
loc shop:130200 firelink g:1740000 from=npcshop shop missable group=73301170
loc shop:130300 firelink g:1210000 from=npcshop shop missable group=73301220
loc shop:130301 firelink g:1372000 from=npcshop shop missable group=73301240
loc shop:130400 firelink g:1304000 from=npcshop shop missable group=73301260
loc shop:130401 firelink g:1306000 from=npcshop shop missable group=73301270
loc shop:130500 firelink g:1305000 from=npcshop shop missable group=73301280
loc shop:130501 firelink g:1307000 from=npcshop shop missable group=73301290
loc shop:130502 firelink g:1312000 from=npcshop shop missable group=73301300
loc shop:130600 firelink g:1340000 from=npcshop shop missable group=73301310
loc shop:130601 firelink g:1341000 from=npcshop shop missable group=73301320
loc shop:130602 firelink g:1353000 from=npcshop shop missable group=73301330
loc shop:130603 firelink g:1350000 from=npcshop shop missable group=73301230
loc shop:130604 firelink g:1651000 from=npcshop shop missable group=73301250
loc shop:140100 firelink g:2400000 from=npcshop shop missable group=73101200
loc shop:140101 firelink g:2405000 from=npcshop shop missable group=73101210
loc shop:140102 firelink g:2411000 from=npcshop shop missable group=73101220
loc shop:140103 firelink g:2431000 from=npcshop shop missable group=73101230
loc shop:140200 firelink g:2402000 from=npcshop shop missable group=73101250
loc shop:140201 firelink g:2562000 from=npcshop shop missable group=73101260
loc shop:140202 firelink g:2620000 from=npcshop shop missable group=73101270
loc shop:140203 firelink g:2420000 from=npcshop shop missable group=73101240
loc shop:140300 firelink g:2422000 from=npcshop shop missable group=73101280
loc shop:140301 firelink g:2435000 from=npcshop shop missable group=73101290
loc shop:140302 firelink g:2650000 from=npcshop shop missable group=73101300
loc shop:140400 firelink g:2450000 from=npcshop shop missable group=73101310
loc shop:140401 firelink g:2451000 from=npcshop shop missable group=73101320
loc shop:140000 firelink a:28000000 from=npcshop shop missable
loc shop:140001 firelink a:28001000 from=npcshop shop missable
loc shop:140002 firelink a:28002000 from=npcshop shop missable
loc shop:140003 firelink a:28003000 from=npcshop shop missable
loc shop:150100 firelink g:1603000 from=npcshop shop missable group=73901120
loc shop:150101 firelink g:1613000 from=npcshop shop missable group=73901130
loc shop:150200 firelink g:2452000 from=npcshop shop missable group=73901140
loc shop:150201 firelink g:2403000 from=npcshop shop missable group=73901150
loc shop:150202 firelink g:2436000 from=npcshop shop missable group=73901160
loc shop:150300 firelink g:2453000 from=npcshop shop missable group=73901170
loc shop:150301 firelink g:2610000 from=npcshop shop missable group=73901180
loc shop:150400 firelink g:3770000 from=npcshop shop missable group=73901190
loc shop:150401 firelink g:3554000 from=npcshop shop missable group=73901200
loc shop:150500 firelink g:3581000 from=npcshop shop missable group=73901210
loc shop:150501 firelink g:3640000 from=npcshop shop missable group=73901220
loc shop:150502 firelink g:3700000 from=npcshop shop missable group=73901230
loc shop:160100 firelink g:3500000 from=npcshop shop missable group=73101610
loc shop:160101 firelink g:3504000 from=npcshop shop missable group=73101620
loc shop:160102 firelink g:3508000 from=npcshop shop missable group=73101630
loc shop:160103 firelink g:3521000 from=npcshop shop missable group=73101640
loc shop:160200 firelink g:3501000 from=npcshop shop missable group=73101650
loc shop:160201 firelink g:3520000 from=npcshop shop missable group=73101660
loc shop:160202 firelink g:3530000 from=npcshop shop missable group=73101670
loc shop:160300 firelink g:3507000 from=npcshop shop missable group=73101680
loc shop:160301 firelink g:3560000 from=npcshop shop missable group=73101690
loc shop:160302 firelink g:3760000 from=npcshop shop missable group=73101700
loc shop:160400 firelink g:3770000 from=npcshop shop missable group=73101710
loc shop:160401 firelink g:3554000 from=npcshop shop missable group=73101720
loc shop:160500 firelink g:3581000 from=npcshop shop missable group=73101730
loc shop:160501 firelink g:3640000 from=npcshop shop missable group=73101740
loc shop:160502 firelink g:3700000 from=npcshop shop missable group=73101750
loc shop:160000 firelink r:20310 from=npcshop shop missable group=73101600
loc shop:760000 dreg_heap w:10170000 from=npcshop shop missable group=75001000
loc shop:760001 dreg_heap g:240 from=npcshop shop missable group=75001010
loc shop:760002 dreg_heap g:241 from=npcshop shop missable group=75001020
loc shop:760003 dreg_heap g:500 from=npcshop shop missable group=75001030
loc shop:760004 dreg_heap g:455 from=npcshop shop missable
loc shop:760005 dreg_heap g:457 from=npcshop shop missable group=75001040
loc lot:61200 high_wall r:20180 from=npc missable group=50006120
loc lot:62300 high_wall g:2102 from=npc missable group=50006232
loc lot:62100 undead_settlement g:456 from=npc missable
loc lot:62500 undead_settlement g:462 from=npc missable
loc lot:63110 undead_settlement g:350 from=npc missable group=50006311
loc lot:62000 cathedral g:455 from=npc missable
loc lot:60640 irithyll g:290 from=npc missable
loc lot:61900 irithyll r:20590 from=npc missable
loc lot:62103 irithyll g:456 from=npc missable
loc lot:62120 irithyll g:3532000 from=npc missable
loc lot:62105 irithyll_dungeon g:456 from=npc missable
loc lot:62130 irithyll_dungeon g:1003 from=npc missable
loc lot:2041 firelink g:731 from=npc missable
loc lot:2111 firelink g:729 from=npc missable
loc lot:2131 firelink g:725 from=npc missable
loc lot:60300 firelink w:2230000 from=npc missable group=50006030
loc lot:60400 firelink w:2180000 from=npc missable
loc lot:60703 firelink g:1100 from=npc missable group=50006070
loc lot:60720 firelink r:20610 from=npc missable
loc lot:60805 firelink w:3011400 from=npc missable
loc lot:60900 firelink g:111x5 from=npc missable group=50006090
loc lot:60910 firelink g:2001 from=npc missable
loc lot:61000 firelink g:2142 from=npc missable
loc lot:61300 firelink r:20230 from=npc missable
loc lot:61310 firelink r:20290 from=npc missable
loc lot:61400 firelink w:13400000 from=npc missable group=50006140
loc lot:62010 firelink g:457 from=npc missable
loc lot:65400 painted_world g:1003 from=npc missable
loc lot:65500 painted_world r:21000 from=npc missable
loc lot:66200 dreg_heap g:456 from=npc missable group=50006620
loc lot:66210 dreg_heap g:1003 from=npc missable group=50006621
loc lot:66220 dreg_heap g:456 from=npc missable group=50006622
loc lot:66300 ringed_city w:13430000 from=npc missable group=50006630
loc lot:66310 ringed_city g:1003 from=npc missable
]==]
