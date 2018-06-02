integer string_contains(string haystack, string needle) 
{
    return 0 <= llSubStringIndex(haystack, needle);
}
integer startswith(string haystack, string needle)
{
    return llDeleteSubString(haystack, llStringLength(needle), 0x7FFFFFF0) == needle;
}
integer endswith(string haystack, string needle)
{
    return llDeleteSubString(haystack, 0x8000000F, ~llStringLength(needle)) == needle;
}