Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC5E434920
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 12:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhJTKpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 06:45:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229702AbhJTKpt (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 06:45:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CCB3611B0;
        Wed, 20 Oct 2021 10:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634726615;
        bh=TUmzTG6PCKHjBNqoIfFKXUOViipgeY3ZCTTyidPCCXM=;
        h=From:To:Cc:Subject:Date:From;
        b=b5RfsNQCvhd30JtBjFft2hPbcweGGN2A85LSr5Prxmz1FlCJX0O/ZdARwLvlbmHHA
         UwEMPC/+jm3gLZ8tH2+j9ydVWSXN31YRB3WEKakZIRVPG6WdRlGV4HOFfEr3StnMPz
         KKFeE8F73u7IQfBf32RJd6AlSgE8HGdeZdijs3J4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.155
Date:   Wed, 20 Oct 2021 12:43:31 +0200
Message-Id: <1634726611132236@kroah.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.155 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                            |    2 
 arch/csky/kernel/ptrace.c                           |    3 -
 arch/csky/kernel/signal.c                           |    4 +
 arch/powerpc/sysdev/xive/common.c                   |    3 -
 arch/s390/lib/string.c                              |   15 ++---
 arch/x86/Kconfig                                    |    1 
 arch/x86/kernel/cpu/resctrl/core.c                  |    2 
 drivers/acpi/arm64/gtdt.c                           |    2 
 drivers/ata/libahci_platform.c                      |    5 -
 drivers/ata/pata_legacy.c                           |    6 +-
 drivers/edac/armada_xp_edac.c                       |    2 
 drivers/firmware/efi/cper.c                         |    4 -
 drivers/firmware/efi/runtime-wrappers.c             |    2 
 drivers/gpio/gpio-pca953x.c                         |   16 +++--
 drivers/gpu/drm/msm/dsi/dsi.c                       |    4 +
 drivers/gpu/drm/msm/dsi/dsi_host.c                  |    2 
 drivers/gpu/drm/msm/edp/edp_ctrl.c                  |    3 -
 drivers/gpu/drm/panel/Kconfig                       |    1 
 drivers/iio/adc/aspeed_adc.c                        |    1 
 drivers/iio/adc/mt6577_auxadc.c                     |    8 ++
 drivers/iio/adc/ti-adc128s052.c                     |    6 ++
 drivers/iio/common/ssp_sensors/ssp_spi.c            |   11 +++
 drivers/iio/dac/ti-dac5571.c                        |    1 
 drivers/iio/light/opt3001.c                         |    6 +-
 drivers/input/joystick/xpad.c                       |    2 
 drivers/misc/cb710/sgbuf2.c                         |    2 
 drivers/misc/mei/hw-me-regs.h                       |    1 
 drivers/misc/mei/pci-me.c                           |    1 
 drivers/net/ethernet/Kconfig                        |    1 
 drivers/net/ethernet/arc/Kconfig                    |    1 
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   |   57 ++++++++++++++++++--
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c  |   52 +-----------------
 drivers/net/ethernet/microchip/encx24j600-regmap.c  |   10 ++-
 drivers/net/ethernet/microchip/encx24j600.c         |    5 +
 drivers/net/ethernet/microchip/encx24j600_hw.h      |    4 -
 drivers/net/ethernet/neterion/s2io.c                |    2 
 drivers/net/ethernet/pensando/ionic/ionic_lif.c     |    4 +
 drivers/net/ethernet/qlogic/qed/qed_main.c          |    1 
 drivers/net/ethernet/stmicro/stmmac/dwmac1000_dma.c |   13 +++-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_dma.c    |    6 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2_dma.c  |    6 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h          |    6 +-
 drivers/net/usb/Kconfig                             |    4 +
 drivers/nvmem/core.c                                |    3 -
 drivers/platform/mellanox/mlxreg-io.c               |    2 
 drivers/usb/host/xhci-pci.c                         |    2 
 drivers/usb/host/xhci-ring.c                        |   14 +++-
 drivers/usb/host/xhci.c                             |    5 +
 drivers/usb/musb/musb_dsps.c                        |    4 +
 drivers/usb/serial/option.c                         |    8 ++
 drivers/usb/serial/qcserial.c                       |    1 
 drivers/virtio/virtio.c                             |   11 +++
 drivers/watchdog/orion_wdt.c                        |    2 
 fs/btrfs/extent-tree.c                              |    1 
 fs/btrfs/tree-log.c                                 |   32 +++++++----
 fs/overlayfs/file.c                                 |   46 ----------------
 include/linux/mlx5/mlx5_ifc.h                       |   10 ++-
 net/nfc/af_nfc.c                                    |    3 +
 net/nfc/digital_core.c                              |    9 ++-
 net/nfc/digital_technology.c                        |    8 ++
 net/sched/sch_mqprio.c                              |   30 ++++++----
 net/sctp/sm_make_chunk.c                            |    2 
 scripts/recordmcount.pl                             |    2 
 sound/core/seq_device.c                             |    8 +-
 sound/pci/hda/patch_realtek.c                       |   35 +++++++++++-
 sound/usb/quirks-table.h                            |   42 ++++++++++++++
 66 files changed, 373 insertions(+), 195 deletions(-)

Al Viro (1):
      csky: don't let sigreturn play with priveleged bits of status register

Aleksander Morgado (1):
      USB: serial: qcserial: add EM9191 QDL support

Andy Shevchenko (2):
      mei: me: add Ice Lake-N device id.
      gpio: pca953x: Improve bias setting

Ard Biesheuvel (1):
      efi/cper: use stack buffer for error record decoding

Arnd Bergmann (2):
      cb710: avoid NULL pointer subtraction
      ethernet: s2io: fix setting mac address during resume

Aya Levin (1):
      net/mlx5e: Mutually exclude RX-FCS and RX-port-timestamp

Billy Tsai (1):
      iio: adc: aspeed: set driver data when adc probe.

Borislav Petkov (1):
      x86/Kconfig: Do not enable AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT automatically

Chris Packham (1):
      watchdog: orion: use 0 for unset heartbeat

Christophe JAILLET (1):
      iio: adc128s052: Fix the error handling path of 'adc128_probe()'

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

Eiichi Tsukata (1):
      sctp: account stream padding length for reconf chunk

Filipe Manana (3):
      btrfs: deal with errors when replaying dir entry during log replay
      btrfs: deal with errors when adding inode reference during log replay
      btrfs: check for error when looking up inode during dir entry replay

Greg Kroah-Hartman (1):
      Linux 5.4.155

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

Jonas Hahnfeld (1):
      ALSA: usb-audio: Add quirk for VF0770

Jonathan Bell (1):
      xhci: guard accesses to ep_state in xhci_endpoint_reset()

Kailang Yang (1):
      ALSA: hda/realtek - ALC236 headset MIC recording issue

Michael Cullen (1):
      Input: xpad - add support for another USB ID of Nacon GC-100

Miklos Szeredi (1):
      ovl: simplify file splice

Miquel Raynal (1):
      usb: musb: dsps: Fix the probe error path

Nanyong Sun (1):
      net: encx24j600: check error in devm_regmap_init_encx24j600

Nikolay Martynov (1):
      xhci: Enable trust tx length quirk for Fresco FL11 USB controller

Pavankumar Kondeti (1):
      xhci: Fix command ring pointer corruption while aborting a command

Qu Wenruo (1):
      btrfs: unlock newly allocated extent buffer after error

Roberto Sassu (1):
      s390: fix strrchr() implementation

Sebastian Andrzej Siewior (1):
      mqprio: Correct stats in mqprio_dump_class_stats().

Shannon Nelson (1):
      ionic: don't remove netdev->dev_addr when syncing uc list

Stephen Boyd (1):
      nvmem: Fix shift-out-of-bound (UBSAN) with byte size cells

Steven Rostedt (1):
      nds32/ftrace: Fix Error: invalid operands (*UND* and *UND* sections) for `^'

Takashi Iwai (1):
      ALSA: seq: Fix a potential UAF by wrong private_free call order

Tomaz Solc (1):
      USB: serial: option: add prod. id for Quectel EG91

Vadim Pasternak (1):
      platform/mellanox: mlxreg-io: Fix argument base in kstrtou32() call

Vegard Nossum (4):
      net: arc: select CRC32
      net: korina: select CRC32
      drm/panel: olimex-lcd-olinuxino: select CRC32
      r8152: select CRC32 and CRYPTO/CRYPTO_HASH/CRYPTO_SHA256

Wang Hai (1):
      ata: ahci_platform: fix null-ptr-deref in ahci_platform_enable_regulators()

Werner Sembach (2):
      ALSA: hda/realtek: Complete partial device name to avoid ambiguity
      ALSA: hda/realtek: Add quirk for Clevo X170KM-G

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

