-- __/\\\\\\\\\\\__/\\\\\_____/\\\__/\\\\\\\\\\\\\\\____/\\\\\_________/\\\\\\\\\
_________/\\\\\\\________/\\\\\\\________/\\\\\\\________/\\\\\\\\\\
________________/\\\\\\\\\_______/\\\\\\\\\_____
-- _\/////\\\///__\/\\\\\\___\/\\\_\/\\\///////////___/\\\///\\\
_____/\\\///////\\\_____/\\\/////\\\____/\\\/////\\\____/\\\/////\\\
____/\\\///////\\\_____________/\\\\\\\\\\\\\___/\\\///////\\\___
-- _____\/\\\_____\/\\\/\\\__\/\\\_\/\\\____________/\\\/__\///\\\__\///
______\//\\\___/\\\____\//\\\__/\\\____\//\\\__/\\\____\//\\\__\///______/\\\
_____________/\\\/////////\\\_\///______\//\\\__
-- _____\/\\\_____\/\\\//\\\_\/\\\_\/\\\\\\\\\\\___/\\\______\//\\\
___________/\\\/___\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\_________/\\\//
_____________\/\\\_______\/\\\___________/\\\/___
-- _____\/\\\_____\/\\\\//\\\\/\\\_\/\\\///////___\/\\\_______\/\\\
________/\\\//_____\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\________\////\\\
____________\/\\\\\\\\\\\\\\\________/\\\//_____
-- _____\/\\\_____\/\\\_\//\\\/\\\_\/\\\__________\//\\\______/\\\______/\\\//
________\/\\\_____\/\\\_\/\\\_____\/\\\_\/\\\_____\/\\\___________\//\\\
___________\/\\\/////////\\\_____/\\\//________
-- _____\/\\\_____\/\\\__\//\\\\\\_\/\\\___________\///\\\__/\\\______/\\\/
___________\//\\\____/\\\__\//\\\____/\\\__\//\\\____/\\\___/\\\______/\\\
____________\/\\\_______\/\\\___/\\\/___________
--
__/\\\\\\\\\\\_\/\\\___\//\\\\\_\/\\\_____________\///\\\\\/______/\\\\\\\\\\\\\\\
__\///\\\\\\\/____\///\\\\\\\/____\///\\\\\\\/___\///\\\\\\\\\/_____________\/\\\
_______\/\\\__/\\\\\\\\\\\\\\\_
--
_\///////////__\///_____\/////__\///________________\/////_______\///////////////
_____\///////________\///////________\///////_______\/////////_______________\///
________\///__\///////////////__
-- Your Name: Tuan Phong Vu
-- Your Student Number: 1266265
-- By submitting, you declare that this work was completed entirely by yourself.
--
___________________________________________________________________________________
___________________________________________________________________________________
______________________________________
-- BEGIN Q1
Select firstName, lastName
from player natural join clubplayer natural join club
where club.clubname = 'Melbourne Tigers' and clubplayer.todate is null;
-- END Q1
--
___________________________________________________________________________________
___________________________________________________________________________________
______________________________________
-- BEGIN Q2
select sub.teamName from
(
select team.teamName, count(*) as counting
from game inner join team on game.team1 = team.teamid
where (game.T2score = 28 and game.t1score is NULL)
group by team.teamname
union
select team.teamName, count(*) as counting
from game inner join team on game.team2 = team.teamid
where (game.t1score = 28 and game.t2score is null)
group by team.teamname
order by counting desc
limit 1) as sub;
-- END Q2
--
___________________________________________________________________________________
___________________________________________________________________________________
______________________________________
-- BEGIN Q3
select sub.firstName, sub.lastName from
(select distinct firstName,lastname, count(distinct clubplayer.clubid) as counting
from player natural join clubplayer
group by firstname, lastname
order by counting desc
limit 1) as sub;
-- END Q3
--
___________________________________________________________________________________
___________________________________________________________________________________
______________________________________
-- BEGIN Q4
select firstName, lastName,
sum(year(matchdate) = 2020) as numGames2020,
sum(year(matchdate) = 2021) as numGames2021
from player natural join playerteam natural join game
group by firstname, lastname
having numGames2020>numGames2021;
-- END Q4
--
___________________________________________________________________________________
___________________________________________________________________________________
______________________________________
-- BEGIN Q5
select teamName,
sum(case when team.teamid = game.team1 then game.t1score
else game.t2score end) AS sumOfPoint
from team inner join
 game on team.teamid = game.team1 or team.teamid = game.team2
where teamtype = 'Women 6-a-side' and year(matchdate) = '2021'
group by teamName
having sumofpoint =
(select max(sumpoint)
from (select teamName,
sum(case when team.teamid = game.team1
then game.t1score
else game.t2score end) AS sumpoint
from team inner join
 game on team.teamid = game.team1 or 
team.teamid = game.team2
where teamtype = 'Women 6-a-side' and
year(matchdate) = '2021'
group by teamname) as sub);
-- END Q5
--
___________________________________________________________________________________
___________________________________________________________________________________
______________________________________
-- BEGIN Q6
select distinct firstName,lastName
from player natural join playerteam natural join team
where player.playerid not in
 (select distinct player.playerid
from player natural join playerteam natural join team
where team.teamtype = 'Women 6-a-side')

and player.sex = 'F';
-- END Q6
--
___________________________________________________________________________________
___________________________________________________________________________________
______________________________________
-- BEGIN Q7
select player.firstName,player.lastName, sub.clubname as
firstClubName,sub2.clubname as mostReccentClubName
from player
natural join
(select firstname, lastname, club.clubname
 from player natural join clubplayer natural join club
 where (playerid,fromdate) in (
 select playerid, min(fromdate)
 from player natural join clubplayer natural join club
 group by playerid)) as sub
inner join
(select firstname, lastname, club.clubname
 from player natural join clubplayer natural join club
 where (playerid,fromdate) in (
 select playerid, max(fromdate)
 from player natural join clubplayer natural join club
 group by playerid)) sub2 on sub.firstname = sub2.firstname and sub.lastname
= sub2.lastname
where playerid in
(select distinct playerid from player natural join playerteam natural join
team);
-- END Q7
--
___________________________________________________________________________________
___________________________________________________________________________________
______________________________________
-- BEGIN Q8
select firstName, lastName
from (
select firstname, lastname, count(*) as played
from player natural join clubplayer natural join club
where clubname like '%Melbourne%'
and not exists (select distinct firstname, lastname, clubname, count(*) as
counting
from player natural join clubplayer natural join club
where clubname like '%Melbourne%'
group by firstname, lastname, clubname
having counting > 1)
group by firstname, lastname
having played = (select count(*) from club where clubname like '%Melbourne%')) as
sub;
-- END Q8
--
___________________________________________________________________________________
___________________________________________________________________________________
______________________________________
-- BEGIN Q9
select distinct firstName, lastName, competitionName, season.seasonYear as
competitionYear
from season inner join
(select firstName, lastName, season.seasonid, competition.competitionName,
sum(case
 when (game.t1score is null and game.t2score is null) then 0
when (playerteam.teamid = game.team1 and (game.t1score <
game.t2score or game.t1score is null )) then 1
 when (playerteam.teamid = game.team2 and (game.t2score <
game.t1score or game.t2score is null )) then 1
else 0 end) AS winlose
from player natural join playerteam natural join game natural join season inner
join competition on season.competitionid = competition.competitionid
where (player.playerid, seasonid) not in
(select playerid,seasonid from (
select playerid, teamid, seasonid,
 sum(case
when (game.t1score is null and game.t2score is null) then 0
when (playerteam.teamid = game.team1 and (game.t1score <
game.t2score or game.t1score is null )) then 1
 when (playerteam.teamid = game.team2 and (game.t2score <
game.t1score or game.t2score is null )) then 1
else 0 end) AS result
from playerteam natural join team inner join
 game on team.teamid = game.team1 or team.teamid =
game.team2
group by playerid, teamid,seasonid
having result = 0) as table1)
group by firstname, lastname, season.seasonid, competition.competitionName
having winlose = 0) as sub1 on season.seasonid = sub1.seasonid;
-- END Q9
--
___________________________________________________________________________________
___________________________________________________________________________________
______________________________________
-- BEGIN Q10
select clubname from
 (select clubname, max(sub1.ratio)-min(sub1.ratio) as result
from
(select clubname, teamid, sub.win/sub.lose as ratio
 from
(select clubname, teamid, sum(case
when team.teamid = game.team1 and game.t1score >
game.t2score or (game.t1score is not null and game.t2score is null) then 1
 when team.teamid = game.team2 and game.t2score > game.t1score
or (game.t2score is not null and game.t1score is null) then 1
else 0 end) AS win,
 sum(case
when team.teamid = game.team1 and game.t1score <
game.t2score or (game.t1score is null and game.t2score is not null) then 1
 when team.teamid = game.team2 and game.t2score < game.t1score
or (game.t2score is null and game.t1score is not null) then 1
else 0 end) AS lose
from club natural join team inner join
 game on team.teamid = game.team1 or team.teamid =
game.team2
where year(game.matchdate) = '2021'
group by clubname, teamid) as sub)as sub1
group by clubname
 order by result desc
 limit 1) as sub;
-- END Q10
--
___________________________________________________________________________________
___________________________________________________________________________________
______________________________________
-- END OF ASSIGNMENT Do not write below this line