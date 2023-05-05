
All_Normal = [];
All_Large = [];
%% normo
% 22N
 [All_Normal_Resids,Large_Dstar_Resids] = Average_SSD('22','Day1','Scan 1_sorted', [23], 'Normo' );
 All_Normal = [All_Normal; All_Normal_Resids];
 All_Large = [All_Large; Large_Dstar_Resids];
% 23N
 [All_Normal_Resids,Large_Dstar_Resids] = Average_SSD('23','Day1', 'Scan 1_sorted',[29,27,23], 'Normo' );
  All_Normal = [All_Normal; All_Normal_Resids];
 All_Large = [All_Large; Large_Dstar_Resids];
% 24N
 [All_Normal_Resids,Large_Dstar_Resids] = Average_SSD('24','Day1','Scan 2_sorted', [26,27,23], 'Normo' );
  All_Normal = [All_Normal; All_Normal_Resids];
 All_Large = [All_Large; Large_Dstar_Resids];
% 25N
 [All_Normal_Resids,Large_Dstar_Resids] = Average_SSD('25','Day1','Scan 2_sorted', [27,21,18], 'Normo' );
  All_Normal = [All_Normal; All_Normal_Resids];
 All_Large = [All_Large; Large_Dstar_Resids];
% 26N
 [All_Normal_Resids,Large_Dstar_Resids] = Average_SSD('26','Day1','Scan 07 IVIM_sorted', [26,23], 'Normo' );
  All_Normal = [All_Normal; All_Normal_Resids];
 All_Large = [All_Large; Large_Dstar_Resids];

 disp('normo: ')
 disp([mean(All_Normal),std(All_Normal)])
 disp([mean(All_Large),std(All_Large)])


%% hyper
All_Normal = [];
All_Large = [];
%21H
 [All_Normal_Resids,Large_Dstar_Resids] = Average_SSD('21','Day1','Scan 34 IVIM_sorted', [28,24,20], 'Hyper' );
  All_Normal = [All_Normal; All_Normal_Resids];
 All_Large = [All_Large; Large_Dstar_Resids];
%22H
 [All_Normal_Resids,Large_Dstar_Resids] = Average_SSD('22','Day1','Scan 2_sorted', [23], 'Hyper' );
  All_Normal = [All_Normal; All_Normal_Resids];
 All_Large = [All_Large; Large_Dstar_Resids];
% 23H
 [All_Normal_Resids,Large_Dstar_Resids] = Average_SSD('23','Day1','Scan 2_sorted', [29,27,23], 'Hyper' );
  All_Normal = [All_Normal; All_Normal_Resids];
 All_Large = [All_Large; Large_Dstar_Resids];
% 25H
 [All_Normal_Resids,Large_Dstar_Resids] = Average_SSD('25','Day1','Scan 4_sorted', [27,21,18], 'Hyper' );
  All_Normal = [All_Normal; All_Normal_Resids];
 All_Large = [All_Large; Large_Dstar_Resids];
% 26H
 [All_Normal_Resids,Large_Dstar_Resids] = Average_SSD('26','Day1','Scan 25 IVIM_sorted', [26, 23], 'Hyper' );
  All_Normal = [All_Normal; All_Normal_Resids];
 All_Large = [All_Large; Large_Dstar_Resids];


 disp('hyper: ')
 disp([mean(All_Normal),std(All_Normal)])
 disp([mean(All_Large),std(All_Large)])

%% post mcao

All_Normal = [];
All_Large = [];
% 21P
 [All_Normal_Resids,Large_Dstar_Resids] = Average_SSD('21','Day2','Scan 28 IVIM_sorted', [27, 23, 21], 'PMCAO' );
  All_Normal = [All_Normal; All_Normal_Resids];
 All_Large = [All_Large; Large_Dstar_Resids];
% 22P
 [All_Normal_Resids,Large_Dstar_Resids] = Average_SSD('22','Day2','Scan2_sorted', [19], 'PMCAO' );
  All_Normal = [All_Normal; All_Normal_Resids];
 All_Large = [All_Large; Large_Dstar_Resids];

% 23P
 [All_Normal_Resids,Large_Dstar_Resids] = Average_SSD('23','Day2','Scan 2_sorted', [29,24,19], 'PMCAO' );
  All_Normal = [All_Normal; All_Normal_Resids];
 All_Large = [All_Large; Large_Dstar_Resids];
%24P
 [All_Normal_Resids,Large_Dstar_Resids] = Average_SSD('24','Day2','Scan 1_sorted', [21,18,15], 'PMCAO' );
  All_Normal = [All_Normal; All_Normal_Resids];
 All_Large = [All_Large; Large_Dstar_Resids];
%26P
 [All_Normal_Resids,Large_Dstar_Resids] = Average_SSD('26','Day2','Scan 23 IVIM_sorted', [25,19], 'PMCAO' );
  All_Normal = [All_Normal; All_Normal_Resids];
 All_Large = [All_Large; Large_Dstar_Resids];


%}
disp('PMCAO')
 disp([mean(All_Normal),std(All_Normal)])
 disp([mean(All_Large),std(All_Large)])


