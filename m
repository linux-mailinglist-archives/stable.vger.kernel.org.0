Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71CFE430766
	for <lists+stable@lfdr.de>; Sun, 17 Oct 2021 11:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241520AbhJQJL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Oct 2021 05:11:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232666AbhJQJLZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Oct 2021 05:11:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D7D3960EBD;
        Sun, 17 Oct 2021 09:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634461756;
        bh=j4jJCnuRaBzwqDK9WgmDJM2jorDucfCKh48LXtuBlAo=;
        h=From:To:Cc:Subject:Date:From;
        b=w9Z4vsKQWdCURaiMaBmSxMU5Sr0MbvJnUCmi0sOr4Vwz8WxmeVcndYSKv4Oy7TEEu
         eXU7GDlD5e+tm6bQeTuwl0RErZjGEXuiWErzOG0qKiNkxR1pBgVzo3ZGi51oZl9EPy
         Fo9wPoA1ceONQWVgcHm2KTtHrVcfNkyPnzQkI+K8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.154
Date:   Sun, 17 Oct 2021 11:09:12 +0200
Message-Id: <1634461753125247@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.154 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
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
 drivers/net/ethernet/sun/Kconfig       |    1 
 drivers/net/phy/bcm7xxx.c              |  114 +++++++++++++++++++++-
 drivers/scsi/ses.c                     |    2 
 drivers/scsi/virtio_scsi.c             |    4 
 fs/ext4/inline.c                       |   15 --
 fs/ext4/inode.c                        |    7 -
 include/linux/sched.h                  |    2 
 include/net/pkt_sched.h                |    1 
 net/ipv6/netfilter/ip6_tables.c        |    1 
 net/mac80211/mesh_pathtbl.c            |    5 
 net/mac80211/rx.c                      |    3 
 net/netfilter/nf_nat_masquerade.c      |  168 +++++++++++++++++++--------------
 net/sched/sch_api.c                    |    6 +
 19 files changed, 298 insertions(+), 142 deletions(-)

Al Viro (1):
      m68k: Handle arrivals of multiple signals correctly

Colin Ian King (1):
      scsi: virtio_scsi: Fix spelling mistake "Unsupport" -> "Unsupported"

Florian Fainelli (1):
      net: phy: bcm7xxx: Fixed indirect MMD operations

Florian Westphal (2):
      netfilter: nf_nat_masquerade: make async masq_inet6_event handling generic
      netfilter: nf_nat_masquerade: defer conntrack walk to work queue

Greg Kroah-Hartman (1):
      Linux 5.4.154

Jeremy Sowden (1):
      netfilter: ip6_tables: zero-initialize fragment offset

Jiapeng Chong (1):
      scsi: ses: Fix unsigned comparison with less than zero

Joshua-Dickens (1):
      HID: wacom: Add new Intuos BT (CTL-4100WL/CTL-6100WL) device IDs

Leslie Shi (1):
      drm/amdgpu: fix gart.bo pin_count leak

MichelleJin (1):
      mac80211: check return value of rhashtable_init

Mizuho Mori (1):
      HID: apple: Fix logical maximum and usage maximum of Magic Keyboard JIS

Peter Zijlstra (1):
      sched: Always inline is_percpu_thread()

Randy Dunlap (1):
      net: sun: SUNVNET_COMMON should depend on INET

YueHaibing (1):
      mac80211: Drop frames from invalid MAC address in ad-hoc mode

Zhang Yi (1):
      ext4: correct the error path of ext4_write_inline_data_end()

王贇 (1):
      net: prevent user from passing illegal stab size

