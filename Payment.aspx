<%@ Page Title="Secure Checkout" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Payment.aspx.cs" Inherits="Payment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:ScriptManager ID="sm1" runat="server" />
    
    <asp:HiddenField ID="hfActiveTab" runat="server" Value="upi" />

    <div class="max-w-md mx-auto mb-4 flex justify-between items-center bg-white p-4 rounded-2xl border border-gray-100 shadow-sm">
        <div class="flex items-center space-x-3">
            <div class="h-10 w-10 bg-gray-50 rounded-full flex items-center justify-center border border-gray-100 shadow-inner">👤</div>
            <div>
                <asp:Label ID="lblWelcome" runat="server" CssClass="font-black text-gray-800 text-sm block"></asp:Label>
                <span class="text-[9px] text-gray-400 uppercase font-bold">Verified Session</span>
            </div>
        </div>
        <asp:Panel ID="pnlRoleBadge" runat="server" CssClass="px-3 py-1 rounded-full shadow-sm">
            <span class="text-[9px] font-black uppercase text-white">
                <asp:Literal ID="litRole" runat="server"></asp:Literal>
            </span>
        </asp:Panel>
    </div>

    <div class="max-w-md mx-auto mb-10 bg-white rounded-3xl shadow-2xl border border-gray-100 overflow-hidden">
        <div class="bg-emerald-600 p-6 text-center text-white">
            <h2 class="text-xl font-bold uppercase italic">Checkout</h2>
            <p class="text-emerald-100 text-[10px] font-mono">ORDER ID: #<asp:Label ID="lblOrderID" runat="server" Text="PENDING"></asp:Label></p>
        </div>

        <div class="p-8 text-center space-y-6">
            <div class="flex bg-gray-100 p-1 rounded-2xl">
                <button type="button" onclick="switchMethod('upi')" id="tabUpi" class="flex-1 py-3 rounded-xl text-[10px] font-black bg-white shadow-sm text-emerald-600">UPI / QR</button>
                <button type="button" onclick="switchMethod('cod')" id="tabCod" class="flex-1 py-3 rounded-xl text-[10px] font-black text-gray-500">CASH ON DELIVERY</button>
            </div>

            <div id="section-upi" class="pay-method">
                <asp:Image ID="imgQRCode" runat="server" CssClass="w-48 h-48 mx-auto mb-4 border-4 border-emerald-50 rounded-3xl" />
                <asp:UpdatePanel ID="updPayment" runat="server">
                    <ContentTemplate>
                        <asp:Timer ID="tmrCheckStatus" runat="server" Interval="5000" Enabled="false" OnTick="TmrCheckStatus_Tick"></asp:Timer>
                        <asp:Panel ID="pnlUtrInput" runat="server" CssClass="space-y-4">
                            <asp:TextBox ID="txtUTR" runat="server" MaxLength="12" placeholder="Enter 12-Digit UTR" CssClass="w-full p-4 bg-gray-50 border-2 border-dashed rounded-2xl text-center font-mono font-bold"></asp:TextBox>
                            <asp:Button ID="btnVerifyPayment" runat="server" Text="VERIFY & PLACE ORDER" OnClick="BtnVerifyPayment_Click" CssClass="w-full bg-emerald-600 text-white font-black py-4 rounded-xl shadow-lg" />
                        </asp:Panel>
                        <asp:Panel ID="pnlWaiting" runat="server" Visible="false" CssClass="bg-amber-50 p-4 rounded-xl border border-amber-100">
                            <p class="text-amber-800 text-[10px] font-black uppercase animate-pulse">Verifying UTR: <asp:Label ID="lblSentUTR" runat="server" /></p>
                        </asp:Panel>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>

            <div id="section-cod" class="pay-method hidden text-left animate-fadeIn">
                <div class="bg-gray-50 rounded-3xl p-6 border border-gray-200 space-y-4 relative">
                    <div class="flex justify-between items-center">
                        <h4 class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Delivery Address</h4>
                        <asp:LinkButton ID="btnEditAddress" runat="server" OnClick="BtnEditAddress_Click" CssClass="text-[10px] font-bold text-emerald-600 uppercase hover:underline">Edit</asp:LinkButton>
                    </div>

                    <asp:Panel ID="pnlAddressView" runat="server">
                        <p class="text-xs font-black text-gray-800 mb-1"><asp:Label ID="lblCustName" runat="server"></asp:Label></p>
                        <p class="text-[11px] text-gray-600 leading-relaxed italic">
                            <asp:Label ID="lblDisplayAddress" runat="server" Text="No address provided."></asp:Label>
                        </p>
                        <p class="text-[10px] font-bold text-gray-400 mt-2">📞 <asp:Label ID="lblCustPhone" runat="server"></asp:Label></p>
                    </asp:Panel>

                    <asp:Panel ID="pnlAddressEdit" runat="server" Visible="false" CssClass="space-y-3">
                        <asp:TextBox ID="txtNewAddress" runat="server" TextMode="MultiLine" Rows="3" 
                            CssClass="w-full p-3 text-xs border border-gray-300 rounded-xl focus:border-emerald-500 outline-none font-sans" 
                            placeholder="Enter your full delivery address..."></asp:TextBox>
                        <div class="flex gap-2">
                            <asp:Button ID="btnSaveAddress" runat="server" Text="Save" OnClick="BtnSaveAddress_Click" 
                                CssClass="flex-1 bg-emerald-600 text-white text-[10px] font-black py-2 rounded-lg" />
                            <asp:Button ID="btnCancelEdit" runat="server" Text="Cancel" OnClick="BtnCancelEdit_Click" 
                                CssClass="px-4 bg-gray-200 text-gray-600 text-[10px] font-black py-2 rounded-lg" />
                        </div>
                    </asp:Panel>
                </div>

                <div class="py-4">
                    <p class="text-[9px] text-gray-400 text-center mb-4 italic">Confirming will notify our pharmacy to prepare your shipment.</p>
                    <asp:Button ID="btnConfirmCOD" runat="server" Text="CONFIRM & SHIP ORDER" OnClick="BtnConfirmCOD_Click" 
                        CssClass="w-full bg-gray-900 text-white font-black py-4 rounded-xl shadow-lg hover:bg-black transition-all" />
                </div>
            </div>

            <div class="bg-gray-50 p-5 rounded-2xl border border-gray-200 text-left">
                <p class="text-xs text-gray-600 font-bold"><asp:Label ID="lblMedSummary" runat="server"></asp:Label></p>
                <div class="flex justify-between items-end border-t pt-3 mt-2">
                    <span class="text-[10px] text-gray-400 font-black uppercase">Total Amount</span>
                    <asp:Label ID="lblTotal" runat="server" CssClass="text-3xl font-black text-gray-800"></asp:Label>
                </div>
            </div>
        </div>
    </div>

    <asp:Panel ID="pnlSuccess" runat="server" CssClass="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center z-50 p-4 hidden">
        <div class="bg-white rounded-[2rem] p-10 text-center max-w-sm w-full">
            <h2 class="text-2xl font-black text-emerald-600 mb-2">Success!</h2>
            <p class="text-gray-500 text-sm mb-8">Order placed successfully.</p>
            <asp:Button ID="btnContinue" runat="server" Text="GO TO HOME" OnClick="BtnContinue_Click" CssClass="w-full bg-emerald-600 text-white font-black py-4 rounded-2xl" />
        </div>
    </asp:Panel>

    <asp:Panel ID="pnlFailed" runat="server" CssClass="fixed inset-0 bg-black/60 backdrop-blur-sm flex items-center justify-center z-50 p-4 hidden">
        <div class="bg-white rounded-[2rem] p-10 text-center max-w-sm w-full">
            <h2 class="text-2xl font-black text-red-600 mb-2">Failed</h2>
            <p class="text-gray-500 text-sm mb-8">Transaction could not be verified.</p>
            <button type="button" onclick="window.location.reload();" class="w-full bg-red-600 text-white font-black py-4 rounded-2xl">TRY AGAIN</button>
        </div>
    </asp:Panel>

    <script type="text/javascript">
        function pageLoad() {
            var activeTab = document.getElementById('<%= hfActiveTab.ClientID %>').value;
            switchMethod(activeTab);
        }

        function switchMethod(type) {
            var hf = document.getElementById('<%= hfActiveTab.ClientID %>');
            if (hf) hf.value = type;

            document.querySelectorAll('.pay-method').forEach(s => s.classList.add('hidden'));
            var target = document.getElementById('section-' + type);
            if (target) target.classList.remove('hidden');

            document.getElementById('tabUpi').className = type === 'upi' ? "flex-1 py-3 rounded-xl text-[10px] font-black bg-white shadow-sm text-emerald-600" : "flex-1 py-3 rounded-xl text-[10px] font-black text-gray-500";
            document.getElementById('tabCod').className = type === 'cod' ? "flex-1 py-3 rounded-xl text-[10px] font-black bg-white shadow-sm text-emerald-600" : "flex-1 py-3 rounded-xl text-[10px] font-black text-gray-500";
        }
    </script>
</asp:Content>