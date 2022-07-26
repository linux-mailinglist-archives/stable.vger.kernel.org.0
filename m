Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 148B3581864
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 19:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239342AbiGZRam (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jul 2022 13:30:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239356AbiGZRai (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jul 2022 13:30:38 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD8242A431
        for <stable@vger.kernel.org>; Tue, 26 Jul 2022 10:30:35 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id e132so13711281pgc.5
        for <stable@vger.kernel.org>; Tue, 26 Jul 2022 10:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mX2+zXzBeZ6jcMGfDHYXXnbkWZviPD6AbhgAD/2Lr7U=;
        b=XuCYg4Px8sswKY8UfemrynVZKzY6/kba3CAobgUPK/ib5fKETnAIWKWT1CfLKlEP+y
         VI4u61mxMYD2MNumVejJphtc761S0AU4KOZoU4l+xmdwxt5Nx6q5b+3/nbG1SmjHya8X
         gXNrGPDRWIFAtPQs23kIRDSjhmidGKvb3Iu1D2zR8ddRlS4dfA6wmPEZyJ5FjY1vpYub
         Vt9KzAyf1g+72cRViNigc48619GiWbUMz64PBTf6Uw7skC3KPx8NS7pvMJ0BsKsuPUMy
         dtW/2HoR+rBdg+Hwp9E/MitHl7mmSrxGy83D9xh6LzyTHeYNux+iA5KgHiF1LNhKeEPU
         C2ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mX2+zXzBeZ6jcMGfDHYXXnbkWZviPD6AbhgAD/2Lr7U=;
        b=d7V51Jr86E/RaeL98NVFwbTG2z+uCPinKyS2HjSntV0uFCkV43B7TrbcRy4KKgxFDA
         ehOOrTdqnnRdTqeJYMo8+uDubXGgXua/PFpnggq981TdE3DoH1JVxXOaXh1oePnQAbmd
         7lUtIILcEK3swPWN+zlU681rfS5EKagBVXRqeFmlKObAyUMxr9ELNMCvk/5cIGx0n2Uj
         pF1n3IBt9rqAa+JPpiFNJwysuSILyoBKJverKfzZkY+nQrG4razOJwc8nab9IEyHjrKL
         wZ7xb0cJ7uNVLwrlz9nRM7F+gcgF0//0fbEzbtY3es/+JcQ7h/VP8C0RTh7JXgmEZOPl
         DDRQ==
X-Gm-Message-State: AJIora+CEDRaBaJ7/0n5aXCLwB3ZTzk29YHwNq/gt5bPjHRjWYceHCUE
        e84wuHURjkhFsuWFEuUjcADGlYXM/mitn/0l
X-Google-Smtp-Source: AGRyM1sdgokhAq+iMu0x+E/X1g+Z7OflSLEmYMKenpAM6hgZjAXUbcXygsvkrrEz8paReZYec/4QXQ==
X-Received: by 2002:a63:4601:0:b0:412:562e:7243 with SMTP id t1-20020a634601000000b00412562e7243mr16007265pga.358.1658856633487;
        Tue, 26 Jul 2022 10:30:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z22-20020aa79596000000b0050dc7628183sm12226502pfj.93.2022.07.26.10.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 10:30:32 -0700 (PDT)
Message-ID: <62e024b8.1c69fb81.4d969.3955@mx.google.com>
Date:   Tue, 26 Jul 2022 10:30:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v5.15.57-176-g1bb44bd5f12d5
Subject: stable-rc/queue/5.15 build: 179 builds: 11 failed, 168 passed,
 28 errors, 7489 warnings (v5.15.57-176-g1bb44bd5f12d5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 build: 179 builds: 11 failed, 168 passed, 28 errors, 7=
489 warnings (v5.15.57-176-g1bb44bd5f12d5)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.1=
5/kernel/v5.15.57-176-g1bb44bd5f12d5/

Tree: stable-rc
Branch: queue/5.15
Git Describe: v5.15.57-176-g1bb44bd5f12d5
Git Commit: 1bb44bd5f12d55660a720d557bd16188f73d3857
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm:
    rpc_defconfig: (gcc-10) FAIL

i386:
    allnoconfig: (gcc-10) FAIL
    i386_defconfig: (gcc-10) FAIL
    tinyconfig: (gcc-10) FAIL

mips:
    decstation_64_defconfig: (gcc-10) FAIL
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL

x86_64:
    allnoconfig: (gcc-10) FAIL
    tinyconfig: (gcc-10) FAIL
    x86_64_defconfig: (gcc-10) FAIL
    x86_64_defconfig+x86-chromebook: (gcc-10) FAIL

Errors and Warnings Detected:

arc:
    tinyconfig (gcc-10): 1 warning

arm64:

arm:
    rpc_defconfig (gcc-10): 4 errors

i386:
    allnoconfig (gcc-10): 2 errors, 562 warnings
    i386_defconfig (gcc-10): 2 errors, 1636 warnings
    tinyconfig (gcc-10): 2 errors, 592 warnings

mips:
    32r2el_defconfig (gcc-10): 1 warning
    bigsur_defconfig (gcc-10): 1 error
    cavium_octeon_defconfig (gcc-10): 1 error
    decstation_64_defconfig (gcc-10): 1 error
    fuloong2e_defconfig (gcc-10): 1 error
    ip32_defconfig (gcc-10): 1 error
    lemote2f_defconfig (gcc-10): 1 error, 1 warning
    loongson2k_defconfig (gcc-10): 1 error, 1 warning
    loongson3_defconfig (gcc-10): 1 error
    nlm_xlp_defconfig (gcc-10): 1 error
    rm200_defconfig (gcc-10): 1 warning
    sb1250_swarm_defconfig (gcc-10): 1 error

riscv:

x86_64:
    allnoconfig (gcc-10): 2 errors, 788 warnings
    tinyconfig (gcc-10): 2 errors, 828 warnings
    x86_64_defconfig (gcc-10): 2 errors, 1482 warnings
    x86_64_defconfig+x86-chromebook (gcc-10): 2 errors, 1596 warnings

Errors summary:

    10   expr: syntax error: unexpected argument =E2=80=980xffffffff8000000=
0=E2=80=99
    7    arch/x86/mm/extable.c:203:2: error: duplicate case value
    7    arch/x86/mm/extable.c:200:2: error: duplicate case value
    2    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3m
    2    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-marc=
h=3D=E2=80=99

Warnings summary:

    3742  arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_=
FAULT_MCE_SAFE" redefined
    3742  arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_=
DEFAULT_MCE_SAFE" redefined
    2    net/mac80211/mlme.c:4377:1: warning: the frame size of 1200 bytes =
is larger than 1024 bytes [-Wframe-larger-than=3D]
    1    drivers/block/paride/bpck.c:32: warning: "PC" redefined
    1    arch/mips/boot/dts/img/boston.dts:128.19-178.5: Warning (pci_devic=
e_reg): /pci@14000000/pci2_root@0,0,0: PCI unit address format error, expec=
ted "0,0"
    1    arch/arc/Makefile:26: ** WARNING ** CONFIG_ARC_TUNE_MCPU flag '' i=
s unknown, fallback to ''

Section mismatches summary:

    1    WARNING: modpost: vmlinux.o(___ksymtab_gpl+ixp4xx_irq_init+0x0): S=
ection mismatch in reference from the variable __ksymtab_ixp4xx_irq_init to=
 the function .init.text:ixp4xx_irq_init()
    1    WARNING: modpost: vmlinux.o(___ksymtab+prom_init_numa_memory+0x0):=
 Section mismatch in reference from the variable __ksymtab_prom_init_numa_m=
emory to the function .init.text:prom_init_numa_memory()

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    arch/mips/boot/dts/img/boston.dts:128.19-178.5: Warning (pci_device_reg=
): /pci@14000000/pci2_root@0,0,0: PCI unit address format error, expected "=
0,0"

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-10) =E2=80=94 FAIL, 2 errors, 562 warnings, 0 sectio=
n mismatches

Errors:
    arch/x86/mm/extable.c:200:2: error: duplicate case value
    arch/x86/mm/extable.c:203:2: error: duplicate case value

Warnings:
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-10) =E2=80=94 FAIL, 2 errors, 788 warnings, 0 sect=
ion mismatches

Errors:
    arch/x86/mm/extable.c:200:2: error: duplicate case value
    arch/x86/mm/extable.c:203:2: error: duplicate case value

Warnings:
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings,=
 0 section mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
cu1000-neo_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
cu1830-neo_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
decstation_64_defconfig (mips, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings,=
 0 section mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
decstation_r4k_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warning=
s, 0 section mismatches

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
defconfig+arm64-chromebook (arm64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warn=
ings, 0 section mismatches

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

---------------------------------------------------------------------------=
-----
gcw0_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-10) =E2=80=94 FAIL, 2 errors, 1636 warnings, 0 se=
ction mismatches

Errors:
    arch/x86/mm/extable.c:200:2: error: duplicate case value
    arch/x86/mm/extable.c:203:2: error: duplicate case value

Warnings:
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-10) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-10) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(___ksymtab_gpl+ixp4xx_irq_init+0x0): Sectio=
n mismatch in reference from the variable __ksymtab_ixp4xx_irq_init to the =
function .init.text:ixp4xx_irq_init()

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 1 warning, 0 sec=
tion mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

Warnings:
    net/mac80211/mlme.c:4377:1: warning: the frame size of 1200 bytes is la=
rger than 1024 bytes [-Wframe-larger-than=3D]

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
loongson2k_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 1 warning, 0 s=
ection mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

Warnings:
    net/mac80211/mlme.c:4377:1: warning: the frame size of 1200 bytes is la=
rger than 1024 bytes [-Wframe-larger-than=3D]

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

Section mismatches:
    WARNING: modpost: vmlinux.o(___ksymtab+prom_init_numa_memory+0x0): Sect=
ion mismatch in reference from the variable __ksymtab_prom_init_numa_memory=
 to the function .init.text:prom_init_numa_memory()

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnin=
gs, 0 section mismatches

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
milbeaut_m10v_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
nommu_k210_defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
nommu_k210_sdcard_defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 war=
nings, 0 section mismatches

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warning=
s, 0 section mismatches

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
oxnas_v6_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    drivers/block/paride/bpck.c:32: warning: "PC" redefined

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-10) =E2=80=94 FAIL, 4 errors, 0 warnings, 0 section=
 mismatches

Errors:
    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3m
    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-march=3D=
=E2=80=99
    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3m
    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-march=3D=
=E2=80=99

---------------------------------------------------------------------------=
-----
rs90_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
rv32_defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
sama7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-10) =E2=80=94 PASS, 1 error, 0 warnings, =
0 section mismatches

Errors:
    expr: syntax error: unexpected argument =E2=80=980xffffffff80000000=E2=
=80=99

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-10) =E2=80=94 FAIL, 2 errors, 828 warnings, 0 secti=
on mismatches

Errors:
    arch/x86/mm/extable.c:200:2: error: duplicate case value
    arch/x86/mm/extable.c:203:2: error: duplicate case value

Warnings:
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-10) =E2=80=94 FAIL, 2 errors, 592 warnings, 0 section=
 mismatches

Errors:
    arch/x86/mm/extable.c:200:2: error: duplicate case value
    arch/x86/mm/extable.c:203:2: error: duplicate case value

Warnings:
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    arch/arc/Makefile:26: ** WARNING ** CONFIG_ARC_TUNE_MCPU flag '' is unk=
nown, fallback to ''

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-10) =E2=80=94 FAIL, 2 errors, 1482 warnings, =
0 section mismatches

Errors:
    arch/x86/mm/extable.c:200:2: error: duplicate case value
    arch/x86/mm/extable.c:203:2: error: duplicate case value

Warnings:
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined

---------------------------------------------------------------------------=
-----
x86_64_defconfig+x86-chromebook (x86_64, gcc-10) =E2=80=94 FAIL, 2 errors, =
1596 warnings, 0 section mismatches

Errors:
    arch/x86/mm/extable.c:200:2: error: duplicate case value
    arch/x86/mm/extable.c:203:2: error: duplicate case value

Warnings:
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---
For more info write to <info@kernelci.org>
