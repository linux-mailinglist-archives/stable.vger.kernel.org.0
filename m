Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38B6F366A36
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 13:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238438AbhDUL6F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 07:58:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238476AbhDUL6B (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Apr 2021 07:58:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9218D61448;
        Wed, 21 Apr 2021 11:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619006246;
        bh=MwbxcPaw/hERHJEeS6ForVJ/0c4+FoxCQAU128UbCeI=;
        h=From:To:Cc:Subject:Date:From;
        b=QWTWreeC6QK1l39kY+XuyVeDyF1SIdiujTk3nFmUHoXA/5yzcjk4+O06OvnUs21dg
         3s5D/DcLxnKpAvoH3XnbhA0iUSPcdLoS6H0rY1T1BvDPMNUj5iwFChnWnCYyghiWgJ
         Cl9e6eNIYRzzt9ZGVzvtvKFqGJHPXEfVYxZ3vfwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.114
Date:   Wed, 21 Apr 2021 13:57:22 +0200
Message-Id: <16190062428796@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.114 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/arc/kernel/signal.c                                |    4 
 arch/arm/boot/dts/omap4.dtsi                            |    5 
 arch/arm/boot/dts/omap44xx-clocks.dtsi                  |    8 
 arch/arm/boot/dts/omap5.dtsi                            |    5 
 arch/arm/mach-footbridge/cats-pci.c                     |    4 
 arch/arm/mach-footbridge/ebsa285-pci.c                  |    4 
 arch/arm/mach-footbridge/netwinder-pci.c                |    2 
 arch/arm/mach-footbridge/personal-pci.c                 |    5 
 arch/arm/mach-keystone/keystone.c                       |    4 
 arch/arm/mach-omap1/ams-delta-fiq-handler.S             |    1 
 arch/arm/probes/uprobes/core.c                          |    4 
 arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-lts.dts |    4 
 arch/arm64/boot/dts/allwinner/sun50i-a64-sopine.dtsi    |    2 
 arch/arm64/include/asm/alternative.h                    |    8 
 arch/arm64/include/asm/word-at-a-time.h                 |   10 -
 arch/riscv/Kconfig                                      |    2 
 drivers/dma/dw/Kconfig                                  |    2 
 drivers/gpio/gpiolib-sysfs.c                            |    8 
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c                   |    4 
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c                   |    4 
 drivers/hid/wacom_wac.c                                 |    6 
 drivers/input/keyboard/nspire-keypad.c                  |   56 +++---
 drivers/input/serio/i8042-x86ia64io.h                   |    1 
 drivers/input/touchscreen/s6sy761.c                     |    4 
 drivers/md/dm-verity-fec.c                              |   11 -
 drivers/md/dm-verity-fec.h                              |    1 
 drivers/net/dsa/mv88e6xxx/chip.c                        |   30 +--
 drivers/net/ethernet/amd/pcnet32.c                      |    5 
 drivers/net/ethernet/cadence/macb_main.c                |    2 
 drivers/net/ethernet/davicom/dm9000.c                   |    6 
 drivers/net/ethernet/ibm/ibmvnic.c                      |   14 -
 drivers/net/ethernet/intel/i40e/i40e_main.c             |    6 
 drivers/net/ethernet/realtek/r8169_main.c               |  141 +++++-----------
 drivers/net/phy/marvell.c                               |   29 ++-
 drivers/net/wireless/virt_wifi.c                        |    5 
 drivers/nvdimm/region_devs.c                            |    9 -
 drivers/scsi/libsas/sas_ata.c                           |    9 -
 drivers/scsi/qla2xxx/qla_dbg.c                          |    2 
 drivers/scsi/qla2xxx/qla_def.h                          |   40 ++++
 drivers/scsi/qla2xxx/qla_fw.h                           |    2 
 drivers/scsi/qla2xxx/qla_gbl.h                          |    3 
 drivers/scsi/qla2xxx/qla_gs.c                           |   44 ++--
 drivers/scsi/qla2xxx/qla_init.c                         |  133 ++++++++-------
 drivers/scsi/qla2xxx/qla_inline.h                       |   36 ++++
 drivers/scsi/qla2xxx/qla_iocb.c                         |   53 ++++--
 drivers/scsi/qla2xxx/qla_mbx.c                          |   11 -
 drivers/scsi/qla2xxx/qla_os.c                           |   19 +-
 drivers/scsi/qla2xxx/qla_target.c                       |   11 -
 drivers/scsi/scsi_transport_srp.c                       |    2 
 drivers/vfio/pci/vfio_pci.c                             |    4 
 fs/readdir.c                                            |    6 
 include/linux/marvell_phy.h                             |    5 
 include/linux/netfilter_arp/arp_tables.h                |    5 
 include/linux/netfilter_bridge/ebtables.h               |    5 
 kernel/locking/lockdep.c                                |    3 
 net/bridge/netfilter/ebtable_broute.c                   |    8 
 net/bridge/netfilter/ebtable_filter.c                   |    8 
 net/bridge/netfilter/ebtable_nat.c                      |    8 
 net/bridge/netfilter/ebtables.c                         |   30 +++
 net/core/dev.c                                          |    3 
 net/core/neighbour.c                                    |    2 
 net/ieee802154/nl802154.c                               |   41 ++++
 net/ipv4/netfilter/arp_tables.c                         |    9 -
 net/ipv4/netfilter/arptable_filter.c                    |   10 +
 net/ipv6/ip6_tunnel.c                                   |   10 +
 net/ipv6/sit.c                                          |    4 
 net/mac80211/cfg.c                                      |    4 
 net/netfilter/nf_conntrack_standalone.c                 |    1 
 net/netfilter/nft_limit.c                               |    4 
 net/sctp/socket.c                                       |   13 -
 sound/soc/codecs/max98373.c                             |    2 
 sound/soc/fsl/fsl_esai.c                                |    8 
 73 files changed, 617 insertions(+), 359 deletions(-)

A. Cody Schuffelen (1):
      virt_wifi: Return micros for BSS TSF values

Alexander Aring (11):
      net: ieee802154: stop dump llsec keys for monitors
      net: ieee802154: forbid monitor for add llsec key
      net: ieee802154: forbid monitor for del llsec key
      net: ieee802154: stop dump llsec devs for monitors
      net: ieee802154: forbid monitor for add llsec dev
      net: ieee802154: forbid monitor for del llsec dev
      net: ieee802154: stop dump llsec devkeys for monitors
      net: ieee802154: forbid monitor for add llsec devkey
      net: ieee802154: forbid monitor for del llsec devkey
      net: ieee802154: stop dump llsec seclevels for monitors
      net: ieee802154: forbid monitor for add llsec seclevel

Alexander Shiyan (1):
      ASoC: fsl_esai: Fix TDM slot setup for I2S mode

Andre Przywara (1):
      arm64: dts: allwinner: Fix SD card CD GPIO for SOPine systems

Andy Shevchenko (1):
      dmaengine: dw: Make it dependent to HAS_IOMEM

Arnd Bergmann (3):
      ARM: keystone: fix integer overflow warning
      ARM: omap1: fix building with clang IAS
      Input: i8042 - fix Pegatron C15B ID entry

Arun Easi (1):
      scsi: qla2xxx: Fix device connect issues in P2P configuration

Caleb Connolly (1):
      Input: s6sy761 - fix coordinate read bit shift

Christian A. Ehrhardt (1):
      vfio/pci: Add missing range check in vfio_pci_mmap

Christophe JAILLET (1):
      net: davicom: Fix regulator not turned off on failed probe

Claudiu Beznea (1):
      net: macb: fix the restore of cmp registers

Eric Dumazet (2):
      netfilter: nft_limit: avoid possible divide error in nft_limit_init
      gro: ensure frag0 meets IP header alignment

Fabian Vogt (1):
      Input: nspire-keypad - enable interrupts only when opened

Florian Westphal (2):
      netfilter: bridge: add pre_exit hooks for ebtable unregistration
      netfilter: arp_tables: add pre_exit hook for table unregister

Fredrik Strupe (1):
      ARM: 9071/1: uprobes: Don't hook on thumb instructions

Greg Kroah-Hartman (1):
      Linux 5.4.114

Guenter Roeck (1):
      pcnet32: Use pci_resource_len to validate PCI resource

Heiner Kallweit (6):
      r8169: remove fiddling with the PCIe max read request size
      r8169: simplify setting PCI_EXP_DEVCTL_NOSNOOP_EN
      r8169: fix performance regression related to PCIe max read request size
      r8169: improve rtl_jumbo_config
      r8169: tweak max read request size for newer chips also in jumbo mtu mode
      r8169: don't advertise pause in jumbo mode

Hristo Venev (2):
      net: sit: Unregister catch-all devices
      net: ip6_tunnel: Unregister catch-all devices

Jaegeuk Kim (1):
      dm verity fec: fix misaligned RS roots IO

Jason Xing (1):
      i40e: fix the panic when running bpf in xdpdrv mode

Jolly Shah (1):
      scsi: libsas: Reset num_scatter if libata marks qc as NODATA

Kefeng Wang (1):
      riscv: Fix spelling mistake "SPARSEMEM" to "SPARSMEM"

Lijun Pan (3):
      ibmvnic: avoid calling napi_disable() twice
      ibmvnic: remove duplicate napi_schedule call in do_reset function
      ibmvnic: remove duplicate napi_schedule call in open function

Linus Torvalds (1):
      readdir: make sure to verify directory entry for legacy interfaces too

Martin Wilck (1):
      scsi: scsi_transport_srp: Don't block target in SRP_PORT_LOST state

Matti Vaittinen (1):
      gpio: sysfs: Obey valid_mask

Michael Hernandez (1):
      scsi: qla2xxx: Dual FCP-NVMe target port support

Nathan Chancellor (1):
      arm64: alternatives: Move length validation in alternative_{insn, endif}

Or Cohen (1):
      net/sctp: fix race condition in sctp_destroy_sock

Pablo Neira Ayuso (1):
      netfilter: conntrack: do not print icmpv6 as unknown via /proc

Pali Rohár (1):
      net: phy: marvell: fix detection of PHY on Topaz switches

Peter Collingbourne (1):
      arm64: fix inline asm in load_unaligned_zeropad()

Ping Cheng (1):
      HID: wacom: set EV_KEY and EV_ABS only for non-HID_GENERIC type of devices

Quinn Tran (3):
      scsi: qla2xxx: Retry PLOGI on FC-NVMe PRLI failure
      scsi: qla2xxx: Fix stuck login session using prli_pend_timer
      scsi: qla2xxx: Fix fabric scan hang

Rob Clark (1):
      drm/msm: Fix a5xx/a6xx timestamps

Russell King (1):
      ARM: footbridge: fix PCI interrupt mapping

Ryan Lee (1):
      ASoC: max98373: Added 30ms turn on/off time delay

Sasha Levin (2):
      Revert "scsi: qla2xxx: Retry PLOGI on FC-NVMe PRLI failure"
      Revert "scsi: qla2xxx: Fix stuck login session using prli_pend_timer"

Seevalamuthu Mariappan (1):
      mac80211: clear sta->fast_rx when STA removed from 4-addr VLAN

Shyam Sundar (1):
      scsi: qla2xxx: Add a shadow variable to hold disc_state history of fcport

Tetsuo Handa (1):
      lockdep: Add a missing initialization hint to the "INFO: Trying to register non-static key" message

Tong Zhu (1):
      neighbour: Disregard DEAD dst in neigh_update

Tony Lindgren (2):
      ARM: dts: Drop duplicate sha2md5_fck to fix clk_disable race
      ARM: dts: Fix moving mmc devices with aliases for omap4 & 5

Vaibhav Jain (1):
      libnvdimm/region: Fix nvdimm_has_flush() to handle ND_REGION_ASYNC

Wang Qing (1):
      arc: kernel: Return -EFAULT if copy_to_user() fails

