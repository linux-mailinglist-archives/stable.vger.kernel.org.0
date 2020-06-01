Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA0B1EA6E1
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 17:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbgFAP3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 11:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgFAP3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 11:29:47 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6281AC05BD43
        for <stable@vger.kernel.org>; Mon,  1 Jun 2020 08:29:47 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x207so1766938pfc.5
        for <stable@vger.kernel.org>; Mon, 01 Jun 2020 08:29:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zW650EKvNuafQ0kmWM45IMXgs1ktIndMqQXFe8WoNJQ=;
        b=mMwWpUyglFPLDrHbz8NG1exnUQ9CToryMI0hT6H1bckVo8ocd6CMWemSLzJ/8PqCtW
         mmkJsCO2+xwWWnMjEQZVbZeis4crxAxgUfbNpGt2SAiD6BDLOUNGjPUC1XQlbZgy+agx
         oMqsUUWaYx4GwhLaqaaTRLGGWTULipQuWgimapgpMNDJ4jJRtnV4+LWp1jbtTIqkVdl3
         XixAkGUfJ3dqfQ1ncTF3drLB6T6WUbF9SQhUWr5qu0TKe5zDwhPRfCe+RTYMmggKWrmS
         U7l4/rCqKjMFgqDtlfl6uPYRs73CSaEQKrr77OriuqpAgC4nQC/Meey8ShM13OTIZ8hS
         pUHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zW650EKvNuafQ0kmWM45IMXgs1ktIndMqQXFe8WoNJQ=;
        b=f5PIq+YwwCOyoczrs0FURxzK5HCGzNwCZuHr6e3ISwC/NDU8SAyMRSq65wRC60vzZy
         NEjZ2dQs42MGi2WkSpk8CsFe+MZ4TAGgqc42jXVaLkfsmCpvu0OpG25U4XMb/qBvfe4U
         lwQa/7jyUvNR4cLObR5xRgnvdMzJm7cl5KITuI3jAnVA4SwtoNVTkwJQUDy1R9Orn/1Y
         h+BPSizvl1ksf4vvyvTaNqCualJjSHViQ+vhZrP3jhR7JrydWJfQ/cpIRseCQZSezJ8R
         1OkZ644vmMuFJyT9DS1xJmHBxVIyNlbGtCixS5J7ugzLnIxX6jXzXow0KWNGhhTE5PY0
         aqWw==
X-Gm-Message-State: AOAM531KVQWOkX3dsaoV6rKcRDDSniuMnwbPnDgIsqnV/yIPG6116SUf
        GayMhf15f+gbTqe5f05hYlGuwadanoY=
X-Google-Smtp-Source: ABdhPJyYmsYsMrogQ6ChFi+qnyiS/HnyBFVZZaM8E+rS28NagaTkUaTCnG26r5I+Xx67ISbm5DRvHQ==
X-Received: by 2002:a62:5f84:: with SMTP id t126mr22196747pfb.124.1591025385606;
        Mon, 01 Jun 2020 08:29:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d18sm14673623pfq.136.2020.06.01.08.29.44
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 08:29:44 -0700 (PDT)
Message-ID: <5ed51ee8.1c69fb81.682aa.104e@mx.google.com>
Date:   Mon, 01 Jun 2020 08:29:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v4.9.225-57-g990ea89b3621
Subject: stable-rc/linux-4.9.y build: 166 builds: 90 failed, 76 passed,
 141 errors (v4.9.225-57-g990ea89b3621)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y build: 166 builds: 90 failed, 76 passed, 141 errors (=
v4.9.225-57-g990ea89b3621)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.225-57-g990ea89b3621/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.225-57-g990ea89b3621
Git Commit: 990ea89b3621b316bb37afa2f9e65565cb4cbc26
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failures Detected:

arm:
    acs5k_defconfig: (gcc-8) FAIL
    acs5k_tiny_defconfig: (gcc-8) FAIL
    am200epdkit_defconfig: (gcc-8) FAIL
    aspeed_g5_defconfig: (gcc-8) FAIL
    assabet_defconfig: (gcc-8) FAIL
    axm55xx_defconfig: (gcc-8) FAIL
    badge4_defconfig: (gcc-8) FAIL
    bcm2835_defconfig: (gcc-8) FAIL
    cerfcube_defconfig: (gcc-8) FAIL
    clps711x_defconfig: (gcc-8) FAIL
    cm_x2xx_defconfig: (gcc-8) FAIL
    cm_x300_defconfig: (gcc-8) FAIL
    cns3420vb_defconfig: (gcc-8) FAIL
    colibri_pxa270_defconfig: (gcc-8) FAIL
    collie_defconfig: (gcc-8) FAIL
    corgi_defconfig: (gcc-8) FAIL
    davinci_all_defconfig: (gcc-8) FAIL
    dove_defconfig: (gcc-8) FAIL
    em_x270_defconfig: (gcc-8) FAIL
    ep93xx_defconfig: (gcc-8) FAIL
    eseries_pxa_defconfig: (gcc-8) FAIL
    ezx_defconfig: (gcc-8) FAIL
    footbridge_defconfig: (gcc-8) FAIL
    h3600_defconfig: (gcc-8) FAIL
    h5000_defconfig: (gcc-8) FAIL
    hackkit_defconfig: (gcc-8) FAIL
    hisi_defconfig: (gcc-8) FAIL
    imote2_defconfig: (gcc-8) FAIL
    imx_v4_v5_defconfig: (gcc-8) FAIL
    imx_v6_v7_defconfig: (gcc-8) FAIL
    integrator_defconfig: (gcc-8) FAIL
    iop13xx_defconfig: (gcc-8) FAIL
    iop32x_defconfig: (gcc-8) FAIL
    iop33x_defconfig: (gcc-8) FAIL
    ixp4xx_defconfig: (gcc-8) FAIL
    jornada720_defconfig: (gcc-8) FAIL
    keystone_defconfig: (gcc-8) FAIL
    lart_defconfig: (gcc-8) FAIL
    lpc32xx_defconfig: (gcc-8) FAIL
    lubbock_defconfig: (gcc-8) FAIL
    magician_defconfig: (gcc-8) FAIL
    mainstone_defconfig: (gcc-8) FAIL
    mmp2_defconfig: (gcc-8) FAIL
    moxart_defconfig: (gcc-8) FAIL
    multi_v4t_defconfig: (gcc-8) FAIL
    multi_v5_defconfig: (gcc-8) FAIL
    multi_v7_defconfig: (gcc-8) FAIL
    mv78xx0_defconfig: (gcc-8) FAIL
    mvebu_v5_defconfig: (gcc-8) FAIL
    mvebu_v7_defconfig: (gcc-8) FAIL
    mxs_defconfig: (gcc-8) FAIL
    neponset_defconfig: (gcc-8) FAIL
    netwinder_defconfig: (gcc-8) FAIL
    netx_defconfig: (gcc-8) FAIL
    nhk8815_defconfig: (gcc-8) FAIL
    nuc950_defconfig: (gcc-8) FAIL
    nuc960_defconfig: (gcc-8) FAIL
    omap2plus_defconfig: (gcc-8) FAIL
    orion5x_defconfig: (gcc-8) FAIL
    palmz72_defconfig: (gcc-8) FAIL
    pleb_defconfig: (gcc-8) FAIL
    prima2_defconfig: (gcc-8) FAIL
    pxa168_defconfig: (gcc-8) FAIL
    pxa3xx_defconfig: (gcc-8) FAIL
    pxa910_defconfig: (gcc-8) FAIL
    pxa_defconfig: (gcc-8) FAIL
    raumfeld_defconfig: (gcc-8) FAIL
    realview_defconfig: (gcc-8) FAIL
    rpc_defconfig: (gcc-8) FAIL
    s3c2410_defconfig: (gcc-8) FAIL
    s5pv210_defconfig: (gcc-8) FAIL
    sama5_defconfig: (gcc-8) FAIL
    shannon_defconfig: (gcc-8) FAIL
    shmobile_defconfig: (gcc-8) FAIL
    simpad_defconfig: (gcc-8) FAIL
    socfpga_defconfig: (gcc-8) FAIL
    spear13xx_defconfig: (gcc-8) FAIL
    spear3xx_defconfig: (gcc-8) FAIL
    spear6xx_defconfig: (gcc-8) FAIL
    tct_hammer_defconfig: (gcc-8) FAIL
    tegra_defconfig: (gcc-8) FAIL
    trizeps4_defconfig: (gcc-8) FAIL
    u300_defconfig: (gcc-8) FAIL
    u8500_defconfig: (gcc-8) FAIL
    versatile_defconfig: (gcc-8) FAIL
    vexpress_defconfig: (gcc-8) FAIL
    viper_defconfig: (gcc-8) FAIL
    vt8500_v6_v7_defconfig: (gcc-8) FAIL
    zeus_defconfig: (gcc-8) FAIL

mips:
    32r2el_defconfig: (gcc-8) FAIL

Errors Detected:

arc:

arm64:

arm:
    acs5k_defconfig (gcc-8): 1 error
    acs5k_tiny_defconfig (gcc-8): 1 error
    am200epdkit_defconfig (gcc-8): 1 error
    aspeed_g5_defconfig (gcc-8): 1 error
    assabet_defconfig (gcc-8): 1 error
    axm55xx_defconfig (gcc-8): 4 errors
    badge4_defconfig (gcc-8): 1 error
    bcm2835_defconfig (gcc-8): 3 errors
    cerfcube_defconfig (gcc-8): 1 error
    clps711x_defconfig (gcc-8): 1 error
    cm_x2xx_defconfig (gcc-8): 1 error
    cm_x300_defconfig (gcc-8): 1 error
    cns3420vb_defconfig (gcc-8): 1 error
    colibri_pxa270_defconfig (gcc-8): 1 error
    collie_defconfig (gcc-8): 1 error
    corgi_defconfig (gcc-8): 1 error
    davinci_all_defconfig (gcc-8): 1 error
    dove_defconfig (gcc-8): 3 errors
    em_x270_defconfig (gcc-8): 1 error
    ep93xx_defconfig (gcc-8): 1 error
    eseries_pxa_defconfig (gcc-8): 1 error
    ezx_defconfig (gcc-8): 1 error
    footbridge_defconfig (gcc-8): 1 error
    h3600_defconfig (gcc-8): 1 error
    h5000_defconfig (gcc-8): 1 error
    hackkit_defconfig (gcc-8): 9 errors
    hisi_defconfig (gcc-8): 2 errors
    imote2_defconfig (gcc-8): 1 error
    imx_v4_v5_defconfig (gcc-8): 1 error
    imx_v6_v7_defconfig (gcc-8): 2 errors
    integrator_defconfig (gcc-8): 1 error
    iop13xx_defconfig (gcc-8): 1 error
    iop32x_defconfig (gcc-8): 1 error
    iop33x_defconfig (gcc-8): 1 error
    ixp4xx_defconfig (gcc-8): 1 error
    jornada720_defconfig (gcc-8): 1 error
    keystone_defconfig (gcc-8): 2 errors
    lart_defconfig (gcc-8): 1 error
    lpc32xx_defconfig (gcc-8): 1 error
    lubbock_defconfig (gcc-8): 1 error
    magician_defconfig (gcc-8): 1 error
    mainstone_defconfig (gcc-8): 9 errors
    mmp2_defconfig (gcc-8): 3 errors
    moxart_defconfig (gcc-8): 1 error
    multi_v4t_defconfig (gcc-8): 1 error
    multi_v5_defconfig (gcc-8): 1 error
    multi_v7_defconfig (gcc-8): 2 errors
    mv78xx0_defconfig (gcc-8): 1 error
    mvebu_v5_defconfig (gcc-8): 1 error
    mvebu_v7_defconfig (gcc-8): 2 errors
    mxs_defconfig (gcc-8): 1 error
    neponset_defconfig (gcc-8): 1 error
    netwinder_defconfig (gcc-8): 1 error
    netx_defconfig (gcc-8): 1 error
    nhk8815_defconfig (gcc-8): 1 error
    nuc950_defconfig (gcc-8): 1 error
    nuc960_defconfig (gcc-8): 1 error
    omap2plus_defconfig (gcc-8): 2 errors
    orion5x_defconfig (gcc-8): 1 error
    palmz72_defconfig (gcc-8): 9 errors
    pleb_defconfig (gcc-8): 1 error
    prima2_defconfig (gcc-8): 1 error
    pxa168_defconfig (gcc-8): 1 error
    pxa3xx_defconfig (gcc-8): 1 error
    pxa910_defconfig (gcc-8): 1 error
    pxa_defconfig (gcc-8): 1 error
    raumfeld_defconfig (gcc-8): 1 error
    realview_defconfig (gcc-8): 2 errors
    rpc_defconfig (gcc-8): 1 error
    s3c2410_defconfig (gcc-8): 1 error
    s5pv210_defconfig (gcc-8): 3 errors
    sama5_defconfig (gcc-8): 3 errors
    shannon_defconfig (gcc-8): 1 error
    shmobile_defconfig (gcc-8): 2 errors
    simpad_defconfig (gcc-8): 1 error
    socfpga_defconfig (gcc-8): 2 errors
    spear13xx_defconfig (gcc-8): 2 errors
    spear3xx_defconfig (gcc-8): 1 error
    spear6xx_defconfig (gcc-8): 1 error
    tct_hammer_defconfig (gcc-8): 1 error
    tegra_defconfig (gcc-8): 2 errors
    trizeps4_defconfig (gcc-8): 1 error
    u300_defconfig (gcc-8): 1 error
    u8500_defconfig (gcc-8): 2 errors
    versatile_defconfig (gcc-8): 1 error
    vexpress_defconfig (gcc-8): 2 errors
    viper_defconfig (gcc-8): 1 error
    vt8500_v6_v7_defconfig (gcc-8): 3 errors
    zeus_defconfig (gcc-8): 1 error

i386:

mips:

x86_64:

Errors summary:

    69   arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip=
]'
    15   arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[=
r0],#32*4'
    15   arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[=
r10],#32*4'
    6    arch/arm/lib/clear_user.S:44: Error: bad instruction `strbtne r2,[=
r0],#1'
    6    arch/arm/lib/clear_user.S:39: Error: bad instruction `strtpl r2,[r=
0],#4'
    5    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stclne p11,cr0,[=
r0],#32*4'
    5    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldclne p11,cr0,[=
r10],#32*4'
    4    arch/arm/vfp/vfphw.S:116: Error: bad instruction `stcleq p11,cr0,[=
r4],#32*4'
    3    arch/arm/lib/clear_user.S:42: Error: bad instruction `strtpl r2,[r=
0],#4'
    3    arch/arm/lib/clear_user.S:35: Error: bad instruction `strbtlt r2,[=
r0],#1'
    3    arch/arm/lib/clear_user.S:34: Error: bad instruction `strbtle r2,[=
r0],#1'
    3    arch/arm/lib/clear_user.S:33: Error: bad instruction `strbtal r2,[=
r0],#1'
    2    arch/arm/vfp/vfphw.S:116: Error: bad instruction `stclne p11,cr0,[=
r4],#32*4'
    1    arch/arm/kvm/hyp/vfp.S:54: Error: bad instruction `ldcleq p11,cr0,=
[r0],#32*4'
    1    arch/arm/kvm/hyp/vfp.S:45: Error: bad instruction `stcleq p11,cr0,=
[r0],#32*4'


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
acs5k_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

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
allnoconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 4 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'
    arch/arm/kvm/hyp/vfp.S:45: Error: bad instruction `stcleq p11,cr0,[r0],=
#32*4'
    arch/arm/kvm/hyp/vfp.S:54: Error: bad instruction `ldcleq p11,cr0,[r0],=
#32*4'

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-8) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/vfp/vfphw.S:116: Error: bad instruction `stclne p11,cr0,[r4],#=
32*4'
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldclne p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stclne p11,cr0,[r0],#=
32*4'

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
cerfcube_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, =
0 section mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

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
dove_defconfig (arm, gcc-8) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 section=
 mismatches

Errors:
    arch/arm/vfp/vfphw.S:116: Error: bad instruction `stcleq p11,cr0,[r4],#=
32*4'
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 s=
ection mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section m=
ismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-8) =E2=80=94 FAIL, 9 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'
    arch/arm/lib/clear_user.S:33: Error: bad instruction `strbtal r2,[r0],#=
1'
    arch/arm/lib/clear_user.S:34: Error: bad instruction `strbtle r2,[r0],#=
1'
    arch/arm/lib/clear_user.S:35: Error: bad instruction `strbtlt r2,[r0],#=
1'
    arch/arm/lib/clear_user.S:39: Error: bad instruction `strtpl r2,[r0],#4'
    arch/arm/lib/clear_user.S:39: Error: bad instruction `strtpl r2,[r0],#4'
    arch/arm/lib/clear_user.S:42: Error: bad instruction `strtpl r2,[r0],#4'
    arch/arm/lib/clear_user.S:44: Error: bad instruction `strbtne r2,[r0],#=
1'
    arch/arm/lib/clear_user.S:44: Error: bad instruction `strbtne r2,[r0],#=
1'

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 section=
 mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldclne p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stclne p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

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
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

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
loongson3_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-8) =E2=80=94 FAIL, 9 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'
    arch/arm/lib/clear_user.S:33: Error: bad instruction `strbtal r2,[r0],#=
1'
    arch/arm/lib/clear_user.S:34: Error: bad instruction `strbtle r2,[r0],#=
1'
    arch/arm/lib/clear_user.S:35: Error: bad instruction `strbtlt r2,[r0],#=
1'
    arch/arm/lib/clear_user.S:39: Error: bad instruction `strtpl r2,[r0],#4'
    arch/arm/lib/clear_user.S:39: Error: bad instruction `strtpl r2,[r0],#4'
    arch/arm/lib/clear_user.S:42: Error: bad instruction `strtpl r2,[r0],#4'
    arch/arm/lib/clear_user.S:44: Error: bad instruction `strbtne r2,[r0],#=
1'
    arch/arm/lib/clear_user.S:44: Error: bad instruction `strbtne r2,[r0],#=
1'

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings,=
 0 section mismatches

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 section=
 mismatches

Errors:
    arch/arm/vfp/vfphw.S:116: Error: bad instruction `stcleq p11,cr0,[r4],#=
32*4'
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

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
mtx1_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section m=
ismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
netx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

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
nuc950_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
nuc960_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldclne p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stclne p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 FAIL, 9 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'
    arch/arm/lib/clear_user.S:33: Error: bad instruction `strbtal r2,[r0],#=
1'
    arch/arm/lib/clear_user.S:34: Error: bad instruction `strbtle r2,[r0],#=
1'
    arch/arm/lib/clear_user.S:35: Error: bad instruction `strbtlt r2,[r0],#=
1'
    arch/arm/lib/clear_user.S:39: Error: bad instruction `strtpl r2,[r0],#4'
    arch/arm/lib/clear_user.S:39: Error: bad instruction `strtpl r2,[r0],#4'
    arch/arm/lib/clear_user.S:42: Error: bad instruction `strtpl r2,[r0],#4'
    arch/arm/lib/clear_user.S:44: Error: bad instruction `strbtne r2,[r0],#=
1'
    arch/arm/lib/clear_user.S:44: Error: bad instruction `strbtne r2,[r0],#=
1'

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings=
, 0 section mismatches

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section m=
ismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

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
realview_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldclne p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stclne p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 secti=
on mismatches

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section m=
ismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-8) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/vfp/vfphw.S:116: Error: bad instruction `stcleq p11,cr0,[r4],#=
32*4'
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 3 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/vfp/vfphw.S:116: Error: bad instruction `stcleq p11,cr0,[r4],#=
32*4'
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 secti=
on mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

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
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 se=
ction mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
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
trizeps4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sect=
ion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section =
mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sectio=
n mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0=
 section mismatches

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 0 warnings, 0 sec=
tion mismatches

Errors:
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldcleq p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stcleq p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 0 warnings, 0 section=
 mismatches

Errors:
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 3 errors, 0 warnings, 0=
 section mismatches

Errors:
    arch/arm/vfp/vfphw.S:116: Error: bad instruction `stclne p11,cr0,[r4],#=
32*4'
    arch/arm/vfp/vfphw.S:158: Error: bad instruction `ldclne p11,cr0,[r10],=
#32*4'
    arch/arm/vfp/vfphw.S:233: Error: bad instruction `stclne p11,cr0,[r0],#=
32*4'

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 se=
ction mismatches

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
    arch/arm/lib/changebit.S:15: Error: bad instruction `strbne r1,[ip]'

---
For more info write to <info@kernelci.org>
