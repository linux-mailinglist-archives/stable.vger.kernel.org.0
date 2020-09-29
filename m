Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12CF327C763
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730881AbgI2Lx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:53:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731045AbgI2Lq7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:46:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D58B22262;
        Tue, 29 Sep 2020 11:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380013;
        bh=geEtgt5e41k56UZuQoFd0tXYoAWOJztPQMBBibF8134=;
        h=From:To:Cc:Subject:Date:From;
        b=aAe0mtnFXdiOtQHjSW0PuAIzHXbYaZI6Edir3iDhfBjyPFVgky9WxNi4cwbFG7hKc
         8VRw597Sumhhr76ecqk4cjvSgnsILPM3znUxvEi3lLfB4OtS8zVlTz+6JMQxeRJfmk
         H9+djMc3pRAcI+JFKB4xJc6w3OrWoKHaD5E+2M7Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        pavel@denx.de, stable@vger.kernel.org
Subject: [PATCH 5.8 00/99] 5.8.13-rc1 review
Date:   Tue, 29 Sep 2020 13:00:43 +0200
Message-Id: <20200929105929.719230296@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.8.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.8.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.8.13-rc1
X-KernelTest-Deadline: 2020-10-01T10:59+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.8.13 release.
There are 99 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 01 Oct 2020 10:59:03 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.8.13-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.8.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.8.13-rc1

Tony Lindgren <tony@atomide.com>
    clocksource/drivers/timer-ti-dm: Do reset before enable

Mike Snitzer <snitzer@redhat.com>
    dm: fix bio splitting and its bio completion order for regular IO

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Assume write fault on S1PTW permission fault on instruction fetch

Jens Axboe <axboe@kernel.dk>
    io_uring: ensure open/openat2 name is cleaned on cancelation

Christian Borntraeger <borntraeger@de.ibm.com>
    s390/zcrypt: Fix ZCRYPT_PERDEV_REQCNT ioctl

Laurent Dufour <ldufour@linux.ibm.com>
    mm: don't rely on system state to detect hot-plug operations

Laurent Dufour <ldufour@linux.ibm.com>
    mm: replace memmap_context by meminit_context

Vasily Gorbik <gor@linux.ibm.com>
    mm/gup: fix gup_fast with dynamic page table folding

Gao Xiang <hsiangkao@redhat.com>
    mm, THP, swap: fix allocating cluster for swapfile by mistake

Charan Teja Reddy <charante@codeaurora.org>
    dmabuf: fix NULL pointer dereference in dma_buf_release()

Jiaxun Yang <jiaxun.yang@flygoat.com>
    MIPS: Loongson2ef: Disable Loongson MMI instructions

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec-adap.c: don't use flush_scheduled_work()

Johannes Thumshirn <johannes.thumshirn@wdc.com>
    btrfs: fix overflow when copying corrupt csums for a message

Anand Jain <anand.jain@oracle.com>
    btrfs: fix put of uninitialized kobject after seed device delete

Masami Hiramatsu <mhiramat@kernel.org>
    kprobes: tracing/kprobes: Fix to kill kprobes on initmem after boot

Masami Hiramatsu <mhiramat@kernel.org>
    kprobes: Fix to check probe enabled before disarm_kprobe_ftrace()

Masami Hiramatsu <mhiramat@kernel.org>
    lib/bootconfig: Fix to remove tailing spaces after value

Masami Hiramatsu <mhiramat@kernel.org>
    lib/bootconfig: Fix a bug of breaking existing tree nodes

Felix Fietkau <nbd@nbd.name>
    mt76: mt7615: use v1 MCU API on MT7615 to fix issues with adding/removing stations

Jan Höppner <hoeppner@linux.ibm.com>
    s390/dasd: Fix zero write for FBA devices

Tom Rix <trix@redhat.com>
    tracing: fix double free

Nick Desaulniers <ndesaulniers@google.com>
    lib/string.c: implement stpcpy

Kai-Heng Feng <kai.heng.feng@canonical.com>
    ALSA: hda/realtek: Enable front panel headset LED on Lenovo ThinkStation P520

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek - Couldn't detect Mic if booting with headset plugged

Joakim Tjernlund <joakim.tjernlund@infinera.com>
    ALSA: usb-audio: Add delay quirk for H570e USB headsets

James Smart <james.smart@broadcom.com>
    scsi: lpfc: Fix initial FLOGI failure due to BBSCN not supported

Thomas Gleixner <tglx@linutronix.de>
    x86/ioapic: Unbreak check_timer()

Thomas Gleixner <tglx@linutronix.de>
    x86/irq: Make run_on_irqstack_cond() typesafe

Mikulas Patocka <mpatocka@redhat.com>
    arch/x86/lib/usercopy_64.c: fix __copy_user_flushcache() cache writeback

Minchan Kim <minchan@kernel.org>
    mm: validate pmd after splitting

Tom Lendacky <thomas.lendacky@amd.com>
    KVM: SVM: Add a dedicated INVD intercept routine

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Reset MMU context if guest toggles CR4.SMAP or CR4.PKE

Ray Jui <ray.jui@broadcom.com>
    spi: bcm-qspi: Fix probe regression on iProc platforms

Icenowy Zheng <icenowy@aosc.io>
    regulator: axp20x: fix LDO2/4 description

Wei Li <liwei391@huawei.com>
    MIPS: Add the missing 'CPU_1074K' into __get_cpu_type()

Dan Carpenter <dan.carpenter@oracle.com>
    PM / devfreq: tegra30: Disable clock on error in probe

Huacai Chen <chenhc@lemote.com>
    MIPS: Loongson-3: Fix fp register access if MSA enabled

Saeed Mahameed <saeedm@nvidia.com>
    net/mlx5e: mlx5e_fec_in_caps() returns a boolean

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    regmap: fix page selection for noinc writes

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    regmap: fix page selection for noinc reads

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix svc_flush_dcache()

Jens Axboe <axboe@kernel.dk>
    io_uring: fix openat/openat2 unified prep handling

Tom Rix <trix@redhat.com>
    ALSA: asihpi: fix iounmap in error handler

John Crispin <john@phrozen.org>
    mac80211: fix 80 MHz association to 160/80+80 AP on 6 GHz

Johannes Berg <johannes.berg@intel.com>
    cfg80211: fix 6 GHz channel conversion

Wen Gong <wgong@codeaurora.org>
    mac80211: do not disable HE if HT is missing on 2.4 GHz

Necip Fazil Yildiran <fazilyildiran@gmail.com>
    lib80211: fix unmet direct dependendices config warning when !CRYPTO

Yonghong Song <yhs@fb.com>
    bpf: Fix a rcu warning for bpffs map pretty-print

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: mcast: fix duplicate mcast packets from BLA backbone to mesh

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: mcast: fix duplicate mcast packets in BLA backbone from mesh

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: mcast: fix duplicate mcast packets in BLA backbone from LAN

Necip Fazil Yildiran <fazilyildiran@gmail.com>
    nvme-tcp: fix kconfig dependency warning when !CRYPTO

Björn Töpel <bjorn.topel@intel.com>
    xsk: Fix number of pinned pages/umem size discrepancy

Sven Eckelmann <sven@narfation.org>
    batman-adv: Add missing include for in_interrupt()

Jason Gunthorpe <jgg@nvidia.com>
    RDMA/core: Fix ordering of CQ pool destruction

Vladimir Oltean <vladimir.oltean@nxp.com>
    spi: spi-fsl-dspi: use XSPI mode instead of DMA for DPAA2 SoCs

Dexuan Cui <decui@microsoft.com>
    hv_netvsc: Switch the data path at the right time during hibernation

Martin Cerveny <m.cerveny@computer.org>
    drm/sun4i: sun8i-csc: Secondary CSC register correction

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    igc: Fix not considering the TX delay for timestamps

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    igc: Fix wrong timestamp latency numbers

Dmitry Bogdanov <dbogdanov@marvell.com>
    net: qed: RDMA personality shouldn't fail VF load

Dmitry Bogdanov <dbogdanov@marvell.com>
    net: qede: Disable aRFS for NPAR and 100G

Dmitry Bogdanov <dbogdanov@marvell.com>
    net: qed: Disable aRFS for NPAR and 100G

Marek Szyprowski <m.szyprowski@samsung.com>
    drm/vc4/vc4_hdmi: fill ASoC card owner

Tony Ambardar <tony.ambardar@gmail.com>
    tools/libbpf: Avoid counting local symbols in ABI check

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix clobbering of r2 in bpf_gen_ld_abs

Eric Dumazet <edumazet@google.com>
    mac802154: tx: fix use-after-free

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_meta: use socket user_ns to retrieve skuid and skgid

Eelco Chaudron <echaudro@redhat.com>
    netfilter: conntrack: nf_conncount_init is failing with IPv6 disabled

Martin Willi <martin@strongswan.org>
    netfilter: ctnetlink: fix mark based dump filtering regression

Will McVicker <willmcvicker@google.com>
    netfilter: ctnetlink: add a range check for l3/l4 protonum

Linus Lüssing <linus.luessing@c0d3.blue>
    batman-adv: mcast/TT: fix wrongly dropped or rerouted packets

Jing Xiangfeng <jingxiangfeng@huawei.com>
    atm: eni: fix the missed pci_disable_device() for eni_init_one()

Tony Ambardar <tony.ambardar@gmail.com>
    libbpf: Fix build failure from uninitialized variable warning

Linus Lüssing <ll@simonwunderlich.de>
    batman-adv: bla: fix type misuse for backbone_gw hash indexing

Maximilian Luz <luzmaximilian@gmail.com>
    mwifiex: Increase AES key storage size to 256 bits

Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
    clocksource/drivers/h8300_timer8: Fix wrong return value in h8300_8timer_init()

Tom Rix <trix@redhat.com>
    ieee802154/adf7242: check status of adf7242_read_reg

Liu Jian <liujian56@huawei.com>
    ieee802154: fix one possible memleak in ca8210_dev_com_init

Damien Le Moal <damien.lemoal@wdc.com>
    riscv: Fix Kendryte K210 device tree

Qii Wang <qii.wang@mediatek.com>
    i2c: mediatek: Send i2c master code at more than 1MHz

Josh Poimboeuf <jpoimboe@redhat.com>
    objtool: Fix noreturn detection for ignored functions

Hans de Goede <hdegoede@redhat.com>
    i2c: core: Call i2c_acpi_install_space_handler() before i2c_acpi_register_devices()

Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
    drm/amd/display: Don't log hdcp module warnings in dmesg

Michel Dänzer <mdaenzer@redhat.com>
    drm/amdgpu/dc: Require primary plane to be enabled whenever the CRTC is

Jun Lei <jun.lei@amd.com>
    drm/amd/display: update nv1x stutter latencies

Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
    drm/amd/display: Don't use DRM_ERROR() for DTM add topology

Dennis Li <Dennis.Li@amd.com>
    drm/amdkfd: fix a memory leak issue

Borislav Petkov <bp@suse.de>
    EDAC/ghes: Check whether the driver is on the safe list correctly

Sven Schnelle <svens@linux.ibm.com>
    lockdep: fix order in trace_hardirqs_off_caller()

Ilya Leoshkevich <iii@linux.ibm.com>
    s390/init: add missing __init annotations

Eddie James <eajames@linux.ibm.com>
    i2c: aspeed: Mask IRQ status to relevant bits

Palmer Dabbelt <palmerdabbelt@google.com>
    RISC-V: Take text_mutex in ftrace_init_nop()

Sumera Priyadarsini <sylphrenadin@gmail.com>
    clk: versatile: Add of_node_put() before return statement

Hans de Goede <hdegoede@redhat.com>
    ASoC: Intel: bytcr_rt5640: Add quirk for MPMAN Converter9 2-in-1

Sylwester Nawrocki <s.nawrocki@samsung.com>
    ASoC: wm8994: Ensure the device is resumed in wm89xx_mic_detect functions

Sylwester Nawrocki <s.nawrocki@samsung.com>
    ASoC: wm8994: Skip setting of the WM8994_MICBIAS register for WM1811

Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
    ASoC: pcm3168a: ignore 0 Hz settings

Amol Grover <frextrite@gmail.com>
    device_cgroup: Fix RCU list debugging warning


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arm64/include/asm/kvm_emulate.h               |  12 +-
 arch/arm64/kvm/hyp/switch.c                        |   2 +-
 arch/arm64/kvm/mmio.c                              |   2 +-
 arch/arm64/kvm/mmu.c                               |   2 +-
 arch/ia64/mm/init.c                                |   6 +-
 arch/mips/include/asm/cpu-type.h                   |   1 +
 arch/mips/loongson2ef/Platform                     |   4 +
 arch/mips/loongson64/cop2-ex.c                     |  24 ++--
 arch/riscv/boot/dts/kendryte/k210.dtsi             |   6 +-
 arch/riscv/include/asm/ftrace.h                    |   7 +
 arch/riscv/kernel/ftrace.c                         |  19 +++
 arch/s390/include/asm/pgtable.h                    |  42 ++++--
 arch/s390/kernel/setup.c                           |   6 +-
 arch/x86/entry/common.c                            |   2 +-
 arch/x86/entry/entry_64.S                          |   2 +
 arch/x86/include/asm/idtentry.h                    |   2 +-
 arch/x86/include/asm/irq_stack.h                   |  70 ++++++++--
 arch/x86/kernel/apic/io_apic.c                     |   1 +
 arch/x86/kernel/irq.c                              |   2 +-
 arch/x86/kernel/irq_64.c                           |   2 +-
 arch/x86/kvm/svm/svm.c                             |   8 +-
 arch/x86/kvm/x86.c                                 |   3 +-
 arch/x86/lib/usercopy_64.c                         |   2 +-
 drivers/atm/eni.c                                  |   2 +-
 drivers/base/node.c                                |  85 +++++++-----
 drivers/base/regmap/internal.h                     |   2 +-
 drivers/base/regmap/regcache.c                     |   2 +-
 drivers/base/regmap/regmap.c                       |  33 ++---
 drivers/clk/versatile/clk-impd1.c                  |   4 +-
 drivers/clocksource/h8300_timer8.c                 |   2 +-
 drivers/clocksource/timer-ti-dm-systimer.c         |  44 ++++---
 drivers/devfreq/tegra30-devfreq.c                  |   4 +-
 drivers/dma-buf/dma-buf.c                          |   2 +
 drivers/edac/ghes_edac.c                           |   4 +
 .../gpu/drm/amd/amdkfd/kfd_device_queue_manager.c  |   2 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  32 ++---
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  |   4 +-
 .../gpu/drm/amd/display/modules/hdcp/hdcp_log.h    |   2 +-
 .../gpu/drm/amd/display/modules/hdcp/hdcp_psp.c    |   2 +-
 drivers/gpu/drm/sun4i/sun8i_csc.h                  |   2 +-
 drivers/gpu/drm/vc4/vc4_hdmi.c                     |   1 +
 drivers/i2c/busses/i2c-aspeed.c                    |   2 +
 drivers/i2c/busses/i2c-mt65xx.c                    |   2 +-
 drivers/i2c/i2c-core-base.c                        |   2 +-
 drivers/infiniband/core/device.c                   |   6 +-
 drivers/md/dm.c                                    |  23 +---
 drivers/media/cec/core/cec-adap.c                  |   2 +-
 drivers/net/ethernet/intel/igc/igc.h               |  20 ++-
 drivers/net/ethernet/intel/igc/igc_ptp.c           |  19 +++
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c  |   7 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c          |  11 +-
 drivers/net/ethernet/qlogic/qed/qed_l2.c           |   3 +
 drivers/net/ethernet/qlogic/qed/qed_main.c         |   2 +
 drivers/net/ethernet/qlogic/qed/qed_sriov.c        |   1 +
 drivers/net/ethernet/qlogic/qede/qede_filter.c     |   3 +
 drivers/net/ethernet/qlogic/qede/qede_main.c       |  11 +-
 drivers/net/hyperv/netvsc_drv.c                    |  11 +-
 drivers/net/ieee802154/adf7242.c                   |   4 +-
 drivers/net/ieee802154/ca8210.c                    |   1 +
 drivers/net/wireless/marvell/mwifiex/fw.h          |   2 +-
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c    |   3 +-
 drivers/nvme/host/Kconfig                          |   1 +
 drivers/regulator/axp20x-regulator.c               |   7 +-
 drivers/s390/block/dasd_fba.c                      |   9 +-
 drivers/s390/crypto/zcrypt_api.c                   |   3 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                   |  76 +++++++----
 drivers/spi/spi-bcm-qspi.c                         |   2 +-
 drivers/spi/spi-fsl-dspi.c                         |   6 +-
 fs/btrfs/disk-io.c                                 |  11 +-
 fs/btrfs/sysfs.c                                   |  16 ++-
 fs/io_uring.c                                      |   8 +-
 include/linux/kprobes.h                            |   5 +
 include/linux/mm.h                                 |   2 +-
 include/linux/mmzone.h                             |  11 +-
 include/linux/node.h                               |  11 +-
 include/linux/pgtable.h                            |  10 ++
 include/linux/qed/qed_if.h                         |   1 +
 init/main.c                                        |   2 +
 kernel/bpf/inode.c                                 |   4 +-
 kernel/kprobes.c                                   |  27 +++-
 kernel/trace/trace_events_hist.c                   |   1 -
 kernel/trace/trace_preemptirq.c                    |   4 +-
 lib/bootconfig.c                                   |  38 ++++--
 lib/string.c                                       |  24 ++++
 mm/gup.c                                           |  18 +--
 mm/madvise.c                                       |   2 +-
 mm/memory_hotplug.c                                |   5 +-
 mm/page_alloc.c                                    |  10 +-
 mm/swapfile.c                                      |   2 +-
 net/batman-adv/bridge_loop_avoidance.c             | 145 +++++++++++++++++----
 net/batman-adv/bridge_loop_avoidance.h             |   4 +-
 net/batman-adv/multicast.c                         |  46 +++++--
 net/batman-adv/multicast.h                         |  15 +++
 net/batman-adv/routing.c                           |   4 +
 net/batman-adv/soft-interface.c                    |  11 +-
 net/core/filter.c                                  |   4 +-
 net/mac80211/mlme.c                                |   3 +-
 net/mac80211/util.c                                |   7 +-
 net/mac802154/tx.c                                 |   8 +-
 net/netfilter/nf_conntrack_netlink.c               |  22 +---
 net/netfilter/nf_conntrack_proto.c                 |   2 +
 net/netfilter/nft_meta.c                           |   4 +-
 net/sunrpc/svcsock.c                               |   2 +-
 net/wireless/Kconfig                               |   1 +
 net/wireless/util.c                                |   2 +-
 net/xdp/xdp_umem.c                                 |  17 ++-
 security/device_cgroup.c                           |   3 +-
 sound/pci/asihpi/hpioctl.c                         |   4 +-
 sound/pci/hda/patch_realtek.c                      |  13 +-
 sound/soc/codecs/pcm3168a.c                        |   7 +
 sound/soc/codecs/wm8994.c                          |  10 ++
 sound/soc/codecs/wm_hubs.c                         |   3 +
 sound/soc/codecs/wm_hubs.h                         |   1 +
 sound/soc/intel/boards/bytcr_rt5640.c              |  10 ++
 sound/usb/quirks.c                                 |   7 +-
 tools/lib/bpf/Makefile                             |   2 +
 tools/lib/bpf/libbpf.c                             |   2 +-
 tools/objtool/check.c                              |   2 +-
 120 files changed, 866 insertions(+), 410 deletions(-)


