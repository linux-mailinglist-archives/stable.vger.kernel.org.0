Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4611F0B30
	for <lists+stable@lfdr.de>; Sun,  7 Jun 2020 14:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726606AbgFGM7N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jun 2020 08:59:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726447AbgFGM7E (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Jun 2020 08:59:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72A4020663;
        Sun,  7 Jun 2020 12:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591534742;
        bh=WDsW2qnpuZpg/U9uPZFFUJY1LIlYlPmFy0tX5B5DDbc=;
        h=From:To:Cc:Subject:Date:From;
        b=afksgbTtdxnhmtzzoQTRbxrwFUKOhUS5sOHXyf4zOo5Bb7HEnVbdXcbfNcAaHdMbe
         5Cy+7antPApB4dPjq8sI+n416zP/PWyKnMulTrZbi+RDyw8KYk9IGs9NAl85zLMNLM
         WEVEctzefaYw3uTsxQZTX9hNhl8ID99w9hbKxjwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.127
Date:   Sun,  7 Jun 2020 14:58:56 +0200
Message-Id: <159153473624839@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.127 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                            |    2 -
 arch/arc/kernel/setup.c                             |    5 +-
 arch/arc/plat-eznps/Kconfig                         |    1 
 arch/powerpc/platforms/powernv/opal-imc.c           |   39 ++++++++------------
 arch/s390/kernel/mcount.S                           |    1 
 arch/s390/mm/hugetlbpage.c                          |    9 +++-
 arch/x86/include/asm/pgtable.h                      |    1 
 arch/x86/mm/mmio-mod.c                              |    4 +-
 drivers/block/null_blk_zoned.c                      |    4 ++
 drivers/gpu/drm/drm_edid.c                          |    3 +
 drivers/gpu/drm/i915/intel_dp.c                     |    7 +--
 drivers/gpu/drm/i915/intel_dp_mst.c                 |   22 ++++++++---
 drivers/hid/hid-sony.c                              |   17 ++++++++
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c            |    8 ++++
 drivers/i2c/busses/i2c-altera.c                     |   10 ++++-
 drivers/net/dsa/mt7530.c                            |   11 ++++-
 drivers/net/dsa/mt7530.h                            |    6 +++
 drivers/net/ethernet/apple/bmac.c                   |    2 -
 drivers/net/ethernet/freescale/ucc_geth.c           |   13 +++---
 drivers/net/ethernet/smsc/smsc911x.c                |    9 ++--
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c |   13 ++++++
 drivers/net/wireless/cisco/airo.c                   |   12 ++++++
 drivers/net/wireless/intersil/p54/p54usb.c          |    1 
 drivers/nvdimm/btt.c                                |    8 ++--
 drivers/nvdimm/namespace_devs.c                     |    7 ++-
 drivers/scsi/hisi_sas/hisi_sas_main.c               |    3 +
 drivers/scsi/ufs/ufshcd.c                           |    1 
 drivers/spi/spi-dw.c                                |    3 +
 include/uapi/linux/mmc/ioctl.h                      |    1 
 kernel/cgroup/rstat.c                               |   16 +-------
 kernel/relay.c                                      |    5 ++
 mm/mremap.c                                         |    2 -
 security/integrity/evm/evm_crypto.c                 |    2 -
 security/integrity/evm/evm_main.c                   |    4 +-
 security/integrity/evm/evm_secfs.c                  |    9 ++++
 35 files changed, 177 insertions(+), 84 deletions(-)

Aneesh Kumar K.V (1):
      libnvdimm: Fix endian conversion issues 

Anju T Sudhakar (1):
      powerpc/powernv: Avoid re-registration of imc debugfs directory

Atsushi Nemoto (1):
      i2c: altera: Fix race between xfer_msg and isr thread

Can Guo (1):
      scsi: ufs: Release clock if DMA map fails

Chaitanya Kulkarni (1):
      null_blk: return error for invalid zone size

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
      Linux 4.19.127

Jan Schmidt (1):
      drm/edid: Add Oculus Rift S to non-desktop list

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

Nathan Chancellor (1):
      x86/mmiotrace: Use cpumask_available() for cpumask_var_t variables

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

