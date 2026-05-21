<%@ Page Title="Distributor Panel" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="DistributorPanel.aspx.cs" Inherits="DistributorPanel" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="max-w-6xl mx-auto space-y-8 mt-6">
        
        <div class="flex flex-col md:flex-row justify-between items-center bg-white p-6 rounded-2xl shadow-sm border border-gray-100 border-l-8 border-orange-500">
            <div>
                <h2 class="text-3xl font-black text-gray-800 tracking-tight italic">Distribution Center</h2>
                <p class="text-orange-600 font-bold text-xs uppercase tracking-widest text-sm">Logistics & Shipments</p>
            </div>

            <div class="flex items-center space-x-4 mt-4 md:mt-0">
                <div class="text-right border-r pr-4 border-gray-100">
                    <span class="text-[10px] text-gray-400 block uppercase font-black tracking-widest">Logged In As</span>
                    <div class="flex items-center justify-end space-x-2">
                        <asp:Label ID="lblDistName" runat="server" CssClass="font-bold text-gray-800 text-lg"></asp:Label>
                        <span class="bg-orange-500 text-white text-[9px] font-black px-2 py-0.5 rounded uppercase shadow-sm">Distributor</span>
                    </div>
                </div>
                <div class="h-12 w-12 bg-orange-50 rounded-full flex items-center justify-center text-2xl border-2 border-white shadow-md">🚚</div>
            </div>
        </div>

        <asp:Label ID="lblStatus" runat="server" CssClass="block p-4 mb-6 rounded-xl font-bold text-center hidden italic shadow-sm"></asp:Label>

        <div class="bg-white rounded-xl shadow-xl overflow-hidden border border-gray-200">
            <div class="p-4 bg-gray-50 border-b border-gray-100 flex justify-between items-center">
                <h3 class="font-black text-gray-700 uppercase text-xs tracking-widest">Pending Shipments</h3>
                <span class="animate-pulse flex h-2 w-2 rounded-full bg-orange-500"></span>
            </div>

            <asp:GridView ID="gvPendingOrders" runat="server" AutoGenerateColumns="False" 
                DataKeyNames="OrderID" OnRowCommand="gvPendingOrders_RowCommand"
                CssClass="min-w-full divide-y divide-gray-200 text-left">
                
                <HeaderStyle CssClass="bg-gray-100 text-gray-600 text-xs uppercase font-black px-6 py-4" />
                <RowStyle CssClass="divide-y divide-gray-200 hover:bg-orange-50/30 transition" />

                <Columns>
                    <asp:BoundField DataField="OrderID" HeaderText="Order ID" ItemStyle-CssClass="px-6 py-4 font-mono text-sm text-gray-400" />
                    <asp:BoundField DataField="CustomerName" HeaderText="Customer" ItemStyle-CssClass="px-6 py-4 text-sm font-bold text-gray-800" />
                    <asp:BoundField DataField="MedicineName" HeaderText="Medicine" ItemStyle-CssClass="px-6 py-4 text-sm text-gray-600" />
                    <asp:BoundField DataField="Quantity" HeaderText="Qty" ItemStyle-CssClass="px-6 py-4 text-sm font-black text-center" />
                    
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class="px-3 py-1 text-[10px] font-black bg-yellow-100 text-yellow-800 rounded-full uppercase tracking-tighter border border-yellow-200">
                                ⏳ <%# Eval("OrderStatus") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderStyle-CssClass="text-center" ItemStyle-CssClass="text-center py-4 px-6">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnShip" runat="server" 
                                CommandName="Distribute" 
                                CommandArgument='<%# Eval("OrderID") %>'
                                CssClass="bg-orange-500 hover:bg-orange-600 text-white font-black py-2 px-4 rounded-lg transition shadow-md text-[10px] uppercase tracking-widest block w-full text-center">
                                Mark Distributed
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>

            <asp:Panel ID="pnlNoOrders" runat="server" Visible="false" CssClass="text-center py-20 bg-gray-50">
                <div class="text-4xl mb-4 grayscale opacity-50">📦</div>
                <p class="text-gray-400 text-lg font-medium italic">No pending orders found. Everything is shipped!</p>
            </asp:Panel>
        </div>
    </div>
</asp:Content>