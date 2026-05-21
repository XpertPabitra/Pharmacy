<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="Register" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
        <div class="max-w-md w-full space-y-8 bg-white p-10 rounded-xl shadow-lg border-t-4 border-emerald-500">
            <h2 class="text-center text-3xl font-extrabold text-gray-900 tracking-tight">Create Account</h2>
            
            <div class="grid grid-cols-1 gap-5 mt-6">
                <div>
                    <label class="block text-[10px] font-bold uppercase tracking-widest text-gray-400 mb-1">Full Name</label>
                    <asp:TextBox ID="txtName" runat="server" CssClass="w-full p-2 border-b-2 border-gray-100 outline-none focus:border-emerald-500 transition-all duration-300" placeholder="John Doe"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvName" runat="server" ControlToValidate="txtName" ErrorMessage="Full name is required" Display="Dynamic" CssClass="text-red-500 text-[10px] font-semibold mt-1 block" />
                </div>

                <div>
                    <label class="block text-[10px] font-bold uppercase tracking-widest text-gray-400 mb-1">Username</label>
                    <asp:TextBox ID="txtUser" runat="server" CssClass="w-full p-2 border-b-2 border-gray-100 outline-none focus:border-emerald-500 transition-all duration-300" placeholder="john_doe88"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvUser" runat="server" ControlToValidate="txtUser" ErrorMessage="Username is required" Display="Dynamic" CssClass="text-red-500 text-[10px] font-semibold mt-1 block" />
                </div>

                <div class="relative">
                    <label class="block text-[10px] font-bold uppercase tracking-widest text-gray-400 mb-1">Security Password</label>
                    <asp:TextBox ID="txtPass" runat="server" TextMode="Password" placeholder="••••••••" ClientIDMode="Static"
                        CssClass="w-full p-2 border-b-2 border-gray-100 outline-none focus:border-emerald-500 transition-all duration-300"></asp:TextBox>
                    
                    <button type="button" onclick="togglePasswordVisibility()" class="absolute right-2 top-7 text-gray-300 hover:text-emerald-500 transition-colors focus:outline-none">
                        <svg id="eyeIcon" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                        </svg>
                    </button>

                    <asp:RequiredFieldValidator ID="rfvPass" runat="server" ControlToValidate="txtPass" ErrorMessage="Password is required" Display="Dynamic" CssClass="text-red-500 text-[10px] font-semibold mt-1 block" />
                    
                    <asp:RegularExpressionValidator ID="revPass" runat="server" ControlToValidate="txtPass" 
                        ValidationExpression="^(?=.*[a-zA-Z])(?=.*\d).{4,}$" 
                        ErrorMessage="Security requirement: Minimum 4 characters, including letters and digits." 
                        Display="Dynamic" CssClass="text-amber-600 text-[10px] font-medium mt-1 block leading-tight" />
                </div>

                <div>
                    <label class="block text-[10px] font-bold uppercase tracking-widest text-gray-400 mb-1">Primary Phone</label>
                    <asp:TextBox ID="txtPhone" runat="server" CssClass="w-full p-2 border-b-2 border-gray-100 focus:border-emerald-500 outline-none transition-all duration-300" placeholder="0000000000"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvPhone" runat="server" ControlToValidate="txtPhone" ErrorMessage="Phone number is required" Display="Dynamic" CssClass="text-red-500 text-[10px] font-semibold mt-1 block" />
                    <asp:RegularExpressionValidator ID="revPhone" runat="server" ControlToValidate="txtPhone" 
                        ValidationExpression="^[0-9]{10}$" ErrorMessage="Please enter a valid 10-digit mobile number." 
                        Display="Dynamic" CssClass="text-red-500 text-[10px] font-semibold mt-1 block" />
                </div>

                <div>
                    <label class="block text-[10px] font-bold uppercase tracking-widest text-gray-400 mb-1">Email Address</label>
                    <asp:TextBox ID="txtEmail" runat="server" CssClass="w-full p-2 border-b-2 border-gray-100 outline-none focus:border-emerald-500 transition-all duration-300" placeholder="name@company.com"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="Email is required" Display="Dynamic" CssClass="text-red-500 text-[10px] font-semibold mt-1 block" />
                    <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" 
                        ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" 
                        ErrorMessage="Invalid professional email format." Display="Dynamic" CssClass="text-red-500 text-[10px] font-semibold mt-1 block" />
                </div>
            </div>

            <div class="mt-8">
                <asp:Button ID="btnRegister" runat="server" Text="COMPLETE REGISTRATION" OnClick="btnRegister_Click" 
                    CssClass="w-full bg-emerald-600 text-white font-bold py-4 rounded-xl hover:bg-emerald-700 shadow-lg shadow-emerald-200 transition-all cursor-pointer tracking-widest text-xs" />
            </div>

            <div class="text-center mt-4">
                <asp:Label ID="lblError" runat="server" CssClass="text-red-500 text-xs font-bold"></asp:Label>
            </div>
        </div>
    </div>

    <asp:Panel ID="pnlRegSuccess" runat="server" Visible="false" 
        CssClass="fixed inset-0 bg-slate-900/60 backdrop-blur-md flex items-center justify-center z-50 p-4">
        <div class="bg-white rounded-3xl p-10 text-center max-w-sm w-full shadow-2xl scale-in-center">
            <div class="w-16 h-16 bg-emerald-100 text-emerald-600 rounded-2xl flex items-center justify-center mx-auto mb-6 transform rotate-12">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="3">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7" />
                </svg>
            </div>
            <h2 class="text-2xl font-bold text-gray-800 mb-2">Success!</h2>
            <p class="text-gray-500 text-sm mb-8">Your account has been verified. You may now proceed to the secure portal.</p>
            <asp:Button ID="btnGoToLogin" runat="server" Text="LOG IN TO ACCOUNT" OnClick="btnGoToLogin_Click" CausesValidation="false"
                CssClass="w-full bg-slate-800 text-white font-bold py-4 rounded-xl shadow-lg tracking-widest text-[10px]" />
        </div>
    </asp:Panel>

    <script type="text/javascript">
        function togglePasswordVisibility() {
            const passInput = document.getElementById('txtPass');
            const type = passInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passInput.setAttribute('type', type);
        }
    </script>
</asp:Content>