Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A07F43C482
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 09:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240715AbhJ0IAp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 04:00:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235890AbhJ0IAd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 04:00:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E79C960E76;
        Wed, 27 Oct 2021 07:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635321488;
        bh=K9VNM/+1CsqvEAGUFDT2El8I757lbLcqdFq+0gx01OQ=;
        h=From:To:Cc:Subject:Date:From;
        b=uiU9v2w0QsezxOfpvCFmhneQlLZBSmo436dO9dOXcgXOGtfW0uhHQIo031dBrTu/0
         l2WfrSLMhC+OdwDz8H3j83ZrPzns4Pu4kA355p/90w/yFJ6WRsiO+/ORWSbnmKitpi
         PWOY4hcp+UkGa7+GgWj+J7ndsiDf3BJZGiCKeD3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.9.288
Date:   Wed, 27 Oct 2021 09:58:02 +0200
Message-Id: <1635321483200255@kroah.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.9.288 kernel.

All users of the 4.9 kernel series must upgrade.

The updated 4.9.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.9.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    2 
 arch/arm/Kconfig                                   |    1 
 arch/arm/boot/dts/spear3xx.dtsi                    |    2 
 arch/nios2/include/asm/irqflags.h                  |    4 -
 arch/nios2/include/asm/registers.h                 |    2 
 arch/s390/lib/string.c                             |   15 ++--
 arch/xtensa/platforms/xtfpga/setup.c               |   12 ++-
 drivers/ata/pata_legacy.c                          |    6 +
 drivers/firmware/efi/cper.c                        |    4 -
 drivers/firmware/efi/runtime-wrappers.c            |    2 
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |    2 
 drivers/gpu/drm/msm/edp/edp_ctrl.c                 |    3 
 drivers/iio/adc/ti-adc128s052.c                    |    6 +
 drivers/iio/common/ssp_sensors/ssp_spi.c           |   11 ++-
 drivers/iio/light/opt3001.c                        |    6 -
 drivers/input/joystick/xpad.c                      |    2 
 drivers/isdn/capi/kcapi.c                          |    5 +
 drivers/isdn/hardware/mISDN/netjet.c               |    2 
 drivers/misc/cb710/sgbuf2.c                        |    2 
 drivers/net/can/rcar/rcar_can.c                    |   20 +++---
 drivers/net/can/sja1000/peak_pci.c                 |    9 +-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |    5 -
 drivers/net/ethernet/Kconfig                       |    1 
 drivers/net/ethernet/arc/Kconfig                   |    1 
 drivers/net/ethernet/microchip/encx24j600-regmap.c |   10 ++-
 drivers/net/ethernet/microchip/encx24j600.c        |    5 +
 drivers/net/ethernet/microchip/encx24j600_hw.h     |    4 -
 drivers/net/ethernet/neterion/s2io.c               |    2 
 drivers/net/phy/mdio_bus.c                         |    1 
 drivers/net/usb/Kconfig                            |    4 +
 drivers/nvmem/core.c                               |    3 
 drivers/platform/x86/intel_scu_ipc.c               |    2 
 drivers/usb/host/xhci-pci.c                        |    2 
 drivers/usb/serial/option.c                        |    2 
 drivers/usb/serial/qcserial.c                      |    1 
 fs/exec.c                                          |    2 
 fs/nfsd/nfsctl.c                                   |    5 +
 fs/ocfs2/alloc.c                                   |   46 +++------------
 fs/ocfs2/super.c                                   |   14 +++-
 include/linux/elfcore.h                            |    2 
 kernel/trace/ftrace.c                              |    4 -
 kernel/trace/trace.h                               |   64 ++++++---------------
 kernel/trace/trace_functions.c                     |    2 
 net/netfilter/Kconfig                              |    2 
 net/netfilter/ipvs/ip_vs_ctl.c                     |    5 +
 net/nfc/af_nfc.c                                   |    3 
 net/nfc/digital_core.c                             |    9 ++
 net/nfc/digital_technology.c                       |    8 +-
 net/nfc/nci/rsp.c                                  |    2 
 sound/core/seq/seq_device.c                        |    8 --
 sound/hda/hdac_controller.c                        |    5 -
 sound/soc/soc-dapm.c                               |   13 ++--
 sound/usb/quirks-table.h                           |   32 ++++++++++
 53 files changed, 227 insertions(+), 160 deletions(-)

Aleksander Morgado (1):
      USB: serial: qcserial: add EM9191 QDL support

Antoine Tenart (1):
      netfilter: ipvs: make global sysctl readonly in non-init netns

Ard Biesheuvel (1):
      efi/cper: use stack buffer for error record decoding

Arnd Bergmann (2):
      cb710: avoid NULL pointer subtraction
      ethernet: s2io: fix setting mac address during resume

Benjamin Coddington (1):
      NFSD: Keep existing listeners on portlist error

Brendan Grieve (1):
      ALSA: usb-audio: Provide quirk for Sennheiser GSP670 Headset

Christophe JAILLET (1):
      iio: adc128s052: Fix the error handling path of 'adc128_probe()'

Colin Ian King (1):
      drm/msm: Fix null pointer dereference on pointer edp

Dan Carpenter (4):
      iio: ssp_sensors: add more range checking in ssp_parse_dataframe()
      iio: ssp_sensors: fix error code in ssp_print_mcu_debug()
      pata_legacy: fix a couple uninitialized variable bugs
      drm/msm/dsi: fix off by one in dsi_bus_clk_enable error handling

Daniele Palmas (1):
      USB: serial: option: add Telit LE910Cx composition 0x1204

Greg Kroah-Hartman (1):
      Linux 4.9.288

Guenter Roeck (1):
      xtensa: xtfpga: Try software restart before simulating CPU reset

Herve Codina (1):
      ARM: dts: spear3xx: Fix gmac node

Jan Kara (1):
      ocfs2: fix data corruption after conversion from inline format

Jiri Valek - 2N (1):
      iio: light: opt3001: Fixed timeout error when 0 lux

Kai Vehmanen (1):
      ALSA: hda: avoid write to STATESTS if controller is in reset

Lin Ma (1):
      nfc: nci: fix the UAF of rf_conn_info object

Lukas Bulwahn (1):
      elfcore: correct reference to CONFIG_UML

Matthew Wilcox (Oracle) (1):
      vfs: check fd has read access in kernel_read_file_from_fd()

Max Filippov (1):
      xtensa: xtfpga: use CONFIG_USE_OF instead of CONFIG_OF

Michael Cullen (1):
      Input: xpad - add support for another USB ID of Nacon GC-100

Nanyong Sun (1):
      net: encx24j600: check error in devm_regmap_init_encx24j600

Nick Desaulniers (1):
      ARM: 9122/1: select HAVE_FUTEX_CMPXCHG

Nikolay Martynov (1):
      xhci: Enable trust tx length quirk for Fresco FL11 USB controller

Prashant Malani (1):
      platform/x86: intel_scu_ipc: Update timeout value in comment

Randy Dunlap (1):
      NIOS2: irqflags: rename a redefined register name

Roberto Sassu (1):
      s390: fix strrchr() implementation

Stephane Grosjean (1):
      can: peak_usb: pcan_usb_fd_decode_status(): fix back to ERROR_ACTIVE state notification

Stephen Boyd (1):
      nvmem: Fix shift-out-of-bound (UBSAN) with byte size cells

Steven Rostedt (VMware) (1):
      tracing: Have all levels of checks prevent recursion

Takashi Iwai (2):
      ALSA: seq: Fix a potential UAF by wrong private_free call order
      ASoC: DAPM: Fix missing kctl change notifications

Valentin Vidic (1):
      ocfs2: mount fails with buffer overflow in strlen

Vegard Nossum (4):
      net: arc: select CRC32
      net: korina: select CRC32
      r8152: select CRC32 and CRYPTO/CRYPTO_HASH/CRYPTO_SHA256
      netfilter: Kconfig: use 'default y' instead of 'm' for bool config option

Xiaolong Huang (1):
      isdn: cpai: check ctr->cnr to avoid array index out of bound

Yanfei Xu (1):
      net: mdiobus: Fix memory leak in __mdiobus_register

Yoshihiro Shimoda (1):
      can: rcar_can: fix suspend/resume

Zhang Jianhua (1):
      efi: Change down_interruptible() in virt_efi_reset_system() to down_trylock()

Zheyu Ma (2):
      can: peak_pci: peak_pci_remove(): fix UAF
      isdn: mISDN: Fix sleeping function called from invalid context

Ziyang Xuan (3):
      nfc: fix error handling of nfc_proto_register()
      NFC: digital: fix possible memory leak in digital_tg_listen_mdaa()
      NFC: digital: fix possible memory leak in digital_in_send_sdd_req()

