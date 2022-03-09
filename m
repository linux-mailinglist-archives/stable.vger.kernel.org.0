Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 065364D26FD
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 05:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231566AbiCIDAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 22:00:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231497AbiCIDAf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 22:00:35 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89AE513AA33
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 18:59:35 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id r12so795954pla.1
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 18:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mkV6ZEou4woAkk11CZm9zR/R/lELb4nYLIpgG2zMeJg=;
        b=iNXVV7n4Z3QP1iHVd5e6d0HzGECZ6jHUDR7PsX92ZiaWsCWKw+RMdOKwPun9W3wpW2
         Cs+zeWXzsH3gc7HnUQA/sedkgy0/Tinv16oFMhQ1A7dOfZ2h+eMCG6fXmi79A0Mj7u+b
         mhMazh7lCf5TaC8k2ADM86R5/Cdh471UFvcTeYVb35eszYn4WlDVjIrEfQvI6EFIxPC2
         JTRT20XrOiU3GIHs/+LHZYsvZYiEqg6q8yfIPcVqywrigCPvbif9girwUFSlj4SWxlLO
         Igu4U/6Z0bu6HAFTC4IJxeNd9jm4l9CYGtLcZ6LVklhKkuEKB4/arydnYkGYSyh5yU/s
         60Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mkV6ZEou4woAkk11CZm9zR/R/lELb4nYLIpgG2zMeJg=;
        b=6A+FHfxigtJHo3ClL2/K+JbztLXabVXdy+7DsiiZKuw/PZHP6CPEDdMAGPl7awqWTZ
         ui3MPigmWdc8O9s1qO8LkFU3WipM9eU+tQn7gaqxYZkEeS/7gUr7bXWwjZgjEp65Kxa5
         2zocSUiaVxEldl5dMY2+ByPUuDx0YbgmChCN7tF6CUBSXV5MtnrxYIjaBwVD5DggGc2o
         unX3VhNDLAT0pajPBAmfajwJ2clH7k/c0db3fKRrNGIjcsqpJnTDTX6TvWDKWeDKsDqg
         fb1QxpywYT4RpJx0OqpLCWX98kDkueIkL8GKr1EWoqOo39vDfwZqgyFZr8YCz7v14QzF
         vUgg==
X-Gm-Message-State: AOAM531m8sO4HPEPga5UooQtEIB0qpheLehtKwNWUfXJJzNfSNcVTx2q
        TjwmP2B5EJ0d6TYhx9JGovETmHIY2LPb9ZjJw/A=
X-Google-Smtp-Source: ABdhPJzc9JFK8L6E9XaqiqNoBtkSPxTYGwEhktxUxwSviPG5S9pdeMQIAk4B1CI02P1SCl2318Ht2w==
X-Received: by 2002:a17:90a:19d5:b0:1bc:a5db:b655 with SMTP id 21-20020a17090a19d500b001bca5dbb655mr8229531pjj.46.1646794774013;
        Tue, 08 Mar 2022 18:59:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h13-20020a056a00170d00b004f757a795fesm245144pfc.219.2022.03.08.18.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 18:59:33 -0800 (PST)
Message-ID: <62281815.1c69fb81.8d19b.117c@mx.google.com>
Date:   Tue, 08 Mar 2022 18:59:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.270-19-g310a15e6f2b1
Subject: stable-rc/linux-4.14.y build: 183 builds: 32 failed, 151 passed,
 52 errors, 31 warnings (v4.14.270-19-g310a15e6f2b1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y build: 183 builds: 32 failed, 151 passed, 52 errors,=
 31 warnings (v4.14.270-19-g310a15e6f2b1)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.270-19-g310a15e6f2b1/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.270-19-g310a15e6f2b1
Git Commit: 310a15e6f2b1701646e1772196cf1ee92060e294
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failures Detected:

arm:
    axm55xx_defconfig: (gcc-10) FAIL
    bcm2835_defconfig: (gcc-10) FAIL
    clps711x_defconfig: (gcc-10) FAIL
    dove_defconfig: (gcc-10) FAIL
    exynos_defconfig: (gcc-10) FAIL
    hisi_defconfig: (gcc-10) FAIL
    imx_v6_v7_defconfig: (gcc-10) FAIL
    keystone_defconfig: (gcc-10) FAIL
    mmp2_defconfig: (gcc-10) FAIL
    multi_v7_defconfig: (gcc-10) FAIL
    mvebu_v7_defconfig: (gcc-10) FAIL
    omap2plus_defconfig: (gcc-10) FAIL
    prima2_defconfig: (gcc-10) FAIL
    pxa168_defconfig: (gcc-10) FAIL
    pxa910_defconfig: (gcc-10) FAIL
    qcom_defconfig: (gcc-10) FAIL
    realview_defconfig: (gcc-10) FAIL
    rpc_defconfig: (gcc-10) FAIL
    s5pv210_defconfig: (gcc-10) FAIL
    sama5_defconfig: (gcc-10) FAIL
    shmobile_defconfig: (gcc-10) FAIL
    socfpga_defconfig: (gcc-10) FAIL
    spear13xx_defconfig: (gcc-10) FAIL
    sunxi_defconfig: (gcc-10) FAIL
    tango4_defconfig: (gcc-10) FAIL
    tegra_defconfig: (gcc-10) FAIL
    u8500_defconfig: (gcc-10) FAIL
    vexpress_defconfig: (gcc-10) FAIL
    vt8500_v6_v7_defconfig: (gcc-10) FAIL
    zx_defconfig: (gcc-10) FAIL

mips:
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL

Errors and Warnings Detected:

arc:

arm64:

arm:
    axm55xx_defconfig (gcc-10): 1 error
    bcm2835_defconfig (gcc-10): 6 errors
    clps711x_defconfig (gcc-10): 1 error
    dove_defconfig (gcc-10): 1 error
    exynos_defconfig (gcc-10): 1 error
    hisi_defconfig (gcc-10): 1 error
    imx_v6_v7_defconfig (gcc-10): 6 errors
    keystone_defconfig (gcc-10): 1 error
    mmp2_defconfig (gcc-10): 1 error
    multi_v7_defconfig (gcc-10): 1 error
    mvebu_v7_defconfig (gcc-10): 1 error
    omap1_defconfig (gcc-10): 1 warning
    omap2plus_defconfig (gcc-10): 6 errors
    prima2_defconfig (gcc-10): 1 error
    pxa168_defconfig (gcc-10): 1 error
    pxa910_defconfig (gcc-10): 1 error
    qcom_defconfig (gcc-10): 1 error
    realview_defconfig (gcc-10): 2 errors
    rpc_defconfig (gcc-10): 2 errors
    s3c2410_defconfig (gcc-10): 1 warning
    s5pv210_defconfig (gcc-10): 1 error
    sama5_defconfig (gcc-10): 1 error
    shmobile_defconfig (gcc-10): 1 error
    socfpga_defconfig (gcc-10): 1 error
    spear13xx_defconfig (gcc-10): 1 error
    sunxi_defconfig (gcc-10): 1 error
    tango4_defconfig (gcc-10): 1 error
    tegra_defconfig (gcc-10): 1 error
    u8500_defconfig (gcc-10): 1 error
    vexpress_defconfig (gcc-10): 1 error
    vt8500_v6_v7_defconfig (gcc-10): 6 errors
    zx_defconfig (gcc-10): 1 error

i386:
    allnoconfig (gcc-10): 3 warnings
    i386_defconfig (gcc-10): 3 warnings
    tinyconfig (gcc-10): 3 warnings

mips:
    malta_qemu_32r6_defconfig (gcc-10): 1 warning
    mtx1_defconfig (gcc-10): 3 warnings

x86_64:
    allnoconfig (gcc-10): 4 warnings
    tinyconfig (gcc-10): 4 warnings
    x86_64_defconfig (gcc-10): 4 warnings
    x86_64_defconfig+x86-chromebook (gcc-10): 4 warnings

Errors summary:

    24   arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=
=99 before =E2=80=98}=E2=80=99 token
    5    arch/arm/kernel/entry-common.S:173: Error: co-processor register e=
xpected -- `mcr p15,0,r0,c7,r5,4'
    5    arch/arm/kernel/entry-common.S:164: Error: co-processor register e=
xpected -- `mcr p15,0,r0,c7,r5,4'
    4    arch/arm/mm/cache-v7.S:63: Error: co-processor register expected -=
- `mcr p15,0,r0,c7,r5,4'
    4    arch/arm/mm/cache-v7.S:298: Error: co-processor register expected =
-- `mcr p15,0,r0,c7,r5,4'
    4    arch/arm/mm/cache-v7.S:170: Error: co-processor register expected =
-- `mcr p15,0,r0,c7,r5,4'
    4    arch/arm/mm/cache-v7.S:136: Error: co-processor register expected =
-- `mcr p15,0,r0,c7,r5,4'
    1    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3
    1    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-marc=
h=3D=E2=80=99

Warnings summary:

    7    ld: warning: creating DT_TEXTREL in a PIE
    4    ld: arch/x86/boot/compressed/head_64.o: warning: relocation in rea=
d-only section `.head.text'
    4    arch/x86/entry/entry_64.S:1642: Warning: no instruction mnemonic s=
uffix given and no register operands; using default for `sysret'
    4    Warning: synced file at 'tools/objtool/arch/x86/include/asm/insn.h=
' differs from latest kernel version at 'arch/x86/include/asm/insn.h'
    3    ld: arch/x86/boot/compressed/head_32.o: warning: relocation in rea=
d-only section `.head.text'
    3    arch/x86/entry/entry_32.S:482: Warning: no instruction mnemonic su=
ffix given and no register operands; using default for `btr'
    2    sound/pci/echoaudio/echoaudio_dsp.c:647:9: warning: iteration 1073=
741824 invokes undefined behavior [-Waggressive-loop-optimizations]
    1    {standard input}:30: Warning: macro instruction expanded into mult=
iple instructions
    1    sound/pci/echoaudio/echoaudio_dsp.c:658:9: warning: iteration 1073=
741824 invokes undefined behavior [-Waggressive-loop-optimizations]
    1    drivers/tty/serial/samsung.c:1794:34: warning: array =E2=80=98s3c2=
4xx_uart_dt_match=E2=80=99 assumed to have one element
    1    drivers/gpio/gpio-omap.c:1152:34: warning: array =E2=80=98omap_gpi=
o_match=E2=80=99 assumed to have one element

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
acs5k_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 4 warnings, 0 sectio=
n mismatches

Warnings:
    Warning: synced file at 'tools/objtool/arch/x86/include/asm/insn.h' dif=
fers from latest kernel version at 'arch/x86/include/asm/insn.h'
    arch/x86/entry/entry_64.S:1642: Warning: no instruction mnemonic suffix=
 given and no register operands; using default for `sysret'
    ld: arch/x86/boot/compressed/head_64.o: warning: relocation in read-onl=
y section `.head.text'
    ld: warning: creating DT_TEXTREL in a PIE

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 section =
mismatches

Warnings:
    arch/x86/entry/entry_32.S:482: Warning: no instruction mnemonic suffix =
given and no register operands; using default for `btr'
    ld: arch/x86/boot/compressed/head_32.o: warning: relocation in read-onl=
y section `.head.text'
    ld: warning: creating DT_TEXTREL in a PIE

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
axm55xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-10) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/kernel/entry-common.S:164: Error: co-processor register expect=
ed -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/kernel/entry-common.S:173: Error: co-processor register expect=
ed -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:63: Error: co-processor register expected -- `mc=
r p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:136: Error: co-processor register expected -- `m=
cr p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:170: Error: co-processor register expected -- `m=
cr p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:298: Error: co-processor register expected -- `m=
cr p15,0,r0,c7,r5,4'

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
bigsur_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

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
cavium_octeon_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

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
clps711x_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

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
davinci_all_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

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
fuloong2e_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

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
hisi_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 secti=
on mismatches

Warnings:
    arch/x86/entry/entry_32.S:482: Warning: no instruction mnemonic suffix =
given and no register operands; using default for `btr'
    ld: arch/x86/boot/compressed/head_32.o: warning: relocation in read-onl=
y section `.head.text'
    ld: warning: creating DT_TEXTREL in a PIE

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
imx_v6_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    arch/arm/kernel/entry-common.S:164: Error: co-processor register expect=
ed -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/kernel/entry-common.S:173: Error: co-processor register expect=
ed -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:63: Error: co-processor register expected -- `mc=
r p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:136: Error: co-processor register expected -- `m=
cr p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:170: Error: co-processor register expected -- `m=
cr p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:298: Error: co-processor register expected -- `m=
cr p15,0,r0,c7,r5,4'

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
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
ip32_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

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
keystone_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

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
loongson3_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

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
malta_kvm_guest_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnin=
gs, 0 section mismatches

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warnin=
g, 0 section mismatches

Warnings:
    {standard input}:30: Warning: macro instruction expanded into multiple =
instructions

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
maltaup_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

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
msp71xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 secti=
on mismatches

Warnings:
    sound/pci/echoaudio/echoaudio_dsp.c:647:9: warning: iteration 107374182=
4 invokes undefined behavior [-Waggressive-loop-optimizations]
    sound/pci/echoaudio/echoaudio_dsp.c:658:9: warning: iteration 107374182=
4 invokes undefined behavior [-Waggressive-loop-optimizations]
    sound/pci/echoaudio/echoaudio_dsp.c:647:9: warning: iteration 107374182=
4 invokes undefined behavior [-Waggressive-loop-optimizations]

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
multi_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

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
netx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

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
nuc910_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
nuc960_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    drivers/gpio/gpio-omap.c:1152:34: warning: array =E2=80=98omap_gpio_mat=
ch=E2=80=99 assumed to have one element

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-10) =E2=80=94 FAIL, 6 errors, 0 warnings, 0 s=
ection mismatches

Errors:
    arch/arm/kernel/entry-common.S:164: Error: co-processor register expect=
ed -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/kernel/entry-common.S:173: Error: co-processor register expect=
ed -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:63: Error: co-processor register expected -- `mc=
r p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:136: Error: co-processor register expected -- `m=
cr p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:170: Error: co-processor register expected -- `m=
cr p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:298: Error: co-processor register expected -- `m=
cr p15,0,r0,c7,r5,4'

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
pistachio_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warning=
s, 0 section mismatches

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

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
pxa910_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
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
realview_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/arm/kernel/entry-common.S:164: Error: co-processor register expect=
ed -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/kernel/entry-common.S:173: Error: co-processor register expect=
ed -- `mcr p15,0,r0,c7,r5,4'

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section=
 mismatches

Errors:
    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3
    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-march=3D=
=E2=80=99

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    drivers/tty/serial/samsung.c:1794:34: warning: array =E2=80=98s3c24xx_u=
art_dt_match=E2=80=99 assumed to have one element

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

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
sunxi_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
tango4_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

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
tegra_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 section m=
ismatches

Warnings:
    arch/x86/entry/entry_32.S:482: Warning: no instruction mnemonic suffix =
given and no register operands; using default for `btr'
    ld: arch/x86/boot/compressed/head_32.o: warning: relocation in read-onl=
y section `.head.text'
    ld: warning: creating DT_TEXTREL in a PIE

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 4 warnings, 0 section=
 mismatches

Warnings:
    Warning: synced file at 'tools/objtool/arch/x86/include/asm/insn.h' dif=
fers from latest kernel version at 'arch/x86/include/asm/insn.h'
    arch/x86/entry/entry_64.S:1642: Warning: no instruction mnemonic suffix=
 given and no register operands; using default for `sysret'
    ld: arch/x86/boot/compressed/head_64.o: warning: relocation in read-onl=
y section `.head.text'
    ld: warning: creating DT_TEXTREL in a PIE

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

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
vexpress_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

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
vt8500_v6_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 6 errors, 0 warnings, =
0 section mismatches

Errors:
    arch/arm/kernel/entry-common.S:164: Error: co-processor register expect=
ed -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/kernel/entry-common.S:173: Error: co-processor register expect=
ed -- `mcr p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:63: Error: co-processor register expected -- `mc=
r p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:136: Error: co-processor register expected -- `m=
cr p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:170: Error: co-processor register expected -- `m=
cr p15,0,r0,c7,r5,4'
    arch/arm/mm/cache-v7.S:298: Error: co-processor register expected -- `m=
cr p15,0,r0,c7,r5,4'

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 4 warnings, 0 s=
ection mismatches

Warnings:
    Warning: synced file at 'tools/objtool/arch/x86/include/asm/insn.h' dif=
fers from latest kernel version at 'arch/x86/include/asm/insn.h'
    arch/x86/entry/entry_64.S:1642: Warning: no instruction mnemonic suffix=
 given and no register operands; using default for `sysret'
    ld: arch/x86/boot/compressed/head_64.o: warning: relocation in read-onl=
y section `.head.text'
    ld: warning: creating DT_TEXTREL in a PIE

---------------------------------------------------------------------------=
-----
x86_64_defconfig+x86-chromebook (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, =
4 warnings, 0 section mismatches

Warnings:
    Warning: synced file at 'tools/objtool/arch/x86/include/asm/insn.h' dif=
fers from latest kernel version at 'arch/x86/include/asm/insn.h'
    arch/x86/entry/entry_64.S:1642: Warning: no instruction mnemonic suffix=
 given and no register operands; using default for `sysret'
    ld: arch/x86/boot/compressed/head_64.o: warning: relocation in read-onl=
y section `.head.text'
    ld: warning: creating DT_TEXTREL in a PIE

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
xilfpga_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section m=
ismatches

Errors:
    arch/arm/kernel/spectre.c:13:14: error: expected =E2=80=98;=E2=80=99 be=
fore =E2=80=98}=E2=80=99 token

---
For more info write to <info@kernelci.org>
