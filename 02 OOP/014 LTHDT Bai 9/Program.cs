﻿namespace _30_05_014_LTHDT_Bai_9
{
    internal class Program
    {
        static void Main(string[] args)
        {
            DanhSachCongNhan danhSach = new DanhSachCongNhan(10);
            danhSach.Add(new CongNhan(1, "Ho", "Danh", 100));
            danhSach.Add(new CongNhan(2, "BBB", "BB", 500));
            danhSach.Add(new CongNhan(3, "AAC", "CCA", 300));

            danhSach.ShowAll();

            danhSach.SortQuantityDescending().ShowAll();
        }
    }
}