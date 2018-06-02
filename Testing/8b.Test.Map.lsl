#include "8b.Protocol"
#include "8b.Common"
#include "8b.Faces"

string generate_map(){
    list elmapa=[];
    list elmapaalpha=[];
    list alpha_tiles_passability=[];
    list ground_tiles_passability=[];
    string tilesetsuelo="base_ground";
    string tilesetalpha="base_alpha";
    vector alphasize=<10,10,0>;
    vector suelosize=<10,10,0>;
    float elAleatorio=llFrand(3);
    
    if(elAleatorio>2){
        elmapa=[
            1,1,1,55,55,1,1,1,
            11,11,11,55,55,11,11,11,
            42,42,42,42,42,42,42,42,
            43,43,43,43,43,43,43,43,
            43,43,43,43,43,43,43,43,
            43,43,43,43,43,43,43,43,
            43,43,43,43,43,43,43,43,
            43,43,43,43,43,43,43,43
        ];
        elmapaalpha=[
            99,99,99,99,99,6,7,99,
            34,35,78,99,99,99,99,99,
            44,45,88,99,99,99,99,99,
            99,99,99,99,99,99,99,99,
            99,99,99,99,99,99,99,99,
            99,99,99,99,99,99,99,99,
            99,99,99,99,99,99,99,99,
            99,99,99,99,99,99,99,99
        ];
        ground_tiles_passability=[
            0,0,0,0,0,0,0,0,0,0,
            0,0,0,0,0,0,0,0,0,0,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1
        ];
        alpha_tiles_passability=[
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,0,0,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1
        ];
    }else if(elAleatorio>1){
        elmapa=[
            0,0,0,55,55,0,0,0,
            10,10,10,55,55,10,10,10,
            42,42,42,42,42,42,42,42,
            43,43,43,43,43,43,43,43,
            43,43,43,43,43,43,43,43,
            43,43,43,43,43,43,43,43,
            43,43,43,43,43,43,43,43,
            43,43,43,43,43,43,43,43
        ];
        elmapaalpha=[
            99,6,7,99,99,99,99,99,
            99,99,99,99,99,34,35,99,
            99,99,99,99,99,44,45,99,
            99,99,99,99,99,99,99,99,
            99,99,99,99,99,99,99,99,
            99,99,99,99,99,99,99,99,
            99,99,99,99,99,99,99,99,
            99,99,99,99,99,99,99,99
        ];
        ground_tiles_passability=[
            0,0,0,0,0,0,0,0,0,0,
            0,0,0,0,0,0,0,0,0,0,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1
        ];
        alpha_tiles_passability=[
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,0,0,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1
        ];
    }else if(elAleatorio>0){
        elmapa=[
            0,0,0,55,55,0,0,0,
            10,10,10,55,55,10,10,10,
            42,42,42,42,42,42,42,42,
            43,43,43,43,43,43,43,43,
            43,43,43,43,43,43,43,43,
            43,43,43,43,43,43,43,43,
            43,43,43,43,43,43,43,43,
            43,43,43,43,43,43,43,43
        ];
        elmapaalpha=[
            99,6,7,99,99,99,99,99,
            99,99,99,99,99,34,35,99,
            99,99,99,99,99,44,45,99,
            99,99,99,99,99,99,99,99,
            99,99,99,99,99,99,99,99,
            99,99,99,99,99,99,99,99,
            99,99,99,99,99,99,99,99,
            99,99,99,99,99,99,99,99
        ];
        ground_tiles_passability=[
            0,0,0,0,0,0,0,0,0,0,
            0,0,0,0,0,0,0,0,0,0,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1
        ];
        alpha_tiles_passability=[
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,0,0,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1,
            1,1,1,1,1,1,1,1,1,1
        ];
    }
    string toRet="{}";
    toRet=llJsonSetValue(toRet,["ground_tileset"],tilesetsuelo);
    toRet=llJsonSetValue(toRet,["alpha_tileset"],tilesetalpha);
    toRet=llJsonSetValue(toRet,["ground"],llList2Json(JSON_ARRAY,elmapa));
    toRet=llJsonSetValue(toRet,["alpha"],llList2Json(JSON_ARRAY,elmapaalpha));
    toRet=llJsonSetValue(toRet,["ground_passability"],llList2Json(JSON_ARRAY,ground_tiles_passability));
    toRet=llJsonSetValue(toRet,["alpha_passability"],llList2Json(JSON_ARRAY,alpha_tiles_passability));
    toRet=llJsonSetValue(toRet,["ground_size"],(string)suelosize);
    toRet=llJsonSetValue(toRet,["alpha_size"],(string)alphasize);
    return toRet;
}
string map_state = "CLEARED";
default
{
    state_entry(){
        llMessageLinked(LINK_THIS, LINK_CHANNEL_NUMBER, "", MT_DO_RESET);
        map_state="RESETTING";
    }
    link_message(integer sender, integer num, string str, key id) {
        if(num==LINK_CHANNEL_NUMBER){
            if(id==EV_SYSTEM_READY){
                //Se ha iniciado el sistema de pintado de mapas
                //llMessageLinked(LINK_THIS, LINK_CHANNEL_NUMBER, "", MT_DO_RESET);
                llMessageLinked(LINK_THIS, LINK_CHANNEL_NUMBER, "", MT_DO_CLEAR);
                map_state = "CLEARING";
            }else if(id==EV_SYSTEM_DONE){
                //Se ha finalizado de limpiar el mapa
                map_state = "CLEARED";
            }else if(id==EV_SYSTEM_PAINTED){
                //Se ha finalizado de pintar el mapa
                map_state = "PAINTED";
            }
        }
    }
    touch_start(integer num_det){
        if(map_state=="CLEARED"){
            llMessageLinked(LINK_THIS, LINK_CHANNEL_NUMBER, generate_map(), MT_DO_PAINT);
            map_state = "PAINTING";
        }else if(map_state!="CLEARING" && map_state!="PAINTING"){
            llMessageLinked(LINK_THIS, LINK_CHANNEL_NUMBER, "", MT_DO_CLEAR);
            map_state = "CLEARING";
        }
    }
}
// state paint{
//     state_entry(){
//         llOwnerSay("ENTRY  Painting...");
//         llMessageLinked(LINK_THIS, LINK_CHANNEL_NUMBER, generate_map(), MT_DO_PAINT);
//     }
//     link_message(integer sender, integer num, string str, key id) {
//         if(num==LINK_CHANNEL_NUMBER){
//             if(id==EV_SYSTEM_PAINTED){
//                 //Se ha finalizado de pintar el mapa
//                 llOwnerSay("LM  Painted...");
//                 state painted;
//             }
//         }
//     }
// }
// state painted{
//     state_entry(){
//         llOwnerSay("ENTRY  Painted...");
//     }
//     touch_start(integer num){
//         llOwnerSay("TOUCHED  Clearing...");
//         llMessageLinked(LINK_THIS, LINK_CHANNEL_NUMBER, "", MT_DO_CLEAR);
//     }
//     link_message(integer sender, integer num, string str, key id) {
//         if(num==LINK_CHANNEL_NUMBER){
//             if(id==EV_SYSTEM_DONE){
//                 //Se ha finalizado de limpiar el mapa
//                 llOwnerSay("LM  Cleared...");
//                 state cleared;
//             }
//         }
//     }
// }
// state cleared{
//     state_entry(){
//         llOwnerSay("ENTRY  Cleared...");
//     }
//     touch_start(integer num){
//         state paint;
//     }
// }