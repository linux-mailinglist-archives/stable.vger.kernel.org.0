Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A737F49E36E
	for <lists+stable@lfdr.de>; Thu, 27 Jan 2022 14:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241735AbiA0NcN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jan 2022 08:32:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241821AbiA0NcL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jan 2022 08:32:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BE4C061714;
        Thu, 27 Jan 2022 05:32:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBBD1B82232;
        Thu, 27 Jan 2022 13:32:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D328FC340E4;
        Thu, 27 Jan 2022 13:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643290328;
        bh=6mCgASksFy2RHrNJ0zx1dcOCotxlzNa8BvxMOb8vyAg=;
        h=From:To:Cc:Subject:Date:From;
        b=AgMtHLYW76HLNnPH7lq0onFITFj1a/7hyJXadYS+WcxXK89ty3ko3ZnGqVpiccGWr
         HyxL/bV3SxVIvigy83xPfZ5Uzp4vTseALmHB9oh3axZPuNanXnriTMQWOJBoUJAFc/
         T+8VqaWTo5XlO6LYbrLSJM6R44vRsUI6LYRhApjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.263
Date:   Thu, 27 Jan 2022 14:31:57 +0100
Message-Id: <1643290318232161@kroah.com>
X-Mailer: git-send-email 2.35.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.263 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/admin-guide/hw-vuln/spectre.rst            |    2 
 Makefile                                                 |    2 
 arch/arm64/boot/dts/nvidia/tegra186.dtsi                 |    2 
 arch/arm64/boot/dts/qcom/msm8916.dtsi                    |    4 
 arch/mips/bcm63xx/clk.c                                  |    6 
 arch/mips/cavium-octeon/octeon-platform.c                |    2 
 arch/mips/cavium-octeon/octeon-usb.c                     |    1 
 arch/mips/include/asm/octeon/cvmx-bootinfo.h             |    4 
 arch/mips/lantiq/clk.c                                   |    6 
 arch/mips/mm/gup.c                                       |    9 
 arch/parisc/kernel/traps.c                               |    2 
 arch/powerpc/boot/dts/fsl/qoriq-fman3l-0.dtsi            |    2 
 arch/powerpc/kernel/btext.c                              |    4 
 arch/powerpc/kernel/prom_init.c                          |    2 
 arch/powerpc/kernel/smp.c                                |    2 
 arch/powerpc/kernel/watchdog.c                           |   41 +
 arch/powerpc/platforms/cell/iommu.c                      |    1 
 arch/powerpc/platforms/cell/pervasive.c                  |    1 
 arch/powerpc/platforms/embedded6xx/hlwd-pic.c            |    1 
 arch/powerpc/platforms/powernv/opal-lpc.c                |    1 
 arch/s390/mm/gup.c                                       |    9 
 arch/sh/mm/gup.c                                         |    9 
 arch/sparc/mm/gup.c                                      |    9 
 arch/um/include/shared/registers.h                       |    4 
 arch/um/os-Linux/registers.c                             |    4 
 arch/um/os-Linux/start_up.c                              |    2 
 arch/x86/kernel/cpu/mcheck/mce-inject.c                  |    2 
 arch/x86/um/syscalls_64.c                                |    3 
 drivers/acpi/acpica/exoparg1.c                           |    3 
 drivers/acpi/acpica/hwesleep.c                           |    4 
 drivers/acpi/acpica/hwsleep.c                            |    4 
 drivers/acpi/acpica/hwxfsleep.c                          |    2 
 drivers/acpi/acpica/utdelete.c                           |    1 
 drivers/block/floppy.c                                   |    6 
 drivers/bluetooth/bfusb.c                                |    3 
 drivers/char/mwave/3780i.h                               |    2 
 drivers/char/random.c                                    |   61 +-
 drivers/char/tpm/tpm_tis_core.c                          |    8 
 drivers/clk/bcm/clk-bcm2835.c                            |   13 
 drivers/crypto/qce/sha.c                                 |    2 
 drivers/crypto/stm32/stm32_crc32.c                       |    4 
 drivers/dma/at_xdmac.c                                   |   32 -
 drivers/dma/mmp_pdma.c                                   |    6 
 drivers/dma/pxa_dma.c                                    |    7 
 drivers/firmware/google/Kconfig                          |    6 
 drivers/gpio/gpiolib-acpi.c                              |   15 
 drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c           |    6 
 drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c |   40 +
 drivers/gpu/drm/i915/intel_pm.c                          |    6 
 drivers/gpu/drm/nouveau/nouveau_sgdma.c                  |    9 
 drivers/gpu/drm/nouveau/nvkm/subdev/pmu/base.c           |   37 -
 drivers/gpu/drm/radeon/radeon_kms.c                      |   42 +
 drivers/gpu/drm/ttm/ttm_tt.c                             |    2 
 drivers/hid/hid-apple.c                                  |    2 
 drivers/hid/uhid.c                                       |   29 +
 drivers/hid/wacom_wac.c                                  |   33 +
 drivers/hsi/hsi_core.c                                   |    1 
 drivers/i2c/busses/i2c-designware-pcidrv.c               |    8 
 drivers/i2c/busses/i2c-i801.c                            |   15 
 drivers/i2c/busses/i2c-mpc.c                             |   23 -
 drivers/infiniband/core/device.c                         |    3 
 drivers/infiniband/hw/cxgb4/qp.c                         |    1 
 drivers/infiniband/hw/hns/hns_roce_main.c                |    5 
 drivers/infiniband/sw/rxe/rxe_opcode.c                   |    2 
 drivers/iommu/iova.c                                     |    3 
 drivers/md/persistent-data/dm-btree.c                    |    8 
 drivers/md/persistent-data/dm-space-map-common.c         |    5 
 drivers/media/common/saa7146/saa7146_fops.c              |    2 
 drivers/media/dvb-core/dmxdev.c                          |   18 
 drivers/media/dvb-frontends/dib8000.c                    |    4 
 drivers/media/pci/b2c2/flexcop-pci.c                     |    3 
 drivers/media/pci/saa7146/hexium_gemini.c                |    7 
 drivers/media/pci/saa7146/hexium_orion.c                 |    8 
 drivers/media/pci/saa7146/mxb.c                          |    8 
 drivers/media/platform/mtk-vcodec/mtk_vcodec_enc_drv.c   |    2 
 drivers/media/rc/igorplugusb.c                           |    4 
 drivers/media/rc/mceusb.c                                |    8 
 drivers/media/rc/redrat3.c                               |   22 
 drivers/media/tuners/msi001.c                            |    7 
 drivers/media/tuners/si2157.c                            |    2 
 drivers/media/usb/b2c2/flexcop-usb.c                     |   10 
 drivers/media/usb/b2c2/flexcop-usb.h                     |   12 
 drivers/media/usb/cpia2/cpia2_usb.c                      |    4 
 drivers/media/usb/dvb-usb/dib0700_core.c                 |    2 
 drivers/media/usb/dvb-usb/dw2102.c                       |  338 +++++++++------
 drivers/media/usb/dvb-usb/m920x.c                        |   12 
 drivers/media/usb/em28xx/em28xx-cards.c                  |   18 
 drivers/media/usb/em28xx/em28xx-core.c                   |    4 
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c                  |    8 
 drivers/media/usb/s2255/s2255drv.c                       |    4 
 drivers/media/usb/stk1160/stk1160-core.c                 |    4 
 drivers/media/usb/uvc/uvc_video.c                        |    4 
 drivers/media/usb/uvc/uvcvideo.h                         |    2 
 drivers/mfd/intel-lpss-acpi.c                            |    7 
 drivers/misc/lattice-ecp3-config.c                       |   12 
 drivers/mmc/core/sdio.c                                  |    4 
 drivers/net/bonding/bond_main.c                          |    6 
 drivers/net/can/softing/softing_cs.c                     |    2 
 drivers/net/can/softing/softing_fw.c                     |   11 
 drivers/net/can/usb/gs_usb.c                             |    5 
 drivers/net/can/xilinx_can.c                             |    7 
 drivers/net/ethernet/broadcom/genet/bcmgenet.c           |   10 
 drivers/net/ethernet/chelsio/libcxgb/libcxgb_cm.c        |    3 
 drivers/net/ethernet/freescale/fman/mac.c                |   21 
 drivers/net/ethernet/freescale/gianfar.c                 |   38 -
 drivers/net/ethernet/freescale/xgmac_mdio.c              |    3 
 drivers/net/ethernet/i825xx/sni_82596.c                  |    3 
 drivers/net/ethernet/mellanox/mlxsw/pci.c                |    1 
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c        |   14 
 drivers/net/phy/marvell.c                                |    6 
 drivers/net/phy/mdio_bus.c                               |    2 
 drivers/net/ppp/ppp_generic.c                            |    7 
 drivers/net/usb/mcs7830.c                                |   12 
 drivers/net/wireless/ath/ar5523/ar5523.c                 |    4 
 drivers/net/wireless/ath/ath10k/htt_tx.c                 |    3 
 drivers/net/wireless/ath/ath10k/txrx.c                   |    2 
 drivers/net/wireless/ath/ath9k/hif_usb.c                 |    7 
 drivers/net/wireless/ath/wcn36xx/smd.c                   |    4 
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c             |   17 
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c        |   17 
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c            |    2 
 drivers/net/wireless/marvell/mwifiex/usb.c               |    3 
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c      |    1 
 drivers/parisc/pdc_stable.c                              |    4 
 drivers/pci/quirks.c                                     |    3 
 drivers/pcmcia/cs.c                                      |    8 
 drivers/pcmcia/rsrc_nonstatic.c                          |    6 
 drivers/power/supply/bq25890_charger.c                   |    4 
 drivers/rtc/rtc-cmos.c                                   |    3 
 drivers/scsi/sr.c                                        |    2 
 drivers/scsi/sr_vendor.c                                 |    4 
 drivers/scsi/ufs/tc-dwc-g210-pci.c                       |    1 
 drivers/scsi/ufs/ufshcd-pltfrm.c                         |    2 
 drivers/scsi/ufs/ufshcd.c                                |    7 
 drivers/spi/spi-meson-spifc.c                            |    1 
 drivers/staging/wlan-ng/hfa384x_usb.c                    |   22 
 drivers/tty/serial/amba-pl010.c                          |    3 
 drivers/tty/serial/amba-pl011.c                          |   27 -
 drivers/tty/serial/atmel_serial.c                        |   14 
 drivers/tty/serial/serial_core.c                         |    7 
 drivers/usb/core/hcd.c                                   |    9 
 drivers/usb/core/hub.c                                   |    7 
 drivers/usb/gadget/function/f_fs.c                       |    4 
 drivers/usb/host/uhci-platform.c                         |    3 
 drivers/usb/misc/ftdi-elan.c                             |    1 
 drivers/w1/slaves/w1_ds28e04.c                           |   26 -
 fs/btrfs/backref.c                                       |   21 
 fs/dlm/lock.c                                            |    9 
 fs/ext4/ioctl.c                                          |    2 
 fs/ext4/mballoc.c                                        |    8 
 fs/ext4/migrate.c                                        |   23 -
 fs/ext4/super.c                                          |   12 
 fs/fuse/acl.c                                            |    6 
 fs/fuse/dir.c                                            |   40 +
 fs/fuse/file.c                                           |   27 -
 fs/fuse/fuse_i.h                                         |   13 
 fs/fuse/inode.c                                          |    2 
 fs/fuse/xattr.c                                          |    9 
 fs/jffs2/file.c                                          |   40 +
 fs/nfs/nfs4client.c                                      |   82 +--
 fs/orangefs/orangefs-bufmap.c                            |    7 
 fs/ubifs/super.c                                         |    1 
 include/acpi/actypes.h                                   |   10 
 include/net/sch_generic.h                                |    5 
 kernel/sched/cputime.c                                   |    4 
 kernel/sched/rt.c                                        |   23 -
 mm/shmem.c                                               |   37 -
 net/bluetooth/cmtp/core.c                                |    4 
 net/bluetooth/hci_core.c                                 |    1 
 net/bluetooth/hci_event.c                                |    8 
 net/bluetooth/sco.c                                      |   34 +
 net/bridge/br_netfilter_hooks.c                          |    7 
 net/core/filter.c                                        |    6 
 net/core/net_namespace.c                                 |    4 
 net/mac80211/rx.c                                        |    2 
 net/nfc/llcp_sock.c                                      |    5 
 net/sched/sch_generic.c                                  |    1 
 net/unix/garbage.c                                       |   14 
 net/unix/scm.c                                           |    6 
 scripts/dtc/dtx_diff                                     |    8 
 sound/core/jack.c                                        |    3 
 sound/core/oss/pcm_oss.c                                 |    2 
 sound/core/pcm.c                                         |    6 
 sound/core/seq/seq_queue.c                               |   14 
 sound/pci/hda/hda_codec.c                                |    3 
 sound/soc/mediatek/mt8173/mt8173-max98090.c              |    3 
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c         |    2 
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5676.c         |    2 
 sound/soc/mediatek/mt8173/mt8173-rt5650.c                |    2 
 sound/soc/samsung/idma.c                                 |    2 
 190 files changed, 1346 insertions(+), 689 deletions(-)

Alan Stern (2):
      USB: core: Fix bug in resuming hub's handling of wakeup requests
      USB: Fix "slab-out-of-bounds Write" bug in usb_hcd_poll_rh_status

Alexander Aring (1):
      fs: dlm: filter user dlm messages for kernel locks

Amir Goldstein (1):
      fuse: fix live lock in fuse_iget()

Anders Roxell (1):
      powerpc/cell: Fix clang -Wimplicit-fallthrough warning

Andrey Ryabinin (1):
      cputime, cpuacct: Include guest time in user time in cpuacct.stat

Andy Shevchenko (1):
      mfd: intel-lpss: Fix too early PM enablement in the ACPI ->probe()

Andy Spencer (1):
      gianfar: simplify FCS handling and fix memory leak

Anton Vasilyev (1):
      media: dw2102: Fix use after free

Arnd Bergmann (1):
      dmaengine: pxa/mmp: stop referencing config->slave_id

Avihai Horon (1):
      RDMA/core: Let ib_find_gid() continue search even after empty entry

Bart Van Assche (1):
      scsi: ufs: Fix race conditions related to driver data

Ben Hutchings (2):
      firmware: Update Kconfig help text for Google firmware
      mips,s390,sh,sparc: gup: Work around the "COW can break either way" issue

Ben Skeggs (1):
      drm/nouveau/pmu/gm200-: avoid touching PMU outside of DEVINIT/PREOS/ACR

Bixuan Cui (1):
      ALSA: oss: fix compile error when OSS_DEBUG is enabled

Brian Silverman (1):
      can: gs_usb: gs_can_start_xmit(): zero-initialize hf->{flags,reserved}

Bryan O'Donoghue (1):
      wcn36xx: Indicate beacon not connection loss on MISSED_BEACON_IND

Chen Jun (1):
      tpm: add request_locality before write TPM_INT_ENABLE

Chengfeng Ye (2):
      crypto: qce - fix uaf on qce_ahash_register_one
      HSI: core: Fix return freed object in hsi_new_client

Chengguang Xu (1):
      RDMA/rxe: Fix a typo in opcode name

Christian König (1):
      drm/radeon: fix error handling in radeon_driver_open_kms

Christoph Hellwig (1):
      scsi: sr: Don't use GFP_DMA

Christophe JAILLET (1):
      orangefs: Fix the size of a memory allocation in orangefs_bufmap_alloc()

Christophe Leroy (1):
      w1: Misuse of get_user()/put_user() reported by sparse

Dafna Hirschfeld (1):
      media: mtk-vcodec: call v4l2_m2m_ctx_release first when file is released

Danielle Ratson (1):
      mlxsw: pci: Add shutdown method in PCI driver

Dave Airlie (1):
      drm/ttm/nouveau: don't call tt destroy callback on alloc failure.

Desmond Cheong Zhi Xi (2):
      Bluetooth: schedule SCO timeouts with delayed_work
      Bluetooth: fix init and cleanup of sco_conn.timeout_work

Dmitry Baryshkov (1):
      arm64: dts: qcom: msm8916: fix MMC controller aliases

Dominik Brodowski (1):
      pcmcia: fix setting of kthread task states

Dongliang Mu (1):
      media: em28xx: fix memory leak in em28xx_init_dev

Eric Biggers (2):
      random: fix data race on crng_node_pool
      random: fix data race on crng init time

Eric Dumazet (3):
      ppp: ensure minimum packet size in ppp_write()
      af_unix: annote lockless accesses to unix_tot_inflight & gc_in_progress
      netns: add schedule point in ops_exit_list()

Florian Fainelli (1):
      net: mdio: Demote probed message to debug print

Florian Westphal (1):
      netfilter: bridge: add support for pppoe filtering

Gang Li (1):
      shmem: fix a race between shmem_unused_huge_shrink and shmem_evict_inode

Greg Kroah-Hartman (1):
      Linux 4.14.263

Guillaume Nault (1):
      libcxgb: Don't accidentally set RTO_ONLINK in cxgb_find_route()

Hans de Goede (1):
      gpiolib: acpi: Do not set the IRQ type if the IRQ is already in use

Heiner Kallweit (1):
      i2c: i801: Don't silently correct invalid transfer size

Ilan Peer (1):
      iwlwifi: mvm: Increase the scan timeout guard to 30 seconds

James Hilliard (1):
      media: uvcvideo: Increase UVC_CTRL_CONTROL_TIMEOUT to 5 seconds.

Jan Kara (2):
      ext4: avoid trim error on fs with small groups
      ext4: make sure quota gets properly shutdown on error

Jann Horn (1):
      HID: uhid: Fix worker destroying device without any protection

Jason Gerecke (2):
      HID: wacom: Ignore the confidence flag when a touch is removed
      HID: wacom: Avoid using stale array indicies to read contact count

Jiasheng Jiang (3):
      fsl/fman: Check for null pointer after calling devm_ioremap
      can: xilinx_can: xcan_probe(): check for error irq
      ASoC: samsung: idma: Check of ioremap return value

Joakim Tjernlund (1):
      i2c: mpc: Correct I2C reset procedure

Joe Thornber (2):
      dm btree: add a defensive bounds check to insert_at()
      dm space map common: add bounds check to sm_ll_lookup_bitmap()

Johan Hovold (11):
      Bluetooth: bfusb: fix division by zero in send path
      media: uvcvideo: fix division by zero at stream start
      media: flexcop-usb: fix control-message timeouts
      media: mceusb: fix control-message timeouts
      media: em28xx: fix control-message timeouts
      media: cpia2: fix control-message timeouts
      media: s2255: fix control-message timeouts
      media: redrat3: fix control-message timeouts
      media: pvrusb2: fix control-message timeouts
      media: stk1160: fix control-message timeouts
      can: softing_cs: softingcs_probe(): fix memleak on registration failure

Johannes Berg (3):
      iwlwifi: mvm: synchronize with FW after multicast commands
      iwlwifi: fix leaks/bad data after failed firmware load
      iwlwifi: remove module loading failure message

John David Anglin (1):
      parisc: Avoid calling faulthandler_disabled() twice

Josef Bacik (2):
      btrfs: remove BUG_ON() in find_parent_nodes()
      btrfs: remove BUG_ON(!eie) in find_parent_nodes

José Expósito (1):
      HID: apple: Do not reset quirks when the Fn key is not found

Julia Lawall (4):
      powerpc/6xx: add missing of_node_put
      powerpc/powernv: add missing of_node_put
      powerpc/cell: add missing of_node_put
      powerpc/btext: add missing of_node_put

Kai-Heng Feng (1):
      usb: hub: Add delay for SuperSpeed hub resume to let links transit to U0

Kamal Heib (2):
      RDMA/hns: Validate the pkey index
      RDMA/cxgb4: Set queue pair state when being queried

Kees Cook (1):
      char/mwave: Adjust io port register size

Kevin Bracey (1):
      net_sched: restore "mpu xxx" handling

Kirill A. Shutemov (1):
      ACPICA: Hardware: Do not flush CPU cache when entering S4 and S5

Krzysztof Kozlowski (1):
      nfc: llcp: fix NULL error pointer dereference on sendmsg() after failed bind()

Kyeong Yoo (1):
      jffs2: GC deadlock reading a page that is used in jffs2_write_begin()

Lakshmi Sowjanya D (1):
      i2c: designware-pci: Fix to change data types of hcnt and lcnt parameters

Larry Finger (1):
      rtlwifi: rtl8192cu: Fix WARNING when calling local_irq_restore() with interrupts enabled

Li Hua (1):
      sched/rt: Try to restart rt period timer when rt runtime exceeded

Lino Sanfilippo (1):
      serial: amba-pl011: do not request memory region twice

Lukas Bulwahn (1):
      Documentation: refer to config RANDOMIZE_BASE for kernel address-space randomization

Lukas Wunner (3):
      serial: pl010: Drop CR register reset on set_termios
      serial: core: Keep mctrl register state and cached copy in sync
      serial: Fix incorrect rs485 polarity on uart open

Luís Henriques (1):
      ext4: set csum seed in tmp inode while migrating to extents

Marc Kleine-Budde (2):
      can: gs_usb: fix use of uninitialized variable, detach device on reception of invalid USB data
      can: softing: softing_startstop(): fix set but not used variable warning

Marek Vasut (1):
      crypto: stm32/crc32 - Fix kernel BUG triggered in probe()

Mark Langsdorf (1):
      ACPICA: actypes.h: Expand the ACPI_ACCESS_ definitions

Martyn Welch (1):
      drm/bridge: megachips: Ensure both bridges are probed before registration

Mateusz Jończyk (1):
      rtc: cmos: take rtc_lock while reading from CMOS

Matthias Schiffer (1):
      scripts/dtc: dtx_diff: remove broken example from help text

Mauro Carvalho Chehab (1):
      media: m920x: don't use stack on USB reads

Maxime Ripard (2):
      clk: bcm-2835: Pick the closest clock rate
      clk: bcm-2835: Remove rounding up the dividers

Miaoqian Lin (3):
      spi: spi-meson-spifc: Add missing pm_runtime_disable() in meson_spifc_probe
      parisc: pdc_stable: Fix memory leak in pdcs_register_pathentries
      lib82596: Fix IRQ check in sni_82596_probe

Michael Braun (1):
      gianfar: fix jumbo packets+napi+rx overrun crash

Michael Ellerman (1):
      powerpc/smp: Move setup_profiling_timer() under CONFIG_PROFILING

Michael Kuron (1):
      media: dib0700: fix undefined behavior in tuner shutdown

Miklos Szeredi (1):
      fuse: fix bad inode

Nathan Chancellor (2):
      staging: wlan-ng: Avoid bitwise vs logical OR warning in hfa384x_usb_throttlefn()
      drm/i915: Avoid bitwise vs logical OR warning in snb_wm_latency_quirk()

Neal Liu (1):
      usb: uhci: add aspeed ast2600 uhci support

Nicholas Piggin (1):
      powerpc/watchdog: Fix missed watchdog reset due to memory ordering race

Paolo Abeni (1):
      bpf: Do not WARN in bpf_warn_invalid_xdp_action()

Pavankumar Kondeti (1):
      usb: gadget: f_fs: Use stream_open() for endpoint files

Pavel Skripkin (2):
      Bluetooth: stop proccessing malicious adv data
      net: mcs7830: handle usb read errors properly

Peiwei Hu (1):
      powerpc/prom_init: Fix improper check of prom_getprop()

Petr Cvachoucek (1):
      ubifs: Error path in ubifs_remount_rw() seems to wrongly free write buffers

Ping-Ke Shih (1):
      mac80211: allow non-standard VHT MCS-10/11

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

Robert Schlabbach (1):
      media: si2157: Fix "warm" tuner state detection

Russell King (Oracle) (1):
      net: phy: marvell: configure RGMII delays for 88E1118

Sean Young (1):
      media: igorplugusb: receiver overflow should be reported

Sebastian Gottschall (1):
      ath10k: Fix tx hanging

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

Thierry Reding (1):
      arm64: tegra: Adjust length of CCPLEX cluster MMIO region

Tianjia Zhang (1):
      MIPS: Octeon: Fix build errors using clang

Tobias Waldekranz (2):
      powerpc/fsl/dts: Enable WA for erratum A-009885 on fman3l MDIO buses
      net/fsl: xgmac_mdio: Fix incorrect iounmap when removing module

Trond Myklebust (1):
      NFSv4: Initialise connection to the server in nfs4_alloc_client()

Tudor Ambarus (6):
      tty: serial: atmel: Check return code of dmaengine_submit()
      tty: serial: atmel: Call dma_async_issue_pending()
      dmaengine: at_xdmac: Don't start transactions at tx_submit level
      dmaengine: at_xdmac: Print debug message after realeasing the lock
      dmaengine: at_xdmac: Fix lld view setting
      dmaengine: at_xdmac: Fix at_xdmac_lld struct definition

Tzung-Bi Shih (1):
      ASoC: mediatek: mt8173: fix device_node leak

Ulf Hansson (1):
      mmc: core: Fixup storing of OCR for MMC_QUIRK_NONSTD_SDIO

Wang Hai (3):
      Bluetooth: cmtp: fix possible panic when cmtp_init_sockets() fails
      media: dmxdev: fix UAF when dvb_register_device() fails
      media: msi001: fix possible null-ptr-deref in msi001_probe()

Wei Yongjun (3):
      usb: ftdi-elan: fix memory leak on device disconnect
      misc: lattice-ecp3-config: Fix task hung when firmware load failed
      Bluetooth: Fix debugfs entry leak in hci_register_dev()

Xiongfeng Wang (1):
      iommu/iova: Fix race between FQ timeout and teardown

Xiongwei Song (1):
      floppy: Add max size check for user space request

Yauhen Kharuzhy (1):
      power: bq25890: Enable continuous conversion for ADC at charging

Ye Bin (1):
      ext4: Fix BUG_ON in ext4_bread when write quota data

Ye Guojin (1):
      MIPS: OCTEON: add put_device() after of_find_device_by_node()

Yifeng Li (1):
      PCI: Add function 1 DMA alias quirk for Marvell 88SE9125 SATA controller

Yixing Liu (1):
      RDMA/hns: Modify the mapping attribute of doorbell to device

Zekun Shen (3):
      ar5523: Fix null-ptr-deref with unexpected WDCMSG_TARGET_START reply
      mwifiex: Fix skb_over_panic in mwifiex_usb_recv()
      ath9k: Fix out-of-bound memcpy in ath9k_hif_usb_rx_stream

Zhang Zixun (1):
      x86/mce/inject: Avoid out-of-bounds write when setting flags

Zheyu Ma (1):
      media: b2c2: Add missing check in flexcop_pci_isr:

Zhou Qingyang (8):
      drm/amdgpu: Fix a NULL pointer dereference in amdgpu_connector_lcd_native_mode()
      drm/radeon/radeon_kms: Fix a NULL pointer dereference in radeon_driver_open_kms()
      media: dib8000: Fix a memleak in dib8000_init()
      media: saa7146: mxb: Fix a NULL pointer dereference in mxb_attach()
      pcmcia: rsrc_nonstatic: Fix a NULL pointer dereference in __nonstatic_find_io_region()
      pcmcia: rsrc_nonstatic: Fix a NULL pointer dereference in nonstatic_find_mem_region()
      media: saa7146: hexium_orion: Fix a NULL pointer dereference in hexium_attach()
      media: saa7146: hexium_gemini: Fix a NULL pointer dereference in hexium_attach()

