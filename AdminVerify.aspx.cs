using System;
using System.Data;
using System.Data.SqlClient;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class AdminVerify : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDashboardStats();
            BindPendingOrders();
        }
    }

    // 1. Load the Statistics at the top of the page
    private void LoadDashboardStats()
    {
        using (SqlConnection conn = DBManager.GetConnection())
        {
            // Standard concatenation for C# 5.0
            string sql = "SELECT " +
                         "SUM(CASE WHEN PaymentStatus = 'Success' THEN (Quantity * PriceAtTimeOfOrder) ELSE 0 END) as TotalRevenue, " +
                         "COUNT(CASE WHEN PaymentStatus = 'Pending' THEN 1 END) as PendingCount, " +
                         "COUNT(CASE WHEN PaymentStatus = 'Success' THEN 1 END) as ApprovedCount " +
                         "FROM [Orders]";

            SqlCommand cmd = new SqlCommand(sql, conn);
            if (conn.State == ConnectionState.Closed) conn.Open();
            SqlDataReader dr = cmd.ExecuteReader();

            if (dr.Read())
            {
                decimal revenue = dr["TotalRevenue"] != DBNull.Value ? Convert.ToDecimal(dr["TotalRevenue"]) : 0;

                // Using string.Format instead of interpolated strings
                lblTotalRevenue.Text = string.Format("₹{0:N2}", revenue);
                lblPendingCount.Text = dr["PendingCount"].ToString();
                lblApprovedCount.Text = dr["ApprovedCount"].ToString();
            }
        }
    }

    // 2. Bind the GridView with Pending Orders
    private void BindPendingOrders()
    {
        using (SqlConnection conn = DBManager.GetConnection())
        {
            if (conn.State == ConnectionState.Closed) conn.Open();

            string sql = "SELECT o.OrderID, c.Name as Username, o.UTRNumber, " +
                         "(o.Quantity * o.PriceAtTimeOfOrder) as TotalAmount " +
                         "FROM [Orders] o " +
                         "JOIN [Customers] c ON o.CustomerID = c.CustomerID " +
                         "WHERE o.PaymentStatus = 'Pending'";

            SqlDataAdapter da = new SqlDataAdapter(sql, conn);
            DataTable dt = new DataTable();
            da.Fill(dt);

            gvPendingOrders.DataSource = (dt.Rows.Count > 0) ? dt : null;
            gvPendingOrders.DataBind();
            pnlEmpty.Visible = (dt.Rows.Count == 0);
        }
    }

    // 3. Handle Approve/Reject Commands (PascalCase)
    protected void GvPendingOrders_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        string orderId = e.CommandArgument.ToString();
        string newStatus = "";

        if (e.CommandName == "ApproveOrder") newStatus = "Success";
        else if (e.CommandName == "RejectOrder") newStatus = "Failed";

        if (!string.IsNullOrEmpty(newStatus))
        {
            using (SqlConnection conn = DBManager.GetConnection())
            {
                if (conn.State == ConnectionState.Closed) conn.Open();
                string sql = "UPDATE Orders SET PaymentStatus = @status WHERE OrderID = @oid";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@status", newStatus);
                cmd.Parameters.AddWithValue("@oid", orderId);
                cmd.ExecuteNonQuery();
            }

            // Refresh everything
            LoadDashboardStats();
            BindPendingOrders();
        }
    }

    // 4. Generate Detailed HTML Report
    protected void BtnGenReport_Click(object sender, EventArgs e)
    {
        using (SqlConnection conn = DBManager.GetConnection())
        {
            string sql = "SELECT o.OrderID, c.Name as Customer, m.Name as Medicine, o.Quantity, " +
                         "(o.Quantity * o.PriceAtTimeOfOrder) as Amount, o.PaymentStatus, o.OrderDate " +
                         "FROM Orders o " +
                         "JOIN Customers c ON o.CustomerID = c.CustomerID " +
                         "JOIN Medicines m ON o.MedicineID = m.MedicineID " +
                         "ORDER BY o.OrderDate DESC";

            SqlDataAdapter da = new SqlDataAdapter(sql, conn);
            DataTable dt = new DataTable();
            da.Fill(dt);

            StringBuilder sb = new StringBuilder();
            sb.Append("<table class='w-full text-left border-collapse'>");
            sb.Append("<tr class='bg-gray-50 border-b'><th class='p-2'>Order</th><th class='p-2'>Customer</th><th class='p-2'>Items</th><th class='p-2'>Status</th><th class='p-2 text-right'>Total</th></tr>");

            foreach (DataRow row in dt.Rows)
            {
                sb.Append("<tr class='border-b hover:bg-gray-50'>");
                sb.Append(string.Format("<td class='p-2 font-bold'>#{0}</td>", row["OrderID"]));
                sb.Append(string.Format("<td class='p-2'>{0}</td>", row["Customer"]));
                sb.Append(string.Format("<td class='p-2'>{0} (x{1})</td>", row["Medicine"], row["Quantity"]));
                sb.Append(string.Format("<td class='p-2 uppercase font-black text-[9px]'>{0}</td>", row["PaymentStatus"]));

                decimal amt = Convert.ToDecimal(row["Amount"]);
                sb.Append(string.Format("<td class='p-2 text-right font-bold'>₹{0:N2}</td>", amt));
                sb.Append("</tr>");
            }
            sb.Append("</table>");

            litReportContent.Text = sb.ToString();
            pnlReport.Visible = true;
        }
    }

    // 5. Navigation & UI Helpers
    protected void BtnCloseReport_Click(object sender, EventArgs e)
    {
        pnlReport.Visible = false;
    }

    protected void BtnRefresh_Click(object sender, EventArgs e)
    {
        LoadDashboardStats();
        BindPendingOrders();
    }
}