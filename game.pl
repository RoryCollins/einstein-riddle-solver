row(1, [twenty, fifty, penny, nickel]).
row(2, [night, sunrise, tornadoes, sun]).
row(3, [zeppelin, helicopter, submarine, ambulance]).
row(4, [santa, wizard, crown, detective]).

match(penny, submarine).
match(detective, submarine).
match(helicopter, sun).
match(ambulance, santa).
match(crown, sun).
match(submarine, night).
match(tornadoes, zeppelin).
match(night, detective).

mismatch(nickel, zeppelin).
mismatch(nickel, helicopter).
mismatch(ambulance, tornadoes).
mismatch(tornadoes, santa).
mismatch(wizard, penny).
mismatch(twenty, zeppelin).
mismatch(santa, twenty).
mismatch(helicopter, detective).
mismatch(detective, sunrise).