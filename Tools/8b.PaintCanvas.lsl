#include "UI.Protocol"
#include "8b.Protocol"
#include "8b.Common"
#include "8b.Faces"

//////  VARIABLES  ///////////////////////////////////////////////////////////////////////////
//Size of the ground grid
vector ground_size=<10,10,0>;
//Size of the alpha grid
vector alpha_size=<10,10,0>;
//Name of the ground tile texture
string ground_tiles="base_ground";
//Name of the alpha tile texture
string alpha_tiles="base_alpha";
//Name of the selection tile texture
string sel_tiles="base_sel";

list map_linkids=[
    -1,-1,-1,-1,
    -1,-1,-1,-1,
    -1,-1,-1,-1,
    -1,-1,-1,-1    
];
//List containing the tiles to paint in the ground layer
list ground_map=[
    43,43,43,43,43,43,43,43,
    43,43,43,43,43,43,43,43,
    43,43,43,43,43,43,43,43,
    43,43,43,43,43,43,43,43,
    43,43,43,43,43,43,43,43,
    43,43,43,43,43,43,43,43,
    43,43,43,43,43,43,43,43,
    43,43,43,43,43,43,43,43
];
//List containing the tiles to paint in the alpha layer
list alpha_map=[
    99,99,99,99,99,99,99,99,
    99,99,99,99,99,99,99,99,
    99,99,99,99,99,99,99,99,
    99,99,99,99,99,99,99,99,
    99,99,99,99,99,99,99,99,
    99,99,99,99,99,99,99,99,
    99,99,99,99,99,99,99,99,
    99,99,99,99,99,99,99,99
];
//////  FUNCTIONS  ///////////////////////////////////////////////////////////////////////////
//Returns the index in a map_linkids for an specified row and column of the map grid.
integer get_grid_position(integer row, integer col){
    return row*SURFACE_SIZE+col;
}
//Scans the linkset and adds each needed prim to its position in the map_linkids list
scan_linkset(){
    integer count=llGetNumberOfPrims();
    integer i=0;
    for(;i<=count;i++){
        string currprimname=llGetLinkName(i); 
        if(string_contains(currprimname,":")){
            list stringparts=llParseString2List(currprimname,[":"],[]);
            if(llList2String(stringparts,0)=="canvas"){
                string numfila= llList2String(stringparts,1);
                string numcolumna= llList2String(stringparts,2);
                integer posenlista= get_grid_position((integer)numfila,(integer)numcolumna);
                map_linkids = llListReplaceList(map_linkids, [i], posenlista, posenlista);            
            }ç
        }   
    }
}
//  integer get_pasability_for(integer listpos, integer layer){
//     list la_lista_a_usar=[];
//     if(layer==ENM_LAYER_GROUND){
//         la_lista_a_usar=ground_tiles_passability;
//     }else if(layer==ENM_LAYER_ALPHA){
//         la_lista_a_usar=alpha_tiles_passability;
//     }
//     return llList2Integer(la_lista_a_usar, listpos);
// }
//Given a link number, face and tile to paint, returns the list needed to set the appropiate params through llSetLinkPrimitiveParamsFast
list get_params_for(string tilesetname, integer linkid, integer face, integer tile_number, integer tileset_cols, integer tileset_rows){
    vector textureOffset=ZERO_VECTOR;
    vector scaleRepeats=ZERO_VECTOR;
    scaleRepeats.x=1.0/tileset_cols;
    scaleRepeats.y=1.0/tileset_rows;
    
    integer xN = (tile_number) % tileset_cols;
    integer yN = (tile_number) / tileset_cols;
    float xOffset = -0.5 + 0.5/tileset_cols + (float) xN / (float) tileset_cols;
    float yOffset = 0.5 - 0.5/tileset_rows - (float) yN / (float) tileset_rows;
    textureOffset=<xOffset,yOffset,0>;

    return [PRIM_LINK_TARGET, linkid, PRIM_TEXTURE, face, tilesetname, scaleRepeats, textureOffset, 0];
}
//Given an index of a tile in the grid and a layer, returns the linknumber and face the tile should be painted on.
list get_linknum_and_face(integer tilePos, integer layer){
    //list cached=getCache(tilePos, layer);
    //if(llGetListLength(cached)>0){
    //    return cached;
    //}
    list to_return=[];
    float surface16=((SURFACE_SIZE*2)*2);
    float surface8=(SURFACE_SIZE*2);
    
    float filaToRet=(float)tilePos/surface16;
    float resto=filaToRet-(float)((integer)filaToRet);
    float step=(float)resto*surface16;
    float subfilaToRet=(float)step/surface8;
    float restoSub=subfilaToRet-((integer)subfilaToRet);
    float oprest=restoSub*surface8;
    
    float colToRet=(float)oprest/2.0;
    float restoSub2=(float)colToRet-(float)((integer)colToRet);
    float step2=(float)restoSub2*2;
    float subcolToRet= (float)step2;
    
    list recparts=llParseString2List((string)filaToRet,["."],[]);
    integer iR=llList2Integer(recparts,0);
    list recparts2=llParseString2List((string)colToRet,["."],[]);
    integer iR2=llList2Integer(recparts2,0);
    list info = [(integer)iR,(integer)iR2,subfilaToRet,subcolToRet];
    
    //Se obtiene el link number
    integer cLnumPos=get_grid_position(llList2Integer(info,0),llList2Integer(info,1));
    to_return+=llList2Integer(map_linkids,cLnumPos);
    
    //Se obtiene la cara
    string recR=llList2String(info,2);
    recparts=llParseString2List(recR,["."],[]);
    
    iR=llList2Integer(recparts,0);
    float iC=llList2Float(info,3);
    if(iR==0){
        if(iC==0){
            if(layer==0)
                to_return+=GROUND_FACE_1;  
            else
                to_return+=ALPHA_FACE_1;  
        }else{
            if(layer==0)
                to_return+=GROUND_FACE_2;  
            else
                to_return+=ALPHA_FACE_2;  
        }  
    }else{
        if(iC==0){
            if(layer==0)
                to_return+=GROUND_FACE_3;  
            else
                to_return+=ALPHA_FACE_3;      
        }else{
            if(layer==0)
                to_return+=GROUND_FACE_4;  
            else
                to_return+=ALPHA_FACE_4;  
        }  
    }
    //setCache(tilePos, layer, to_return);
    //Se devuelve la lista
    return to_return;
}
//Paints the map using the current values
paint_map(){
    
   // baked_passability=[];
    paint_ground();
    paint_alpha();
   // llMessageLinked(LINK_THIS, LINK_CHANNEL_NUMBER, llList2Json(JSON_ARRAY, baked_passability), EV_SYSTEM_PAINTED);
}
//Paints only the ground and bakes passability
paint_ground(){
    integer i=0;
    list toSet=[];
    list toSet2=[];
    for(;i<llGetListLength(ground_map);i++){
        integer ctile=llList2Integer( ground_map,i); 
        //baked_passability+=get_pasability_for(ctile,ENM_LAYER_GROUND);
        list link_and_face=get_linknum_and_face(i,ENM_LAYER_GROUND);
        if(i%2==0){
            toSet+=get_params_for(ground_tiles, llList2Integer(link_and_face,0),llList2Integer(link_and_face,1),ctile, (integer)(ground_size.x), (integer)(ground_size.y));
        }else{
            toSet2+=get_params_for(ground_tiles, llList2Integer(link_and_face,0),llList2Integer(link_and_face,1),ctile, (integer)(ground_size.x), (integer)(ground_size.y));
        }
    }
    //llOwnerSay((string)i);
    llSetLinkPrimitiveParamsFast(2,toSet);
    llSetLinkPrimitiveParamsFast(2,toSet2);
}
//Paints only the alpha layer and bakes passability
paint_alpha(){
    integer i=0;
    list toSet=[];
    list toSet2=[];
    for(;i<llGetListLength(alpha_map);i++){
        integer ctile=llList2Integer( alpha_map,i); 
        //baked_passability=llListReplaceList(baked_passability, [llList2Integer(baked_passability, i) && get_pasability_for(ctile,ENM_LAYER_ALPHA)], i, i);
        list link_and_face=get_linknum_and_face(i,ENM_LAYER_ALPHA);
        if(i%2==0){
            toSet+=get_params_for(alpha_tiles, llList2Integer(link_and_face,0),llList2Integer(link_and_face,1),ctile, (integer)(alpha_size.x), (integer)(alpha_size.y));
        }else{
            toSet2+=get_params_for(alpha_tiles, llList2Integer(link_and_face,0),llList2Integer(link_and_face,1),ctile, (integer)(alpha_size.x), (integer)(alpha_size.y));           
        }
    }
    
    llSetLinkPrimitiveParamsFast(2,toSet);
    llSetLinkPrimitiveParamsFast(2,toSet2);
}
//Clears up the screen and sets it to elColor.
clear_screen(vector elColor){
    integer i=0;
    list toSet=[];
    list toSet2=[];
    //llOwnerSay((string)llGetListLength(ground_map));
    for(;i<llGetListLength(alpha_map);i++){
        list link_and_face=get_linknum_and_face(i,ENM_LAYER_ALPHA);
        if(elColor==ZERO_VECTOR){
            if(i%2==0){
                toSet+=[PRIM_LINK_TARGET, llList2Integer(link_and_face,0), PRIM_TEXTURE, llList2Integer(link_and_face,1), TEXTURE_TRANSPARENT, <1,1,0>, <0,0,0>, 0];
            }else{
                toSet2+=[PRIM_LINK_TARGET, llList2Integer(link_and_face,0), PRIM_TEXTURE, llList2Integer(link_and_face,1), TEXTURE_TRANSPARENT, <1,1,0>, <0,0,0>, 0];
            }
        }else{
            if(i%2==0){
                toSet+=[PRIM_LINK_TARGET, llList2Integer(link_and_face,0), PRIM_TEXTURE, llList2Integer(link_and_face,1), TEXTURE_TRANSPARENT, <1,1,0>, <0,0,0>, 0,PRIM_COLOR,llList2Integer(link_and_face,0),elColor,0];
            }else{
                toSet2+=[PRIM_LINK_TARGET, llList2Integer(link_and_face,0), PRIM_TEXTURE, llList2Integer(link_and_face,1), TEXTURE_TRANSPARENT, <1,1,0>, <0,0,0>, 0,PRIM_COLOR,llList2Integer(link_and_face,0),elColor,0];
            }
        }
    }
    i=0;
    for(;i<llGetListLength(ground_map);i++){
        list link_and_face=get_linknum_and_face(i,ENM_LAYER_GROUND);
        if(elColor==ZERO_VECTOR){
            if(i%2==0){
                toSet+=[PRIM_LINK_TARGET, llList2Integer(link_and_face,0), PRIM_TEXTURE, llList2Integer(link_and_face,1), TEXTURE_TRANSPARENT, <1,1,0>, <0,0,0>, 0];
            }else{
                toSet2+=[PRIM_LINK_TARGET, llList2Integer(link_and_face,0), PRIM_TEXTURE, llList2Integer(link_and_face,1), TEXTURE_TRANSPARENT, <1,1,0>, <0,0,0>, 0];
            }
        }else{
            if(i%2==0){
                toSet+=[PRIM_LINK_TARGET, llList2Integer(link_and_face,0), PRIM_TEXTURE, llList2Integer(link_and_face,1), TEXTURE_TRANSPARENT, <1,1,0>, <0,0,0>, 0,PRIM_COLOR,llList2Integer(link_and_face,0),elColor,0];
            }else{
                toSet2+=[PRIM_LINK_TARGET, llList2Integer(link_and_face,0), PRIM_TEXTURE, llList2Integer(link_and_face,1), TEXTURE_TRANSPARENT, <1,1,0>, <0,0,0>, 0,PRIM_COLOR,llList2Integer(link_and_face,0),elColor,0];
            }
        }
    }
    llSetLinkPrimitiveParamsFast(2,toSet);
    //llSleep(0.02);
    llSetLinkPrimitiveParamsFast(2,toSet2);
    llMessageLinked(LINK_THIS, LINK_CHANNEL_NUMBER, "", EV_SYSTEM_DONE);
}

default{
    state_entry(){
        //clearCache();
        scan_linkset();
        llMessageLinked(LINK_THIS, LINK_CHANNEL_NUMBER, "", EV_SYSTEM_READY);
    }
    link_message(integer sender, integer num, string str, key id) {
        if(num==LINK_CHANNEL_NUMBER){
            if(id==MT_DO_RESET){
                llResetScript();
            }if(id==MT_DO_PAINT){
                if(str!=""){
                   
                    paint_map();
                }
            }if(id==MT_DO_CLEAR){
                if(str!=""){
                    clear_screen((vector)str);
                }else{
                    clear_screen(ZERO_VECTOR);
                }
            }
        }
    }
}