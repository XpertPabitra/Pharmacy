<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AdminVerify.aspx.cs" Inherits="AdminVerify" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Admin - Payment Verification</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 font-sans">
    <form id="form1" runat="server">
        <div class="max-w-6xl mx-auto py-12 px-6 space-y-8">
            
            <div class="flex justify-between items-center">
                <h1 class="text-2xl font-black text-gray-800 uppercase tracking-widest">
                    <span class="text-emerald-600">🛡️ Admin</span> Control Panel
                </h1>
                <div class="flex space-x-2">
                    <asp:Button ID="btnGenReport" runat="server" Text="📊 Generate Report" OnClick="BtnGenReport_Click" 
                        CssClass="text-[10px] font-black bg-gray-900 text-white px-4 py-2 rounded-lg shadow-lg hover:bg-black transition cursor-pointer" />
                    <asp:LinkButton ID="btnRefresh" runat="server" OnClick="BtnRefresh_Click" 
                        CssClass="text-[10px] font-bold bg-white border border-gray-200 px-4 py-2 rounded-lg shadow-sm hover:bg-gray-50 transition">
                        REFRESH LIST
                    </asp:LinkButton>
                </div>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div class="bg-white p-6 rounded-3xl shadow-sm border border-gray-100 border-l-4 border-emerald-500">
                    <p class="text-[9px] font-black text-gray-400 uppercase tracking-widest">Total Sales</p>
                    <h3 class="text-2xl font-black text-gray-800"><asp:Label ID="lblTotalRevenue" runat="server">₹0.00</asp:Label></h3>
                </div>
                <div class="bg-white p-6 rounded-3xl shadow-sm border border-gray-100 border-l-4 border-amber-500">
                    <p class="text-[9px] font-black text-gray-400 uppercase tracking-widest">Pending Verification</p>
                    <h3 class="text-2xl font-black text-gray-800"><asp:Label ID="lblPendingCount" runat="server">0</asp:Label></h3>
                </div>
                <div class="bg-white p-6 rounded-3xl shadow-sm border border-gray-100 border-l-4 border-indigo-500">
                    <p class="text-[9px] font-black text-gray-400 uppercase tracking-widest">Approved Orders</p>
                    <h3 class="text-2xl font-black text-gray-800"><asp:Label ID="lblApprovedCount" runat="server">0</asp:Label></h3>
                </div>
            </div>

            <asp:Panel ID="pnlReport" runat="server" Visible="false" CssClass="bg-white p-8 rounded-[2rem] shadow-2xl border border-emerald-100 animate-fadeIn">
                <div class="flex justify-between items-center mb-6 border-b pb-4">
                    <h2 class="text-lg font-black italic uppercase">Detailed Sales Audit</h2>
                    <asp:LinkButton ID="btnCloseReport" runat="server" OnClick="BtnCloseReport_Click" CssClass="text-red-500 font-bold text-xs uppercase">Close ✕</asp:LinkButton>
                </div>
                <div class="overflow-x-auto font-mono text-[11px]">
                    <asp:Literal ID="litReportContent" runat="server"></asp:Literal>
                </div>
                <div class="mt-6 flex justify-center">
                    <button type="button" onclick="window.print();" class="bg-emerald-600 text-white px-8 py-2 rounded-full font-black text-[10px] uppercase shadow-md">Print to PDF</button>
                </div>
            </asp:Panel>

            <div class="bg-white rounded-[2rem] shadow-xl border border-gray-100 overflow-hidden">
                <asp:GridView ID="gvPendingOrders" runat="server" AutoGenerateColumns="False" 
                    CssClass="w-full text-left" GridLines="None" OnRowCommand="GvPendingOrders_RowCommand">
                    
                    <HeaderStyle CssClass="bg-gray-50 text-[10px] font-black uppercase text-gray-400 tracking-widest p-5 border-b border-gray-100" />
                    <RowStyle CssClass="border-b border-gray-50 hover:bg-emerald-50/20 transition-colors" />
                    
                    <Columns>
                        <asp:BoundField DataField="OrderID" HeaderText="Order ID" ItemStyle-CssClass="p-5 font-mono font-bold text-gray-600" />
                        <asp:BoundField DataField="Username" HeaderText="Customer" ItemStyle-CssClass="p-5 text-sm font-semibold text-gray-700" />
                        
                        <asp:TemplateField HeaderText="UTR Reference">
                            <ItemTemplate>
                                <span class="bg-emerald-50 text-emerald-700 px-3 py-1 rounded-md font-mono text-xs font-black border border-emerald-100">
                                    <%# Eval("UTRNumber") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="TotalAmount" HeaderText="Amount" DataFormatString="₹{0:N2}" ItemStyle-CssClass="p-5 font-black text-gray-800" />
                        
                        <asp:TemplateField HeaderText="Verification">
                            <ItemTemplate>
                                <div class="flex space-x-2">
                                    <asp:Button ID="btnApprove" runat="server" Text="APPROVE" 
                                        CommandName="ApproveOrder" CommandArgument='<%# Eval("OrderID") %>'
                                        CssClass="bg-emerald-600 hover:bg-emerald-700 text-white text-[10px] font-black px-4 py-2 rounded-xl shadow-lg transition transform active:scale-95 cursor-pointer" />
                                    
                                    <asp:Button ID="btnReject" runat="server" Text="REJECT" 
                                        CommandName="RejectOrder" CommandArgument='<%# Eval("OrderID") %>'
                                        CssClass="bg-red-500 hover:bg-red-600 text-white text-[10px] font-black px-4 py-2 rounded-xl shadow-lg transition transform active:scale-95 cursor-pointer" />
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>

                <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="py-20 text-center">
                    <div class="text-4xl mb-3">✅</div>
                    <p class="text-gray-400 font-bold uppercase tracking-widest text-[10px]">No pending payments to verify.</p>
                </asp:Panel>
            </div>
        </div>
    </form>
</body>
</html>