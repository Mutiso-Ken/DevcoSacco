query 50100 "Portal Activity Breakdown"
{
    QueryType = Normal;
    elements
    {
        dataitem(Portal_Activity_Tracker; "Portal Tracker")
        {
            filter(Date_Filter; "Date") { }
            filter(Interaction_Type_Filter; "Interaction Type") { }
            filter(Gender_Filter; Gender) { }
            column(InteractionType; "Interaction Type") { }
            column(ActivityCount)
            {
                Method = Count;
            }
        }
    }
}

query 50101 "Portal Daily Trend"
{
    QueryType = Normal;
    elements
    {
        dataitem(Portal_Activity_Tracker; "Portal Tracker")
        {
            filter(Date_Filter; "Date") { }
            filter(Interaction_Type_Filter; "Interaction Type") { }
            filter(Gender_Filter; Gender) { }
            column(ActivityDate; "Date") { }
            column(ActivityCount)
            {
                Method = Count;
            }
        }
    }
}

query 50102 "Portal Top Members"
{
    QueryType = Normal;
    TopNumberOfRows = 10;
    OrderBy = descending(ActivityCount);
    elements
    {
        dataitem(Portal_Activity_Tracker; "Portal Tracker")
        {
            filter(Date_Filter; "Date") { }
            filter(Interaction_Type_Filter; "Interaction Type") { }
            filter(Gender_Filter; Gender) { }
            column(MemberNumber; MemberNumber) { }
            column(MemberName; MemberName) { }
            column(ActivityCount)
            {
                Method = Count;
            }
        }
    }
}

query 50103 "Portal Login Distribution"
{
    QueryType = Normal;
    elements
    {
        dataitem(Portal_Activity_Tracker; "Portal Tracker")
        {
            filter(Date_Filter; "Date") { }
            filter(Interaction_Type_Filter; "Interaction Type") { }
            filter(Gender_Filter; Gender) { }
            column(ActivityTime; "Time") { }
            column(ActivityCount)
            {
                Method = Count;
            }
        }
    }
}

query 50104 "Portal KPI Summary"
{
    QueryType = Normal;
    elements
    {
        dataitem(Portal_Activity_Tracker; "Portal Tracker")
        {
            filter(Date_Filter; "Date") { }
            filter(Gender_Filter; Gender) { }
            column(InteractionType; "Interaction Type") { }
            column(MemberNumber; MemberNumber) { }
            column(Gender; Gender) { }
            column(ActivityCount)
            {
                Method = Count;
            }
        }
    }
}

query 50105 "Portal Gender Distribution"
{
    QueryType = Normal;
    elements
    {
        dataitem(Portal_Activity_Tracker; "Portal Tracker")
        {
            filter(Date_Filter; "Date") { }
            filter(Interaction_Type_Filter; "Interaction Type") { }
            column(Gender; Gender) { }
            column(ActivityCount)
            {
                Method = Count;
            }
        }
    }
}