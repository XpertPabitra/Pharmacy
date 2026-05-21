<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Cart.aspx.cs" Inherits="Cart" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Your Shopping Cart</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 font-sans">
    <form id="form1" runat="server">
        <div class="max-w-4xl mx-auto mt-10 p-8 bg-white rounded-3xl shadow-xl border border-gray-100">
            
            <div class="flex justify-between items-center mb-8 border-b pb-6">
                <div>
                    <h2 class="text-3xl font-black text-gray-800 tracking-tight">Shopping Cart</h2>
                    <p class="text-emerald-600 text-sm font-medium">Review your items before checkout</p>
                </div>
                <asp:HyperLink ID="lnkBack" runat="server" NavigateUrl="~/CustomerHome.aspx" 
                    CssClass="text-gray-400 hover:text-emerald-600 font-bold text-xs uppercase tracking-widest transition-colors">
                    ← Back to Store
                </asp:HyperLink>
            </div>

            <asp:GridView ID="gvCart" runat="server" AutoGenerateColumns="False" 
                OnRowDeleting="gvCart_RowDeleting" DataKeyNames="MedicineID"
                CssClass="w-full text-left border-collapse" GridLines="None">
                <Columns>
                    <asp:TemplateField HeaderText="Product">
                        <ItemTemplate>
                            <div class="py-4">
                                <p class="font-bold text-gray-800 text-lg"><%# Eval("Name") %></p>
                                <span class="text-[10px] text-gray-400 uppercase font-black tracking-tighter">ID: <%# Eval("MedicineID") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Price">
                        <ItemTemplate>
                            <span class="font-bold text-gray-600">₹<%# Eval("Price", "{0:N2}") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Qty">
                        <ItemTemplate>
                            <span class="bg-emerald-50 text-emerald-700 px-3 py-1 rounded-lg font-black">
                                <%# Eval("Quantity") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Total">
                        <ItemTemplate>
                            <span class="font-black text-gray-900">₹<%# Eval("Total", "{0:N2}") %></span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:CommandField ShowDeleteButton="True" DeleteText="Remove" 
                        ControlStyle-CssClass="text-red-400 font-bold text-[10px] uppercase hover:text-red-600 transition-colors ml-4" />
                </Columns>
                <HeaderStyle CssClass="border-b border-gray-100 text-[10px] uppercase tracking-widest text-gray-400 pb-2" />
                <EmptyDataTemplate>
                    <div class="text-center py-20">
                        <span class="text-5xl block mb-4">🛒</span>
                        <p class="text-gray-400 italic mb-6">Your cart is currently empty.</p>
                        <a href="CustomerHome.aspx" class="inline-block bg-emerald-600 text-white px-8 py-3 rounded-xl font-bold hover:bg-emerald-700 transition-all">Start Shopping</a>
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>

            <asp:Panel ID="pnlFooter" runat="server" CssClass="mt-10 border-t pt-8 flex flex-col items-end">
                <div class="mb-6 text-right">
                    <p class="text-gray-400 uppercase text-[10px] font-black tracking-widest mb-1">Total Amount Payable</p>
                    <asp:Label ID="lblGrandTotal" runat="server" CssClass="text-4xl font-black text-emerald-600"></asp:Label>
                </div>
                
                <div class="flex space-x-4">
                     <asp:Button ID="btnClear" runat="server" Text="Clear Cart" OnClick="btnClear_Click"
                        CssClass="text-gray-400 hover:text-red-500 font-bold uppercase text-xs tracking-widest px-6" />

                    <asp:Button ID="btnCheckout" runat="server" Text="Checkout Now" OnClick="btnCheckout_Click"
                        CssClass="bg-emerald-600 hover:bg-emerald-700 text-white px-10 py-4 rounded-2xl shadow-lg font-black uppercase tracking-widest transform transition hover:scale-105 active:scale-95" />
                </div>
            </asp:Panel>
        </div>
    </form>
</body>
</html>