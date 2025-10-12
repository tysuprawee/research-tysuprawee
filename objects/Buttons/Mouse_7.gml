sprite_index = Button_glow;
if (Type == "Options") {
	
    room_goto(Options);      
}
else if (Type == "Exit") {
    game_end();
}

else if (Type == "Back") {
    room_goto(Home);
}

else if (Type == "Single") {
    room_goto(Single);
}

else if (Type == "Multi") {
    room_goto(Multi);
}

else if (Type == "Store") {
    room_goto(Store);
}

else if (Type == "Card") {
    room_goto(Card);
}

