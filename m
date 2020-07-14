Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D82EA21FA07
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbgGNSsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:48:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729984AbgGNSsk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:48:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B781D22B3F;
        Tue, 14 Jul 2020 18:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752519;
        bh=2fnvO+tAlHx+SM7bc6unYX9qk2VvPAqe8Dm81Q9b0xw=;
        h=From:To:Cc:Subject:Date:From;
        b=FITPAapsg29ulphODZG+TpaZbVR6PO+YYTAt5uIXCpSEC4ysgjp7bueiM3JdvmIUW
         gfbhzppzREdFST2PTYuKRVNiYHeeGIoMrNvLHNkQEEGprZsx8jLb9XBWuVoKKjNhUO
         Excijj9gq8KVB3C7R7/qETDWV5wSqzKj2PzhTTwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 000/109] 5.4.52-rc1 review
Date:   Tue, 14 Jul 2020 20:42:54 +0200
Message-Id: <20200714184105.507384017@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.52-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.52-rc1
X-KernelTest-Deadline: 2020-07-16T18:41+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.52 release.
There are 109 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 16 Jul 2020 18:40:38 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.52-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.52-rc1

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: jz4740: Fix build failure

Adrian Hunter <adrian.hunter@intel.com>
    perf scripts python: exported-sql-viewer.py: Fix unexpanded 'Find' result

Adrian Hunter <adrian.hunter@intel.com>
    perf scripts python: exported-sql-viewer.py: Fix zero id in call tree 'Find' result

Adrian Hunter <adrian.hunter@intel.com>
    perf scripts python: exported-sql-viewer.py: Fix zero id in call graph 'Find' result

Adrian Hunter <adrian.hunter@intel.com>
    perf scripts python: export-to-postgresql.py: Fix struct.pack() int argument

Michal Suchanek <msuchanek@suse.de>
    dm writecache: reject asynchronous pmem devices

Ming Lei <ming.lei@redhat.com>
    blk-mq: consider non-idle request as "inflight" in blk_mq_rq_inflight()

Janosch Frank <frankja@linux.ibm.com>
    s390/mm: fix huge pte soft dirty copying

Vasily Gorbik <gor@linux.ibm.com>
    s390/setup: init jump labels before command line parsing

Vineet Gupta <vgupta@synopsys.com>
    ARC: elf: use right ELF_ARCH

Vineet Gupta <vgupta@synopsys.com>
    ARC: entry: fix potential EFA clobber when TIF_SYSCALL_TRACE

Neil Armstrong <narmstrong@baylibre.com>
    mmc: meson-gx: limit segments to 1 when dram-access-quirk is needed

Mikulas Patocka <mpatocka@redhat.com>
    dm: use noio when sending kobject event

Marek Olšák <marek.olsak@amd.com>
    drm/amdgpu: don't do soft recovery if gpu_recovery=0

Tom Rix <trix@redhat.com>
    drm/radeon: fix double free

Josef Bacik <josef@toxicpanda.com>
    btrfs: fix double put of block group with nocow

Boris Burkov <boris@bur.io>
    btrfs: fix fatal extent_buffer readahead vs releasepage race

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb"

Kees Cook <keescook@chromium.org>
    bpf: Check correct cred for CAP_SYSLOG in bpf_dump_raw_ok()

Kees Cook <keescook@chromium.org>
    kprobes: Do not expose probe addresses to non-CAP_SYSLOG

Kees Cook <keescook@chromium.org>
    module: Do not expose section addresses to non-CAP_SYSLOG

Kees Cook <keescook@chromium.org>
    module: Refactor section attr into bin attribute

Kees Cook <keescook@chromium.org>
    kallsyms: Refactor kallsyms_show_value() to take cred

Steven Price <steven.price@arm.com>
    KVM: arm64: Fix kvm_reset_vcpu() return code being incorrect with SVE

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Mark CR4.TSD as being possibly owned by the guest

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Inject #GP if guest attempts to toggle CR4.LA57 in 64-bit mode

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: bit 8 of non-leaf PDPEs is not reserved

Alexandru Elisei <alexandru.elisei@arm.com>
    KVM: arm64: Annotate hyp NMI-related functions as __always_inline

Andrew Scull <ascull@google.com>
    KVM: arm64: Stop clobbering x0 for HVC_SOFT_RESTART

Will Deacon <will@kernel.org>
    KVM: arm64: Fix definition of PAGE_HYP_DEVICE

Jian-Hong Pan <jian-hong@endlessm.com>
    ALSA: hda/realtek: Enable headset mic of Acer Veriton N4660G with ALC269VC

Jian-Hong Pan <jian-hong@endlessm.com>
    ALSA: hda/realtek: Enable headset mic of Acer C20-820 with ALC269VC

Jian-Hong Pan <jian-hong@endlessm.com>
    ALSA: hda/realtek - Enable audio jacks of Acer vCopperbox with ALC269VC

Benjamin Poirier <benjamin.poirier@gmail.com>
    ALSA: hda/realtek - Fix Lenovo Thinkpad X1 Carbon 7th quirk subdevice id

Pavel Hofman <pavel.hofman@ivitera.com>
    ALSA: usb-audio: Add implicit feedback quirk for RTX6001

Hector Martin <marcan@marcan.st>
    ALSA: usb-audio: add quirk for MacroSilicon MS2109

Hui Wang <hui.wang@canonical.com>
    ALSA: hda - let hs_mic be picked ahead of hp_mic

xidongwang <wangxidong_97@163.com>
    ALSA: opl3: fix infoleak in opl3

Kaike Wan <kaike.wan@intel.com>
    IB/hfi1: Do not destroy link_wq when the device is shut down

Kaike Wan <kaike.wan@intel.com>
    IB/hfi1: Do not destroy hfi1_wq when the device is shut down

Ido Schimmel <idosch@mellanox.com>
    mlxsw: pci: Fix use-after-free in case of failed devlink reload

Ido Schimmel <idosch@mellanox.com>
    mlxsw: spectrum_router: Remove inappropriate usage of WARN_ON()

Nicolas Ferre <nicolas.ferre@microchip.com>
    net: macb: fix call to pm_runtime in the suspend/resume functions

Nicolas Ferre <nicolas.ferre@microchip.com>
    net: macb: mark device wake capable when "magic-packet" property present

Nicolas Ferre <nicolas.ferre@microchip.com>
    net: macb: fix wakeup test in runtime suspend/resume routines

Davide Caratti <dcaratti@redhat.com>
    bnxt_en: fix NULL dereference in case SR-IOV configuration fails

Aya Levin <ayal@mellanox.com>
    net/mlx5e: Fix 50G per lane indication

Eran Ben Elisha <eranbe@mellanox.com>
    net/mlx5: Fix eeprom support for SFP module

Sudarsana Reddy Kalluru <skalluru@marvell.com>
    qed: Populate nvm-file attributes while reading nvm config partition.

Aya Levin <ayal@mellanox.com>
    IB/mlx5: Fix 50G per lane indication

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: fix all-mask IP address comparison

Zheng Bin <zhengbin13@huawei.com>
    nbd: Fix memory leak in nbd_add_socket

Wei Li <liwei391@huawei.com>
    arm64: kgdb: Fix single-step exception handling oops

Kamal Heib <kamalheib1@gmail.com>
    RDMA/siw: Fix reporting vendor_part_id

Vinod Koul <vkoul@kernel.org>
    ALSA: compress: fix partial_drain completion state

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: fix use-after-free when doing self test

Huazhong Tan <tanhuazhong@huawei.com>
    net: hns3: add a missing uninit debugfs when unload driver

Andre Edich <andre.edich@microchip.com>
    smsc95xx: avoid memory leak in smsc95xx_bind

Andre Edich <andre.edich@microchip.com>
    smsc95xx: check return value of smsc95xx_reset

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix PEBS sample for XMM registers

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix recording PEBS-via-PT with registers

Wei Li <liwei391@huawei.com>
    perf report TUI: Fix segmentation fault in perf_evsel__hists_browse()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: conntrack: refetch conntrack after nf_conntrack_update()

Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
    net: dsa: microchip: set the correct number of ports

Divya Indi <divya.indi@oracle.com>
    IB/sa: Resolv use-after-free in ib_nl_make_request()

Li Heng <liheng40@huawei.com>
    net: cxgb4: fix return error value in t4_prep_fw

Russell King <rmk+kernel@armlinux.org.uk>
    net: mvneta: fix use of state->speed

Eric Dumazet <edumazet@google.com>
    netfilter: ipset: call ip_set_free() instead of kfree()

John Fastabend <john.fastabend@gmail.com>
    bpf, sockmap: RCU dereferenced psock may be used outside RCU block

John Fastabend <john.fastabend@gmail.com>
    bpf, sockmap: RCU splat with redirect and strparser error or TLS

Hsin-Yi Wang <hsinyi@chromium.org>
    drm/mediatek: Check plane visibility in atomic_update

Luca Coelho <luciano.coelho@intel.com>
    nl80211: don't return err unconditionally in nl80211_start_ap()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: pca953x: Fix GPIO resource leak on Intel Galileo Gen 2

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpio: pca953x: Override IRQ for one of the expanders on Galileo Gen 2

Dan Carpenter <dan.carpenter@oracle.com>
    net: qrtr: Fix an out of bounds read qrtr_endpoint_post()

Scott Wood <swood@redhat.com>
    sched/core: Check cpus_mask, not cpus_ptr in __set_cpus_allowed_ptr(), to fix mask corruption

Peter Zijlstra <peterz@infradead.org>
    x86/entry: Increase entry_stack size to a full page

Max Gurtovoy <maxg@mellanox.com>
    nvme-rdma: assign completion vector correctly

Chengguang Xu <cgxu519@mykernel.net>
    block: release bip in a right way in error path

Aditya Pakki <pakki001@umn.edu>
    usb: dwc3: pci: Fix reference count leak in dwc3_pci_resume_work

Tomas Henzl <thenzl@redhat.com>
    scsi: mptscsih: Fix read sense data size

yu kuai <yukuai3@huawei.com>
    ARM: imx6: add missing put_device() call in imx6q_suspend_init()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: update ctime and mtime during truncate

Maxime Ripard <maxime@cerno.tech>
    drm/sun4i: mixer: Call of_dma_configure if there's an IOMMU

Vasily Gorbik <gor@linux.ibm.com>
    s390/kasan: fix early pgm check handler execution

Hans de Goede <hdegoede@redhat.com>
    drm: panel-orientation-quirks: Use generic orientation-data for Acer S1003

Hans de Goede <hdegoede@redhat.com>
    drm: panel-orientation-quirks: Add quirk for Asus T101HA panel

Rajat Jain <rajatja@google.com>
    iommu/vt-d: Don't apply gfx quirks to untrusted devices

Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
    powerpc/kvm/book3s64: Fix kernel crash with nested kvm & DEBUG_VIRTUAL

Dany Madden <drt@linux.ibm.com>
    ibmvnic: continue to init in CRQ reset returns H_CLOSED

Ciara Loftus <ciara.loftus@intel.com>
    i40e: protect ring accesses with READ- and WRITE_ONCE

Ciara Loftus <ciara.loftus@intel.com>
    ixgbe: protect ring accesses with READ- and WRITE_ONCE

Sascha Hauer <s.hauer@pengutronix.de>
    net: ethernet: mvneta: Add 2500BaseX support for SoCs without comphy

Sascha Hauer <s.hauer@pengutronix.de>
    net: ethernet: mvneta: Fix Serdes configuration for SoCs without comphy

Zhenzhong Duan <zhenzhong.duan@gmail.com>
    spi: spidev: fix a potential use-after-free in spidev_release()

Zhenzhong Duan <zhenzhong.duan@gmail.com>
    spi: spidev: fix a race between spidev_release and spidev_remove

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ALSA: hda: Intel: add missing PCI IDs for ICL-H, TGL-H and EKL

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: SOF: Intel: add PCI ID for CometLake-S

Linus Walleij <linus.walleij@linaro.org>
    drm: mcde: Fix display initialization problem

Thierry Reding <treding@nvidia.com>
    gpu: host1x: Detach driver on unregister

Nicolin Chen <nicoleotsuka@gmail.com>
    drm/tegra: hub: Do not enable orphaned window group

Xiyu Yang <xiyuyang19@fudan.edu.cn>
    drm/ttm: Fix dma_fence refcnt leak when adding move fence

Tony Lindgren <tony@atomide.com>
    ARM: dts: omap4-droid4: Fix spi configuration and increase rate

Stephane Eranian <eranian@google.com>
    perf/x86/rapl: Fix RAPL config variable bug

Stephane Eranian <eranian@google.com>
    perf/x86/rapl: Move RAPL support to common x86 code

Jens Thoms Toerring <jt@toerring.de>
    regmap: fix alignment issue

Krzysztof Kozlowski <krzk@kernel.org>
    spi: spi-fsl-dspi: Fix lockup if device is removed during SPI transfer

Peng Ma <peng.ma@nxp.com>
    spi: spi-fsl-dspi: Adding shutdown hook

Christian Borntraeger <borntraeger@de.ibm.com>
    KVM: s390: reduce number of IO pins to 1


-------------

Diffstat:

 Makefile                                           |   4 +-
 arch/arc/include/asm/elf.h                         |   2 +-
 arch/arc/kernel/entry.S                            |  16 ++--
 arch/arm/boot/dts/motorola-cpcap-mapphone.dtsi     |   4 +-
 arch/arm/mach-imx/pm-imx6.c                        |  10 ++-
 arch/arm64/include/asm/arch_gicv3.h                |   2 +-
 arch/arm64/include/asm/cpufeature.h                |   2 +-
 arch/arm64/include/asm/pgtable-prot.h              |   2 +-
 arch/arm64/kernel/kgdb.c                           |   2 +-
 arch/arm64/kvm/hyp-init.S                          |  11 ++-
 arch/arm64/kvm/reset.c                             |  10 ++-
 arch/powerpc/kvm/book3s_64_mmu_radix.c             |   3 +-
 arch/s390/include/asm/kvm_host.h                   |   8 +-
 arch/s390/kernel/early.c                           |   2 +
 arch/s390/kernel/setup.c                           |   1 +
 arch/s390/mm/hugetlbpage.c                         |   2 +-
 arch/x86/events/Kconfig                            |   6 +-
 arch/x86/events/Makefile                           |   1 +
 arch/x86/events/intel/Makefile                     |   2 -
 arch/x86/events/{intel => }/rapl.c                 |   9 +-
 arch/x86/include/asm/processor.h                   |   2 +-
 arch/x86/kvm/kvm_cache_regs.h                      |   2 +-
 arch/x86/kvm/mmu.c                                 |   2 +-
 arch/x86/kvm/vmx/vmx.c                             |   2 +
 arch/x86/kvm/x86.c                                 |   2 +
 block/bio-integrity.c                              |  23 +++--
 block/blk-mq.c                                     |   4 +-
 drivers/base/regmap/regmap.c                       | 100 ++++++++++-----------
 drivers/block/nbd.c                                |  25 +++---
 drivers/gpio/gpio-pca953x.c                        |  84 +++++++++++++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c            |   3 +-
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |  14 +--
 drivers/gpu/drm/mcde/mcde_drv.c                    |   3 +-
 drivers/gpu/drm/mediatek/mtk_drm_plane.c           |  25 +++---
 drivers/gpu/drm/radeon/ci_dpm.c                    |   7 +-
 drivers/gpu/drm/sun4i/sun8i_mixer.c                |  13 +++
 drivers/gpu/drm/tegra/hub.c                        |   8 +-
 drivers/gpu/drm/ttm/ttm_bo.c                       |   4 +-
 drivers/gpu/host1x/bus.c                           |   9 ++
 drivers/infiniband/core/sa_query.c                 |  38 ++++----
 drivers/infiniband/hw/hfi1/init.c                  |  37 ++++++--
 drivers/infiniband/hw/hfi1/qp.c                    |   5 +-
 drivers/infiniband/hw/hfi1/tid_rdma.c              |   5 +-
 drivers/infiniband/hw/mlx5/main.c                  |   2 +-
 drivers/infiniband/sw/siw/siw_main.c               |   3 +-
 drivers/iommu/intel-iommu.c                        |  37 ++++++++
 drivers/md/dm-writecache.c                         |   6 ++
 drivers/md/dm.c                                    |  15 +++-
 drivers/message/fusion/mptscsih.c                  |   4 +-
 drivers/mmc/host/meson-gx-mmc.c                    |   6 +-
 drivers/net/dsa/microchip/ksz8795.c                |   3 +
 drivers/net/dsa/microchip/ksz9477.c                |   3 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c    |   2 +-
 drivers/net/ethernet/cadence/macb_main.c           |  12 +--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |  10 +--
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |   8 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   3 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   9 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   9 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  29 +++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c       |  12 +--
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  14 ++-
 drivers/net/ethernet/marvell/mvneta.c              |  88 ++++++++++--------
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c  |  21 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/en/port.h  |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/port.c     |  93 +++++++++++++++----
 drivers/net/ethernet/mellanox/mlxsw/pci.c          |  54 +++++++----
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |   2 +-
 drivers/net/ethernet/qlogic/qed/qed_debug.c        |   4 +
 drivers/net/ethernet/qlogic/qed/qed_dev.c          |  12 +--
 drivers/net/ethernet/qlogic/qed/qed_mcp.c          |   7 ++
 drivers/net/ethernet/qlogic/qed/qed_mcp.h          |   7 ++
 drivers/net/usb/smsc95xx.c                         |   9 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |  48 +++-------
 drivers/net/wireless/ath/ath9k/hif_usb.h           |   5 --
 drivers/nvme/host/rdma.c                           |   2 +-
 drivers/pwm/pwm-jz4740.c                           |   5 +-
 drivers/spi/spi-fsl-dspi.c                         |  34 ++++++-
 drivers/spi/spidev.c                               |  24 ++---
 drivers/usb/dwc3/dwc3-pci.c                        |   4 +-
 fs/btrfs/extent_io.c                               |  40 +++++----
 fs/btrfs/inode.c                                   |   9 +-
 fs/cifs/inode.c                                    |   9 ++
 include/linux/filter.h                             |   4 +-
 include/linux/kallsyms.h                           |   5 +-
 include/sound/compress_driver.h                    |  10 ++-
 kernel/bpf/syscall.c                               |  32 ++++---
 kernel/kallsyms.c                                  |  17 ++--
 kernel/kprobes.c                                   |   4 +-
 kernel/module.c                                    |  51 ++++++-----
 kernel/sched/core.c                                |   2 +-
 net/core/skmsg.c                                   |  23 +++--
 net/core/sysctl_net_core.c                         |   2 +-
 net/netfilter/ipset/ip_set_bitmap_ip.c             |   2 +-
 net/netfilter/ipset/ip_set_bitmap_ipmac.c          |   2 +-
 net/netfilter/ipset/ip_set_bitmap_port.c           |   2 +-
 net/netfilter/ipset/ip_set_hash_gen.h              |   4 +-
 net/netfilter/nf_conntrack_core.c                  |   2 +
 net/qrtr/qrtr.c                                    |   6 +-
 net/wireless/nl80211.c                             |   3 +-
 sound/core/compress_offload.c                      |   4 +
 sound/drivers/opl3/opl3_synth.c                    |   2 +
 sound/pci/hda/hda_auto_parser.c                    |   6 ++
 sound/pci/hda/hda_intel.c                          |   8 ++
 sound/pci/hda/patch_realtek.c                      |  38 +++++++-
 sound/soc/sof/sof-pci-dev.c                        |   2 +
 sound/usb/pcm.c                                    |   1 +
 sound/usb/quirks-table.h                           |  52 +++++++++++
 tools/perf/arch/x86/util/intel-pt.c                |   1 +
 tools/perf/scripts/python/export-to-postgresql.py  |   2 +-
 tools/perf/scripts/python/exported-sql-viewer.py   |   7 +-
 tools/perf/ui/browsers/hists.c                     |  17 ++--
 tools/perf/util/evsel.c                            |   4 +-
 tools/perf/util/intel-pt.c                         |   5 +-
 115 files changed, 1025 insertions(+), 485 deletions(-)


