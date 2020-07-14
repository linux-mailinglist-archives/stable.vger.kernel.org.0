Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7071721FD09
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:13:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729676AbgGNTNH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 15:13:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:40270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbgGNSpw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:45:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4487B22282;
        Tue, 14 Jul 2020 18:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594752351;
        bh=QqTrJfsv74wPyJqCf8T/3iUoPM7IiyJ1jbSMC/1s+K0=;
        h=From:To:Cc:Subject:Date:From;
        b=GZczcKY1Awwp/96Dp0Ha491BszG4ZS+YezXwfQO5YEXd2hcFugTsSVk1X1+nwuN8H
         fENnOqSREQOuKWL5k19Tkg9Llfw5Cv2uJkq2+6XATVVrKioMqlHX+Q7Ljh7c6bkQqf
         B5kKoXD1fzp9sArSm9dOCBTzqbf8D7VIUqd/xSzs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/58] 4.19.133-rc1 review
Date:   Tue, 14 Jul 2020 20:43:33 +0200
Message-Id: <20200714184056.149119318@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.133-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.133-rc1
X-KernelTest-Deadline: 2020-07-16T18:40+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.133 release.
There are 58 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 16 Jul 2020 18:40:38 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.133-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.133-rc1

Janosch Frank <frankja@linux.ibm.com>
    s390/mm: fix huge pte soft dirty copying

Vineet Gupta <vgupta@synopsys.com>
    ARC: elf: use right ELF_ARCH

Vineet Gupta <vgupta@synopsys.com>
    ARC: entry: fix potential EFA clobber when TIF_SYSCALL_TRACE

Mikulas Patocka <mpatocka@redhat.com>
    dm: use noio when sending kobject event

Tom Rix <trix@redhat.com>
    drm/radeon: fix double free

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

Gustavo A. R. Silva <gustavo@embeddedor.com>
    kernel: module: Use struct_size() helper

Kees Cook <keescook@chromium.org>
    kallsyms: Refactor kallsyms_show_value() to take cred

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Mark CR4.TSD as being possibly owned by the guest

Sean Christopherson <sean.j.christopherson@intel.com>
    KVM: x86: Inject #GP if guest attempts to toggle CR4.LA57 in 64-bit mode

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: bit 8 of non-leaf PDPEs is not reserved

Andrew Scull <ascull@google.com>
    KVM: arm64: Stop clobbering x0 for HVC_SOFT_RESTART

Will Deacon <will@kernel.org>
    KVM: arm64: Fix definition of PAGE_HYP_DEVICE

Hector Martin <marcan@marcan.st>
    ALSA: usb-audio: add quirk for MacroSilicon MS2109

Hui Wang <hui.wang@canonical.com>
    ALSA: hda - let hs_mic be picked ahead of hp_mic

xidongwang <wangxidong_97@163.com>
    ALSA: opl3: fix infoleak in opl3

Ido Schimmel <idosch@mellanox.com>
    mlxsw: spectrum_router: Remove inappropriate usage of WARN_ON()

Nicolas Ferre <nicolas.ferre@microchip.com>
    net: macb: mark device wake capable when "magic-packet" property present

Davide Caratti <dcaratti@redhat.com>
    bnxt_en: fix NULL dereference in case SR-IOV configuration fails

Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
    cxgb4: fix all-mask IP address comparison

Zheng Bin <zhengbin13@huawei.com>
    nbd: Fix memory leak in nbd_add_socket

Wei Li <liwei391@huawei.com>
    arm64: kgdb: Fix single-step exception handling oops

Vinod Koul <vkoul@kernel.org>
    ALSA: compress: fix partial_drain completion state

Yonglong Liu <liuyonglong@huawei.com>
    net: hns3: fix use-after-free when doing self test

Andre Edich <andre.edich@microchip.com>
    smsc95xx: avoid memory leak in smsc95xx_bind

Andre Edich <andre.edich@microchip.com>
    smsc95xx: check return value of smsc95xx_reset

Li Heng <liheng40@huawei.com>
    net: cxgb4: fix return error value in t4_prep_fw

Hsin-Yi Wang <hsinyi@chromium.org>
    drm/mediatek: Check plane visibility in atomic_update

Dan Carpenter <dan.carpenter@oracle.com>
    net: qrtr: Fix an out of bounds read qrtr_endpoint_post()

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

Ciara Loftus <ciara.loftus@intel.com>
    i40e: protect ring accesses with READ- and WRITE_ONCE

Ciara Loftus <ciara.loftus@intel.com>
    ixgbe: protect ring accesses with READ- and WRITE_ONCE

Zhenzhong Duan <zhenzhong.duan@gmail.com>
    spi: spidev: fix a potential use-after-free in spidev_release()

Zhenzhong Duan <zhenzhong.duan@gmail.com>
    spi: spidev: fix a race between spidev_release and spidev_remove

Thierry Reding <treding@nvidia.com>
    gpu: host1x: Detach driver on unregister

Nicolin Chen <nicoleotsuka@gmail.com>
    drm/tegra: hub: Do not enable orphaned window group

Tony Lindgren <tony@atomide.com>
    ARM: dts: omap4-droid4: Fix spi configuration and increase rate

Jens Thoms Toerring <jt@toerring.de>
    regmap: fix alignment issue

Krzysztof Kozlowski <krzk@kernel.org>
    spi: spi-fsl-dspi: Fix external abort on interrupt in resume or exit paths

Chuanhua Han <chuanhua.han@nxp.com>
    spi: spi-fsl-dspi: use IRQF_SHARED mode to request IRQ

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
 arch/arm64/include/asm/pgtable-prot.h              |   2 +-
 arch/arm64/kernel/kgdb.c                           |   2 +-
 arch/arm64/kvm/hyp-init.S                          |  11 ++-
 arch/s390/include/asm/kvm_host.h                   |   8 +-
 arch/s390/kernel/early.c                           |   2 +
 arch/s390/mm/hugetlbpage.c                         |   2 +-
 arch/x86/include/asm/processor.h                   |   2 +-
 arch/x86/kvm/kvm_cache_regs.h                      |   2 +-
 arch/x86/kvm/mmu.c                                 |   2 +-
 arch/x86/kvm/vmx.c                                 |   2 +
 arch/x86/kvm/x86.c                                 |   2 +
 block/bio-integrity.c                              |  23 +++--
 drivers/base/regmap/regmap.c                       | 100 ++++++++++-----------
 drivers/block/nbd.c                                |  25 +++---
 drivers/gpu/drm/drm_panel_orientation_quirks.c     |  14 +--
 drivers/gpu/drm/mediatek/mtk_drm_plane.c           |  25 +++---
 drivers/gpu/drm/radeon/ci_dpm.c                    |   7 +-
 drivers/gpu/drm/sun4i/sun8i_mixer.c                |  13 +++
 drivers/gpu/drm/tegra/hub.c                        |   8 +-
 drivers/gpu/host1x/bus.c                           |   9 ++
 drivers/md/dm.c                                    |  15 +++-
 drivers/message/fusion/mptscsih.c                  |   4 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c    |   2 +-
 drivers/net/ethernet/cadence/macb_main.c           |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |  10 +--
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c         |   8 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |   9 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  29 +++---
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c       |  12 +--
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  14 ++-
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |   2 +-
 drivers/net/usb/smsc95xx.c                         |   9 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |  48 +++-------
 drivers/net/wireless/ath/ath9k/hif_usb.h           |   5 --
 drivers/nvme/host/rdma.c                           |   2 +-
 drivers/spi/spi-fsl-dspi.c                         |  51 +++++++++--
 drivers/spi/spidev.c                               |  24 ++---
 drivers/usb/dwc3/dwc3-pci.c                        |   4 +-
 fs/btrfs/extent_io.c                               |  40 +++++----
 fs/cifs/inode.c                                    |   9 ++
 include/linux/filter.h                             |   4 +-
 include/linux/kallsyms.h                           |   5 +-
 include/sound/compress_driver.h                    |  10 ++-
 kernel/bpf/syscall.c                               |  32 ++++---
 kernel/kallsyms.c                                  |  17 ++--
 kernel/kprobes.c                                   |   4 +-
 kernel/module.c                                    |  54 +++++------
 net/core/sysctl_net_core.c                         |   2 +-
 net/qrtr/qrtr.c                                    |   6 +-
 sound/core/compress_offload.c                      |   4 +
 sound/drivers/opl3/opl3_synth.c                    |   2 +
 sound/pci/hda/hda_auto_parser.c                    |   6 ++
 sound/usb/quirks-table.h                           |  52 +++++++++++
 58 files changed, 492 insertions(+), 302 deletions(-)


