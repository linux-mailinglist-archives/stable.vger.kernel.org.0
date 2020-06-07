Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899E31F0B28
	for <lists+stable@lfdr.de>; Sun,  7 Jun 2020 14:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbgFGM6l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jun 2020 08:58:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:34948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbgFGM6k (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Jun 2020 08:58:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D48020663;
        Sun,  7 Jun 2020 12:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591534718;
        bh=3keEu7Tocz75YUJW3LcJey7z85CKcFWlZ6Wl9n7zPTw=;
        h=From:To:Cc:Subject:Date:From;
        b=cEz+qXaR0cvGUvkeiFW+R8n6+3JUwJAjM1qQsF934drqqjSz7oI2ha2Xz+TulSNPs
         QsiMEuP41nwfK2uKOohFlEo4LoW6PvQAVYFJ0GIylInsj3A5KzRoDutsCmBHX059YK
         Op/mRO5ClVTojfllQU17nN9b46iJYh13ZjytVBmM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.6.17
Date:   Sun,  7 Jun 2020 14:58:32 +0200
Message-Id: <1591534711118161@kroah.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.6.17 kernel.

All users of the 5.6 kernel series must upgrade.

The updated 5.6.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.6.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                  |    2 -
 arch/arc/kernel/setup.c                                   |    5 +-
 arch/arc/plat-eznps/Kconfig                               |    1 
 arch/riscv/mm/init.c                                      |    2 -
 arch/s390/mm/hugetlbpage.c                                |    9 +++-
 arch/x86/hyperv/hv_init.c                                 |   19 ++++++++-
 arch/x86/include/asm/pgtable.h                            |    1 
 arch/x86/include/uapi/asm/unistd.h                        |   11 ++++-
 arch/x86/mm/mmio-mod.c                                    |    4 +-
 crypto/algapi.c                                           |   22 ++++++++---
 crypto/api.c                                              |    3 +
 crypto/internal.h                                         |    1 
 drivers/block/null_blk_zoned.c                            |    4 ++
 drivers/dma/ti/k3-udma.c                                  |    6 ++-
 drivers/firmware/efi/earlycon.c                           |   14 ++++---
 drivers/firmware/efi/libstub/arm-stub.c                   |    6 ++-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c          |   27 +++++++++++++
 drivers/gpu/drm/drm_edid.c                                |    3 +
 drivers/hid/hid-multitouch.c                              |   26 +++++++++++++
 drivers/hid/hid-sony.c                                    |   17 ++++++++
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c                  |    8 ++++
 drivers/i2c/busses/i2c-altera.c                           |   10 ++++-
 drivers/net/can/ifi_canfd/ifi_canfd.c                     |    5 ++
 drivers/net/can/sun4i_can.c                               |    2 -
 drivers/net/dsa/b53/b53_srab.c                            |    2 -
 drivers/net/dsa/mt7530.c                                  |   11 ++++-
 drivers/net/dsa/mt7530.h                                  |    6 +++
 drivers/net/ethernet/apple/bmac.c                         |    2 -
 drivers/net/ethernet/freescale/ucc_geth.c                 |   13 +++---
 drivers/net/ethernet/marvell/pxa168_eth.c                 |    2 -
 drivers/net/ethernet/smsc/smsc911x.c                      |    9 ++--
 drivers/net/ethernet/stmicro/stmmac/dwmac-ipq806x.c       |   13 ++++++
 drivers/net/ethernet/ti/cpsw_ale.c                        |    2 -
 drivers/net/ethernet/ti/cpsw_priv.c                       |    4 +-
 drivers/net/ethernet/ti/netcp_ethss.c                     |    4 +-
 drivers/net/phy/phy_device.c                              |    4 +-
 drivers/net/wireless/cisco/airo.c                         |   12 ++++++
 drivers/net/wireless/intersil/p54/p54usb.c                |    1 
 drivers/net/wireless/mediatek/mt76/mt76x02.h              |    1 
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c           |    1 
 drivers/scsi/scsi_pm.c                                    |   10 ++++-
 drivers/staging/media/ipu3/include/intel-ipu3.h           |    7 ++-
 fs/io_uring.c                                             |   28 +++++++++-----
 include/uapi/linux/mmc/ioctl.h                            |    1 
 kernel/cgroup/rstat.c                                     |   16 +-------
 kernel/relay.c                                            |    5 ++
 mm/mremap.c                                               |    2 -
 security/integrity/evm/evm_crypto.c                       |    2 -
 security/integrity/evm/evm_main.c                         |    4 +-
 security/integrity/evm/evm_secfs.c                        |    9 ++++
 tools/arch/x86/include/uapi/asm/unistd.h                  |    2 -
 tools/testing/selftests/drivers/net/mlxsw/qos_mc_aware.sh |    2 -
 tools/testing/selftests/wireguard/qemu/Makefile           |    2 -
 53 files changed, 293 insertions(+), 92 deletions(-)

Amit Cohen (1):
      selftests: mlxsw: qos_mc_aware: Specify arping timeout as an integer

Andy Lutomirski (1):
      x86/syscalls: Revert "x86/syscalls: Make __X32_SYSCALL_BIT be unsigned long"

Atsushi Nemoto (1):
      i2c: altera: Fix race between xfer_msg and isr thread

Benjamin Tissoires (1):
      HID: multitouch: enable multi-input as a quirk for some devices

Can Guo (1):
      scsi: pm: Balance pm_only counter of request queue during system resume

Chaitanya Kulkarni (1):
      null_blk: return error for invalid zone size

DENG Qingfang (1):
      net: dsa: mt7530: set CPU port to fallback mode

Dan Carpenter (1):
      airo: Fix read overflows sending packets

Daniel Axtens (1):
      kernel/relay.c: handle alloc_percpu returning NULL in relay_open

Dave Young (1):
      efi/earlycon: Fix early printk for wider fonts

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
      Linux 5.6.17

Heinrich Schuchardt (1):
      efi/libstub: Avoid returning uninitialized data from setup_graphics()

Herbert Xu (1):
      crypto: api - Fix use-after-free and race in crypto_spawn_alg

Jan Schmidt (1):
      drm/edid: Add Oculus Rift S to non-desktop list

Jason A. Donenfeld (1):
      wireguard: selftests: use newer iproute2 for gcc-10

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

Kefeng Wang (1):
      riscv: Fix print_vm_layout build error if NOMMU

Leon Romanovsky (1):
      net: phy: propagate an error back to the callers of phy_sfp_probe

Madhuparna Bhowmik (1):
      evm: Fix RCU list related warnings

Matthew Garrett (1):
      mt76: mt76x02u: Add support for newer versions of the XBox One wifi adapter

Nathan Chancellor (1):
      x86/mmiotrace: Use cpumask_available() for cpumask_var_t variables

Pavel Begunkov (2):
      io_uring: don't prepare DRAIN reqs twice
      io_uring: fix FORCE_ASYNC req preparation

Peter Ujfalusi (1):
      dmaengine: ti: k3-udma: Fix TR mode flags for slave_sg and memcpy

Sakari Ailus (2):
      media: Revert "staging: imgu: Address a compiler warning on alignment"
      media: staging: ipu3-imgu: Move alignment attribute to field

Scott Shumate (1):
      HID: sony: Fix for broken buttons on DS3 USB dongles

Tejun Heo (1):
      Revert "cgroup: Add memory barriers to plug cgroup_rstat_updated() race window"

Tiezhu Yang (1):
      net: Fix return value about devm_platform_ioremap_resource()

Valentin Longchamp (1):
      net/ethernet/freescale: rework quiesce/activate for ucc_geth

Vineet Gupta (1):
      ARC: [plat-eznps]: Restrict to CONFIG_ISA_ARCOMPACT

Vitaly Kuznetsov (1):
      x86/hyperv: Properly suspend/resume reenlightenment notifications

Vladimir Stempen (1):
      drm/amd/display: DP training to set properly SCRAMBLING_DISABLE

Wei Yongjun (1):
      net: ethernet: ti: fix some return value check of cpsw_ale_create()

Xiaoguang Wang (1):
      io_uring: reset -EBUSY error when io sq thread is waken up

