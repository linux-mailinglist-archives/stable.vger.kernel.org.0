Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1BC646B58D
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 09:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbhLGIWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 03:22:04 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40784 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbhLGIV6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 03:21:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65AC3B80E8C;
        Tue,  7 Dec 2021 08:18:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 623DCC341C1;
        Tue,  7 Dec 2021 08:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638865106;
        bh=8W1naWUNHJFgilQO9cau632gcT+BhWKOJ+hhK/dI1kI=;
        h=From:To:Cc:Subject:Date:From;
        b=Wf6rovignJj5c5JqxG2qcRnfvLdxGq0FN2FQ5ywpJM0p6N0BwVfLdsMHLDs8ij9fu
         CmxfmX4MxMhkaRJBBhMGiasSQJXfWlx9eiVszdaX0Q4LjvOs3p0mfmnya5ITF/+ye0
         dhtX4mRzgYowM46c59AjWc/1dsZa70YvmSnr2AMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.10 000/125] 5.10.84-rc2 review
Date:   Tue,  7 Dec 2021 09:18:22 +0100
Message-Id: <20211207081114.760201765@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.84-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.84-rc2
X-KernelTest-Deadline: 2021-12-09T08:12+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.84 release.
There are 125 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 09 Dec 2021 08:09:22 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.84-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.84-rc2

Wei Yongjun <weiyongjun1@huawei.com>
    ipmi: msghandler: Make symbol 'remove_work_wq' static

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    net/tls: Fix authentication failure in CCM mode

Helge Deller <deller@gmx.de>
    parisc: Mark cr16 CPU clocksource unstable on all SMP machines

Mordechay Goodstein <mordechay.goodstein@intel.com>
    iwlwifi: mvm: retry init flow if failed

Lukas Wunner <lukas@wunner.de>
    serial: 8250: Fix RTS modem control while in rs485 mode

Jay Dolan <jay.dolan@accesio.com>
    serial: 8250_pci: rewrite pericom_do_set_divisor()

Jay Dolan <jay.dolan@accesio.com>
    serial: 8250_pci: Fix ACCES entries in pci_serial_quirks array

Johan Hovold <johan@kernel.org>
    serial: core: fix transmit-buffer reset and memleak

Patrik John <patrik.john@u-blox.com>
    serial: tegra: Change lower tolerance baud rate limit for tegra20 and tegra30

Pierre Gondois <Pierre.Gondois@arm.com>
    serial: pl011: Add ACPI SBSA UART match id

Sven Eckelmann <sven@narfation.org>
    tty: serial: msm_serial: Deactivate RX DMA for polling support

Joerg Roedel <jroedel@suse.de>
    x86/64/mm: Map all kernel memory into trampoline_pgd

Feng Tang <feng.tang@intel.com>
    x86/tsc: Disable clocksource watchdog for TSC on qualified platorms

Feng Tang <feng.tang@intel.com>
    x86/tsc: Add a timer to make sure TSC_adjust is always checked

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpm: Wait in SNK_DEBOUNCED until disconnect

Ole Ernst <olebowle@gmx.com>
    USB: NO_LPM quirk Lenovo Powered USB-C Travel Hub

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix commad ring abort, write all 64 bits to CRCR register.

Maciej W. Rozycki <macro@orcam.me.uk>
    vgacon: Propagate console boot parameters before calling `vc_resize'

Helge Deller <deller@gmx.de>
    parisc: Fix "make install" on newer debian releases

Helge Deller <deller@gmx.de>
    parisc: Fix KBUILD_IMAGE for self-extracting kernel

Lai Jiangshan <laijs@linux.alibaba.com>
    x86/entry: Add a fence for kernel entry SWAPGS in paranoid_entry()

Juergen Gross <jgross@suse.com>
    x86/pv: Switch SWAPGS to ALTERNATIVE

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Fix rq->uclamp_max not set on first enqueue

Lai Jiangshan <laijs@linux.alibaba.com>
    x86/xen: Add xenpv_restore_regs_and_return_to_usermode()

Lai Jiangshan <laijs@linux.alibaba.com>
    x86/entry: Use the correct fence macro after swapgs in kernel CR3

Michael Sterritt <sterritt@google.com>
    x86/sev: Fix SEV-ES INS/OUTS instructions for word, dword, and qword

Dan Carpenter <dan.carpenter@oracle.com>
    KVM: VMX: Set failure code in prepare_vmcs02()

Like Xu <likexu@tencent.com>
    KVM: x86/pmu: Fix reserved bits for AMD PerfEvtSeln register

Sameer Saurabh <ssaurabh@marvell.com>
    atlantic: Remove warn trace message.

Dmitry Bogdanov <dbezrukov@marvell.com>
    atlantic: Fix statistics logic for production hardware

Sameer Saurabh <ssaurabh@marvell.com>
    Remove Half duplex mode speed capabilities.

Nikita Danilov <ndanilov@aquantia.com>
    atlantic: Add missing DIDs and fix 115c.

Sameer Saurabh <ssaurabh@marvell.com>
    atlantic: Fix to display FW bundle version instead of FW mac version.

Nikita Danilov <ndanilov@aquantia.com>
    atlatnic: enable Nbase-t speeds with base-t

Dmitry Bogdanov <dbezrukov@marvell.com>
    atlantic: Increase delay for fw transactions

Rob Clark <robdclark@chromium.org>
    drm/msm: Do hw_init() before capturing GPU state

Douglas Anderson <dianders@chromium.org>
    drm/msm/a6xx: Allocate enough space for GMU registers

Tony Lu <tonylu@linux.alibaba.com>
    net/smc: Keep smc_close_final rc during active close

William Kucharski <william.kucharski@oracle.com>
    net/rds: correct socket tunable error in rds_tcp_tune()

Dust Li <dust.li@linux.alibaba.com>
    net/smc: fix wrong list_del in smc_lgr_cleanup_early

Eric Dumazet <edumazet@google.com>
    ipv4: convert fib_num_tclassid_users to atomic_t

Eric Dumazet <edumazet@google.com>
    net: annotate data-races on txq->xmit_lock_owner

Dongliang Mu <mudongliangabcd@gmail.com>
    dpaa2-eth: destroy workqueue at the end of remove function

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: marvell: mvpp2: Fix the computation of shared CPUs

Sven Schuchmann <schuchmann@schleissheimer.de>
    net: usb: lan78xx: lan78xx_phy_init(): use PHY_POLL instead of "0" if no IRQ is available

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ALSA: intel-dsp-config: add quirk for CML devices based on ES8336 codec

Eiichi Tsukata <eiichi.tsukata@nutanix.com>
    rxrpc: Fix rxrpc_local leak in rxrpc_lookup_peer()

Eiichi Tsukata <eiichi.tsukata@nutanix.com>
    rxrpc: Fix rxrpc_peer leak in rxrpc_look_up_bundle()

Sameer Pujar <spujar@nvidia.com>
    ASoC: tegra: Fix kcontrol put callback in AHUB

Sameer Pujar <spujar@nvidia.com>
    ASoC: tegra: Fix kcontrol put callback in DSPK

Sameer Pujar <spujar@nvidia.com>
    ASoC: tegra: Fix kcontrol put callback in DMIC

Sameer Pujar <spujar@nvidia.com>
    ASoC: tegra: Fix kcontrol put callback in I2S

Sameer Pujar <spujar@nvidia.com>
    ASoC: tegra: Fix kcontrol put callback in ADMAIF

Sameer Pujar <spujar@nvidia.com>
    ASoC: tegra: Fix wrong value type in DSPK

Sameer Pujar <spujar@nvidia.com>
    ASoC: tegra: Fix wrong value type in DMIC

Sameer Pujar <spujar@nvidia.com>
    ASoC: tegra: Fix wrong value type in I2S

Sameer Pujar <spujar@nvidia.com>
    ASoC: tegra: Fix wrong value type in ADMAIF

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7915: fix NULL pointer dereference in mt7915_get_phy_mode

Li Zhijian <lizhijian@cn.fujitsu.com>
    selftests: net: Correct case name

Zhou Qingyang <zhou1615@umn.edu>
    net/mlx4_en: Fix an use-after-free bug in mlx4_en_try_alloc_resources()

Mark Rutland <mark.rutland@arm.com>
    arm64: ftrace: add missing BTIs

Arnd Bergmann <arnd@arndb.de>
    siphash: use _unaligned version by default

Benjamin Poirier <bpoirier@nvidia.com>
    net: mpls: Fix notifications when deleting a device

Zhou Qingyang <zhou1615@umn.edu>
    net: qlogic: qlcnic: Fix a NULL pointer dereference in qlcnic_83xx_add_rings()

Paolo Abeni <pabeni@redhat.com>
    tcp: fix page frag corruption on page fault

Randy Dunlap <rdunlap@infradead.org>
    natsemi: xtensa: fix section mismatch warnings

Aaro Koskinen <aaro.koskinen@iki.fi>
    i2c: cbus-gpio: set atomic transfer callback

Alain Volmat <alain.volmat@foss.st.com>
    i2c: stm32f7: stop dma transfer in case of NACK

Alain Volmat <alain.volmat@foss.st.com>
    i2c: stm32f7: recover the bus on access timeout

Alain Volmat <alain.volmat@foss.st.com>
    i2c: stm32f7: flush TX FIFO upon transfer errors

Gustavo A. R. Silva <gustavoars@kernel.org>
    wireguard: ratelimiter: use kvcalloc() instead of kvzalloc()

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: receive: drop handshakes if queue lock is contended

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: receive: use ring buffer for incoming handshakes

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: device: reset peer src endpoint when netns exits

Li Zhijian <lizhijian@cn.fujitsu.com>
    wireguard: selftests: rename DEBUG_PI_LIST to DEBUG_PLIST

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: selftests: actually test for routing loops

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: allowedips: add missing __rcu annotation to satisfy sparse

Jason A. Donenfeld <Jason@zx2c4.com>
    wireguard: selftests: increase default dmesg log size

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing/histograms: String compares should not care about signed values

Lai Jiangshan <laijs@linux.alibaba.com>
    KVM: X86: Use vcpu->arch.walk_mmu for kvm_mmu_invlpg()

Catalin Marinas <catalin.marinas@arm.com>
    KVM: arm64: Avoid setting the upper 32 bits of TCR_EL2 and CPTR_EL2 to 1

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: Use a stable condition around all VT-d PI paths

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Flush current VPID (L1 vs. L2) for KVM_REQ_TLB_FLUSH_GUEST

Sean Christopherson <seanjc@google.com>
    KVM: Disallow user memslot with size that exceeds "unsigned long"

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Allow DSC on supported MST branch devices

msizanoen1 <msizanoen@qtmlabs.xyz>
    ipv6: fix memory leak in fib6_rule_suppress

Baokun Li <libaokun1@huawei.com>
    sata_fsl: fix warning in remove_proc_entry when rmmod sata_fsl

Baokun Li <libaokun1@huawei.com>
    sata_fsl: fix UAF in sata_fsl_port_stop when rmmod sata_fsl

Linus Torvalds <torvalds@linux-foundation.org>
    fget: check that the fd still exists after getting a ref to it

Niklas Schnelle <schnelle@linux.ibm.com>
    s390/pci: move pseudo-MMIO to prevent MIO overlap

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    cpufreq: Fix get_cpu_device() failure in add_cpu_dev_symlink()

Ioanna Alifieraki <ioanna-maria.alifieraki@canonical.com>
    ipmi: Move remove_work to dedicated workqueue

Stanislaw Gruszka <stf_xl@wp.pl>
    rt2x00: do not mark device gone on EPROTO errors during start

Masami Hiramatsu <mhiramat@kernel.org>
    kprobes: Limit max data_size of the kretprobe instances

Stephen Suryaputra <ssuryaextr@gmail.com>
    vrf: Reset IPCB/IP6CB when processing outbound pkts in vrf dev xmit

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: Add stubs for wakeup handler functions

Wen Gu <guwen@linux.alibaba.com>
    net/smc: Avoid warning of possible recursive locking

Ian Rogers <irogers@google.com>
    perf report: Fix memory leaks around perf_tip()

Ian Rogers <irogers@google.com>
    perf hist: Fix memory leak of a perf_hpp_fmt

German Gomez <german.gomez@arm.com>
    perf inject: Fix ARM SPE handling

Teng Qi <starmiku1207184332@gmail.com>
    net: ethernet: dec: tulip: de4x5: fix possible array overflows in type3_infoblock()

zhangyue <zhangyue1@kylinos.cn>
    net: tulip: de4x5: fix the problem that the array 'lp->phy[8]' may be out of bound

Jordy Zomer <jordy@pwning.systems>
    ipv6: check return value of ipv6_skip_exthdr

Teng Qi <starmiku1207184332@gmail.com>
    ethernet: hisilicon: hns: hns_dsaf_misc: fix a possible array overflow in hns_dsaf_ge_srst_by_port()

Mario Limonciello <mario.limonciello@amd.com>
    ata: ahci: Add Green Sardine vendor ID as board_ahci_mobile

Bernard Zhao <bernard@vivo.com>
    drm/amd/amdgpu: fix potential memleak

shaoyunl <shaoyun.liu@amd.com>
    drm/amd/amdkfd: Fix kernel panic when reset failed and been triggered again

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Unblock session then wake up error handler

Manaf Meethalavalappu Pallikunhi <manafm@codeaurora.org>
    thermal: core: Reset previous low and high trip during thermal zone init

Wang Yugui <wangyugui@e16-tech.com>
    btrfs: check-integrity: fix a warning on write caching disabled disk

Vasily Gorbik <gor@linux.ibm.com>
    s390/setup: avoid using memblock_enforce_memory_limit

Slark Xiao <slark_xiao@163.com>
    platform/x86: thinkpad_acpi: Fix WWAN device disabled issue after S3 deep

Jimmy Wang <jimmy221b@163.com>
    platform/x86: thinkpad_acpi: Add support for dual fan control

liuguoqiang <liuguoqiang@uniontech.com>
    net: return correct error code

Zekun Shen <bruceshenzk@gmail.com>
    atlantic: Fix OOB read and write in hw_atl_utils_fw_rpc_wait

Wen Gu <guwen@linux.alibaba.com>
    net/smc: Transfer remaining wait queue entries during fallback

Xing Song <xing.song@mediatek.com>
    mac80211: do not access the IV when it was stripped

Julian Braha <julianbraha@gmail.com>
    drm/sun4i: fix unmet dependency on RESET_CONTROLLER for PHY_SUN6I_MIPI_DPHY

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/pseries/ddw: Revert "Extend upper limit for huge DMA window for persistent memory"

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix length of holes reported at end-of-file

Bob Peterson <rpeterso@redhat.com>
    gfs2: release iopen glock early in evict

Miklos Szeredi <mszeredi@redhat.com>
    ovl: fix deadlock in splice write

Miklos Szeredi <mszeredi@redhat.com>
    ovl: simplify file splice

Zhang Changzhong <zhangchangzhong@huawei.com>
    can: j1939: j1939_tp_cmd_recv(): check the dst address of TP.CM_BAM

Benjamin Coddington <bcodding@redhat.com>
    NFSv42: Fix pagecache invalidation after COPY/CLONE


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/include/asm/kvm_arm.h                   |   4 +-
 arch/arm64/kernel/entry-ftrace.S                   |   6 +
 arch/parisc/Makefile                               |   5 +
 arch/parisc/install.sh                             |   1 +
 arch/parisc/kernel/time.c                          |  24 +-
 arch/powerpc/platforms/pseries/iommu.c             |   9 -
 arch/s390/include/asm/pci_io.h                     |   7 +-
 arch/s390/kernel/setup.c                           |   3 -
 arch/x86/entry/entry_64.S                          |  45 ++--
 arch/x86/include/asm/irqflags.h                    |  20 +-
 arch/x86/include/asm/paravirt.h                    |  20 --
 arch/x86/include/asm/paravirt_types.h              |   2 -
 arch/x86/kernel/asm-offsets_64.c                   |   1 -
 arch/x86/kernel/paravirt.c                         |   1 -
 arch/x86/kernel/paravirt_patch.c                   |   3 -
 arch/x86/kernel/sev-es.c                           |  57 ++--
 arch/x86/kernel/tsc.c                              |  28 +-
 arch/x86/kernel/tsc_sync.c                         |  41 +++
 arch/x86/kvm/mmu/mmu.c                             |   2 +-
 arch/x86/kvm/svm/pmu.c                             |   2 +-
 arch/x86/kvm/vmx/nested.c                          |   4 +-
 arch/x86/kvm/vmx/posted_intr.c                     |  20 +-
 arch/x86/kvm/vmx/vmx.c                             |  23 +-
 arch/x86/realmode/init.c                           |  12 +-
 arch/x86/xen/enlighten_pv.c                        |   3 -
 arch/x86/xen/xen-asm.S                             |  20 ++
 drivers/ata/ahci.c                                 |   1 +
 drivers/ata/sata_fsl.c                             |  20 +-
 drivers/char/ipmi/ipmi_msghandler.c                |  13 +-
 drivers/cpufreq/cpufreq.c                          |   9 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_xgmi.c           |   1 +
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |   5 +
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |  20 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c        |   4 +-
 drivers/gpu/drm/msm/msm_debugfs.c                  |   1 +
 drivers/gpu/drm/sun4i/Kconfig                      |   1 +
 drivers/i2c/busses/i2c-cbus-gpio.c                 |   5 +-
 drivers/i2c/busses/i2c-stm32f7.c                   |  31 ++-
 drivers/net/ethernet/aquantia/atlantic/aq_common.h |  27 +-
 drivers/net/ethernet/aquantia/atlantic/aq_hw.h     |   2 +
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c    |  10 +-
 .../net/ethernet/aquantia/atlantic/aq_pci_func.c   |   7 +-
 drivers/net/ethernet/aquantia/atlantic/aq_vec.c    |   3 -
 .../aquantia/atlantic/hw_atl/hw_atl_utils.c        |  25 +-
 .../aquantia/atlantic/hw_atl/hw_atl_utils_fw2x.c   |   3 -
 .../ethernet/aquantia/atlantic/hw_atl2/hw_atl2.c   |  22 +-
 .../ethernet/aquantia/atlantic/hw_atl2/hw_atl2.h   |   2 +
 .../aquantia/atlantic/hw_atl2/hw_atl2_utils.h      |  38 ++-
 .../aquantia/atlantic/hw_atl2/hw_atl2_utils_fw.c   | 110 ++++++--
 drivers/net/ethernet/dec/tulip/de4x5.c             |  34 ++-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c   |   2 +
 drivers/net/ethernet/hisilicon/hns/hns_dsaf_misc.c |   4 +
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c     |   9 +-
 drivers/net/ethernet/natsemi/xtsonic.c             |   2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c    |  10 +-
 drivers/net/usb/lan78xx.c                          |   2 +-
 drivers/net/vrf.c                                  |   2 +
 drivers/net/wireguard/allowedips.c                 |   2 +-
 drivers/net/wireguard/device.c                     |  39 +--
 drivers/net/wireguard/device.h                     |   9 +-
 drivers/net/wireguard/queueing.c                   |   6 +-
 drivers/net/wireguard/queueing.h                   |   2 +-
 drivers/net/wireguard/ratelimiter.c                |   4 +-
 drivers/net/wireguard/receive.c                    |  39 +--
 drivers/net/wireguard/socket.c                     |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c       |  22 +-
 drivers/net/wireless/intel/iwlwifi/iwl-drv.h       |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  24 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       |   3 +
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c       |   3 +
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |   4 +-
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c     |   3 +
 drivers/platform/x86/thinkpad_acpi.c               |  13 +-
 drivers/scsi/scsi_transport_iscsi.c                |   6 +-
 drivers/thermal/thermal_core.c                     |   2 +
 drivers/tty/serial/8250/8250_pci.c                 |  39 ++-
 drivers/tty/serial/8250/8250_port.c                |   7 -
 drivers/tty/serial/amba-pl011.c                    |   1 +
 drivers/tty/serial/msm_serial.c                    |   3 +
 drivers/tty/serial/serial-tegra.c                  |   4 +-
 drivers/tty/serial/serial_core.c                   |  18 +-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/host/xhci-ring.c                       |  21 +-
 drivers/usb/typec/tcpm/tcpm.c                      |   4 -
 drivers/video/console/vgacon.c                     |  14 +-
 fs/btrfs/disk-io.c                                 |  14 +-
 fs/file.c                                          |   4 +
 fs/gfs2/bmap.c                                     |   2 +-
 fs/gfs2/super.c                                    |  14 +-
 fs/nfs/nfs42proc.c                                 |   5 +-
 fs/overlayfs/file.c                                |  59 ++--
 include/linux/acpi.h                               |   9 +
 include/linux/kprobes.h                            |   2 +
 include/linux/netdevice.h                          |  19 +-
 include/linux/siphash.h                            |  14 +-
 include/net/dst_cache.h                            |  11 +
 include/net/fib_rules.h                            |   4 +-
 include/net/ip_fib.h                               |   2 +-
 include/net/netns/ipv4.h                           |   2 +-
 include/net/sock.h                                 |  13 +-
 kernel/kprobes.c                                   |   3 +
 kernel/sched/core.c                                |   2 +-
 kernel/trace/trace_events_hist.c                   |   2 +-
 lib/siphash.c                                      |  12 +-
 net/can/j1939/transport.c                          |   6 +
 net/core/dev.c                                     |   5 +-
 net/core/dst_cache.c                               |  19 ++
 net/core/fib_rules.c                               |   2 +-
 net/ipv4/devinet.c                                 |   2 +-
 net/ipv4/fib_frontend.c                            |   2 +-
 net/ipv4/fib_rules.c                               |   5 +-
 net/ipv4/fib_semantics.c                           |   4 +-
 net/ipv6/esp6.c                                    |   6 +
 net/ipv6/fib6_rules.c                              |   4 +-
 net/mac80211/rx.c                                  |   3 +-
 net/mpls/af_mpls.c                                 |  68 +++--
 net/rds/tcp.c                                      |   2 +-
 net/rxrpc/conn_client.c                            |  14 +-
 net/rxrpc/peer_object.c                            |  14 +-
 net/smc/af_smc.c                                   |  14 +
 net/smc/smc_close.c                                |   8 +-
 net/smc/smc_core.c                                 |   7 +-
 net/tls/tls_sw.c                                   |   4 +-
 sound/hda/intel-dsp-config.c                       |  10 +
 sound/soc/tegra/tegra186_dspk.c                    | 181 ++++++++++---
 sound/soc/tegra/tegra210_admaif.c                  | 140 +++++++---
 sound/soc/tegra/tegra210_ahub.c                    |  11 +-
 sound/soc/tegra/tegra210_dmic.c                    | 184 ++++++++++---
 sound/soc/tegra/tegra210_i2s.c                     | 296 ++++++++++++++++-----
 tools/perf/builtin-report.c                        |  15 +-
 tools/perf/ui/hist.c                               |  28 +-
 tools/perf/util/arm-spe.c                          |  15 ++
 tools/perf/util/hist.h                             |   1 -
 tools/perf/util/util.c                             |  14 +-
 tools/perf/util/util.h                             |   2 +-
 tools/testing/selftests/net/fcnal-test.sh          |   4 +-
 tools/testing/selftests/wireguard/netns.sh         |  30 ++-
 .../testing/selftests/wireguard/qemu/debug.config  |   2 +-
 .../testing/selftests/wireguard/qemu/kernel.config |   1 +
 virt/kvm/kvm_main.c                                |   3 +-
 142 files changed, 1729 insertions(+), 684 deletions(-)


