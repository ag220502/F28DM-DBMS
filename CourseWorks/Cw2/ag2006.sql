#F28DM CW2

#username = ag2006
#Name = Akshay Arunkumar Garg
#Heriot Watt Id = H0338776

#question 1
SELECT COUNT(*) AS TotalFemales FROM `imdb_actors` WHERE sex="F";

#question 2
SELECT title AS MovieName FROM imdb_movies WHERE year = (SELECT MIN(year) FROM imdb_movies);

#question 3
SELECT COUNT(DISTINCT(md.movieid)) As TotalMovies FROM `imdb_movies2directors` md INNER JOIN (SELECT movieid,COUNT(directorid) FROM `imdb_movies2directors` GROUP BY movieid HAVING COUNT(directorid)>5 ) a ON md.movieid = a.movieid;

#question 4
SELECT m.title AS MovieTitle FROM imdb_movies m INNER JOIN (SELECT movieid,COUNT(directorid) AS direc FROM imdb_movies2directors GROUP BY movieid) grp ON m.movieid=grp.movieid ORDER BY grp.direc DESC LIMIT 1;

#question 5
SELECT SUM(r.time1) AS TotalTime FROM imdb_runningtimes r INNER JOIN ( SELECT d.movieid AS movieId From imdb_movies m INNER JOIN imdb_movies2directors d ON m.movieid=d.movieid WHERE d.genre="Sci-Fi" ) a ON r.movieid=a.movieid;

#question 6
SELECT COUNT(ia.movieid) AS TotalMovies FROM imdb_movies2actors ia INNER JOIN ( SELECT actorId FROM imdb_actors a WHERE a.name LIKE "%McGregor, Ewan%" )ac INNER JOIN ( SELECT ia.movieid FROM imdb_movies2actors ia INNER JOIN ( SELECT actorId FROM imdb_actors a WHERE a.name LIKE "%Carlyle, Robert%" )ac ON ia.actorid=ac.actorid )b ON ia.movieid=b.movieid AND ia.actorid=ac.actorid;

#question 7
SELECT ROUND(COUNT(*)/2,0) AS Total FROM ( SELECT COUNT(1)+1 AS AllCount from imdb_movies2actors ma1,imdb_movies2actors ma2 WHERE ma1.movieid=ma2.movieid AND ma1.actorid!=ma2.actorid GROUP BY ma1.actorid,ma2.actorid HAVING AllCount>10)abc;

#question 8
SELECT CONCAT((FLOOR(im.year / 10) * 10),"-",RIGHT((floor(im.year / 10) * 10+9),2)) AS Decade,COUNT(im.movieid) AS MoviesCount FROM `imdb_movies` im WHERE im.year>=1960 AND im.year<=2009 GROUP BY Decade;

#question 9
SELECT COUNT(a.movieId) AS TotalMovies FROM ( SELECT ma.movieid AS movieId,COUNT(a.actorid) AS females FROM imdb_movies2actors ma INNER JOIN imdb_actors a ON ma.actorid=a.actorid WHERE a.sex="F" GROUP BY ma.movieid) a INNER JOIN ( SELECT ma.movieid AS movieId,COUNT(a.actorid) AS allCount FROM imdb_movies2actors ma INNER JOIN imdb_actors a ON ma.actorid=a.actorid GROUP BY ma.movieid)b ON a.movieId=b.movieId WHERE a.females>(b.allCount-a.females);

#question 10
SELECT id.genre Genre FROM imdb_movies2directors id INNER JOIN imdb_ratings ir ON id.movieid=ir.movieid WHERE ir.votes>=10000 GROUP BY id.genre ORDER BY AVG(ir.rank) DESC LIMIT 1;

#question 11
SELECT ia.name AS ActorName FROM imdb_movies2actors ma INNER JOIN imdb_movies2directors mw INNER JOIN imdb_actors ia ON ma.movieid=mw.movieid AND ia.actorid=ma.actorid GROUP BY ma.actorid HAVING COUNT(DISTINCT(mw.genre))>=10;

#question 12
SELECT COUNT(DISTINCT(ma.movieid)) AS MovieCounts FROM imdb_movies2writers mw INNER JOIN imdb_movies2directors md INNER JOIN imdb_movies2actors ma INNER JOIN ( SELECT ia.actorid AS ActorId,id.directorid AS DecId,iw.writerid As WriterId FROM imdb_actors ia INNER JOIN imdb_directors id INNER JOIN imdb_writers iw ON ia.name=id.name AND ia.name=iw.name )mid ON mw.writerid=mid.WriterId AND ma.actorid=mid.ActorId AND md.directorid=mid.DecId AND mw.movieid=ma.movieid AND md.movieid=ma.movieid;

#question 13
SELECT (FLOOR(im.year / 10) * 10) AS Year FROM `imdb_movies` im INNER JOIN imdb_ratings ir ON im.movieid=ir.movieid GROUP BY CONCAT((FLOOR(im.year / 10) * 10),"-",(FLOOR(im.year / 10) * 10)+9) ORDER BY AVG(ir.rank) Desc LIMIT 1;

#question 14
SELECT COUNT(DISTINCT(a.movieid)) AS TotalMovies FROM `imdb_movies2directors` d RIGHT JOIN imdb_movies a ON a.movieid=d.movieid WHERE d.genre IS NULL;

#question 15
SELECT AllMovieCounts-MovieCounts AS TotalMovies FROM ( SELECT COUNT(DISTINCT(ma.movieid)) AS MovieCounts FROM imdb_movies2writers mw INNER JOIN imdb_movies2directors md INNER JOIN imdb_movies2actors ma INNER JOIN ( SELECT ia.actorid AS ActorId,id.directorid AS DecId,iw.writerid As WriterId FROM imdb_actors ia INNER JOIN imdb_directors id INNER JOIN imdb_writers iw ON ia.name=id.name AND ia.name=iw.name )mid ON mw.writerid=mid.WriterId AND ma.actorid=mid.ActorId AND md.directorid=mid.DecId AND mw.movieid=ma.movieid AND md.movieid=ma.movieid)ab INNER JOIN ( SELECT COUNT(DISTINCT(ma.movieid)) AS AllMovieCounts FROM imdb_movies2writers mw INNER JOIN imdb_movies2directors md INNER JOIN imdb_movies2actors ma INNER JOIN ( SELECT ia.actorid AS ActorId,id.directorid AS DecId,iw.writerid As WriterId FROM imdb_actors ia INNER JOIN imdb_directors id INNER JOIN imdb_writers iw ON ia.name=id.name AND ia.name=iw.name )mid ON mw.writerid=mid.WriterId AND md.directorid=mid.DecId AND mw.movieid=ma.movieid AND md.movieid=ma.movieid)abc