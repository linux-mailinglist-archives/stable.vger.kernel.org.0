Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D645949E366
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 14:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236827AbiA0Nbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 08:31:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiA0Nbx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 08:31:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34919C061714;
        Thu, 27 Jan 2022 05:31:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB4EC61B9D;
        Thu, 27 Jan 2022 13:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91BA0C340E4;
        Thu, 27 Jan 2022 13:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643290312;
        bh=ukZLdSVMN/ikR4iZTjrwg/7KR111h8N265cYE/4NK2E=;
        h=From:To:Cc:Subject:Date:From;
        b=uRHUYsRygVaiotLGBsiMOWybuAx9FbBrvJmaVio1BTeAevNtQ4NZnnCpBa0JcCk8V
         gRGPBrqK1Kbf7FLQu/MaiEYtv229hbAV0ipDxl3zNasM+nSmMKVeBY1ZN6PQEUpBLB
         +7srLMZuGoDw4cz1iU9Ay76MqirbsoJcve8MPLC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.300
Date:   Thu, 27 Jan 2022 14:31:48 +0100
Message-Id: <164329030816656@kroah.com>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.300 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                            |    2 -
 arch/arm64/boot/dts/qcom/msm8916.dtsi               |    4 +-
 arch/mips/bcm63xx/clk.c                             |    6 +++
 arch/mips/include/asm/octeon/cvmx-bootinfo.h        |    4 +-
 arch/mips/lantiq/clk.c                              |    6 +++
 arch/parisc/kernel/traps.c                          |    2 -
 arch/powerpc/boot/dts/fsl/qoriq-fman3l-0.dtsi       |    2 +
 arch/powerpc/kernel/btext.c                         |    4 +-
 arch/powerpc/kernel/prom_init.c                     |    2 -
 arch/powerpc/kernel/smp.c                           |    2 +
 arch/powerpc/platforms/cell/iommu.c                 |    1 
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c       |    1 
 arch/powerpc/platforms/powernv/opal-lpc.c           |    1 
 arch/um/include/shared/registers.h                  |    4 +-
 arch/um/os-Linux/registers.c                        |    4 +-
 arch/um/os-Linux/start_up.c                         |    2 -
 arch/x86/um/syscalls_64.c                           |    3 +
 drivers/acpi/acpica/exoparg1.c                      |    3 +
 drivers/acpi/acpica/utdelete.c                      |    1 
 drivers/block/floppy.c                              |    6 ++-
 drivers/bluetooth/bfusb.c                           |    3 +
 drivers/char/mwave/3780i.h                          |    2 -
 drivers/crypto/qce/sha.c                            |    2 -
 drivers/dma/at_xdmac.c                              |   32 +++++++++-----------
 drivers/dma/mmp_pdma.c                              |    6 ---
 drivers/dma/pxa_dma.c                               |    7 ----
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c      |    6 +++
 drivers/gpu/drm/i915/intel_pm.c                     |    6 +--
 drivers/hid/uhid.c                                  |   29 +++++++++++++++---
 drivers/hsi/hsi.c                                   |    1 
 drivers/i2c/busses/i2c-designware-pcidrv.c          |    8 ++---
 drivers/i2c/busses/i2c-i801.c                       |   15 +++------
 drivers/i2c/busses/i2c-mpc.c                        |   23 +++++++++-----
 drivers/infiniband/core/device.c                    |    3 +
 drivers/infiniband/hw/cxgb4/qp.c                    |    1 
 drivers/md/persistent-data/dm-btree.c               |    8 +++--
 drivers/md/persistent-data/dm-space-map-common.c    |    5 +++
 drivers/media/common/saa7146/saa7146_fops.c         |    2 -
 drivers/media/dvb-frontends/dib8000.c               |    4 +-
 drivers/media/pci/b2c2/flexcop-pci.c                |    3 +
 drivers/media/pci/saa7146/hexium_gemini.c           |    7 +++-
 drivers/media/pci/saa7146/hexium_orion.c            |    8 ++++-
 drivers/media/pci/saa7146/mxb.c                     |    8 ++++-
 drivers/media/rc/igorplugusb.c                      |    4 +-
 drivers/media/rc/mceusb.c                           |    8 ++---
 drivers/media/tuners/msi001.c                       |    7 ++++
 drivers/media/usb/dvb-usb/dib0700_core.c            |    2 -
 drivers/media/usb/dvb-usb/m920x.c                   |   12 ++++++-
 drivers/media/usb/em28xx/em28xx-core.c              |    4 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c             |    8 ++---
 drivers/media/usb/stk1160/stk1160-core.c            |    4 +-
 drivers/media/usb/uvc/uvc_video.c                   |    4 ++
 drivers/mfd/intel-lpss-acpi.c                       |    7 +++-
 drivers/misc/lattice-ecp3-config.c                  |   12 +++----
 drivers/net/bonding/bond_main.c                     |    6 +--
 drivers/net/can/softing/softing_cs.c                |    2 -
 drivers/net/can/softing/softing_fw.c                |   11 +++---
 drivers/net/can/usb/gs_usb.c                        |    5 ++-
 drivers/net/can/xilinx_can.c                        |    7 +++-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c      |   10 +++---
 drivers/net/ethernet/freescale/xgmac_mdio.c         |    3 +
 drivers/net/ethernet/i825xx/sni_82596.c             |    3 +
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c   |   14 +++++++-
 drivers/net/phy/mdio_bus.c                          |    2 -
 drivers/net/ppp/ppp_generic.c                       |    7 +++-
 drivers/net/usb/mcs7830.c                           |   12 ++++++-
 drivers/net/wireless/ath/ar5523/ar5523.c            |    4 ++
 drivers/net/wireless/ath/ath9k/hif_usb.c            |    7 ++++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c         |   17 ++++++++++
 drivers/net/wireless/mwifiex/usb.c                  |    3 +
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c |    1 
 drivers/parisc/pdc_stable.c                         |    4 +-
 drivers/pci/quirks.c                                |    3 +
 drivers/pcmcia/cs.c                                 |    8 +----
 drivers/pcmcia/rsrc_nonstatic.c                     |    6 +++
 drivers/power/bq25890_charger.c                     |    4 +-
 drivers/rtc/rtc-cmos.c                              |    3 +
 drivers/scsi/sr.c                                   |    2 -
 drivers/scsi/sr_vendor.c                            |    4 +-
 drivers/spi/spi-meson-spifc.c                       |    1 
 drivers/tty/serial/amba-pl010.c                     |    3 -
 drivers/tty/serial/amba-pl011.c                     |   27 +---------------
 drivers/tty/serial/atmel_serial.c                   |   14 ++++++++
 drivers/tty/serial/serial_core.c                    |    3 +
 drivers/usb/core/hcd.c                              |    9 +++++
 drivers/usb/core/hub.c                              |    7 +++-
 drivers/usb/gadget/function/f_fs.c                  |    4 +-
 drivers/usb/misc/ftdi-elan.c                        |    1 
 drivers/w1/slaves/w1_ds28e04.c                      |   26 +++-------------
 fs/btrfs/backref.c                                  |   21 ++++++++++---
 fs/dlm/lock.c                                       |    9 +++++
 fs/ext4/ioctl.c                                     |    2 -
 fs/ext4/mballoc.c                                   |    8 +++++
 fs/ext4/migrate.c                                   |   23 ++++++--------
 fs/ext4/super.c                                     |    2 -
 fs/ubifs/super.c                                    |    1 
 include/net/sch_generic.h                           |    5 +++
 net/bluetooth/cmtp/core.c                           |    4 --
 net/bluetooth/hci_core.c                            |    1 
 net/bluetooth/hci_event.c                           |    8 ++++-
 net/bridge/br_netfilter_hooks.c                     |    7 +---
 net/core/net_namespace.c                            |    4 +-
 net/nfc/llcp_sock.c                                 |    5 +++
 net/sched/sch_generic.c                             |    1 
 net/unix/garbage.c                                  |   14 ++++++--
 net/unix/scm.c                                      |    6 ++-
 sound/core/jack.c                                   |    3 +
 sound/core/oss/pcm_oss.c                            |    2 -
 sound/core/pcm.c                                    |    6 +++
 sound/core/seq/seq_queue.c                          |   14 +++++++-
 sound/pci/hda/hda_codec.c                           |    3 +
 sound/soc/samsung/idma.c                            |    2 +
 112 files changed, 479 insertions(+), 236 deletions(-)

Alan Stern (2):
      USB: core: Fix bug in resuming hub's handling of wakeup requests
      USB: Fix "slab-out-of-bounds Write" bug in usb_hcd_poll_rh_status

Alexander Aring (1):
      fs: dlm: filter user dlm messages for kernel locks

Andy Shevchenko (1):
      mfd: intel-lpss: Fix too early PM enablement in the ACPI ->probe()

Arnd Bergmann (1):
      dmaengine: pxa/mmp: stop referencing config->slave_id

Avihai Horon (1):
      RDMA/core: Let ib_find_gid() continue search even after empty entry

Bixuan Cui (1):
      ALSA: oss: fix compile error when OSS_DEBUG is enabled

Brian Silverman (1):
      can: gs_usb: gs_can_start_xmit(): zero-initialize hf->{flags,reserved}

Chengfeng Ye (2):
      crypto: qce - fix uaf on qce_ahash_register_one
      HSI: core: Fix return freed object in hsi_new_client

Christoph Hellwig (1):
      scsi: sr: Don't use GFP_DMA

Christophe Leroy (1):
      w1: Misuse of get_user()/put_user() reported by sparse

Dmitry Baryshkov (1):
      arm64: dts: qcom: msm8916: fix MMC controller aliases

Dominik Brodowski (1):
      pcmcia: fix setting of kthread task states

Eric Dumazet (3):
      ppp: ensure minimum packet size in ppp_write()
      af_unix: annote lockless accesses to unix_tot_inflight & gc_in_progress
      netns: add schedule point in ops_exit_list()

Florian Fainelli (1):
      net: mdio: Demote probed message to debug print

Florian Westphal (1):
      netfilter: bridge: add support for pppoe filtering

Greg Kroah-Hartman (1):
      Linux 4.4.300

Heiner Kallweit (1):
      i2c: i801: Don't silently correct invalid transfer size

Jan Kara (1):
      ext4: avoid trim error on fs with small groups

Jann Horn (1):
      HID: uhid: Fix worker destroying device without any protection

Jiasheng Jiang (2):
      can: xilinx_can: xcan_probe(): check for error irq
      ASoC: samsung: idma: Check of ioremap return value

Joakim Tjernlund (1):
      i2c: mpc: Correct I2C reset procedure

Joe Thornber (2):
      dm btree: add a defensive bounds check to insert_at()
      dm space map common: add bounds check to sm_ll_lookup_bitmap()

Johan Hovold (7):
      Bluetooth: bfusb: fix division by zero in send path
      media: uvcvideo: fix division by zero at stream start
      media: mceusb: fix control-message timeouts
      media: em28xx: fix control-message timeouts
      media: pvrusb2: fix control-message timeouts
      media: stk1160: fix control-message timeouts
      can: softing_cs: softingcs_probe(): fix memleak on registration failure

Johannes Berg (1):
      iwlwifi: mvm: synchronize with FW after multicast commands

John David Anglin (1):
      parisc: Avoid calling faulthandler_disabled() twice

Josef Bacik (2):
      btrfs: remove BUG_ON() in find_parent_nodes()
      btrfs: remove BUG_ON(!eie) in find_parent_nodes

Julia Lawall (4):
      powerpc/6xx: add missing of_node_put
      powerpc/powernv: add missing of_node_put
      powerpc/cell: add missing of_node_put
      powerpc/btext: add missing of_node_put

Kai-Heng Feng (1):
      usb: hub: Add delay for SuperSpeed hub resume to let links transit to U0

Kamal Heib (1):
      RDMA/cxgb4: Set queue pair state when being queried

Kees Cook (1):
      char/mwave: Adjust io port register size

Kevin Bracey (1):
      net_sched: restore "mpu xxx" handling

Krzysztof Kozlowski (1):
      nfc: llcp: fix NULL error pointer dereference on sendmsg() after failed bind()

Lakshmi Sowjanya D (1):
      i2c: designware-pci: Fix to change data types of hcnt and lcnt parameters

Larry Finger (1):
      rtlwifi: rtl8192cu: Fix WARNING when calling local_irq_restore() with interrupts enabled

Lino Sanfilippo (1):
      serial: amba-pl011: do not request memory region twice

Lukas Wunner (2):
      serial: pl010: Drop CR register reset on set_termios
      serial: core: Keep mctrl register state and cached copy in sync

Luís Henriques (1):
      ext4: set csum seed in tmp inode while migrating to extents

Marc Kleine-Budde (2):
      can: gs_usb: fix use of uninitialized variable, detach device on reception of invalid USB data
      can: softing: softing_startstop(): fix set but not used variable warning

Mateusz Jończyk (1):
      rtc: cmos: take rtc_lock while reading from CMOS

Mauro Carvalho Chehab (1):
      media: m920x: don't use stack on USB reads

Miaoqian Lin (3):
      spi: spi-meson-spifc: Add missing pm_runtime_disable() in meson_spifc_probe
      parisc: pdc_stable: Fix memory leak in pdcs_register_pathentries
      lib82596: Fix IRQ check in sni_82596_probe

Michael Ellerman (1):
      powerpc/smp: Move setup_profiling_timer() under CONFIG_PROFILING

Michael Kuron (1):
      media: dib0700: fix undefined behavior in tuner shutdown

Nathan Chancellor (1):
      drm/i915: Avoid bitwise vs logical OR warning in snb_wm_latency_quirk()

Pavankumar Kondeti (1):
      usb: gadget: f_fs: Use stream_open() for endpoint files

Pavel Skripkin (2):
      Bluetooth: stop proccessing malicious adv data
      net: mcs7830: handle usb read errors properly

Peiwei Hu (1):
      powerpc/prom_init: Fix improper check of prom_getprop()

Petr Cvachoucek (1):
      ubifs: Error path in ubifs_remount_rw() seems to wrongly free write buffers

Rafael J. Wysocki (2):
      ACPICA: Utilities: Avoid deleting the same object twice in a row
      ACPICA: Executer: Fix the REFCLASS_REFOF case in acpi_ex_opcode_1A_0T_1R()

Randy Dunlap (3):
      mips: lantiq: add support for clk_set_parent()
      mips: bcm63xx: add support for clk_set_parent()
      um: registers: Rename function names to avoid conflicts and build problems

Robert Hancock (2):
      net: axienet: Wait for PhyRstCmplt after core reset
      net: axienet: fix number of TX ring slots for available check

Sean Young (1):
      media: igorplugusb: receiver overflow should be reported

Sergey Shtylyov (1):
      bcmgenet: add WOL IRQ check

Suresh Kumar (1):
      net: bonding: debug: avoid printing debug logs when bond is not notifying peers

Takashi Iwai (4):
      ALSA: jack: Add missing rwsem around snd_ctl_remove() calls
      ALSA: PCM: Add missing rwsem around snd_ctl_remove() calls
      ALSA: hda: Add missing rwsem around snd_ctl_remove() calls
      ALSA: seq: Set upper limit of processed events

Tasos Sahanidis (1):
      floppy: Fix hang in watchdog when disk is ejected

Theodore Ts'o (1):
      ext4: don't use the orphan list when migrating an inode

Tianjia Zhang (1):
      MIPS: Octeon: Fix build errors using clang

Tobias Waldekranz (2):
      powerpc/fsl/dts: Enable WA for erratum A-009885 on fman3l MDIO buses
      net/fsl: xgmac_mdio: Fix incorrect iounmap when removing module

Tudor Ambarus (6):
      tty: serial: atmel: Check return code of dmaengine_submit()
      tty: serial: atmel: Call dma_async_issue_pending()
      dmaengine: at_xdmac: Don't start transactions at tx_submit level
      dmaengine: at_xdmac: Print debug message after realeasing the lock
      dmaengine: at_xdmac: Fix lld view setting
      dmaengine: at_xdmac: Fix at_xdmac_lld struct definition

Wang Hai (2):
      Bluetooth: cmtp: fix possible panic when cmtp_init_sockets() fails
      media: msi001: fix possible null-ptr-deref in msi001_probe()

Wei Yongjun (3):
      usb: ftdi-elan: fix memory leak on device disconnect
      misc: lattice-ecp3-config: Fix task hung when firmware load failed
      Bluetooth: Fix debugfs entry leak in hci_register_dev()

Xiongwei Song (1):
      floppy: Add max size check for user space request

Yauhen Kharuzhy (1):
      power: bq25890: Enable continuous conversion for ADC at charging

Ye Bin (1):
      ext4: Fix BUG_ON in ext4_bread when write quota data

Yifeng Li (1):
      PCI: Add function 1 DMA alias quirk for Marvell 88SE9125 SATA controller

Zekun Shen (3):
      ar5523: Fix null-ptr-deref with unexpected WDCMSG_TARGET_START reply
      mwifiex: Fix skb_over_panic in mwifiex_usb_recv()
      ath9k: Fix out-of-bound memcpy in ath9k_hif_usb_rx_stream

Zheyu Ma (1):
      media: b2c2: Add missing check in flexcop_pci_isr:

Zhou Qingyang (7):
      drm/amdgpu: Fix a NULL pointer dereference in amdgpu_connector_lcd_native_mode()
      media: dib8000: Fix a memleak in dib8000_init()
      media: saa7146: mxb: Fix a NULL pointer dereference in mxb_attach()
      pcmcia: rsrc_nonstatic: Fix a NULL pointer dereference in __nonstatic_find_io_region()
      pcmcia: rsrc_nonstatic: Fix a NULL pointer dereference in nonstatic_find_mem_region()
      media: saa7146: hexium_orion: Fix a NULL pointer dereference in hexium_attach()
      media: saa7146: hexium_gemini: Fix a NULL pointer dereference in hexium_attach()

