<%@ Page Title="About Us" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="About.aspx.cs" Inherits="About" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="max-w-4xl mx-auto">
        <div class="text-center mb-12">
            <h2 class="text-4xl font-extrabold text-gray-900 mb-4">About PharmacyPro</h2>
            <p class="text-lg text-gray-600">A comprehensive digital solution for modern medicinal logistics and customer care.</p>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
            <div class="bg-white p-6 rounded-2xl shadow-sm border border-emerald-100">
                <div class="w-12 h-12 bg-emerald-100 rounded-lg flex items-center justify-center mb-4 text-emerald-600 text-2xl">🎯</div>
                <h3 class="text-xl font-bold text-gray-800 mb-2">Our Mission</h3>
                <p class="text-gray-500 text-sm leading-relaxed">
                    Our system aims to bridge the gap between pharmacies and patients by providing a real-time platform for medicine availability, 
                    secure ordering, and efficient distribution tracking.
                </p>
            </div>

            <div class="bg-white p-6 rounded-2xl shadow-sm border border-emerald-100">
                <div class="w-12 h-12 bg-emerald-100 rounded-lg flex items-center justify-center mb-4 text-emerald-600 text-2xl">⚡</div>
                <h3 class="text-xl font-bold text-gray-800 mb-2">Key Features</h3>
                <ul class="text-gray-500 text-sm space-y-2 list-disc ml-4">
                    <li>Role-based secure authentication</li>
                    <li>Real-time automated inventory tracking</li>
                    <li>Simplified distributor logistics</li>
                    <li>User-friendly medicine catalog</li>
                </ul>
            </div>
        </div>

        <div class="mt-12 bg-emerald-900 rounded-2xl p-8 text-white">
            <h3 class="text-2xl font-bold mb-6 text-center text-emerald-300 underline underline-offset-8">How It Works</h3>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6 text-center">
                <div>
                    <div class="text-3xl font-bold mb-2">01</div>
                    <p class="text-sm font-semibold">Customers Register & Browse Medicines</p>
                </div>
                <div class="border-t md:border-t-0 md:border-l border-emerald-700 pt-6 md:pt-0">
                    <div class="text-3xl font-bold mb-2">02</div>
                    <p class="text-sm font-semibold">Orders are processed via Stored Procedures</p>
                </div>
                <div class="border-t md:border-t-0 md:border-l border-emerald-700 pt-6 md:pt-0">
                    <div class="text-3xl font-bold mb-2">03</div>
                    <p class="text-sm font-semibold">Distributors fulfill and ship orders</p>
                </div>
            </div>
        </div>
    </div>
</asp:Content>