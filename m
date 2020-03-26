Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A63B1193718
	for <lists+stable@lfdr.de>; Thu, 26 Mar 2020 04:34:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbgCZDeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 23:34:20 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41865 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727575AbgCZDeU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Mar 2020 23:34:20 -0400
Received: by mail-pl1-f193.google.com with SMTP id t16so1620577plr.8
        for <stable@vger.kernel.org>; Wed, 25 Mar 2020 20:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OlAefLEiQxSKi/Q7LPeUS4FUEOpCuBH/5Klp/tseHw0=;
        b=GX/KZOL9/jZl2s9iQ8Wc3zNtmxXfCOsytYR1zNWvCMvh3MdlWOo9X7wmCpnKfkr1hJ
         4Veo+3B1/vqVmjQnrT5fbu3qSc2K3Y0We+ZGvV+f1FZ9h0e5S4o12HRbOYLcSQL51W1y
         jR1Kb3UxvwMXTr2VzsSSHyQb58aH1IYIK5Py2L2O1Zzev1zSvytxD4CochwjZU4B1gbL
         H5WELZFAe17LZNasS7cERXBFR3KkoP0S/rFRKCSOWNd1RK4KGo4TRuP/LDus34cVIpAo
         lqUmn0RD1cLAnNAe1iMnnzvXAEEZsr92vDs3ctQuTsuMgJyanQX+z1/9gdhFPtfX5+xs
         YTUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OlAefLEiQxSKi/Q7LPeUS4FUEOpCuBH/5Klp/tseHw0=;
        b=RG2wYUuCBwH6au7XZ7S0Oi7MOBCWUbDleaQMErcTCuXHRij5lyLvacOWXfMp5Vrsxz
         w9jWs4plW4OH9oEHiVY8JRzXVdHfKjAVIY+N/kwICfNSm0b8ytXeZjCfg1hiniZGD7qb
         N1oFYeoDJrFBMmvrpyQ6clSuWB5Cgmjx4Q3wgDu9jhV6YsbyMoc6SAVIq+0ZVLVNf/Kl
         IxP64nwUiR8wWocS1pvgTeQq/Tnq5NwMU0W9rbUzeewDEptiqSc9QU6VSz6LJbegYKcP
         +/yxJZliCgX6sxW/mFvOvrn5Cxav693LymnF1JIaCAvVOE8xTlwWJG+2gu4fyb4sIbm7
         I8YQ==
X-Gm-Message-State: ANhLgQ2JggyqF0XPdejhhSXu2yejWchkero9uFdr2pW8E2t5TvaqGGl7
        QqoD4C8qoxVuQ8rFgdVLoICbDS6l00o=
X-Google-Smtp-Source: ADFU+vsLibGAGBJUZFPPFZW5qfNQ/KwEoco6DST4/KYMcPN+p/uBigexbh6g7Ps3ieotqo+wz1+AAw==
X-Received: by 2002:a17:902:6a88:: with SMTP id n8mr6117796plk.265.1585193658707;
        Wed, 25 Mar 2020 20:34:18 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l15sm472363pgk.59.2020.03.25.20.34.17
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 20:34:18 -0700 (PDT)
Message-ID: <5e7c22ba.1c69fb81.29911.296e@mx.google.com>
Date:   Wed, 25 Mar 2020 20:34:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.174
X-Kernelci-Report-Type: build
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y build: 201 builds: 0 failed, 201 passed,
 102 warnings (v4.14.174)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y build: 201 builds: 0 failed, 201 passed, 102 warning=
s (v4.14.174)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.174/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.174
Git Commit: 01364dad1d4577e27a57729d41053f661bb8a5b9
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Warnings Detected:

arc:

arm64:
    defconfig (gcc-8): 1 warning

arm:
    acs5k_defconfig (gcc-8): 1 warning
    acs5k_tiny_defconfig (gcc-8): 1 warning
    aspeed_g4_defconfig (gcc-8): 1 warning
    aspeed_g5_defconfig (gcc-8): 1 warning
    assabet_defconfig (gcc-8): 1 warning
    axm55xx_defconfig (gcc-8): 1 warning
    badge4_defconfig (gcc-8): 1 warning
    cerfcube_defconfig (gcc-8): 1 warning
    clps711x_defconfig (gcc-8): 1 warning
    cm_x300_defconfig (gcc-8): 1 warning
    cns3420vb_defconfig (gcc-8): 1 warning
    colibri_pxa270_defconfig (gcc-8): 1 warning
    colibri_pxa300_defconfig (gcc-8): 1 warning
    collie_defconfig (gcc-8): 1 warning
    corgi_defconfig (gcc-8): 1 warning
    davinci_all_defconfig (gcc-8): 1 warning
    dove_defconfig (gcc-8): 1 warning
    ebsa110_defconfig (gcc-8): 1 warning
    ep93xx_defconfig (gcc-8): 1 warning
    eseries_pxa_defconfig (gcc-8): 1 warning
    exynos_defconfig (gcc-8): 1 warning
    ezx_defconfig (gcc-8): 1 warning
    footbridge_defconfig (gcc-8): 1 warning
    gemini_defconfig (gcc-8): 1 warning
    h3600_defconfig (gcc-8): 1 warning
    hackkit_defconfig (gcc-8): 1 warning
    hisi_defconfig (gcc-8): 1 warning
    imote2_defconfig (gcc-8): 1 warning
    imx_v6_v7_defconfig (gcc-8): 1 warning
    integrator_defconfig (gcc-8): 1 warning
    iop13xx_defconfig (gcc-8): 1 warning
    iop32x_defconfig (gcc-8): 1 warning
    iop33x_defconfig (gcc-8): 1 warning
    ixp4xx_defconfig (gcc-8): 1 warning
    jornada720_defconfig (gcc-8): 1 warning
    keystone_defconfig (gcc-8): 1 warning
    ks8695_defconfig (gcc-8): 1 warning
    lart_defconfig (gcc-8): 1 warning
    lpd270_defconfig (gcc-8): 1 warning
    lubbock_defconfig (gcc-8): 1 warning
    magician_defconfig (gcc-8): 1 warning
    mainstone_defconfig (gcc-8): 1 warning
    mini2440_defconfig (gcc-8): 1 warning
    mmp2_defconfig (gcc-8): 1 warning
    moxart_defconfig (gcc-8): 1 warning
    multi_v4t_defconfig (gcc-8): 1 warning
    multi_v5_defconfig (gcc-8): 1 warning
    multi_v7_defconfig (gcc-8): 2 warnings
    mv78xx0_defconfig (gcc-8): 1 warning
    mvebu_v5_defconfig (gcc-8): 1 warning
    mvebu_v7_defconfig (gcc-8): 1 warning
    mxs_defconfig (gcc-8): 1 warning
    neponset_defconfig (gcc-8): 1 warning
    netwinder_defconfig (gcc-8): 1 warning
    netx_defconfig (gcc-8): 1 warning
    nhk8815_defconfig (gcc-8): 1 warning
    nuc910_defconfig (gcc-8): 1 warning
    nuc950_defconfig (gcc-8): 1 warning
    nuc960_defconfig (gcc-8): 1 warning
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
    realview_defconfig (gcc-8): 1 warning
    rpc_defconfig (gcc-8): 1 warning
    s3c2410_defconfig (gcc-8): 1 warning
    s3c6400_defconfig (gcc-8): 1 warning
    s5pv210_defconfig (gcc-8): 1 warning
    sama5_defconfig (gcc-8): 1 warning
    shannon_defconfig (gcc-8): 1 warning
    simpad_defconfig (gcc-8): 1 warning
    socfpga_defconfig (gcc-8): 1 warning
    spear13xx_defconfig (gcc-8): 1 warning
    spear3xx_defconfig (gcc-8): 1 warning
    spear6xx_defconfig (gcc-8): 1 warning
    spitz_defconfig (gcc-8): 1 warning
    sunxi_defconfig (gcc-8): 2 warnings
    tango4_defconfig (gcc-8): 1 warning
    tegra_defconfig (gcc-8): 1 warning
    trizeps4_defconfig (gcc-8): 1 warning
    u300_defconfig (gcc-8): 1 warning
    u8500_defconfig (gcc-8): 1 warning
    versatile_defconfig (gcc-8): 1 warning
    vexpress_defconfig (gcc-8): 1 warning
    vt8500_v6_v7_defconfig (gcc-8): 1 warning
    zeus_defconfig (gcc-8): 1 warning
    zx_defconfig (gcc-8): 1 warning

i386:
    i386_defconfig (gcc-8): 1 warning

mips:
    malta_qemu_32r6_defconfig (gcc-8): 1 warning

x86_64:
    tinyconfig (gcc-8): 1 warning
    x86_64_defconfig (gcc-8): 1 warning


Warnings summary:

    98   fs/proc/task_mmu.c:761:7: warning: =E2=80=98last_vma=E2=80=99 may =
be used uninitialized in this function [-Wmaybe-uninitialized]
    2    drivers/gpu/drm/sun4i/sun4i_hdmi_tmds_clk.c:146:5: warning: =E2=80=
=98is_double=E2=80=99 may be used uninitialized in this function [-Wmaybe-u=
ninitialized]
    1    {standard input}:29: Warning: macro instruction expanded into mult=
iple instructions
    1    .config:1028:warning: override: UNWINDER_GUESS changes choice state

---
For more info write to <info@kernelci.org>
