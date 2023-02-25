Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA62E6A2945
	for <lists+stable@lfdr.de>; Sat, 25 Feb 2023 12:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229482AbjBYLJk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Feb 2023 06:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjBYLJk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Feb 2023 06:09:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B632218B0E;
        Sat, 25 Feb 2023 03:09:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06F1360AF7;
        Sat, 25 Feb 2023 11:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F649C433EF;
        Sat, 25 Feb 2023 11:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677323343;
        bh=c6yZ2vZSX5yiEBLmOw5oh8PkR7pcwliu3LmLXQQB5ak=;
        h=From:To:Cc:Subject:Date:From;
        b=xNThH1MA0aWpXIZfGr3c61dgpEkh7729ZDZjlHNIc9Mm7OA7+7clJ+08w7HHijVOp
         6fLrVMgKyMOZ8JcQK26Xw5YJvaUwbz1S/jwe989OcBeQiEwBSOAgAFq7gtYqUm6vnW
         vQEjHX7jZoP/S6TJnyVxlrfspkaWZeHIkjZvGjYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.15.96
Date:   Sat, 25 Feb 2023 12:08:54 +0100
Message-Id: <167732333583191@kroah.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.15.96 kernel.

All users of the 5.15 kernel series must upgrade.

The updated 5.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.15.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 MAINTAINERS                                           |    3 
 Makefile                                              |    2 
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi    |   44 ++
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi    |   44 ++
 arch/powerpc/boot/dts/fsl/t2081si-post.dtsi           |   20 -
 arch/powerpc/include/asm/sections.h                   |   14 
 arch/powerpc/kernel/vmlinux.lds.S                     |   14 
 arch/powerpc/mm/book3s32/mmu.c                        |    2 
 arch/powerpc/mm/book3s64/radix_pgtable.c              |   28 +
 arch/x86/kvm/svm/svm.c                                |   10 
 arch/x86/kvm/vmx/nested.c                             |   11 
 arch/x86/kvm/vmx/vmx.c                                |    6 
 arch/x86/kvm/x86.c                                    |    4 
 drivers/android/binder.c                              |  343 ++++++++++++++++--
 drivers/block/nbd.c                                   |   23 -
 drivers/clk/x86/Kconfig                               |    5 
 drivers/clk/x86/clk-cgu-pll.c                         |   23 -
 drivers/clk/x86/clk-cgu.c                             |  106 +----
 drivers/clk/x86/clk-cgu.h                             |   46 +-
 drivers/clk/x86/clk-lgm.c                             |   18 
 drivers/gpu/drm/drm_edid.c                            |    3 
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c                 |    4 
 drivers/gpu/drm/i915/gvt/gtt.c                        |   17 
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c     |   33 +
 drivers/net/wireless/marvell/mwifiex/sdio.c           |    1 
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c |    8 
 fs/ext4/sysfs.c                                       |    7 
 include/linux/nospec.h                                |    4 
 include/linux/random.h                                |    6 
 init/Kconfig                                          |    4 
 kernel/bpf/core.c                                     |    3 
 lib/Kconfig.debug                                     |    4 
 lib/usercopy.c                                        |    7 
 net/sched/sch_taprio.c                                |    8 
 scripts/pahole-flags.sh                               |    2 
 scripts/pahole-version.sh                             |   13 
 36 files changed, 660 insertions(+), 230 deletions(-)

Alessandro Astone (2):
      binder: Address corner cases in deferred copy and fixup
      binder: Gracefully handle BINDER_TYPE_FDA objects with num_fds=0

Ankit Nautiyal (1):
      drm/edid: Fix minimum bpc supported with DSC1.2 for HDMI sink

Arnd Bergmann (1):
      binder: fix pointer cast warning

Bitterblue Smith (1):
      wifi: rtl8xxxu: gen2: Turn on the rate control

Christophe Leroy (1):
      powerpc: use generic version of arch_is_kernel_initmem_freed()

Dave Hansen (1):
      uaccess: Add speculation barrier to copy_from_user()

Greg Kroah-Hartman (1):
      Linux 5.15.96

Jason A. Donenfeld (1):
      random: always mix cycle counter in add_latent_entropy()

Jim Mattson (1):
      KVM: VMX: Execute IBPB on emulated VM-exit when guest has IBRS

Kees Cook (1):
      ext4: Fix function prototype mismatch for ext4_feat_ktype

Linus Torvalds (1):
      bpf: add missing header file include

Lucas Stach (1):
      drm/etnaviv: don't truncate physical page address

Lukas Wunner (1):
      wifi: mwifiex: Add missing compatible string for SD8787

Marc Kleine-Budde (1):
      can: kvaser_usb: hydra: help gcc-13 to figure out cmd_len

Michael Ellerman (4):
      powerpc/vmlinux.lds: Ensure STRICT_ALIGN_SIZE is at least page aligned
      powerpc/vmlinux.lds: Add an explicit symbol for the SRWX boundary
      powerpc/64s/radix: Fix crash with unaligned relocated kernel
      powerpc/64s/radix: Fix RWX mapping with relocated kernel

Nathan Chancellor (4):
      kbuild: Add CONFIG_PAHOLE_VERSION
      scripts/pahole-flags.sh: Use pahole-version.sh
      lib/Kconfig.debug: Use CONFIG_PAHOLE_VERSION
      lib/Kconfig.debug: Allow BTF + DWARF5 with pahole 1.21+

Paul Moore (1):
      audit: update the mailing list in MAINTAINERS

Rahul Tanwar (5):
      clk: mxl: Switch from direct readl/writel based IO to regmap based IO
      clk: mxl: Remove redundant spinlocks
      clk: mxl: Add option to override gate clks
      clk: mxl: Fix a clk entry by adding relevant flags
      clk: mxl: syscon_node_to_regmap() returns error pointers

Sean Anderson (2):
      powerpc: dts: t208x: Mark MAC1 and MAC2 as 10G
      powerpc: dts: t208x: Disable 10G on MAC1 and MAC2

Sean Christopherson (2):
      KVM: x86: Fail emulation during EMULTYPE_SKIP on any exception
      KVM: SVM: Skip WRMSR fastpath on VM-Exit if next RIP isn't valid

Todd Kjos (2):
      binder: read pre-translated fds from sender buffer
      binder: defer copies of pre-patched txn data

Vladimir Oltean (1):
      Revert "net/sched: taprio: make qdisc_leaf() see the per-netdev-queue pfifo child qdiscs"

Zhang Wensheng (1):
      nbd: fix possible overflow on 'first_minor' in nbd_dev_add()

Zheng Wang (1):
      drm/i915/gvt: fix double free bug in split_2MB_gtt_entry

