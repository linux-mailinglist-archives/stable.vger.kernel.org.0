Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE5F823D422
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 01:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbgHEXUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 19:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbgHEXUw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 19:20:52 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B196AC061574
        for <stable@vger.kernel.org>; Wed,  5 Aug 2020 16:20:51 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id d19so2110436pgl.10
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 16:20:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ETle86hv2kltKfQr3ZY1GjENSTCcH6TVyWVg0wYEc6Q=;
        b=YF3QWT0JvuxaGFe1WFjPjvhGt/CRaKvO/77hkR5gKSLUTvp5sqZWjF5fEEKTIm0KEJ
         ddyL8yucdn25PAtpA1sHJHi3YkShopdbAF5O361uQwMp1W9xU3xoEAE93CP8ZQ1/0jB2
         PTvA591aGw+fw9uOm/KVNfHSwFl0vBrct23tMIgihDnvXOcbVHfuHYRP7k1O+PnaO7pa
         4tygR6BjqjJ8EcTCu+aLwullbgj0C/7+Xj6tAbiday1uzI9x51yrPOTqWxg90e+tiyLQ
         MSjKW+vUBe4bFYWYgz2qtfnr2+DpkmFQ6iq59S2zRTHDE71prCQgYgiO7RYUR773kRqt
         pQjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ETle86hv2kltKfQr3ZY1GjENSTCcH6TVyWVg0wYEc6Q=;
        b=SKUScCVcG54eLHhVG78MJ6qNaIZsWFzDLCYFQTgAGcEMmGMh+2QgkBXCYFhqwb5fTH
         HTbrzr5B7ePEsrUjE+120PmmSuspHj0IEw9QreG8jeti2nZFB2A7fLt8bS9Bacgg1x2Y
         N9txxiaEU1C7v80h0G2R3sU//BRrDwTPIITAw5jxAJAJX5hhgY5bSy3YKNtcW30dA8e1
         p9k889U6hSisxKvnJileD+B+7g8U18DYKtsrNxfC2fcGv8e5xUsE90Sa7+um1EqHOo2X
         tQivTSChgfOhwoktRKtb/od6FyS2/EBcOoK/kQEEPexk0l7t88qQAYi6fYWT8dos0nWo
         dIRg==
X-Gm-Message-State: AOAM533nMmus7wh/U/DyclaZgq5nI3mgTNR7wf/ece0Tv5CDOOBBh+Qr
        SmoS16R6sOtIRBFOzGV7E/9CQgtn7Ls=
X-Google-Smtp-Source: ABdhPJyCbOcrh5k5ZpbZr0RA6HCBDOiJBy6pJIC6v3XYQYEM+84RPttBiMd7/Kr98Pq0hG/V6cVTvQ==
X-Received: by 2002:aa7:9ac2:: with SMTP id x2mr5484629pfp.57.1596669649020;
        Wed, 05 Aug 2020 16:20:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m29sm4238599pgc.55.2020.08.05.16.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 16:20:48 -0700 (PDT)
Message-ID: <5f2b3ed0.1c69fb81.55f87.aa07@mx.google.com>
Date:   Wed, 05 Aug 2020 16:20:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v4.4.232-33-g0b3898baf614
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y build: 190 builds: 111 failed, 79 passed,
 112 errors, 12 warnings (v4.4.232-33-g0b3898baf614)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y build: 190 builds: 111 failed, 79 passed, 112 errors,=
 12 warnings (v4.4.232-33-g0b3898baf614)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.232-33-g0b3898baf614/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.232-33-g0b3898baf614
Git Commit: 0b3898baf61459e1f963dcf893b4683174668975
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failures Detected:

arc:
    axs103_defconfig: (gcc-8) FAIL
    axs103_smp_defconfig: (gcc-8) FAIL
    vdk_hs38_defconfig: (gcc-8) FAIL
    vdk_hs38_smp_defconfig: (gcc-8) FAIL

arm64:
    defconfig: (gcc-8) FAIL

arm:
    at91_dt_defconfig: (gcc-8) FAIL
    axm55xx_defconfig: (gcc-8) FAIL
    badge4_defconfig: (gcc-8) FAIL
    bcm2835_defconfig: (gcc-8) FAIL
    bcm_defconfig: (gcc-8) FAIL
    cerfcube_defconfig: (gcc-8) FAIL
    cm_x2xx_defconfig: (gcc-8) FAIL
    cm_x300_defconfig: (gcc-8) FAIL
    colibri_pxa300_defconfig: (gcc-8) FAIL
    davinci_all_defconfig: (gcc-8) FAIL
    dove_defconfig: (gcc-8) FAIL
    em_x270_defconfig: (gcc-8) FAIL
    ep93xx_defconfig: (gcc-8) FAIL
    eseries_pxa_defconfig: (gcc-8) FAIL
    exynos_defconfig: (gcc-8) FAIL
    ezx_defconfig: (gcc-8) FAIL
    hisi_defconfig: (gcc-8) FAIL
    imote2_defconfig: (gcc-8) FAIL
    imx_v4_v5_defconfig: (gcc-8) FAIL
    imx_v6_v7_defconfig: (gcc-8) FAIL
    iop13xx_defconfig: (gcc-8) FAIL
    iop32x_defconfig: (gcc-8) FAIL
    iop33x_defconfig: (gcc-8) FAIL
    ixp4xx_defconfig: (gcc-8) FAIL
    keystone_defconfig: (gcc-8) FAIL
    lart_defconfig: (gcc-8) FAIL
    mini2440_defconfig: (gcc-8) FAIL
    mmp2_defconfig: (gcc-8) FAIL
    moxart_defconfig: (gcc-8) FAIL
    multi_v5_defconfig: (gcc-8) FAIL
    multi_v7_defconfig: (gcc-8) FAIL
    mv78xx0_defconfig: (gcc-8) FAIL
    mvebu_v5_defconfig: (gcc-8) FAIL
    mvebu_v7_defconfig: (gcc-8) FAIL
    mxs_defconfig: (gcc-8) FAIL
    nhk8815_defconfig: (gcc-8) FAIL
    omap1_defconfig: (gcc-8) FAIL
    omap2plus_defconfig: (gcc-8) FAIL
    orion5x_defconfig: (gcc-8) FAIL
    palmz72_defconfig: (gcc-8) FAIL
    pcm027_defconfig: (gcc-8) FAIL
    pleb_defconfig: (gcc-8) FAIL
    qcom_defconfig: (gcc-8) FAIL
    raumfeld_defconfig: (gcc-8) FAIL
    rpc_defconfig: (gcc-8) FAIL
    s3c2410_defconfig: (gcc-8) FAIL
    s3c6400_defconfig: (gcc-8) FAIL
    sama5_defconfig: (gcc-8) FAIL
    simpad_defconfig: (gcc-8) FAIL
    socfpga_defconfig: (gcc-8) FAIL
    spear13xx_defconfig: (gcc-8) FAIL
    spear3xx_defconfig: (gcc-8) FAIL
    spear6xx_defconfig: (gcc-8) FAIL
    spitz_defconfig: (gcc-8) FAIL
    sunxi_defconfig: (gcc-8) FAIL
    tegra_defconfig: (gcc-8) FAIL
    trizeps4_defconfig: (gcc-8) FAIL
    u8500_defconfig: (gcc-8) FAIL
    vexpress_defconfig: (gcc-8) FAIL
    viper_defconfig: (gcc-8) FAIL
    vt8500_v6_v7_defconfig: (gcc-8) FAIL
    zeus_defconfig: (gcc-8) FAIL
    zx_defconfig: (gcc-8) FAIL

i386:
    i386_defconfig: (gcc-8) FAIL

mips:
    bigsur_defconfig: (gcc-8) FAIL
    bmips_be_defconfig: (gcc-8) FAIL
    bmips_stb_defconfig: (gcc-8) FAIL
    capcella_defconfig: (gcc-8) FAIL
    cavium_octeon_defconfig: (gcc-8) FAIL
    cobalt_defconfig: (gcc-8) FAIL
    db1xxx_defconfig: (gcc-8) FAIL
    decstation_defconfig: (gcc-8) FAIL
    e55_defconfig: (gcc-8) FAIL
    fuloong2e_defconfig: (gcc-8) FAIL
    ip22_defconfig: (gcc-8) FAIL
    ip27_defconfig: (gcc-8) FAIL
    ip28_defconfig: (gcc-8) FAIL
    ip32_defconfig: (gcc-8) FAIL
    jazz_defconfig: (gcc-8) FAIL
    lasat_defconfig: (gcc-8) FAIL
    lemote2f_defconfig: (gcc-8) FAIL
    loongson3_defconfig: (gcc-8) FAIL
    ls1b_defconfig: (gcc-8) FAIL
    malta_defconfig: (gcc-8) FAIL
    malta_kvm_defconfig: (gcc-8) FAIL
    malta_kvm_guest_defconfig: (gcc-8) FAIL
    malta_qemu_32r6_defconfig: (gcc-8) FAIL
    maltaaprp_defconfig: (gcc-8) FAIL
    maltasmvp_defconfig: (gcc-8) FAIL
    maltasmvp_eva_defconfig: (gcc-8) FAIL
    maltaup_defconfig: (gcc-8) FAIL
    maltaup_xpa_defconfig: (gcc-8) FAIL
    markeins_defconfig: (gcc-8) FAIL
    mips_paravirt_defconfig: (gcc-8) FAIL
    mtx1_defconfig: (gcc-8) FAIL
    nlm_xlp_defconfig: (gcc-8) FAIL
    nlm_xlr_defconfig: (gcc-8) FAIL
    pistachio_defconfig: (gcc-8) FAIL
    qi_lb60_defconfig: (gcc-8) FAIL
    rm200_defconfig: (gcc-8) FAIL
    sead3_defconfig: (gcc-8) FAIL
    sead3micro_defconfig: (gcc-8) FAIL
    tb0219_defconfig: (gcc-8) FAIL
    tb0287_defconfig: (gcc-8) FAIL
    workpad_defconfig: (gcc-8) FAIL

x86_64:
    x86_64_defconfig: (gcc-8) FAIL

Errors and Warnings Detected:

arc:
    allnoconfig (gcc-8): 3 warnings
    axs103_defconfig (gcc-8): 1 error
    axs103_smp_defconfig (gcc-8): 1 error
    tinyconfig (gcc-8): 4 warnings
    vdk_hs38_defconfig (gcc-8): 1 error
    vdk_hs38_smp_defconfig (gcc-8): 1 error

arm64:
    defconfig (gcc-8): 1 error

arm:
    at91_dt_defconfig (gcc-8): 1 error
    axm55xx_defconfig (gcc-8): 1 error
    badge4_defconfig (gcc-8): 1 error
    bcm2835_defconfig (gcc-8): 1 error
    bcm_defconfig (gcc-8): 1 error
    cerfcube_defconfig (gcc-8): 1 error
    clps711x_defconfig (gcc-8): 1 warning
    cm_x2xx_defconfig (gcc-8): 1 error
    cm_x300_defconfig (gcc-8): 1 error
    colibri_pxa300_defconfig (gcc-8): 1 error
    davinci_all_defconfig (gcc-8): 1 error, 1 warning
    dove_defconfig (gcc-8): 1 error
    em_x270_defconfig (gcc-8): 1 error
    ep93xx_defconfig (gcc-8): 1 error
    eseries_pxa_defconfig (gcc-8): 1 error
    exynos_defconfig (gcc-8): 1 error
    ezx_defconfig (gcc-8): 1 error
    hisi_defconfig (gcc-8): 1 error
    imote2_defconfig (gcc-8): 1 error
    imx_v4_v5_defconfig (gcc-8): 1 error
    imx_v6_v7_defconfig (gcc-8): 1 error
    iop13xx_defconfig (gcc-8): 1 error
    iop32x_defconfig (gcc-8): 1 error
    iop33x_defconfig (gcc-8): 1 error
    ixp4xx_defconfig (gcc-8): 1 error
    keystone_defconfig (gcc-8): 1 error
    lart_defconfig (gcc-8): 1 error
    lpc32xx_defconfig (gcc-8): 1 warning
    mini2440_defconfig (gcc-8): 1 error
    mmp2_defconfig (gcc-8): 1 error
    moxart_defconfig (gcc-8): 1 error
    multi_v5_defconfig (gcc-8): 1 error
    multi_v7_defconfig (gcc-8): 1 error
    mv78xx0_defconfig (gcc-8): 1 error
    mvebu_v5_defconfig (gcc-8): 1 error
    mvebu_v7_defconfig (gcc-8): 1 error
    mxs_defconfig (gcc-8): 1 error, 1 warning
    nhk8815_defconfig (gcc-8): 1 error
    omap1_defconfig (gcc-8): 1 error
    omap2plus_defconfig (gcc-8): 1 error
    orion5x_defconfig (gcc-8): 1 error
    palmz72_defconfig (gcc-8): 1 error
    pcm027_defconfig (gcc-8): 1 error
    pleb_defconfig (gcc-8): 1 error
    qcom_defconfig (gcc-8): 1 error
    raumfeld_defconfig (gcc-8): 1 error
    rpc_defconfig (gcc-8): 1 error
    s3c2410_defconfig (gcc-8): 1 error
    s3c6400_defconfig (gcc-8): 1 error
    sama5_defconfig (gcc-8): 1 error
    simpad_defconfig (gcc-8): 1 error
    socfpga_defconfig (gcc-8): 1 error
    spear13xx_defconfig (gcc-8): 1 error
    spear3xx_defconfig (gcc-8): 1 error
    spear6xx_defconfig (gcc-8): 1 error
    spitz_defconfig (gcc-8): 1 error
    sunxi_defconfig (gcc-8): 1 error
    tegra_defconfig (gcc-8): 1 error
    trizeps4_defconfig (gcc-8): 1 error
    u8500_defconfig (gcc-8): 1 error
    vexpress_defconfig (gcc-8): 1 error
    viper_defconfig (gcc-8): 1 error
    vt8500_v6_v7_defconfig (gcc-8): 1 error
    zeus_defconfig (gcc-8): 1 error
    zx_defconfig (gcc-8): 1 error

i386:
    i386_defconfig (gcc-8): 1 error

mips:
    bigsur_defconfig (gcc-8): 1 error
    bmips_be_defconfig (gcc-8): 1 error
    bmips_stb_defconfig (gcc-8): 1 error
    capcella_defconfig (gcc-8): 1 error
    cavium_octeon_defconfig (gcc-8): 1 error
    cobalt_defconfig (gcc-8): 1 error
    db1xxx_defconfig (gcc-8): 1 error
    decstation_defconfig (gcc-8): 1 error
    e55_defconfig (gcc-8): 1 error
    fuloong2e_defconfig (gcc-8): 1 error
    ip22_defconfig (gcc-8): 1 error, 1 warning
    ip27_defconfig (gcc-8): 1 error
    ip28_defconfig (gcc-8): 1 error
    ip32_defconfig (gcc-8): 1 error
    jazz_defconfig (gcc-8): 1 error
    lasat_defconfig (gcc-8): 1 error
    lemote2f_defconfig (gcc-8): 1 error
    loongson3_defconfig (gcc-8): 1 error
    ls1b_defconfig (gcc-8): 1 error
    malta_defconfig (gcc-8): 1 error
    malta_kvm_defconfig (gcc-8): 1 error
    malta_kvm_guest_defconfig (gcc-8): 1 error
    malta_qemu_32r6_defconfig (gcc-8): 1 error
    maltaaprp_defconfig (gcc-8): 1 error
    maltasmvp_defconfig (gcc-8): 1 error
    maltasmvp_eva_defconfig (gcc-8): 1 error
    maltaup_defconfig (gcc-8): 1 error
    maltaup_xpa_defconfig (gcc-8): 1 error
    markeins_defconfig (gcc-8): 1 error
    mips_paravirt_defconfig (gcc-8): 1 error
    mtx1_defconfig (gcc-8): 1 error
    nlm_xlp_defconfig (gcc-8): 1 error
    nlm_xlr_defconfig (gcc-8): 1 error
    pistachio_defconfig (gcc-8): 1 error
    qi_lb60_defconfig (gcc-8): 1 error
    rm200_defconfig (gcc-8): 1 error
    sead3_defconfig (gcc-8): 1 error
    sead3micro_defconfig (gcc-8): 2 errors
    tb0219_defconfig (gcc-8): 1 error
    tb0287_defconfig (gcc-8): 1 error
    workpad_defconfig (gcc-8): 1 error

x86_64:
    x86_64_defconfig (gcc-8): 1 error

Errors summary:

    110  /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=
=80=99 redeclared as different kind of symbol
    1    /scratch/linux/arch/mips/kernel/genex.S:271: Error: branch to a sy=
mbol in another ISA mode
    1    /scratch/linux/arch/mips/kernel/genex.S:152: Error: branch to a sy=
mbol in another ISA mode

Warnings summary:

    7    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct d=
ependencies (FUTEX)
    1    /scratch/linux/drivers/net/ethernet/seeq/sgiseeq.c:804:26: warning=
: passing argument 5 of =E2=80=98dma_free_attrs=E2=80=99 makes pointer from=
 integer without a cast [-Wint-conversion]
    1    /scratch/linux/arch/arm/mach-mxs/mach-mxs.c:285:26: warning: dupli=
cate =E2=80=98const=E2=80=99 declaration specifier [-Wduplicate-decl-specif=
ier]
    1    /scratch/linux/arch/arm/mach-lpc32xx/phy3250.c:215:36: warning: du=
plicate =E2=80=98const=E2=80=99 declaration specifier [-Wduplicate-decl-spe=
cifier]
    1    /scratch/linux/arch/arm/mach-davinci/da8xx-dt.c:23:34: warning: du=
plicate =E2=80=98const=E2=80=99 declaration specifier [-Wduplicate-decl-spe=
cifier]
    1    /scratch/linux/arch/arm/mach-clps711x/board-autcpu12.c:163:26: war=
ning: duplicate =E2=80=98const=E2=80=99 declaration specifier [-Wduplicate-=
decl-specifier]

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
acs5k_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 3 warnings, 0 section mi=
smatches

Warnings:
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
bcm_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section m=
ismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, =
0 section mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    /scratch/linux/arch/arm/mach-clps711x/board-autcpu12.c:163:26: warning:=
 duplicate =E2=80=98const=E2=80=99 declaration specifier [-Wduplicate-decl-=
specifier]

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, =
0 section mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 se=
ction mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

Warnings:
    /scratch/linux/arch/arm/mach-davinci/da8xx-dt.c:23:34: warning: duplica=
te =E2=80=98const=E2=80=99 declaration specifier [-Wduplicate-decl-specifie=
r]

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section mis=
matches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section m=
ismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section =
mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

Warnings:
    /scratch/linux/drivers/net/ethernet/seeq/sgiseeq.c:804:26: warning: pas=
sing argument 5 of =E2=80=98dma_free_attrs=E2=80=99 makes pointer from inte=
ger without a cast [-Wint-conversion]

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    /scratch/linux/arch/arm/mach-lpc32xx/phy3250.c:215:36: warning: duplica=
te =E2=80=98const=E2=80=99 declaration specifier [-Wduplicate-decl-specifie=
r]

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ls1b_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings=
, 0 section mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings=
, 0 section mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, =
0 section mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, =
0 section mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 1 warning, 0 section mi=
smatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

Warnings:
    /scratch/linux/arch/arm/mach-mxs/mach-mxs.c:285:26: warning: duplicate =
=E2=80=98const=E2=80=99 declaration specifier [-Wduplicate-decl-specifier]

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
netx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
nuc910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
nuc960_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
realview-smp_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section m=
ismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

---------------------------------------------------------------------------=
-----
sead3_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
sead3micro_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 =
section mismatches

Errors:
    /scratch/linux/arch/mips/kernel/genex.S:152: Error: branch to a symbol =
in another ISA mode
    /scratch/linux/arch/mips/kernel/genex.S:271: Error: branch to a symbol =
in another ISA mode

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 4 warnings, 0 section mis=
matches

Warnings:
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)
    warning: (ARC) selects HAVE_FUTEX_CMPXCHG which has unmet direct depend=
encies (FUTEX)

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
xilfpga_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section mi=
smatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3355:9: error: =E2=80=98offset=E2=80=99 =
redeclared as different kind of symbol

---
For more info write to <info@kernelci.org>
