# Get text from user
def main():
    text = input("Text: ")
    L, S = read_level(text)
    # Compute and print grades
    reading_grade = 0.0588 * L - 0.296 * S - 15.8
    # print(f"{reading_grade}")
    reading_grade = round(reading_grade)
    if reading_grade >= 16:
        print("Grade 16+")
    elif reading_grade < 1:
        print("Before Grade 1")
    else:
        print(f"Grade {reading_grade}")


# Set L and S vars
def read_level(text):
    # We set words to 1 as the final word will not have a space following after
    letters = 0
    sentences = 0
    words = 1
    for i in text:
        if i.isalpha():
            letters += 1
        if i == " ":
            words += 1
        if i == "." or i == "!" or i == "?":
            sentences += 1
    # print(f"{letters}, {words}, {sentences}")
    L = letters / float(words) * 100
    # print(f"{L}")
    S = sentences / float(words) * 100
    # print(f"{S}")
    return (L, S)


if __name__ == "__main__":
    main()
