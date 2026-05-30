# 🍲 NomNom UI Library

NomNom adalah UI Library modern, minimalis, dan elegan untuk Roblox. Dirancang sebagai alternatif yang lebih bersih dan ringan daripada Rayfield, NomNom berfokus pada estetika premium, kustomisasi penuh (termasuk ikon Asset ID), serta transisi unik **Dynamic Island** saat menu diminimalkan.

---

## ✨ Fitur Utama

* **Dynamic Island Transition:** Saat menu ditutup, UI akan mengecil dan berpindah ke atas layar menjadi bentuk kapsul interaktif ala Dynamic Island.
* **Ultra-Minimalist Design:** Interface bersih tanpa elemen yang mengganggu fokus visual.
* **Custom Logo Support:** Mendukung penggunaan Roblox Asset ID langsung untuk logo menu Anda.
* **Fully Adaptable:** Skrip builder yang mempermudah penyusunan elemen tanpa perlu menulis kode dari awal.

---

## 🚀 Cara Penggunaan (Quick Start)

Untuk menggunakan NomNom UI di dalam skrip Roblox Anda, gunakan `loadstring` yang mengarah ke file utama repositori ini:

```lua
local NomNom = loadstring(game:HttpGet("[https://raw.githubusercontent.com/1MN00X/NomNom/main/NomNomSource.lua](https://raw.githubusercontent.com/1MN00X/NomNom/main/NomNomSource.lua)"))()

local UI = NomNom.new({
    Title = "NomNom Hub",
    LogoId = "rbxassetid://0", -- Ganti dengan Asset ID gambar Anda jika ada
    ThemeColor = Color3.fromRGB(255, 107, 107)
})

-- Menambahkan Tombol Premium
UI:CreateButton("Fitur Contoh 1", function()
    print("Tombol ditekan!")
end)

-- Menambahkan Sakelar Minimalis (Toggle)
UI:CreateToggle("Fitur Contoh 2", false, function(state)
    print("Status toggle:", state)
end)
