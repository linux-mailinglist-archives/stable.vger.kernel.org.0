Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0FFA43076A
	for <lists+stable@lfdr.de>; Sun, 17 Oct 2021 11:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241585AbhJQJLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Oct 2021 05:11:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241557AbhJQJLg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Oct 2021 05:11:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E57261054;
        Sun, 17 Oct 2021 09:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634461767;
        bh=earWNHFnodZSeHkpL2DCzlwyJ/k87RuafjTw/K3a38I=;
        h=From:To:Cc:Subject:Date:From;
        b=P9kiJiid57QZ4krzNgjMdhce/wsX/b84bVQctPcsH69AmVRr5OeofSVIY/OPsjK/8
         yR5pcvglAH3fY1dcqc+XycxJmwmVuyfrTb5c6FMFFgGYYuCWZgubALvERfPsoyxcab
         27dNyt0XJJqMqDv+pc+ilQyuwnIRGwEbi6tgbdpk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.10.74
Date:   Sun, 17 Oct 2021 11:09:20 +0200
Message-Id: <163446176023879@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.10.74 kernel.

All users of the 5.10 kernel series must upgrade.

The updated 5.10.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.10.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                               |    2 
 arch/m68k/kernel/signal.c              |   88 ++++++++---------
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c |    3 
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c  |    3 
 drivers/hid/hid-apple.c                |    7 +
 drivers/hid/wacom_wac.c                |    8 +
 drivers/hwmon/ltc2947-core.c           |    8 +
 drivers/hwmon/pmbus/ibm-cffps.c        |   10 +
 drivers/net/ethernet/sun/Kconfig       |    1 
 drivers/scsi/ses.c                     |    2 
 drivers/scsi/virtio_scsi.c             |    4 
 fs/ext4/inline.c                       |   15 --
 fs/ext4/inode.c                        |   41 ++++----
 fs/vboxsf/super.c                      |   12 --
 include/linux/perf_event.h             |    4 
 include/linux/sched.h                  |    2 
 include/net/pkt_sched.h                |    1 
 kernel/events/core.c                   |   34 +++++-
 net/ipv6/netfilter/ip6_tables.c        |    1 
 net/mac80211/mesh_pathtbl.c            |    5 
 net/mac80211/rx.c                      |    3 
 net/netfilter/nf_nat_masquerade.c      |  168 +++++++++++++++++++--------------
 net/sched/sch_api.c                    |    6 +
 sound/soc/intel/boards/sof_sdw.c       |    5 
 sound/soc/sof/core.c                   |    4 
 sound/soc/sof/loader.c                 |    2 
 26 files changed, 263 insertions(+), 176 deletions(-)

Al Viro (1):
      m68k: Handle arrivals of multiple signals correctly

Brandon Wyman (1):
      hwmon: (pmbus/ibm-cffps) max_power_out swap changes

Colin Ian King (1):
      scsi: virtio_scsi: Fix spelling mistake "Unsupport" -> "Unsupported"

Florian Westphal (2):
      netfilter: nf_nat_masquerade: make async masq_inet6_event handling generic
      netfilter: nf_nat_masquerade: defer conntrack walk to work queue

Greg Kroah-Hartman (1):
      Linux 5.10.74

Jeremy Sowden (1):
      netfilter: ip6_tables: zero-initialize fragment offset

Jiapeng Chong (1):
      scsi: ses: Fix unsigned comparison with less than zero

Joshua-Dickens (1):
      HID: wacom: Add new Intuos BT (CTL-4100WL/CTL-6100WL) device IDs

Leslie Shi (1):
      drm/amdgpu: fix gart.bo pin_count leak

Linus Torvalds (1):
      vboxfs: fix broken legacy mount signature checking

Marc Herbert (1):
      ASoC: SOF: loader: release_firmware() on load failure to avoid batching

MichelleJin (1):
      mac80211: check return value of rhashtable_init

Mizuho Mori (1):
      HID: apple: Fix logical maximum and usage maximum of Magic Keyboard JIS

Peter Zijlstra (1):
      sched: Always inline is_percpu_thread()

Pierre-Louis Bossart (1):
      ASoC: Intel: sof_sdw: tag SoundWire BEs as non-atomic

Randy Dunlap (1):
      net: sun: SUNVNET_COMMON should depend on INET

Song Liu (1):
      perf/core: fix userpage->time_enabled of inactive events

Uwe Kleine-König (1):
      hwmon: (ltc2947) Properly handle errors when looking for the external clock

YueHaibing (1):
      mac80211: Drop frames from invalid MAC address in ad-hoc mode

Zhang Yi (2):
      ext4: check and update i_disksize properly
      ext4: correct the error path of ext4_write_inline_data_end()

王贇 (1):
      net: prevent user from passing illegal stab size

