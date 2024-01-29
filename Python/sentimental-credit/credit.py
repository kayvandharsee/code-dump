# TODO
def main():
    # use input to get card number
    card = input("Number: ")
    # use isnumeric to check if value is a number and repeat if not
    while not (card.isnumeric()):
        card = input("Number: ")
    # sets variables for later use
    card_length = len(card)
    card = int(card)
    card_type = card
    # for loop and use modulus to check if it is the even or odd digit, apply algorithm
    sum = 0
    sum_mult = 0
    for i in range(0, card_length):
        # even digit algo
        if i % 2 == 0:
            sum += card % 10
        # odd digit algo
        if i % 2 == 1:
            temp_mult = (card % 10) * 2
            if temp_mult > 9:
                while temp_mult != 0:
                    sum_mult += temp_mult % 10
                    temp_mult = temp_mult // 10
            else:
                sum_mult += temp_mult
        card = card // 10
    # check number validity
    if (sum + sum_mult) % 10 == 0:
        card_type = card_type // (10 ** (card_length - 2))
        # check for card type
        if card_type in (34, 37) and card_length == 15:
            print("AMEX")
        elif (50 < card_type < 56) and card_length == 16:
            print("MASTERCARD")
        elif (39 < card_type < 50) and card_length in (13, 16):
            print("VISA")
        else:
            print("INVALID")
    else:
        print("INVALID")


if __name__ == "__main__":
    main()
