condition = "y"
def encrypt(text,s):
    result = ""
    # traverse text
    for i in range(len(text)):
        char = text[i]
        # Encrypt uppercase characters
        if char == " ":
            result += char
        elif (char.isupper()):
            result += chr(((ord(char) + int(s)-65) % 26 + 65))
        # Encrypt lowercase characters
        else:
            result += chr(((ord(char) + int(s) - 97) % 26 + 97))

    return result

def decrypt(text,s):
    result = ""
    # traverse text
    for i in range(len(text)):
        char = text[i]
        # Encrypt uppercase characters
        if char == " ":
            result += char
        elif (char.isupper()):
            result += chr(((ord(char) - int(s)-65) % 26 + 65))
        # Encrypt lowercase characters
        else:
            result += chr(((ord(char) - int(s) - 97) % 26 + 97))

    return result
while condition == "y":
    choice = input("Ceasar cypher Decrypt/Encrypt code \nUsing the ASCII table to deal with punctuation\nWhat would you like to do ? (d)ecrypt or (e)ncrypt \n")
    if choice == "e":
        text = input("What text would you like to encrypt ?\n")
        s = input("What key would you like to use ?\n")
        encrypt(text,s)
        print ("Original Text  : " + text)
        print ("Shift : " + str(s))
        print ("Cipher: " + encrypt(text,s))
        condition = input("Would you like to continue ? y or n\n")
    elif choice == "d":
        text = input("What would you like to decrypt ?\n")
        s = input("What key would you like to use ? enter (b) for bruteforce\n")
        if s == "b":
            condition2 = "n"
            for s in range(1,27):
                decrypt(text,s)
                print ("Shift : " + str(s))
                print ("Decrypted Text: " + encrypt(text,s))
                print ("-----------------------------")
                condition2 = input("Is this what you are looking for ?")
                if condition2 == "y":
                    break
            condition = input("Would you like to continue ? y or n\n")
        
        else:
            decrypt(text,s)
            print ("Cipher  : " + text)
            print ("Shift : " + str(s))
            print ("Decrypted Text: " + encrypt(text,s))
            condition = input("Would you like to continue ? y or n\n")
print("Ave Caesar !")