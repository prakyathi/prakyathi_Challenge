import re

def is_valid_credit_card(card_number):
    pattern = r'^[4-6]\d{3}-?\d{4}-?\d{4}-?\d{4}$'

    
    if re.match(pattern, card_number):
        card_number = card_number.replace("-", "")
        for i in range(len(card_number) - 3):
            if card_number[i] == card_number[i + 1] == card_number[i + 2] == card_number[i + 3]:
                return False
        return True

    return False

# Test cases
credit_cards = [
    "4123-5678-9101-2345",
    "4333-5678-9101-2345",
    "5123-4567-8912-3456",  # Valid
    "61234-567-8912-3456",  # Valid
    "4123356789123456",     # Valid
    "41234567891234566",    # Invalid (consecutive repeated digits)
    "412345678912345",      # Invalid (not enough digits)
    "5123-4567-8912-3456-", # Invalid (extra hyphen)
    "4123_5678_9123_4567",  # Invalid (uses underscore as separator)
]

for card in credit_cards:
    if is_valid_credit_card(card):
        print(f"{card} is a valid credit card.")
    else:
        print(f"{card} is not a valid credit card.")
