using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

public class DBManager
{
    private static string connString = ConfigurationManager.ConnectionStrings["PharmacyDB"].ConnectionString;

    // Opens a connection to the SQL Database
    public static SqlConnection GetConnection()
    {
        SqlConnection conn = new SqlConnection(connString);
        if (conn.State == ConnectionState.Closed)
        {
            conn.Open();
        }
        return conn;
    }

    // Helper to fetch data for GridViews (Medicine lists, Customer lists)
    public static DataTable GetDataTable(string query)
    {
        using (SqlConnection conn = GetConnection())
        {
            using (SqlDataAdapter da = new SqlDataAdapter(query, conn))
            {
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }
    }
}