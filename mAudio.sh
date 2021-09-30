#!/bin/bash
 E='echo -e';    # -e включить поддержку вывода Escape последовательностей
 e='echo -en';   # -n не выводить перевод строки
 trap "R;exit" 2 # 
    ESC=$( $e "\e")
   TPUT(){ $e "\e[${1};${2}H" ;}
  CLEAR(){ $e "\ec";}
# 25 возможно это 
  CIVIS(){ $e "\e[?25l";}
# это цвет текста списка перед курсором при значении 0 в переменной  UNMARK(){ $e "\e[0m";}
MARK(){ $e "\e[94m";}
# 0 это цвет списка
 UNMARK(){ $e "\e[0m";}
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Эти строки задают цвет фона ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  R(){ CLEAR ;stty sane;CLEAR;};                 # в этом варианте фон прозрачный
# R(){ CLEAR ;stty sane;$e "\ec\e[37;44m\e[J";}; # в этом варианте закрашивается весь фон терминала
# R(){ CLEAR ;stty sane;$e "\ec\e[0;45m\e[";};   # в этом варианте закрашивается только фон меню
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 HEAD(){ for (( a=2; a<=28; a++ ))
  do
   TPUT $a 1
        $E "\e[94m\xE2\x94\x82                        \xE2\x94\x82\e[0m";
  done
 TPUT 3 2
        $E "$(tput bold)  Справочник аудио $(tput sgr 0)";
 TPUT 10 2
        $E "$(tput setaf 2) Плееры $(tput sgr 0)";
 TPUT 15 2
        $E "$(tput setaf 2) Kонсольный интерфейс $(tput sgr 0)";
 TPUT 19 2
        $E "$(tput setaf 2) Визуализаторы $(tput sgr 0)";
 TPUT 22 2
        $E "$(tput setaf 2) Оборудование $(tput sgr 0)";
 TPUT 26 2
        $E "$(tput setaf 2) Up \xE2\x86\x91 \xE2\x86\x93 Down Enter $(tput sgr 0)";
 MARK;TPUT 1 1
        $E "+~~~~~~~~~~~~~~~~~~~~~~~~+";UNMARK;}
   i=0; CLEAR; CIVIS;NULL=/dev/null
 FOOT(){ MARK;TPUT 29 1
        $E "+~ Grannik | 2021.09.30 ~+";UNMARK;}
# это управляет кнопками ввер/хвниз
 i=0; CLEAR; CIVIS;NULL=/dev/null
#
 ARROW(){ IFS= read -s -n1 key 2>/dev/null >&2
           if [[ $key = $ESC ]];then 
              read -s -n1 key 2>/dev/null >&2;
              if [[ $key = \[ ]]; then
                 read -s -n1 key 2>/dev/null >&2;
                 if [[ $key = A ]]; then echo up;fi
                 if [[ $key = B ]];then echo dn;fi
              fi
           fi
           if [[ "$key" == "$($e \\x0A)" ]];then echo enter;fi;}
#
 M0(){ TPUT  5 3; $e " #                   ";}
 M1(){ TPUT  6 3; $e " avconv              ";}
 M2(){ TPUT  7 3; $e " espeak              ";}
 M3(){ TPUT  8 3; $e " lame                ";}
 M4(){ TPUT  9 3; $e " mkvmerge            ";}
#
 M5(){ TPUT 11 3; $e " mplayer             ";}
 M6(){ TPUT 12 3; $e " mpv                 ";}
 M7(){ TPUT 13 3; $e " mpg321              ";}
 M8(){ TPUT 14 3; $e " cvlc                ";}
#
 M9(){ TPUT 16 3; $e " mocp                ";}
M10(){ TPUT 17 3; $e " cmus                ";}
M11(){ TPUT 18 3; $e " nvlc                ";}
#
M12(){ TPUT 20 3; $e " cli-visualizer      ";}
M13(){ TPUT 21 3; $e " cava                ";}
#
M14(){ TPUT 23 3; $e " aplay               ";}
M15(){ TPUT 24 3; $e " arecord             ";}
M16(){ TPUT 25 3; $e " alsamixer           ";}
#
M17(){ TPUT 27 3; $e " EXIT                ";}
# далее идет переменная LM=16 позволяющая бегать по списоку.
LM=17
   MENU(){ for each in $(seq 0 $LM);do M${each};done;}
    POS(){ if [[ $cur == up ]];then ((i--));fi
           if [[ $cur == dn ]];then ((i++));fi
           if [[ $i -lt 0   ]];then i=$LM;fi
           if [[ $i -gt $LM ]];then i=0;fi;}
REFRESH(){ after=$((i+1)); before=$((i-1))
           if [[ $before -lt 0  ]];then before=$LM;fi
           if [[ $after -gt $LM ]];then after=0;fi
           if [[ $j -lt $i      ]];then UNMARK;M$before;else UNMARK;M$after;fi
           if [[ $after -eq 0 ]] || [ $before -eq $LM ];then
           UNMARK; M$before; M$after;fi;j=$i;UNMARK;M$before;M$after;}
   INIT(){ R;HEAD;FOOT;MENU;}
     SC(){ REFRESH;MARK;$S;$b;cur=`ARROW`;}
# Функция возвращения в меню
     ES(){ MARK;$e " ENTER = main menu ";$b;read;INIT;};INIT
  while [[ "$O" != " " ]]; do case $i in
# Здесь необходимо следить за двумя перепенными 0) и S=M0 Они должны совпадать между собой и переменной списка M0().
        0) S=M0 ;SC;if [[ $cur == enter ]];then R;echo "

";ES;fi;;
        1) S=M1 ;SC;if [[ $cur == enter ]];then R;echo "
 Эта команда поможет нам получить информацию о мультимедийных файлах или преобразовать их в другие форматы совместимый. 
";ES;fi;;
        2) S=M2 ;SC;if [[ $cur == enter ]];then R;echo "
 терминал проговорит слово Linux по динамику: espeak \"Linux\"

 sudo apt-get install espeak
 sudo apt install espeak            # version 1.48.15+dfsg-2build1, or
 sudo apt install espeak-ng-espeak  # version 1.50+dfsg-7build1

 espeak \"Ура работает!\"
 espeak \"Ura rabotaet!\"
 (правдв только по английски) 
";ES;fi;;
        3) S=M3;SC;if [[ $cur == enter ]];then R;echo "
 Добавление картинки к аудиофайду.
 sudo apt install lame

 Используя lameвы можете сделать это с помощью небольшого сценария:
 lame --ti /path/to/file.jpg audio.mp3

 Если файлы названы примерно так, вы можете создать скрипт оболочки, который будет делать то, что вы хотите:
for i in file1.mp3 file2.mp3 file3.mp3; do
  albart=$(echo \$i | sed 's/.mp3/.jpg/')
  lame --ti /path/to/\$albart \$i
done

 Вы можете сделать вышеупомянутое немного более компактным и устранить необходимость sed, используя bashдля этого,
 удалив соответствующий суффикс:
 albart=\"\${i%.mp3}.jpg\" 
";ES;fi;;
        4) S=M4;SC;if [[ $cur == enter ]];then R;echo "
 Cклеить без перекодировки
 sudo apt install mkvtoolnix 
";ES;fi;;
        5) S=M5;SC;if [[ $cur == enter ]];then R;echo "
 mplayer 
";ES;fi;;
        6) S=M6;SC;if [[ $cur == enter ]];then R;echo "
 mpv
";ES;fi;;
 7) S=M7;SC;if [[ $cur == enter ]];then R;echo "
 mpg321
#
 Плейлисты: mpg123 *.mp3
";ES;fi;;
 8) S=M8;SC;if [[ $cur == enter ]];then R;echo "
 cvlc
";ES;fi;;
#
 9) S=M9;SC;if [[ $cur == enter ]];then R;echo "
 sudo apt-get install moc moc-ffmpeg-plugin
#
 Cочетания клавиш: P - для воспроизведения музыки
                   B - для воспроизведения предыдущего трека
                   N - для воспроизведения следующего трека
                   Q - для скрытия интерфейса MOC
                   H - для помощи по использованию плеера
";ES;fi;;
10) S=M10;SC;if [[ $cur == enter ]];then R;echo "
 sudo apt-get install cmus
или
 sudo add-apt-repository ppa:jmuc/cmus
 sudo apt-get update
 sudo apt-get install cmus
#
 введите 5, чтобы перейти к музыке
";ES;fi;;
11) S=M11;SC;if [[ $cur == enter ]];then R;echo "
 nvlc file.mp3
#
 для воспроизведения случайных песен из папки Музыка: nvlc --random /path/to/your/music/folder
";ES;fi;;
12) S=M12;SC;if [[ $cur == enter ]];then R;echo "
 Утилита для визуализации аудио сигнала в режиме реального времени, используя преобразование Фурье с помощью библиотеки FFTW.
";ES;fi;;
13) S=M13;SC;if [[ $cur == enter ]];then R;echo "
 Название утилиты является сращением от Console-based Audio Visualizer for ALSA / MPD and Pulseaudio.
";ES;fi;;
14) S=M14;SC;if [[ $cur == enter ]];then R;echo "
 Более подробная информация о звуковой карте: aplay --list-devices или aplay -l
 Послушать шум драйверов, остановить ctrl+C : aplay -c 2 /dev/urandom
";ES;fi;;
15) S=M15;SC;if [[ $cur == enter ]];then R;echo "
 Проверка звуковых модулей для записи звука: arecord --list-devices
";ES;fi;;
16) S=M16;SC;if [[ $cur == enter ]];then R;echo "
 alsamixer --help
#
 Usage: alsamixer [options]
 Useful options: -h --help  his help
                 -c --card=NUMBER sound card number or id
                 -D --device=NAME mixer device name
                 -V --view=MODE   starting view mode: playback/capture/all
 Debugging options: -g --no-color          toggle using of colors
                    -a --abstraction=NAME  mixer abstraction level: none/basic
 обеспечивает поддержку аудио

 sudo apt-get update
 sudo apt-get install alsa-utils
 ------------------------------- Примеры ---------------------------
 Следующая команда установит громкость на Master control / свойство first звуковой карты на 100%
 amixer -c 0 set Master 100%

 Следующая команда установит громкость Speake r control / свойства second звуковой карты на 30%
 amixer -c 1 set Speaker 50%

 Следующая команда установит громкость Speaker control / свойство second звуковой карты на 3db
 amixer -c 1 set Speaker 3db

 Следующая команда будет увеличивать громкость Speaker control / свойство второй звуковой карты на 2db
 amixer -c 1 set Speaker 2db+

 Используйте следующие команды для mute и unmute свойства.
 amixer -c 0 set Mic mute

 amixer -c 0 set Mic unmute

 volume
 amixer -c 0 set Master 100%
";ES;fi;;
#
17) S=M17;SC;if [[ $cur == enter ]];then R;ls -l;exit 0;fi;;
 esac;POS;done
