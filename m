Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDD945807B7
	for <lists+stable@lfdr.de>; Tue, 26 Jul 2022 00:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237718AbiGYWno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 18:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237721AbiGYWn0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 18:43:26 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD5F275DF
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 15:42:03 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id c6so7623694plc.5
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 15:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ufvzx2/m7jMv89ZbjJVhMULIMFxD8TVMYA1jccaD14k=;
        b=tVTgdtUgtRXGOgmdkr8SiLdMY9tY7MHBmLLg8cfnr9qPzchyE7BrqxUKtup0rlTw49
         a6p7A7JAu1QgOUesD6m0wZRf9pwLPhuHIXF0mADrPoj8TX+qSkeJk7YohaYcSAqE8R0l
         llMuji9BDT2SdMlJT+CV5ZIDcqbzZjx4g1/XPXshQR6DHs3p5S5gcFHShrNosHQpn9Z/
         DXVLeZ9z/2A+HMdWngII+MArjMLU4Jvx9TKQOYvnZfLc8/1lMZZ1mHWAUrDSyl6kSXr+
         8oQ2KV86LqxKoOfkIx0WqkLusxZXXF5iBO1CsUBcadDdy7wtQSy/NZWc1RcNtD2ZUsXH
         rlBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ufvzx2/m7jMv89ZbjJVhMULIMFxD8TVMYA1jccaD14k=;
        b=5cHArxOQh0UbWWvC1Vbsqo+TS8zsz3YFENJqWxKNheuobX5cqrb+RjNQe1VrzRRgnF
         Zw6WKzWiavbZC8XirdiEdH/ffa81LaRCUbqwW372cTBWBQrU99ef+zG7SkFlr5Q8GkAA
         wIvZNnqsfCvobmk8RVtIJOYHmAIMrEPAG/XMzwkRjL2kkop/8Lb4YJmjKABmtQQWH8M/
         wp9tdk2QP1LJtMa1J+esYyUhcSjVyeINlsuKo2hsdb/KQ+hZ46WcIEG2QkFPjIbGL+/u
         cBKUZ/SqnXYAVSTKFlnYbca4BNAodPOQmGHbS3aOVB61KdbPCzSy3YxkuHURb+uUaBB3
         Mhng==
X-Gm-Message-State: AJIora8NLS47J+XR82fdUpQ7cUhWo653qRkcxPKp44bFUtZ4xND3t9IL
        OsxGUnBnStTIh2AtwTe5bFabczzuz+vdaGFN
X-Google-Smtp-Source: AGRyM1vHWdP9xiiGsoe/yT/7oFUkG5G/qY+rMjTPVaa1ufUJlxyHmhlla3JWrE8nnDRpivBdqqiGkA==
X-Received: by 2002:a17:902:b70a:b0:16c:f62c:43aa with SMTP id d10-20020a170902b70a00b0016cf62c43aamr14226093pls.8.1658788886214;
        Mon, 25 Jul 2022 15:41:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f9-20020a17090a4a8900b001f21c635479sm9370641pjh.40.2022.07.25.15.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 15:41:25 -0700 (PDT)
Message-ID: <62df1c15.1c69fb81.4e476.e512@mx.google.com>
Date:   Mon, 25 Jul 2022 15:41:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v5.15.57-176-g9780829ed8d15
Subject: stable-rc/queue/5.15 build: 180 builds: 11 failed, 169 passed,
 28 errors, 6827 warnings (v5.15.57-176-g9780829ed8d15)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 build: 180 builds: 11 failed, 169 passed, 28 errors, 6=
827 warnings (v5.15.57-176-g9780829ed8d15)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.1=
5/kernel/v5.15.57-176-g9780829ed8d15/

Tree: stable-rc
Branch: queue/5.15
Git Describe: v5.15.57-176-g9780829ed8d15
Git Commit: 9780829ed8d15de556424bed96704c95dfc357f6
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
    allnoconfig (gcc-10): 2 errors, 758 warnings
    i386_defconfig (gcc-10): 2 errors, 914 warnings
    tinyconfig (gcc-10): 2 errors, 650 warnings

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
    tinyconfig (gcc-10): 2 errors, 534 warnings
    x86_64_defconfig (gcc-10): 2 errors, 1684 warnings
    x86_64_defconfig+x86-chromebook (gcc-10): 2 errors, 1494 warnings

Errors summary:

    10   expr: syntax error: unexpected argument =E2=80=980xffffffff8000000=
0=E2=80=99
    7    arch/x86/mm/extable.c:203:2: error: duplicate case value
    7    arch/x86/mm/extable.c:200:2: error: duplicate case value
    2    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3m
    2    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-marc=
h=3D=E2=80=99

Warnings summary:

    3411  arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_=
FAULT_MCE_SAFE" redefined
    3411  arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_=
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
allnoconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-10) =E2=80=94 FAIL, 2 errors, 758 warnings, 0 sectio=
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
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
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
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
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
defconfig (arm64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
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
i386_defconfig (i386, gcc-10) =E2=80=94 FAIL, 2 errors, 914 warnings, 0 sec=
tion mismatches

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
mvebu_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
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
spear3xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

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
tinyconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    arch/arc/Makefile:26: ** WARNING ** CONFIG_ARC_TUNE_MCPU flag '' is unk=
nown, fallback to ''

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-10) =E2=80=94 FAIL, 2 errors, 534 warnings, 0 secti=
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

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-10) =E2=80=94 FAIL, 2 errors, 650 warnings, 0 section=
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
x86_64_defconfig (x86_64, gcc-10) =E2=80=94 FAIL, 2 errors, 1684 warnings, =
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
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:49: warning: "EX_TYPE_DEFAUL=
T_MCE_SAFE" redefined
    arch/x86/include/asm/extable_fixup_types.h:50: warning: "EX_TYPE_FAULT_=
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
1494 warnings, 0 section mismatches

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
