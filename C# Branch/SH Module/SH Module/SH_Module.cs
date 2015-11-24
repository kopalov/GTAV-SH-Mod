using System;
using GTA;
using GTA.Math;
using GTA.Native;
using System.Windows.Forms;

namespace SH_Module
{
    public class SH_Module : Script
    {
        public double[,] house = new double[2, 3] { { 2200.8125, 3318.0876464844, 46.945693969727 }, { -952.35943603516, -1077.5021972656, 2.6772258281708 } };


        public SH_Module()
        {
            Tick += OnTick;
        }

        void OnTick(object sender, EventArgs e)
        {

        }





    }
}
