#include "8b.Protocol"
#include "8b.Common"
#include "8b.Faces"

list char_linkids=[
];

string char_texture="base_character";

integer CHAR_DIRECTION_UP=8;
integer CHAR_DIRECTION_DOWN=2;
integer CHAR_DIRECTION_LEFT=4;
integer CHAR_DIRECTION_RIGHT=6;

integer animation_index=0;

integer current_direction=2;

vector map_size=<8,8,0>;

vector starting_position=<4,4,0>;
vector current_position=<4,4,0>;
vector destination_position=<4,4,0>;

integer is_moving=FALSE;

vector cell_size=<0.001,0.18750,0.18750>;


integer row_col_2_cell_id(integer row, integer col){
    return (col)*(integer)(map_size.x)+(row);
}
vector cell_id_2_local_pos(integer row, integer col){
    float offset_x=(col/map_size.x)-0.5;
    float offset_y=(row/map_size.y)-0.5;;
    
    
    
    float diffx=((((float) (map_size.x)*(float) (cell_size.y))))*offset_x;
    float diffy=((((float) (map_size.y)*(float) (cell_size.y))))*offset_y;
    
    return <diffx, diffy, 0.03>;
}
integer get_texture_tile_number(integer char_dir, integer anim_index, integer is_head){
    
    integer row=0;
    integer col=0;
    if(char_dir==CHAR_DIRECTION_UP){
        if(is_head)
            row=7;
        else
            row=8;
    }else if(char_dir==CHAR_DIRECTION_DOWN){
        if(is_head)
            row=1;
        else
            row=2;
    }else if(char_dir==CHAR_DIRECTION_LEFT){
        if(is_head)
            row=3;
        else
            row=4;
    }else if(char_dir==CHAR_DIRECTION_RIGHT){
        if(is_head)
            row=5;
        else
            row=6;
    }
    if(anim_index==0){
        col=2;
    }else if(anim_index==1){
        col=3;
    }else if(anim_index==2){
        col=1;
    }
   // llOwnerSay((string)col+","+(string)row+"    "+(string)(row*3+col));
    return (row-1)*3+(col-1);
}

list get_params_for(string tilesetname, integer linkid, integer face, integer tile_number){
    vector textureOffset=ZERO_VECTOR;
    vector scaleRepeats=ZERO_VECTOR;
    integer tileset_cols=3;
    integer tileset_rows=8;
    scaleRepeats.x=1.0/tileset_cols;
    scaleRepeats.y=1.0/tileset_rows;
   
    integer xN = (tile_number) % tileset_cols;
    integer yN = (tile_number) / tileset_cols;
    float xOffset = -0.5 + 0.5/tileset_cols + (float) xN / (float) tileset_cols;
    float yOffset = 0.5 - 0.5/tileset_rows - (float) yN / (float) tileset_rows;
    textureOffset=<xOffset,yOffset,0>;

    //llOwnerSay(llList2Json(JSON_ARRAY,[PRIM_LINK_TARGET, linkid, PRIM_TEXTURE, face, tilesetname, scaleRepeats, textureOffset, 0]));
    return [PRIM_LINK_TARGET, linkid, PRIM_TEXTURE, face, tilesetname, scaleRepeats, textureOffset, 0];
}
integer string_contains(string haystack, string needle) 
{
    return 0 <= llSubStringIndex(haystack, needle);
}
scan_linkset(){
    integer count=llGetNumberOfPrims();
    integer i=0;
    for(;i<=count;i++){
        string currprimname=llGetLinkName(i); 
        if(string_contains(currprimname,"character_1")){
           list stringparts=llParseString2List(currprimname,["-"],[]);
           if(llGetListLength(char_linkids)>0){
               if(llList2String(stringparts,1)=="0"){
                    char_linkids=[i]+char_linkids;   
               }else{
                   char_linkids+=i;   
               } 
           }else{
               char_linkids =[i];   
           }    
        }   
    }
}
ensure_in_grid(){
    if(destination_position.x>=map_size.x){
        destination_position.x=map_size.x;
    }if(destination_position.y>=map_size.y){
        destination_position.y=map_size.y;
    }
    if(destination_position.x<=1){
        destination_position.x=1;
    }if(destination_position.y<=1){
        destination_position.y=1;
    }
}
paint_character(){
    list losParametros=[];
    losParametros+=get_params_for(char_texture, llList2Integer(char_linkids,0),0,get_texture_tile_number(current_direction,0,FALSE));
    losParametros+=get_params_for(char_texture, llList2Integer(char_linkids,1),0,get_texture_tile_number(current_direction,0,TRUE));
    llSetLinkPrimitiveParamsFast(2,losParametros);
    character_shown=TRUE;
}
clear_character(){
    list losParametros=[];
    losParametros+=[PRIM_LINK_TARGET, llList2Integer(char_linkids,0), PRIM_TEXTURE, 0, TEXTURE_TRANSPARENT, <1,1,0>, <0,0,0>, 0];
    losParametros+=[PRIM_LINK_TARGET, llList2Integer(char_linkids,1), PRIM_TEXTURE, 0, TEXTURE_TRANSPARENT, <1,1,0>, <0,0,0>, 0];
    llSetLinkPrimitiveParamsFast(2,losParametros);
    character_shown=FALSE;
}
move_to(vector pos){
    list losParametros=[];
    losParametros+=[PRIM_LINK_TARGET, llList2Integer(char_linkids,0), PRIM_POS_LOCAL,ZERO_VECTOR+<cell_size.y/2,cell_size.y/2,0>+cell_id_2_local_pos((integer)pos.x-1,(integer)pos.y-1)];
    if(character_shown){
        losParametros+=get_params_for(char_texture, llList2Integer(char_linkids,0),0,get_texture_tile_number(current_direction,animation_index,FALSE));
    }else{
        losParametros+=[PRIM_TEXTURE, 0, TEXTURE_TRANSPARENT, <1,1,0>, <0,0,0>, 0];
    }
    losParametros+=[PRIM_LINK_TARGET, llList2Integer(char_linkids,1), PRIM_POS_LOCAL,ZERO_VECTOR+<cell_size.y/2,cell_size.y/2,0>+cell_id_2_local_pos((integer)pos.x-1,(integer)pos.y-2)];
    //llOwnerSay("pos "+(string)((integer)pos.y));
    if(character_shown){
        if((integer)pos.y==1){
            losParametros+=[PRIM_TEXTURE, 0, TEXTURE_TRANSPARENT, <1,1,0>, <0,0,0>, 0];
        }else{
            losParametros+=get_params_for(char_texture, llList2Integer(char_linkids,1),0,get_texture_tile_number(current_direction,animation_index,TRUE));
        }
    }else{
        losParametros+=[PRIM_TEXTURE, 0, TEXTURE_TRANSPARENT, <1,1,0>, <0,0,0>, 0];
    }
    llSetLinkPrimitiveParamsFast(2,losParametros);
    current_position=destination_position;
    is_moving=FALSE;
}
move_to_animated(vector pos){
    
    list losParametros=[];
    animation_index=1;
    losParametros+=[PRIM_LINK_TARGET, llList2Integer(char_linkids,0)];
    losParametros+=get_params_for(char_texture, llList2Integer(char_linkids,0),0,get_texture_tile_number(current_direction,animation_index,FALSE));
    losParametros+=[PRIM_LINK_TARGET, llList2Integer(char_linkids,1)];
    if((integer)pos.y==1){
        losParametros+=[PRIM_TEXTURE, 0, TEXTURE_TRANSPARENT, <1,1,0>, <0,0,0>, 0];
    }else{
        losParametros+=get_params_for(char_texture, llList2Integer(char_linkids,1),0,get_texture_tile_number(current_direction,animation_index,TRUE));
    }
    llSetLinkPrimitiveParamsFast(2,losParametros);
    llSleep(0.1);
    
    losParametros=[];
    animation_index=2;
    losParametros+=[PRIM_LINK_TARGET, llList2Integer(char_linkids,0), PRIM_POS_LOCAL,ZERO_VECTOR+<cell_size.y/2,cell_size.y/2,0>+cell_id_2_local_pos((integer)pos.x-1,(integer)pos.y-1)];
    losParametros+=get_params_for(char_texture, llList2Integer(char_linkids,0),0,get_texture_tile_number(current_direction,animation_index,FALSE));
    losParametros+=[PRIM_LINK_TARGET, llList2Integer(char_linkids,1), PRIM_POS_LOCAL,ZERO_VECTOR+<cell_size.y/2,cell_size.y/2,0>+cell_id_2_local_pos((integer)pos.x-1,(integer)pos.y-2)];
    if((integer)pos.y==1){
        losParametros+=[PRIM_TEXTURE, 0, TEXTURE_TRANSPARENT, <1,1,0>, <0,0,0>, 0];
    }else{
        losParametros+=get_params_for(char_texture, llList2Integer(char_linkids,1),0,get_texture_tile_number(current_direction,animation_index,TRUE));
    }
    llSetLinkPrimitiveParamsFast(2,losParametros);
    llSleep(0.1);
    
    losParametros=[];
    animation_index=0;
    losParametros+=[PRIM_LINK_TARGET, llList2Integer(char_linkids,0)];
    losParametros+=get_params_for(char_texture, llList2Integer(char_linkids,0),0,get_texture_tile_number(current_direction,animation_index,FALSE));
    losParametros+=[PRIM_LINK_TARGET, llList2Integer(char_linkids,1)];
    if((integer)pos.y==1){
        losParametros+=[PRIM_TEXTURE, 0, TEXTURE_TRANSPARENT, <1,1,0>, <0,0,0>, 0];
    }else{
        losParametros+=get_params_for(char_texture, llList2Integer(char_linkids,1),0,get_texture_tile_number(current_direction,animation_index,TRUE));
    }
    llSetLinkPrimitiveParamsFast(2,losParametros);
    llSleep(0.1);
    
    current_position=destination_position;
    is_moving=FALSE;
}
integer can_pass(integer listpos){
   // llOwnerSay("can_pass "+(string)listpos+" -> "+(string)llList2Integer(passability, listpos));
    return llList2Integer(passability, listpos);
}
list passability=[];


integer character_shown=FALSE;
integer moving_to_start=FALSE;

default{
    state_entry(){
        scan_linkset();
        clear_character();
    }
    link_message(integer sender, integer num, string str, key id) {
        if(num==LINK_CHANNEL_NUMBER){
            if(id==EV_SYSTEM_PAINTED){
                passability=llJson2List(str);
               // llOwnerSay(str);
                destination_position=starting_position;
                //Se ha finalizado de pintar el mapa
                state ready;
            }
        }
    }

}
state ready{
    
    state_entry(){
        paint_character();
        llListen(0, "", NULL_KEY, "");
        llSetTimerEvent(0.3);
        llSetLinkPrimitiveParamsFast(llList2Integer(char_linkids,0),[PRIM_POS_LOCAL,<0,0,0.10>]);
        llSetLinkPrimitiveParamsFast(llList2Integer(char_linkids,1),[PRIM_POS_LOCAL,<0,0,0.10>]);
        list losParametros=[];
        losParametros+=[PRIM_LINK_TARGET, llList2Integer(char_linkids,0), PRIM_POS_LOCAL,ZERO_VECTOR+<cell_size.y/2,cell_size.y/2,0>+cell_id_2_local_pos((integer)starting_position.x-1,(integer)starting_position.y-1)];
        losParametros+=[PRIM_LINK_TARGET, llList2Integer(char_linkids,1), PRIM_POS_LOCAL,ZERO_VECTOR+<cell_size.y/2,cell_size.y/2,0>+cell_id_2_local_pos((integer)starting_position.x-1,(integer)starting_position.y-2)];
        llSetLinkPrimitiveParamsFast(2,losParametros);
    }
    listen(integer channel, string name, key id, string message){
        vector prev_pos=current_position;
        if(message=="left"||message=="izquierda"||message=="4"){
            destination_position=current_position+<-1,0,0>;
        }else if(message=="up"||message=="arriba"||message=="8"){
            destination_position=current_position+<0,-1,0>;
        }else if(message=="right"||message=="derecha"||message=="6"){
            destination_position=current_position+<1,0,0>;
        }else if(message=="down"||message=="abajo"||message=="2"){
            destination_position=current_position+<0,1,0>;
        }
        ensure_in_grid();
        if(!can_pass(row_col_2_cell_id((integer)destination_position.x-1,(integer)destination_position.y-1))){
            destination_position=prev_pos;
        }
       // llOwnerSay("Current "+(string)current_position+"\nDestination "+(string)destination_position);
    }
    link_message(integer sender, integer num, string str, key id) {
        if(num==LINK_CHANNEL_NUMBER){
            if(id==EV_SYSTEM_PAINTED){
                //Se ha finalizado de pintar el mapa
                passability=llJson2List(str);
               // llOwnerSay(str);
                destination_position=starting_position;
                moving_to_start=TRUE;
                //paint character gets called in the timer (after finishig the movement) so the character is hidden until it
                //reaches the starting position.
                //paint_character();
            }else if(id==MT_DO_RESET || id==EV_SYSTEM_READY || id==MT_DO_CLEAR || id==EV_SYSTEM_DONE){
                //Se ha mandado orden de resetear el mapa o se ha limpiado el mapa, limpiar el personaje
                clear_character();
            }
        }
    }
    timer(){
        if(character_shown){
            if(current_position!=destination_position){
                if(!is_moving){
                    is_moving=TRUE;
                    ensure_in_grid();
                    if(current_position.x>destination_position.x){
                        current_direction=CHAR_DIRECTION_LEFT;
                    }else if(current_position.x<destination_position.x){
                        current_direction=CHAR_DIRECTION_RIGHT;
                    }else if(current_position.y>destination_position.y){
                        current_direction=CHAR_DIRECTION_UP;
                    }else if(current_position.y<destination_position.y){
                        current_direction=CHAR_DIRECTION_DOWN;
                    }
                    
                    move_to_animated(destination_position);  
                    
                }
            }else if(!is_moving){
                list losParametros=[];
                
                losParametros+=get_params_for(char_texture, llList2Integer(char_linkids,0),0,get_texture_tile_number(current_direction,0,FALSE));
                if((integer)current_position.y==1){
                    losParametros+=[PRIM_LINK_TARGET, llList2Integer(char_linkids,1) ,PRIM_TEXTURE, 0, TEXTURE_TRANSPARENT, <1,1,0>, <0,0,0>, 0];
                }else{
                    losParametros+=get_params_for(char_texture, llList2Integer(char_linkids,1),0,get_texture_tile_number(current_direction,0,TRUE));
                }
                llSetLinkPrimitiveParamsFast(2,losParametros);    
            }  
        }else{
            if(current_position!=destination_position){
                if(!is_moving){
                    is_moving=TRUE;
                    ensure_in_grid();
                    if(current_position.x>destination_position.x){
                        current_direction=CHAR_DIRECTION_LEFT;
                    }else if(current_position.x<destination_position.x){
                        current_direction=CHAR_DIRECTION_RIGHT;
                    }else if(current_position.y>destination_position.y){
                        current_direction=CHAR_DIRECTION_UP;
                    }else if(current_position.y<destination_position.y){
                        current_direction=CHAR_DIRECTION_DOWN;
                    }
                    
                    move_to(destination_position);  
                }
            }else if(moving_to_start) {
                moving_to_start=FALSE;
                current_direction=CHAR_DIRECTION_DOWN;
                paint_character();
            } 
        }
        
       // paint_character();
    }
}
