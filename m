Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628C943076E
	for <lists+stable@lfdr.de>; Sun, 17 Oct 2021 11:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241657AbhJQJLt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Oct 2021 05:11:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:43258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241668AbhJQJLr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Oct 2021 05:11:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99BBE60EBD;
        Sun, 17 Oct 2021 09:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634461778;
        bh=3ezQYKkdNlGN5BM+uAcsR00kDl9QjgbsIKwTR5s2+Do=;
        h=From:To:Cc:Subject:Date:From;
        b=W+fRPgwBci99WCetkq7Y7q3xVdesipqo69flqldYNV31TadZAseGKdMolT8Hsnmjl
         KRZypZELXmX1Dbn9E4+Hue8Y0gZZtMn91dDXJbI+3UPfQNUVGWPdL5IQPsVm7ZeO5W
         X/gSRi/zhjS9/Rx+8e+iumdP9X7nEQK2OMYeRP/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.14.13
Date:   Sun, 17 Oct 2021 11:09:25 +0200
Message-Id: <163446176644211@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.14.13 kernel.

All users of the 5.14 kernel series must upgrade.

The updated 5.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                       |    2 
 arch/arm64/kvm/hyp/nvhe/Makefile               |    2 
 arch/m68k/kernel/signal.c                      |   88 ++++++-------
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c         |    3 
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c          |    3 
 drivers/hid/hid-apple.c                        |    7 +
 drivers/hid/wacom_wac.c                        |    8 +
 drivers/hwmon/ltc2947-core.c                   |    8 -
 drivers/hwmon/pmbus/ibm-cffps.c                |   10 +
 drivers/net/ethernet/broadcom/bgmac-platform.c |    3 
 drivers/net/ethernet/sun/Kconfig               |    1 
 drivers/pinctrl/qcom/pinctrl-sc7280.c          |    1 
 drivers/scsi/qla2xxx/qla_isr.c                 |    4 
 drivers/scsi/ses.c                             |    2 
 drivers/scsi/virtio_scsi.c                     |    4 
 fs/ext4/inline.c                               |   15 --
 fs/ext4/inode.c                                |   41 +++---
 fs/io_uring.c                                  |   17 --
 fs/vboxsf/super.c                              |   12 -
 include/linux/perf_event.h                     |    4 
 include/linux/sched.h                          |    2 
 include/net/pkt_sched.h                        |    1 
 kernel/events/core.c                           |   34 ++++-
 net/ipv6/netfilter/ip6_tables.c                |    1 
 net/mac80211/mesh_pathtbl.c                    |    5 
 net/mac80211/rx.c                              |    3 
 net/netfilter/nf_nat_masquerade.c              |  168 ++++++++++++++-----------
 net/sched/sch_api.c                            |    6 
 sound/firewire/oxfw/oxfw.c                     |   13 +
 sound/soc/intel/boards/sof_sdw.c               |    5 
 sound/soc/sof/core.c                           |    4 
 sound/soc/sof/loader.c                         |    2 
 sound/usb/card.c                               |   18 --
 sound/usb/mixer.c                              |   26 ---
 sound/usb/mixer.h                              |    3 
 sound/usb/mixer_quirks.c                       |    2 
 36 files changed, 290 insertions(+), 238 deletions(-)

Al Viro (1):
      m68k: Handle arrivals of multiple signals correctly

Arun Easi (1):
      scsi: qla2xxx: Fix excessive messages during device logout

Brandon Wyman (1):
      hwmon: (pmbus/ibm-cffps) max_power_out swap changes

Colin Ian King (1):
      scsi: virtio_scsi: Fix spelling mistake "Unsupport" -> "Unsupported"

Florian Westphal (2):
      netfilter: nf_nat_masquerade: make async masq_inet6_event handling generic
      netfilter: nf_nat_masquerade: defer conntrack walk to work queue

Greg Kroah-Hartman (1):
      Linux 5.14.13

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

Matthew Hagan (1):
      net: bgmac-platform: handle mac-address deferral

MichelleJin (1):
      mac80211: check return value of rhashtable_init

Mizuho Mori (1):
      HID: apple: Fix logical maximum and usage maximum of Magic Keyboard JIS

Pavel Begunkov (1):
      io_uring: kill fasync

Peter Zijlstra (1):
      sched: Always inline is_percpu_thread()

Pierre-Louis Bossart (1):
      ASoC: Intel: sof_sdw: tag SoundWire BEs as non-atomic

Rajendra Nayak (1):
      pinctrl: qcom: sc7280: Add PM suspend callbacks

Randy Dunlap (1):
      net: sun: SUNVNET_COMMON should depend on INET

Song Liu (1):
      perf/core: fix userpage->time_enabled of inactive events

Takashi Iwai (1):
      ALSA: usb-audio: Unify mixer resume and reset_resume procedure

Takashi Sakamoto (1):
      ALSA: oxfw: fix transmission method for Loud models based on OXFW971

Uwe Kleine-König (1):
      hwmon: (ltc2947) Properly handle errors when looking for the external clock

YueHaibing (1):
      mac80211: Drop frames from invalid MAC address in ad-hoc mode

Zenghui Yu (1):
      KVM: arm64: nvhe: Fix missing FORCE for hyp-reloc.S build rule

Zhang Yi (2):
      ext4: check and update i_disksize properly
      ext4: correct the error path of ext4_write_inline_data_end()

王贇 (1):
      net: prevent user from passing illegal stab size

