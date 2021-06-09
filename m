Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 827483A10F0
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 12:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235985AbhFIKSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 06:18:11 -0400
Received: from mail-ej1-f50.google.com ([209.85.218.50]:34401 "EHLO
        mail-ej1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234217AbhFIKSK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 06:18:10 -0400
Received: by mail-ej1-f50.google.com with SMTP id g8so37654407ejx.1
        for <stable@vger.kernel.org>; Wed, 09 Jun 2021 03:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SnVZmhAdFHghOloEOvbtb4HkG2ZWJV5NLscWBHBMKRk=;
        b=kugWRrgptt41srmYZXQ1HwsJ3x31HJkK5hQCxKlpIqRpQljvguGXQyNkGJrAcjQqp+
         Dkf3mge0nJ0f7TF3tjrv/UkqaAUJ405QvyhkENstJrYkh3d4GXC3AvZPiW4WWauuZ0r3
         8pbBXV1LTL8tnpgTBQx6zB7tw/btVbnP2pmctykdN7zFPFKzJSmzUT3ocBlx54Zu92jb
         jHCyD8PUzi53EE5kOMPD5PKOJwiQEA3oyb+HcIowkBG/TB70VAXalvB06CDdcvxxqnid
         JznDX2sxL5rXIOgGTdE4WAKJWun7kLb36UBxeDxelpYSCIIvYcJn1SaRC/3r+wIEdInz
         zwpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SnVZmhAdFHghOloEOvbtb4HkG2ZWJV5NLscWBHBMKRk=;
        b=BaDqNwrC+mrJcYN9Jj8gzy1XC+5kt4FEQzHsJlzjMMso8PHkDLaLYr32cKlhOBYjhV
         w6e2glo5fKrnT6cuMjQvkutHZ+uDlOxd9Ux9seJcNdpCEHtOYMr3Y7/DODeC0KxPpbMp
         diKXfQyA4hb3/DhgBzYOhtMjH1eug4Jz5H5xmZ1jWCyJQRAHeLzFMWNNhnRZqr50QWYK
         QIt3XR3QZkfyCeSHUVtzWk/73Jbdn9CofQNceE2okgswkgA4qxWOoXJPJ6bLpkiE1L+o
         hTTgETNWHtddbPKRPtTsgEsQK9/oAgtB7gWNVrNZNSZoBG46z2B5wfQ0s0/TiuOSfwpf
         SWCA==
X-Gm-Message-State: AOAM5330qKL8QPTe8ZH8nCCIGBwwNf23uCQinD2e42dLbXBLpHIqP201
        rNVtGyphfQ0TLFtEob/KXtGXdwhooSXEmJDZndNcKA==
X-Google-Smtp-Source: ABdhPJwZGHKH84T5XPTdm25aloqoGmN4AkAAaOKGZ2iknhw9Vq5g7PRtl0eL4tgfjWyuM4AcOi/xrcaY8hsFLGFaWJs=
X-Received: by 2002:a17:906:c211:: with SMTP id d17mr28124528ejz.247.1623233715196;
 Wed, 09 Jun 2021 03:15:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210608175935.254388043@linuxfoundation.org>
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 9 Jun 2021 15:45:03 +0530
Message-ID: <CA+G9fYutMa2kr6-GUdnZYyVkdutGRXUgQOq1ABt=TZdJ0oW84w@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/78] 5.4.125-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 9 Jun 2021 at 00:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.125 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.125-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.125-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.4.y
* git commit: 90487dc4fc3599ba4b2e00c89edcd0a397d2f051
* git describe: v5.4.124-79-g90487dc4fc35
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.1=
24-79-g90487dc4fc35

## No regressions (compared to v5.4.124)

## No fixes (compared to v5.4.124)

## Test result summary
 total: 74682, pass: 60077, fail: 1521, skip: 11846, xfail: 1238,

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 192 total, 192 passed, 0 failed
* arm64: 26 total, 26 passed, 0 failed
* dragonboard-410c: 1 total, 1 passed, 0 failed
* hi6220-hikey: 1 total, 1 passed, 0 failed
* i386: 15 total, 15 passed, 0 failed
* juno-r2: 1 total, 1 passed, 0 failed
* mips: 42 total, 42 passed, 0 failed
* parisc: 9 total, 9 passed, 0 failed
* powerpc: 27 total, 27 passed, 0 failed
* riscv: 18 total, 18 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 18 total, 18 passed, 0 failed
* sparc: 9 total, 9 passed, 0 failed
* x15: 1 total, 1 passed, 0 failed
* x86: 1 total, 1 passed, 0 failed
* x86_64: 26 total, 26 passed, 0 failed

## Test suites summary
* fwts
* install-android-platform-tools-r2600
* kselftest-
* kselftest-android
* kselftest-bpf
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers
* kselftest-efivarfs
* kselftest-filesystems
* kselftest-firmware
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
* kselftest-lkdtm
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
* kselftest-net
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-vsyscall-mode-native-
* kselftest-x86
* kselftest-zram
* kvm-unit-tests
* libhugetlbfs
* linux-log-parser
* ltp-cap_bounds-tests
* ltp-commands-tests
* ltp-containers-tests
* ltp-controllers-tests
* ltp-cpuhotplug-tests
* ltp-crypto-tests
* ltp-cve-tests
* ltp-dio-tests
* ltp-fcntl-locktests-tests
* ltp-filecaps-tests
* ltp-fs-tests
* ltp-fs_bind-tests
* ltp-fs_perms_simple-tests
* ltp-fsx-tests
* ltp-hugetlb-tests
* ltp-io-tests
* ltp-ipc-tests
* ltp-math-tests
* ltp-mm-tests
* ltp-nptl-tests
* ltp-open-posix-tests
* ltp-pty-tests
* ltp-sched-tests
* ltp-securebits-tests
* ltp-syscalls-tests
* ltp-tracing-tests
* network-basic-tests
* packetdrill
* perf
* rcutorture
* ssuite
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
>
> -------------
> Pseudo-Shortlog of commits:
>
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 5.4.125-rc1
>
> David Ahern <dsahern@kernel.org>
>     neighbour: allow NUD_NOARP entries to be forced GCed
>
> Roja Rani Yarubandi <rojay@codeaurora.org>
>     i2c: qcom-geni: Suspend and resume the bus during SYSTEM_SLEEP_PM ops
>
> Jan Beulich <jbeulich@suse.com>
>     xen-pciback: redo VF placement in the virtual topology
>
> Gao Xiang <hsiangkao@redhat.com>
>     lib/lz4: explicitly support in-place decompression
>
> Vitaly Kuznetsov <vkuznets@redhat.com>
>     x86/kvm: Disable all PV features on crash
>
> Vitaly Kuznetsov <vkuznets@redhat.com>
>     x86/kvm: Disable kvmclock on all CPUs on shutdown
>
> Vitaly Kuznetsov <vkuznets@redhat.com>
>     x86/kvm: Teardown PV features on boot CPU as well
>
> Marc Zyngier <maz@kernel.org>
>     KVM: arm64: Fix debug register indexing
>
> Sean Christopherson <seanjc@google.com>
>     KVM: SVM: Truncate GPR value for DR and CR accesses in !64-bit mode
>
> Anand Jain <anand.jain@oracle.com>
>     btrfs: fix unmountable seed device after fstrim
>
> Matthew Wilcox (Oracle) <willy@infradead.org>
>     mm/filemap: fix storing to a THP shadow entry
>
> Matthew Wilcox (Oracle) <willy@infradead.org>
>     XArray: add xas_split
>
> Matthew Wilcox (Oracle) <willy@infradead.org>
>     XArray: add xa_get_order
>
> Matthew Wilcox (Oracle) <willy@infradead.org>
>     mm: add thp_order
>
> Michael Chan <michael.chan@broadcom.com>
>     bnxt_en: Remove the setting of dev_port.
>
> Mina Almasry <almasrymina@google.com>
>     mm, hugetlb: fix simple resv_huge_pages underflow on UFFDIO_COPY
>
> Josef Bacik <josef@toxicpanda.com>
>     btrfs: fixup error handling in fixup_inode_link_counts
>
> Josef Bacik <josef@toxicpanda.com>
>     btrfs: return errors from btrfs_del_csums in cleanup_ref_head
>
> Josef Bacik <josef@toxicpanda.com>
>     btrfs: fix error handling in btrfs_del_csums
>
> Josef Bacik <josef@toxicpanda.com>
>     btrfs: mark ordered extent and inode with error if we fail to finish
>
> Thomas Gleixner <tglx@linutronix.de>
>     x86/apic: Mark _all_ legacy interrupts when IO/APIC is missing
>
> Nirmoy Das <nirmoy.das@amd.com>
>     drm/amdgpu: make sure we unpin the UVD BO
>
> Luben Tuikov <luben.tuikov@amd.com>
>     drm/amdgpu: Don't query CE and UE errors
>
> Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>     nfc: fix NULL ptr dereference in llcp_sock_getname() after failed con=
nect
>
> Junxiao Bi <junxiao.bi@oracle.com>
>     ocfs2: fix data corruption by fallocate
>
> Mark Rutland <mark.rutland@arm.com>
>     pid: take a reference when initializing `cad_pid`
>
> Phil Elwell <phil@raspberrypi.com>
>     usb: dwc2: Fix build in periphal-only mode
>
> Ye Bin <yebin10@huawei.com>
>     ext4: fix bug on in ext4_es_cache_extent as ext4_split_extent_at fail=
ed
>
> Marek Vasut <marex@denx.de>
>     ARM: dts: imx6q-dhcom: Add PU,VDD1P1,VDD2P5 regulators
>
> Michal Vok=C3=A1=C4=8D <michal.vokac@ysoft.com>
>     ARM: dts: imx6dl-yapp4: Fix RGMII connection to QCA8334 switch
>
> Carlos M <carlos.marr.pz@gmail.com>
>     ALSA: hda: Fix for mute key LED for HP Pavilion 15-CK0xx
>
> Takashi Iwai <tiwai@suse.de>
>     ALSA: timer: Fix master timer notification
>
> Ahelenia Ziemia=C5=84ska <nabijaczleweli@nabijaczleweli.xyz>
>     HID: multitouch: require Finger field to mark Win8 reports as MT
>
> Johan Hovold <johan@kernel.org>
>     HID: magicmouse: fix NULL-deref on disconnect
>
> Johnny Chuang <johnny.chuang.emc@gmail.com>
>     HID: i2c-hid: Skip ELAN power-on command after reset
>
> Pavel Skripkin <paskripkin@gmail.com>
>     net: caif: fix memory leak in cfusbl_device_notify
>
> Pavel Skripkin <paskripkin@gmail.com>
>     net: caif: fix memory leak in caif_device_notify
>
> Pavel Skripkin <paskripkin@gmail.com>
>     net: caif: add proper error handling
>
> Pavel Skripkin <paskripkin@gmail.com>
>     net: caif: added cfserl_release function
>
> Lin Ma <linma@zju.edu.cn>
>     Bluetooth: use correct lock to prevent UAF of hdev object
>
> Lin Ma <linma@zju.edu.cn>
>     Bluetooth: fix the erroneous flush_work() order
>
> Hoang Le <hoang.h.le@dektech.com.au>
>     tipc: fix unique bearer names sanity check
>
> Hoang Le <hoang.h.le@dektech.com.au>
>     tipc: add extack messages for bearer/media failure
>
> Tony Lindgren <tony@atomide.com>
>     bus: ti-sysc: Fix flakey idling of uarts and stop using swsup_sidle_a=
ct
>
> Geert Uytterhoeven <geert+renesas@glider.be>
>     ARM: dts: imx: emcon-avari: Fix nxp,pca8574 #gpio-cells
>
> Fabio Estevam <festevam@gmail.com>
>     ARM: dts: imx7d-pico: Fix the 'tuning-step' property
>
> Fabio Estevam <festevam@gmail.com>
>     ARM: dts: imx7d-meerkat96: Fix the 'tuning-step' property
>
> Lucas Stach <l.stach@pengutronix.de>
>     arm64: dts: zii-ultra: fix 12V_MAIN voltage
>
> Michael Walle <michael@walle.cc>
>     arm64: dts: ls1028a: fix memory node
>
> Magnus Karlsson <magnus.karlsson@intel.com>
>     i40e: add correct exception tracing for XDP
>
> Magnus Karlsson <magnus.karlsson@intel.com>
>     i40e: optimize for XDP_REDIRECT in xsk path
>
> Roja Rani Yarubandi <rojay@codeaurora.org>
>     i2c: qcom-geni: Add shutdown callback for i2c
>
> Dave Ertman <david.m.ertman@intel.com>
>     ice: Allow all LLDP packets from PF to Tx
>
> Brett Creeley <brett.creeley@intel.com>
>     ice: Fix VFR issues for AVF drivers that expect ATQLEN cleared
>
> Mitch Williams <mitch.a.williams@intel.com>
>     ice: write register with correct offset
>
> Coco Li <lixiaoyan@google.com>
>     ipv6: Fix KASAN: slab-out-of-bounds Read in fib6_nh_flush_exceptions
>
> Magnus Karlsson <magnus.karlsson@intel.com>
>     ixgbevf: add correct exception tracing for XDP
>
> Wei Yongjun <weiyongjun1@huawei.com>
>     ieee802154: fix error return code in ieee802154_llsec_getparams()
>
> Zhen Lei <thunder.leizhen@huawei.com>
>     ieee802154: fix error return code in ieee802154_add_iface()
>
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: nfnetlink_cthelper: hit EBUSY on updates if size mismatche=
s
>
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: nft_ct: skip expectations for confirmed conntrack
>
> Erik Kaneda <erik.kaneda@intel.com>
>     ACPICA: Clean up context mutex during object deletion
>
> Ariel Levkovich <lariel@nvidia.com>
>     net/sched: act_ct: Fix ct template allocation for zone 0
>
> Arnd Bergmann <arnd@arndb.de>
>     HID: i2c-hid: fix format string mismatch
>
> Zhen Lei <thunder.leizhen@huawei.com>
>     HID: pidff: fix error return code in hid_pidff_init()
>
> Julian Anastasov <ja@ssi.bg>
>     ipvs: ignore IP_VS_SVC_F_HASHED flag when adding service
>
> Max Gurtovoy <mgurtovoy@nvidia.com>
>     vfio/platform: fix module_put call in error flow
>
> Wei Yongjun <weiyongjun1@huawei.com>
>     samples: vfio-mdev: fix error handing in mdpy_fb_probe()
>
> Randy Dunlap <rdunlap@infradead.org>
>     vfio/pci: zap_vma_ptes() needs MMU
>
> Zhen Lei <thunder.leizhen@huawei.com>
>     vfio/pci: Fix error return code in vfio_ecap_init()
>
> Rasmus Villemoes <linux@rasmusvillemoes.dk>
>     efi: cper: fix snprintf() use in cper_dimm_err_location()
>
> Heiner Kallweit <hkallweit1@gmail.com>
>     efi: Allow EFI_MEMORY_XP and EFI_MEMORY_RO both to be cleared
>
> Florian Westphal <fw@strlen.de>
>     netfilter: conntrack: unregister ipv4 sockopts on error unwind
>
> Armin Wolf <W_Armin@gmx.de>
>     hwmon: (dell-smm-hwmon) Fix index values
>
> Anant Thazhemadam <anant.thazhemadam@gmail.com>
>     nl80211: validate key indexes for cfg80211_registered_device
>
> Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>     ALSA: usb: update old-style static const declaration
>
> Grant Grundler <grundler@chromium.org>
>     net: usb: cdc_ncm: don't spew notifications
>
> Josef Bacik <josef@toxicpanda.com>
>     btrfs: tree-checker: do not error out if extent ref hash doesn't matc=
h
>
>
> -------------
>
> Diffstat:
>
>  Documentation/core-api/xarray.rst                  |  16 +-
>  Makefile                                           |   4 +-
>  arch/arm/boot/dts/imx6dl-yapp4-common.dtsi         |   6 +-
>  arch/arm/boot/dts/imx6q-dhcom-som.dtsi             |  12 ++
>  arch/arm/boot/dts/imx6qdl-emcon-avari.dtsi         |   2 +-
>  arch/arm/boot/dts/imx7d-meerkat96.dts              |   2 +-
>  arch/arm/boot/dts/imx7d-pico.dtsi                  |   2 +-
>  arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi     |   4 +-
>  .../arm64/boot/dts/freescale/imx8mq-zii-ultra.dtsi |   4 +-
>  arch/arm64/kvm/sys_regs.c                          |  42 ++---
>  arch/x86/include/asm/apic.h                        |   1 +
>  arch/x86/include/asm/kvm_para.h                    |  10 +-
>  arch/x86/kernel/apic/apic.c                        |   1 +
>  arch/x86/kernel/apic/vector.c                      |  20 ++
>  arch/x86/kernel/kvm.c                              |  92 ++++++---
>  arch/x86/kernel/kvmclock.c                         |  26 +--
>  arch/x86/kvm/svm.c                                 |   8 +-
>  drivers/acpi/acpica/utdelete.c                     |   8 +
>  drivers/bus/ti-sysc.c                              |   4 +-
>  drivers/firmware/efi/cper.c                        |   4 +-
>  drivers/firmware/efi/memattr.c                     |   5 -
>  drivers/gpu/drm/amd/amdgpu/amdgpu_ctx.c            |  16 --
>  drivers/gpu/drm/amd/amdgpu/uvd_v6_0.c              |   1 +
>  drivers/hid/hid-magicmouse.c                       |   2 +-
>  drivers/hid/hid-multitouch.c                       |  10 +-
>  drivers/hid/i2c-hid/i2c-hid-core.c                 |  13 +-
>  drivers/hid/usbhid/hid-pidff.c                     |   1 +
>  drivers/hwmon/dell-smm-hwmon.c                     |   4 +-
>  drivers/i2c/busses/i2c-qcom-geni.c                 |  21 ++-
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   1 -
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c        |   7 +-
>  drivers/net/ethernet/intel/i40e/i40e_xsk.c         |  15 +-
>  drivers/net/ethernet/intel/ice/ice_hw_autogen.h    |   1 +
>  drivers/net/ethernet/intel/ice/ice_txrx.c          |   5 +-
>  drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c   |  14 +-
>  drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |   3 +
>  drivers/net/usb/cdc_ncm.c                          |  12 +-
>  drivers/usb/dwc2/core_intr.c                       |   4 +
>  drivers/vfio/pci/Kconfig                           |   1 +
>  drivers/vfio/pci/vfio_pci_config.c                 |   2 +-
>  drivers/vfio/platform/vfio_platform_common.c       |   2 +-
>  drivers/xen/xen-pciback/vpci.c                     |  14 +-
>  fs/btrfs/extent-tree.c                             |  12 +-
>  fs/btrfs/file-item.c                               |  10 +-
>  fs/btrfs/inode.c                                   |  12 ++
>  fs/btrfs/tree-checker.c                            |  16 +-
>  fs/btrfs/tree-log.c                                |  13 +-
>  fs/ext4/extents.c                                  |  43 +++--
>  fs/ocfs2/file.c                                    |  55 +++++-
>  include/linux/huge_mm.h                            |  19 ++
>  include/linux/usb/usbnet.h                         |   2 +
>  include/linux/xarray.h                             |  22 +++
>  include/net/caif/caif_dev.h                        |   2 +-
>  include/net/caif/cfcnfg.h                          |   2 +-
>  include/net/caif/cfserl.h                          |   1 +
>  init/main.c                                        |   2 +-
>  lib/lz4/lz4_decompress.c                           |   6 +-
>  lib/lz4/lz4defs.h                                  |   2 +
>  lib/test_xarray.c                                  |  65 +++++++
>  lib/xarray.c                                       | 208 +++++++++++++++=
+++++-
>  mm/filemap.c                                       |  37 +++-
>  mm/hugetlb.c                                       |  14 +-
>  net/bluetooth/hci_core.c                           |   7 +-
>  net/bluetooth/hci_sock.c                           |   4 +-
>  net/caif/caif_dev.c                                |  13 +-
>  net/caif/caif_usb.c                                |  14 +-
>  net/caif/cfcnfg.c                                  |  16 +-
>  net/caif/cfserl.c                                  |   5 +
>  net/core/neighbour.c                               |   1 +
>  net/ieee802154/nl-mac.c                            |   4 +-
>  net/ieee802154/nl-phy.c                            |   4 +-
>  net/ipv6/route.c                                   |   8 +-
>  net/netfilter/ipvs/ip_vs_ctl.c                     |   2 +-
>  net/netfilter/nf_conntrack_proto.c                 |   2 +-
>  net/netfilter/nfnetlink_cthelper.c                 |   8 +-
>  net/netfilter/nft_ct.c                             |   2 +-
>  net/nfc/llcp_sock.c                                |   2 +
>  net/sched/act_ct.c                                 |   3 -
>  net/tipc/bearer.c                                  |  94 +++++++---
>  net/wireless/core.h                                |   2 +
>  net/wireless/nl80211.c                             |   7 +-
>  net/wireless/util.c                                |  39 +++-
>  samples/vfio-mdev/mdpy-fb.c                        |  13 +-
>  sound/core/timer.c                                 |   3 +-
>  sound/pci/hda/patch_realtek.c                      |   1 +
>  sound/usb/mixer_quirks.c                           |   2 +-
>  86 files changed, 926 insertions(+), 295 deletions(-)
>
>
