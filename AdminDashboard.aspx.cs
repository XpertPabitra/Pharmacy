using System;
using System.Data;
using System.Data.SqlClient;
using System.Text; // Required for StringBuilder
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class AdminDashboard : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // 1. SECURITY: Only allow Admins
        if (Session["Role"] == null || Session["Role"].ToString() != "Admin")
        {
            Response.Redirect("Login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            lblAdminName.Text = Session["Username"] != null ? Session["Username"].ToString() : "Admin";

            // Initial data loads
            LoadDashboardStats();
            BindGrid();

            // 2. LISTEN FOR SIGNALS FROM NAV BAR (Master Page)
            // This catches the ?view=report or ?view=stats from the Master Page
            string view = Request.QueryString["view"];
            if (view == "report")
            {
                GenerateReport();
            }
        }
    }

    // --- NEW: Stats Loading Logic ---
    private void LoadDashboardStats()
    {
        try
        {
            using (SqlConnection conn = DBManager.GetConnection())
            {
                // Sub-queries to get all 3 counts in one trip to the database
                string sql = "SELECT " +
                             "(SELECT ISNULL(SUM(Quantity * PriceAtTimeOfOrder), 0) FROM Orders WHERE PaymentStatus='Success') as Revenue, " +
                             "(SELECT COUNT(*) FROM Medicines) as TotalMed, " +
                             "(SELECT COUNT(*) FROM Medicines WHERE QuantityInStock < 10) as LowStock";

                SqlCommand cmd = new SqlCommand(sql, conn);
                if (conn.State == ConnectionState.Closed) conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    lblTotalRevenue.Text = string.Format("₹{0:N2}", dr["Revenue"]);
                    lblStockCount.Text = dr["TotalMed"].ToString();
                    lblLowStockCount.Text = dr["LowStock"].ToString();
                }
            }
        }
        catch { /* Handle database errors silently or log them */ }
    }

    // --- NEW: Report Generation Logic ---
    protected void GenerateReport()
    {
        using (SqlConnection conn = DBManager.GetConnection())
        {
            string sql = "SELECT Name, Price, QuantityInStock FROM Medicines ORDER BY QuantityInStock ASC";
            SqlDataAdapter da = new SqlDataAdapter(sql, conn);
            DataTable dt = new DataTable();
            da.Fill(dt);

            StringBuilder sb = new StringBuilder();
            sb.Append("<table class='w-full border-collapse text-left text-xs'>");
            sb.Append("<tr class='bg-gray-100 border-b'><th class='p-3'>Medicine Name</th><th class='p-3'>Price</th><th class='p-3'>Current Stock</th></tr>");

            foreach (DataRow row in dt.Rows)
            {
                int stock = Convert.ToInt32(row["QuantityInStock"]);
                string rowStyle = stock < 10 ? "text-red-600 font-bold bg-red-50" : "text-gray-700";

                sb.Append("<tr class='border-b " + rowStyle + "'>");
                sb.Append("<td class='p-3'>" + row["Name"] + "</td>");
                sb.Append("<td class='p-3'>₹" + string.Format("{0:N2}", row["Price"]) + "</td>");
                sb.Append("<td class='p-3'>" + stock + " " + (stock < 10 ? "(Low)" : "") + "</td>");
                sb.Append("</tr>");
            }
            sb.Append("</table>");

            litReportContent.Text = sb.ToString();
            pnlReport.Visible = true; // Show the panel
        }
    }

    protected void BtnCloseReport_Click(object sender, EventArgs e)
    {
        pnlReport.Visible = false;
    }

    // --- READ: Load the Inventory into the Grid ---
    private void BindGrid()
    {
        using (SqlConnection conn = DBManager.GetConnection())
        {
            string query = "SELECT MedicineID, Name, Price, QuantityInStock FROM Medicines ORDER BY MedicineID DESC";
            SqlDataAdapter da = new SqlDataAdapter(query, conn);
            DataTable dt = new DataTable();
            da.Fill(dt);
            gvInventory.DataSource = dt;
            gvInventory.DataBind();
        }
    }

    // --- INSERT: Add New Medicine ---
    protected void btnAddMed_Click(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(newName.Text) || string.IsNullOrEmpty(newPrice.Text))
        {
            ShowStatus("Please fill all fields!", "bg-red-100 text-red-700");
            return;
        }

        try
        {
            using (SqlConnection conn = DBManager.GetConnection())
            {
                string sql = "INSERT INTO Medicines (Name, Price, QuantityInStock, Description) VALUES (@name, @price, @qty, 'No Description')";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@name", newName.Text.Trim());
                cmd.Parameters.AddWithValue("@price", Convert.ToDecimal(newPrice.Text));
                cmd.Parameters.AddWithValue("@qty", Convert.ToInt32(newQty.Text));
                cmd.ExecuteNonQuery();
            }

            newName.Text = ""; newPrice.Text = ""; newQty.Text = "0";
            ShowStatus("✅ Product Added Successfully!", "bg-emerald-100 text-emerald-700");

            // REFRESH Stats and Grid
            LoadDashboardStats();
            BindGrid();
        }
        catch (Exception ex) { ShowStatus("Error: " + ex.Message, "bg-red-100 text-red-700"); }
    }

    // --- UPDATE: Edit existing stock ---
    protected void gvInventory_RowEditing(object sender, GridViewEditEventArgs e)
    {
        gvInventory.EditIndex = e.NewEditIndex;
        BindGrid();
    }

    protected void gvInventory_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
    {
        gvInventory.EditIndex = -1;
        BindGrid();
    }

    protected void gvInventory_RowUpdating(object sender, GridViewUpdateEventArgs e)
    {
        int medID = Convert.ToInt32(gvInventory.DataKeys[e.RowIndex].Value);
        TextBox tName = (TextBox)gvInventory.Rows[e.RowIndex].FindControl("txtEditName");
        TextBox tPrice = (TextBox)gvInventory.Rows[e.RowIndex].FindControl("txtEditPrice");
        TextBox tQty = (TextBox)gvInventory.Rows[e.RowIndex].FindControl("txtEditQty");

        try
        {
            using (SqlConnection conn = DBManager.GetConnection())
            {
                string sql = "UPDATE Medicines SET Name=@name, Price=@price, QuantityInStock=@qty WHERE MedicineID=@id";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@id", medID);
                cmd.Parameters.AddWithValue("@name", tName.Text.Trim());
                cmd.Parameters.AddWithValue("@price", Convert.ToDecimal(tPrice.Text));
                cmd.Parameters.AddWithValue("@qty", Convert.ToInt32(tQty.Text));
                cmd.ExecuteNonQuery();
            }
            gvInventory.EditIndex = -1;
            ShowStatus("📝 Medicine Updated!", "bg-blue-100 text-blue-700");

            LoadDashboardStats(); // Refresh Stats
            BindGrid();
        }
        catch (Exception ex) { ShowStatus(ex.Message, "bg-red-100 text-red-700"); }
    }

    // --- DELETE: Remove medicine from DB ---
    protected void gvInventory_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        int medID = Convert.ToInt32(gvInventory.DataKeys[e.RowIndex].Value);
        try
        {
            using (SqlConnection conn = DBManager.GetConnection())
            {
                string sql = "DELETE FROM Medicines WHERE MedicineID=@id";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@id", medID);
                cmd.ExecuteNonQuery();
            }
            ShowStatus("🗑️ Medicine Deleted!", "bg-gray-100 text-gray-700");
            LoadDashboardStats(); // Refresh Stats
            BindGrid();
        }
        catch { ShowStatus("An error occurred.", "bg-red-100 text-red-700"); }
    }

    private void ShowStatus(string msg, string css)
    {
        lblStatus.Text = msg;
        lblStatus.CssClass = "px-4 py-2 rounded-lg text-sm font-bold " + css;
        lblStatus.Style["display"] = "inline-block"; // Make sure it shows up
    }
}