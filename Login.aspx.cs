using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

public partial class Login : System.Web.UI.Page
{
    protected void btnLogin_Click(object sender, EventArgs e)
    {
        string user = txtUsername.Text.Trim();
        string pass = txtPassword.Text.Trim();

        // 1. Clear previous messages
        lblMessage.Text = "";

        // 2. Basic Validation
        if (string.IsNullOrEmpty(user) || string.IsNullOrEmpty(pass))
        {
            lblMessage.Text = "⚠️ Enter Username & Password";
            return;
        }

        try
        {
            // 3. Using DBManager for centralized connection handling
            using (SqlConnection conn = DBManager.GetConnection())
            {
                // Ensure connection is open (DBManager usually handles this, but safety first)
                if (conn.State == ConnectionState.Closed) conn.Open();

                // --- 1. ADMIN CHECK ---
                string adminQuery = "SELECT AdminID, Username FROM Admin WHERE Username=@u AND Password=@p";
                using (SqlCommand cmdAdmin = new SqlCommand(adminQuery, conn))
                {
                    cmdAdmin.Parameters.AddWithValue("@u", user);
                    cmdAdmin.Parameters.AddWithValue("@p", pass);

                    using (SqlDataReader drAdmin = cmdAdmin.ExecuteReader())
                    {
                        if (drAdmin.Read())
                        {
                            Session["UserID"] = drAdmin["AdminID"];
                            Session["Username"] = drAdmin["Username"];
                            Session["Role"] = "Admin";
                            Response.Redirect("AdminDashboard.aspx");
                            return;
                        }
                    } // Reader closes here automatically
                }

                // --- 2. DISTRIBUTOR CHECK ---
                string distQuery = "SELECT DistributorID, Username FROM Distributors WHERE Username=@u AND Password=@p";
                using (SqlCommand cmdDist = new SqlCommand(distQuery, conn))
                {
                    cmdDist.Parameters.AddWithValue("@u", user);
                    cmdDist.Parameters.AddWithValue("@p", pass);

                    using (SqlDataReader drDist = cmdDist.ExecuteReader())
                    {
                        if (drDist.Read())
                        {
                            Session["UserID"] = drDist["DistributorID"];
                            Session["Username"] = drDist["Username"];
                            Session["Role"] = "Distributor";
                            Response.Redirect("DistributorPanel.aspx");
                            return;
                        }
                    }
                }

                // --- 3. CUSTOMER CHECK ---
                string custQuery = "SELECT CustomerID, Username FROM Customers WHERE Username=@u AND Password=@p";
                using (SqlCommand cmdCust = new SqlCommand(custQuery, conn))
                {
                    cmdCust.Parameters.AddWithValue("@u", user);
                    cmdCust.Parameters.AddWithValue("@p", pass);

                    using (SqlDataReader drCust = cmdCust.ExecuteReader())
                    {
                        if (drCust.Read())
                        {
                            Session["UserID"] = drCust["CustomerID"];
                            Session["Username"] = drCust["Username"];
                            Session["Role"] = "Customer";
                            Response.Redirect("CustomerHome.aspx");
                            return;
                        }
                    }
                }

                // 4. IF NO MATCH IN ANY TABLE
                lblMessage.Text = "❌ Invalid Credentials";
            }
        }
        catch (System.Threading.ThreadAbortException)
        {
            // Response.Redirect causes this exception; we catch it to prevent it from going to the general catch block
        }
        catch (Exception ex)
        {
            lblMessage.Text = "ERR: " + ex.Message;
        }
    }
}