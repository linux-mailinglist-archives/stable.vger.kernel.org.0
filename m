Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2CDA23D40F
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 00:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgHEW7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 18:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbgHEW7B (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 18:59:01 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EF2C061574
        for <stable@vger.kernel.org>; Wed,  5 Aug 2020 15:59:01 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id e4so5628521pjd.0
        for <stable@vger.kernel.org>; Wed, 05 Aug 2020 15:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jxIcaRbTh7GjuRoLRrCLeuFT7luD2CjIdvVNHvzEi7k=;
        b=e1fyEDSns3+ViZ0t+iv47dKfQ89+QU5uTo9GjzvGvLhQrzbCD/kE1nQDaK98Tq23D4
         ONf8GARYXQhEloJ445wo9Z3123jsGFgT3Kcgq5g3W2yTQe1HUa9k7ppkzI83lZLoN8QL
         vz6ZUuffzrlpLLUd2rFXQVY9rqA1kna051+jCWprhrU4xlsByRRyHdcOYCWDQXRCVpR6
         SIQiN489suSbqH3f+Sf8E+W0lkHCvUDVp6GK5DFGlR7IF1p8sqpcAlY3Q6R7XRIMMSum
         AYKigCteDElBVdGqW2pBOM8xYT7L4l9MsgAMF+sLC0wfqXAohHNcwWFv1GhbUszja7z9
         O8Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jxIcaRbTh7GjuRoLRrCLeuFT7luD2CjIdvVNHvzEi7k=;
        b=Pp6JkYF6/O0l+7cK7H/YtuRUAdd5OmFCby2ZfY0Ig48kOA5mbunhTAE/MsjIUIfjOg
         liwN3VhHZz9s1H3MfR1lsJ3b+jkycnQDINGo7KzDlJT034klUeLTUqyQ13vZNt3bVPFl
         kBIxJL+ay2lzdtI2T32bj8gKg8jDKQfZY0ytKyeggKAJ3KSHY0d6YYYLhDWsB4Wf63lw
         BJ1Xnwk/mhUbFTlmd5o9+Q5kHl7wtguFgFop3Q/0irfMNOux2lAWTunXlf81d9YJWriR
         75LlJwyS2zvTovRRh/BRtqKFcCU626J9vJDkyl5UluOGHUUf5kLdGZH2+jQ01zXZak3v
         8LhQ==
X-Gm-Message-State: AOAM530uHZjf+x79YdJ3rhFx4fs1Hwp+32p1V+8NZl+1F8G/yk2jzbSS
        3hfVwRis4UVmqgAmIBgDrvyn4BpYP8E=
X-Google-Smtp-Source: ABdhPJxq02TUwn6I+GxYHJVp2VBQbwMZyjDIHnFXtfOp8vi7wwMUxKFfUMqsJ0PYb8C423uglOU/3w==
X-Received: by 2002:a17:90b:4acd:: with SMTP id mh13mr5679790pjb.147.1596668336755;
        Wed, 05 Aug 2020 15:58:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 75sm4741593pfx.187.2020.08.05.15.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 15:58:55 -0700 (PDT)
Message-ID: <5f2b39af.1c69fb81.c53d9.d5cd@mx.google.com>
Date:   Wed, 05 Aug 2020 15:58:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v4.9.232-51-g1f47445197d2
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y build: 197 builds: 112 failed, 85 passed,
 111 errors (v4.9.232-51-g1f47445197d2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y build: 197 builds: 112 failed, 85 passed, 111 errors =
(v4.9.232-51-g1f47445197d2)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.232-51-g1f47445197d2/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.232-51-g1f47445197d2
Git Commit: 1f47445197d2c8eecafa2b996f635aa89851c123
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
    pxa_defconfig: (gcc-8) FAIL
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
    32r2el_defconfig: (gcc-8) FAIL
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
    loongson1b_defconfig: (gcc-8) FAIL
    loongson1c_defconfig: (gcc-8) FAIL
    loongson3_defconfig: (gcc-8) FAIL
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
    pic32mzda_defconfig: (gcc-8) FAIL
    pistachio_defconfig: (gcc-8) FAIL
    qi_lb60_defconfig: (gcc-8) FAIL
    rm200_defconfig: (gcc-8) FAIL
    tb0219_defconfig: (gcc-8) FAIL
    tb0287_defconfig: (gcc-8) FAIL
    workpad_defconfig: (gcc-8) FAIL

x86_64:
    x86_64_defconfig: (gcc-8) FAIL

Errors Detected:

arc:
    axs103_defconfig (gcc-8): 1 error
    axs103_smp_defconfig (gcc-8): 1 error
    vdk_hs38_defconfig (gcc-8): 1 error
    vdk_hs38_smp_defconfig (gcc-8): 1 error

arm64:
    defconfig (gcc-8): 1 error

arm:
    at91_dt_defconfig (gcc-8): 1 error
    axm55xx_defconfig (gcc-8): 1 error
    badge4_defconfig (gcc-8): 1 error
    bcm2835_defconfig (gcc-8): 1 error
    cerfcube_defconfig (gcc-8): 1 error
    cm_x2xx_defconfig (gcc-8): 1 error
    cm_x300_defconfig (gcc-8): 1 error
    colibri_pxa300_defconfig (gcc-8): 1 error
    davinci_all_defconfig (gcc-8): 1 error
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
    mini2440_defconfig (gcc-8): 1 error
    mmp2_defconfig (gcc-8): 1 error
    moxart_defconfig (gcc-8): 1 error
    multi_v5_defconfig (gcc-8): 1 error
    multi_v7_defconfig (gcc-8): 1 error
    mv78xx0_defconfig (gcc-8): 1 error
    mvebu_v5_defconfig (gcc-8): 1 error
    mvebu_v7_defconfig (gcc-8): 1 error
    mxs_defconfig (gcc-8): 1 error
    nhk8815_defconfig (gcc-8): 1 error
    omap1_defconfig (gcc-8): 1 error
    omap2plus_defconfig (gcc-8): 1 error
    orion5x_defconfig (gcc-8): 1 error
    palmz72_defconfig (gcc-8): 1 error
    pcm027_defconfig (gcc-8): 1 error
    pleb_defconfig (gcc-8): 1 error
    pxa_defconfig (gcc-8): 1 error
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
    ip22_defconfig (gcc-8): 1 error
    ip27_defconfig (gcc-8): 1 error
    ip28_defconfig (gcc-8): 1 error
    ip32_defconfig (gcc-8): 1 error
    jazz_defconfig (gcc-8): 1 error
    lasat_defconfig (gcc-8): 1 error
    lemote2f_defconfig (gcc-8): 1 error
    loongson1b_defconfig (gcc-8): 1 error
    loongson1c_defconfig (gcc-8): 1 error
    loongson3_defconfig (gcc-8): 1 error
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
    pic32mzda_defconfig (gcc-8): 1 error
    pistachio_defconfig (gcc-8): 1 error
    qi_lb60_defconfig (gcc-8): 1 error
    rm200_defconfig (gcc-8): 1 error
    tb0219_defconfig (gcc-8): 1 error
    tb0287_defconfig (gcc-8): 1 error
    workpad_defconfig (gcc-8): 1 error

x86_64:
    x86_64_defconfig (gcc-8): 1 error

Errors summary:

    111  /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=
=80=98offset=E2=80=99


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-8) =E2=80=94 FAIL, 0 errors, 0 warnings, 0 sect=
ion mismatches

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
allnoconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

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
aspeed_g4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

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
bigsur_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, =
0 section mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, =
0 section mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

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
davinci_all_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section mis=
matches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

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
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section m=
ismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

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
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

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
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

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
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings=
, 0 section mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings=
, 0 section mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, =
0 section mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, =
0 section mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section m=
ismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

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
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

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
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

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
pxa_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section m=
ismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

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
realview_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section m=
ismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, =
0 section mismatches

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
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 =
section mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

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
zebu_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
zebu_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section mi=
smatches

Errors:
    /scratch/linux/fs/ext4/inode.c:3610:9: error: redefinition of =E2=80=98=
offset=E2=80=99

---
For more info write to <info@kernelci.org>
