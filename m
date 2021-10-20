Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6898F434928
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 12:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbhJTKqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 06:46:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:51296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230170AbhJTKqC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 06:46:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F39CD6136A;
        Wed, 20 Oct 2021 10:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634726628;
        bh=bPEmbj2ZP7DZKqE/uWiYb8x0GPjCHgAGnBe4QoAlO3g=;
        h=From:To:Cc:Subject:Date:From;
        b=MSJcvvN8q7A26vz8wAEF2k7c2Go35mIFFLc3bgrfbo8yO2SfgWnAzQex2N80ho9Ww
         a8prDI1UR372G5f7l8dt08nMDA1zgMzeu6U3IfFqawWfOATkjUJeZYAvbQuWbL65r2
         UnRMI5rnn3Ugu0dAgMvqKLwIQ1FMFYf3vH1utmI0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.14.14
Date:   Wed, 20 Oct 2021 12:43:42 +0200
Message-Id: <16347266229392@kroah.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.14.14 kernel.

All users of the 5.14 kernel series must upgrade.

The updated 5.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                            |    2 
 arch/arm/boot/dts/bcm2711-rpi-4-b.dts               |   11 +-
 arch/arm/boot/dts/bcm2711.dtsi                      |   12 ++
 arch/arm/boot/dts/bcm2835-common.dtsi               |    8 +
 arch/arm/boot/dts/bcm283x.dtsi                      |    8 -
 arch/arm64/mm/hugetlbpage.c                         |    2 
 arch/csky/kernel/ptrace.c                           |    3 
 arch/csky/kernel/signal.c                           |    4 
 arch/powerpc/sysdev/xive/common.c                   |    3 
 arch/s390/lib/string.c                              |   15 +--
 arch/x86/Kconfig                                    |    1 
 arch/x86/kernel/cpu/resctrl/core.c                  |    2 
 arch/x86/kernel/fpu/signal.c                        |    2 
 drivers/acpi/arm64/gtdt.c                           |    2 
 drivers/acpi/x86/s2idle.c                           |    3 
 drivers/ata/libahci_platform.c                      |    5 -
 drivers/ata/pata_legacy.c                           |    6 -
 drivers/base/core.c                                 |    3 
 drivers/block/rnbd/rnbd-clt-sysfs.c                 |    4 
 drivers/block/virtio_blk.c                          |   41 +--------
 drivers/bus/simple-pm-bus.c                         |   42 ++++++++-
 drivers/clk/renesas/renesas-rzg2l-cpg.c             |    2 
 drivers/clk/socfpga/clk-agilex.c                    |    9 --
 drivers/edac/armada_xp_edac.c                       |    2 
 drivers/firmware/arm_ffa/bus.c                      |   12 ++
 drivers/firmware/efi/cper.c                         |    4 
 drivers/firmware/efi/runtime-wrappers.c             |    2 
 drivers/fpga/ice40-spi.c                            |    7 +
 drivers/gpio/gpio-74x164.c                          |    8 +
 drivers/gpio/gpio-pca953x.c                         |   16 ++-
 drivers/gpu/drm/drm_edid.c                          |   15 ++-
 drivers/gpu/drm/drm_fb_helper.c                     |    6 +
 drivers/gpu/drm/msm/adreno/a3xx_gpu.c               |    9 +-
 drivers/gpu/drm/msm/adreno/a4xx_gpu.c               |    9 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c               |    6 -
 drivers/gpu/drm/msm/adreno/a6xx_gpu.h               |   11 ++
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c           |   16 +++
 drivers/gpu/drm/msm/dsi/dsi.c                       |    4 
 drivers/gpu/drm/msm/dsi/dsi_host.c                  |    2 
 drivers/gpu/drm/msm/dsi/phy/dsi_phy_14nm.c          |   30 +++---
 drivers/gpu/drm/msm/edp/edp_ctrl.c                  |    3 
 drivers/gpu/drm/msm/msm_drv.c                       |   12 +-
 drivers/gpu/drm/msm/msm_drv.h                       |    5 -
 drivers/gpu/drm/msm/msm_gem_submit.c                |    3 
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/chang84.c  |    2 
 drivers/gpu/drm/panel/Kconfig                       |    1 
 drivers/iio/accel/fxls8962af-core.c                 |    2 
 drivers/iio/adc/ad7192.c                            |    1 
 drivers/iio/adc/ad7780.c                            |    2 
 drivers/iio/adc/ad7793.c                            |    2 
 drivers/iio/adc/aspeed_adc.c                        |    1 
 drivers/iio/adc/max1027.c                           |    3 
 drivers/iio/adc/mt6577_auxadc.c                     |    8 +
 drivers/iio/adc/ti-adc128s052.c                     |    6 +
 drivers/iio/common/ssp_sensors/ssp_spi.c            |   11 ++
 drivers/iio/dac/ti-dac5571.c                        |    1 
 drivers/iio/imu/adis16475.c                         |    3 
 drivers/iio/imu/adis16480.c                         |   14 ++-
 drivers/iio/light/opt3001.c                         |    6 -
 drivers/input/joystick/xpad.c                       |    2 
 drivers/input/touchscreen/resistive-adc-touch.c     |   29 +++---
 drivers/md/dm-rq.c                                  |    8 +
 drivers/md/dm.c                                     |   17 ++-
 drivers/misc/cb710/sgbuf2.c                         |    2 
 drivers/misc/eeprom/at25.c                          |    8 +
 drivers/misc/eeprom/eeprom_93xx46.c                 |   18 ++++
 drivers/misc/fastrpc.c                              |    2 
 drivers/misc/mei/hbm.c                              |   12 +-
 drivers/misc/mei/hw-me-regs.h                       |    1 
 drivers/misc/mei/pci-me.c                           |    1 
 drivers/mtd/nand/raw/qcom_nandc.c                   |    8 +
 drivers/net/dsa/microchip/ksz_common.c              |    4 
 drivers/net/dsa/mv88e6xxx/chip.c                    |   13 ++
 drivers/net/dsa/ocelot/felix.c                      |   25 +++--
 drivers/net/ethernet/Kconfig                        |    1 
 drivers/net/ethernet/arc/Kconfig                    |    1 
 drivers/net/ethernet/intel/ice/ice_ptp.c            |   15 +--
 drivers/net/ethernet/mellanox/mlx5/core/cq.c        |    7 -
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   |   57 +++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c    |    1 
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c  |   52 +----------
 drivers/net/ethernet/microchip/encx24j600-regmap.c  |   10 +-
 drivers/net/ethernet/microchip/encx24j600.c         |    5 -
 drivers/net/ethernet/microchip/encx24j600_hw.h      |    4 
 drivers/net/ethernet/mscc/ocelot.c                  |   90 +++++++++++++++-----
 drivers/net/ethernet/neterion/s2io.c                |    2 
 drivers/net/ethernet/netronome/nfp/flower/main.c    |   19 +++-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c     |    4 
 drivers/net/ethernet/qlogic/qed/qed_main.c          |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c |   13 ++
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c    |    6 -
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c  |    6 -
 drivers/net/ethernet/stmicro/stmmac/hwif.h          |    6 -
 drivers/net/phy/phy_device.c                        |    3 
 drivers/net/usb/Kconfig                             |    4 
 drivers/nvme/host/pci.c                             |    2 
 drivers/nvmem/core.c                                |    3 
 drivers/platform/mellanox/mlxreg-io.c               |    4 
 drivers/platform/x86/amd-pmc.c                      |    1 
 drivers/platform/x86/gigabyte-wmi.c                 |    1 
 drivers/platform/x86/intel_scu_ipc.c                |    2 
 drivers/spi/spi-atmel.c                             |    4 
 drivers/spi/spi-bcm-qspi.c                          |   77 ++++++++++-------
 drivers/spi/spidev.c                                |   14 +++
 drivers/tee/optee/core.c                            |    3 
 drivers/tee/optee/device.c                          |   22 ++++
 drivers/tee/optee/optee_private.h                   |    1 
 drivers/usb/host/xhci-dbgtty.c                      |   28 ++----
 drivers/usb/host/xhci-pci.c                         |    6 +
 drivers/usb/host/xhci-ring.c                        |   39 +++++++-
 drivers/usb/host/xhci.c                             |    5 +
 drivers/usb/host/xhci.h                             |    1 
 drivers/usb/musb/musb_dsps.c                        |    4 
 drivers/usb/serial/option.c                         |    8 +
 drivers/usb/serial/qcserial.c                       |    1 
 drivers/vhost/vdpa.c                                |    2 
 drivers/virtio/virtio.c                             |   11 ++
 fs/btrfs/extent-tree.c                              |    1 
 fs/btrfs/file.c                                     |   19 ++--
 fs/btrfs/tree-log.c                                 |   32 ++++---
 include/linux/mlx5/mlx5_ifc.h                       |   10 +-
 include/soc/mscc/ocelot.h                           |    6 +
 include/soc/mscc/ocelot_ptp.h                       |    3 
 kernel/module.c                                     |    2 
 kernel/trace/trace.c                                |   11 --
 net/dsa/switch.c                                    |    2 
 net/mptcp/protocol.c                                |   55 +++---------
 net/nfc/af_nfc.c                                    |    3 
 net/nfc/digital_core.c                              |    9 +-
 net/nfc/digital_technology.c                        |    8 +
 net/sched/sch_mqprio.c                              |   30 ++++--
 net/sctp/sm_make_chunk.c                            |    2 
 net/smc/smc_cdc.c                                   |    7 +
 net/smc/smc_core.c                                  |   20 ++--
 net/smc/smc_llc.c                                   |   63 ++++++++++----
 net/smc/smc_tx.c                                    |   22 +---
 net/smc/smc_wr.h                                    |   14 +++
 scripts/recordmcount.pl                             |    2 
 sound/core/pcm_compat.c                             |   72 +++++++++++++++-
 sound/core/seq_device.c                             |    8 -
 sound/pci/hda/patch_realtek.c                       |   66 +++++++++++++-
 sound/usb/mixer_scarlett_gen2.c                     |    2 
 sound/usb/quirks-table.h                            |   42 +++++++++
 143 files changed, 1146 insertions(+), 496 deletions(-)

Al Viro (1):
      csky: don't let sigreturn play with priveleged bits of status register

Aleksander Morgado (1):
      USB: serial: qcserial: add EM9191 QDL support

Alexander Usyskin (1):
      mei: hbm: drop hbm responses on early shutdown

Alexandru Tachici (3):
      iio: adc: ad7192: Add IRQ flag
      iio: adc: ad7780: Fix IRQ flag
      iio: adc: ad7793: Fix IRQ flag

Alvin Šipraga (1):
      net: dsa: fix spurious error message when unoffloaded port leaves bridge

Andy Shevchenko (2):
      mei: me: add Ice Lake-N device id.
      gpio: pca953x: Improve bias setting

Ard Biesheuvel (1):
      efi/cper: use stack buffer for error record decoding

Arnd Bergmann (5):
      module: fix clang CFI with MODULE_UNLOAD=n
      cb710: avoid NULL pointer subtraction
      eeprom: 93xx46: fix MODULE_DEVICE_TABLE
      ethernet: s2io: fix setting mac address during resume
      drm/msm/submit: fix overflow check on 64-bit architectures

Arun Ramadoss (1):
      net: dsa: microchip: Added the condition for scheduling ksz_mib_read_work

Aya Levin (1):
      net/mlx5e: Mutually exclude RX-FCS and RX-port-timestamp

Baowen Zheng (1):
      nfp: flow_offload: move flow_indr_dev_register from app init to app start

Biju Das (1):
      clk: renesas: rzg2l: Fix clk status function

Billy Tsai (1):
      iio: adc: aspeed: set driver data when adc probe.

Borislav Petkov (2):
      x86/fpu: Mask out the invalid MXCSR bits properly
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

Dan Carpenter (9):
      iio: ssp_sensors: add more range checking in ssp_parse_dataframe()
      iio: ssp_sensors: fix error code in ssp_print_mcu_debug()
      iio: dac: ti-dac5571: fix an error code in probe()
      pata_legacy: fix a couple uninitialized variable bugs
      drm/msm/a4xx: fix error handling in a4xx_gpu_init()
      drm/msm/a3xx: fix error handling in a3xx_gpu_init()
      drm/msm/dsi: Fix an error code in msm_dsi_modeset_init()
      drm/msm/dsi: fix off by one in dsi_bus_clk_enable error handling
      block/rnbd-clt-sysfs: fix a couple uninitialized variable bugs

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

Fabio Estevam (1):
      drm/msm: Do not run snapshot on non-DPU devices

Filipe Manana (3):
      btrfs: deal with errors when replaying dir entry during log replay
      btrfs: deal with errors when adding inode reference during log replay
      btrfs: check for error when looking up inode during dir entry replay

Florian Fainelli (1):
      net: phy: Do not shutdown PHYs in READY state

Greg Kroah-Hartman (1):
      Linux 5.14.14

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

Jackie Liu (2):
      tracing: Fix missing osnoise tracer on max_latency
      acpi/arm64: fix next_platform_timer() section mismatch error

Jacob Keller (1):
      ice: fix locking for Tx timestamp tracking flush

James Morse (1):
      x86/resctrl: Free the ctrlval arrays when domain_setup_mon_state() fails

Jiazi Li (1):
      dm: fix mempool NULL pointer race when completing IO

Jiri Valek - 2N (1):
      iio: light: opt3001: Fixed timeout error when 0 lux

Johan Hovold (1):
      USB: xhci: dbc: fix tty registration race

John Liu (1):
      ALSA: hda/realtek: Enable 4-speaker output for Dell Precision 5560 laptop

Jonas Hahnfeld (1):
      ALSA: usb-audio: Add quirk for VF0770

Jonathan Bell (2):
      xhci: guard accesses to ep_state in xhci_endpoint_reset()
      xhci: add quirk for host controllers that don't update endpoint DCS

Josef Bacik (2):
      btrfs: update refs for any root except tree log roots
      btrfs: fix abort logic in btrfs_replace_file_extents

Kailang Yang (1):
      ALSA: hda/realtek - ALC236 headset MIC recording issue

Kamal Dasu (1):
      spi: bcm-qspi: clear MSPI spifie interrupt during probe

Karsten Graul (1):
      net/smc: improved fix wait on already cleared link

Keith Busch (1):
      nvme-pci: Fix abort command id

Maarten Zanders (1):
      net: dsa: mv88e6xxx: don't use PHY_DETECT on internal PHY's

Marek Vasut (2):
      drm/nouveau/fifo: Reinstate the correct engine bit programming
      drm/msm: Avoid potential overflow in timeout_to_jiffies()

Marijn Suijten (1):
      drm/msm/dsi: dsi_phy_14nm: Take ready-bit into account in poll_for_ready

Mark Brown (5):
      eeprom: 93xx46: Add SPI device ID table
      eeprom: at25: Add SPI ID table
      fpga: ice40-spi: Add SPI device ID table
      gpio: 74x164: Add SPI device ID table
      spi: spidev: Add SPI ID table

Mateusz Kwiatkowski (1):
      ARM: dts: bcm283x: Fix VEC address for BCM2711

Max Gurtovoy (1):
      virtio-blk: remove unneeded "likely" statements

Md Sadre Alam (1):
      mtd: rawnand: qcom: Update code word value for raw read

Michael Cullen (1):
      Input: xpad - add support for another USB ID of Nacon GC-100

Michael S. Tsirkin (1):
      Revert "virtio-blk: Add validation for block size in config space"

Mike Kravetz (1):
      arm64/hugetlb: fix CMA gigantic page order for non-4K PAGE_SIZE

Ming Lei (1):
      dm rq: don't queue request to blk-mq during DM suspend

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

Nuno Sá (2):
      iio: adis16480: fix devices that do not support sleep mode
      iio: adis16475: fix deadlock on frequency set

Oleksij Rempel (1):
      Input: resistive-adc-touch - fix division by zero error on z1 == 0

Paolo Abeni (1):
      mptcp: fix possible stall on recvmsg()

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

Sachi King (2):
      platform/x86: amd-pmc: Add alternative acpi id for PMC controller
      ACPI: PM: Include alternate AMDI0005 id in special behaviour

Saeed Mahameed (1):
      net/mlx5e: Switchdev representors are not vlan challenged

Saravana Kannan (2):
      drivers: bus: simple-pm-bus: Add support for probing simple bus only devices
      driver core: Reject pointless SYNC_STATE_ONLY device links

Sean Nyekjaer (1):
      iio: accel: fxls8962af: return IRQ_HANDLED when fifo is flushed

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

Sudeep Holla (2):
      firmware: arm_ffa: Fix __ffa_devices_unregister
      firmware: arm_ffa: Add missing remove callback to ffa_bus_type

Sumit Garg (1):
      tee: optee: Fix missing devices unregister during optee_remove

Takashi Iwai (3):
      ALSA: pcm: Workaround for a wrong offset in SYNC_PTR compat ioctl
      ALSA: usb-audio: Fix a missing error check in scarlett gen2 mixer
      ALSA: seq: Fix a potential UAF by wrong private_free call order

Thomas Zimmermann (1):
      drm/fbdev: Clamp fbdev surface size if too large

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

Ville Baillie (1):
      spi: atmel: Fix PDC transfer setup bug

Vladimir Oltean (6):
      net: mscc: ocelot: make use of all 63 PTP timestamp identifiers
      net: mscc: ocelot: avoid overflowing the PTP timestamp FIFO
      net: mscc: ocelot: warn when a PTP IRQ is raised for an unknown skb
      net: mscc: ocelot: deny TX timestamping of non-PTP packets
      net: mscc: ocelot: cross-check the sequence id from the timestamp FIFO with the skb PTP header
      net: dsa: felix: break at first CPU port during init and teardown

Wang Hai (1):
      ata: ahci_platform: fix null-ptr-deref in ahci_platform_enable_regulators()

Werner Sembach (3):
      ALSA: hda/realtek: Complete partial device name to avoid ambiguity
      ALSA: hda/realtek: Add quirk for Clevo X170KM-G
      ALSA: hda/realtek: Add quirk for TongFang PHxTxX1

Yu-Tung Chang (1):
      USB: serial: option: add Quectel EC200S-CN module support

Zephaniah E. Loss-Cutler-Hull (1):
      platform/x86: gigabyte-wmi: add support for B550 AORUS ELITE AX V2

Zhang Jianhua (1):
      efi: Change down_interruptible() in virt_efi_reset_system() to down_trylock()

Ziyang Xuan (3):
      nfc: fix error handling of nfc_proto_register()
      NFC: digital: fix possible memory leak in digital_tg_listen_mdaa()
      NFC: digital: fix possible memory leak in digital_in_send_sdd_req()

chongjiapeng (1):
      qed: Fix missing error code in qed_slowpath_start()

