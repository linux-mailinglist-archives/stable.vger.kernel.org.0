Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD8736D6CA
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 13:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbhD1Lum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 07:50:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229900AbhD1LuZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Apr 2021 07:50:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD23961417;
        Wed, 28 Apr 2021 11:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619610579;
        bh=bqeEXfwgqxMCZQpf6ElCPrKbezziUcn9UwpakOW/AcE=;
        h=From:To:Cc:Subject:Date:From;
        b=WEtF9ZURij9F/CC27G49sVMCmHwKBIqkZuHt162JCLDYSwLgpemSaLNgNHgmMaa9O
         zVONOUZ23qvMJflP9433wFJRQFHE7/983lEjvSBm7VZ2XXt065uNFjr5eTaYc6Bboi
         Merdr2jHuSY3zJ27SyFpg3kGQIUnoDnG+B+ccJ7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.189
Date:   Wed, 28 Apr 2021 13:49:35 +0200
Message-Id: <161961057518956@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.189 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    2 
 arch/arc/kernel/signal.c                           |    4 -
 arch/arm/boot/dts/omap3.dtsi                       |    3 +
 arch/arm/boot/dts/omap4.dtsi                       |    5 +
 arch/arm/boot/dts/omap44xx-clocks.dtsi             |    8 --
 arch/arm/boot/dts/omap5.dtsi                       |    5 +
 arch/arm/mach-footbridge/cats-pci.c                |    4 -
 arch/arm/mach-footbridge/ebsa285-pci.c             |    4 -
 arch/arm/mach-footbridge/netwinder-pci.c           |    2 
 arch/arm/mach-footbridge/personal-pci.c            |    5 -
 arch/arm/mach-keystone/keystone.c                  |    4 -
 arch/arm/probes/uprobes/core.c                     |    4 -
 arch/arm64/include/asm/alternative.h               |    8 +-
 arch/arm64/include/asm/word-at-a-time.h            |   10 +--
 arch/ia64/mm/discontig.c                           |    6 +-
 arch/s390/kernel/entry.S                           |    1 
 arch/x86/events/intel/uncore_snbep.c               |   61 ++++++++-------------
 arch/x86/kernel/crash.c                            |    2 
 drivers/dma/dw/Kconfig                             |    2 
 drivers/gpio/gpiolib-sysfs.c                       |    8 ++
 drivers/gpu/drm/msm/adreno/a5xx_gpu.c              |    4 -
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |    4 -
 drivers/hid/hid-alps.c                             |    1 
 drivers/hid/hid-google-hammer.c                    |    2 
 drivers/hid/hid-ids.h                              |    1 
 drivers/hid/wacom_wac.c                            |    8 +-
 drivers/input/keyboard/nspire-keypad.c             |   56 ++++++++++---------
 drivers/input/serio/i8042-x86ia64io.h              |    1 
 drivers/input/touchscreen/s6sy761.c                |    4 -
 drivers/md/dm-verity-fec.c                         |   11 ++-
 drivers/md/dm-verity-fec.h                         |    1 
 drivers/net/dsa/mv88e6xxx/chip.c                   |   30 ++++------
 drivers/net/ethernet/amd/pcnet32.c                 |    5 +
 drivers/net/ethernet/cavium/liquidio/cn66xx_regs.h |    2 
 drivers/net/ethernet/davicom/dm9000.c              |    6 +-
 drivers/net/ethernet/ibm/ibmvnic.c                 |   14 ----
 drivers/net/ethernet/intel/i40e/i40e_main.c        |    6 ++
 drivers/net/geneve.c                               |    6 ++
 drivers/net/phy/marvell.c                          |   28 ++++++++-
 drivers/net/usb/hso.c                              |    2 
 drivers/net/xen-netback/xenbus.c                   |   12 ++--
 drivers/pinctrl/intel/pinctrl-lewisburg.c          |    6 +-
 drivers/scsi/libsas/sas_ata.c                      |    9 +--
 drivers/scsi/scsi_transport_srp.c                  |    2 
 drivers/usb/class/cdc-acm.c                        |    3 -
 fs/readdir.c                                       |    6 ++
 include/linux/marvell_phy.h                        |    5 +
 kernel/locking/lockdep.c                           |    3 -
 kernel/locking/qrwlock.c                           |    7 +-
 mm/gup.c                                           |   44 +++++++++++++--
 mm/huge_memory.c                                   |    7 +-
 net/core/neighbour.c                               |    2 
 net/ieee802154/nl802154.c                          |   29 +++++++++
 net/ipv6/ip6_tunnel.c                              |   10 +++
 net/ipv6/sit.c                                     |    4 -
 net/mac80211/cfg.c                                 |    4 +
 net/netfilter/nf_conntrack_standalone.c            |    1 
 net/netfilter/nft_limit.c                          |    4 -
 net/sctp/socket.c                                  |   13 +---
 sound/soc/fsl/fsl_esai.c                           |    8 +-
 tools/arch/ia64/include/asm/barrier.h              |    3 -
 61 files changed, 324 insertions(+), 198 deletions(-)

Alexander Aring (7):
      net: ieee802154: stop dump llsec keys for monitors
      net: ieee802154: stop dump llsec devs for monitors
      net: ieee802154: forbid monitor for add llsec dev
      net: ieee802154: stop dump llsec devkeys for monitors
      net: ieee802154: forbid monitor for add llsec devkey
      net: ieee802154: stop dump llsec seclevels for monitors
      net: ieee802154: forbid monitor for add llsec seclevel

Alexander Shiyan (1):
      ASoC: fsl_esai: Fix TDM slot setup for I2S mode

Ali Saidi (1):
      locking/qrwlock: Fix ordering in queued_write_lock_slowpath()

Andy Shevchenko (1):
      dmaengine: dw: Make it dependent to HAS_IOMEM

Arnd Bergmann (2):
      ARM: keystone: fix integer overflow warning
      Input: i8042 - fix Pegatron C15B ID entry

Caleb Connolly (1):
      Input: s6sy761 - fix coordinate read bit shift

Christophe JAILLET (1):
      net: davicom: Fix regulator not turned off on failed probe

Eric Dumazet (1):
      netfilter: nft_limit: avoid possible divide error in nft_limit_init

Fabian Vogt (1):
      Input: nspire-keypad - enable interrupts only when opened

Fredrik Strupe (1):
      ARM: 9071/1: uprobes: Don't hook on thumb instructions

Greg Kroah-Hartman (1):
      Linux 4.19.189

Guenter Roeck (1):
      pcnet32: Use pci_resource_len to validate PCI resource

Hristo Venev (2):
      net: sit: Unregister catch-all devices
      net: ip6_tunnel: Unregister catch-all devices

Jaegeuk Kim (1):
      dm verity fec: fix misaligned RS roots IO

Jason Xing (1):
      i40e: fix the panic when running bpf in xdpdrv mode

Jia-Ju Bai (1):
      HID: alps: fix error return code in alps_input_configured()

Jiapeng Zhong (1):
      HID: wacom: Assign boolean values to a bool variable

Johan Hovold (1):
      net: hso: fix NULL-deref on disconnect regression

John Paul Adrian Glaubitz (1):
      ia64: tools: remove duplicate definition of ia64_mf() on ia64

Jolly Shah (1):
      scsi: libsas: Reset num_scatter if libata marks qc as NODATA

Kan Liang (1):
      perf/x86/intel/uncore: Remove uncore extra PCI dev HSWEP_PCI_PCU_3

Lijun Pan (3):
      ibmvnic: avoid calling napi_disable() twice
      ibmvnic: remove duplicate napi_schedule call in do_reset function
      ibmvnic: remove duplicate napi_schedule call in open function

Linus Torvalds (2):
      readdir: make sure to verify directory entry for legacy interfaces too
      gup: document and work around "COW can break either way" issue

Martin Wilck (1):
      scsi: scsi_transport_srp: Don't block target in SRP_PORT_LOST state

Matti Vaittinen (1):
      gpio: sysfs: Obey valid_mask

Michael Brown (1):
      xen-netback: Check for hotplug-status existence before watching

Mike Galbraith (1):
      x86/crash: Fix crash_setup_memmap_entries() out-of-bounds access

Nathan Chancellor (1):
      arm64: alternatives: Move length validation in alternative_{insn, endif}

Oliver Neukum (1):
      USB: CDC-ACM: fix poison/unpoison imbalance

Or Cohen (1):
      net/sctp: fix race condition in sctp_destroy_sock

Pablo Neira Ayuso (1):
      netfilter: conntrack: do not print icmpv6 as unknown via /proc

Pali Rohár (1):
      net: phy: marvell: fix detection of PHY on Topaz switches

Peter Collingbourne (1):
      arm64: fix inline asm in load_unaligned_zeropad()

Phillip Potter (1):
      net: geneve: check skb is large enough for IPv4/IPv6 header

Ping Cheng (1):
      HID: wacom: set EV_KEY and EV_ABS only for non-HID_GENERIC type of devices

Randy Dunlap (1):
      ia64: fix discontig.c section mismatches

Rob Clark (1):
      drm/msm: Fix a5xx/a6xx timestamps

Russell King (1):
      ARM: footbridge: fix PCI interrupt mapping

Seevalamuthu Mariappan (1):
      mac80211: clear sta->fast_rx when STA removed from 4-addr VLAN

Shou-Chieh Hsu (1):
      HID: google: add don USB id

Tetsuo Handa (1):
      lockdep: Add a missing initialization hint to the "INFO: Trying to register non-static key" message

Tong Zhu (1):
      neighbour: Disregard DEAD dst in neigh_update

Tony Lindgren (3):
      ARM: dts: Drop duplicate sha2md5_fck to fix clk_disable race
      ARM: dts: Fix moving mmc devices with aliases for omap4 & 5
      ARM: dts: Fix swapped mmc order for omap3

Vasily Gorbik (1):
      s390/entry: save the caller of psw_idle

Wan Jiabing (1):
      cavium/liquidio: Fix duplicate argument

Wang Qing (1):
      arc: kernel: Return -EFAULT if copy_to_user() fails

Yuanyuan Zhong (1):
      pinctrl: lewisburg: Update number of pins in community

