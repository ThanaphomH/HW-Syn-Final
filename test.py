# Python dictionary mapping for a-z, A-Z, 0-9, Enter, Space, and Thai characters to their ASCII values.

# Generate dictionary for a-z
ascii_mapping = {chr(c): c for c in range(ord('a'), ord('z') + 1)}

# Add A-Z
ascii_mapping.update({chr(c): c for c in range(ord('A'), ord('Z') + 1)})

# Add 0-9
ascii_mapping.update({chr(c): c for c in range(ord('0'), ord('9') + 1)})

# Add Enter and Space
ascii_mapping['Enter'] = 13  # ASCII for Enter is 13
ascii_mapping['Space'] = 32  # ASCII for Space is 32
ascii_mapping['-'] = 45

# Add Thai characters (U+0E00 to U+0E7F in Unicode)
thai_start = 0x0E00
thai_end = 0x0E7F
ascii_mapping.update({chr(c): c for c in range(thai_start, thai_end + 1)})

# # Display the dictionary
# ascii_mapping


w = open("rom.txt", "w")

# mainkey + enter + lshift + rshift + space + caplock
scancode_list = ["16","1E","26","25","2E","36","3D","3E","46","45","4E","55","15","1D","24","2D","2C","35","3C","43","44","4D","54","5B","5D","1C","1B","23","2B","34","33","3B","42","4B","4C","52","1A","22","21","2A","32","31","3A","41","49","4A","5A","12","59","29","58"]
eng_no_shift =  ["1","2","3","4","5","6","7","8","9","0","-","-","q","w","e","r","t","y","u","i","o","p","-","-","-","a","s","d","f","g","h","j","k","l","-","-","z","x","c","v","b","n","m","-","-","-", "Enter", None, None, "Space", None]
eng_shifting =  ["-","-","-","-","-","-","-","-","-","-","-","-","Q","W","E","R","T","Y","U","I","O","P","-","-","-","A","S","D","F","G","H","J","K","L","-","-","Z","X","C","V","B","N","M","-","-","-", "Enter", None, None, "Space", None]
thai_no_shift = ["ๅ","-","-","ภ","ถ","ุ" ,"ึ" ,"ค","ต","จ","ข","ช","ๆ","ไ","ำ","พ","ะ","ั","ี","ร","น","ย","บ","ล","ฃ","ฟ","ห","ก","ด","เ","้","่","า","ส","ว","ง","ผ","ป","แ","อ","ิ","ื","ท","ม","ใ","ฝ","Enter", None, None, "Space" , None]
thai_shifting = ["-","-","-","-","-","ู","-","-","-","-","-","-","-","","ฎ","ฑ","ธ","ํ","๊","ณ","ฯ","ญ","ฐ",",","ฅ","ฤ","ฆ","ฏ","โ","ฌ","็","๋","ษ","ศ","ซ","-","-","-","ฉ","ฮ","-","์","-","ฒ","ฬ","ฦ","Enter", None, None, "Space" , None]

n = len(scancode_list)

for lang in range(2):
    for shift in range(2):
        for i in range(n):
            data = ""
            if (lang == 0 and shift == 0) :
                data = eng_no_shift[i]
            elif (lang == 0 and shift == 1) :
                data = eng_shifting[i]
            elif (lang == 1 and shift == 0) :
                data = thai_no_shift[i]
            else :
                data = thai_shifting[i]
            
            ascii = ""
            if (data == None) :
                ascii = 0
            elif (data not in ascii_mapping) : 
                ascii = ascii_mapping["-"]
            else :
                ascii = ascii_mapping[data]
            
            res = f"10'b{lang:01b}{shift:01b}{int(scancode_list[i] , 16):08b} : data = 8'h{ascii:02X};\n"

            w.write(res)

print(n)