Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C4036D7B7
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 14:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236514AbhD1Myd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 08:54:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235549AbhD1Myb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Apr 2021 08:54:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 312DD61407;
        Wed, 28 Apr 2021 12:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619614423;
        bh=yGoWvSMujpm5g0rv0pwcyOMMi00FOE06yluBXftPCmg=;
        h=From:To:Cc:Subject:Date:From;
        b=KmahOYlVzPfPTuYyZy5vmcDagEg5h0osJjGg25uVKpW3lU/0QCjM14EjJM52Bd+lT
         UWOVZZpP8O+Ct/S51y9Sv2aCNJFtx4TT6feM9HPvkIPDnIPOz2iTGUvLzuLxqUGdur
         eIOBh6nSc6jlxNeeXU+3920aEy00QeAgTMQhV0v8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.115
Date:   Wed, 28 Apr 2021 14:53:39 +0200
Message-Id: <161961441913867@kroah.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.115 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                                |    2 
 arch/arm/boot/dts/omap3.dtsi                            |    3 
 arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-lts.dts |    2 
 arch/csky/Kconfig                                       |    2 
 arch/csky/include/asm/page.h                            |    2 
 arch/ia64/mm/discontig.c                                |    6 -
 arch/s390/kernel/entry.S                                |    1 
 arch/s390/kernel/ptrace.c                               |   17 +++-
 arch/x86/events/intel/core.c                            |    2 
 arch/x86/events/intel/uncore_snbep.c                    |   61 ++++++----------
 arch/x86/kernel/crash.c                                 |    2 
 drivers/gpio/gpio-omap.c                                |    9 ++
 drivers/hid/hid-alps.c                                  |    1 
 drivers/hid/hid-google-hammer.c                         |    2 
 drivers/hid/hid-ids.h                                   |    1 
 drivers/hid/wacom_wac.c                                 |    2 
 drivers/net/ethernet/cavium/liquidio/cn66xx_regs.h      |    2 
 drivers/net/geneve.c                                    |    6 +
 drivers/net/usb/hso.c                                   |    2 
 drivers/net/xen-netback/xenbus.c                        |   12 ++-
 drivers/pinctrl/intel/pinctrl-lewisburg.c               |    6 -
 drivers/usb/class/cdc-acm.c                             |    3 
 include/linux/platform_data/gpio-omap.h                 |    3 
 kernel/locking/qrwlock.c                                |    7 +
 tools/arch/ia64/include/asm/barrier.h                   |    3 
 tools/perf/util/auxtrace.c                              |    2 
 26 files changed, 94 insertions(+), 67 deletions(-)

Ali Saidi (1):
      locking/qrwlock: Fix ordering in queued_write_lock_slowpath()

Andre Przywara (1):
      arm64: dts: allwinner: Revert SD card CD GPIO for Pine64-LTS

Greg Kroah-Hartman (1):
      Linux 5.4.115

Jia-Ju Bai (1):
      HID: alps: fix error return code in alps_input_configured()

Jiapeng Zhong (1):
      HID: wacom: Assign boolean values to a bool variable

Jim Mattson (1):
      perf/x86/kvm: Fix Broadwell Xeon stepping in isolation_ucodes[]

Johan Hovold (1):
      net: hso: fix NULL-deref on disconnect regression

John Paul Adrian Glaubitz (1):
      ia64: tools: remove duplicate definition of ia64_mf() on ia64

Kan Liang (1):
      perf/x86/intel/uncore: Remove uncore extra PCI dev HSWEP_PCI_PCU_3

Leo Yan (1):
      perf auxtrace: Fix potential NULL pointer dereference

Michael Brown (1):
      xen-netback: Check for hotplug-status existence before watching

Mike Galbraith (1):
      x86/crash: Fix crash_setup_memmap_entries() out-of-bounds access

Oliver Neukum (1):
      USB: CDC-ACM: fix poison/unpoison imbalance

Phillip Potter (1):
      net: geneve: check skb is large enough for IPv4/IPv6 header

Randy Dunlap (2):
      csky: change a Kconfig symbol name to fix e1000 build error
      ia64: fix discontig.c section mismatches

Shou-Chieh Hsu (1):
      HID: google: add don USB id

Sven Schnelle (1):
      s390/ptrace: return -ENOSYS when invalid syscall is supplied

Tony Lindgren (2):
      gpio: omap: Save and restore sysconfig
      ARM: dts: Fix swapped mmc order for omap3

Vasily Gorbik (1):
      s390/entry: save the caller of psw_idle

Wan Jiabing (1):
      cavium/liquidio: Fix duplicate argument

Yuanyuan Zhong (1):
      pinctrl: lewisburg: Update number of pins in community

