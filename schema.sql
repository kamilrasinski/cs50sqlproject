8--Schema of GameRate database - you can rate games here

--Table of games
CREATE TABLE "games" (
    "id" INTEGER,
    "title" TEXT NOT NULL UNIQUE,
    "developer_id" INTEGER,
    "publisher_id" INTEGER,
    "year" NUMERIC,
    "type" TEXT,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("developer_id") REFERENCES "developers"("id"),
    FOREIGN KEY ("publisher_id") REFERENCES "publishers"("id")
);

--Table of companies (developers and publishers)
CREATE TABLE "companies" (
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    "country" TEXT,
    PRIMARY KEY ("id")
);

--Table of developer companies
CREATE TABLE "developers" (
    "id" INTEGER,
    "company_id" INTEGER,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("company_id") REFERENCES "companies"("id")
);

--Table of publisher companies
CREATE TABLE "publishers" (
    "id" INTEGER,
    "company_id" INTEGER,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("company_id") REFERENCES "companies"("id")
);

--Table of users of the database
CREATE TABLE "users" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "username" TEXT NOT NULL UNIQUE,
    "password" TEXT NOT NULL,
    PRIMARY KEY ("id")
);

--Table of ratings given by users to games in the database
CREATE TABLE "ratings" (
    "id" INTEGER,
    "user_id" INTEGER,
    "game_id" INTEGER,
    "rating" NUMERIC CHECK ("rating" BETWEEN 1 AND 10),
    PRIMARY KEY ("id"),
    FOREIGN KEY ("user_id") REFERENCES "users"("id"),
    FOREIGN KEY ("game_id") REFERENCES "games"("id"),
    CONSTRAINT "one_rating_per_user" UNIQUE ("user_id", "game_id") --Constraint so users can rate one particular game only once
);

--Indexes for faster quering
CREATE INDEX "game_search" ON "games"("title");
CREATE INDEX "company_search" ON "companies"("name");
CREATE INDEX "username_search" ON "users"("username");

-- In this view, we can view all games, their developers and publishers in one place
CREATE VIEW "games_made_by" AS
SELECT
    "games"."title",
    "developer_companies"."name" AS "developer",
    "publisher_companies"."name" AS "publisher"
FROM
    "games"
JOIN
    "developers" ON "games"."developer_id" = "developers"."id"
JOIN
    "companies" AS "developer_companies" ON "developer_companies"."id" = "developers"."company_id"
JOIN
    "publishers" ON "games"."publisher_id" = "publishers"."id"
JOIN
    "companies" AS "publisher_companies" ON "publisher_companies"."id" = "publishers"."company_id";

--View of developers with their id's in developers table
CREATE VIEW "developers_view" AS
SELECT "developers"."id", "companies"."name"
FROM "developers"
JOIN "companies" ON "companies"."id" = "developers"."company_id";

--View of publishers with their id's in publishers table
CREATE VIEW "publishers_view" AS
SELECT "publishers"."id", "companies"."name"
FROM "publishers"
JOIN "companies" ON "companies"."id" = "publishers"."company_id";

--View of games with their average user ratings
CREATE VIEW "games_ratings" AS
SELECT "games"."title", ROUND(AVG("rating"), 2) AS "average_rating" FROM "games"
JOIN "ratings" ON "ratings"."game_id" = "games"."id"
GROUP BY "game_id";

--View of ratings that users gave to particular game
CREATE VIEW "users_ratings" AS
SELECT "title", "username", "rating"
FROM "games"
LEFT JOIN "ratings" ON "ratings"."game_id" = "games"."id"
LEFT JOIN "users" ON "users"."id" = "ratings"."user_id";
