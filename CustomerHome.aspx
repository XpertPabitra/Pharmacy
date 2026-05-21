<%@ Page Title="Shop Medicines" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="CustomerHome.aspx.cs" Inherits="CustomerHome" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="fixed bottom-6 right-6 z-50">
        <asp:LinkButton ID="btnViewCart" runat="server" OnClick="btnViewCart_Click"
            CssClass="flex items-center space-x-3 bg-emerald-600 hover:bg-emerald-700 text-white px-6 py-4 rounded-full shadow-2xl transition-all transform hover:scale-105 active:scale-95 border-2 border-white">
            <span class="text-xl">🛒</span>
            <span class="font-black uppercase tracking-widest text-[10px]">
                Cart (<asp:Label ID="lblCartCount" runat="server" Text="0"></asp:Label>)
            </span>
        </asp:LinkButton>
    </div>

    <div class="mb-8 flex flex-col md:flex-row justify-between items-center bg-white p-6 rounded-2xl shadow-sm border border-gray-100 mt-4">
        <div>
            <h2 class="text-3xl font-black text-gray-800 tracking-tight">Healthcare Store</h2>
            <p class="text-emerald-600 font-medium italic">Your trusted digital pharmacy.</p>
        </div>
        
        <div class="flex items-center space-x-4 mt-4 md:mt-0">
            <div class="text-right border-r pr-4 border-gray-100">
                <asp:Label ID="lblRoleBadge" runat="server" 
                    CssClass="inline-block text-[9px] font-black uppercase tracking-widest text-white px-2 py-0.5 rounded-md mb-1 shadow-sm">
                </asp:Label>
                
                <div class="block">
                    <span class="text-[10px] text-gray-400 uppercase font-bold tracking-widest">Logged In As</span>
                    <asp:Label ID="lblWelcome" runat="server" CssClass="font-bold text-gray-700 text-lg ml-1"></asp:Label>
                </div>
            </div>
            <div class="h-12 w-12 bg-gray-50 rounded-full flex items-center justify-center text-xl border-2 border-white shadow-sm ring-1 ring-gray-100">👤</div>
        </div>
    </div>

    <asp:Label ID="lblStatus" runat="server" CssClass="block p-4 mb-6 rounded-xl font-bold text-center hidden shadow-inner italic"></asp:Label>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        <asp:Repeater ID="rptMedicines" runat="server" OnItemCommand="rptMedicines_ItemCommand">
            <ItemTemplate>
                <div class="bg-white border border-gray-200 rounded-2xl shadow-sm hover:shadow-2xl transition-all duration-300 overflow-hidden group">
                    <div class="p-6">
                        <div class="flex justify-between items-start mb-4">
                            <h3 class="text-xl font-bold text-gray-900"><%# Eval("Name") %></h3>
                            <div class="text-right">
                                <span class="text-emerald-700 text-xl font-black block">₹<%# Eval("Price", "{0:N2}") %></span>
                                <span class="text-[10px] text-gray-400 uppercase font-bold">Per Unit</span>
                            </div>
                        </div>
                        
                        <p class="text-gray-500 text-sm leading-relaxed mb-6 h-12 overflow-hidden italic">
                            <%# Eval("Description") %>
                        </p>
                        
                        <div class="bg-gray-50 rounded-xl p-4 border border-gray-100">
                            <div class="flex justify-between items-center mb-4">
                                <span class="text-[10px] font-bold text-gray-400 uppercase">Availability</span>
                                <span class='<%# Convert.ToInt32(Eval("QuantityInStock")) < 10 ? "text-red-500 font-black animate-pulse" : "text-gray-600 font-bold" %>'>
                                    <%# Eval("QuantityInStock") %> units left
                                </span>
                            </div>

                            <div class="flex items-center space-x-2">
                                <div class="w-16">
                                    <asp:TextBox ID="txtQty" runat="server" TextMode="Number" Text="1" min="1" 
                                        CssClass="w-full bg-white border border-gray-300 rounded-lg py-2 text-sm focus:ring-2 focus:ring-emerald-500 outline-none font-bold text-center">
                                    </asp:TextBox>
                                </div>
                                <div class="flex-1 flex space-x-2">
                                    <asp:LinkButton ID="btnAddToCart" runat="server" 
                                        CommandName="AddToCart" 
                                        CommandArgument='<%# Eval("MedicineID") %>'
                                        CssClass="flex-1 bg-white border-2 border-emerald-600 text-emerald-600 hover:bg-emerald-50 text-[9px] font-black py-3 rounded-lg transition-all text-center uppercase tracking-tighter">
                                        + Cart
                                    </asp:LinkButton>
                                    
                                    <asp:LinkButton ID="btnOrder" runat="server" 
                                        CommandName="PlaceOrder" 
                                        CommandArgument='<%# Eval("MedicineID") %>'
                                        CssClass="flex-1 bg-emerald-600 hover:bg-emerald-700 text-white text-[9px] font-black py-3 rounded-lg shadow-lg text-center uppercase tracking-tighter">
                                        Buy Now
                                    </asp:LinkButton>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>