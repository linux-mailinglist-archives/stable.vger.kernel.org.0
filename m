Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1979E3916A0
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 13:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234370AbhEZLww (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 07:52:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233370AbhEZLvL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 May 2021 07:51:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18CA76143E;
        Wed, 26 May 2021 11:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622029750;
        bh=1/sx8XaKYn69nrOPUDf+v8zwpcFdTBWBZVlxDtKuFFI=;
        h=From:To:Cc:Subject:Date:From;
        b=g4hX4OWzoCH29ayG8fiMzIKgJVpK8chKoL/lcJx+JYtAdw50AViWTUvczIAYbyxBZ
         KeRKX6hF8fKLX8mD6Ejxn7HJ5RwITwZ0xKQ/aVkPxZ49ITE44zFYfqMtdmjzbMuttS
         5a60C2xE+e4GQRYv9S+AB+B86xj1qyNp+H08pHRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.192
Date:   Wed, 26 May 2021 13:48:40 +0200
Message-Id: <1622029720223218@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.192 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                            |    2 
 arch/openrisc/kernel/setup.c                        |    2 
 drivers/cdrom/gdrom.c                               |   13 +++-
 drivers/firmware/arm_scpi.c                         |    4 +
 drivers/hwmon/lm80.c                                |   11 ---
 drivers/infiniband/hw/mlx5/main.c                   |    1 
 drivers/infiniband/sw/rxe/rxe_qp.c                  |    7 ++
 drivers/leds/leds-lp5523.c                          |    2 
 drivers/md/dm-snap.c                                |    1 
 drivers/media/platform/rcar_drif.c                  |    1 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c |    3 -
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c   |    8 +-
 drivers/net/ethernet/sun/niu.c                      |   32 +++++++----
 drivers/net/wireless/realtek/rtlwifi/base.c         |   19 +++---
 drivers/nvme/target/io-cmd-file.c                   |    8 +-
 drivers/platform/x86/dell-smbios-wmi.c              |    3 -
 drivers/rapidio/rio_cm.c                            |   17 ++----
 drivers/scsi/qla2xxx/qla_nx.c                       |    3 -
 drivers/scsi/ufs/ufs-hisi.c                         |   15 +++--
 drivers/tty/serial/mvebu-uart.c                     |    3 -
 drivers/tty/vt/vt.c                                 |    2 
 drivers/tty/vt/vt_ioctl.c                           |    6 +-
 drivers/video/console/vgacon.c                      |   56 +++++++++++---------
 drivers/video/fbdev/core/fbcon.c                    |    2 
 drivers/video/fbdev/hgafb.c                         |   21 ++++---
 drivers/video/fbdev/imsttfb.c                       |    5 -
 drivers/xen/xen-pciback/xenbus.c                    |   22 ++++++-
 fs/cifs/smb2ops.c                                   |    2 
 fs/ecryptfs/crypto.c                                |    6 --
 include/linux/console_struct.h                      |    1 
 kernel/locking/mutex-debug.c                        |    4 -
 kernel/locking/mutex-debug.h                        |    2 
 kernel/locking/mutex.c                              |   18 ++++--
 kernel/locking/mutex.h                              |    4 -
 kernel/ptrace.c                                     |   18 ++++++
 net/bluetooth/smp.c                                 |    9 +++
 sound/firewire/Kconfig                              |    4 -
 sound/firewire/bebob/bebob.c                        |    2 
 sound/firewire/dice/dice-alesis.c                   |    2 
 sound/firewire/dice/dice-tcelectronic.c             |    4 -
 sound/firewire/oxfw/oxfw.c                          |    1 
 sound/isa/sb/sb8.c                                  |    4 -
 sound/pci/hda/patch_realtek.c                       |   20 ++++++-
 sound/usb/line6/driver.c                            |    4 +
 sound/usb/line6/pod.c                               |    5 -
 sound/usb/line6/variax.c                            |    6 --
 sound/usb/midi.c                                    |    4 +
 47 files changed, 236 insertions(+), 153 deletions(-)

Anirudh Rayabharam (3):
      rapidio: handle create_workqueue() failure
      net: stmicro: handle clk_prepare() failure during init
      video: hgafb: correctly handle card detect failure during probe

Atul Gopinathan (1):
      cdrom: gdrom: deallocate struct gdrom_unit fields in remove_gdrom

Christophe JAILLET (1):
      openrisc: Fix a memory leak

Dan Carpenter (1):
      firmware: arm_scpi: Prevent the ternary sign expansion bug

Daniel Wagner (1):
      nvmet: seset ns->file when open fails

Du Cheng (1):
      ethernet: sun: niu: fix missing checks of niu_pci_eeprom_read()

Greg Kroah-Hartman (18):
      Revert "ALSA: sb8: add a check for request_region"
      Revert "rapidio: fix a NULL pointer dereference when create_workqueue() fails"
      Revert "serial: mvebu-uart: Fix to avoid a potential NULL pointer dereference"
      Revert "video: hgafb: fix potential NULL pointer dereference"
      Revert "net: stmicro: fix a missing check of clk_prepare"
      Revert "leds: lp5523: fix a missing check of return value of lp55xx_read"
      Revert "hwmon: (lm80) fix a missing check of bus read in lm80 probe"
      Revert "video: imsttfb: fix potential NULL pointer dereferences"
      Revert "ecryptfs: replace BUG_ON with error handling code"
      Revert "scsi: ufs: fix a missing check of devm_reset_control_get"
      Revert "gdrom: fix a memory leak bug"
      cdrom: gdrom: initialize global variable at init time
      Revert "media: rcar_drif: fix a memory disclosure"
      Revert "rtlwifi: fix a potential NULL pointer dereference"
      Revert "qlcnic: Avoid potential NULL pointer dereference"
      Revert "niu: fix missing checks of niu_pci_eeprom_read"
      net: rtlwifi: properly check for alloc_workqueue() failure
      Linux 4.19.192

Hans de Goede (1):
      platform/x86: dell-smbios-wmi: Fix oops on rmmod dell_smbios

Hui Wang (1):
      ALSA: hda/realtek: reset eapd coeff to default value for alc287

Igor Matheus Andrade Torrente (1):
      video: hgafb: fix potential NULL pointer dereference

Jan Beulich (1):
      xen-pciback: reconfigure also from backend watch handler

Leon Romanovsky (1):
      RDMA/rxe: Clear all QP fields if creation failed

Luiz Augusto von Dentz (1):
      Bluetooth: SMP: Fail if remote and local public keys are identical

Maciej W. Rozycki (2):
      vgacon: Record video mode changes with VT_RESIZEX
      vt: Fix character height handling with VT_RESIZEX

Maor Gottlieb (1):
      RDMA/mlx5: Recover from fatal event in dual port mode

Mikulas Patocka (1):
      dm snapshot: fix crash with transient storage and zero chunk size

Oleg Nesterov (1):
      ptrace: make ptrace() fail if the tracee changed its pid unexpectedly

PeiSen Hou (1):
      ALSA: hda/realtek: Add some CLOVE SSIDs of ALC293

Phillip Potter (2):
      scsi: ufs: handle cleanup correctly on devm_reset_control_get error
      leds: lp5523: check return value of lp5xx_read and jump to cleanup code

Ronnie Sahlberg (1):
      cifs: fix memory leak in smb2_copychunk_range

Takashi Iwai (2):
      ALSA: line6: Fix racy initialization of LINE6 MIDI
      ALSA: usb-audio: Validate MS endpoint descriptors

Takashi Sakamoto (3):
      ALSA: dice: fix stream format for TC Electronic Konnekt Live at high sampling transfer frequency
      ALSA: dice: fix stream format at middle sampling rate for Alesis iO 26
      ALSA: bebob/oxfw: fix Kconfig entry for Mackie d.2 Pro

Tetsuo Handa (1):
      tty: vt: always invoke vc->vc_sw->con_resize callback

Tom Seewald (1):
      qlcnic: Add null check after calling netdev_alloc_skb

Zhen Lei (1):
      scsi: qla2xxx: Fix error return code in qla82xx_write_flash_dword()

Zqiang (1):
      locking/mutex: clear MUTEX_FLAGS if wait_list is empty due to signal

