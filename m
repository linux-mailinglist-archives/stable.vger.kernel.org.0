Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD7663124E7
	for <lists+stable@lfdr.de>; Sun,  7 Feb 2021 16:06:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229683AbhBGPGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Feb 2021 10:06:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:54432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhBGPGS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Feb 2021 10:06:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1DE760200;
        Sun,  7 Feb 2021 15:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612710338;
        bh=BYYSNtV13yL8eX9PZqdB9UmpvT64utuV+LDT48qylTc=;
        h=From:To:Cc:Subject:Date:From;
        b=Aqa108xHBXcEoviSUW+WIJnJ9XTJY0KUjtvPAN7m2njusQVdUUCQjExBf0Ots9RZE
         uCMwlz4n0J1dgAihtn3jGwTrUqYF3rM97zhMo4IEz8KniB162FterrkMLI8aL4H59B
         C2IgtgkwE0/TGK6uY6b2IrnI24Cx4L7rTkGVE2JQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.14.220
Date:   Sun,  7 Feb 2021 16:05:34 +0100
Message-Id: <161271033418137@kroah.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.14.220 kernel.

All users of the 4.14 kernel series must upgrade.

The updated 4.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.14.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                             |    2 -
 arch/x86/include/asm/msr.h           |    4 +-
 drivers/acpi/thermal.c               |   55 ++++++++++++++++++++++++-----------
 drivers/base/core.c                  |   19 ++++++++++--
 drivers/net/dsa/bcm_sf2.c            |    8 +++--
 drivers/net/ethernet/ibm/ibmvnic.c   |    6 +++
 drivers/phy/motorola/phy-cpcap-usb.c |   19 ++++++++----
 drivers/scsi/ibmvscsi/ibmvfc.c       |    4 +-
 drivers/scsi/libfc/fc_exch.c         |   16 ++++++++--
 drivers/scsi/scsi_transport_srp.c    |    9 +++++
 include/linux/kthread.h              |    3 +
 kernel/kthread.c                     |   27 ++++++++++++++++-
 kernel/smpboot.c                     |    1 
 net/core/gen_estimator.c             |   11 ++++---
 net/mac80211/rx.c                    |    2 +
 net/sched/sch_api.c                  |    3 +
 tools/objtool/elf.c                  |    7 +++-
 17 files changed, 154 insertions(+), 42 deletions(-)

Benjamin Gaignard (1):
      base: core: Remove WARN_ON from link dependencies check

Brian King (1):
      scsi: ibmvfc: Set default timeout to avoid crash during migration

Eric Dumazet (2):
      net_sched: reject silly cell_log in qdisc_get_rtab()
      net_sched: gen_estimator: support large ewma log

Felix Fietkau (1):
      mac80211: fix fast-rx encryption check

Greg Kroah-Hartman (1):
      Linux 4.14.220

Javed Hasan (1):
      scsi: libfc: Avoid invoking response handler twice if ep is already completed

Josh Poimboeuf (1):
      objtool: Don't fail on missing symbol table

Lijun Pan (1):
      ibmvnic: Ensure that CRQ entry read are correctly ordered

Martin Wilck (1):
      scsi: scsi_transport_srp: Don't block target in failfast state

Pan Bian (1):
      net: dsa: bcm_sf2: put device node before return

Peter Zijlstra (2):
      x86: __always_inline __{rd,wr}msr()
      kthread: Extract KTHREAD_IS_PER_CPU

Rafael J. Wysocki (2):
      ACPI: thermal: Do not call acpi_thermal_check() directly
      driver core: Extend device_is_dependent()

Tony Lindgren (1):
      phy: cpcap-usb: Fix warning for missing regulator_disable

