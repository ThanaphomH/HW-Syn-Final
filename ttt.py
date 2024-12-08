thai_start = 0x0E00
thai_end = 0x0E7F
ascii_mapping = {}
ascii_mapping.update({chr(c): c for c in range(thai_start, thai_end + 1)})

keys = []
for key in ascii_mapping:
    keys.append(key)

print(keys[:-32])