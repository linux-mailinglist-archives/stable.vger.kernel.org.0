Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A682B3E394E
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 09:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhHHHPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 03:15:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:49168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230397AbhHHHPv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Aug 2021 03:15:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47BE560F42;
        Sun,  8 Aug 2021 07:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628406931;
        bh=YlmSMOi+cgizIRx1C2e5a/jJLSNzxnzc8tSRA3KqM1s=;
        h=From:To:Cc:Subject:Date:From;
        b=AFD/YJVFhQqw6g5ydgja9wVFQDuc0YIA4KUDUWQjRPwiPuIC35B1NXdhdaiOX1qpo
         LznqYUTO4j4L6GV2vkOUNiDyacG0TFy4z/S4BZpMHsBT+JYiHm7EGpXK9fwvObo27a
         2F925Qikr+0vdZXpmHU2PoyHEfoSSjCwbre5SfHg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.202
Date:   Sun,  8 Aug 2021 09:15:25 +0200
Message-Id: <162840692587205@kroah.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.202 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                  |    2 +-
 block/bfq-iosched.c                       |    6 ++++--
 block/blk-cgroup.c                        |    2 +-
 drivers/firmware/arm_scmi/bus.c           |    3 +++
 drivers/gpu/drm/i915/intel_engine_cs.c    |    2 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c |   23 +++++++++++++++++------
 drivers/net/usb/r8152.c                   |    3 ++-
 drivers/spi/spi-mt65xx.c                  |   19 +++++--------------
 drivers/watchdog/iTCO_wdt.c               |   12 +++---------
 fs/btrfs/compression.c                    |    3 +--
 fs/ceph/debugfs.c                         |    2 +-
 include/linux/backing-dev-defs.h          |    1 +
 include/linux/backing-dev.h               |    9 +--------
 include/linux/cpuhotplug.h                |    1 +
 include/linux/mfd/rt5033-private.h        |    4 ++--
 include/linux/padata.h                    |    6 ++++--
 include/trace/events/wbt.h                |    8 ++++----
 kernel/padata.c                           |   28 ++++++++++++++++++++--------
 mm/backing-dev.c                          |   13 +++++++++++--
 net/bluetooth/hci_core.c                  |   16 ++++++++--------
 net/core/skbuff.c                         |    5 ++++-
 sound/soc/codecs/tlv320aic31xx.h          |    4 ++--
 22 files changed, 97 insertions(+), 75 deletions(-)

Axel Lin (1):
      regulator: rt5033: Fix n_voltages settings for BUCK and LDO

Christoph Hellwig (2):
      bdi: move bdi_dev_name out of line
      bdi: add a ->dev_name field to struct backing_dev_info

Daniel Jordan (2):
      padata: validate cpumask without removed CPU during offline
      padata: add separate cpuhp node for CPUHP_PADATA_DEAD

Goldwyn Rodrigues (1):
      btrfs: mark compressed range uptodate only if all bio succeed

Greg Kroah-Hartman (3):
      Revert "Bluetooth: Shutdown controller after workqueues are flushed or cancelled"
      Revert "watchdog: iTCO_wdt: Account for rebooting on second timeout"
      Linux 4.19.202

Guenter Roeck (1):
      spi: mediatek: Fix fifo transfer

Jani Nikula (1):
      drm/i915: Ensure intel_engine_init_execlist() builds with Clang

Jia He (1):
      qed: fix possible unpaired spin_{un}lock_bh in _qed_mcp_cmd_and_union()

Kyle Russell (1):
      ASoC: tlv320aic31xx: fix reversed bclk/wclk master bits

Pravin B Shelar (1):
      net: Fix zero-copy head len calculation.

Sudeep Holla (1):
      firmware: arm_scmi: Ensure drivers provide a probe function

Takashi Iwai (1):
      r8152: Fix potential PM refcount imbalance

Yufen Yu (1):
      bdi: use bdi_dev_name() to get device name

