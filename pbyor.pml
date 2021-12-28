#include "for.h"

byte Cards[4]={4,4,4,4};
bool shuffled[4]={0,0,0,0};
#define Terminated (np_ == 0)
#define zero ((Cards[0] == 0) && (Cards[1] == 0) && (Cards[2] == 0) && (Cards[3] == 0))
#define one ((Cards[0] == 1) && (Cards[1] == 1) && (Cards[2] == 1) && (Cards[3] == 1))
#define two ((Cards[0] == 2) && (Cards[1] == 2) && (Cards[2] == 2) && (Cards[3] == 2))
#define three ((Cards[0] == 3) && (Cards[1] == 3) && (Cards[2] == 3) && (Cards[3] == 3))

ltl { [] (Terminated -> (zero || one || two || three )) };


active proctype dealer()
{
    byte repeat_times = 1
    for(k,0,repeat_times)
        byte p=4;
        byte q=4;
        byte r=4;
        byte s=4;
        atomic 
        {
            select ( p : 0 .. 3);
            select ( q : 0 .. 3);
            select ( r : 0 .. 3);
            select ( s : 0 .. 3);
            if
                :: (shuffled[0] == 0) && (shuffled[1] == 0) && (shuffled[2] == 0) && (shuffled[3] == 0) -> 
                {
                    Cards[0] = p;
                    Cards[1] = q;
                    Cards[2] = r;
                    Cards[3] = s;
                    shuffled[0] = 1;
                    shuffled[1] = 1;
                    shuffled[2] = 1;
                    shuffled[3] = 1;
                }
            fi
        }
    rof(k);
}

active [4] proctype player()
{
    byte player_number = _pid-1;
    byte left_player = 4;
    byte right_player = 4;
    byte maximum_iterations = 100;   
    do 
        
        :: maximum_iterations == 0 -> {break}

        :: else ->
        { 
            
            maximum_iterations--;
            if
                :: (player_number == 0) && (shuffled[player_number] == 1) -> {
                                    left_player = 3;
                                    right_player = 1;
                                    if
                                        :: Cards[player_number] < Cards[left_player] -> atomic {Cards[player_number] = Cards[left_player] ; shuffled[player_number] = 0};
                                        :: Cards[player_number] < Cards[right_player] -> atomic {Cards[player_number] = Cards[right_player] ; shuffled[player_number] = 0};
                                        :: else -> {skip};
                                fi;
                            }
                :: (player_number == 1) && (shuffled[player_number] == 1) -> {
                                    left_player = 0;
                                    right_player = 2;
                                    if
                                        :: Cards[player_number] < Cards[left_player] -> atomic {Cards[player_number] = Cards[left_player] ; shuffled[player_number] = 0};
                                        :: Cards[player_number] < Cards[right_player] -> atomic {Cards[player_number] = Cards[right_player] ; shuffled[player_number] = 0};
                                        :: else -> {skip};
                                    fi;
                            }
                :: (player_number == 2) && (shuffled[player_number] == 1) -> {
                                    left_player = 3;
                                    right_player = 1;
                                    if
                                        :: Cards[player_number] < Cards[left_player] -> atomic {Cards[player_number] = Cards[left_player] ; shuffled[player_number] = 0};
                                        :: Cards[player_number] < Cards[right_player] -> atomic {Cards[player_number] = Cards[right_player] ; shuffled[player_number] = 0};
                                        :: else -> {skip};

                                    fi;
                            }
                :: (player_number == 3) && (shuffled[player_number] == 1) -> {
                                    left_player = 0;
                                    right_player = 2;
                                    if
                                        :: Cards[player_number] < Cards[left_player] -> atomic {Cards[player_number] = Cards[left_player] ; shuffled[player_number] = 0};
                                        :: Cards[player_number] < Cards[right_player] -> atomic {Cards[player_number] = Cards[right_player] ; shuffled[player_number] = 0};
                                        :: else -> {skip};

                                    fi;
                            }

            fi;
        }
    od;
}



