Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97C7E6A09A2
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234328AbjBWNIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:08:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234008AbjBWNIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:08:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783665FCB;
        Thu, 23 Feb 2023 05:08:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47254616ED;
        Thu, 23 Feb 2023 13:08:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24B1C433D2;
        Thu, 23 Feb 2023 13:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157714;
        bh=7vmswi1pV/dUWUIMSvx/xBGdkN0n+ukIvXfZ76sofPg=;
        h=From:To:Cc:Subject:Date:From;
        b=pDLK4/p/SWG0x489bN+ugyb51NuhmCkmbmsgMWSsCk8XWF7c7ehCjD5lzZ9UnPsqG
         PeBPp5EsLTfDPkOym+MFXTMCRFTUdw5UkS4xNQnD9j7Y20DZ8pEkfNllwSWWlhPcn6
         XmVeQLWXU92v82FmKWrl6b1RaFK6Ypf3tnOf55w0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.1 00/46] 6.1.14-rc1 review
Date:   Thu, 23 Feb 2023 14:06:07 +0100
Message-Id: <20230223130431.553657459@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.14-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.1.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.1.14-rc1
X-KernelTest-Deadline: 2023-02-25T13:04+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 6.1.14 release.
There are 46 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 25 Feb 2023 13:04:16 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.14-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.1.14-rc1

Eric Biggers <ebiggers@google.com>
    randstruct: disable Clang 15 support

Kees Cook <keescook@chromium.org>
    ext4: Fix function prototype mismatch for ext4_feat_ktype

Hans de Goede <hdegoede@redhat.com>
    platform/x86: nvidia-wmi-ec-backlight: Add force module parameter

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    platform/x86/amd/pmf: Add depends on CONFIG_POWER_SUPPLY

Paul Moore <paul@paul-moore.com>
    audit: update the mailing list in MAINTAINERS

Lukas Wunner <lukas@wunner.de>
    wifi: mwifiex: Add missing compatible string for SD8787

Tom Saeger <tom.saeger@oracle.com>
    sh: define RUNTIME_DISCARD_EXIT

Masahiro Yamada <masahiroy@kernel.org>
    s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT

Masahiro Yamada <masahiroy@kernel.org>
    arch: fix broken BuildID for arm64 and riscv

Masahiro Yamada <masahiroy@kernel.org>
    arm64: remove special treatment for the link order of head.o

Jisheng Zhang <jszhang@kernel.org>
    riscv: remove special treatment for the link order of head.o

Shengyu Qu <wiagn233@outlook.com>
    Bluetooth: btusb: Add more device IDs for WCN6855

Peter Zijlstra <peterz@infradead.org>
    x86/static_call: Add support for Jcc tail-calls

Peter Zijlstra <peterz@infradead.org>
    x86/alternatives: Teach text_poke_bp() to patch Jcc.d32 instructions

Peter Zijlstra <peterz@infradead.org>
    x86/alternatives: Introduce int3_emulate_jcc()

Dave Hansen <dave.hansen@linux.intel.com>
    uaccess: Add speculation barrier to copy_from_user()

Yu Xiao <yu.xiao@corigine.com>
    nfp: ethtool: fix the bug of setting unsupported port speed

Yu Xiao <yu.xiao@corigine.com>
    nfp: ethtool: support reporting link modes

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s/radix: Fix RWX mapping with relocated kernel

Paolo Bonzini <pbonzini@redhat.com>
    selftests: kvm: move declaration at the beginning of main()

Paolo Bonzini <pbonzini@redhat.com>
    KVM: x86: fix deadlock for KVM_XEN_EVTCHN_RESET

Lucas De Marchi <lucas.demarchi@intel.com>
    drm/i915: Remove __maybe_unused from mtl_info

Ricardo Ribalda <ribalda@chromium.org>
    spi: mediatek: Enable irq before the spi registration

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

Yicong Yang <yangyicong@hisilicon.com>
    docs: perf: Fix PMU instance name of hisi-pcie-pmu

Ricardo Ribalda <ribalda@chromium.org>
    spi: mediatek: Enable irq when pdata is ready

Jie Zhan <zhanjie9@hisilicon.com>
    scsi: hisi_sas: Fix SATA devices missing issue during I_T nexus reset

Jie Zhan <zhanjie9@hisilicon.com>
    scsi: libsas: Add smp_ata_check_ready_type()

Jason A. Donenfeld <Jason@zx2c4.com>
    random: always mix cycle counter in add_latent_entropy()

Suren Baghdasaryan <surenb@google.com>
    sched/psi: Stop relying on timer_pending() for poll_work rescheduling

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

Wen Gong <quic_wgong@quicinc.com>
    wifi: ath11k: fix warning in dma_free_coherent() of memory chunks while recovery

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: don't truncate physical page address


-------------

Diffstat:

 Documentation/admin-guide/perf/hisi-pcie-pmu.rst   |  22 +--
 MAINTAINERS                                        |   2 +-
 Makefile                                           |   4 +-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi |  44 +++++
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi |  44 +++++
 arch/powerpc/boot/dts/fsl/t2081si-post.dtsi        |  20 ++-
 arch/powerpc/kernel/vmlinux.lds.S                  |   6 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c           |  13 ++
 arch/s390/kernel/vmlinux.lds.S                     |   2 +
 arch/sh/kernel/vmlinux.lds.S                       |   1 +
 arch/x86/include/asm/text-patching.h               |  31 ++++
 arch/x86/kernel/alternative.c                      |  59 +++++--
 arch/x86/kernel/kprobes/core.c                     |  38 +---
 arch/x86/kernel/static_call.c                      |  49 +++++-
 arch/x86/kvm/svm/svm.c                             |  10 +-
 arch/x86/kvm/vmx/nested.c                          |  11 ++
 arch/x86/kvm/vmx/vmx.c                             |   6 +-
 arch/x86/kvm/x86.c                                 |   4 +-
 arch/x86/kvm/xen.c                                 |  30 +++-
 drivers/bluetooth/btusb.c                          |  84 +++++++++
 drivers/clk/x86/Kconfig                            |   5 +-
 drivers/clk/x86/clk-cgu-pll.c                      |  23 +--
 drivers/clk/x86/clk-cgu.c                          | 106 ++++-------
 drivers/clk/x86/clk-cgu.h                          |  46 ++---
 drivers/clk/x86/clk-lgm.c                          |  18 +-
 drivers/gpu/drm/drm_edid.c                         |   3 +-
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c              |   4 +-
 drivers/gpu/drm/i915/i915_pci.c                    |   1 -
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |  33 +++-
 drivers/net/ethernet/netronome/nfp/nfp_main.h      |   1 +
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   | 195 +++++++++++++++++++++
 drivers/net/ethernet/netronome/nfp/nfp_port.h      |  12 ++
 .../net/ethernet/netronome/nfp/nfpcore/nfp_nsp.c   |  17 ++
 .../net/ethernet/netronome/nfp/nfpcore/nfp_nsp.h   |  56 ++++++
 .../ethernet/netronome/nfp/nfpcore/nfp_nsp_eth.c   |  26 +++
 drivers/net/wireless/ath/ath11k/qmi.c              |   6 +-
 drivers/net/wireless/marvell/mwifiex/sdio.c        |   1 +
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   8 +-
 drivers/platform/x86/amd/pmf/Kconfig               |   1 +
 drivers/platform/x86/nvidia-wmi-ec-backlight.c     |   6 +-
 drivers/scsi/hisi_sas/hisi_sas_main.c              |   8 +-
 drivers/scsi/libsas/sas_ata.c                      |  25 +++
 drivers/scsi/libsas/sas_expander.c                 |   4 +-
 drivers/scsi/libsas/sas_internal.h                 |   2 +
 drivers/spi/spi-mt65xx.c                           |  10 +-
 fs/ext4/sysfs.c                                    |   7 +-
 include/asm-generic/vmlinux.lds.h                  |   5 +
 include/linux/nospec.h                             |   4 +
 include/linux/psi_types.h                          |   1 +
 include/linux/random.h                             |   6 +-
 include/scsi/sas_ata.h                             |   6 +
 kernel/bpf/core.c                                  |   2 -
 kernel/sched/psi.c                                 |  62 +++++--
 lib/usercopy.c                                     |   7 +
 scripts/head-object-list.txt                       |   2 -
 security/Kconfig.hardening                         |   3 +
 .../testing/selftests/kvm/x86_64/xen_shinfo_test.c |   5 +
 57 files changed, 962 insertions(+), 245 deletions(-)


