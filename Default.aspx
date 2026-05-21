<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h1 class="text-3xl font-bold mb-6 text-gray-700">Dashboard</h1>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <!-- Total Customers -->
        <div class="bg-white p-6 rounded-lg shadow hover:shadow-lg transition duration-300">
            <h2 class="text-xl font-semibold mb-2">Total Customers</h2>
            <asp:Label ID="lblTotalCustomers" runat="server" CssClass="text-3xl font-bold text-blue-600">0</asp:Label>
        </div>

        <!-- Total Orders -->
        <div class="bg-white p-6 rounded-lg shadow hover:shadow-lg transition duration-300">
            <h2 class="text-xl font-semibold mb-2">Total Orders</h2>
            <asp:Label ID="lblTotalOrders" runat="server" CssClass="text-3xl font-bold text-green-600">0</asp:Label>
        </div>

        <!-- Total Medicines -->
        <div class="bg-white p-6 rounded-lg shadow hover:shadow-lg transition duration-300">
            <h2 class="text-xl font-semibold mb-2">Total Medicines</h2>
            <asp:Label ID="lblTotalMedicines" runat="server" CssClass="text-3xl font-bold text-red-600">0</asp:Label>
        </div>
    </div>

</asp:Content>