#include <ctype.h>
#include <cs50.h>
#include <stdio.h>
#include <string.h>

// Points assigned to each letter of the alphabet
int POINTS[] = {1, 3, 3, 2, 1, 4, 2, 4, 1, 8, 5, 1, 3, 1, 1, 3, 10, 1, 1, 1, 1, 4, 4, 8, 4, 10};

int compute_score(string word);

int main(void)
{
    // Get input words from both players
    string word1 = get_string("Player 1: ");
    string word2 = get_string("Player 2: ");

    // Score both words
    int score1 = compute_score(word1);
    int score2 = compute_score(word2);

    // Player 1 Wins
    if (score1 > score2)
    {
        printf("Player 1 wins!\n");
    }
    // Player 2 Wins
    if (score1 < score2)
    {
        printf("Player 2 wins!\n");
    }
    // Tie
    if (score1 == score2)
    {
        printf("Tie!\n");
    }
}

int compute_score(string word)
{
    // TODO: Compute and return score for string
    int score = 0;
    int difference = 0;
    // Iterates through the word
    for (int i = 0, length = strlen(word); i < length; i++)
    {
        // Ensures it is a letter and not a symbol
        if (isupper(word[i]) || islower(word[i]))
        {
            if isupper(word[i])
            {
                difference = 65;
            }
            else
            {
                difference = 97;
            }
            int ascii = word[i] - difference;
            score += POINTS[ascii];
        }
        // Else case for symbols
        else
        {
            score += 0;
        }
    }
    return score;
}
