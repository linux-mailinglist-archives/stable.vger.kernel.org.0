Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4CB47CEA1
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 10:03:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236523AbhLVJDG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 04:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243598AbhLVJDD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 04:03:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C120DC061747;
        Wed, 22 Dec 2021 01:03:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 49BC361938;
        Wed, 22 Dec 2021 09:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BF0C36AE8;
        Wed, 22 Dec 2021 09:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640163782;
        bh=kV+W3CZ/BLPM4iIZL8nxXkKr31z3K3haLkXHb7IjEWA=;
        h=From:To:Cc:Subject:Date:From;
        b=yQ+M1GRxInboZhRO+KgMt0uCLiq50HtTstza8sCK4/l7FKI52OwLs36P30x9j5pa0
         j/6n8LqSUpKWPPS4JJwgqd0svAdP+DLIXWQZ9LrymvSfEvQJ0g604aU5SMMrmh+QAE
         Jfg0lTqsXtM6ZgdLf6hdR5ujQ43f2H4vy09tW7Ac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.259
Date:   Wed, 22 Dec 2021 10:02:52 +0100
Message-Id: <1640163772160218@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.259 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    2 
 arch/Kconfig                                       |    3 
 arch/arm/Kconfig.debug                             |   44 ++++---
 arch/arm/boot/dts/imx6ull-pinfunc.h                |    2 
 arch/arm/boot/dts/socfpga_arria10_socdk_qspi.dts   |    2 
 arch/arm/boot/dts/socfpga_arria5_socdk.dts         |    2 
 arch/arm/boot/dts/socfpga_cyclone5_socdk.dts       |    2 
 arch/arm/boot/dts/socfpga_cyclone5_sockit.dts      |    2 
 arch/arm/boot/dts/socfpga_cyclone5_socrates.dts    |    2 
 arch/arm/boot/dts/socfpga_cyclone5_sodia.dts       |    2 
 arch/arm/boot/dts/socfpga_cyclone5_vining_fpga.dts |    4 
 arch/arm/mm/copypage-fa.c                          |   35 ++---
 arch/arm/mm/copypage-feroceon.c                    |   98 ++++++++--------
 arch/arm/mm/copypage-v4mc.c                        |   19 +--
 arch/arm/mm/copypage-v4wb.c                        |   41 +++---
 arch/arm/mm/copypage-v4wt.c                        |   37 +++---
 arch/arm/mm/copypage-xsc3.c                        |   71 +++++------
 arch/arm/mm/copypage-xscale.c                      |   71 +++++------
 arch/x86/Kconfig                                   |    6 -
 arch/x86/mm/ioremap.c                              |    4 
 arch/x86/platform/efi/quirks.c                     |    3 
 drivers/ata/libata-scsi.c                          |   15 ++
 drivers/block/xen-blkfront.c                       |   15 ++
 drivers/char/agp/parisc-agp.c                      |    6 -
 drivers/dma/st_fdma.c                              |    2 
 drivers/firmware/scpi_pm_domain.c                  |   10 +
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |    2 
 drivers/hwmon/dell-smm-hwmon.c                     |    7 -
 drivers/i2c/busses/i2c-rk3x.c                      |    4 
 drivers/input/touchscreen/of_touchscreen.c         |   18 +--
 drivers/md/persistent-data/dm-btree-remove.c       |    2 
 drivers/net/ethernet/broadcom/bcmsysport.c         |    5 
 drivers/net/ethernet/broadcom/bcmsysport.h         |    1 
 drivers/net/ethernet/intel/igbvf/netdev.c          |    1 
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c      |    3 
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |    6 -
 drivers/net/usb/lan78xx.c                          |    6 -
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      |    4 
 drivers/net/wireless/marvell/mwifiex/fw.h          |    8 -
 drivers/net/xen-netback/common.h                   |    1 
 drivers/net/xen-netback/rx.c                       |   77 ++++++++----
 drivers/net/xen-netfront.c                         |  125 +++++++++++++++------
 drivers/pci/msi.c                                  |   15 +-
 drivers/scsi/scsi_debug.c                          |    4 
 drivers/soc/tegra/fuse/fuse-tegra.c                |    2 
 drivers/soc/tegra/fuse/fuse.h                      |    2 
 drivers/tty/hvc/hvc_xen.c                          |   30 ++++-
 drivers/usb/gadget/composite.c                     |    6 -
 drivers/usb/gadget/legacy/dbgp.c                   |    6 -
 drivers/usb/gadget/legacy/inode.c                  |    6 -
 drivers/usb/serial/option.c                        |    8 +
 fs/fuse/dir.c                                      |    2 
 fs/nfsd/nfs4state.c                                |    9 +
 kernel/audit.c                                     |   21 +--
 kernel/time/timekeeping.c                          |    3 
 kernel/trace/tracing_map.c                         |    3 
 lib/Kconfig.debug                                  |    6 -
 net/bpf/test_run.c                                 |   17 ++
 net/ipv6/sit.c                                     |    1 
 net/mac80211/agg-tx.c                              |    2 
 net/netlink/af_netlink.c                           |    5 
 net/nfc/netlink.c                                  |    6 -
 net/packet/af_packet.c                             |    5 
 scripts/recordmcount.pl                            |    2 
 tools/testing/selftests/bpf/test_verifier.c        |   18 +++
 65 files changed, 575 insertions(+), 374 deletions(-)

Alyssa Ross (1):
      dmaengine: st_fdma: fix MODULE_ALIAS

Ard Biesheuvel (1):
      x86: Make ARCH_USE_MEMREMAP_PROT a generic Kconfig symbol

Armin Wolf (1):
      hwmon: (dell-smm) Fix warning on /proc/i8k creation error

Chen Jun (1):
      tracing: Fix a kmemleak false positive in tracing_map

Cyril Novikov (1):
      ixgbe: set X550 MDIO speed before talking to PHY

Daniel Borkmann (1):
      bpf: fix panic due to oob in bpf_prog_test_run_skb

Daniele Palmas (1):
      USB: serial: option: add Telit FN990 compositions

Dinh Nguyen (1):
      ARM: socfpga: dts: fix qspi node compatible

Eric Dumazet (1):
      sit: do not call ipip6_dev_free() from sit_init_net()

Erik Ekman (1):
      net/mlx4_en: Update reported link modes for 1/10G

Fabio Estevam (1):
      ARM: dts: imx6ull-pinfunc: Fix CSI_DATA07__ESAI_TX0 pad name

Felix Fietkau (1):
      mac80211: send ADDBA requests using the tid/queue of the aggregation session

Florian Fainelli (1):
      net: systemport: Add global locking for descriptor lifecycle

George Kennedy (2):
      libata: if T_LENGTH is zero, dma direction should be DMA_NONE
      scsi: scsi_debug: Sanity check block descriptor length in resp_mode_select()

Greg Kroah-Hartman (2):
      USB: gadget: bRequestType is a bitfield, not a enum
      Linux 4.14.259

Harshit Mogalapalli (1):
      net: netlink: af_netlink: Prevent empty skb by adding a check on len.

Helge Deller (1):
      parisc/agp: Annotate parisc agp init functions with __init

J. Bruce Fields (1):
      nfsd: fix use-after-free due to delegation race

Jerome Marchand (1):
      recordmcount.pl: look for jgnop instruction as well as bcrl on s390

Joe Thornber (1):
      dm btree remove: fix use after free in rebalance_children()

Juergen Gross (5):
      xen/blkfront: harden blkfront against event channel storms
      xen/netfront: harden netfront against event channel storms
      xen/console: harden hvc_xen against event channel storms
      xen/netback: fix rx queue stall detection
      xen/netback: don't queue unlimited number of packages

Letu Ren (1):
      igbvf: fix double free in `igbvf_probe`

Miklos Szeredi (1):
      fuse: annotate lock in fuse_reverse_inval_entry()

Nathan Chancellor (4):
      soc/tegra: fuse: Fix bitwise vs. logical OR warning
      net: lan78xx: Avoid unnecessary self assignment
      mwifiex: Remove unnecessary braces from HostCmd_SET_SEQ_NO_BSS_INFO
      Input: touchscreen - avoid bitwise vs logical OR warning

Nicolas Pitre (1):
      ARM: 8805/2: remove unneeded naked function usage

Ondrej Jirman (1):
      i2c: rk3x: Handle a spurious start completion interrupt flag

Paul Moore (1):
      audit: improve robustness of the audit queue handling

Philip Chen (1):
      drm/msm/dsi: set default num_data_lanes

Stefan Agner (1):
      ARM: 8800/1: use choice for kernel unwinders

Stefan Roese (1):
      PCI/MSI: Mask MSI-X vectors only on success

Sudeep Holla (1):
      firmware: arm_scpi: Fix string overflow in SCPI genpd driver

Tadeusz Struk (1):
      nfc: fix segfault in nfc_genl_dump_devices_done

Thomas Gleixner (1):
      PCI/MSI: Clear PCI_MSIX_FLAGS_MASKALL on error

Tom Lendacky (1):
      x86/sme: Explicitly map new EFI memmap table as encrypted

Willem de Bruijn (1):
      net/packet: rx_owner_map depends on pg_vec

Yu Liao (1):
      timekeeping: Really make sure wall_to_monotonic isn't positive

