using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Payment : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // 1. Safety check
        if (Session["UserID"] == null || Session["PendingOrderMedID"] == null)
        {
            Response.Redirect("CustomerHome.aspx");
            return;
        }

        if (!IsPostBack)
        {
            ShowWhoIsLoggedIn();
            LoadPaymentData();
            LoadUserAddress();
        }
    }

    private void ShowWhoIsLoggedIn()
    {
        string username = Session["Username"] != null ? Session["Username"].ToString() : "Guest";
        string userRole = Session["Role"] != null ? Session["Role"].ToString() : "User";
        lblWelcome.Text = username;
        litRole.Text = userRole;

        switch (userRole.ToLower())
        {
            case "admin": pnlRoleBadge.CssClass = "px-3 py-1 rounded-full shadow-sm bg-indigo-600"; break;
            case "distributor": pnlRoleBadge.CssClass = "px-3 py-1 rounded-full shadow-sm bg-orange-500"; break;
            default: pnlRoleBadge.CssClass = "px-3 py-1 rounded-full shadow-sm bg-emerald-600"; break;
        }
    }

    private void LoadUserAddress()
    {
        try
        {
            using (SqlConnection conn = DBManager.GetConnection())
            {
                string sql = "SELECT Name, Phone, Address FROM Customers WHERE CustomerID = @id";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@id", Session["UserID"]);

                if (conn.State == ConnectionState.Closed) conn.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    lblCustName.Text = dr["Name"].ToString();
                    lblCustPhone.Text = dr["Phone"].ToString();
                    string addr = dr["Address"].ToString();

                    if (string.IsNullOrEmpty(addr))
                    {
                        lblDisplayAddress.Text = "No address found! Please edit to add one.";
                        lblDisplayAddress.CssClass = "text-red-500 italic text-[11px]";
                        btnConfirmCOD.Enabled = false;
                        btnConfirmCOD.CssClass = "w-full bg-gray-300 text-white font-black py-4 rounded-xl cursor-not-allowed";
                    }
                    else
                    {
                        lblDisplayAddress.Text = addr;
                        lblDisplayAddress.CssClass = "text-[11px] text-gray-600 italic";
                        btnConfirmCOD.Enabled = true;
                        btnConfirmCOD.CssClass = "w-full bg-gray-900 text-white font-black py-4 rounded-xl shadow-lg";
                    }
                }
            }
        }
        catch { lblDisplayAddress.Text = "Error loading shipping details."; }
    }

    // UPDATED: PascalCase to avoid IDE Conflict
    protected void BtnEditAddress_Click(object sender, EventArgs e)
    {
        pnlAddressView.Visible = false;
        pnlAddressEdit.Visible = true;
        txtNewAddress.Text = lblDisplayAddress.Text.Contains("No address") ? "" : lblDisplayAddress.Text;
    }

    // UPDATED: PascalCase to avoid IDE Conflict
    protected void BtnSaveAddress_Click(object sender, EventArgs e)
    {
        string updatedAddress = txtNewAddress.Text.Trim();
        if (string.IsNullOrEmpty(updatedAddress))
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Address cannot be empty');", true);
            return;
        }

        using (SqlConnection conn = DBManager.GetConnection())
        {
            string sql = "UPDATE Customers SET Address = @addr WHERE CustomerID = @id";
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@addr", updatedAddress);
            cmd.Parameters.AddWithValue("@id", Session["UserID"]);

            if (conn.State == ConnectionState.Closed) conn.Open();
            cmd.ExecuteNonQuery();
        }

        pnlAddressEdit.Visible = false;
        pnlAddressView.Visible = true;
        LoadUserAddress();
    }

    // UPDATED: PascalCase to avoid IDE Conflict
    protected void BtnCancelEdit_Click(object sender, EventArgs e)
    {
        pnlAddressEdit.Visible = false;
        pnlAddressView.Visible = true;
    }

    private void LoadPaymentData()
    {
        decimal total = 0;
        if (Session["PendingOrderTotal"] != null)
        {
            decimal.TryParse(Session["PendingOrderTotal"].ToString(), out total);
        }

        lblTotal.Text = string.Format("₹{0:N2}", total);

        string amountForUPI = total.ToString("F2");
        string upiString = string.Format("upi://pay?pa={0}&pn={1}&am={2}&cu=INR",
                           "pabitrapramanik80@oksbi", HttpUtility.UrlEncode("Healthcare Store"), amountForUPI);

        imgQRCode.ImageUrl = "https://quickchart.io/qr?text=" + HttpUtility.UrlEncode(upiString);
    }

    // UPDATED: PascalCase to avoid IDE Conflict
    protected void BtnVerifyPayment_Click(object sender, EventArgs e)
    {
        string utr = txtUTR.Text.Trim();
        if (utr.Length < 12)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Please enter a valid 12-digit UTR number');", true);
            return;
        }

        string orderID = ProcessOrder("UPI", "Pending", utr);

        if (!string.IsNullOrEmpty(orderID))
        {
            lblOrderID.Text = orderID;
            pnlUtrInput.Visible = false;
            pnlWaiting.Visible = true;
            lblSentUTR.Text = utr;
            tmrCheckStatus.Enabled = true;
        }
    }

    // UPDATED: PascalCase to avoid IDE Conflict
    protected void BtnConfirmCOD_Click(object sender, EventArgs e)
    {
        string orderID = ProcessOrder("COD", "Pending", "CASH_ON_DELIVERY");
        if (!string.IsNullOrEmpty(orderID))
        {
            ShowResultModal("Success");
        }
    }

    private string ProcessOrder(string method, string status, string reference)
    {
        try
        {
            using (SqlConnection conn = DBManager.GetConnection())
            {
                SqlCommand cmd = new SqlCommand("sp_PlaceOrder", conn);
                cmd.CommandType = CommandType.StoredProcedure;

                cmd.Parameters.AddWithValue("@CustomerID", Session["UserID"]);
                cmd.Parameters.AddWithValue("@MedicineID", Session["PendingOrderMedID"]);
                cmd.Parameters.AddWithValue("@Quantity", Session["PendingOrderQty"]);
                cmd.Parameters.AddWithValue("@UTRNumber", reference);
                cmd.Parameters.AddWithValue("@Status", status);

                if (conn.State == ConnectionState.Closed) conn.Open();
                object result = cmd.ExecuteScalar();
                return result != null ? result.ToString() : "";
            }
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Error: " + ex.Message.Replace("'", "") + "');", true);
            return "";
        }
    }

    private void ShowResultModal(string status)
    {
        Session.Remove("PendingOrderMedID");
        Session.Remove("PendingOrderQty");
        Session.Remove("PendingOrderTotal");

        string targetPanel = (status == "Success") ? pnlSuccess.ClientID : pnlFailed.ClientID;
        string script = "var modal = document.getElementById('" + targetPanel + "'); if(modal) { modal.classList.remove('hidden'); modal.classList.add('flex'); }";
        ScriptManager.RegisterStartupScript(this, GetType(), "ShowModal", script, true);
    }

    // UPDATED: PascalCase to avoid IDE Conflict
    protected void BtnContinue_Click(object sender, EventArgs e)
    {
        Response.Redirect("CustomerHome.aspx?payment=success");
    }

    // UPDATED: PascalCase to avoid IDE Conflict
    protected void TmrCheckStatus_Tick(object sender, EventArgs e)
    {
        string orderId = lblOrderID.Text;
        if (string.IsNullOrEmpty(orderId)) return;

        using (SqlConnection conn = DBManager.GetConnection())
        {
            string sql = "SELECT PaymentStatus FROM Orders WHERE OrderID = @oid";
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@oid", orderId);

            if (conn.State == ConnectionState.Closed) conn.Open();
            object statusObj = cmd.ExecuteScalar();

            if (statusObj != null && (statusObj.ToString() == "Success" || statusObj.ToString() == "Failed"))
            {
                tmrCheckStatus.Enabled = false;
                ShowResultModal(statusObj.ToString());
            }
        }
    }
}