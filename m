Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBDA93916A4
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 13:52:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbhEZLw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 07:52:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:35878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233392AbhEZLvg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 May 2021 07:51:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A69861417;
        Wed, 26 May 2021 11:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622029757;
        bh=Rskw6hYN+VHiqVxsv8VXMtHq2nACKskU2xu/0ykwPZI=;
        h=From:To:Cc:Subject:Date:From;
        b=rR//elaAQPzIvw649Fyd93JBXm1syJxrSIAc5f6QS2+tcYweEaHjSRSCDaz+QmatW
         TnBHd82wAsNYhat5Y3F6qMm/4K6GB8l0k0mhFkBkXOiSvdKqiVawf+oVUcJ5FZ4Kfm
         i56BAppUJQmjN50izphiez8KRSUhbAXQzyhQkZGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.122
Date:   Wed, 26 May 2021 13:48:48 +0200
Message-Id: <16220297281791@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.122 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                            |    2 
 arch/openrisc/kernel/setup.c                        |    2 
 drivers/cdrom/gdrom.c                               |   13 +
 drivers/firmware/arm_scpi.c                         |    4 
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c              |    6 
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c               |   10 +
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c              |    4 
 drivers/gpu/drm/amd/amdgpu/soc15.c                  |    2 
 drivers/hwmon/lm80.c                                |   11 -
 drivers/infiniband/core/cma.c                       |    4 
 drivers/infiniband/core/uverbs_std_types_device.c   |    4 
 drivers/infiniband/hw/mlx5/main.c                   |    1 
 drivers/infiniband/sw/rxe/rxe_qp.c                  |    7 +
 drivers/infiniband/sw/siw/siw_verbs.c               |   11 -
 drivers/leds/leds-lp5523.c                          |    2 
 drivers/md/dm-snap.c                                |    1 
 drivers/media/platform/rcar_drif.c                  |    1 
 drivers/misc/ics932s401.c                           |    2 
 drivers/mmc/host/sdhci-pci-gli.c                    |    7 -
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c |    3 
 drivers/net/ethernet/stmicro/stmmac/dwmac-sunxi.c   |    8 -
 drivers/net/ethernet/sun/niu.c                      |   32 ++--
 drivers/net/wireless/realtek/rtlwifi/base.c         |   18 +-
 drivers/nvme/host/core.c                            |    3 
 drivers/nvme/host/multipath.c                       |   55 ++++----
 drivers/nvme/host/nvme.h                            |    8 -
 drivers/nvme/target/io-cmd-file.c                   |    8 -
 drivers/platform/mellanox/mlxbf-tmfifo.c            |   11 +
 drivers/platform/x86/dell-smbios-wmi.c              |    3 
 drivers/rapidio/rio_cm.c                            |   17 +-
 drivers/scsi/qla2xxx/qla_nx.c                       |    3 
 drivers/scsi/ufs/ufs-hisi.c                         |   15 +-
 drivers/scsi/ufs/ufshcd.c                           |    5 
 drivers/tty/serial/mvebu-uart.c                     |    3 
 drivers/tty/vt/vt.c                                 |    2 
 drivers/tty/vt/vt_ioctl.c                           |    6 
 drivers/uio/uio_hv_generic.c                        |    8 -
 drivers/video/console/vgacon.c                      |   56 ++++----
 drivers/video/fbdev/core/fbcon.c                    |    2 
 drivers/video/fbdev/hgafb.c                         |   21 +--
 drivers/video/fbdev/imsttfb.c                       |    5 
 drivers/xen/xen-pciback/xenbus.c                    |   22 ++-
 fs/btrfs/inode.c                                    |    1 
 fs/cifs/smb2ops.c                                   |    2 
 fs/ecryptfs/crypto.c                                |    6 
 fs/ext4/verity.c                                    |   89 ++++++++-----
 include/linux/console_struct.h                      |    1 
 kernel/locking/mutex-debug.c                        |    4 
 kernel/locking/mutex-debug.h                        |    2 
 kernel/locking/mutex.c                              |   18 +-
 kernel/locking/mutex.h                              |    4 
 kernel/ptrace.c                                     |   18 ++
 net/bluetooth/l2cap_sock.c                          |   24 ++-
 net/bluetooth/smp.c                                 |    9 +
 sound/firewire/Kconfig                              |    4 
 sound/firewire/amdtp-stream.c                       |   27 ++--
 sound/firewire/bebob/bebob.c                        |    2 
 sound/firewire/dice/dice-alesis.c                   |    2 
 sound/firewire/dice/dice-tcelectronic.c             |    4 
 sound/firewire/oxfw/oxfw.c                          |    1 
 sound/isa/sb/sb8.c                                  |    4 
 sound/pci/hda/patch_realtek.c                       |  135 +++++++++++++++++++-
 sound/pci/intel8x0.c                                |    7 +
 sound/usb/line6/driver.c                            |    4 
 sound/usb/line6/pod.c                               |    5 
 sound/usb/line6/variax.c                            |    6 
 sound/usb/midi.c                                    |    4 
 67 files changed, 538 insertions(+), 253 deletions(-)

Anirudh Rayabharam (3):
      rapidio: handle create_workqueue() failure
      net: stmicro: handle clk_prepare() failure during init
      video: hgafb: correctly handle card detect failure during probe

Atul Gopinathan (1):
      cdrom: gdrom: deallocate struct gdrom_unit fields in remove_gdrom

Bart Van Assche (1):
      scsi: ufs: core: Increase the usable queue depth

Changfeng (1):
      drm/amdgpu: disable 3DCGCG on picasso/raven1 to avoid compute hang

Christoph Hellwig (1):
      nvme-multipath: fix double initialization of ANA state

Christophe JAILLET (2):
      openrisc: Fix a memory leak
      uio_hv_generic: Fix a memory leak in error handling paths

Dan Carpenter (2):
      firmware: arm_scpi: Prevent the ternary sign expansion bug
      RDMA/uverbs: Fix a NULL vs IS_ERR() bug

Daniel Beer (1):
      mmc: sdhci-pci-gli: increase 1.8V regulator wait

Daniel Cordova A (1):
      ALSA: hda: fixup headset for ASUS GU502 laptop

Daniel Wagner (1):
      nvmet: seset ns->file when open fails

Darrick J. Wong (1):
      ics932s401: fix broken handling of errors when word reading fails

Du Cheng (1):
      ethernet: sun: niu: fix missing checks of niu_pci_eeprom_read()

Elia Devito (1):
      ALSA: hda/realtek: Add fixup for HP Spectre x360 15-df0xxx

Eric Biggers (1):
      ext4: fix error handling in ext4_end_enable_verity()

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
      Linux 5.4.122

Guchun Chen (2):
      drm/amdgpu: update gc golden setting for Navi12
      drm/amdgpu: update sdma golden setting for Navi12

Hans de Goede (1):
      platform/x86: dell-smbios-wmi: Fix oops on rmmod dell_smbios

Hou Pu (1):
      nvmet: use new ana_log_size instead the old one

Hui Wang (1):
      ALSA: hda/realtek: reset eapd coeff to default value for alc287

Igor Matheus Andrade Torrente (1):
      video: hgafb: fix potential NULL pointer dereference

Jan Beulich (1):
      xen-pciback: reconfigure also from backend watch handler

Josef Bacik (1):
      btrfs: avoid RCU stalls while running delayed iputs

Leon Romanovsky (3):
      RDMA/siw: Properly check send and receive CQ pointers
      RDMA/siw: Release xarray entry
      RDMA/rxe: Clear all QP fields if creation failed

Liming Sun (1):
      platform/mellanox: mlxbf-tmfifo: Fix a memory barrier issue

Luiz Augusto von Dentz (2):
      Bluetooth: L2CAP: Fix handling LE modes by L2CAP_OPTIONS
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

Shay Drory (1):
      RDMA/core: Don't access cm_id after its destruction

Takashi Iwai (5):
      ALSA: intel8x0: Don't update period unless prepared
      ALSA: line6: Fix racy initialization of LINE6 MIDI
      ALSA: usb-audio: Validate MS endpoint descriptors
      ALSA: hda/realtek: Fix silent headphone output on ASUS UX430UA
      ALSA: hda/realtek: Add fixup for HP OMEN laptop

Takashi Sakamoto (5):
      ALSA: dice: fix stream format for TC Electronic Konnekt Live at high sampling transfer frequency
      ALSA: dice: fix stream format at middle sampling rate for Alesis iO 26
      ALSA: firewire-lib: fix calculation for size of IR context payload
      ALSA: bebob/oxfw: fix Kconfig entry for Mackie d.2 Pro
      ALSA: firewire-lib: fix check for the size of isochronous packet payload

Tetsuo Handa (1):
      tty: vt: always invoke vc->vc_sw->con_resize callback

Tom Seewald (1):
      qlcnic: Add null check after calling netdev_alloc_skb

Zhen Lei (1):
      scsi: qla2xxx: Fix error return code in qla82xx_write_flash_dword()

Zqiang (1):
      locking/mutex: clear MUTEX_FLAGS if wait_list is empty due to signal

