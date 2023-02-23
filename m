Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 197E26A0A30
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234508AbjBWNN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:13:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234528AbjBWNNV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:13:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE911AD09;
        Thu, 23 Feb 2023 05:12:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E852EB81A27;
        Thu, 23 Feb 2023 13:12:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A300C433EF;
        Thu, 23 Feb 2023 13:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157940;
        bh=hmwBEY9lOp9OIoKwQUe+3HQgpbQ2awX8Bpb2QgkdhUM=;
        h=From:To:Cc:Subject:Date:From;
        b=spgUWjJ5AFmjIjNZtSBIVZnqBTzcVGzSSqOsUbDGI+8Zjp7gaM4qTnn/u6hSPpPyo
         fTRbz5/bKg+pc8zMxmn6gdTgz+zgg6Vbmogl/8WylRhCyQWBWzixFJ09HdMYinxcX/
         +PXll7JI7eYhQ/aFpNIRCD/Epyal+LjFm/C/qPR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.15 00/36] 5.15.96-rc1 review
Date:   Thu, 23 Feb 2023 14:06:36 +0100
Message-Id: <20230223130429.072633724@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.96-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.96-rc1
X-KernelTest-Deadline: 2023-02-25T13:04+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.96 release.
There are 36 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 25 Feb 2023 13:04:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.96-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.96-rc1

Vladimir Oltean <vladimir.oltean@nxp.com>
    Revert "net/sched: taprio: make qdisc_leaf() see the per-netdev-queue pfifo child qdiscs"

Nathan Chancellor <nathan@kernel.org>
    lib/Kconfig.debug: Allow BTF + DWARF5 with pahole 1.21+

Nathan Chancellor <nathan@kernel.org>
    lib/Kconfig.debug: Use CONFIG_PAHOLE_VERSION

Nathan Chancellor <nathan@kernel.org>
    scripts/pahole-flags.sh: Use pahole-version.sh

Nathan Chancellor <nathan@kernel.org>
    kbuild: Add CONFIG_PAHOLE_VERSION

Kees Cook <keescook@chromium.org>
    ext4: Fix function prototype mismatch for ext4_feat_ktype

Paul Moore <paul@paul-moore.com>
    audit: update the mailing list in MAINTAINERS

Lukas Wunner <lukas@wunner.de>
    wifi: mwifiex: Add missing compatible string for SD8787

Zhang Wensheng <zhangwensheng5@huawei.com>
    nbd: fix possible overflow on 'first_minor' in nbd_dev_add()

Alessandro Astone <ales.astone@gmail.com>
    binder: Gracefully handle BINDER_TYPE_FDA objects with num_fds=0

Alessandro Astone <ales.astone@gmail.com>
    binder: Address corner cases in deferred copy and fixup

Arnd Bergmann <arnd@arndb.de>
    binder: fix pointer cast warning

Todd Kjos <tkjos@google.com>
    binder: defer copies of pre-patched txn data

Todd Kjos <tkjos@google.com>
    binder: read pre-translated fds from sender buffer

Dave Hansen <dave.hansen@linux.intel.com>
    uaccess: Add speculation barrier to copy_from_user()

Zheng Wang <zyytlz.wz@163.com>
    drm/i915/gvt: fix double free bug in split_2MB_gtt_entry

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s/radix: Fix RWX mapping with relocated kernel

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s/radix: Fix crash with unaligned relocated kernel

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/vmlinux.lds: Add an explicit symbol for the SRWX boundary

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/vmlinux.lds: Ensure STRICT_ALIGN_SIZE is at least page aligned

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc: use generic version of arch_is_kernel_initmem_freed()

Sean Anderson <sean.anderson@seco.com>
    powerpc: dts: t208x: Disable 10G on MAC1 and MAC2

Marc Kleine-Budde <mkl@pengutronix.de>
    can: kvaser_usb: hydra: help gcc-13 to figure out cmd_len

Jim Mattson <jmattson@google.com>
    KVM: VMX: Execute IBPB on emulated VM-exit when guest has IBRS

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Skip WRMSR fastpath on VM-Exit if next RIP isn't valid

Sean Christopherson <seanjc@google.com>
    KVM: x86: Fail emulation during EMULTYPE_SKIP on any exception

Jason A. Donenfeld <Jason@zx2c4.com>
    random: always mix cycle counter in add_latent_entropy()

Rahul Tanwar <rtanwar@maxlinear.com>
    clk: mxl: syscon_node_to_regmap() returns error pointers

Sean Anderson <sean.anderson@seco.com>
    powerpc: dts: t208x: Mark MAC1 and MAC2 as 10G

Rahul Tanwar <rtanwar@maxlinear.com>
    clk: mxl: Fix a clk entry by adding relevant flags

Rahul Tanwar <rtanwar@maxlinear.com>
    clk: mxl: Add option to override gate clks

Rahul Tanwar <rtanwar@maxlinear.com>
    clk: mxl: Remove redundant spinlocks

Rahul Tanwar <rtanwar@maxlinear.com>
    clk: mxl: Switch from direct readl/writel based IO to regmap based IO

Ankit Nautiyal <ankit.k.nautiyal@intel.com>
    drm/edid: Fix minimum bpc supported with DSC1.2 for HDMI sink

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: gen2: Turn on the rate control

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: don't truncate physical page address


-------------

Diffstat:

 MAINTAINERS                                        |   3 +-
 Makefile                                           |   4 +-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi |  44 +++
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi |  44 +++
 arch/powerpc/boot/dts/fsl/t2081si-post.dtsi        |  20 +-
 arch/powerpc/include/asm/sections.h                |  14 +-
 arch/powerpc/kernel/vmlinux.lds.S                  |  14 +-
 arch/powerpc/mm/book3s32/mmu.c                     |   2 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c           |  28 +-
 arch/x86/kvm/svm/svm.c                             |  10 +-
 arch/x86/kvm/vmx/nested.c                          |  11 +
 arch/x86/kvm/vmx/vmx.c                             |   6 +-
 arch/x86/kvm/x86.c                                 |   4 +-
 drivers/android/binder.c                           | 343 +++++++++++++++++++--
 drivers/block/nbd.c                                |  23 +-
 drivers/clk/x86/Kconfig                            |   5 +-
 drivers/clk/x86/clk-cgu-pll.c                      |  23 +-
 drivers/clk/x86/clk-cgu.c                          | 106 ++-----
 drivers/clk/x86/clk-cgu.h                          |  46 +--
 drivers/clk/x86/clk-lgm.c                          |  18 +-
 drivers/gpu/drm/drm_edid.c                         |   3 +-
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c              |   4 +-
 drivers/gpu/drm/i915/gvt/gtt.c                     |  17 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |  33 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c        |   1 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   8 +-
 fs/ext4/sysfs.c                                    |   7 +-
 include/linux/nospec.h                             |   4 +
 include/linux/random.h                             |   6 +-
 init/Kconfig                                       |   4 +
 kernel/bpf/core.c                                  |   2 -
 lib/Kconfig.debug                                  |   4 +-
 lib/usercopy.c                                     |   7 +
 net/sched/sch_taprio.c                             |   8 +-
 scripts/pahole-flags.sh                            |   2 +-
 scripts/pahole-version.sh                          |  13 +
 36 files changed, 660 insertions(+), 231 deletions(-)


