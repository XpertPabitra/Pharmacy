using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class CustomerHome : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // 1. Session Guard: If UserID is null, redirect to Login
        if (Session["UserID"] == null)
        {
            Response.Redirect("Login.aspx");
            return;
        }

        if (!IsPostBack)
        {
            SetUserDisplay();
            LoadMedicines();
            CheckPaymentStatus();
            UpdateCartCount(); // Ensure the cart number is correct on page load
        }
    }

    private void SetUserDisplay()
    {
        if (Session["Username"] != null)
        {
            lblWelcome.Text = Session["Username"].ToString();
        }

        // SHOW THE ROLE (Admin / User / Distributor) and set colors
        if (Session["Role"] != null)
        {
            string role = Session["Role"].ToString().ToLower();

            if (role == "admin")
            {
                lblWelcome.CssClass = "font-bold text-indigo-600";
            }
            else if (role == "distributor")
            {
                lblWelcome.CssClass = "font-bold text-orange-500";
            }
            else
            {
                lblWelcome.CssClass = "font-bold text-emerald-600";
            }
        }
    }

    private void LoadMedicines()
    {
        try
        {
            using (SqlConnection conn = DBManager.GetConnection())
            {
                string query = "SELECT MedicineID, Name, Description, Price, QuantityInStock FROM Medicines WHERE QuantityInStock > 0";
                SqlDataAdapter da = new SqlDataAdapter(query, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptMedicines.DataSource = dt;
                rptMedicines.DataBind();
            }
        }
        catch (Exception ex)
        {
            lblStatus.Text = "Error loading medicines: " + ex.Message;
            lblStatus.Visible = true;
        }
    }

    private void CheckPaymentStatus()
    {
        if (Request.QueryString["payment"] == "success")
        {
            lblStatus.Text = "🎉 Order Placed Successfully!";
            lblStatus.CssClass = "block p-4 mb-6 rounded-xl font-bold text-center bg-emerald-100 text-emerald-700 border border-emerald-200";
            lblStatus.Visible = true;
        }
    }

    protected void rptMedicines_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        TextBox txtQty = (TextBox)e.Item.FindControl("txtQty");
        int quantity;

        // Validate quantity input
        if (int.TryParse(txtQty.Text, out quantity) && quantity > 0)
        {
            string medicineID = e.CommandArgument.ToString();

            // CHOICE 1: ADD TO CART (Accumulate multiple items)
            if (e.CommandName == "AddToCart")
            {
                AddToCartLogic(medicineID, quantity);
            }

            // CHOICE 2: BUY NOW (Directly to Payment for 1 item)
            else if (e.CommandName == "PlaceOrder")
            {
                DataTable dt = GetMedicineDetails(medicineID);

                if (dt.Rows.Count > 0)
                {
                    Session["PendingOrderMedID"] = medicineID;
                    Session["PendingOrderName"] = dt.Rows[0]["Name"].ToString();
                    Session["PendingOrderQty"] = quantity;
                    Session["PendingOrderTotal"] = Convert.ToDecimal(dt.Rows[0]["Price"]) * quantity;

                    Response.Redirect("Payment.aspx");
                }
            }
        }
    }

    private void AddToCartLogic(string medicineID, int quantity)
    {
        // Get existing cart from Session or create new one
        DataTable dtCart = Session["Cart"] as DataTable;

        if (dtCart == null)
        {
            dtCart = new DataTable();
            dtCart.Columns.Add("MedicineID", typeof(string));
            dtCart.Columns.Add("Quantity", typeof(int));
        }

        // Update quantity if item already exists in cart
        bool exists = false;
        foreach (DataRow row in dtCart.Rows)
        {
            if (row["MedicineID"].ToString() == medicineID)
            {
                row["Quantity"] = Convert.ToInt32(row["Quantity"]) + quantity;
                exists = true;
                break;
            }
        }

        // Add as a new row if it didn't exist
        if (!exists)
        {
            dtCart.Rows.Add(medicineID, quantity);
        }

        Session["Cart"] = dtCart;
        UpdateCartCount();

        // Optional Feedback alert
        ScriptManager.RegisterStartupScript(this, GetType(), "AddedAlert", "alert('Item added to cart!');", true);
    }

    private void UpdateCartCount()
    {
        DataTable dtCart = Session["Cart"] as DataTable;
        if (dtCart != null)
        {
            // Set the count on the floating cart label
            lblCartCount.Text = dtCart.Rows.Count.ToString();
        }
        else
        {
            lblCartCount.Text = "0";
        }
    }

    protected void btnViewCart_Click(object sender, EventArgs e)
    {
        Response.Redirect("Cart.aspx");
    }

    private DataTable GetMedicineDetails(string id)
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
}