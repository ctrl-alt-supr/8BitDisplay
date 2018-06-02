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
    0,1,2,3,4,5,6,7,
    8,9,10,11,12,13,14,15,
    16,17,18,19,20,21,22,23,
    24,25,26,27,28,29,30,31,
    32,33,34,35,36,37,38,39,
    40,41,42,43,44,45,46,47,
    48,49,50,51,52,53,54,55,
    56,57,58,59,60,61,62,63
];
list ground_map_p1=[
    0,1,2,3,4,5,6,7,
    8,9,10,11,12,13,14,15,
    16,17,18,19,20,21,22,23,
    24,25,26,27,28,29,30,31,
    32,33,34,35,36,37,38,39,
    40,41,42,43,44,45,46,47,
    48,49,50,51,52,53,54,55,
    56,57,58,59,60,61,62,63
];
list ground_map_p2=[
    64,65,66,67,68,69,70,71,
    72,73,74,75,76,77,78,79,
    80,81,82,83,84,85,86,87,
    88,89,90,91,92,93,94,95,
    96,97,98,99,-1,-1,-1,-1,
    -1,-1,-1,-1,-1,-1,-1,-1,
    -1,-1,-1,-1,-1,-1,-1,-1,
    -1,-1,-1,-1,-1,-1,-1,-1
];
list alpha_map_p1=[
    0,1,2,3,4,5,6,7,
    8,9,10,11,12,13,14,15,
    16,17,18,19,20,21,22,23,
    24,25,26,27,28,29,30,31,
    32,33,34,35,36,37,38,39,
    40,41,42,43,44,45,46,47,
    48,49,50,51,52,53,54,55,
    56,57,58,59,60,61,62,63
];
list alpha_map_p2=[
    64,65,66,67,68,69,70,71,
    72,73,74,75,76,77,78,79,
    80,81,82,83,84,85,86,87,
    88,89,90,91,92,93,94,95,
    96,97,98,99,99,99,99,99,
    99,99,99,99,99,99,99,99,
    99,99,99,99,99,99,99,99,
    99,99,99,99,99,99,99,99
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
integer get_osition(integer row, integer col){
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
            if(llList2String(stringparts,0)=="tiles"){
                string numfila= llList2String(stringparts,1);
                string numcolumna= llList2String(stringparts,2);
                integer posenlista= get_osition((integer)numfila,(integer)numcolumna);
                map_linkids = llListReplaceList(map_linkids, [i], posenlista, posenlista);    
            }   
        }   
    }
}
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
// //Given an index of a tile in the grid and a layer, returns the linknumber and face the tile should be painted on.
// list get_tilePos(integer linkNum, integer face){
//     float surface16=((SURFACE_SIZE*2)*2);
//     float surface8=(SURFACE_SIZE*2);
//     integer indexInLinkList=llListFindList(map_linkids,[linkNum]);
//     integer posibleRow=
//     indexInLinkList=row*SURFACE_SIZE+col;
// }
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
    integer cLnumPos=get_osition(llList2Integer(info,0),llList2Integer(info,1));
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
    //llOwnerSay((string)llList2CSV(to_return));
    return to_return;
}
//Paints the map using the current values
paint_map(){
    paint_ground();
    paint_alpha();
    //llMessageLinked(LINK_THIS, LINK_CHANNEL_NUMBER, llList2Json(JSON_ARRAY, baked_passability), EV_SYSTEM_PAINTED);
}

// //linknum_and_face cache
// string tilePosJSON="{}";
// clearCache(){
//     tilePosJSON="{}";
// }
// integer cacheSet=FALSE;
// setCache(integer index, integer layer, list linknum_and_face){
//     string newVal=tilePosJSON;
//     string oldLayerContent=llJsonGetValue(newVal,[(string)layer]);
//     if(oldLayerContent==JSON_INVALID){
//         oldLayerContent="{}";
//     }
//     oldLayerContent=llJsonSetValue(oldLayerContent, [(string)index], llList2Json(JSON_ARRAY, linknum_and_face));
//     newVal=llJsonSetValue(newVal, [(string)layer], oldLayerContent);
//     if(newVal!=JSON_INVALID){
//        tilePosJSON=newVal; 
//        //llOwnerSay(newVal);
//     }
// }
// list getCache(integer index, integer layer){
//     string layerContent=llJsonGetValue(tilePosJSON,[(string)layer]);
//     if(layerContent!=JSON_INVALID){
//         string val=llJsonGetValue(layerContent,[(string)index]);
//         if(val!=JSON_INVALID){
//             return llJson2List(val);
//         }
//     }
//     return [];
// }
integer getIndexOfLinkAndFace(integer linkId, integer face){
    integer i=0;
    for(;i<llGetListLength(ground_map);i++){
        list linkAndFace=getCache(i,ENM_LAYER_ALPHA);
        if(llList2Integer(linkAndFace,0)==linkId && llList2Integer(linkAndFace,1)==face){
            return i;
        }
    }
    for(;i<llGetListLength(ground_map);i++){
        list linkAndFace=getCache(i,ENM_LAYER_GROUND);
        if(llList2Integer(linkAndFace,0)==linkId && llList2Integer(linkAndFace,1)==face){
            return i;
        }
    }
    return -1;
}

list cache_linknum=[];
list cache_face=[];
list cache_linknum2=[];
list cache_face2=[];

integer cacheSet=FALSE;

list getCache(integer index, integer layer){
    if(layer==ENM_LAYER_GROUND){
        return [llList2Integer(cache_linknum,index),llList2Integer(cache_face,index)];
    }else if(layer==ENM_LAYER_ALPHA){
        return [llList2Integer(cache_linknum2,index),llList2Integer(cache_face2,index)];
    }
    
    return [];
}

clearCache(){
    cacheSet=FALSE;
    cache_linknum=[];
    cache_linknum2=[];
    cache_face=[];
    cache_face2=[];
}

//Paints only the ground and bakes passability
paint_ground(){
    clearCache();
    integer i=0;
    list toSet=[];
    list toSet2=[];
    string tilesetName=ground_tiles;
    if(current_layer==ENM_LAYER_ALPHA){
        tilesetName=alpha_tiles;
    }
    for(;i<llGetListLength(ground_map);i++){
        integer ctile=llList2Integer( ground_map,i); 
        list link_and_face=get_linknum_and_face(i,ENM_LAYER_GROUND);
        if(!cacheSet){
            cache_linknum+=llList2Integer(link_and_face,0);
            cache_face+=llList2Integer(link_and_face,1);
            //setCache(i,ENM_LAYER_GROUND, link_and_face);
            toSet+=get_params_for(tilesetName, llList2Integer(link_and_face,0),llList2Integer(link_and_face,1),ctile, (integer)(ground_size.x), (integer)(ground_size.y));
        }
    }
    //llOwnerSay((string)i);
    llSetLinkPrimitiveParamsFast(2,toSet);
    //llSetLinkPrimitiveParamsFast(2,toSet2);
}
//Paints only the alpha layer and bakes passability
paint_alpha(){
    integer i=0;
    list toSet=[];
    list toSet2=[];
    for(;i<llGetListLength(alpha_map);i++){
        integer ctile=llList2Integer( alpha_map,i); 
        list link_and_face=get_linknum_and_face(i,ENM_LAYER_ALPHA);
        if(i+(i*2*current_page)==current_tileId){
            //llOwnerSay("wiiii "+(string)i);
            if(!cacheSet){
                cache_linknum2+=llList2Integer(link_and_face,0);
                cache_face2+=llList2Integer(link_and_face,1);
                //setCache(i,ENM_LAYER_ALPHA, link_and_face);
            }
            integer tileset_cols=(integer)(ground_size.x);
            integer tileset_rows=(integer)(ground_size.y);
            vector textureOffset=ZERO_VECTOR;
            vector scaleRepeats=ZERO_VECTOR;
            scaleRepeats.x=1.0/tileset_cols;
            scaleRepeats.y=1.0/tileset_rows;
            
            integer xN = (0) % tileset_cols;
            integer yN = (0) / tileset_cols;
            float xOffset = -0.5 + 0.5/tileset_cols + (float) xN / (float) tileset_cols;
            float yOffset = 0.5 - 0.5/tileset_rows - (float) yN / (float) tileset_rows;
            textureOffset=<xOffset,yOffset,0>;

            toSet+= [PRIM_LINK_TARGET, llList2Integer(link_and_face,0), PRIM_TEXTURE, llList2Integer(link_and_face,1), sel_tiles, scaleRepeats, textureOffset, 0];
        }else{
            if(!cacheSet){
                cache_linknum2+=llList2Integer(link_and_face,0);
                cache_face2+=llList2Integer(link_and_face,1);
                //setCache(i,ENM_LAYER_ALPHA, link_and_face);
            }
            //setCache(i,ENM_LAYER_ALPHA, link_and_face);
            toSet+=[PRIM_LINK_TARGET, llList2Integer(link_and_face,0), PRIM_TEXTURE, llList2Integer(link_and_face,1), TEXTURE_TRANSPARENT, <1,1,0>, <0,0,0>, 0];
        }
    }
    cacheSet=TRUE;
    llSetLinkPrimitiveParamsFast(2,toSet);
    llSetLinkPrimitiveParamsFast(2,toSet2);
}
//Clears up the screen and sets it to elColor.
clear_screen(vector elColor){
    integer i=0;
    list toSet=[];
    //llOwnerSay((string)llGetListLength(ground_map));
    for(;i<llGetListLength(alpha_map);i++){
        list link_and_face=get_linknum_and_face(i,ENM_LAYER_ALPHA);
        if(elColor==ZERO_VECTOR){
                toSet+=[PRIM_LINK_TARGET, llList2Integer(link_and_face,0), PRIM_TEXTURE, llList2Integer(link_and_face,1), TEXTURE_TRANSPARENT, <1,1,0>, <0,0,0>, 0];

        }else{
                toSet+=[PRIM_LINK_TARGET, llList2Integer(link_and_face,0), PRIM_TEXTURE, llList2Integer(link_and_face,1), TEXTURE_TRANSPARENT, <1,1,0>, <0,0,0>, 0,PRIM_COLOR,llList2Integer(link_and_face,0),elColor,0];

        }
    }
    i=0;
    for(;i<llGetListLength(ground_map);i++){
        list link_and_face=get_linknum_and_face(i,ENM_LAYER_GROUND);
        if(elColor==ZERO_VECTOR){

                toSet+=[PRIM_LINK_TARGET, llList2Integer(link_and_face,0), PRIM_TEXTURE, llList2Integer(link_and_face,1), TEXTURE_TRANSPARENT, <1,1,0>, <0,0,0>, 0];

        }else{

                toSet+=[PRIM_LINK_TARGET, llList2Integer(link_and_face,0), PRIM_TEXTURE, llList2Integer(link_and_face,1), TEXTURE_TRANSPARENT, <1,1,0>, <0,0,0>, 0,PRIM_COLOR,llList2Integer(link_and_face,0),elColor,0];

        }
    }
    llSetLinkPrimitiveParamsFast(2,toSet);
    //llSleep(0.02);
    //llSetLinkPrimitiveParamsFast(2,toSet2);
    //llMessageLinked(LINK_THIS, LINK_CHANNEL_NUMBER, "", EV_SYSTEM_DONE);
}
integer current_layer=0;
integer current_page=0;
integer current_tileId=0;
integer current_tile=0;
update_display(){
    if(current_page==1){
        if(current_layer == ENM_LAYER_GROUND){
            ground_map=ground_map_p2;
        }else{
            ground_map=alpha_map_p2;
        }
    }else if(current_page==0){
        if(current_layer == ENM_LAYER_GROUND){
            ground_map=ground_map_p1;
        }else{
            ground_map=alpha_map_p1;
        }
    }
}
default{
    state_entry(){
        //Overrides the surface size SURFACE_SIZE
        SURFACE_SIZE=4;
        scan_linkset();
        current_page=0;
        llSleep(0.02);
        paint_map();
    }
    touch_end(integer num_det){
        integer touchLinkNum = llDetectedLinkNumber(0);
        string touchName = llGetLinkName(touchLinkNum);
        if(startswith(touchName,"tiles")){
            integer touchFace = llDetectedTouchFace(0);
            vector  touchST   = llDetectedTouchST(0);
            if (!(touchST == TOUCH_INVALID_TEXCOORD)){
                integer selectedIndex=getIndexOfLinkAndFace(touchLinkNum,touchFace);
                current_tileId=selectedIndex+(selectedIndex*2*current_page);
                paint_alpha();
                //llOwnerSay((string)touchLinkNum+"  "+(string)touchFace+"  "+(string)getIndexOfLinkAndFace(touchLinkNum,touchFace));
            }
        }
    }
    link_message(integer source, integer num, string str, key id){
        if(source!=llGetLinkNumber() && num==UI_EVENT_NUMBER){
            if(startswith((string)id,"scr")){
                list evTypeAndPars = llParseString2List(str, ["~"],[]);
                if(llGetListLength(evTypeAndPars)>1){
                    string evType=llList2String(evTypeAndPars,0);
                    if(evType==UI_EVENT_TYPE_CHANGED){
                        //llOwnerSay("INTERNALCHANGE");
                        list evPars = llParseString2List(llList2String(evTypeAndPars,1), ["|"],[]);
                        if(llGetListLength(evPars)>=2){
                            string newVal=llList2String(evPars,1);
                            //llOwnerSay(newVal);
                            if((float)newVal>0.5){
                                if(current_page==0){
                                    current_page=1;
                                }
                            }else{
                                if(current_page==1){
                                    current_page=0;
                                }
                            }
                            update_display();
                            paint_map();
                        }
                    }
                }
            }else if(startswith((string)id,"tab")){
                list evTypeAndPars = llParseString2List(str, ["~"],[]);
                if(llGetListLength(evTypeAndPars)>1){
                    string evType=llList2String(evTypeAndPars,0);
                    if(evType==UI_EVENT_TYPE_CHANGED){
                        list evPars = llParseString2List(llList2String(evTypeAndPars,1), ["|"],[]);
                        if(llGetListLength(evPars)>=2){
                            string newVal=llList2String(evPars,1);
                            if(newVal=="1"){
                                
                                list comIdLst=llParseString2List(id,["^"],[]);
                                if(llList2String(comIdLst,1)=="tabGround_tabLayersGroup"){
                                    current_layer = ENM_LAYER_GROUND;
                                    //llOwnerSay((string)current_layer);
                                }else if(llList2String(comIdLst,1)=="tabAlpha_tabLayersGroup"){
                                    current_layer = ENM_LAYER_ALPHA;
                                    //llOwnerSay((string)current_layer);
                                }
                                update_display();
                                paint_map();
                            }
                        }
                    }
                }
            }
        }
    }
}