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
