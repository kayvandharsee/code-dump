import csv
import sys


def main():
    # TODO: Check for command-line usage
    if len(sys.argv) != 3:
        sys.exit("Usage: python dna.py data.csv sequence.txt")
    # TODO: Read database file into a variable
    file = open(sys.argv[1], "r")
    reader = csv.DictReader(file)
    # TODO: Read DNA sequence file into a variable
    file = open(sys.argv[2], "r")
    sequence = file.read()
    # TODO: Find longest match of each STR in DNA sequence
    # Creates a list of the keys of the dictreader without the names key
    str_check = list(reader.fieldnames)
    database_length = len(str_check)
    str_counts = []
    str_check.pop(0)
    index = 0
    for key in str_check:
        str_seq = longest_match(sequence, key)
        str_counts.append(str_seq)
    # TODO: Check database for matching profiles
    counter = 0
    match_found = 0
    for item in reader:
        for i, subseq in enumerate(str_check):
            if int(item[subseq]) == int(str_counts[i]):
                counter += 1
        if counter == len(str_check):
            print(item["name"])
            match_found = 1
            break
        else:
            counter = 0
    if match_found == 0:
        print("No match")
    return


def longest_match(sequence, subsequence):
    """Returns length of longest run of subsequence in sequence."""

    # Initialize variables
    longest_run = 0
    subsequence_length = len(subsequence)
    sequence_length = len(sequence)

    # Check each character in sequence for most consecutive runs of subsequence
    for i in range(sequence_length):
        # Initialize count of consecutive runs
        count = 0

        # Check for a subsequence match in a "substring" (a subset of characters) within sequence
        # If a match, move substring to next potential match in sequence
        # Continue moving substring and checking for matches until out of consecutive matches
        while True:
            # Adjust substring start and end
            start = i + count * subsequence_length
            end = start + subsequence_length

            # If there is a match in the substring
            if sequence[start:end] == subsequence:
                count += 1

            # If there is no match in the substring
            else:
                break

        # Update most consecutive matches found
        longest_run = max(longest_run, count)

    # After checking for runs at each character in seqeuence, return longest run found
    return longest_run


main()
