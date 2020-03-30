Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2C351984A0
	for <lists+stable@lfdr.de>; Mon, 30 Mar 2020 21:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbgC3Tig (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Mar 2020 15:38:36 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41046 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727714AbgC3Tig (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Mar 2020 15:38:36 -0400
Received: by mail-pl1-f195.google.com with SMTP id d24so3304463pll.8
        for <stable@vger.kernel.org>; Mon, 30 Mar 2020 12:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cnwJ6a001RptyFamUiLyfgHdxABlvoWQAfJqJUtaE2s=;
        b=OR6432uNdhBwm0s1+HfCN1UJEyMD7gm2UKbopu0Dbh7tGBBb3s8RCbzoW/xDZO2+rr
         cac06oPvn2mnmLBdN2qRiHNv3/5pEp3+SEyO2DufyvIffitAZJzNsdsjWL+Fvz3PK47a
         aW6YADRi1dW/BkhcfJ0Zc+X9M3zP0A9seGPsOJtAgqcJ1bH7KDWmb0/NVdA7V5EnYIrt
         vMH6lQV344OxKoVMLPqgXn+P43ya53m+f5jynAlGFP9gZym7M1mUrISLQfjPSQiI+76R
         WWwrlUiqhfzantbCQngSMwrYStGt2iSyM8ddWLM5Q1qjoU0Gqi33jcV3BM1grZdPle6a
         h2pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cnwJ6a001RptyFamUiLyfgHdxABlvoWQAfJqJUtaE2s=;
        b=rfxjHuml4V98sI4XFurcK08dOPn7J17DWwV+lIvoR03BddC+VRW4ydrpKspZ8/iKHI
         VV9UO21JB2wefFjyqCdBWoLylHSFELhHSftQLIImuRHYzDuVPzEJ22e47znv4c0k8noj
         nMbJTpibdgyWJsma0O+V4grBuv9RHqx7bI/sriITLgM5Vt89ojh1FmwI5tqzQdhAMCy3
         PrFF28MZBrmV3lfuFBUX4JgOU7dmwwvvdaxoSeeDaaPIhtx8jsWOnmobbHn/HrmOVnBR
         PAP8ZrTP/ChQ5Ch9Z3R71RE8zeNRPtotMQi0c3Htp4df1QiJWQcGYe0zhHmwAgbN4wiF
         wzEw==
X-Gm-Message-State: AGi0Puas9Ta/vSEppnetxaUtbh55vxc2jtdEMQBiQKNprmx5SSyiZa/a
        WD3SZJg71cXLibLhuuBFZdV6arqKg90=
X-Google-Smtp-Source: APiQypKcKVm9g4EXXnwK0tKit1Iu41fzaIkzD8dk4yrbTDOzRWQ0DyBso91GBN70UxT5icYoBaMdhQ==
X-Received: by 2002:a17:90a:5802:: with SMTP id h2mr939490pji.141.1585597113805;
        Mon, 30 Mar 2020 12:38:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y9sm11306108pfo.135.2020.03.30.12.38.32
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 12:38:33 -0700 (PDT)
Message-ID: <5e824ab9.1c69fb81.f37ae.06cc@mx.google.com>
Date:   Mon, 30 Mar 2020 12:38:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.174-112-g7d4e98ddeffc
X-Kernelci-Report-Type: build
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y build: 201 builds: 0 failed, 201 passed,
 102 warnings (v4.14.174-112-g7d4e98ddeffc)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y build: 201 builds: 0 failed, 201 passed, 102 warning=
s (v4.14.174-112-g7d4e98ddeffc)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.174-112-g7d4e98ddeffc/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.174-112-g7d4e98ddeffc
Git Commit: 7d4e98ddeffca219e71f08142a7100e7c16efef8
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
