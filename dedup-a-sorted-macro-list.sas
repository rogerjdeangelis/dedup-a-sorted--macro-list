Dedup a sorted  macro list

github
https://github.com/rogerjdeangelis/dedup-a-sorted-macro-list

SAS Forum
https://tinyurl.com/y7h7s7yq
https://communities.sas.com/t5/SAS-Programming/distinct-values-of-macro-varaible-vector/m-p/641841

Two Solutions

      a. dosubl file out file in with delimiter (use Richards solution - this is just academic DOSUBL experimentation)

      b. praparse  (select one)
         RichardADeVenezia
         https://communities.sas.com/t5/user/viewprofilepage/user-id/12477


This solution has the advantage that you get both
the the macro variable and a datasets

%macro dosubl(arg);
  %let rc=%qsysfunc(dosubl(&arg));
%mend dosubl;

*_                   _
(_)_ __  _ __  _   _| |_
| | '_ \| '_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
;

%let years =2001+2001+2002+2003+2003+2003+2004;

*            _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| '_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
;


%put &=newyear;

NEWYEAR=2001+2002+2003+2004

Up to 40 obs WORK.WANT total obs=1

Obs          newyear

 1     2001+2002+2003+2004

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

*              _                 _     _
  __ _      __| | ___  ___ _   _| |__ | |
 / _` |    / _` |/ _ \/ __| | | | '_ \| |
| (_| |_  | (_| | (_) \__ \ |_| | |_) | |
 \__,_(_)  \__,_|\___/|___/\__,_|_.__/|_|

;

data want;
 retain newyear "                             ";
 if _n_=0 then do; %dosubl('data;file ".temp";put "&years";run;quit;');end;
 infile ".temp" delimiter='+' eof=lbl;
 input year$ @@;
 lagyear=lag(year);
 if lagyear ne year;
 newyear=catx('+',newyear,year);
 put _n_= x=;
 return;
 lbl: call symputx('newyear',newyear);
      keep newyear;
      output;
      stop;
run;quit;

%put &=newyear;

*
 _ __  _ ____  ___ __   __ _ _ __ ___  ___
| '_ \| '__\ \/ / '_ \ / _` | '__/ __|/ _ \
| |_) | |   >  <| |_) | (_| | |  \__ \  __/
| .__/|_|  /_/\_\ .__/ \__,_|_|  |___/\___|
|_|             |_|
;

options nosource;

%let years = 2001+2001+2002+2003+2003+2003+2004;

%let rxid = %sysfunc(prxparse(s/((\d+)\+)(\1)+/\1/));
%let times = -1;

%put NOTE: before, &=years;

%syscall prxchange(rxid,times,years);
%syscall prxfree(rxid);

%put NOTE: after,  &=years;

%symdel years rxid times;


