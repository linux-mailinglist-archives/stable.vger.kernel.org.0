Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12FD26DC7A
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 15:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbgIQNIf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 09:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727044AbgIQNId (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Sep 2020 09:08:33 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCA1C06174A
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 06:08:13 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id a9so1265639pjg.1
        for <stable@vger.kernel.org>; Thu, 17 Sep 2020 06:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2+aLD85OccJ+1k5fzgYwG4ja3H3xmV0YpGqQcgjUg6U=;
        b=Wzc8uSMsRE7BU+nh5TyqKO/bi7tUO3NcJy95+nBhMyo+ordquhzOeFSoAIg+VnNKYq
         1MJnMAcWexqa2/UQhWTeDChjUmATvLwSLewkCs3DIkOJmrZVmYSpQSkH6i0boL4a2gBT
         OpaBxwBUwNUBHR6Qh78txoS3wXo2UjlbORYk98HnvU+ABENt/MlP8iFj2WurVD6PNK0Y
         GBEWzPVTDrpxjVqYQtjm0N9ZNY+OXtoMQVGI5LNiXC0KplNWgYWOGpxXk5s0/nyjq3sH
         uZyfmvrhfw8QfZkOfNoo0DrzmFAc5OeEWPxFj4xN9miEPkVX6Sc1z5F9drI0OCBnCH9o
         sZDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2+aLD85OccJ+1k5fzgYwG4ja3H3xmV0YpGqQcgjUg6U=;
        b=Mer//EzBFH6Z3Z6B6zWEX6Jhu9UHk4i+cIoQ18FfcJMJF5crDU0Sq5M/LLy8y3NR3S
         iKbkIgT9rKw/ql8MdlPLwxsEOca2x4EJeWbXEK6iAFSWAdGrqILn3ojkN6JOYCqaW9y4
         SXmD+e8IQGVWgXJsBWrItGyeqioM+hZu6yFszV21hlR44LdIyvkP7W1pu+Ez3tpAHnKZ
         tYdxnBZpq6AnC/T4lcDVLF+oLCnEdQP2uVc3hIPEBW4wzwp7CEfVsuib8egKWhzA96zb
         +vpfVOYIORPIlacMbaUSc1fjFx5NmRlOvUe+IHqT2PaxytYkGELYsw0Ah/ZyOhYX3Ydp
         5h7w==
X-Gm-Message-State: AOAM5315cWX+KmNw3KWX4Xj+ZllTzHx36ct17ZD4Kk9AUk/mkjR5QA+l
        vLVKf6YZ8EiXjDK5J4+vAzYTc9pZ+/CRxQ==
X-Google-Smtp-Source: ABdhPJyNGdkcUbJc9k/iEuSHWCfz9aCQM1mpuo9MnGktLVPDVuXxcHhgUyiBB01TtaSClbf+BlhhLA==
X-Received: by 2002:a17:902:8c91:b029:d1:9be4:7fe6 with SMTP id t17-20020a1709028c91b02900d19be47fe6mr29285155plo.33.1600348091863;
        Thu, 17 Sep 2020 06:08:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r2sm17782031pga.94.2020.09.17.06.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 06:08:11 -0700 (PDT)
Message-ID: <5f635fbb.1c69fb81.e6c81.b190@mx.google.com>
Date:   Thu, 17 Sep 2020 06:08:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.146
Subject: stable/linux-4.19.y build: 206 builds: 0 failed, 206 passed,
 94 warnings (v4.19.146)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y build: 206 builds: 0 failed, 206 passed, 94 warnings (v=
4.19.146)

Full Build Summary: https://kernelci.org/build/stable/branch/linux-4.19.y/k=
ernel/v4.19.146/

Tree: stable
Branch: linux-4.19.y
Git Describe: v4.19.146
Git Commit: 015e94d0e37b6860e4354ce3cac56bd7c39c8992
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Built: 7 unique architectures

Warnings Detected:

arc:
    allnoconfig (gcc-8): 1 warning
    axs103_defconfig (gcc-8): 1 warning
    axs103_smp_defconfig (gcc-8): 1 warning
    haps_hs_defconfig (gcc-8): 1 warning
    haps_hs_smp_defconfig (gcc-8): 2 warnings
    hsdk_defconfig (gcc-8): 1 warning
    nsim_hs_defconfig (gcc-8): 2 warnings
    nsim_hs_smp_defconfig (gcc-8): 2 warnings
    nsimosci_hs_defconfig (gcc-8): 2 warnings
    nsimosci_hs_smp_defconfig (gcc-8): 2 warnings
    tinyconfig (gcc-8): 1 warning
    vdk_hs38_defconfig (gcc-8): 1 warning
    vdk_hs38_smp_defconfig (gcc-8): 1 warning

arm64:
    allnoconfig (gcc-8): 1 warning
    tinyconfig (gcc-8): 1 warning

arm:
    allnoconfig (gcc-8): 1 warning
    am200epdkit_defconfig (gcc-8): 1 warning
    clps711x_defconfig (gcc-8): 1 warning
    cm_x2xx_defconfig (gcc-8): 1 warning
    colibri_pxa300_defconfig (gcc-8): 1 warning
    corgi_defconfig (gcc-8): 1 warning
    efm32_defconfig (gcc-8): 1 warning
    eseries_pxa_defconfig (gcc-8): 1 warning
    h5000_defconfig (gcc-8): 1 warning
    imx_v4_v5_defconfig (gcc-8): 1 warning
    integrator_defconfig (gcc-8): 1 warning
    keystone_defconfig (gcc-8): 1 warning
    lpc32xx_defconfig (gcc-8): 1 warning
    lpd270_defconfig (gcc-8): 1 warning
    lubbock_defconfig (gcc-8): 1 warning
    magician_defconfig (gcc-8): 1 warning
    mainstone_defconfig (gcc-8): 1 warning
    multi_v4t_defconfig (gcc-8): 1 warning
    multi_v5_defconfig (gcc-8): 1 warning
    multi_v7_defconfig (gcc-8): 1 warning
    mv78xx0_defconfig (gcc-8): 1 warning
    mvebu_v5_defconfig (gcc-8): 1 warning
    omap2plus_defconfig (gcc-8): 1 warning
    orion5x_defconfig (gcc-8): 1 warning
    palmz72_defconfig (gcc-8): 1 warning
    pcm027_defconfig (gcc-8): 1 warning
    prima2_defconfig (gcc-8): 1 warning
    pxa168_defconfig (gcc-8): 1 warning
    pxa255-idp_defconfig (gcc-8): 1 warning
    pxa3xx_defconfig (gcc-8): 1 warning
    pxa910_defconfig (gcc-8): 1 warning
    pxa_defconfig (gcc-8): 1 warning
    qcom_defconfig (gcc-8): 1 warning
    raumfeld_defconfig (gcc-8): 1 warning
    s3c2410_defconfig (gcc-8): 1 warning
    s3c6400_defconfig (gcc-8): 1 warning
    s5pv210_defconfig (gcc-8): 1 warning
    spitz_defconfig (gcc-8): 1 warning
    stm32_defconfig (gcc-8): 1 warning
    sunxi_defconfig (gcc-8): 1 warning
    tango4_defconfig (gcc-8): 1 warning
    tct_hammer_defconfig (gcc-8): 1 warning
    tinyconfig (gcc-8): 1 warning
    vf610m4_defconfig (gcc-8): 1 warning
    viper_defconfig (gcc-8): 1 warning
    vt8500_v6_v7_defconfig (gcc-8): 1 warning
    xcep_defconfig (gcc-8): 2 warnings
    zeus_defconfig (gcc-8): 1 warning

i386:
    i386_defconfig (gcc-8): 1 warning

mips:
    allnoconfig (gcc-8): 1 warning
    db1xxx_defconfig (gcc-8): 1 warning
    gcw0_defconfig (gcc-8): 1 warning
    jmr3927_defconfig (gcc-8): 1 warning
    lemote2f_defconfig (gcc-8): 1 warning
    loongson3_defconfig (gcc-8): 2 warnings
    malta_defconfig (gcc-8): 1 warning
    malta_kvm_guest_defconfig (gcc-8): 1 warning
    malta_qemu_32r6_defconfig (gcc-8): 2 warnings
    maltaaprp_defconfig (gcc-8): 1 warning
    maltasmvp_defconfig (gcc-8): 1 warning
    maltasmvp_eva_defconfig (gcc-8): 1 warning
    maltaup_defconfig (gcc-8): 1 warning
    maltaup_xpa_defconfig (gcc-8): 1 warning
    nlm_xlp_defconfig (gcc-8): 1 warning
    pic32mzda_defconfig (gcc-8): 1 warning
    tinyconfig (gcc-8): 1 warning

riscv:
    allnoconfig (gcc-8): 1 warning
    defconfig (gcc-8): 1 warning
    tinyconfig (gcc-8): 1 warning

x86_64:
    tinyconfig (gcc-8): 1 warning
    x86_64_defconfig (gcc-8): 1 warning


Warnings summary:

    69   /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_l=
ist=E2=80=99 defined but not used [-Wunused-variable]
    17   /scratch/linux/kernel/kprobes.c:1070:33: warning: statement with n=
o effect [-Wunused-value]
    3    /scratch/linux/net/core/rtnetlink.c:3191:1: warning: the frame siz=
e of 1312 bytes is larger than 1024 bytes [-Wframe-larger-than=3D]
    2    arch/arm/boot/dts/sun8i-h3-beelink-x2.dtb: Warning (clocks_propert=
y): /wifi_pwrseq: Missing property '#clock-cells' in node /soc/rtc@1f00000 =
or bad phandle (referred from clocks[0])
    1    {standard input}:131: Warning: macro instruction expanded into mul=
tiple instructions
    1    arch/mips/configs/loongson3_defconfig:55:warning: symbol value 'm'=
 invalid for HOTPLUG_PCI_SHPC
    1    .config:1010:warning: override: UNWINDER_GUESS changes choice state

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
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
allnoconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mi=
smatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
allnoconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

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
at91_dt_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

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
axm55xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

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
bigsur_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
defconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 s=
ection mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
gcw0_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

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
h5000_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 =
section mismatches

Warnings:
    /scratch/linux/kernel/kprobes.c:1070:33: warning: statement with no eff=
ect [-Wunused-value]
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    /scratch/linux/kernel/kprobes.c:1070:33: warning: statement with no eff=
ect [-Wunused-value]

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    /scratch/linux/kernel/kprobes.c:1070:33: warning: statement with no eff=
ect [-Wunused-value]

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    /scratch/linux/kernel/kprobes.c:1070:33: warning: statement with no eff=
ect [-Wunused-value]

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    /scratch/linux/net/core/rtnetlink.c:3191:1: warning: the frame size of =
1312 bytes is larger than 1024 bytes [-Wframe-larger-than=3D]

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 s=
ection mismatches

Warnings:
    arch/mips/configs/loongson3_defconfig:55:warning: symbol value 'm' inva=
lid for HOTPLUG_PCI_SHPC
    /scratch/linux/net/core/rtnetlink.c:3191:1: warning: the frame size of =
1312 bytes is larger than 1024 bytes [-Wframe-larger-than=3D]

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning=
, 0 section mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 2 warning=
s, 0 section mismatches

Warnings:
    {standard input}:131: Warning: macro instruction expanded into multiple=
 instructions
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, =
0 section mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

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
mtx1_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    /scratch/linux/kernel/kprobes.c:1070:33: warning: statement with no eff=
ect [-Wunused-value]

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    arch/arm/boot/dts/sun8i-h3-beelink-x2.dtb: Warning (clocks_property): /=
wifi_pwrseq: Missing property '#clock-cells' in node /soc/rtc@1f00000 or ba=
d phandle (referred from clocks[0])

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    /scratch/linux/kernel/kprobes.c:1070:33: warning: statement with no eff=
ect [-Wunused-value]

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    /scratch/linux/kernel/kprobes.c:1070:33: warning: statement with no eff=
ect [-Wunused-value]

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

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
nhk8815_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    /scratch/linux/net/core/rtnetlink.c:3191:1: warning: the frame size of =
1312 bytes is larger than 1024 bytes [-Wframe-larger-than=3D]

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 sect=
ion mismatches

Warnings:
    /scratch/linux/kernel/kprobes.c:1070:33: warning: statement with no eff=
ect [-Wunused-value]
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 =
section mismatches

Warnings:
    /scratch/linux/kernel/kprobes.c:1070:33: warning: statement with no eff=
ect [-Wunused-value]
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 =
section mismatches

Warnings:
    /scratch/linux/kernel/kprobes.c:1070:33: warning: statement with no eff=
ect [-Wunused-value]
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings=
, 0 section mismatches

Warnings:
    /scratch/linux/kernel/kprobes.c:1070:33: warning: statement with no eff=
ect [-Wunused-value]
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

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
omap1_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    /scratch/linux/kernel/kprobes.c:1070:33: warning: statement with no eff=
ect [-Wunused-value]

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    /scratch/linux/kernel/kprobes.c:1070:33: warning: statement with no eff=
ect [-Wunused-value]

---------------------------------------------------------------------------=
-----
oxnas_v6_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    /scratch/linux/kernel/kprobes.c:1070:33: warning: statement with no eff=
ect [-Wunused-value]

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    /scratch/linux/kernel/kprobes.c:1070:33: warning: statement with no eff=
ect [-Wunused-value]

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

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
rm200_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

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
simpad_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    arch/arm/boot/dts/sun8i-h3-beelink-x2.dtb: Warning (clocks_property): /=
wifi_pwrseq: Missing property '#clock-cells' in node /soc/rtc@1f00000 or ba=
d phandle (referred from clocks[0])

---------------------------------------------------------------------------=
-----
tango4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sectio=
n mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 se=
ction mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mis=
matches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
tinyconfig (riscv, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mi=
smatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section m=
ismatches

Warnings:
    .config:1010:warning: override: UNWINDER_GUESS changes choice state

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mism=
atches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mism=
atches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section mi=
smatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sect=
ion mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 secti=
on mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section=
 mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 =
section mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 sec=
tion mismatches

Warnings:
    /scratch/linux/kernel/kprobes.c:1070:33: warning: statement with no eff=
ect [-Wunused-value]

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 2 warnings, 0 section=
 mismatches

Warnings:
    /scratch/linux/kernel/kprobes.c:1070:33: warning: statement with no eff=
ect [-Wunused-value]
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 1 warning, 0 section =
mismatches

Warnings:
    /scratch/linux/drivers/clk/clk.c:49:27: warning: =E2=80=98orphan_list=
=E2=80=99 defined but not used [-Wunused-variable]

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---
For more info write to <info@kernelci.org>
