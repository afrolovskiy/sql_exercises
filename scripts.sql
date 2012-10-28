/*1) Найти названия всех фильмов, снятых Стивеном Спилбергом*/
SELECT title
FROM Movie
Where director = 'Steven Spielberg';

/*2) Найти года, в которых были фильмы с рейтингом 4 или 5, и отсортивать по 
  возрастанию*/
SELECT DISTINCT m.year 
FROM Movie m JOIN Rating r ON m.mID = r.mID
WHERE r.stars = 4 OR r.stars = 5
ORDER BY m.year;

/*3) Найти названия всех фильмов, которые не имеют рейтинга */
SELECT title
FROM Movie
WHERE mID NOT IN (
	SELECT mID
	FROM Rating
);

/*4) Некоторые оценки не имеют даты. Найти имена всех экспертов, имеющих оценки 
  без даты*/
SELECT DISTINCT re.name
FROM Rating ra JOIN Reviewer re ON ra.rID = re.rID
WHERE ra.ratingDate IS NULL;

/*5) Напишите запрос, возвращающий информацию о рейтингах в более читаемом 
  формате: имя эксперта, название фильма, оценка и дата оценки. Отсортируйте данные
  по имени эксперта, затем названию фильма и наконец, оценка (4 первых записи) */
SELECT name, title, stars, ratingDate
FROM Rating ra  
JOIN Movie m ON ra.mID = m.mID 
JOIN Reviewer re ON ra.rID = re.rID
ORDER BY name, title, stars
LIMIT 4; 

/*6) Для всех случаев, когда один эксперт оценивал фильм дважды и указал лучший 
  рейтинг второй раз, выведите имя эксперта и навание фильма*/
SELECT name, title
FROM (
	SELECT rID, mID, max(stars) as max_stars, max(ratingDate) as max_ratingDate
	FROM Rating
	GROUP BY rID
	HAVING count(rID) = 2
) as tmp 
JOIN Rating ra ON ra.rID = tmp.rID and ra.mID = tmp.mID
JOIN Movie m ON m.mID = tmp.mID
JOIN Reviewer re ON re.rID = tmp.rID
WHERE stars = max_stars AND ratingDate = max_ratingDate;

/*7) Для каждого фильма, который имеет, по крайней мере, одну оценку, найти 
  наибольшее количество звезд, что фильм получил. Выбрать название фильма и
  количество звезд. Сортировать по названию фильма.*/
SELECT title, max(stars)
FROM Rating ra
JOIN Movie m ON ra.mID = m.mID
GROUP BY ra.mID
ORDER BY title;

/*8) Для каждого фильма выбрать название и "разброс оценок", то есть разницу между 
  самой высокой и самой низкой оценками для этого фильма. Сортировать по "разбросу
  оценок" от высшего к низшему и по названию фильма */
SELECT title,  max(stars) -  min(stars) as diff_stars
FROM Rating r
JOIN Movie m ON r.mID = m.mID
GROUP BY r.mID
ORDER BY diff_stars DESC, title;

/*9) Найти разницу между средней оценкой фильмов. выпущенных до 1980 года, и 
  средней оценкой фильмов, выпущенных после 1980 года*/
SELECT max(tmp2.stars) - min(tmp2.stars) as diff
FROM (
        SELECT avg(tmp1.stars) as stars
        FROM (
	        SELECT avg(stars) as stars, mID
	        FROM Rating
	        GROUP BY mID
        ) AS tmp1
        JOIN Movie m ON tmp1.mID = m.mID
        GROUP BY m.year < 1980
) as tmp2;

/*10) Найти имена всех экспертов, кто оценил "Gone with the Wind"*/
SELECT DISTINCT name
FROM Rating ra
JOIN Reviewer re ON ra.rID = re.rID
JOIN Movie m ON ra.mID = m.mID
WHERE m.title = "Gone with the Wind";

/*11) Для каждой оценки, где эксперт тот же человек что и режиссер, выбрать имя, 
  название фильма и оценки*/
SELECT name, title, stars
FROM Rating ra
JOIN Reviewer re ON ra.rID = re.rID
JOIN Movie m ON ra.mID = m.mID
WHERE m.director = re.name;

/*12) Выберите всех экспертов и названия фильмов в едином списке в алфавитном
  порядке (4 первых записи)*/
SELECT name as record
FROM Reviewer
UNION
SELECT title as record
FROM Movie
ORDER BY record
LIMIT 4;

/*13) Выберите названия всех фильмов, которым не поставил оценку Chris Jackson*/
SELECT DISTINCT title
FROM Rating ra
JOIN Reviewer re ON ra.rID = re.rID
JOIN Movie m ON ra.mID = m.mID
WHERE re.name != 'Chris Jackson';

/*14) Для всех пар экспертов, если оба оценили один и тот же фильм, выбрать имена
  обоих. Устранить дубликаты, проверить отсутствие пар самих с собой и включать 
  каждую пару только 1 раз. Выбрать имена в паре в алфавитном порядке.*/
SELECT DISTINCT r1.name, r2.name
FROM (
        SELECT ra.rID, name, mID
        FROM Rating ra
        JOIN Reviewer re ON ra.rID = re.rID
) as r1
JOIN  (
        SELECT ra.rID, name, mID
        FROM Rating ra
        JOIN Reviewer re ON ra.rID = re.rID
) as r2 ON r1.mID = r2.mID
WHERE r1.name < r2.name;

/*15) Для каждой минимальной оценки выбрать имя эксперта, название фильма,
  количество звезд*/
SELECT name, title, stars
FROM Rating ra
JOIN Reviewer re ON ra.rID = re.rID
JOIN Movie m ON ra.mID = m.mID
WHERE ra.stars = (
	SELECT min(stars)
	FROM Rating
);

/*16) Список названий фильмов и средний рейтинг, от самого низкого до высокого.
  Если 2 и более фильмов имеют одинаковый средний балл, перечислить их в   
  алфавитном порядке*/
SELECT avg(stars) as avg_stars, title
FROM Rating r
JOIN Movie m ON r.mID = m.mID
GROUP BY m.mID
ORDER BY avg_stars DESC, title;

/*17) Найти имена всех экспертов, которые поставили 3 и более оценки*/
SELECT re.name
FROM Rating r
JOIN Reviewer re ON r.rID = re.rID
GROUP BY r.rID
HAVING count(r.rID) >= 3;

/*18) Некоторые режиссеры сняли более, чем 1 фильм. Для всех таких режиссеров
  выбрать названия всех фильмов режиссера. его имя. Сортировка по имени режиссера.*/
SELECT title, director
FROM Movie
WHERE director IN (
	SELECT director
	FROM Movie
	GROUP BY director
	HAVING count(director) > 1
)
ORDER BY director;
