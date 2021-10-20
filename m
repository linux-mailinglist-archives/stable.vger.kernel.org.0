Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC06434925
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 12:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbhJTKp6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 06:45:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:51146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230072AbhJTKp5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 06:45:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F6E7610EA;
        Wed, 20 Oct 2021 10:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634726622;
        bh=Ux/tWH9iR2XF9uRW7yAmk3a0gDngVOFA8DKRtBNMmdg=;
        h=From:To:Cc:Subject:Date:From;
        b=sbpMA9YAs5bQhUX04MkKnbDhf3I2a3XksWctq5hgQThCuhse8r4BOKpWHtaNWcEFX
         VC8YMs7dXr8yc+cocdMbStyCYzrW1igC3UGRD8DoINgQu70AgdPlMzbL62khRu4/fm
         qq6Mvon65DXTozL3MIu84QVCyRMijiWZULfZwThs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.75
Date:   Wed, 20 Oct 2021 12:43:36 +0200
Message-Id: <163472661754156@kroah.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.75 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                            |    2 
 arch/arm/boot/dts/bcm2711-rpi-4-b.dts               |   11 +-
 arch/arm/boot/dts/bcm2711.dtsi                      |    4 -
 arch/arm64/mm/hugetlbpage.c                         |    2 
 arch/csky/kernel/ptrace.c                           |    3 
 arch/csky/kernel/signal.c                           |    4 +
 arch/powerpc/sysdev/xive/common.c                   |    3 
 arch/s390/lib/string.c                              |   15 +--
 arch/x86/Kconfig                                    |    1 
 arch/x86/kernel/cpu/resctrl/core.c                  |    2 
 drivers/acpi/arm64/gtdt.c                           |    2 
 drivers/ata/libahci_platform.c                      |    5 -
 drivers/ata/pata_legacy.c                           |    6 +
 drivers/base/core.c                                 |    3 
 drivers/bus/simple-pm-bus.c                         |   39 +++++++++-
 drivers/clk/socfpga/clk-agilex.c                    |    9 --
 drivers/edac/armada_xp_edac.c                       |    2 
 drivers/firmware/efi/cper.c                         |    4 -
 drivers/firmware/efi/runtime-wrappers.c             |    2 
 drivers/gpio/gpio-pca953x.c                         |   16 ++--
 drivers/gpu/drm/drm_edid.c                          |   15 +++
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c               |    6 -
 drivers/gpu/drm/msm/adreno/a6xx_gpu.h               |   11 ++
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c           |   16 ++++
 drivers/gpu/drm/msm/dsi/dsi.c                       |    4 -
 drivers/gpu/drm/msm/dsi/dsi_host.c                  |    2 
 drivers/gpu/drm/msm/edp/edp_ctrl.c                  |    3 
 drivers/gpu/drm/msm/msm_drv.c                       |    3 
 drivers/gpu/drm/msm/msm_drv.h                       |    5 -
 drivers/gpu/drm/panel/Kconfig                       |    1 
 drivers/iio/adc/ad7192.c                            |    1 
 drivers/iio/adc/ad7780.c                            |    2 
 drivers/iio/adc/ad7793.c                            |    2 
 drivers/iio/adc/aspeed_adc.c                        |    1 
 drivers/iio/adc/max1027.c                           |    3 
 drivers/iio/adc/mt6577_auxadc.c                     |    8 ++
 drivers/iio/adc/ti-adc128s052.c                     |    6 +
 drivers/iio/common/ssp_sensors/ssp_spi.c            |   11 ++
 drivers/iio/dac/ti-dac5571.c                        |    1 
 drivers/iio/light/opt3001.c                         |    6 -
 drivers/input/joystick/xpad.c                       |    2 
 drivers/misc/cb710/sgbuf2.c                         |    2 
 drivers/misc/fastrpc.c                              |    2 
 drivers/misc/mei/hw-me-regs.h                       |    1 
 drivers/misc/mei/pci-me.c                           |    1 
 drivers/net/dsa/microchip/ksz_common.c              |    4 -
 drivers/net/dsa/mv88e6xxx/chip.c                    |   13 ++-
 drivers/net/ethernet/Kconfig                        |    1 
 drivers/net/ethernet/arc/Kconfig                    |    1 
 drivers/net/ethernet/mellanox/mlx5/core/cq.c        |    7 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   |   57 +++++++++++++-
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c  |   52 +------------
 drivers/net/ethernet/microchip/encx24j600-regmap.c  |   10 ++
 drivers/net/ethernet/microchip/encx24j600.c         |    5 +
 drivers/net/ethernet/microchip/encx24j600_hw.h      |    4 -
 drivers/net/ethernet/mscc/ocelot.c                  |    6 -
 drivers/net/ethernet/neterion/s2io.c                |    2 
 drivers/net/ethernet/netronome/nfp/flower/main.c    |   19 +++-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c     |    4 +
 drivers/net/ethernet/qlogic/qed/qed_main.c          |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c |   13 ++-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c    |    6 +
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c  |    6 +
 drivers/net/ethernet/stmicro/stmmac/hwif.h          |    6 -
 drivers/net/usb/Kconfig                             |    4 +
 drivers/nvme/host/pci.c                             |    2 
 drivers/nvmem/core.c                                |    3 
 drivers/platform/mellanox/mlxreg-io.c               |    4 -
 drivers/platform/x86/intel_scu_ipc.c                |    2 
 drivers/spi/spi-bcm-qspi.c                          |   77 +++++++++++---------
 drivers/tee/optee/core.c                            |    3 
 drivers/tee/optee/device.c                          |   22 +++++
 drivers/tee/optee/optee_private.h                   |    1 
 drivers/usb/host/xhci-dbgtty.c                      |   28 +++----
 drivers/usb/host/xhci-pci.c                         |    2 
 drivers/usb/host/xhci-ring.c                        |   14 ++-
 drivers/usb/host/xhci.c                             |    5 +
 drivers/usb/musb/musb_dsps.c                        |    4 -
 drivers/usb/serial/option.c                         |    8 ++
 drivers/usb/serial/qcserial.c                       |    1 
 drivers/vhost/vdpa.c                                |    2 
 drivers/virtio/virtio.c                             |   11 ++
 fs/btrfs/extent-tree.c                              |    1 
 fs/btrfs/file.c                                     |   19 ++--
 fs/btrfs/tree-log.c                                 |   32 +++++---
 include/linux/mlx5/mlx5_ifc.h                       |   10 ++
 net/nfc/af_nfc.c                                    |    3 
 net/nfc/digital_core.c                              |    9 +-
 net/nfc/digital_technology.c                        |    8 +-
 net/sched/sch_mqprio.c                              |   30 ++++---
 net/sctp/sm_make_chunk.c                            |    2 
 scripts/recordmcount.pl                             |    2 
 sound/core/pcm_compat.c                             |   72 ++++++++++++++++++
 sound/core/seq_device.c                             |    8 --
 sound/pci/hda/patch_realtek.c                       |   66 ++++++++++++++++-
 sound/usb/quirks-table.h                            |   42 ++++++++++
 96 files changed, 704 insertions(+), 260 deletions(-)

Al Viro (1):
      csky: don't let sigreturn play with priveleged bits of status register

Aleksander Morgado (1):
      USB: serial: qcserial: add EM9191 QDL support

Alexandru Tachici (3):
      iio: adc: ad7192: Add IRQ flag
      iio: adc: ad7780: Fix IRQ flag
      iio: adc: ad7793: Fix IRQ flag

Andy Shevchenko (2):
      mei: me: add Ice Lake-N device id.
      gpio: pca953x: Improve bias setting

Ard Biesheuvel (1):
      efi/cper: use stack buffer for error record decoding

Arnd Bergmann (2):
      cb710: avoid NULL pointer subtraction
      ethernet: s2io: fix setting mac address during resume

Arun Ramadoss (1):
      net: dsa: microchip: Added the condition for scheduling ksz_mib_read_work

Aya Levin (1):
      net/mlx5e: Mutually exclude RX-FCS and RX-port-timestamp

Baowen Zheng (1):
      nfp: flow_offload: move flow_indr_dev_register from app init to app start

Billy Tsai (1):
      iio: adc: aspeed: set driver data when adc probe.

Borislav Petkov (1):
      x86/Kconfig: Do not enable AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT automatically

Cameron Berkenpas (1):
      ALSA: hda/realtek: Fix for quirk to enable speaker output on the Lenovo 13s Gen2

Chris Chiu (1):
      ALSA: hda - Enable headphone mic on Dell Latitude laptops with ALC3254

Christophe JAILLET (1):
      iio: adc128s052: Fix the error handling path of 'adc128_probe()'

Cindy Lu (1):
      vhost-vdpa: Fix the wrong input in config_cb

Colin Ian King (1):
      drm/msm: Fix null pointer dereference on pointer edp

Cédric Le Goater (1):
      powerpc/xive: Discard disabled interrupts in get_irqchip_state()

Dan Carpenter (6):
      iio: ssp_sensors: add more range checking in ssp_parse_dataframe()
      iio: ssp_sensors: fix error code in ssp_print_mcu_debug()
      iio: dac: ti-dac5571: fix an error code in probe()
      pata_legacy: fix a couple uninitialized variable bugs
      drm/msm/dsi: Fix an error code in msm_dsi_modeset_init()
      drm/msm/dsi: fix off by one in dsi_bus_clk_enable error handling

Daniele Palmas (1):
      USB: serial: option: add Telit LE910Cx composition 0x1204

Dinh Nguyen (1):
      clk: socfpga: agilex: fix duplicate s2f_user0_clk

Dmitry Baryshkov (1):
      drm/msm/mdp5: fix cursor-related warnings

Douglas Anderson (1):
      drm/edid: In connector_bad_edid() cap num_of_ext by num_blocks read

Eiichi Tsukata (1):
      sctp: account stream padding length for reconf chunk

Filipe Manana (3):
      btrfs: deal with errors when replaying dir entry during log replay
      btrfs: deal with errors when adding inode reference during log replay
      btrfs: check for error when looking up inode during dir entry replay

Greg Kroah-Hartman (1):
      Linux 5.10.75

Guo Ren (1):
      csky: Fixup regs.sr broken in ptrace

Halil Pasic (1):
      virtio: write back F_VERSION_1 before validate

Hans Potsch (1):
      EDAC/armada-xp: Fix output of uncorrectable error counter

Herve Codina (1):
      net: stmmac: fix get_hw_feature() on old hardware

Hui Liu (1):
      iio: mtk-auxadc: fix case IIO_CHAN_INFO_PROCESSED

Hui Wang (1):
      ALSA: hda/realtek: Fix the mic type detection issue for ASUS G551JW

Ido Schimmel (1):
      mlxsw: thermal: Fix out-of-bounds memory accesses

Jackie Liu (1):
      acpi/arm64: fix next_platform_timer() section mismatch error

James Morse (1):
      x86/resctrl: Free the ctrlval arrays when domain_setup_mon_state() fails

Jiri Valek - 2N (1):
      iio: light: opt3001: Fixed timeout error when 0 lux

Johan Hovold (1):
      USB: xhci: dbc: fix tty registration race

John Liu (1):
      ALSA: hda/realtek: Enable 4-speaker output for Dell Precision 5560 laptop

Jonas Hahnfeld (1):
      ALSA: usb-audio: Add quirk for VF0770

Jonathan Bell (1):
      xhci: guard accesses to ep_state in xhci_endpoint_reset()

Josef Bacik (2):
      btrfs: update refs for any root except tree log roots
      btrfs: fix abort logic in btrfs_replace_file_extents

Kailang Yang (1):
      ALSA: hda/realtek - ALC236 headset MIC recording issue

Kamal Dasu (1):
      spi: bcm-qspi: clear MSPI spifie interrupt during probe

Keith Busch (1):
      nvme-pci: Fix abort command id

Maarten Zanders (1):
      net: dsa: mv88e6xxx: don't use PHY_DETECT on internal PHY's

Marek Vasut (1):
      drm/msm: Avoid potential overflow in timeout_to_jiffies()

Michael Cullen (1):
      Input: xpad - add support for another USB ID of Nacon GC-100

Mike Kravetz (1):
      arm64/hugetlb: fix CMA gigantic page order for non-4K PAGE_SIZE

Miquel Raynal (3):
      usb: musb: dsps: Fix the probe error path
      iio: adc: max1027: Fix wrong shift with 12-bit devices
      iio: adc: max1027: Fix the number of max1X31 channels

Nanyong Sun (1):
      net: encx24j600: check error in devm_regmap_init_encx24j600

Nicolas Saenz Julienne (2):
      ARM: dts: bcm2711-rpi-4-b: Fix usb's unit address
      ARM: dts: bcm2711-rpi-4-b: Fix pcie0's unit address formatting

Nikolay Martynov (1):
      xhci: Enable trust tx length quirk for Fresco FL11 USB controller

Pavankumar Kondeti (1):
      xhci: Fix command ring pointer corruption while aborting a command

Prashant Malani (1):
      platform/x86: intel_scu_ipc: Fix busy loop expiry time

Qu Wenruo (1):
      btrfs: unlock newly allocated extent buffer after error

Rob Clark (1):
      drm/msm/a6xx: Track current ctx by seqno

Roberto Sassu (1):
      s390: fix strrchr() implementation

Saravana Kannan (2):
      drivers: bus: simple-pm-bus: Add support for probing simple bus only devices
      driver core: Reject pointless SYNC_STATE_ONLY device links

Sebastian Andrzej Siewior (1):
      mqprio: Correct stats in mqprio_dump_class_stats().

Shannon Nelson (1):
      ionic: don't remove netdev->dev_addr when syncing uc list

Srinivas Kandagatla (1):
      misc: fastrpc: Add missing lock before accessing find_vma()

Stefan Wahren (2):
      ARM: dts: bcm2711: fix MDIO #address- and #size-cells
      ARM: dts: bcm2711-rpi-4-b: fix sd_io_1v8_reg regulator states

Stephen Boyd (1):
      nvmem: Fix shift-out-of-bound (UBSAN) with byte size cells

Steven Rostedt (1):
      nds32/ftrace: Fix Error: invalid operands (*UND* and *UND* sections) for `^'

Sumit Garg (1):
      tee: optee: Fix missing devices unregister during optee_remove

Takashi Iwai (2):
      ALSA: pcm: Workaround for a wrong offset in SYNC_PTR compat ioctl
      ALSA: seq: Fix a potential UAF by wrong private_free call order

Tomaz Solc (1):
      USB: serial: option: add prod. id for Quectel EG91

Vadim Pasternak (2):
      platform/mellanox: mlxreg-io: Fix argument base in kstrtou32() call
      platform/mellanox: mlxreg-io: Fix read access of n-bytes size attributes

Valentine Fatiev (1):
      net/mlx5e: Fix memory leak in mlx5_core_destroy_cq() error path

Vegard Nossum (4):
      net: arc: select CRC32
      net: korina: select CRC32
      drm/panel: olimex-lcd-olinuxino: select CRC32
      r8152: select CRC32 and CRYPTO/CRYPTO_HASH/CRYPTO_SHA256

Vladimir Oltean (1):
      net: mscc: ocelot: warn when a PTP IRQ is raised for an unknown skb

Wang Hai (1):
      ata: ahci_platform: fix null-ptr-deref in ahci_platform_enable_regulators()

Werner Sembach (3):
      ALSA: hda/realtek: Complete partial device name to avoid ambiguity
      ALSA: hda/realtek: Add quirk for Clevo X170KM-G
      ALSA: hda/realtek: Add quirk for TongFang PHxTxX1

Yu-Tung Chang (1):
      USB: serial: option: add Quectel EC200S-CN module support

Zhang Jianhua (1):
      efi: Change down_interruptible() in virt_efi_reset_system() to down_trylock()

Ziyang Xuan (3):
      nfc: fix error handling of nfc_proto_register()
      NFC: digital: fix possible memory leak in digital_tg_listen_mdaa()
      NFC: digital: fix possible memory leak in digital_in_send_sdd_req()

chongjiapeng (1):
      qed: Fix missing error code in qed_slowpath_start()

