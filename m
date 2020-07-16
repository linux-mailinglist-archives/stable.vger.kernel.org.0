Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 891CB221E93
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 10:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgGPIiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 04:38:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727104AbgGPIhz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jul 2020 04:37:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72B8A20771;
        Thu, 16 Jul 2020 08:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594888674;
        bh=fCDzIHtDZ6JmYE9diTlh/ADSJj4zGQUgt9B0loQKTqE=;
        h=From:To:Cc:Subject:Date:From;
        b=NPUBZChEzNAq6/PaPQR700h4RAmMWQ4Tq1MscIHyS+iCEKEc2W0eNryyr2mp6jKZ8
         W/ekIfKLDrjz5jS/3UMYvRG5vtlih7gP/hkp1lMeboijNNbCFdybXealGLCzsJlf03
         TD6OD7BJFpBIob/pwtDH0KhrFda3GkiLT0xmEimk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.133
Date:   Thu, 16 Jul 2020 10:37:36 +0200
Message-Id: <15948886569828@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.133 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                              |    2 
 arch/arc/include/asm/elf.h                            |    2 
 arch/arc/kernel/entry.S                               |   16 --
 arch/arm/boot/dts/motorola-cpcap-mapphone.dtsi        |    4 
 arch/arm/mach-imx/pm-imx6.c                           |   10 +
 arch/arm64/include/asm/pgtable-prot.h                 |    2 
 arch/arm64/kernel/kgdb.c                              |    2 
 arch/arm64/kvm/hyp-init.S                             |   11 +
 arch/s390/include/asm/kvm_host.h                      |    8 -
 arch/s390/kernel/early.c                              |    2 
 arch/s390/mm/hugetlbpage.c                            |    2 
 arch/x86/include/asm/processor.h                      |    2 
 arch/x86/kvm/kvm_cache_regs.h                         |    2 
 arch/x86/kvm/mmu.c                                    |    2 
 arch/x86/kvm/vmx.c                                    |    2 
 arch/x86/kvm/x86.c                                    |    2 
 block/bio-integrity.c                                 |   23 ++--
 drivers/base/regmap/regmap.c                          |  100 ++++++++----------
 drivers/block/nbd.c                                   |   25 ++--
 drivers/gpu/drm/drm_panel_orientation_quirks.c        |   14 +-
 drivers/gpu/drm/mediatek/mtk_drm_plane.c              |   25 ++--
 drivers/gpu/drm/radeon/ci_dpm.c                       |    7 -
 drivers/gpu/drm/tegra/hub.c                           |    8 +
 drivers/gpu/host1x/bus.c                              |    9 +
 drivers/md/dm.c                                       |   15 ++
 drivers/message/fusion/mptscsih.c                     |    4 
 drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c       |    2 
 drivers/net/ethernet/cadence/macb_main.c              |    2 
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c     |   10 -
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c            |    8 -
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c    |    9 +
 drivers/net/ethernet/intel/i40e/i40e_main.c           |   29 +++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c          |   12 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c         |   14 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c |    2 
 drivers/net/usb/smsc95xx.c                            |    9 +
 drivers/net/wireless/ath/ath9k/hif_usb.c              |   48 +-------
 drivers/net/wireless/ath/ath9k/hif_usb.h              |    5 
 drivers/nvme/host/rdma.c                              |    2 
 drivers/spi/spi-fsl-dspi.c                            |   51 ++++++++-
 drivers/spi/spidev.c                                  |   24 ++--
 drivers/usb/dwc3/dwc3-pci.c                           |    4 
 fs/btrfs/extent_io.c                                  |   40 ++++---
 fs/cifs/inode.c                                       |    9 +
 include/linux/filter.h                                |    4 
 include/linux/kallsyms.h                              |    5 
 include/sound/compress_driver.h                       |   10 +
 kernel/bpf/syscall.c                                  |   32 +++--
 kernel/kallsyms.c                                     |   17 +--
 kernel/kprobes.c                                      |    4 
 kernel/module.c                                       |   54 +++++----
 net/core/sysctl_net_core.c                            |    2 
 net/qrtr/qrtr.c                                       |    6 -
 sound/core/compress_offload.c                         |    4 
 sound/drivers/opl3/opl3_synth.c                       |    2 
 sound/pci/hda/hda_auto_parser.c                       |    6 +
 sound/usb/quirks-table.h                              |   52 +++++++++
 57 files changed, 478 insertions(+), 301 deletions(-)

Aditya Pakki (1):
      usb: dwc3: pci: Fix reference count leak in dwc3_pci_resume_work

Andre Edich (2):
      smsc95xx: check return value of smsc95xx_reset
      smsc95xx: avoid memory leak in smsc95xx_bind

Andrew Scull (1):
      KVM: arm64: Stop clobbering x0 for HVC_SOFT_RESTART

Boris Burkov (1):
      btrfs: fix fatal extent_buffer readahead vs releasepage race

Chengguang Xu (1):
      block: release bip in a right way in error path

Christian Borntraeger (1):
      KVM: s390: reduce number of IO pins to 1

Chuanhua Han (1):
      spi: spi-fsl-dspi: use IRQF_SHARED mode to request IRQ

Ciara Loftus (2):
      ixgbe: protect ring accesses with READ- and WRITE_ONCE
      i40e: protect ring accesses with READ- and WRITE_ONCE

Dan Carpenter (1):
      net: qrtr: Fix an out of bounds read qrtr_endpoint_post()

Davide Caratti (1):
      bnxt_en: fix NULL dereference in case SR-IOV configuration fails

Greg Kroah-Hartman (2):
      Revert "ath9k: Fix general protection fault in ath9k_hif_usb_rx_cb"
      Linux 4.19.133

Gustavo A. R. Silva (1):
      kernel: module: Use struct_size() helper

Hans de Goede (2):
      drm: panel-orientation-quirks: Add quirk for Asus T101HA panel
      drm: panel-orientation-quirks: Use generic orientation-data for Acer S1003

Hector Martin (1):
      ALSA: usb-audio: add quirk for MacroSilicon MS2109

Hsin-Yi Wang (1):
      drm/mediatek: Check plane visibility in atomic_update

Hui Wang (1):
      ALSA: hda - let hs_mic be picked ahead of hp_mic

Ido Schimmel (1):
      mlxsw: spectrum_router: Remove inappropriate usage of WARN_ON()

Janosch Frank (1):
      s390/mm: fix huge pte soft dirty copying

Jens Thoms Toerring (1):
      regmap: fix alignment issue

Kees Cook (5):
      kallsyms: Refactor kallsyms_show_value() to take cred
      module: Refactor section attr into bin attribute
      module: Do not expose section addresses to non-CAP_SYSLOG
      kprobes: Do not expose probe addresses to non-CAP_SYSLOG
      bpf: Check correct cred for CAP_SYSLOG in bpf_dump_raw_ok()

Krzysztof Kozlowski (2):
      spi: spi-fsl-dspi: Fix lockup if device is removed during SPI transfer
      spi: spi-fsl-dspi: Fix external abort on interrupt in resume or exit paths

Li Heng (1):
      net: cxgb4: fix return error value in t4_prep_fw

Max Gurtovoy (1):
      nvme-rdma: assign completion vector correctly

Mikulas Patocka (1):
      dm: use noio when sending kobject event

Nicolas Ferre (1):
      net: macb: mark device wake capable when "magic-packet" property present

Nicolin Chen (1):
      drm/tegra: hub: Do not enable orphaned window group

Paolo Bonzini (1):
      KVM: x86: bit 8 of non-leaf PDPEs is not reserved

Peng Ma (1):
      spi: spi-fsl-dspi: Adding shutdown hook

Peter Zijlstra (1):
      x86/entry: Increase entry_stack size to a full page

Rahul Lakkireddy (1):
      cxgb4: fix all-mask IP address comparison

Sean Christopherson (2):
      KVM: x86: Inject #GP if guest attempts to toggle CR4.LA57 in 64-bit mode
      KVM: x86: Mark CR4.TSD as being possibly owned by the guest

Thierry Reding (1):
      gpu: host1x: Detach driver on unregister

Tom Rix (1):
      drm/radeon: fix double free

Tomas Henzl (1):
      scsi: mptscsih: Fix read sense data size

Tony Lindgren (1):
      ARM: dts: omap4-droid4: Fix spi configuration and increase rate

Vasily Gorbik (1):
      s390/kasan: fix early pgm check handler execution

Vineet Gupta (2):
      ARC: entry: fix potential EFA clobber when TIF_SYSCALL_TRACE
      ARC: elf: use right ELF_ARCH

Vinod Koul (1):
      ALSA: compress: fix partial_drain completion state

Wei Li (1):
      arm64: kgdb: Fix single-step exception handling oops

Will Deacon (1):
      KVM: arm64: Fix definition of PAGE_HYP_DEVICE

Yonglong Liu (1):
      net: hns3: fix use-after-free when doing self test

Zhang Xiaoxu (1):
      cifs: update ctime and mtime during truncate

Zheng Bin (1):
      nbd: Fix memory leak in nbd_add_socket

Zhenzhong Duan (2):
      spi: spidev: fix a race between spidev_release and spidev_remove
      spi: spidev: fix a potential use-after-free in spidev_release()

xidongwang (1):
      ALSA: opl3: fix infoleak in opl3

yu kuai (1):
      ARM: imx6: add missing put_device() call in imx6q_suspend_init()

