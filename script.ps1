# ===================================================================================
# == Windows 11 24H2 就地升级绕过脚本 (PowerShell 最终修正版)
# == 使用 --% 操作符来确保 reg.exe 命令的参数被正确传递
# ===================================================================================

# -----------------------------------------------------------------------------------
# -- 步骤一：清理旧的失败记录 (Clear old failure records)
# -----------------------------------------------------------------------------------

Write-Host "步骤一：正在清理旧的升级失败记录..." -ForegroundColor Yellow
# 使用 --% 确保 PowerShell 不会错误解析参数
reg.exe --% delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\CompatMarkers" /f 2>$null
reg.exe --% delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Shared" /f 2>$null
reg.exe --% delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\TargetVersionUpgradeExperienceIndicators" /f 2>$null
Write-Host "清理完成。" -ForegroundColor Green


# -----------------------------------------------------------------------------------
# -- 步骤二：伪造一份完美的硬件报告 (Forge a perfect hardware report)
# -----------------------------------------------------------------------------------

Write-Host "步骤二：正在伪造硬件兼容性报告..." -ForegroundColor Yellow
# 使用 --% 解决逗号被 PowerShell 错误解析的问题
reg.exe --% add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\HwReqChk" /f /v HwReqChkVars /t REG_MULTI_SZ /s , /d "SQ_SecureBootCapable=TRUE,SQ_SecureBootEnabled=TRUE,SQ_TpmVersion=2,SQ_RamMB=8192,"
Write-Host "伪造报告已写入。" -ForegroundColor Green


# -----------------------------------------------------------------------------------
# -- 步骤三：使用官方后门强制放行 (Use the official backdoor to force it)
# -----------------------------------------------------------------------------------

Write-Host "步骤三：正在启用官方升级后门..." -ForegroundColor Yellow
# 移除了重复的 /f 参数，并使用 --% 确保健壮性
reg.exe --% add "HKLM\SYSTEM\Setup\MoSetup" /v AllowUpgradesWithUnsupportedTPMOrCPU /t REG_DWORD /d 1 /f
Write-Host "官方后门已启用。" -ForegroundColor Green

# -----------------------------------------------------------------------------------
# -- 完成
# -----------------------------------------------------------------------------------

Write-Host ""
Write-Host "==============================================================================" -ForegroundColor Cyan
Write-Host "== 所有操作已成功完成！                                                  ==" -ForegroundColor Cyan
Write-Host "== 您现在可以运行 Windows 11 24H2 的 setup.exe 进行就地升级。无需重启。 ==" -ForegroundColor Cyan
Write-Host "==============================================================================" -ForegroundColor Cyan