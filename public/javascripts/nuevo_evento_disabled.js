function newEventDisabled(){
    if (document.getElementById('evento_reccurrent').checked == true){
                                                  document.getElementById('evento_freq_weekly').disabled = false;
                                                  document.getElementById('evento_freq_weekly').checked = true;
                                                  document.getElementById('evento_byday_mo').disabled = false;
                                                  document.getElementById('evento_byday_tu').disabled = false;
                                                  document.getElementById('evento_byday_we').disabled = false;
                                                  document.getElementById('evento_byday_th').disabled = false;
                                                  document.getElementById('evento_byday_fr').disabled = false;
                                                  document.getElementById('evento_byday_sa').disabled = false;
                                                  document.getElementById('evento_byday_su').disabled = false;
                                               }else{
                                                  document.getElementById('evento_freq_weekly').disabled = true;
                                                  document.getElementById('evento_freq_weekly').checked = false;
                                                  document.getElementById('evento_byday_mo').disabled = true;
                                                  document.getElementById('evento_byday_tu').disabled = true;
                                                  document.getElementById('evento_byday_we').disabled = true;
                                                  document.getElementById('evento_byday_th').disabled = true;
                                                  document.getElementById('evento_byday_fr').disabled = true;
                                                  document.getElementById('evento_byday_sa').disabled = true;
                                                  document.getElementById('evento_byday_su').disabled = true;
                                               }
}