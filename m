Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5851D1F0B2D
	for <lists+stable@lfdr.de>; Sun,  7 Jun 2020 14:59:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgFGM67 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jun 2020 08:58:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:35068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbgFGM65 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Jun 2020 08:58:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0D4020663;
        Sun,  7 Jun 2020 12:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591534736;
        bh=uqToi0vjwcnpmXlSU0rdZ5i9QFWQguQQB65b4jwIZwU=;
        h=From:To:Cc:Subject:Date:From;
        b=ibqEz3AOuVq6uGmvDlkt9qKLzQlCy4vP2zITNsVxZP8ArVI9B7qdTreCpvk+eNcOz
         L4oOhXuWnRBc1SfIY6YlESotJNfsKVGCk80GRs1+xSoych8u9aK6nAxklhXtXYbwFQ
         caipf4a7NM93m3t/TbYj8J1JFqVcFeUXLBH+675M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.45
Date:   Sun,  7 Jun 2020 14:58:50 +0200
Message-Id: <15915347264790@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.45 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                  |    2 
 arch/arc/kernel/setup.c                                   |    5 
 arch/arc/plat-eznps/Kconfig                               |    1 
 arch/powerpc/platforms/powernv/opal-imc.c                 |   39 +--
 arch/powerpc/xmon/xmon.c                                  |  103 +++++++--
 arch/s390/kernel/mcount.S                                 |    1 
 arch/s390/mm/hugetlbpage.c                                |    9 
 arch/x86/include/asm/pgtable.h                            |    1 
 arch/x86/mm/mmio-mod.c                                    |    4 
 drivers/block/null_blk_zoned.c                            |    4 
 drivers/gpu/drm/drm_edid.c                                |    3 
 drivers/gpu/drm/i915/display/intel_dp.c                   |    7 
 drivers/gpu/drm/i915/display/intel_dp_mst.c               |   22 +-
 drivers/hid/hid-multitouch.c                              |   26 ++
 drivers/hid/hid-sony.c                                    |   17 +
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c                  |    8 
 drivers/i2c/busses/i2c-altera.c                           |   10 
 drivers/infiniband/hw/qedr/main.c                         |    2 
 drivers/infiniband/hw/qedr/qedr.h                         |   23 +-
 drivers/infiniband/hw/qedr/qedr_iw_cm.c                   |  148 +++++++++-----
 drivers/infiniband/hw/qedr/verbs.c                        |   64 +++---
 drivers/net/dsa/mt7530.c                                  |   11 -
 drivers/net/dsa/mt7530.h                                  |    6 
 drivers/net/ethernet/apple/bmac.c                         |    2 
 drivers/net/ethernet/freescale/ucc_geth.c                 |   13 -
 drivers/net/ethernet/smsc/smsc911x.c                      |    9 
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c       |   13 +
 drivers/net/wireless/cisco/airo.c                         |   12 +
 drivers/net/wireless/intersil/p54/p54usb.c                |    1 
 drivers/net/wireless/mediatek/mt76/mt76x02.h              |    1 
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c           |    1 
 drivers/scsi/hisi_sas/hisi_sas_main.c                     |    3 
 drivers/scsi/scsi_pm.c                                    |   10 
 drivers/scsi/ufs/ufshcd.c                                 |    1 
 drivers/spi/spi-dw.c                                      |    3 
 drivers/staging/media/ipu3/include/intel-ipu3.h           |    7 
 fs/io_uring.c                                             |    2 
 include/linux/security.h                                  |    2 
 include/uapi/linux/mmc/ioctl.h                            |    1 
 kernel/cgroup/rstat.c                                     |   16 -
 kernel/relay.c                                            |    5 
 mm/mremap.c                                               |    2 
 security/integrity/evm/evm_crypto.c                       |    2 
 security/integrity/evm/evm_main.c                         |    4 
 security/integrity/evm/evm_secfs.c                        |    9 
 security/lockdown/lockdown.c                              |    2 
 sound/soc/intel/boards/kbl_rt5663_rt5514_max98927.c       |    2 
 sound/soc/intel/boards/skl_hda_dsp_generic.c              |    2 
 sound/soc/intel/boards/sof_rt5682.c                       |    2 
 tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh |    2 
 50 files changed, 460 insertions(+), 185 deletions(-)

Amit Cohen (1):
      selftests: mlxsw: qos_mc_aware: Specify arping timeout as an integer

Anju T Sudhakar (1):
      powerpc/powernv: Avoid re-registration of imc debugfs directory

Atsushi Nemoto (1):
      i2c: altera: Fix race between xfer_msg and isr thread

Benjamin Tissoires (1):
      HID: multitouch: enable multi-input as a quirk for some devices

Can Guo (2):
      scsi: ufs: Release clock if DMA map fails
      scsi: pm: Balance pm_only counter of request queue during system resume

Chaitanya Kulkarni (1):
      null_blk: return error for invalid zone size

Christopher M. Riedl (1):
      powerpc/xmon: Restrict when kernel is locked down

DENG Qingfang (1):
      net: dsa: mt7530: set CPU port to fallback mode

Dan Carpenter (1):
      airo: Fix read overflows sending packets

Daniel Axtens (1):
      kernel/relay.c: handle alloc_percpu returning NULL in relay_open

Dinghao Liu (1):
      net: smsc911x: Fix runtime PM imbalance on error

Eugeniy Paltsev (1):
      ARC: Fix ICCM & DCCM runtime size checks

Fan Yang (1):
      mm: Fix mremap not considering huge pmd devmap

Gerald Schaefer (1):
      s390/mm: fix set_huge_pte_at() for empty ptes

Giuseppe Marco Randazzo (1):
      p54usb: add AirVasT USB stick device-id

Greg Kroah-Hartman (1):
      Linux 5.4.45

Jan Schmidt (1):
      drm/edid: Add Oculus Rift S to non-desktop list

Jaroslav Kysela (1):
      ASoC: intel - fix the card names

Jens Axboe (1):
      io_uring: initialize ctx->sqo_wait earlier

Jeremy Kerr (1):
      net: bmac: Fix read of MAC address from ROM

Jonathan McDowell (1):
      net: ethernet: stmmac: Enable interface clocks on probe for IPQ806x

Julian Sax (1):
      HID: i2c-hid: add Schneider SCL142ALM to descriptor override

Jérôme Pouiller (1):
      mmc: fix compilation of user API

Lucas De Marchi (1):
      drm/i915: fix port checks for MST support on gen >= 11

Madhuparna Bhowmik (1):
      evm: Fix RCU list related warnings

Matthew Garrett (1):
      mt76: mt76x02u: Add support for newer versions of the XBox One wifi adapter

Michal Kalderon (2):
      RDMA/qedr: Fix qpids xarray api used
      RDMA/qedr: Fix synchronization methods and memory leaks in qedr

Nathan Chancellor (1):
      x86/mmiotrace: Use cpumask_available() for cpumask_var_t variables

Sakari Ailus (2):
      media: Revert "staging: imgu: Address a compiler warning on alignment"
      media: staging: ipu3-imgu: Move alignment attribute to field

Scott Shumate (1):
      HID: sony: Fix for broken buttons on DS3 USB dongles

Tejun Heo (1):
      Revert "cgroup: Add memory barriers to plug cgroup_rstat_updated() race window"

Valentin Longchamp (1):
      net/ethernet/freescale: rework quiesce/activate for ucc_geth

Vasily Gorbik (1):
      s390/ftrace: save traced function caller

Vineet Gupta (1):
      ARC: [plat-eznps]: Restrict to CONFIG_ISA_ARCOMPACT

Xiang Chen (1):
      scsi: hisi_sas: Check sas_port before using it

Xinwei Kong (1):
      spi: dw: use "smp_mb()" to avoid sending spi data error

