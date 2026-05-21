using System;
using System.Data;
using System.Data.SqlClient;

public partial class Register : System.Web.UI.Page
{
    protected void btnRegister_Click(object sender, EventArgs e)
    {
        // 1. Validation: Check for blank fields (Server-side safety)
        if (string.IsNullOrEmpty(txtName.Text) || string.IsNullOrEmpty(txtUser.Text) || string.IsNullOrEmpty(txtPass.Text))
        {
            lblError.Text = "Required fields cannot be empty!";
            return;
        }

        try
        {
            using (SqlConnection conn = DBManager.GetConnection())
            {
                string sql = "INSERT INTO Customers (Name, Username, Password, Phone, Email) VALUES (@name, @user, @pass, @phone, @email)";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@name", txtName.Text.Trim());
                    cmd.Parameters.AddWithValue("@user", txtUser.Text.Trim());
                    cmd.Parameters.AddWithValue("@pass", txtPass.Text.Trim());
                    cmd.Parameters.AddWithValue("@phone", txtPhone.Text.Trim());
                    cmd.Parameters.AddWithValue("@email", txtEmail.Text.Trim());

                    cmd.ExecuteNonQuery();

                    // --- POPUP LOGIC STARTS HERE ---
                    // Instead of immediate redirect, show the green checkmark popup
                    pnlRegSuccess.Visible = true;

                    // Optional: Hide the registration form to make the popup stand out
                    // (Ensure your form is wrapped in a Panel/Div with an ID if you want to hide it)
                }
            }
        }
        catch (SqlException ex)
        {
            if (ex.Number == 2627)
                lblError.Text = "Username already exists. Choose another.";
            else
                lblError.Text = "Database Error: " + ex.Message;
        }
        catch (Exception ex)
        {
            lblError.Text = "Error: " + ex.Message;
        }
    }

    // THIS METHOD HANDLES THE "PROCEED TO LOGIN" BUTTON IN THE POPUP
    protected void btnGoToLogin_Click(object sender, EventArgs e)
    {
        Response.Redirect("Login.aspx?msg=RegisteredSuccessfully");
    }
}