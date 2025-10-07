sprite_index = Button_glow;

if (Type == "Start") {
    room_goto(Room1); 
}
else if (Type == "Options") {
    room_goto(Options);      
}
else if (Type == "Exit") {
    game_end();
}

else if (Type == "Back") {
    room_goto(Home);
}


