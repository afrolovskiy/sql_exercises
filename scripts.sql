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






