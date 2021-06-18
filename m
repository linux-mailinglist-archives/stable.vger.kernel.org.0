Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0E463AC600
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 10:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbhFRI04 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 04:26:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233756AbhFRI0s (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Jun 2021 04:26:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E3EFB61351;
        Fri, 18 Jun 2021 08:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624004679;
        bh=ccQhSs+nobOu8g8z0mYh374zOQhLUvAIEiwubaA62v8=;
        h=From:To:Cc:Subject:Date:From;
        b=sl3A0Vm0jSg+k4wWx3P+EukQY157Cd8SMSo064GYaZlnDdkgIN+Lx4KQUkH45Vd8p
         iP6I0Jn4DfHgxMQ7zX2tO1/owOVQAjiRS6p3RR+2FXKLuoqWgC/Y4Xi6qpuOLb0NhU
         GsSCW+hVSiU4GYVDcmqyl/4Pg5VkvXqz4vqJY5LQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.12.12
Date:   Fri, 18 Jun 2021 10:24:26 +0200
Message-Id: <16240046674293@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.12.12 kernel.

All users of the 5.12 kernel series must upgrade.

The updated 5.12.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.12.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                              |    2 
 arch/arm/mach-omap1/pm.c                              |   10 +++-
 arch/arm/mach-omap2/board-n8x0.c                      |    2 
 arch/riscv/Makefile                                   |    9 +++
 drivers/bluetooth/btusb.c                             |    2 
 drivers/gpu/drm/amd/amdgpu/amdgpu_fru_eeprom.c        |   42 +++++++++---------
 drivers/gpu/drm/amd/amdgpu/amdgpu_psp.h               |    1 
 drivers/gpu/drm/amd/amdgpu/psp_v11_0.c                |    3 -
 drivers/gpu/drm/amd/amdgpu/psp_v3_1.c                 |    3 -
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c     |    4 -
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c |    2 
 drivers/gpu/drm/tegra/sor.c                           |   41 +++++++++--------
 drivers/gpu/host1x/bus.c                              |   30 ++++++++++--
 drivers/hid/Kconfig                                   |    4 -
 drivers/hid/hid-a4tech.c                              |    2 
 drivers/hid/hid-asus.c                                |   12 ++++-
 drivers/hid/hid-core.c                                |    3 +
 drivers/hid/hid-debug.c                               |    1 
 drivers/hid/hid-gt683r.c                              |    1 
 drivers/hid/hid-ids.h                                 |    4 +
 drivers/hid/hid-input.c                               |    3 +
 drivers/hid/hid-multitouch.c                          |   36 ++++++++++++---
 drivers/hid/hid-quirks.c                              |    4 +
 drivers/hid/hid-sensor-hub.c                          |   13 +++--
 drivers/hid/intel-ish-hid/ipc/hw-ish.h                |    2 
 drivers/hid/intel-ish-hid/ipc/pci-ish.c               |    2 
 drivers/hid/usbhid/hid-core.c                         |    2 
 drivers/hwmon/pmbus/q54sj108a2.c                      |    2 
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c      |    1 
 drivers/net/wireless/mediatek/mt76/mt7921/init.c      |    4 -
 drivers/net/wireless/mediatek/mt76/mt7921/main.c      |    3 -
 drivers/nvme/target/loop.c                            |   11 +++-
 drivers/scsi/qedf/qedf_main.c                         |   20 +++-----
 drivers/scsi/scsi_devinfo.c                           |    1 
 drivers/target/target_core_transport.c                |    4 -
 fs/gfs2/file.c                                        |    5 +-
 fs/gfs2/glock.c                                       |   26 +++++++++--
 fs/gfs2/log.c                                         |    6 +-
 fs/gfs2/log.h                                         |    1 
 fs/gfs2/lops.c                                        |    7 ++-
 fs/gfs2/lops.h                                        |    1 
 fs/gfs2/util.c                                        |    1 
 include/linux/hid.h                                   |    3 -
 include/linux/host1x.h                                |   30 ++++++++++--
 include/uapi/linux/input-event-codes.h                |    1 
 net/compat.c                                          |    2 
 net/core/fib_rules.c                                  |    2 
 net/core/rtnetlink.c                                  |    4 +
 net/ieee802154/nl802154.c                             |    9 ++-
 net/ipv4/ipconfig.c                                   |   13 +++--
 net/x25/af_x25.c                                      |    2 
 sound/hda/intel-dsp-config.c                          |    4 +
 sound/pci/hda/hda_intel.c                             |    3 +
 53 files changed, 287 insertions(+), 119 deletions(-)

Ahelenia Ziemiańska (1):
      HID: multitouch: set Stylus suffix for Stylus-application devices, too

Andreas Gruenbacher (1):
      gfs2: Prevent direct-I/O write fallback errors from getting lost

Anirudh Rayabharam (1):
      HID: usbhid: fix info leak in hid_submit_ctrl

Bindu Ramamurthy (1):
      drm/amd/display: Allow bandwidth validation for 0 streams.

Bixuan Cui (1):
      HID: gt683r: add missing MODULE_DEVICE_TABLE

Bob Peterson (2):
      gfs2: fix a deadlock on withdraw-during-mount
      gfs2: Clean up revokes on normal withdraws

Chu Lin (1):
      hwmon/pmbus: (q54sj108a2) The PMBUS_MFR_ID is actually 6 chars instead of 5

Dan Robertson (1):
      net: ieee802154: fix null deref in parse dev addr

Daniel Wagner (1):
      scsi: qedf: Do not put host in qedf_vport_create() unconditionally

Dmitry Torokhov (1):
      HID: hid-input: add mapping for emoji picker key

Ewan D. Milne (1):
      scsi: scsi_devinfo: Add blacklist entry for HPE OPEN-V

Felix Fietkau (2):
      mt76: mt7921: fix max aggregation subframes setting
      mt76: mt7921: remove leftover 80+80 HE capability

Greg Kroah-Hartman (1):
      Linux 5.12.12

Hannes Reinecke (4):
      nvme-loop: reset queue count to 1 in nvme_loop_destroy_io_queues()
      nvme-loop: clear NVME_LOOP_Q_LIVE when nvme_loop_configure_admin_queue() fails
      nvme-loop: check for NVME_LOOP_Q_LIVE in nvme_loop_destroy_admin_queue()
      nvme-loop: do not warn for deleted controllers during reset

Hans de Goede (2):
      HID: quirks: Add HID_QUIRK_NO_INIT_REPORTS quirk for Dell K15A keyboard-dock
      HID: multitouch: Disable event reporting on suspend on the Asus T101HA touchpad

Hillf Danton (1):
      gfs2: Fix use-after-free in gfs2_glock_shrink_scan

Jiansong Chen (1):
      drm/amdgpu: refine amdgpu_fru_get_product_info

Jiapeng Chong (2):
      ethernet: myri10ge: Fix missing error code in myri10ge_probe()
      rtnetlink: Fix missing error code in rtnl_bridge_notify()

Josh Triplett (1):
      net: ipconfig: Don't override command-line hostnames or domains

Kai Vehmanen (1):
      ALSA: hda: Add AlderLake-M PCI ID

Khem Raj (1):
      riscv: Use -mno-relax when using lld linker

Larry Finger (1):
      Bluetooth: Add a new USB ID for RTL8822CE

Luke D Jones (2):
      HID: asus: Filter keyboard EC for old ROG keyboard
      HID: asus: filter G713/G733 key event to prevent shutdown

Maciej Falkowski (1):
      ARM: OMAP1: Fix use of possibly uninitialized irq variable

Mark Bolhuis (1):
      HID: Add BUS_VIRTUAL to hid_connect logging

Mateusz Jończyk (1):
      HID: a4tech: use A4_2WHEEL_MOUSE_HACK_B8 for A4TECH NB-95

Maurizio Lombardi (1):
      scsi: target: core: Fix warning on realtime kernels

Nirenjan Krishnan (1):
      HID: quirks: Set INCREMENT_USAGE_ON_DUPLICATE for Saitek X65

Pavel Machek (CIP) (1):
      drm/tegra: sor: Do not leak runtime PM reference

Roman Li (1):
      drm/amd/display: Fix potential memory leak in DMUB hw_init

Saeed Mirzamohammadi (1):
      HID: quirks: Add quirk for Lenovo optical mouse

Srinivas Pandruvada (1):
      HID: hid-sensor-hub: Return error for hid_set_field() failure

Thierry Reding (2):
      gpu: host1x: Split up client initalization and registration
      drm/tegra: sor: Fully initialize SOR before registration

Victor Zhao (1):
      drm/amd/amdgpu:save psp ring wptr to avoid attack

Ye Xiang (1):
      HID: intel-ish-hid: ipc: Add Alder Lake device IDs

Yongqiang Liu (1):
      ARM: OMAP2+: Fix build warning when mmc_omap is not built

Zheng Yongjun (3):
      net/x25: Return the correct errno code
      net: Return the correct errno code
      fib: Return the correct errno code

