@echo off
cls
cd /d %~dp0
set "tcd=%cd:\=/%"

pushd ".\grub\"

grub-mkimage.exe -c ..\cfg\grub_cd.cfg -d i386-pc -p /grub -o core.img -O i386-pc linux16 linux normal iso9660 biosdisk memdisk search tar ls
timeout.exe /t 2 /nobreak >nul

if exist ..\grub2.img del /f /q ..\grub2.img >nul
copy /b .\i386-pc\cdboot.img+core.img ..\grub2.img
del /f /q core.img
popd
pause

if exist .\grub2.iso del /f /q .\grub2.iso >nul

.\xorriso\xorriso.exe -as mkisofs -iso-level 3 -full-iso9660-filenames -eltorito-boot grub/grub2.img ^
 -no-emul-boot -boot-load-size 4 -boot-info-table --eltorito-catalog grub/boot.cat --grub2-boot-info ^
 --grub2-mbr grub/i386-pc/boot_hybrid.img -eltorito-alt-boot -output "%tcd%/grub2.iso" -graft-points "grub=./grub" ^
  grub/grub2.img=grub2.img

pause
exit