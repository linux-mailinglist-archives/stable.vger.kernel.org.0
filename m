Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25FB64C6594
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 10:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbiB1JWS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 04:22:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbiB1JWS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 04:22:18 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B8B57B2E
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 01:21:37 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id s11so218201pfu.13
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 01:21:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oMaZutxp+Zg5gofmnrsc2ciA/yptgFoWHWpygG3YyzE=;
        b=fdS6wPV2o2ErM+EeY0x9gO3kUEzp8ap0AOrFmAkdYSic4oQDJAwpqwQuHxPwZEBScU
         8cIFhK32Gzj6DTueUouZjWLZOWENyTHfZp6mJmW87CWIzx4HZg3nQqhqOhctKnrYshe6
         XAIAWt9CL3N+zDVItdrpZkqx50MLLW6pViXj3I8NmAAoBSflX8ulwfNzUPeW5pwI+MaL
         Wh/S3CgE1D637P6DJNDXgydpYlhwwMxw6niHnpVSW37H2umGWms92c59vtAShWwlgj3T
         U+9jGFNFxqIT8rJZUun1TFjQqz1TFi1Eotw4i35zyZ7iDAKzS9vS8rk1AT2kQkPw/qFT
         JgGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oMaZutxp+Zg5gofmnrsc2ciA/yptgFoWHWpygG3YyzE=;
        b=Xuto2khmvYUFBGAP2fX7YalZj1kyXYALejFufZeAKhupSy6tSkxEUXylVw6VaZah6U
         TzwsCEdlteZo424d1lPiZ810Duet9o+1W7Sp0WchNO1HR8bRoFidQTkY5EMnCca7Zvyk
         YmS0xUNbaieYqHqMG6g+WH1ZH9rUNwbZkUAI80QZgI42xMyGflKlf1rF53Se96Gl1WuH
         d+VuEwTcE64AskhSQZRl9y+2fk6vELBif2NTjM1taEB0/4mRt/fMAD3gHGSBTUxXdrTP
         DumRgJ7IMq1fHTRuITGngKMFiuEsYzAtnl6ExhHPIpFNc/BDjhfOnRmHGptEIY1QewNF
         FO5A==
X-Gm-Message-State: AOAM531+ZPy/B29PiiOWPVwKShJGdhhzv+HNQ3XxW4I4AhgiXpOfDIgv
        /VeGCD4MD28L1S1vRoeBhIvQvs4bTXhltcCnUVs=
X-Google-Smtp-Source: ABdhPJyb2wn6VdydmUAJuyJPeXZqkeplsNSaXe/5fCkPWagTRiYRTZH94Ub0fhueYV3eGJRxbbWuNQ==
X-Received: by 2002:a05:6a00:2cd:b0:4e1:1989:5b7f with SMTP id b13-20020a056a0002cd00b004e119895b7fmr20451701pft.3.1646040096006;
        Mon, 28 Feb 2022 01:21:36 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g9-20020a056a0023c900b004e10365c47dsm12869116pfc.192.2022.02.28.01.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 01:21:35 -0800 (PST)
Message-ID: <621c941f.1c69fb81.5028e.fca8@mx.google.com>
Date:   Mon, 28 Feb 2022 01:21:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.102-71-g10341c2171f3
Subject: stable-rc/queue/5.10 build: 164 builds: 37 failed, 127 passed,
 72 errors, 43 warnings (v5.10.102-71-g10341c2171f3)
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

stable-rc/queue/5.10 build: 164 builds: 37 failed, 127 passed, 72 errors, 4=
3 warnings (v5.10.102-71-g10341c2171f3)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/queue%2F5.1=
0/kernel/v5.10.102-71-g10341c2171f3/

Tree: stable-rc
Branch: queue/5.10
Git Describe: v5.10.102-71-g10341c2171f3
Git Commit: 10341c2171f3ecd006fd91cc6b7717250ca26111
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
    vexpress_defconfig: (gcc-10) FAIL

i386:
    i386_defconfig: (gcc-10) FAIL

mips:
    fuloong2e_defconfig: (gcc-10) FAIL
    gcw0_defconfig: (gcc-10) FAIL
    gpr_defconfig: (gcc-10) FAIL
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL
    ip32_defconfig: (gcc-10) FAIL
    lemote2f_defconfig: (gcc-10) FAIL
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

arm:
    aspeed_g4_defconfig (gcc-10): 2 errors, 1 warning
    aspeed_g5_defconfig (gcc-10): 2 errors, 1 warning
    bcm2835_defconfig (gcc-10): 2 errors, 1 warning
    exynos_defconfig (gcc-10): 2 errors, 1 warning
    ezx_defconfig (gcc-10): 2 errors, 1 warning
    imote2_defconfig (gcc-10): 2 errors, 1 warning
    imx_v4_v5_defconfig (gcc-10): 2 errors, 1 warning
    imx_v6_v7_defconfig (gcc-10): 2 errors, 1 warning
    keystone_defconfig (gcc-10): 2 errors, 1 warning
    moxart_defconfig (gcc-10): 2 errors, 1 warning
    multi_v7_defconfig (gcc-10): 2 errors, 1 warning
    mv78xx0_defconfig (gcc-10): 2 errors, 1 warning
    mvebu_v7_defconfig (gcc-10): 2 errors, 1 warning
    mxs_defconfig (gcc-10): 2 errors, 1 warning
    omap1_defconfig (gcc-10): 2 errors, 1 warning
    omap2plus_defconfig (gcc-10): 2 errors, 1 warning
    oxnas_v6_defconfig (gcc-10): 2 errors, 1 warning
    pxa_defconfig (gcc-10): 2 errors, 1 warning
    qcom_defconfig (gcc-10): 2 errors, 1 warning
    rpc_defconfig (gcc-10): 4 errors
    shmobile_defconfig (gcc-10): 2 errors, 1 warning
    socfpga_defconfig (gcc-10): 2 errors, 1 warning
    vexpress_defconfig (gcc-10): 2 errors, 1 warning

i386:
    i386_defconfig (gcc-10): 2 errors, 1 warning

mips:
    32r2el_defconfig (gcc-10): 1 warning
    decstation_64_defconfig (gcc-10): 1 warning
    decstation_defconfig (gcc-10): 1 warning
    decstation_r4k_defconfig (gcc-10): 1 warning
    fuloong2e_defconfig (gcc-10): 2 errors, 1 warning
    gcw0_defconfig (gcc-10): 2 errors, 1 warning
    gpr_defconfig (gcc-10): 2 errors, 1 warning
    ip32_defconfig (gcc-10): 2 errors, 1 warning
    lemote2f_defconfig (gcc-10): 2 errors, 1 warning
    mtx1_defconfig (gcc-10): 2 errors, 1 warning
    nlm_xlp_defconfig (gcc-10): 2 errors, 1 warning
    nlm_xlr_defconfig (gcc-10): 2 errors, 1 warning
    pistachio_defconfig (gcc-10): 2 errors, 1 warning
    rm200_defconfig (gcc-10): 1 warning

riscv:
    rv32_defconfig (gcc-10): 4 warnings

x86_64:
    x86_64_defconfig (gcc-10): 2 errors, 1 warning
    x86_64_defconfig+x86-chromebook (gcc-10): 2 errors, 1 warning

Errors summary:

    34   kernel/trace/trace_events_trigger.c:1225:3: error: too few argumen=
ts to function =E2=80=98__trace_stack=E2=80=99
    34   kernel/trace/trace_events_trigger.c:1225:27: error: implicit decla=
ration of function =E2=80=98tracing_gen_ctx=E2=80=99 [-Werror=3Dimplicit-fu=
nction-declaration]
    2    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3m
    2    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-marc=
h=3D=E2=80=99

Warnings summary:

    34   cc1: some warnings being treated as errors
    3    kernel/rcu/tasks.h:707:13: warning: =E2=80=98show_rcu_tasks_rude_g=
p_kthread=E2=80=99 defined but not used [-Wunused-function]
    2    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [=
-Wcpp]
    2    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemente=
d [-Wcpp]
    1    drivers/block/paride/bpck.c:32: warning: "PC" redefined
    1    WARNING: modpost: Symbol info of vmlinux is missing. Unresolved sy=
mbol check will be entirely skipped.

Section mismatches summary:

    1    WARNING: modpost: vmlinux.o(.text+0xd040): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()
    1    WARNING: modpost: vmlinux.o(.text+0xce9c): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()
    1    WARNING: modpost: vmlinux.o(.text+0xcda4): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()
    1    WARNING: modpost: vmlinux.o(.text+0xcd38): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()
    1    WARNING: modpost: vmlinux.o(.text+0xcb84): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()
    1    WARNING: modpost: vmlinux.o(.text+0xcb74): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()
    1    WARNING: modpost: vmlinux.o(.text+0xcb6c): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()
    1    WARNING: modpost: vmlinux.o(.text+0xcb4c): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()
    1    WARNING: modpost: vmlinux.o(.text+0xcaa8): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()
    1    WARNING: modpost: vmlinux.o(.text+0xc8ec): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()
    1    WARNING: modpost: vmlinux.o(.text+0xb904): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()
    1    WARNING: modpost: vmlinux.o(.text+0x7670): Section mismatch in ref=
erence from the function __arm_ioremap_pfn_caller() to the function .memini=
t.text:memblock_is_map_memory()

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
    WARNING: modpost: Symbol info of vmlinux is missing. Unresolved symbol =
check will be entirely skipped.

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

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
assabet_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xcb6c): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

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
    WARNING: modpost: vmlinux.o(.text+0xcd38): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

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
bigsur_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
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
    WARNING: modpost: vmlinux.o(.text+0x7670): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

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

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xb904): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

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
decstation_64_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning,=
 0 section mismatches

Warnings:
    kernel/rcu/tasks.h:707:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    kernel/rcu/tasks.h:707:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]

---------------------------------------------------------------------------=
-----
decstation_r4k_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning=
, 0 section mismatches

Warnings:
    kernel/rcu/tasks.h:707:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]

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
ebsa110_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

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
gcw0_defconfig (mips, gcc-10) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
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
h3600_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xcb84): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xce9c): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

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
jazz_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xcaa8): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

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
    WARNING: modpost: vmlinux.o(.text+0xcb74): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

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
magician_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

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
maltasmvp_eva_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

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
neponset_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xcda4): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

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
nommu_k210_defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

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
    WARNING: modpost: vmlinux.o(.text+0xc8ec): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

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
rv32_defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 4 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [-Wcpp]
    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemented [-W=
cpp]
    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [-Wcpp]
    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemented [-W=
cpp]

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
shannon_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

Section mismatches:
    WARNING: modpost: vmlinux.o(.text+0xcb4c): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

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
    WARNING: modpost: vmlinux.o(.text+0xd040): Section mismatch in referenc=
e from the function __arm_ioremap_pfn_caller() to the function .meminit.tex=
t:memblock_is_map_memory()

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
tinyconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

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

---
For more info write to <info@kernelci.org>
