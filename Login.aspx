<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Login.aspx.cs" Inherits="Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8 min-h-screen bg-gray-50">
        <div class="max-w-md w-full space-y-8 bg-white p-10 rounded-2xl shadow-xl border-t-8 border-emerald-600">
            <div>
                <div class="flex justify-center">
                    <span class="text-5xl bg-emerald-100 p-4 rounded-full">🔐</span>
                </div>
                <h2 class="mt-6 text-center text-3xl font-black text-gray-900 tracking-tight">
                    Pharmacy Sign In
                </h2>
                <p class="mt-2 text-center text-sm text-gray-500 font-medium uppercase tracking-widest">
                    Secure Dashboard Access
                </p>
            </div>
            
            <div class="mt-8 space-y-6">
                <div class="space-y-1">
                    <label class="block text-gray-700 text-[10px] font-black uppercase tracking-widest ml-1">Username</label>
                    <asp:TextBox ID="txtUsername" runat="server" 
                        CssClass="appearance-none rounded-xl relative block w-full px-4 py-3 border border-gray-300 placeholder-gray-400 text-gray-900 focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent transition-all sm:text-sm" 
                        placeholder="Enter your username"></asp:TextBox>
                </div>
                
                <div class="space-y-1">
                    <label class="block text-gray-700 text-[10px] font-black uppercase tracking-widest ml-1">Password</label>
                    <div class="relative group">
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" 
                            CssClass="appearance-none rounded-xl relative block w-full px-4 py-3 border border-gray-300 placeholder-gray-400 text-gray-900 focus:outline-none focus:ring-2 focus:ring-emerald-500 focus:border-transparent transition-all sm:text-sm pr-12" 
                            placeholder="Enter your password"></asp:TextBox>
                        
                        <button type="button" onclick="togglePassword()" 
                            class="absolute right-0 top-0 bottom-0 px-4 flex items-center z-30 focus:outline-none group-hover:opacity-100 transition-opacity">
                            <svg id="eyeIcon" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 text-gray-400 hover:text-emerald-600 cursor-pointer" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                <path id="eyePath" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0zM2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                            </svg>
                        </button>
                    </div>
                </div>

                <div class="text-center h-4">
                    <asp:Label ID="lblMessage" runat="server" CssClass="text-red-500 text-xs font-bold uppercase italic"></asp:Label>
                </div>

                <div>
                    <asp:Button ID="btnLogin" runat="server" Text="LOG IN TO ACCOUNT" OnClick="btnLogin_Click" 
                        CssClass="w-full flex justify-center py-4 px-4 border border-transparent text-xs font-black rounded-xl text-white bg-emerald-600 hover:bg-emerald-700 focus:outline-none shadow-lg shadow-emerald-200 transition-all transform active:scale-95 uppercase tracking-widest" />
                </div>

                <div class="flex items-center justify-between text-[10px] font-bold uppercase tracking-tighter pt-4 border-t border-gray-100">
                    <asp:HyperLink ID="lnkRegister" runat="server" NavigateUrl="~/Register.aspx" CssClass="text-emerald-600 hover:text-emerald-500 transition">
                        New User? Create Account
                    </asp:HyperLink>
                    <asp:HyperLink ID="lnkAbout" runat="server" NavigateUrl="~/About.aspx" CssClass="text-gray-400 hover:text-gray-600 transition">
                        Project Info
                    </asp:HyperLink>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function togglePassword() {
            var passField = document.getElementById('<%= txtPassword.ClientID %>');
            var icon = document.getElementById('eyeIcon');
            var path = document.getElementById('eyePath');

            // Standard Eye Icon Data
            var eyeOpen = "M15 12a3 3 0 11-6 0 3 3 0 016 0zM2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z";
            // Eye with slash (hidden)
            var eyeClosed = "M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l18 18";

            if (passField.type === "password") {
                passField.type = "text";
                icon.classList.add("text-emerald-600");
                path.setAttribute("d", eyeClosed);
            } else {
                passField.type = "password";
                icon.classList.remove("text-emerald-600");
                path.setAttribute("d", eyeOpen);
            }
        }
    </script>
</asp:Content>