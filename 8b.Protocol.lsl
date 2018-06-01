//CHANNEL
integer LINK_CHANNEL_NUMBER=-348;
//----Events (sent from the system)----
//Sent on initialization
string EV_SYSTEM_READY="eyg_gridmap_ready";
//Sent after receiving and finished processing an clear order
string EV_SYSTEM_DONE="eyg_gridmap_cleared";
//Sent after receiving and finished processing a paint order
string EV_SYSTEM_PAINTED="eyg_gridmap_painted";
//----Method calls (received by the system)----
string MT_DO_RESET="eyg_gridmap_reset";
//Paints a map
string MT_DO_PAINT="eyg_gridmap_paint"; 
//Forces clear the map
string MT_DO_CLEAR="eyg_gridmap_clear";