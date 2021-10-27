Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18FBB43C47E
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 09:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240701AbhJ0IA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 04:00:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240686AbhJ0IA0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Oct 2021 04:00:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A263D60E76;
        Wed, 27 Oct 2021 07:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635321481;
        bh=gCrt7dNZtPBbBUWD4Sa6VLNrqxzQ1mXDmllU6kEdSW4=;
        h=From:To:Cc:Subject:Date:From;
        b=o/yhIHMB5XFAO4a1UkzW60M6y2+A8a1ejmu4vCeFl0e4Lmt82CX6CHDO64vqbX9ib
         derIG6IDlJW7ZlqB47aN0ai/h6Y18tOZPWSjm8lB5DEAaeImbpElLJLjsBh19gxQd8
         Fbf2i35hePmG9AIjXTqXnNI1UJiXYQqj+OXSrPBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.290
Date:   Wed, 27 Oct 2021 09:57:57 +0200
Message-Id: <163532147810065@kroah.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.290 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
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
 drivers/ata/pata_legacy.c                          |    6 +
 drivers/firmware/efi/cper.c                        |    4 -
 drivers/gpu/drm/msm/edp/edp_ctrl.c                 |    3 
 drivers/iio/adc/ti-adc128s052.c                    |    6 +
 drivers/iio/common/ssp_sensors/ssp_spi.c           |   11 ++-
 drivers/input/joystick/xpad.c                      |    2 
 drivers/isdn/capi/kcapi.c                          |    5 +
 drivers/isdn/hardware/mISDN/netjet.c               |    2 
 drivers/misc/cb710/sgbuf2.c                        |    2 
 drivers/net/can/rcar_can.c                         |   20 +++---
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
 fs/nfsd/nfsctl.c                                   |    5 +
 fs/ocfs2/super.c                                   |   14 +++-
 fs/overlayfs/dir.c                                 |   10 ++-
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
 48 files changed, 208 insertions(+), 119 deletions(-)

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

Dan Carpenter (3):
      iio: ssp_sensors: add more range checking in ssp_parse_dataframe()
      iio: ssp_sensors: fix error code in ssp_print_mcu_debug()
      pata_legacy: fix a couple uninitialized variable bugs

Daniele Palmas (1):
      USB: serial: option: add Telit LE910Cx composition 0x1204

Greg Kroah-Hartman (1):
      Linux 4.4.290

Herve Codina (1):
      ARM: dts: spear3xx: Fix gmac node

Kai Vehmanen (1):
      ALSA: hda: avoid write to STATESTS if controller is in reset

Lin Ma (1):
      nfc: nci: fix the UAF of rf_conn_info object

Lukas Bulwahn (1):
      elfcore: correct reference to CONFIG_UML

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

Zheng Liang (1):
      ovl: fix missing negative dentry check in ovl_rename()

Zheyu Ma (2):
      can: peak_pci: peak_pci_remove(): fix UAF
      isdn: mISDN: Fix sleeping function called from invalid context

Ziyang Xuan (3):
      nfc: fix error handling of nfc_proto_register()
      NFC: digital: fix possible memory leak in digital_tg_listen_mdaa()
      NFC: digital: fix possible memory leak in digital_in_send_sdd_req()

