unit time;
interface
uses DateUtils, SysUtils;

function ctime:integer;    // seconds after 01.01.2000 0:00
function mirctime:string;  // [DayOfWeek Month DayOfWeek hh:mm:ss Year]

implementation

function ctime;
begin
  result:=SecondsBetween(EncodeDateDay(2000,1),now)
end; // function ctime;

function mirctime;
var s: string;
begin
  case DayOfTheWeek(now) of
    1: s:='Mon ';
    2: s:='Tue ';
    3: s:='Wed';
    4: s:='Thu';
    5: s:='Fri';
    6: s:='Sat';
    7: s:='Sun '
  end;
  case MonthOf(now) of
    1: s:=s+'Jan ';
    2: s:=s+'Feb ';
    3: s:=s+'Mar ';
    4: s:=s+'Apr ';
    5: s:=s+'May ';
    6: s:=s+'Jun ';
    7: s:=s+'Jul ';
    8: s:=s+'Aug ';
    9: s:=s+'Sep ';
    10: s:=s+'Oct ';
    11: s:=s+'Nov ';
    12: s:=s+'Des ';
  end;
  s:=s+inttostr(DayOf(now));
  s:=s+FormatDateTime(' h:nn:ss ',now);
  s:=s+inttostr(YearOf(now));
  result:=s
end; // function mirctime;

end.
