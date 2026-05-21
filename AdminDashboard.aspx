<%@ Page Title="Admin Panel" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="AdminDashboard.aspx.cs" Inherits="AdminDashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="max-w-6xl mx-auto space-y-8 mt-6">
        
        <div class="flex flex-col md:flex-row justify-between items-center bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
            <div>
                <h2 class="text-3xl font-black text-gray-800 italic">Inventory Management</h2>
                <p class="text-indigo-600 font-bold text-xs uppercase tracking-widest">System Control Panel</p>
            </div>

            <div class="flex items-center space-x-4 mt-4 md:mt-0">
                <div class="text-right border-r pr-4 border-gray-100">
                    <span class="text-[10px] text-gray-400 block uppercase font-black tracking-widest">Logged In As</span>
                    <div class="flex items-center justify-end space-x-2">
                        <asp:Label ID="lblAdminName" runat="server" CssClass="font-bold text-gray-800 text-lg"></asp:Label>
                        <span class="bg-indigo-600 text-white text-[9px] font-black px-2 py-0.5 rounded uppercase shadow-sm">Admin</span>
                    </div>
                </div>
                <div class="h-12 w-12 bg-indigo-50 rounded-full flex items-center justify-center text-2xl border-2 border-white shadow-md">🛡️</div>
            </div>
        </div>

        <asp:Panel ID="pnlStats" runat="server" CssClass="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div class="bg-white p-6 rounded-2xl shadow-sm border-l-4 border-emerald-500">
                <p class="text-[9px] font-black text-gray-400 uppercase tracking-widest">Total Revenue</p>
                <h3 class="text-2xl font-black text-gray-800"><asp:Label ID="lblTotalRevenue" runat="server">₹0.00</asp:Label></h3>
            </div>
            <div class="bg-white p-6 rounded-2xl shadow-sm border-l-4 border-amber-500">
                <p class="text-[9px] font-black text-gray-400 uppercase tracking-widest">Items in Stock</p>
                <h3 class="text-2xl font-black text-gray-800"><asp:Label ID="lblStockCount" runat="server">0</asp:Label></h3>
            </div>
            <div class="bg-white p-6 rounded-2xl shadow-sm border-l-4 border-red-500">
                <p class="text-[9px] font-black text-gray-400 uppercase tracking-widest">Low Stock Alert</p>
                <h3 class="text-2xl font-black text-red-600"><asp:Label ID="lblLowStockCount" runat="server">0</asp:Label></h3>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlReport" runat="server" Visible="false" CssClass="bg-white p-6 rounded-xl shadow-lg border-2 border-indigo-100">
            <div class="flex justify-between items-center mb-4">
                <h3 class="font-black text-gray-700 uppercase italic text-sm">📋 Inventory Audit Report</h3>
                <asp:LinkButton ID="btnCloseReport" runat="server" OnClick="BtnCloseReport_Click" CssClass="text-red-500 font-bold text-xs uppercase">Close Report ✕</asp:LinkButton>
            </div>
            <div class="overflow-x-auto">
                <asp:Literal ID="litReportContent" runat="server"></asp:Literal>
            </div>
        </asp:Panel>

        <div class="flex justify-center">
            <asp:Label ID="lblStatus" runat="server" CssClass="px-6 py-2 rounded-full text-sm font-bold transition-all shadow-sm italic hidden"></asp:Label>
        </div>

        <div class="bg-white p-6 rounded-xl shadow-md border-t-4 border-indigo-500">
            <h3 class="text-lg font-bold text-gray-700 mb-4 flex items-center">
                <span class="mr-2">📦</span> Add New Medicine to Stock
            </h3>
            <div class="grid grid-cols-1 md:grid-cols-4 gap-4">
                <asp:TextBox ID="newName" runat="server" placeholder="Medicine Name" 
                    CssClass="p-2.5 border rounded-lg focus:ring-2 focus:ring-indigo-500 outline-none"></asp:TextBox>
                
                <div class="relative">
                    <span class="absolute left-3 top-2.5 text-gray-400 font-bold">₹</span>
                    <asp:TextBox ID="newPrice" runat="server" placeholder="0.00" 
                        CssClass="p-2.5 pl-7 border rounded-lg w-full focus:ring-2 focus:ring-indigo-500 outline-none font-bold"></asp:TextBox>
                </div>

                <asp:TextBox ID="newQty" runat="server" TextMode="Number" placeholder="Initial Qty" 
                    CssClass="p-2.5 border rounded-lg focus:ring-2 focus:ring-indigo-500 outline-none"></asp:TextBox>
                
                <asp:Button ID="btnAddMed" runat="server" Text="Add Product" OnClick="btnAddMed_Click" 
                    CssClass="bg-indigo-600 text-white font-bold py-2.5 rounded-lg hover:bg-indigo-700 transition shadow-lg cursor-pointer uppercase text-xs tracking-widest" />
            </div>
        </div>

        <div class="bg-white rounded-xl shadow-xl overflow-hidden border border-gray-200">
            <asp:GridView ID="gvInventory" runat="server" AutoGenerateColumns="False" 
                DataKeyNames="MedicineID" 
                OnRowEditing="gvInventory_RowEditing" 
                OnRowCancelingEdit="gvInventory_RowCancelingEdit" 
                OnRowUpdating="gvInventory_RowUpdating" 
                OnRowDeleting="gvInventory_RowDeleting"
                CssClass="min-w-full divide-y divide-gray-200 text-left">
                
                <HeaderStyle CssClass="bg-gray-100 text-gray-600 text-xs uppercase font-black px-6 py-4" />
                <RowStyle CssClass="divide-y divide-gray-200 hover:bg-gray-50 transition" />

                <Columns>
                    <asp:BoundField DataField="MedicineID" HeaderText="ID" ReadOnly="True" 
                        ItemStyle-CssClass="px-6 py-4 text-sm font-mono text-gray-400" />
                    
                    <asp:TemplateField HeaderText="Medicine Name">
                        <ItemTemplate>
                            <span class="font-bold text-gray-800"><%# Eval("Name") %></span>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtEditName" runat="server" Text='<%# Bind("Name") %>' 
                                CssClass="border p-2 w-full rounded text-sm bg-yellow-50 outline-none"></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Price (₹)">
                        <ItemTemplate>
                            <span class="text-indigo-700 font-bold text-sm">₹<%# Eval("Price", "{0:N2}") %></span>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtEditPrice" runat="server" Text='<%# Bind("Price") %>' 
                                CssClass="border p-2 w-24 rounded text-sm font-bold bg-yellow-50"></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Stock">
                        <ItemTemplate>
                            <span class='<%# Convert.ToInt32(Eval("QuantityInStock")) < 10 ? "text-red-600 font-black" : "text-gray-600 font-semibold" %>'>
                                <%# Eval("QuantityInStock") %>
                            </span>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtEditQty" runat="server" TextMode="Number" Text='<%# Bind("QuantityInStock") %>' 
                                CssClass="border p-2 w-20 rounded text-sm bg-yellow-50"></asp:TextBox>
                        </EditItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="px-6 py-4">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" 
                                CssClass="text-blue-600 font-bold hover:underline mx-2 text-xs uppercase tracking-tighter">Edit</asp:LinkButton>
                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="Delete" 
                                OnClientClick="return confirm('⚠️ Delete this medicine?');" 
                                CssClass="text-red-500 font-bold hover:underline mx-2 text-xs uppercase tracking-tighter">Delete</asp:LinkButton>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <asp:LinkButton ID="btnUpdate" runat="server" CommandName="Update" 
                                CssClass="bg-green-600 text-white px-4 py-1.5 rounded text-[10px] font-black uppercase mx-1 shadow-md">Save Changes</asp:LinkButton>
                            <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel" 
                                CssClass="bg-gray-400 text-white px-4 py-1.5 rounded text-[10px] font-black uppercase mx-1">Cancel</asp:LinkButton>
                        </EditItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>