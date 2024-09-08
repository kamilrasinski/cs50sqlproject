
-- Add a new user --
INSERT INTO "users" ("first_name", "last_name", "username", "password")
VALUES ('Kamil', 'Rasiński', 'KamilR', 'password1');

-- Add a new company --
INSERT INTO "companies" ("name", "country")
VALUES ('Blizzard Entertainment', 'USA');

-- Add a new publisher from companies --
INSERT INTO "publishers" ("company_id")
VALUES (1);

-- Add a new developer from companies --
INSERT INTO "developers" ("company_id")
VALUES (1);

-- Add a new game --
INSERT INTO "games" ("title", "developer_id", "publisher_id", "year", "type")
VALUES ('Diablo II: Ressurected', 1, 1, 2021, 'action');

--Add a rating to the game --
INSERT INTO "ratings" ("user_id", "game_id", "rating")
VALUES (4, 1, 5.5);

--View all ratings that particular user have given
SELECT "title", "username", "rating"
FROM "users_ratings"
WHERE "username" = "KamilR";

--Change already given rating
UPDATE "ratings"
SET "rating" = 9
WHERE "user_id" = (
    SELECT "id" FROM "users"
    WHERE "username" = 'KamilR'
)
AND "game_id" = (
    SELECT "id" FROM "games"
    WHERE "title" = "Diablo II: Ressurected"
);

--Delete rating
DELETE FROM "ratings"
WHERE "id" = 10;
