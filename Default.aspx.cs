using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

public partial class _Default : Page
{
    // Connection string from web.config
    string connStr = ConfigurationManager.ConnectionStrings["PharmacyDB"].ConnectionString;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindDashboardStats();
        }
    }

    private void BindDashboardStats()
    {
        using (SqlConnection con = new SqlConnection(connStr))
        {
            con.Open();

            // Total Customers
            using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Customers", con))
            {
                int totalCustomers = (int)cmd.ExecuteScalar();
                lblTotalCustomers.Text = totalCustomers.ToString();
            }

            // Total Orders
            using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Orders", con))
            {
                int totalOrders = (int)cmd.ExecuteScalar();
                lblTotalOrders.Text = totalOrders.ToString();
            }

            // Total Medicines
            using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM Medicines", con))
            {
                int totalMedicines = (int)cmd.ExecuteScalar();
                lblTotalMedicines.Text = totalMedicines.ToString();
            }
        }
    }
}