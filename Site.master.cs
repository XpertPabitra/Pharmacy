using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SiteMaster : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Safety check: Only show the admin buttons if the user is actually an Admin
        if (Session["Role"] != null && Session["Role"].ToString() == "Admin")
        {
            phAdminMenu.Visible = true;
        }
        else
        {
            phAdminMenu.Visible = false;
        }
    }

    // --- Stats Button ---
    protected void BtnNavStats_Click(object sender, EventArgs e)
    {
        // Sends signal to show stats and hide inventory
        Response.Redirect("AdminDashboard.aspx?view=stats");
    }

    // --- Generate Report Button ---
    protected void BtnNavGenReport_Click(object sender, EventArgs e)
    {
        // Sends signal to show report and hide inventory
        Response.Redirect("AdminDashboard.aspx?view=report");
    }

    // --- All Orders Button ---
    protected void BtnNavOrders_Click(object sender, EventArgs e)
    {
        // Default view shows the full inventory/orders list
        Response.Redirect("AdminDashboard.aspx");
    }

    // --- Logout ---
    protected void btnLogout_Click(object sender, EventArgs e)
    {
        Session.Clear();
        Session.Abandon();
        Response.Redirect("Login.aspx");
    }
}