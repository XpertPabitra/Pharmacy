using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web.UI.WebControls;

public partial class DistributorPanel : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // 1. Security check: Prevent NullReferenceException by checking nulls first
        if (Session["UserID"] == null || Session["Role"] == null)
        {
            Response.Redirect("Login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            // 2. Set the Identity Display
            lblDistName.Text = Session["Username"].ToString();

            // 3. Call the method (This is the one that was missing!)
            BindPendingOrders();
        }
    }

    // THIS IS THE MISSING METHOD
    private void BindPendingOrders()
    {
        try
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["PharmacyDB"].ConnectionString))
            {
                // UPDATED QUERY TO MATCH YOUR SCHEMA:
                // 1. Table is 'Customers', Column is 'Name'
                // 2. Table is 'Medicines', Column is 'Name'
                string sql = @"
                SELECT 
                    o.OrderID, 
                    c.Name AS CustomerName, 
                    m.Name AS MedicineName, 
                    o.Quantity, 
                    o.OrderStatus 
                FROM Orders o
                INNER JOIN Customers c ON o.CustomerID = c.CustomerID
                INNER JOIN Medicines m ON o.MedicineID = m.MedicineID
                WHERE o.OrderStatus = 'Pending' OR o.OrderStatus = 'Paid'";

                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    gvPendingOrders.DataSource = dt;
                    gvPendingOrders.DataBind();
                    pnlNoOrders.Visible = false;
                }
                else
                {
                    gvPendingOrders.DataSource = null;
                    gvPendingOrders.DataBind();
                    pnlNoOrders.Visible = true;
                }
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = "Error: " + ex.Message;
            lblStatus.CssClass = "block p-4 mb-6 rounded-xl font-bold text-center bg-red-100 text-red-700";
            lblStatus.Visible = true;
        }
    }
    protected void gvPendingOrders_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Distribute")
        {
            int orderId = Convert.ToInt32(e.CommandArgument);
            UpdateOrderStatus(orderId);
        }
    }

    private void UpdateOrderStatus(int orderId)
    {
        try
        {
            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["PharmacyDB"].ConnectionString))
            {
                SqlCommand cmd = new SqlCommand("sp_DistributeOrder", conn);
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@OrderID", orderId);

                conn.Open();
                cmd.ExecuteNonQuery();

                lblStatus.Text = "✅ Order #" + orderId + " successfully distributed!";
                lblStatus.CssClass = "block p-4 mb-6 rounded-xl font-bold text-center bg-orange-100 text-orange-700";
                lblStatus.Visible = true;

                BindPendingOrders(); // Refresh the grid
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = "Update failed: " + ex.Message;
            lblStatus.Visible = true;
        }
    }
}