```markdown
# 💊 PharmaNeura: Advanced Pharmacy Management System

PharmaNeura is an enterprise-grade, high-performance web application designed to optimize pharmacy operations, coordinate multi-tier inventory controls, process fast-lane billing transactions, and compile real-time intelligence metrics. 

Engineered strictly around **ASP.NET Web Forms**, architecture-driven **ADO.NET Data Access Layers**, and fully compiled **SQL Server Stored Procedures**, this system bypasses heavy ORM frameworks to maintain sub-millisecond data execution barriers, offering unprecedented efficiency and resource optimization.

---

## 🚀 Architectural Tech Stack

* **Frontend Interface:** ASP.NET Web Forms (`.aspx`), HTML5 semantic structures, JavaScript (ES6+), Tailwind CSS utility engines, and Bootstrap 5 layout grids.
* **Application Logic Layer:** C# (.NET Framework 4.8 / .NET Core wrapped APIs).
* **Data Access Strategy:** Direct decoupled ADO.NET abstraction layer (`SqlConnection`, `SqlCommand`, `SqlDataAdapter`).
* **Database Engine:** Microsoft SQL Server (Highly indexed relational database layout).

---

## ✨ Key Enterprise Capabilities

### 🎛️ Real-Time Intelligence Dashboard
* Instantly tracks high-level key performance metrics (KPIs) including **Total Registered Customers**, **Cumulative Purchase Orders**, and **Total Managed Medicinal Stock**.
* Utilizes a performance-tuned data-bind routine to ensure metrics stay refreshed without excessive server-overhead.

### 📦 Comprehensive Inventory Management
* Full CRUD control lifecycle for medicinal products, tracing batch numbers, active therapeutic chemical generic compositions, unit costs, and expiration thresholds.
* Automated notification dispatch parameters flagging items trending toward zero-stock barriers or imminent shelf-life expirations.

### 🧾 Point of Sale (POS) & Invoice Generation
* Seamless sales transaction entry, automatically parsing out active tax parameters, calculating dynamic item totals, and executing atomic inventory decrement logic on checkout completion.

### 🛡️ Role-Based Access Security
* Enforced system partitioning securing modules between Administrative oversight roles, dispensing Pharmacists, and checkout Cashiers.

---

## 🎨 Frontend Spotlight: Responsive Dashboard Page

The main entry dashboard leverages modern responsive layout primitives (Tailwind CSS engine grids) paired with native `.NET Framework` server-side rendering labels to deliver an incredibly rapid user response.

```html
<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <h1 class="text-3xl font-bold mb-6 text-gray-700">Dashboard</h1>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div class="bg-white p-6 rounded-lg shadow hover:shadow-lg transition duration-300">
            <h2 class="text-xl font-semibold mb-2">Total Customers</h2>
            <asp:Label ID="lblTotalCustomers" runat="server" CssClass="text-3xl font-bold text-blue-600">0</asp:Label>
        </div>

        <div class="bg-white p-6 rounded-lg shadow hover:shadow-lg transition duration-300">
            <h2 class="text-xl font-semibold mb-2">Total Orders</h2>
            <asp:Label ID="lblTotalOrders" runat="server" CssClass="text-3xl font-bold text-green-600">0</asp:Label>
        </div>

        <div class="bg-white p-6 rounded-lg shadow hover:shadow-lg transition duration-300">
            <h2 class="text-xl font-semibold mb-2">Total Medicines</h2>
            <asp:Label ID="lblTotalMedicines" runat="server" CssClass="text-3xl font-bold text-red-600">0</asp:Label>
        </div>
    </div>

</asp:Content>
