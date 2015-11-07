### Inventory links<br>
http://gtaforums.com/topic/792877-list-of-over-100-coordinates-more-comming/<br>
https://docs.google.com/spreadsheets/d/1C_dJ5rnwSTA0JY9k69hTMJuBQxRQbOAc7bBZl2QMMLM/edit#gid=0<br>
https://docs.google.com/spreadsheets/d/1xxR-B8ETCmO_OPa5KKsqqNSTirgLQdHH2kboRW5EE5k/edit#gid=0<br>
http://gtaforums.com/topic/795824-q-mobile-phone-text-message/<br>
http://gtaforums.com/topic/816868-player-passenger-in-the-backseat/<br>

// Look into phone mechanics in this
https://www.gta5-mods.com/scripts/tax-and-bill-payments/<br>

//
Ped playerPed = PLAYER::PLAYER_PED_ID();

// No point in displaying the keyboard if they aren't in a vehicle
if (!PED::IS_PED_IN_ANY_VEHICLE(playerPed, false)) return;

// Invoke keyboard
GAMEPLAY::DISPLAY_ONSCREEN_KEYBOARD(true, "", "", VEHICLE::GET_VEHICLE_NUMBER_PLATE_TEXT(PED::GET_VEHICLE_PED_IS_IN(playerPed, false)), "", "", "", 9);

// Wait for the user to edit
while (GAMEPLAY::UPDATE_ONSCREEN_KEYBOARD() == 0) WAIT(0);

// Make sure they didn't exit without confirming their change, and that they're still in a vehicle
if (!GAMEPLAY::GET_ONSCREEN_KEYBOARD_RESULT() || !PED::IS_PED_IN_ANY_VEHICLE(playerPed, false)) return;

// Update the licenseplate
VEHICLE::SET_VEHICLE_NUMBER_PLATE_TEXT(PED::GET_VEHICLE_PED_IS_IN(playerPed, false), GAMEPLAY::GET_ONSCREEN_KEYBOARD_RESULT());
