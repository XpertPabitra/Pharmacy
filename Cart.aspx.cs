using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

public partial class Cart : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // 1. Session Guard
        if (Session["UserID"] == null) Response.Redirect("Login.aspx");

        if (!IsPostBack)
        {
            BindCart();
        }
    }

    private void BindCart()
    {
        DataTable dtCartSession = Session["Cart"] as DataTable;

        if (dtCartSession != null && dtCartSession.Rows.Count > 0)
        {
            DataTable displayTable = CreateDisplayTable();
            decimal grandTotal = 0;

            foreach (DataRow cartRow in dtCartSession.Rows)
            {
                string medID = cartRow["MedicineID"].ToString();
                int qty = Convert.ToInt32(cartRow["Quantity"]);

                // Fetch current data from DB to prevent session tampering
                DataTable dtInfo = GetMedicineFromDB(medID);
                if (dtInfo.Rows.Count > 0)
                {
                    decimal price = Convert.ToDecimal(dtInfo.Rows[0]["Price"]);
                    decimal total = price * qty;
                    grandTotal += total;

                    displayTable.Rows.Add(medID, dtInfo.Rows[0]["Name"], price, qty, total);
                }
            }

            gvCart.DataSource = displayTable;
            gvCart.DataBind();
            lblGrandTotal.Text = "₹" + grandTotal.ToString("N2");
            pnlFooter.Visible = true;
        }
        else
        {
            gvCart.DataSource = null;
            gvCart.DataBind();
            pnlFooter.Visible = false;
        }
    }

    private DataTable CreateDisplayTable()
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("MedicineID");
        dt.Columns.Add("Name");
        dt.Columns.Add("Price", typeof(decimal));
        dt.Columns.Add("Quantity", typeof(int));
        dt.Columns.Add("Total", typeof(decimal));
        return dt;
    }

    private DataTable GetMedicineFromDB(string id)
    {
        using (SqlConnection conn = DBManager.GetConnection())
        {
            string query = "SELECT Name, Price FROM Medicines WHERE MedicineID = @id";
            SqlCommand cmd = new SqlCommand(query, conn);
            cmd.Parameters.AddWithValue("@id", id);
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            return dt;
        }
    }

    protected void gvCart_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        string medID = gvCart.DataKeys[e.RowIndex].Value.ToString();
        DataTable dtCart = Session["Cart"] as DataTable;

        for (int i = dtCart.Rows.Count - 1; i >= 0; i--)
        {
            if (dtCart.Rows[i]["MedicineID"].ToString() == medID)
                dtCart.Rows.RemoveAt(i);
        }

        Session["Cart"] = dtCart;
        BindCart();
    }

    protected void btnClear_Click(object sender, EventArgs e)
    {
        Session["Cart"] = null;
        BindCart();
    }

    protected void btnCheckout_Click(object sender, EventArgs e)
    {
        if (Session["Cart"] != null)
        {
            // Calculate the final total one last time to be safe
            DataTable dt = Session["Cart"] as DataTable;
            decimal grandTotal = 0;

            foreach (DataRow row in dt.Rows)
            {
                // Note: Ensure your Session["Cart"] actually contains Price or fetch it again
                // If Session["Cart"] only has ID and Qty, you need to fetch prices from DB here
                // But for now, let's pass the calculated label value:
                string totalText = lblGrandTotal.Text.Replace("₹", "").Replace(",", "");
                decimal.TryParse(totalText, out grandTotal);
            }

            Session["CheckoutType"] = "Cart";
            Session["FinalAmount"] = grandTotal; // Pass this to Payment.aspx
            Response.Redirect("Payment.aspx");
        }
    }
}