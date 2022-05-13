Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D871526440
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380885AbiEMO2c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380874AbiEMO1c (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:27:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A2152B03;
        Fri, 13 May 2022 07:27:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5AC7B82C9D;
        Fri, 13 May 2022 14:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15710C34118;
        Fri, 13 May 2022 14:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652452036;
        bh=pcIxy5YNkTrj36jxGeFlMJcSFdAeZ1inj3nyLG9iOOs=;
        h=From:To:Cc:Subject:Date:From;
        b=dr2rLjngEFZFw3t4ODccsavAgPyrDRn+0aCJAJTDd/VRoAo2n9k0y5oehWvdHXz6P
         rOhJMSrIrcHQHfS5/jAIbPuO51XMWlJqB43/zH6cIJ5d7QlN4FG3qz1yyrZ6qMSFAq
         4U3eFeo/tJZle0ANpnpc2yWkj7/8zW3h9GgeVogU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.4 00/18] 5.4.194-rc1 review
Date:   Fri, 13 May 2022 16:23:26 +0200
Message-Id: <20220513142229.153291230@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.194-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.194-rc1
X-KernelTest-Deadline: 2022-05-15T14:22+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.194 release.
There are 18 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.194-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.194-rc1

Muchun Song <songmuchun@bytedance.com>
    mm: userfaultfd: fix missing cache flush in mcopy_atomic_pte() and __mcopy_atomic()

Muchun Song <songmuchun@bytedance.com>
    mm: hugetlb: fix missing cache flush in copy_huge_page_from_user()

Muchun Song <songmuchun@bytedance.com>
    mm: fix missing cache flush for all tail pages of compound page

Itay Iellin <ieitayie@gmail.com>
    Bluetooth: Fix the creation of hdev->name

Kyle Huey <me@kylehuey.com>
    KVM: x86/svm: Account for family 17h event renumberings in amd_pmc_perf_hw_id

Masami Hiramatsu <mhiramat@kernel.org>
    x86: kprobes: Prohibit probing on instruction which has emulate prefix

Masami Hiramatsu <mhiramat@kernel.org>
    x86: xen: insn: Decode Xen and KVM emulate-prefix signature

Masami Hiramatsu <mhiramat@kernel.org>
    x86: xen: kvm: Gather the definition of emulate prefixes

Masami Hiramatsu <mhiramat@kernel.org>
    x86/asm: Allow to pass macros to __ASM_FORM()

Like Xu <likexu@tencent.com>
    KVM: x86/pmu: Refactoring find_arch_event() to pmc_perf_hw_id()

Mike Rapoport <rppt@linux.ibm.com>
    arm: remove CONFIG_ARCH_HAS_HOLES_MEMORYMODEL

Andreas Larsson <andreas@gaisler.com>
    can: grcan: only use the NAPI poll budget for RX

Andreas Larsson <andreas@gaisler.com>
    can: grcan: grcan_probe(): fix broken system id check for errata workaround needs

Nathan Chancellor <nathan@kernel.org>
    nfp: bpf: silence bitwise vs. logical OR warning

Nathan Chancellor <natechancellor@gmail.com>
    drm/i915: Cast remain to unsigned long in eb_relocate_vma

Lee Jones <lee.jones@linaro.org>
    drm/amd/display/dc/gpio/gpio_service: Pass around correct dce_{version, environment} types

Lee Jones <lee.jones@linaro.org>
    block: drbd: drbd_nl: Make conversion to 'enum drbd_ret_code' explicit

Nathan Chancellor <natechancellor@gmail.com>
    MIPS: Use address-of operator on section symbols


-------------

Diffstat:

 Documentation/vm/memory-model.rst                  |  3 +-
 Makefile                                           |  4 +--
 arch/arm/Kconfig                                   |  8 ++---
 arch/arm/mach-bcm/Kconfig                          |  1 -
 arch/arm/mach-davinci/Kconfig                      |  1 -
 arch/arm/mach-exynos/Kconfig                       |  1 -
 arch/arm/mach-highbank/Kconfig                     |  1 -
 arch/arm/mach-omap2/Kconfig                        |  2 +-
 arch/arm/mach-s5pv210/Kconfig                      |  1 -
 arch/arm/mach-tango/Kconfig                        |  1 -
 arch/mips/bmips/setup.c                            |  2 +-
 arch/mips/lantiq/prom.c                            |  2 +-
 arch/mips/pic32/pic32mzda/init.c                   |  2 +-
 arch/mips/ralink/of.c                              |  2 +-
 arch/x86/include/asm/asm.h                         |  8 +++--
 arch/x86/include/asm/emulate_prefix.h              | 14 ++++++++
 arch/x86/include/asm/insn.h                        |  6 ++++
 arch/x86/include/asm/xen/interface.h               | 11 +++----
 arch/x86/kernel/kprobes/core.c                     |  4 +++
 arch/x86/kvm/pmu.c                                 |  8 +----
 arch/x86/kvm/pmu.h                                 |  3 +-
 arch/x86/kvm/pmu_amd.c                             | 36 ++++++++++++++++----
 arch/x86/kvm/vmx/pmu_intel.c                       |  9 ++---
 arch/x86/kvm/x86.c                                 |  4 ++-
 arch/x86/lib/insn.c                                | 34 +++++++++++++++++++
 drivers/block/drbd/drbd_nl.c                       | 13 +++++---
 drivers/gpu/drm/amd/display/dc/gpio/gpio_service.c | 12 +++----
 .../amd/display/include/gpio_service_interface.h   |  4 +--
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c     |  2 +-
 drivers/net/can/grcan.c                            | 38 ++++++++++------------
 drivers/net/ethernet/netronome/nfp/nfp_asm.c       |  4 +--
 fs/proc/kcore.c                                    |  2 --
 include/linux/mmzone.h                             | 31 ------------------
 include/net/bluetooth/hci_core.h                   |  3 ++
 mm/memory.c                                        |  2 ++
 mm/migrate.c                                       |  7 ++--
 mm/mmzone.c                                        | 14 --------
 mm/userfaultfd.c                                   |  3 ++
 mm/vmstat.c                                        |  4 ---
 net/bluetooth/hci_core.c                           |  6 ++--
 tools/arch/x86/include/asm/emulate_prefix.h        | 14 ++++++++
 tools/arch/x86/include/asm/insn.h                  |  6 ++++
 tools/arch/x86/lib/insn.c                          | 34 +++++++++++++++++++
 tools/objtool/sync-check.sh                        |  3 +-
 tools/perf/check-headers.sh                        |  3 +-
 45 files changed, 227 insertions(+), 146 deletions(-)


