#include "for.h"
byte Cards[4]={0,1,2,3};
bool dealer_terminated = 0
#define Terminated (np_ == 0)
#define zero ((Cards[0] == 0) && (Cards[1] == 0) && (Cards[2] == 0) && (Cards[3] == 0))
#define one ((Cards[0] == 1) && (Cards[1] == 1) && (Cards[2] == 1) && (Cards[3] == 1))
#define two ((Cards[0] == 2) && (Cards[1] == 2) && (Cards[2] == 2) && (Cards[3] == 2))
#define three ((Cards[0] == 3) && (Cards[1] == 3) && (Cards[2] == 3) && (Cards[3] == 3))
ltl { [] (Terminated -> ( zero || one || two || three )) };

active proctype dealer()
{
    byte repeat_times = 1
    for(k,0,repeat_times)
        byte p=0;
        byte q=1;
        byte r=0;
        byte s=1;
        
        select ( p : 0 .. 3);
        select ( q : 0 .. 3);
        select ( r : 0 .. 3);
        select ( s : 0 .. 3);
        atomic {
            Cards[0] = p;
            Cards[1] = q;
            Cards[2] = r;
            Cards[3] = s;
        }
    rof(k);
    dealer_terminated = 1
}

active [4] proctype player()
{
    byte player_number = _pid-1;
    byte left_player = 4;
    byte right_player = 4;
    do 
        :: dealer_terminated == 1 && ( zero || one || two || three ) -> break;

        :: (player_number == 0) -> {
                            left_player = 3;
                            right_player = 1;
                            if
                                :: Cards[player_number] < Cards[left_player] -> atomic {
                                                                                        Cards[player_number] = Cards[left_player] ;
                                                                                        
                                                                                    };
                                :: Cards[player_number] < Cards[right_player] -> atomic {
                                                                                        Cards[player_number] = Cards[right_player] ;
                                                                                        };
                                :: else -> {skip};

                        fi;
                    }
        :: (player_number == 1) -> {
                            left_player = 0;
                            right_player = 2;
                            if
                                :: Cards[player_number] < Cards[left_player] -> atomic {
                                                                                        Cards[player_number] = Cards[left_player] ;
                                                                                    };
                                :: Cards[player_number] < Cards[right_player] -> atomic {
                                                                                        Cards[player_number] = Cards[right_player] ;
                                                                                        };
                                :: else -> {skip};

                            fi;
                    }
        :: (player_number == 2)  -> {
                            left_player = 3;
                            right_player = 1;
                            if
                                :: Cards[player_number] < Cards[left_player] -> atomic {
                                                                                        Cards[player_number] = Cards[left_player] ;
                                                                                    };
                                :: Cards[player_number] < Cards[right_player] -> atomic {
                                                                                        Cards[player_number] = Cards[right_player] ;
                                                                                        };
                                :: else -> {skip};

                            fi;
                    }
        :: (player_number == 3)  -> {
                            left_player = 0;
                            right_player = 2;
                            if
                                :: Cards[player_number] < Cards[left_player] -> atomic {
                                                                                        Cards[player_number] = Cards[left_player] ;
                                                                                    };
                                :: Cards[player_number] < Cards[right_player] -> atomic {
                                                                                        Cards[player_number] = Cards[right_player] ;
                                                                                        };
                                :: else -> {skip};

                            fi;
                    }
    od;
}



