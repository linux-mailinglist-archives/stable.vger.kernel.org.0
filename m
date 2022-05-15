Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14FA7527945
	for <lists+stable@lfdr.de>; Sun, 15 May 2022 20:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238467AbiEOSrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 May 2022 14:47:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238466AbiEOSr1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 May 2022 14:47:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D9513D05;
        Sun, 15 May 2022 11:47:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 082A8B80E0B;
        Sun, 15 May 2022 18:47:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4000EC385B8;
        Sun, 15 May 2022 18:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652640443;
        bh=C0fvbAVTPPaBEmS62tLssCt4aCrajAA6sX/vSHmYmB4=;
        h=From:To:Cc:Subject:Date:From;
        b=kmeizFn2H8hiOmkj8x71VenKR22TJZdW6yjhND1DHqnvl9tsJzkhylF/ReJ/TK/T0
         Ovck4OY1RD62qtvR7szVpqpc/kDpJiikn8SZ8QpSgiiaKsbq9GJaMHKsLO68GpifCJ
         3w+yM0EnfPvi2zCT97zMk+Mjlr8o6hsC+vnpoW3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Linux 5.4.194
Date:   Sun, 15 May 2022 20:47:09 +0200
Message-Id: <165264042915756@kroah.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm announcing the release of the 5.4.194 kernel.

All users of the 5.4 kernel series must upgrade.

The updated 5.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-5.4.y
and can be browsed at the normal kernel.org git web browser:
	https://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

thanks,

greg k-h

------------

 Documentation/vm/memory-model.rst                            |    3 
 Makefile                                                     |    2 
 arch/arm/Kconfig                                             |    8 --
 arch/arm/mach-bcm/Kconfig                                    |    1 
 arch/arm/mach-davinci/Kconfig                                |    1 
 arch/arm/mach-exynos/Kconfig                                 |    1 
 arch/arm/mach-highbank/Kconfig                               |    1 
 arch/arm/mach-omap2/Kconfig                                  |    2 
 arch/arm/mach-s5pv210/Kconfig                                |    1 
 arch/arm/mach-tango/Kconfig                                  |    1 
 arch/mips/bmips/setup.c                                      |    2 
 arch/mips/lantiq/prom.c                                      |    2 
 arch/mips/pic32/pic32mzda/init.c                             |    2 
 arch/mips/ralink/of.c                                        |    2 
 arch/x86/include/asm/asm.h                                   |    8 +-
 arch/x86/include/asm/emulate_prefix.h                        |   14 ++++
 arch/x86/include/asm/insn.h                                  |    6 +
 arch/x86/include/asm/xen/interface.h                         |   11 +--
 arch/x86/kernel/kprobes/core.c                               |    4 +
 arch/x86/kvm/pmu.c                                           |    8 --
 arch/x86/kvm/pmu.h                                           |    3 
 arch/x86/kvm/pmu_amd.c                                       |   36 ++++++++--
 arch/x86/kvm/vmx/pmu_intel.c                                 |    9 +-
 arch/x86/kvm/x86.c                                           |    4 -
 arch/x86/lib/insn.c                                          |   34 +++++++++
 drivers/block/drbd/drbd_nl.c                                 |   13 ++-
 drivers/gpu/drm/amd/display/dc/gpio/gpio_service.c           |   12 +--
 drivers/gpu/drm/amd/display/include/gpio_service_interface.h |    4 -
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c               |    2 
 drivers/net/can/grcan.c                                      |   38 +++++------
 drivers/net/ethernet/netronome/nfp/nfp_asm.c                 |    4 -
 fs/proc/kcore.c                                              |    2 
 include/linux/mmzone.h                                       |   31 --------
 include/net/bluetooth/hci_core.h                             |    3 
 mm/memory.c                                                  |    2 
 mm/migrate.c                                                 |    7 +-
 mm/mmzone.c                                                  |   14 ----
 mm/userfaultfd.c                                             |    3 
 mm/vmstat.c                                                  |    4 -
 net/bluetooth/hci_core.c                                     |    6 -
 tools/arch/x86/include/asm/emulate_prefix.h                  |   14 ++++
 tools/arch/x86/include/asm/insn.h                            |    6 +
 tools/arch/x86/lib/insn.c                                    |   34 +++++++++
 tools/objtool/sync-check.sh                                  |    3 
 tools/perf/check-headers.sh                                  |    3 
 45 files changed, 226 insertions(+), 145 deletions(-)

Andreas Larsson (2):
      can: grcan: grcan_probe(): fix broken system id check for errata workaround needs
      can: grcan: only use the NAPI poll budget for RX

Greg Kroah-Hartman (1):
      Linux 5.4.194

Itay Iellin (1):
      Bluetooth: Fix the creation of hdev->name

Kyle Huey (1):
      KVM: x86/svm: Account for family 17h event renumberings in amd_pmc_perf_hw_id

Lee Jones (2):
      block: drbd: drbd_nl: Make conversion to 'enum drbd_ret_code' explicit
      drm/amd/display/dc/gpio/gpio_service: Pass around correct dce_{version, environment} types

Like Xu (1):
      KVM: x86/pmu: Refactoring find_arch_event() to pmc_perf_hw_id()

Masami Hiramatsu (4):
      x86/asm: Allow to pass macros to __ASM_FORM()
      x86: xen: kvm: Gather the definition of emulate prefixes
      x86: xen: insn: Decode Xen and KVM emulate-prefix signature
      x86: kprobes: Prohibit probing on instruction which has emulate prefix

Mike Rapoport (1):
      arm: remove CONFIG_ARCH_HAS_HOLES_MEMORYMODEL

Muchun Song (3):
      mm: fix missing cache flush for all tail pages of compound page
      mm: hugetlb: fix missing cache flush in copy_huge_page_from_user()
      mm: userfaultfd: fix missing cache flush in mcopy_atomic_pte() and __mcopy_atomic()

Nathan Chancellor (3):
      MIPS: Use address-of operator on section symbols
      drm/i915: Cast remain to unsigned long in eb_relocate_vma
      nfp: bpf: silence bitwise vs. logical OR warning

