Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E178B31613B
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 09:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbhBJIjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 03:39:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:49254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229517AbhBJIir (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Feb 2021 03:38:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2353C64E25;
        Wed, 10 Feb 2021 08:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612946286;
        bh=BssUeBQvYH3t/9ebcXx9g8mBArj87b9wn78bdZP8l/Q=;
        h=From:To:Cc:Subject:Date:From;
        b=2lMQztVH4YAa3h8Mky/yyGgnfCT6ES6UWH8OwEMfe0o11xrC939vlZnDBawJ3U4tp
         QJONnSAh3aAsyl+MhBXAHdKcijU4zKODK0ogZlrhUqdriyuZhJt6lgh7YNeLjpnWRO
         j6tMezrot7Md03CeiBXWCuSP15m49PfUBEfqxQx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 4.4.257
Date:   Wed, 10 Feb 2021 09:38:02 +0100
Message-Id: <1612946282192196@kroah.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 4.4.257 kernel.

All users of the 4.4 kernel series must upgrade.

The updated 4.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-4.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                              |   10 -
 arch/arm/mach-footbridge/dc21285.c    |   12 -
 arch/mips/Kconfig                     |    1 
 arch/x86/Makefile                     |    3 
 arch/x86/include/asm/apic.h           |   10 -
 arch/x86/include/asm/barrier.h        |   18 ++
 arch/x86/kernel/apic/apic.c           |    4 
 arch/x86/kernel/apic/x2apic_cluster.c |    3 
 arch/x86/kernel/apic/x2apic_phys.c    |    3 
 drivers/acpi/thermal.c                |   54 ++++--
 drivers/input/joystick/xpad.c         |   17 +-
 drivers/input/serio/i8042-x86ia64io.h |    2 
 drivers/mmc/core/sdio_cis.c           |    6 
 drivers/scsi/ibmvscsi/ibmvfc.c        |    4 
 drivers/scsi/libfc/fc_exch.c          |   16 +
 drivers/usb/class/usblp.c             |   19 +-
 drivers/usb/dwc2/gadget.c             |    8 
 drivers/usb/gadget/legacy/ether.c     |    4 
 drivers/usb/gadget/udc/udc-core.c     |   13 +
 drivers/usb/serial/cp210x.c           |    2 
 drivers/usb/serial/option.c           |    6 
 fs/Kconfig.binfmt                     |    8 
 fs/cifs/dir.c                         |   22 ++
 fs/hugetlbfs/inode.c                  |    3 
 include/linux/elfcore.h               |   22 ++
 include/linux/hugetlb.h               |    3 
 kernel/Makefile                       |    3 
 kernel/elfcore.c                      |   25 ---
 kernel/futex.c                        |  278 +++++++++++++++++++---------------
 kernel/kprobes.c                      |    4 
 kernel/locking/rtmutex-debug.c        |    9 -
 kernel/locking/rtmutex-debug.h        |    3 
 kernel/locking/rtmutex.c              |  127 +++++++++------
 kernel/locking/rtmutex.h              |    2 
 kernel/locking/rtmutex_common.h       |   12 -
 mm/hugetlb.c                          |    9 -
 net/lapb/lapb_out.c                   |    3 
 net/mac80211/driver-ops.c             |    5 
 net/mac80211/rate.c                   |    3 
 net/sched/sch_api.c                   |    3 
 sound/pci/hda/patch_realtek.c         |    2 
 41 files changed, 468 insertions(+), 293 deletions(-)

Alexey Dobriyan (1):
      Input: i8042 - unbreak Pegatron C15B

Arnd Bergmann (1):
      elfcore: fix building with clang

Aurelien Aptel (1):
      cifs: report error instead of invalid when revalidating a dentry fails

Benjamin Valentin (1):
      Input: xpad - sync supported devices with fork on GitHub

Brian King (1):
      scsi: ibmvfc: Set default timeout to avoid crash during migration

Chenxin Jin (1):
      USB: serial: cp210x: add new VID/PID for supporting Teraoka AD2000

Christoph Schemmel (1):
      USB: serial: option: Adding support for Cinterion MV31

Dan Carpenter (1):
      USB: gadget: legacy: fix an error code in eth_bind()

Dave Hansen (1):
      x86/apic: Add extra serialization for non-serializing MSRs

Eric Dumazet (1):
      net_sched: reject silly cell_log in qdisc_get_rtab()

Felix Fietkau (1):
      mac80211: fix station rate table updates on assoc

Fengnan Chang (1):
      mmc: core: Limit retries when analyse of SDIO tuples fails

Greg Kroah-Hartman (1):
      Linux 4.4.257

Heiko Stuebner (1):
      usb: dwc2: Fix endpoint direction check in ep_from_windex

Javed Hasan (1):
      scsi: libfc: Avoid invoking response handler twice if ep is already completed

Jeremy Figgins (1):
      USB: usblp: don't call usb_set_interface if there's a single alt

Josh Poimboeuf (1):
      x86/build: Disable CET instrumentation in the kernel

Lee Jones (10):
      futex,rt_mutex: Provide futex specific rt_mutex API
      futex: Remove rt_mutex_deadlock_account_*()
      futex: Rework inconsistent rt_mutex/futex_q state
      futex: Avoid violating the 10th rule of futex
      futex: Replace pointless printk in fixup_owner()
      futex: Provide and use pi_state_update_owner()
      rtmutex: Remove unused argument from rt_mutex_proxy_unlock()
      futex: Use pi_state_update_owner() in put_pi_state()
      futex: Simplify fixup_pi_state_owner()
      futex: Handle faults correctly for PI futexes

Muchun Song (3):
      mm: hugetlbfs: fix cannot migrate the fallocated HugeTLB page
      mm: hugetlb: fix a race between isolating and freeing page
      mm: hugetlb: remove VM_BUG_ON_PAGE from page_huge_active

Pho Tran (1):
      USB: serial: cp210x: add pid/vid for WSDA-200-USB

Rafael J. Wysocki (1):
      ACPI: thermal: Do not call acpi_thermal_check() directly

Ralf Baechle (1):
      ELF/MIPS build fix

Russell King (1):
      ARM: footbridge: fix dc21285 PCI configuration accessors

Sasha Levin (1):
      stable: clamp SUBLEVEL in 4.4 and 4.9

Shih-Yuan Lee (FourDollars) (1):
      ALSA: hda/realtek - Fix typo of pincfg for Dell quirk

Thinh Nguyen (1):
      usb: udc: core: Use lock when write to soft_connect

Wang ShaoBo (1):
      kretprobe: Avoid re-registration of the same kretprobe earlier

Xie He (1):
      net: lapb: Copy the skb before sending a packet

