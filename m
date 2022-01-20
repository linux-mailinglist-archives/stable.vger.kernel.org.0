Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7BF4949ED
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 09:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359400AbiATIr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 03:47:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359388AbiATIrv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 03:47:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A09BC06173F;
        Thu, 20 Jan 2022 00:47:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0D35B81CED;
        Thu, 20 Jan 2022 08:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDE9C340E0;
        Thu, 20 Jan 2022 08:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642668466;
        bh=25iE4WEL40R7PhiT7NNAbnx0Zl7GHdrs2smXehKX/R4=;
        h=From:To:Cc:Subject:Date:From;
        b=mMuEziFPQZaA51CgfazHrOL1jQr0tke+20ZsF7pB5P1X0XPQYgIDQmtmyXn2v0Q9a
         dTRZDeemnZdsdx/fSO7O3l7ymgL+ySvDVnY73imFWx7LxV0hb53xI6s1h7NHz4Ctng
         sn/8gGIDVl8pAcJ0UEXXSXeHpV5yoJ0MQysUr66Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.173
Date:   Thu, 20 Jan 2022 09:47:42 +0100
Message-Id: <164266846389242@kroah.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.173 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Makefile                                            |    4 +-
 arch/arm/kernel/perf_callchain.c                    |   17 +++++++----
 arch/arm/mm/Kconfig                                 |    1 
 arch/arm64/kernel/perf_callchain.c                  |   18 ++++++++----
 arch/csky/kernel/perf_callchain.c                   |    6 ++--
 arch/nds32/kernel/perf_event_cpu.c                  |   17 +++++++----
 arch/riscv/kernel/perf_callchain.c                  |    7 +++-
 arch/s390/kvm/interrupt.c                           |    7 ++++
 arch/s390/kvm/kvm-s390.c                            |    9 ++++--
 arch/s390/kvm/kvm-s390.h                            |    1 
 arch/s390/kvm/sigp.c                                |   28 ++++++++++++++++++
 arch/x86/events/core.c                              |   17 +++++++----
 arch/x86/events/intel/core.c                        |    9 ++++--
 arch/x86/kvm/x86.c                                  |    2 -
 drivers/base/devtmpfs.c                             |    8 +++++
 drivers/firmware/qemu_fw_cfg.c                      |   20 +++++--------
 drivers/media/usb/uvc/uvc_video.c                   |    4 ++
 drivers/mtd/chips/Kconfig                           |    2 +
 drivers/mtd/maps/Kconfig                            |    2 -
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c |    1 
 fs/fs_context.c                                     |    2 -
 fs/orangefs/orangefs-bufmap.c                       |    7 ++--
 fs/super.c                                          |    4 +-
 include/linux/fs_context.h                          |    2 +
 include/linux/perf_event.h                          |   13 ++++++++
 kernel/events/core.c                                |   13 ++++++--
 sound/pci/hda/patch_realtek.c                       |   30 +++++++++++++++++++-
 27 files changed, 190 insertions(+), 61 deletions(-)

Arnd Bergmann (1):
      mtd: fixup CFI on ixp4xx

Christian Lachner (1):
      ALSA: hda/realtek - Fix silent output on Gigabyte X570 Aorus Master after reboot from Windows

Christophe JAILLET (1):
      orangefs: Fix the size of a memory allocation in orangefs_bufmap_alloc()

Eric Farman (1):
      KVM: s390: Clarify SIGP orders versus STOP/RESTART

Greg Kroah-Hartman (1):
      Linux 5.4.173

Jamie Hill-Daniel (1):
      vfs: fs_context: fix up param length parsing in legacy_parse_param

Johan Hovold (4):
      media: uvcvideo: fix division by zero at stream start
      firmware: qemu_fw_cfg: fix sysfs information leak
      firmware: qemu_fw_cfg: fix NULL-pointer deref on duplicate entries
      firmware: qemu_fw_cfg: fix kobject leak in probe error path

Larry Finger (1):
      rtlwifi: rtl8192cu: Fix WARNING when calling local_irq_restore() with interrupts enabled

Nathan Chancellor (1):
      kbuild: Add $(KBUILD_HOSTLDFLAGS) to 'has_libelf' test

NeilBrown (1):
      devtmpfs regression fix: reconfigure on each mount

Nick Desaulniers (1):
      ARM: 9025/1: Kconfig: CPU_BIG_ENDIAN depends on !LD_IS_LLD

Sean Christopherson (1):
      perf: Protect perf_guest_cbs with RCU

Wei Wang (1):
      KVM: x86: remove PMU FIXED_CTR3 from msrs_to_save_all

