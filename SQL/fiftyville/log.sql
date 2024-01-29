-- Keep a log of any SQL queries you execute as you solve the mystery.

-- First off, we should see everything from the crime scene reports that matches the details we were given
SELECT * FROM crime_scene_reports
    WHERE year = 2021 AND month = 7 AND day = 28 AND street = "Humphrey Street";
-- From the previous query, we learn that the crime ocurred at 10:15am, and happened at the bakery.
-- We can use this info to check the bakery security logs for that day
SELECT * FROM bakery_security_logs
    WHERE year = 2021 AND month = 7 AND day = 28;
-- We should also take a look at the interviews
SELECT * FROM interviews
    WHERE year = 2021 AND month = 7 AND day = 28;
-- The thief must have entered before 10:15am and left within 10 minutes after 10:15am (nothing on logs at 10:15),
-- so we can gather the names from the license plates of the people who fit this criteria
SELECT name FROM people
    WHERE license_plate IN
        (SELECT license_plate FROM bakery_security_logs
            WHERE year = 2021 AND month = 7 AND day = 28 AND activity = "entrance"
            AND (hour < 10 OR (hour = 10 AND minute < 15)))
    AND license_plate IN
        (SELECT license_plate FROM bakery_security_logs
            WHERE year = 2021 AND month = 7 AND day = 28 AND activity = "exit"
            AND (hour = 10 AND minute > 15 AND minute < 26));
-- We get 8 thief suspects from this, and we can thus use these names along with out other information.
-- Lets check bank accounts that line up with atm withdrawls on Leggett Street(per witness), and find matching names
SELECT name FROM people
    JOIN bank_accounts ON people.id = bank_accounts.person_id
    WHERE account_number IN
        (SELECT account_number FROM atm_transactions
            WHERE year = 2021 AND month = 7 AND day = 28
            AND atm_location = "Leggett Street" AND transaction_type = "withdraw")
    AND name IN ("Vanessa", "Barry", "Iman", "Sofia", "Luca", "Diana", "Kelsey", "Bruce");
-- We now have 4 thief suspects, and test these names with calls on that day for under a minute(per witness)
SELECT name FROM people
    WHERE phone_number IN
        (SELECT caller FROM phone_calls
            WHERE year = 2021 AND month = 7 AND day = 28
            AND duration < 60) AND name IN
            ("Bruce", "Diana", "Iman", "Luca");
-- Now we have narrowed the thief suspect to Diana and Bruce. We can then check what the earliest flight out of fiftyville was the next day.
SELECT * FROM flights
    WHERE year = 2021 AND month = 7 AND day = 29
    AND origin_airport_id =
        (SELECT id FROM airports
            WHERE city = "Fiftyville");
-- We can see the earliest flight has id 36 and has destination airport id of 4. Lets see which of our suspects were on this flight
SELECT name FROM people
    WHERE passport_number IN
        (SELECT passport_number FROM passengers
            WHERE flight_id = 36)
    AND name IN ("Diana", "Bruce");
-- Now we know Bruce is our thief, so lets see who Bruce contacted for less than 60 seconds on the day of the robbery
SELECT name FROM people
    WHERE phone_number IN
        (SELECT receiver FROM phone_calls
            WHERE year = 2021 AND month = 7 AND day = 28
            AND duration < 60
            AND caller =
                (SELECT phone_number FROM people
                    WHERE name = "Bruce"));
-- We see Bruce contacted Robin for less than a minute the day of the robbery, thus making her the accomplice.
-- We can then see where Bruce fled to by checking which city corresponds with the airport id of 4
SELECT city FROM airports
    WHERE id = 4;
-- We now know the thief Bruce fled to New York City with the help of his accomplice Robin
