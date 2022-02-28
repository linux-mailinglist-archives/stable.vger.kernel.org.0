Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F70E4C6561
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 10:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbiB1JFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 04:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234351AbiB1JF2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 04:05:28 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC6A2C101
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 01:04:43 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id o8so10817327pgf.9
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 01:04:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OMo4h8RggdoRXuc/xbSTAv8IKEsGupqCyi7B0WPhm+U=;
        b=suPH+TsG7Pdm9I3nSzV8EmLIBkw0T41iBIrLQhIbM+qOdpNNlU2qHryAcr/cmqMTV3
         lWlpwSc6dDgv7aJdGb1jqiIP5N/MhScn6c/VzGdkkfMiAOTz6KCQ0Sie3s6smMqnoNrA
         XXUehtehIPSwNrIVvTvZ7M80eQGTmTJ74ui0W/KUdWV7hese9JpnNqt0CiMb30OhCqui
         ANvgVYr70rLyODQaLklKonrymWC5jZyOr1Q90wKXr1UdQet+vKTGdKap4D3m4VBoauMF
         Mm0X8LFxvTGyDTtTvJA/+yhr94Mm7UN2OtWBpxedElxsxFbxAnZGNUIAu46aI8d5R6z4
         ZBPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OMo4h8RggdoRXuc/xbSTAv8IKEsGupqCyi7B0WPhm+U=;
        b=8D6DoEMfNg2ueFQID26wW/fQH2Xx1rrGBfO+0XbrEoZiK76Xdc+a7HUbt4TzynGaLQ
         ZVxkkogcUpqom0fRx0F45ejnS6FQuapmCwpBFDyxGUt8qiW8OI9wRl8OrxnWpbvN9hAy
         vcBt0SmA6VO/9QNtuhrM241blaIDaUBHSb4HqkCJwBsy8nx/Z1ctXiiNXbHFGoa2u82L
         SL2M1E4FL1F8IlSydPaJ/9ICzIANZAOXUhMNm7NvpQuQODYnIVMJaR7pJgUtdH/Cix7G
         aR1vPGDcAgWNgredJrpyOexji2N55KVtBmGXAUW51rsD83DK6zJ/dHX9lMHh3iy5Bmxk
         h5lA==
X-Gm-Message-State: AOAM531JF5/F/0uZ6RSoU7QyTZeNCWQRIWfx08lCAHC/1raV491B0BeF
        ux27U0rqxt3WAti1fjkaRGTmm21EXeX4o+lqZ7M=
X-Google-Smtp-Source: ABdhPJyUZuphlw1o+fn51TBL0AMKgdw8k15OqtllaSIkqQ/0TFnX3aGX5RbncVw3ILfXAIkPT0oYXw==
X-Received: by 2002:a63:a54:0:b0:378:907d:1fb6 with SMTP id z20-20020a630a54000000b00378907d1fb6mr4100910pgk.33.1646039082042;
        Mon, 28 Feb 2022 01:04:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j8-20020a056a00174800b004f26d3f5b03sm12954212pfc.39.2022.02.28.01.04.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 01:04:41 -0800 (PST)
Message-ID: <621c9029.1c69fb81.1380c.0756@mx.google.com>
Date:   Mon, 28 Feb 2022 01:04:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.181-47-g4cde2925825f
Subject: stable-rc/queue/5.4 build: 190 builds: 39 failed, 151 passed,
 76 errors, 55 warnings (v5.4.181-47-g4cde2925825f)
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

stable-rc/queue/5.4 build: 190 builds: 39 failed, 151 passed, 76 errors, 55=
 warnings (v5.4.181-47-g4cde2925825f)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.4=
/kernel/v5.4.181-47-g4cde2925825f/

Tree: stable-rc
Branch: queue/5.4
Git Describe: v5.4.181-47-g4cde2925825f
Git Commit: 4cde2925825fc566e69188f9ec2a1d85ee12cac8
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm:
    aspeed_g4_defconfig: (gcc-10) FAIL
    aspeed_g5_defconfig: (gcc-10) FAIL
    bcm2835_defconfig: (gcc-10) FAIL
    exynos_defconfig: (gcc-10) FAIL
    ezx_defconfig: (gcc-10) FAIL
    imote2_defconfig: (gcc-10) FAIL
    imx_v4_v5_defconfig: (gcc-10) FAIL
    imx_v6_v7_defconfig: (gcc-10) FAIL
    keystone_defconfig: (gcc-10) FAIL
    milbeaut_m10v_defconfig: (gcc-10) FAIL
    moxart_defconfig: (gcc-10) FAIL
    multi_v7_defconfig: (gcc-10) FAIL
    mv78xx0_defconfig: (gcc-10) FAIL
    mvebu_v7_defconfig: (gcc-10) FAIL
    mxs_defconfig: (gcc-10) FAIL
    omap1_defconfig: (gcc-10) FAIL
    omap2plus_defconfig: (gcc-10) FAIL
    oxnas_v6_defconfig: (gcc-10) FAIL
    pxa_defconfig: (gcc-10) FAIL
    qcom_defconfig: (gcc-10) FAIL
    rpc_defconfig: (gcc-10) FAIL
    shmobile_defconfig: (gcc-10) FAIL
    socfpga_defconfig: (gcc-10) FAIL
    tegra_defconfig: (gcc-10) FAIL
    vexpress_defconfig: (gcc-10) FAIL

i386:
    i386_defconfig: (gcc-10) FAIL

mips:
    fuloong2e_defconfig: (gcc-10) FAIL
    gpr_defconfig: (gcc-10) FAIL
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL
    ip32_defconfig: (gcc-10) FAIL
    lemote2f_defconfig: (gcc-10) FAIL
    malta_kvm_defconfig: (gcc-10) FAIL
    mtx1_defconfig: (gcc-10) FAIL
    nlm_xlp_defconfig: (gcc-10) FAIL
    nlm_xlr_defconfig: (gcc-10) FAIL
    pistachio_defconfig: (gcc-10) FAIL

x86_64:
    x86_64_defconfig: (gcc-10) FAIL
    x86_64_defconfig+x86-chromebook: (gcc-10) FAIL

Errors and Warnings Detected:

arc:

arm64:
    defconfig (gcc-10): 2 warnings
    defconfig+arm64-chromebook (gcc-10): 2 warnings

arm:
    aspeed_g4_defconfig (gcc-10): 2 errors, 1 warning
    aspeed_g5_defconfig (gcc-10): 2 errors, 1 warning
    assabet_defconfig (gcc-10): 1 warning
    bcm2835_defconfig (gcc-10): 2 errors, 1 warning
    collie_defconfig (gcc-10): 1 warning
    exynos_defconfig (gcc-10): 2 errors, 1 warning
    ezx_defconfig (gcc-10): 2 errors, 1 warning
    h3600_defconfig (gcc-10): 1 warning
    imote2_defconfig (gcc-10): 2 errors, 1 warning
    imx_v4_v5_defconfig (gcc-10): 2 errors, 1 warning
    imx_v6_v7_defconfig (gcc-10): 2 errors, 1 warning
    keystone_defconfig (gcc-10): 2 errors, 1 warning
    milbeaut_m10v_defconfig (gcc-10): 2 errors, 1 warning
    moxart_defconfig (gcc-10): 2 errors, 1 warning
    multi_v7_defconfig (gcc-10): 2 errors, 1 warning
    mv78xx0_defconfig (gcc-10): 2 errors, 1 warning
    mvebu_v7_defconfig (gcc-10): 2 errors, 1 warning
    mxs_defconfig (gcc-10): 2 errors, 1 warning
    neponset_defconfig (gcc-10): 1 warning
    omap1_defconfig (gcc-10): 2 errors, 1 warning
    omap2plus_defconfig (gcc-10): 2 errors, 1 warning
    oxnas_v6_defconfig (gcc-10): 2 errors, 1 warning
    pxa_defconfig (gcc-10): 2 errors, 1 warning
    qcom_defconfig (gcc-10): 2 errors, 1 warning
    rpc_defconfig (gcc-10): 4 errors
    shannon_defconfig (gcc-10): 1 warning
    shmobile_defconfig (gcc-10): 2 errors, 1 warning
    socfpga_defconfig (gcc-10): 2 errors, 1 warning
    tegra_defconfig (gcc-10): 2 errors, 1 warning
    vexpress_defconfig (gcc-10): 2 errors, 1 warning

i386:
    allnoconfig (gcc-10): 2 warnings
    i386_defconfig (gcc-10): 2 errors, 1 warning
    tinyconfig (gcc-10): 2 warnings

mips:
    fuloong2e_defconfig (gcc-10): 2 errors, 1 warning
    gpr_defconfig (gcc-10): 2 errors, 1 warning
    ip32_defconfig (gcc-10): 2 errors, 1 warning
    lemote2f_defconfig (gcc-10): 2 errors, 1 warning
    malta_kvm_defconfig (gcc-10): 2 errors, 1 warning
    mtx1_defconfig (gcc-10): 2 errors, 1 warning
    nlm_xlp_defconfig (gcc-10): 2 errors, 1 warning
    nlm_xlr_defconfig (gcc-10): 2 errors, 1 warning
    pistachio_defconfig (gcc-10): 2 errors, 1 warning

riscv:

x86_64:
    allnoconfig (gcc-10): 3 warnings
    tinyconfig (gcc-10): 3 warnings
    x86_64_defconfig (gcc-10): 2 errors, 1 warning
    x86_64_defconfig+x86-chromebook (gcc-10): 2 errors, 1 warning

Errors summary:

    36   kernel/trace/trace_events_trigger.c:1225:3: error: too few argumen=
ts to function =E2=80=98__trace_stack=E2=80=99
    36   kernel/trace/trace_events_trigger.c:1225:27: error: implicit decla=
ration of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-fu=
nction-declaration]
    2    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3m
    2    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-marc=
h=3D=E2=80=99

Warnings summary:

    36   cc1: some warnings being treated as errors
    5    drivers/video/fbdev/sa1100fb.c:975:21: warning: =E2=80=98sa1100fb_=
min_dma_period=E2=80=99 defined but not used [-Wunused-function]
    4    ld: warning: creating DT_TEXTREL in a PIE
    4    arch/arm64/include/asm/memory.h:238:15: warning: cast from pointer=
 to integer of different size [-Wpointer-to-int-cast]
    2    ld: arch/x86/boot/compressed/head_64.o: warning: relocation in rea=
d-only section `.head.text'
    2    ld: arch/x86/boot/compressed/head_32.o: warning: relocation in rea=
d-only section `.head.text'
    2    arch/x86/entry/entry_64.S:1732: Warning: no instruction mnemonic s=
uffix given and no register operands; using default for `sysret'

Section mismatches summary:

    2    WARNING: vmlinux.o(.text+0xcacc): Section mismatch in reference fr=
om the function __arm_ioremap_pfn_caller() to the function .meminit.text:me=
mblock_is_map_memory()
    2    WARNING: vmlinux.o(.text+0x7ecc): Section mismatch in reference fr=
om the function __arm_ioremap_pfn_caller() to the function .meminit.text:me=
mblock_is_map_memory()
    1    WARNING: vmlinux.o(.text.unlikely+0x3774): Section mismatch in ref=
erence from the function pmax_setup_memory_region() to the function .init.t=
ext:add_memory_region()
    1    WARNING: vmlinux.o(.text.unlikely+0x349c): Section mismatch in ref=
erence from the function pmax_setup_memory_region() to the function .init.t=
ext:add_memory_region()
    1    WARNING: vmlinux.o(.text+0xcf00): Section mismatch in reference fr=
om the function __arm_ioremap_pfn_caller() to the function .meminit.text:me=
mblock_is_map_memory()
    1    WARNING: vmlinux.o(.text+0xce00): Section mismatch in reference fr=
om the function __arm_ioremap_pfn_caller() to the function .meminit.text:me=
mblock_is_map_memory()
    1    WARNING: vmlinux.o(.text+0xcd0c): Section mismatch in reference fr=
om the function __arm_ioremap_pfn_caller() to the function .meminit.text:me=
mblock_is_map_memory()
    1    WARNING: vmlinux.o(.text+0xcc00): Section mismatch in reference fr=
om the function __arm_ioremap_pfn_caller() to the function .meminit.text:me=
mblock_is_map_memory()
    1    WARNING: vmlinux.o(.text+0xcad4): Section mismatch in reference fr=
om the function __arm_ioremap_pfn_caller() to the function .meminit.text:me=
mblock_is_map_memory()
    1    WARNING: vmlinux.o(.text+0xcaac): Section mismatch in reference fr=
om the function __arm_ioremap_pfn_caller() to the function .meminit.text:me=
mblock_is_map_memory()
    1    WARNING: vmlinux.o(.text+0xc978): Section mismatch in reference fr=
om the function __arm_ioremap_pfn_caller() to the function .meminit.text:me=
mblock_is_map_memory()
    1    WARNING: vmlinux.o(.text+0xc834): Section mismatch in reference fr=
om the function __arm_ioremap_pfn_caller() to the function .meminit.text:me=
mblock_is_map_memory()
    1    WARNING: vmlinux.o(.text+0xb8d0): Section mismatch in reference fr=
om the function __arm_ioremap_pfn_caller() to the function .meminit.text:me=
mblock_is_map_memory()
    1    WARNING: vmlinux.o(.text+0x7530): Section mismatch in reference fr=
om the function __arm_ioremap_pfn_caller() to the function .meminit.text:me=
mblock_is_map_memory()

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
allnoconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 sectio=
n mismatches

Warnings:
    arch/x86/entry/entry_64.S:1732: Warning: no instruction mnemonic suffix=
 given and no register operands; using default for `sysret'
    ld: arch/x86/boot/compressed/head_64.o: warning: relocation in read-onl=
y section `.head.text'
    ld: warning: creating DT_TEXTREL in a PIE

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section =
mismatches

Warnings:
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
aspeed_g4_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    drivers/video/fbdev/sa1100fb.c:975:21: warning: =E2=80=98sa1100fb_min_d=
ma_period=E2=80=99 defined but not used [-Wunused-function]

Section mismatches:
    WARNING: vmlinux.o(.text+0xcacc): Section mismatch in reference from th=
e function __arm_ioremap_pfn_caller() to the function .meminit.text:membloc=
k_is_map_memory()

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

Section mismatches:
    WARNING: vmlinux.o(.text+0xcc00): Section mismatch in reference from th=
e function __arm_ioremap_pfn_caller() to the function .meminit.text:membloc=
k_is_map_memory()

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

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
cavium_octeon_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

Section mismatches:
    WARNING: vmlinux.o(.text+0x7530): Section mismatch in reference from th=
e function __arm_ioremap_pfn_caller() to the function .meminit.text:membloc=
k_is_map_memory()

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

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
colibri_pxa270_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    drivers/video/fbdev/sa1100fb.c:975:21: warning: =E2=80=98sa1100fb_min_d=
ma_period=E2=80=99 defined but not used [-Wunused-function]

Section mismatches:
    WARNING: vmlinux.o(.text+0xb8d0): Section mismatch in reference from th=
e function __arm_ioremap_pfn_caller() to the function .meminit.text:membloc=
k_is_map_memory()

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
decstation_64_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

Section mismatches:
    WARNING: vmlinux.o(.text.unlikely+0x3774): Section mismatch in referenc=
e from the function pmax_setup_memory_region() to the function .init.text:a=
dd_memory_region()

---------------------------------------------------------------------------=
-----
decstation_r4k_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warning=
s, 0 section mismatches

Section mismatches:
    WARNING: vmlinux.o(.text.unlikely+0x349c): Section mismatch in referenc=
e from the function pmax_setup_memory_region() to the function .init.text:a=
dd_memory_region()

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section m=
ismatches

Warnings:
    arch/arm64/include/asm/memory.h:238:15: warning: cast from pointer to i=
nteger of different size [-Wpointer-to-int-cast]
    arch/arm64/include/asm/memory.h:238:15: warning: cast from pointer to i=
nteger of different size [-Wpointer-to-int-cast]

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
defconfig+arm64-chromebook (arm64, gcc-10) =E2=80=94 PASS, 0 errors, 2 warn=
ings, 0 section mismatches

Warnings:
    arch/arm64/include/asm/memory.h:238:15: warning: cast from pointer to i=
nteger of different size [-Wpointer-to-int-cast]
    arch/arm64/include/asm/memory.h:238:15: warning: cast from pointer to i=
nteger of different size [-Wpointer-to-int-cast]

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

Section mismatches:
    WARNING: vmlinux.o(.text+0x7ecc): Section mismatch in reference from th=
e function __arm_ioremap_pfn_caller() to the function .meminit.text:membloc=
k_is_map_memory()

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

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
gpr_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    drivers/video/fbdev/sa1100fb.c:975:21: warning: =E2=80=98sa1100fb_min_d=
ma_period=E2=80=99 defined but not used [-Wunused-function]

Section mismatches:
    WARNING: vmlinux.o(.text+0xcacc): Section mismatch in reference from th=
e function __arm_ioremap_pfn_caller() to the function .meminit.text:membloc=
k_is_map_memory()

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: vmlinux.o(.text+0xce00): Section mismatch in reference from th=
e function __arm_ioremap_pfn_caller() to the function .meminit.text:membloc=
k_is_map_memory()

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
i386_defconfig (i386, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

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
ip32_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

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

Section mismatches:
    WARNING: vmlinux.o(.text+0xc978): Section mismatch in reference from th=
e function __arm_ioremap_pfn_caller() to the function .meminit.text:membloc=
k_is_map_memory()

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

Section mismatches:
    WARNING: vmlinux.o(.text+0xcad4): Section mismatch in reference from th=
e function __arm_ioremap_pfn_caller() to the function .meminit.text:membloc=
k_is_map_memory()

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

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
malta_kvm_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnin=
gs, 0 section mismatches

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
markeins_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
milbeaut_m10v_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, =
0 section mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

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
mtx1_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

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
multi_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    drivers/video/fbdev/sa1100fb.c:975:21: warning: =E2=80=98sa1100fb_min_d=
ma_period=E2=80=99 defined but not used [-Wunused-function]

Section mismatches:
    WARNING: vmlinux.o(.text+0xcd0c): Section mismatch in reference from th=
e function __arm_ioremap_pfn_caller() to the function .meminit.text:membloc=
k_is_map_memory()

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
nlm_xlp_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

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
omap1_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

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
oxnas_v6_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

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
pistachio_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

Section mismatches:
    WARNING: vmlinux.o(.text+0xc834): Section mismatch in reference from th=
e function __arm_ioremap_pfn_caller() to the function .meminit.text:membloc=
k_is_map_memory()

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warning=
s, 0 section mismatches

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

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
pxa_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

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
rm200_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

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
rt305x_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

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
sb1250_swarm_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    drivers/video/fbdev/sa1100fb.c:975:21: warning: =E2=80=98sa1100fb_min_d=
ma_period=E2=80=99 defined but not used [-Wunused-function]

Section mismatches:
    WARNING: vmlinux.o(.text+0xcaac): Section mismatch in reference from th=
e function __arm_ioremap_pfn_caller() to the function .meminit.text:membloc=
k_is_map_memory()

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

Section mismatches:
    WARNING: vmlinux.o(.text+0xcf00): Section mismatch in reference from th=
e function __arm_ioremap_pfn_caller() to the function .meminit.text:membloc=
k_is_map_memory()

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

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
tango4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

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
tegra_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section m=
ismatches

Warnings:
    ld: arch/x86/boot/compressed/head_32.o: warning: relocation in read-onl=
y section `.head.text'
    ld: warning: creating DT_TEXTREL in a PIE

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 3 warnings, 0 section=
 mismatches

Warnings:
    arch/x86/entry/entry_64.S:1732: Warning: no instruction mnemonic suffix=
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
u300_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

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
vexpress_defconfig (arm, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

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
x86_64_defconfig (x86_64, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
x86_64_defconfig+x86-chromebook (x86_64, gcc-10) =E2=80=94 FAIL, 2 errors, =
1 warning, 0 section mismatches

Errors:
    kernel/trace/trace_events_trigger.c:1225:27: error: implicit declaratio=
n of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-functio=
n-declaration]
    kernel/trace/trace_events_trigger.c:1225:3: error: too few arguments to=
 function =E2=80=98__trace_stack=E2=80=99

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---
For more info write to <info@kernelci.org>
