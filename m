Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA87F3AC5F5
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 10:24:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbhFRI0b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 04:26:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:39602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233482AbhFRI0b (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Jun 2021 04:26:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14DEF6121D;
        Fri, 18 Jun 2021 08:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624004660;
        bh=dQlXw02WjtEp60rXOsyReBjH983jfBdDxnwT9fris78=;
        h=From:To:Cc:Subject:Date:From;
        b=Yi7uGHy9jWppcgvLScuztJm2kqpZWNcsA8nZ/Uvu0VYvJnlpICDFlrU5f5jgjf7cs
         RQ1dBxSFxIbOc6zff0iNDM+dgUhY7UQA50aIrmegUa9Hg+ttUINxkWeS3pqhN0dFtV
         7FeHHuyQ2ncP6HP8DJJWiYXMuKZ1R1b8DUc8zIZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.127
Date:   Fri, 18 Jun 2021 10:24:16 +0200
Message-Id: <1624004657231172@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.127 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                              |    2 -
 arch/arm/mach-omap2/board-n8x0.c                      |    2 -
 arch/riscv/Makefile                                   |    9 ++++++++
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_resource.c |    2 -
 drivers/gpu/drm/tegra/sor.c                           |   14 +++++++++---
 drivers/hid/hid-core.c                                |    3 ++
 drivers/hid/hid-debug.c                               |    1 
 drivers/hid/hid-gt683r.c                              |    1 
 drivers/hid/hid-ids.h                                 |    2 +
 drivers/hid/hid-input.c                               |    3 ++
 drivers/hid/hid-multitouch.c                          |    8 +++----
 drivers/hid/hid-quirks.c                              |    2 +
 drivers/hid/hid-sensor-hub.c                          |   13 ++++++++---
 drivers/hid/usbhid/hid-core.c                         |    2 -
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c      |    1 
 drivers/nvme/target/loop.c                            |    5 +++-
 drivers/scsi/qedf/qedf_main.c                         |   20 ++++++++----------
 drivers/scsi/scsi_devinfo.c                           |    1 
 drivers/target/target_core_transport.c                |    4 ---
 fs/gfs2/file.c                                        |    5 +++-
 fs/gfs2/glock.c                                       |    2 -
 include/linux/hid.h                                   |    3 --
 include/uapi/linux/input-event-codes.h                |    1 
 net/compat.c                                          |    2 -
 net/core/fib_rules.c                                  |    2 -
 net/core/rtnetlink.c                                  |    4 ++-
 net/ieee802154/nl802154.c                             |    9 ++++----
 net/ipv4/ipconfig.c                                   |   13 +++++++----
 net/x25/af_x25.c                                      |    2 -
 29 files changed, 90 insertions(+), 48 deletions(-)

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

Dan Robertson (1):
      net: ieee802154: fix null deref in parse dev addr

Daniel Wagner (1):
      scsi: qedf: Do not put host in qedf_vport_create() unconditionally

Dmitry Torokhov (1):
      HID: hid-input: add mapping for emoji picker key

Ewan D. Milne (1):
      scsi: scsi_devinfo: Add blacklist entry for HPE OPEN-V

Greg Kroah-Hartman (1):
      Linux 5.4.127

Hannes Reinecke (3):
      nvme-loop: reset queue count to 1 in nvme_loop_destroy_io_queues()
      nvme-loop: clear NVME_LOOP_Q_LIVE when nvme_loop_configure_admin_queue() fails
      nvme-loop: check for NVME_LOOP_Q_LIVE in nvme_loop_destroy_admin_queue()

Hillf Danton (1):
      gfs2: Fix use-after-free in gfs2_glock_shrink_scan

Jiapeng Chong (2):
      ethernet: myri10ge: Fix missing error code in myri10ge_probe()
      rtnetlink: Fix missing error code in rtnl_bridge_notify()

Josh Triplett (1):
      net: ipconfig: Don't override command-line hostnames or domains

Khem Raj (1):
      riscv: Use -mno-relax when using lld linker

Mark Bolhuis (1):
      HID: Add BUS_VIRTUAL to hid_connect logging

Maurizio Lombardi (1):
      scsi: target: core: Fix warning on realtime kernels

Nirenjan Krishnan (1):
      HID: quirks: Set INCREMENT_USAGE_ON_DUPLICATE for Saitek X65

Pavel Machek (CIP) (1):
      drm/tegra: sor: Do not leak runtime PM reference

Saeed Mirzamohammadi (1):
      HID: quirks: Add quirk for Lenovo optical mouse

Srinivas Pandruvada (1):
      HID: hid-sensor-hub: Return error for hid_set_field() failure

Yongqiang Liu (1):
      ARM: OMAP2+: Fix build warning when mmc_omap is not built

Zheng Yongjun (3):
      net/x25: Return the correct errno code
      net: Return the correct errno code
      fib: Return the correct errno code

