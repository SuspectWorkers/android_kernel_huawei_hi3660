# android_kernel_huawei_hi3660 (BakaSU + SUSFS v2.4.0)

Custom Kirin 960 (\hi3660\ / \CMR-W09\) Linux \4.9.337\ kernel tree adapted for clean **AOSP 13** with:

- **BakaSU** (\KernelSU\ \35261\, UAPI \6\, built-in mode)
- **SUSFS v2.4.0** (\hide_sus_mnts_for_non_su_procs\, \vc_log_spoofing\, \sus_path\, \sus_map\)
- **SysMon** (\com.tablet.sysmon\) release certificate embedded in \KernelSU/kernel/manager/manager_sign.h\
- Clean \/proc/version\ / \linux_banner\ without \@\ (\ndroid-build abfarm662\)

Prebuilt padded \oot-susfs-v17-sysmon-padded.img\ and matching \SysMon-v17-local.apk\ are attached in [**Releases**](https://github.com/SuspectWorkers/android_kernel_huawei_hi3660/releases/latest).
