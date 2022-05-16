Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA175528B7A
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 19:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiEPRAp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 13:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245193AbiEPRAo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 13:00:44 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E054AE
        for <stable@vger.kernel.org>; Mon, 16 May 2022 10:00:39 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id c14so14597164pfn.2
        for <stable@vger.kernel.org>; Mon, 16 May 2022 10:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=31cJ5pREd1AmJPLZZVT/YLbZKK4pY98uZjmK0wMzuTk=;
        b=Bprw27UiJ2P0l269lf+7tmGiLtR5knM5li8VBZ78/BVH+Qy4qq5Wp12zhn7a2XcAXB
         RYw2uNXuRxFyZ9qJxgvEpEjpKOFbeVNYYIK08VXgw1IgJhMg8xdad36jNA1eX5Roc9xa
         CFCkBz1dinMBegYVI2WsH4DyC22Zxr0MwjwM7nlKLVrM4t9Pxm53xMyrFWyorUbjG2P7
         ESt7a8n4kCh9a9DfNR5Cn7Mbs1HHzWcIdu9YgDfCE/LIJ5tdJPOWY09TCTonrLCcec2B
         XPvsjHN5exxZ/K4oZzqjPtJhUJeNCKn5quaWSvcTCcBMEULDjIQxCjeLnYMiFWQLT9J6
         6Okg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=31cJ5pREd1AmJPLZZVT/YLbZKK4pY98uZjmK0wMzuTk=;
        b=Qqgpio4qRdbgWYOnVfYSLSLw1Cwrvl+W85KgFldUmdIBoEAJP5k1QUNgyKXTXEqb1e
         5JyZ46ft0Az6Obpp0UaLg8pPOQIBpRXjYChQ8G2tvDRAHJSEgXAPuvxdO8/beO6W6kd4
         SKQEDnzYwpYHWWtmR2y35BikUb9taEYdSFdPLbnc3LqKQtTEy2YPM0vWN6V0tpLu+GoM
         tlGyCoBvZ/P9lMi6I9BMokBCHZPsNtNzCnznt1Ntuqk1/eug+J2Z3GLmElm65Kr1CVjT
         Uyq6QSZRZYiPVvJ/nfBMpO7M+NABRkYbJ/KqGnOWHOJTLnjOg6TX+mwEf52F3aFSo4Js
         pCEw==
X-Gm-Message-State: AOAM530xvSvp+rLcKec2DuUfBEXETkkNf8f41siGrXbpRbH3/Kefx8M5
        EkKpSJvytRyJ+XC8ZMyn+fscnolYSvmvokaFoN8=
X-Google-Smtp-Source: ABdhPJy7IUJ20ha/ECp1DlRl9h1ZJXkAfsrkrqWyZg/2/bo+M3wzpJ3/f3HlXU6zwQbKu9aQx1qnpw==
X-Received: by 2002:a63:d215:0:b0:3f2:76c5:d0aa with SMTP id a21-20020a63d215000000b003f276c5d0aamr3628996pgg.399.1652720437403;
        Mon, 16 May 2022 10:00:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bd36-20020a056a0027a400b00512d13016d0sm6940979pfb.159.2022.05.16.10.00.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 10:00:36 -0700 (PDT)
Message-ID: <62828334.1c69fb81.22de5.1135@mx.google.com>
Date:   Mon, 16 May 2022 10:00:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.116-65-g11c5de3d33a97
Subject: stable-rc/linux-5.10.y build: 185 builds: 3 failed, 182 passed,
 4 errors, 146 warnings (v5.10.116-65-g11c5de3d33a97)
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

stable-rc/linux-5.10.y build: 185 builds: 3 failed, 182 passed, 4 errors, 1=
46 warnings (v5.10.116-65-g11c5de3d33a97)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.10.=
y/kernel/v5.10.116-65-g11c5de3d33a97/

Tree: stable-rc
Branch: linux-5.10.y
Git Describe: v5.10.116-65-g11c5de3d33a97
Git Commit: 11c5de3d33a97e81943542d428d2a9c665e3e6da
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 7 unique architectures

Build Failures Detected:

arm:
    rpc_defconfig: (gcc-10) FAIL

mips:
    ip27_defconfig: (gcc-10) FAIL
    ip28_defconfig: (gcc-10) FAIL

Errors and Warnings Detected:

arc:
    axs103_defconfig (gcc-10): 1 warning
    axs103_smp_defconfig (gcc-10): 1 warning
    haps_hs_defconfig (gcc-10): 1 warning
    haps_hs_smp_defconfig (gcc-10): 1 warning
    hsdk_defconfig (gcc-10): 1 warning
    nsimosci_hs_defconfig (gcc-10): 1 warning
    nsimosci_hs_smp_defconfig (gcc-10): 1 warning
    vdk_hs38_defconfig (gcc-10): 1 warning
    vdk_hs38_smp_defconfig (gcc-10): 1 warning

arm64:
    defconfig (gcc-10): 1 warning
    defconfig+arm64-chromebook (gcc-10): 1 warning

arm:
    assabet_defconfig (gcc-10): 1 warning
    at91_dt_defconfig (gcc-10): 1 warning
    axm55xx_defconfig (gcc-10): 1 warning
    badge4_defconfig (gcc-10): 1 warning
    bcm2835_defconfig (gcc-10): 1 warning
    cerfcube_defconfig (gcc-10): 1 warning
    cm_x300_defconfig (gcc-10): 1 warning
    colibri_pxa270_defconfig (gcc-10): 1 warning
    colibri_pxa300_defconfig (gcc-10): 1 warning
    corgi_defconfig (gcc-10): 1 warning
    davinci_all_defconfig (gcc-10): 1 warning
    dove_defconfig (gcc-10): 1 warning
    ebsa110_defconfig (gcc-10): 1 warning
    ep93xx_defconfig (gcc-10): 1 warning
    eseries_pxa_defconfig (gcc-10): 1 warning
    exynos_defconfig (gcc-10): 1 warning
    ezx_defconfig (gcc-10): 1 warning
    footbridge_defconfig (gcc-10): 1 warning
    h3600_defconfig (gcc-10): 1 warning
    hisi_defconfig (gcc-10): 1 warning
    imote2_defconfig (gcc-10): 1 warning
    imx_v4_v5_defconfig (gcc-10): 1 warning
    imx_v6_v7_defconfig (gcc-10): 1 warning
    integrator_defconfig (gcc-10): 1 warning
    iop32x_defconfig (gcc-10): 1 warning
    ixp4xx_defconfig (gcc-10): 1 warning
    keystone_defconfig (gcc-10): 1 warning
    lart_defconfig (gcc-10): 1 warning
    lpc32xx_defconfig (gcc-10): 1 warning
    lpd270_defconfig (gcc-10): 1 warning
    lubbock_defconfig (gcc-10): 1 warning
    magician_defconfig (gcc-10): 1 warning
    mainstone_defconfig (gcc-10): 1 warning
    mini2440_defconfig (gcc-10): 1 warning
    mmp2_defconfig (gcc-10): 1 warning
    mps2_defconfig (gcc-10): 1 warning
    multi_v5_defconfig (gcc-10): 1 warning
    multi_v7_defconfig (gcc-10): 1 warning
    mvebu_v5_defconfig (gcc-10): 1 warning
    mvebu_v7_defconfig (gcc-10): 1 warning
    mxs_defconfig (gcc-10): 1 warning
    neponset_defconfig (gcc-10): 1 warning
    netwinder_defconfig (gcc-10): 1 warning
    nhk8815_defconfig (gcc-10): 1 warning
    omap1_defconfig (gcc-10): 1 warning
    omap2plus_defconfig (gcc-10): 1 warning
    orion5x_defconfig (gcc-10): 1 warning
    pcm027_defconfig (gcc-10): 1 warning
    pleb_defconfig (gcc-10): 1 warning
    pxa168_defconfig (gcc-10): 1 warning
    pxa255-idp_defconfig (gcc-10): 1 warning
    pxa3xx_defconfig (gcc-10): 1 warning
    pxa910_defconfig (gcc-10): 1 warning
    pxa_defconfig (gcc-10): 1 warning
    qcom_defconfig (gcc-10): 1 warning
    realview_defconfig (gcc-10): 1 warning
    rpc_defconfig (gcc-10): 4 errors
    s3c2410_defconfig (gcc-10): 1 warning
    sama5_defconfig (gcc-10): 1 warning
    shannon_defconfig (gcc-10): 1 warning
    shmobile_defconfig (gcc-10): 1 warning
    simpad_defconfig (gcc-10): 1 warning
    socfpga_defconfig (gcc-10): 1 warning
    spear13xx_defconfig (gcc-10): 1 warning
    spitz_defconfig (gcc-10): 1 warning
    sunxi_defconfig (gcc-10): 1 warning
    tango4_defconfig (gcc-10): 1 warning
    tegra_defconfig (gcc-10): 1 warning
    trizeps4_defconfig (gcc-10): 1 warning
    u8500_defconfig (gcc-10): 1 warning
    versatile_defconfig (gcc-10): 1 warning
    vexpress_defconfig (gcc-10): 1 warning
    viper_defconfig (gcc-10): 1 warning
    vt8500_v6_v7_defconfig (gcc-10): 1 warning
    xcep_defconfig (gcc-10): 1 warning
    zeus_defconfig (gcc-10): 1 warning

i386:
    i386_defconfig (gcc-10): 1 warning

mips:
    32r2el_defconfig (gcc-10): 2 warnings
    bigsur_defconfig (gcc-10): 1 warning
    bmips_be_defconfig (gcc-10): 1 warning
    bmips_stb_defconfig (gcc-10): 1 warning
    capcella_defconfig (gcc-10): 1 warning
    cavium_octeon_defconfig (gcc-10): 1 warning
    ci20_defconfig (gcc-10): 1 warning
    cobalt_defconfig (gcc-10): 1 warning
    cu1000-neo_defconfig (gcc-10): 1 warning
    cu1830-neo_defconfig (gcc-10): 1 warning
    db1xxx_defconfig (gcc-10): 1 warning
    decstation_64_defconfig (gcc-10): 2 warnings
    decstation_defconfig (gcc-10): 2 warnings
    decstation_r4k_defconfig (gcc-10): 2 warnings
    fuloong2e_defconfig (gcc-10): 1 warning
    gpr_defconfig (gcc-10): 1 warning
    ip22_defconfig (gcc-10): 1 warning
    ip32_defconfig (gcc-10): 1 warning
    jazz_defconfig (gcc-10): 1 warning
    jmr3927_defconfig (gcc-10): 1 warning
    lemote2f_defconfig (gcc-10): 2 warnings
    loongson1b_defconfig (gcc-10): 1 warning
    loongson1c_defconfig (gcc-10): 1 warning
    loongson3_defconfig (gcc-10): 1 warning
    malta_defconfig (gcc-10): 1 warning
    malta_kvm_defconfig (gcc-10): 1 warning
    malta_kvm_guest_defconfig (gcc-10): 1 warning
    malta_qemu_32r6_defconfig (gcc-10): 1 warning
    maltaaprp_defconfig (gcc-10): 1 warning
    maltasmvp_defconfig (gcc-10): 1 warning
    maltasmvp_eva_defconfig (gcc-10): 1 warning
    maltaup_defconfig (gcc-10): 1 warning
    maltaup_xpa_defconfig (gcc-10): 1 warning
    mpc30x_defconfig (gcc-10): 1 warning
    mtx1_defconfig (gcc-10): 1 warning
    nlm_xlp_defconfig (gcc-10): 1 warning
    nlm_xlr_defconfig (gcc-10): 1 warning
    pistachio_defconfig (gcc-10): 1 warning
    rbtx49xx_defconfig (gcc-10): 1 warning
    rm200_defconfig (gcc-10): 2 warnings
    sb1250_swarm_defconfig (gcc-10): 1 warning
    tb0219_defconfig (gcc-10): 1 warning
    tb0226_defconfig (gcc-10): 1 warning
    tb0287_defconfig (gcc-10): 1 warning
    workpad_defconfig (gcc-10): 1 warning

riscv:
    defconfig (gcc-10): 1 warning
    rv32_defconfig (gcc-10): 5 warnings

x86_64:
    x86_64_defconfig (gcc-10): 1 warning
    x86_64_defconfig+x86-chromebook (gcc-10): 1 warning

Errors summary:

    2    arm-linux-gnueabihf-gcc: error: unrecognized -march target: armv3m
    2    arm-linux-gnueabihf-gcc: error: missing argument to =E2=80=98-marc=
h=3D=E2=80=99

Warnings summary:

    61   net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall thr=
ough [-Wimplicit-fallthrough=3D]
    57   arch/arm/include/asm/bitops.h:181:55: warning: this statement may =
fall through [-Wimplicit-fallthrough=3D]
    18   arch/arm/include/asm/bitops.h:183:34: warning: this statement may =
fall through [-Wimplicit-fallthrough=3D]
    3    kernel/rcu/tasks.h:707:13: warning: =E2=80=98show_rcu_tasks_rude_g=
p_kthread=E2=80=99 defined but not used [-Wunused-function]
    2    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [=
-Wcpp]
    2    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemente=
d [-Wcpp]
    1    net/mac80211/mlme.c:4349:1: warning: the frame size of 1040 bytes =
is larger than 1024 bytes [-Wframe-larger-than=3D]
    1    drivers/block/paride/bpck.c:32: warning: "PC" redefined
    1    WARNING: modpost: Symbol info of vmlinux is missing. Unresolved sy=
mbol check will be entirely skipped.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sec=
tion mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]
    WARNING: modpost: Symbol info of vmlinux is missing. Unresolved symbol =
check will be entirely skipped.

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
allnoconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

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
assabet_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

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
axm55xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    arch/arm/include/asm/bitops.h:183:34: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

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
bigsur_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning,=
 0 section mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning,=
 0 section mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning,=
 0 section mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
cu1000-neo_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
cu1830-neo_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
decstation_64_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings=
, 0 section mismatches

Warnings:
    kernel/rcu/tasks.h:707:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0=
 section mismatches

Warnings:
    kernel/rcu/tasks.h:707:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
decstation_r4k_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warning=
s, 0 section mismatches

Warnings:
    kernel/rcu/tasks.h:707:13: warning: =E2=80=98show_rcu_tasks_rude_gp_kth=
read=E2=80=99 defined but not used [-Wunused-function]
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mi=
smatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mi=
smatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
defconfig+arm64-chromebook (arm64, gcc-10) =E2=80=94 PASS, 0 errors, 1 warn=
ing, 0 section mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    arch/arm/include/asm/bitops.h:183:34: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

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
gpr_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

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
haps_hs_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    arch/arm/include/asm/bitops.h:183:34: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    arch/arm/include/asm/bitops.h:183:34: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

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
ip32_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    arch/arm/include/asm/bitops.h:183:34: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 s=
ection mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]
    net/mac80211/mlme.c:4349:1: warning: the frame size of 1040 bytes is la=
rger than 1024 bytes [-Wframe-larger-than=3D]

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warnin=
g, 0 section mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warnin=
g, 0 section mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning,=
 0 section mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0=
 section mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
milbeaut_m10v_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    arch/arm/include/asm/bitops.h:183:34: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    arch/arm/include/asm/bitops.h:183:34: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
nommu_k210_defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning=
, 0 section mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    arch/arm/include/asm/bitops.h:183:34: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

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
pcm027_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    arch/arm/include/asm/bitops.h:183:34: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

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
rbtx49xx_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    arch/arm/include/asm/bitops.h:183:34: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]
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
rv32_defconfig (riscv, gcc-10) =E2=80=94 PASS, 0 errors, 5 warnings, 0 sect=
ion mismatches

Warnings:
    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [-Wcpp]
    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemented [-W=
cpp]
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]
    <stdin>:830:2: warning: #warning syscall fstat64 not implemented [-Wcpp]
    <stdin>:1127:2: warning: #warning syscall fstatat64 not implemented [-W=
cpp]

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

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
sama5_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    arch/arm/include/asm/bitops.h:183:34: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    arch/arm/include/asm/bitops.h:183:34: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    arch/arm/include/asm/bitops.h:183:34: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

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
spitz_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    arch/arm/include/asm/bitops.h:183:34: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
tango4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    arch/arm/include/asm/bitops.h:183:34: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    arch/arm/include/asm/bitops.h:183:34: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

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
tinyconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    arch/arm/include/asm/bitops.h:183:34: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0=
 section mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    arch/arm/include/asm/bitops.h:183:34: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0=
 section mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
x86_64_defconfig+x86-chromebook (x86_64, gcc-10) =E2=80=94 PASS, 0 errors, =
1 warning, 0 section mismatches

Warnings:
    net/sunrpc/xprtsock.c:2311:3: warning: this statement may fall through =
[-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    arch/arm/include/asm/bitops.h:181:55: warning: this statement may fall =
through [-Wimplicit-fallthrough=3D]

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-10) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---
For more info write to <info@kernelci.org>
