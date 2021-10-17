Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A33B43075E
	for <lists+stable@lfdr.de>; Sun, 17 Oct 2021 10:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245163AbhJQIub (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Oct 2021 04:50:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:48850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245146AbhJQIu3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 17 Oct 2021 04:50:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC50A61040;
        Sun, 17 Oct 2021 08:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634460500;
        bh=KUJOw3PSZAv6ppQSP3Zda/5Q8gCc9OoeP78dpWCVSHI=;
        h=From:To:Cc:Subject:Date:From;
        b=M+AulqYkROj4CKT7iE8/1X+unfDOCpYonatIOJZSk80+Gz0HN2Vk4s6JpkKNerxvb
         n9G1uC+fcvaeOuCSK8dqiyM5FUhK0785I4C8gj+e4R4J4HWPGdDfLVev5YWlMza+cR
         rMqESAaqcL678uW5VjO5xoN4T91R/6ZHh/AiDHZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.19.212
Date:   Sun, 17 Oct 2021 10:48:05 +0200
Message-Id: <1634460486243142@kroah.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.19.212 kernel.

All users of the 4.19 kernel series must upgrade.

The updated 4.19.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.19.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                         |    2 
 arch/m68k/kernel/signal.c        |   88 +++++++++++++++++-------------------
 arch/x86/events/core.c           |    1 
 drivers/hid/hid-apple.c          |    7 ++
 drivers/net/ethernet/sun/Kconfig |    1 
 drivers/net/phy/bcm7xxx.c        |   94 +++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ses.c               |    2 
 drivers/scsi/virtio_scsi.c       |    4 -
 include/linux/sched.h            |    2 
 include/net/pkt_sched.h          |    1 
 net/ipv6/netfilter/ip6_tables.c  |    1 
 net/mac80211/mesh_pathtbl.c      |    5 +-
 net/mac80211/rx.c                |    3 -
 net/sched/sch_api.c              |    6 ++
 14 files changed, 164 insertions(+), 53 deletions(-)

Al Viro (1):
      m68k: Handle arrivals of multiple signals correctly

Anand K Mistry (1):
      perf/x86: Reset destroy callback on event init failure

Colin Ian King (1):
      scsi: virtio_scsi: Fix spelling mistake "Unsupport" -> "Unsupported"

Florian Fainelli (1):
      net: phy: bcm7xxx: Fixed indirect MMD operations

Greg Kroah-Hartman (1):
      Linux 4.19.212

Jeremy Sowden (1):
      netfilter: ip6_tables: zero-initialize fragment offset

Jiapeng Chong (1):
      scsi: ses: Fix unsigned comparison with less than zero

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

王贇 (1):
      net: prevent user from passing illegal stab size

