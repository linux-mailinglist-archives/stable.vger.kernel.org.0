Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A34F74347D3
	for <lists+stable@lfdr.de>; Wed, 20 Oct 2021 11:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbhJTJXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Oct 2021 05:23:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230052AbhJTJXe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Oct 2021 05:23:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 379B561074;
        Wed, 20 Oct 2021 09:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634721680;
        bh=INySm50pXBu/NBezJgMl27pOQGA4HMQuCYZj5jqaKC4=;
        h=From:To:Cc:Subject:Date:From;
        b=AjXbcFWcvn3S3zQD2r994NPrfJyepl8lcRGGczRHotuek8aYY3/4H3Ko5IxAfID5M
         Wb7j+aL/kOy8jN07h+NDRPg9MpPuk/CveyDRK/KAhx9K48eMYq4N7HDUnpMykB2pLZ
         sqAk2yLJZb0GVA9vszJOT4AImPHjQY3WtO1187mw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.252
Date:   Wed, 20 Oct 2021 11:21:17 +0200
Message-Id: <163472167652240@kroah.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.252 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                           |    4 +-
 arch/s390/lib/string.c                             |   15 ++++-----
 arch/x86/Kconfig                                   |    1 
 drivers/acpi/arm64/gtdt.c                          |    2 -
 drivers/ata/pata_legacy.c                          |    6 ++-
 drivers/firmware/efi/cper.c                        |    4 +-
 drivers/firmware/efi/runtime-wrappers.c            |    2 -
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |    2 -
 drivers/gpu/drm/msm/edp/edp_ctrl.c                 |    3 +
 drivers/iio/adc/aspeed_adc.c                       |    1 
 drivers/iio/adc/ti-adc128s052.c                    |    6 +++
 drivers/iio/common/ssp_sensors/ssp_spi.c           |   11 +++++--
 drivers/iio/light/opt3001.c                        |    6 +--
 drivers/input/joystick/xpad.c                      |    2 +
 drivers/misc/cb710/sgbuf2.c                        |    2 -
 drivers/net/ethernet/Kconfig                       |    1 
 drivers/net/ethernet/arc/Kconfig                   |    1 
 drivers/net/ethernet/microchip/encx24j600-regmap.c |   10 +++++-
 drivers/net/ethernet/microchip/encx24j600.c        |    5 ++-
 drivers/net/ethernet/microchip/encx24j600_hw.h     |    4 +-
 drivers/net/ethernet/neterion/s2io.c               |    2 -
 drivers/net/ethernet/qlogic/qed/qed_main.c         |    1 
 drivers/net/usb/Kconfig                            |    4 ++
 drivers/nvmem/core.c                               |    3 +
 drivers/usb/host/xhci-pci.c                        |    2 +
 drivers/usb/host/xhci-ring.c                       |   14 ++++++---
 drivers/usb/musb/musb_dsps.c                       |    4 +-
 drivers/usb/serial/option.c                        |    8 +++++
 drivers/usb/serial/qcserial.c                      |    1 
 drivers/virtio/virtio.c                            |   11 +++++++
 fs/btrfs/tree-log.c                                |   32 ++++++++++++++-------
 net/nfc/af_nfc.c                                   |    3 +
 net/nfc/digital_core.c                             |    9 ++++-
 net/nfc/digital_technology.c                       |    8 +++--
 net/sctp/sm_make_chunk.c                           |    2 -
 sound/core/seq_device.c                            |    8 +----
 36 files changed, 143 insertions(+), 57 deletions(-)

Aleksander Morgado (1):
      USB: serial: qcserial: add EM9191 QDL support

Ard Biesheuvel (1):
      efi/cper: use stack buffer for error record decoding

Arnd Bergmann (2):
      cb710: avoid NULL pointer subtraction
      ethernet: s2io: fix setting mac address during resume

Billy Tsai (1):
      iio: adc: aspeed: set driver data when adc probe.

Borislav Petkov (1):
      x86/Kconfig: Do not enable AMD_MEM_ENCRYPT_ACTIVE_BY_DEFAULT automatically

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

Eiichi Tsukata (1):
      sctp: account stream padding length for reconf chunk

Filipe Manana (3):
      btrfs: deal with errors when replaying dir entry during log replay
      btrfs: deal with errors when adding inode reference during log replay
      btrfs: check for error when looking up inode during dir entry replay

Greg Kroah-Hartman (1):
      Linux 4.14.252

Halil Pasic (1):
      virtio: write back F_VERSION_1 before validate

Jackie Liu (1):
      acpi/arm64: fix next_platform_timer() section mismatch error

Jiri Valek - 2N (1):
      iio: light: opt3001: Fixed timeout error when 0 lux

Michael Cullen (1):
      Input: xpad - add support for another USB ID of Nacon GC-100

Miquel Raynal (1):
      usb: musb: dsps: Fix the probe error path

Nanyong Sun (1):
      net: encx24j600: check error in devm_regmap_init_encx24j600

Nikolay Martynov (1):
      xhci: Enable trust tx length quirk for Fresco FL11 USB controller

Pavankumar Kondeti (1):
      xhci: Fix command ring pointer corruption while aborting a command

Roberto Sassu (1):
      s390: fix strrchr() implementation

Sasha Levin (1):
      stable: clamp SUBLEVEL in 4.14

Stephen Boyd (1):
      nvmem: Fix shift-out-of-bound (UBSAN) with byte size cells

Takashi Iwai (1):
      ALSA: seq: Fix a potential UAF by wrong private_free call order

Tomaz Solc (1):
      USB: serial: option: add prod. id for Quectel EG91

Vegard Nossum (3):
      net: arc: select CRC32
      net: korina: select CRC32
      r8152: select CRC32 and CRYPTO/CRYPTO_HASH/CRYPTO_SHA256

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

