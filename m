Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF6C012E02B
	for <lists+stable@lfdr.de>; Wed,  1 Jan 2020 19:46:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbgAASqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jan 2020 13:46:32 -0500
Received: from mail-wr1-f50.google.com ([209.85.221.50]:39247 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727268AbgAASqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jan 2020 13:46:32 -0500
Received: by mail-wr1-f50.google.com with SMTP id y11so37449584wrt.6
        for <stable@vger.kernel.org>; Wed, 01 Jan 2020 10:46:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mQtN0gXeh3vA/9Ha1bXEqN16FjZWMxo3AR822qMuXOQ=;
        b=JK+zy+WrwnK50Kszi6p7xrMKgtWBQP8spoJCkudHFPe7Xel/voF9TjikuT/3/Eme27
         TJT7XC7kpnmQcMBICs8zfbXTOcsLT5JAXNuvhPFbEpU+ZRH8+jkGLlrxUJB/PkGUQTf8
         IaBZ0HX+AJBoYWXP+6pNWw5x8KPWC48Hj+syWOfp79VkvlicGV4K66BFGF0wXQyxuukf
         iPF+p4lkGHMNXVBUfhW91ywZWo07jlV73meklsQaEwMuTdK0Z6y109AfKp8gAtEkhe3k
         deGhOQVmT4mOHck02wcltmEPWCI56YU/+CLn05CzWvjdNS977qPHnQNNcaITLj7zQVEk
         G14w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mQtN0gXeh3vA/9Ha1bXEqN16FjZWMxo3AR822qMuXOQ=;
        b=eKLCf0aFNd4qG+X97LKUm6bM7sGqOmZt4mOE2HPITkOPwjXUOwOLv4uZdN1Qcko16U
         DG5kbdE9vt1gHwYQfKDE2/PF60/WopZpPxk4RGSTWwtYU7JM69CIVSCR2bn9lJS0Ovcy
         rUE67sYWLdN1gjVHJw5sdWTZfu9kVLWoDscaPCg5+fKDvrPZnaY1isIy2d4E6Tijmu8Q
         hVy6+loctdrTXll61ZvRM6i1FvrvMuUhSTdeGUjp1gWuPJd86ob+NPYds7K3qdzK+mHz
         wRw9WwxhXWhVqeWO+BhHSiIUT+Nxzaw5uN/jmSwb6RFNVvzPbkGqtyCXZXqMdCYpnbOF
         zy/g==
X-Gm-Message-State: APjAAAWY+29y9q4V3rxYRPSrkGc3lBXMsu3f43V/jSjTTkSQx+jbRHFl
        ei3E3KDOF5lm7f69sq+ebhJEjbvVVu/bJw==
X-Google-Smtp-Source: APXvYqzXmA8w5fCzCC05hPb3muH+YTw9n5VicTz6Jq9t3SFNhoeXJ5B3pKW8080lvTpKdQm6Y+zAMA==
X-Received: by 2002:adf:e984:: with SMTP id h4mr76510783wrm.275.1577904384966;
        Wed, 01 Jan 2020 10:46:24 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n67sm6266335wmf.46.2020.01.01.10.46.24
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jan 2020 10:46:24 -0800 (PST)
Message-ID: <5e0ce900.1c69fb81.1e944.c3da@mx.google.com>
Date:   Wed, 01 Jan 2020 10:46:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.207-164-g7d6b084587b1
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: build
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y build: 197 builds: 170 failed, 27 passed,
 169 errors, 338 warnings (v4.9.207-164-g7d6b084587b1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y build: 197 builds: 170 failed, 27 passed, 169 errors,=
 338 warnings (v4.9.207-164-g7d6b084587b1)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.207-164-g7d6b084587b1/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.207-164-g7d6b084587b1
Git Commit: 7d6b084587b18722645e5f6905006e71124a65e6
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failures Detected:

arc:
    axs103_defconfig: (gcc-8) FAIL
    axs103_smp_defconfig: (gcc-8) FAIL
    nsim_hs_defconfig: (gcc-8) FAIL
    nsim_hs_smp_defconfig: (gcc-8) FAIL
    nsimosci_hs_defconfig: (gcc-8) FAIL
    nsimosci_hs_smp_defconfig: (gcc-8) FAIL
    vdk_hs38_defconfig: (gcc-8) FAIL
    vdk_hs38_smp_defconfig: (gcc-8) FAIL
    zebu_hs_defconfig: (gcc-8) FAIL
    zebu_hs_smp_defconfig: (gcc-8) FAIL

arm64:
    defconfig: (gcc-8) FAIL

arm:
    acs5k_defconfig: (gcc-8) FAIL
    acs5k_tiny_defconfig: (gcc-8) FAIL
    assabet_defconfig: (gcc-8) FAIL
    at91_dt_defconfig: (gcc-8) FAIL
    axm55xx_defconfig: (gcc-8) FAIL
    badge4_defconfig: (gcc-8) FAIL
    bcm2835_defconfig: (gcc-8) FAIL
    cerfcube_defconfig: (gcc-8) FAIL
    clps711x_defconfig: (gcc-8) FAIL
    cm_x2xx_defconfig: (gcc-8) FAIL
    cm_x300_defconfig: (gcc-8) FAIL
    cns3420vb_defconfig: (gcc-8) FAIL
    colibri_pxa270_defconfig: (gcc-8) FAIL
    colibri_pxa300_defconfig: (gcc-8) FAIL
    collie_defconfig: (gcc-8) FAIL
    corgi_defconfig: (gcc-8) FAIL
    davinci_all_defconfig: (gcc-8) FAIL
    dove_defconfig: (gcc-8) FAIL
    ebsa110_defconfig: (gcc-8) FAIL
    em_x270_defconfig: (gcc-8) FAIL
    ep93xx_defconfig: (gcc-8) FAIL
    eseries_pxa_defconfig: (gcc-8) FAIL
    exynos_defconfig: (gcc-8) FAIL
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
    ks8695_defconfig: (gcc-8) FAIL
    lart_defconfig: (gcc-8) FAIL
    lpc32xx_defconfig: (gcc-8) FAIL
    lpd270_defconfig: (gcc-8) FAIL
    lubbock_defconfig: (gcc-8) FAIL
    magician_defconfig: (gcc-8) FAIL
    mainstone_defconfig: (gcc-8) FAIL
    mini2440_defconfig: (gcc-8) FAIL
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
    nuc910_defconfig: (gcc-8) FAIL
    nuc950_defconfig: (gcc-8) FAIL
    nuc960_defconfig: (gcc-8) FAIL
    omap2plus_defconfig: (gcc-8) FAIL
    orion5x_defconfig: (gcc-8) FAIL
    palmz72_defconfig: (gcc-8) FAIL
    pcm027_defconfig: (gcc-8) FAIL
    prima2_defconfig: (gcc-8) FAIL
    pxa168_defconfig: (gcc-8) FAIL
    pxa255-idp_defconfig: (gcc-8) FAIL
    pxa3xx_defconfig: (gcc-8) FAIL
    pxa910_defconfig: (gcc-8) FAIL
    pxa_defconfig: (gcc-8) FAIL
    qcom_defconfig: (gcc-8) FAIL
    raumfeld_defconfig: (gcc-8) FAIL
    realview_defconfig: (gcc-8) FAIL
    rpc_defconfig: (gcc-8) FAIL
    s3c2410_defconfig: (gcc-8) FAIL
    s3c6400_defconfig: (gcc-8) FAIL
    s5pv210_defconfig: (gcc-8) FAIL
    sama5_defconfig: (gcc-8) FAIL
    shannon_defconfig: (gcc-8) FAIL
    shmobile_defconfig: (gcc-8) FAIL
    simpad_defconfig: (gcc-8) FAIL
    socfpga_defconfig: (gcc-8) FAIL
    spear13xx_defconfig: (gcc-8) FAIL
    spear3xx_defconfig: (gcc-8) FAIL
    spear6xx_defconfig: (gcc-8) FAIL
    spitz_defconfig: (gcc-8) FAIL
    sunxi_defconfig: (gcc-8) FAIL
    tegra_defconfig: (gcc-8) FAIL
    trizeps4_defconfig: (gcc-8) FAIL
    u300_defconfig: (gcc-8) FAIL
    u8500_defconfig: (gcc-8) FAIL
    versatile_defconfig: (gcc-8) FAIL
    vexpress_defconfig: (gcc-8) FAIL
    vt8500_v6_v7_defconfig: (gcc-8) FAIL
    zeus_defconfig: (gcc-8) FAIL
    zx_defconfig: (gcc-8) FAIL

i386:
    i386_defconfig: (gcc-8) FAIL

mips:
    32r2el_defconfig: (gcc-8) FAIL
    ar7_defconfig: (gcc-8) FAIL
    ath25_defconfig: (gcc-8) FAIL
    ath79_defconfig: (gcc-8) FAIL
    bcm47xx_defconfig: (gcc-8) FAIL
    bigsur_defconfig: (gcc-8) FAIL
    bmips_be_defconfig: (gcc-8) FAIL
    bmips_stb_defconfig: (gcc-8) FAIL
    capcella_defconfig: (gcc-8) FAIL
    cavium_octeon_defconfig: (gcc-8) FAIL
    ci20_defconfig: (gcc-8) FAIL
    cobalt_defconfig: (gcc-8) FAIL
    db1xxx_defconfig: (gcc-8) FAIL
    decstation_defconfig: (gcc-8) FAIL
    e55_defconfig: (gcc-8) FAIL
    fuloong2e_defconfig: (gcc-8) FAIL
    gpr_defconfig: (gcc-8) FAIL
    ip22_defconfig: (gcc-8) FAIL
    ip27_defconfig: (gcc-8) FAIL
    ip28_defconfig: (gcc-8) FAIL
    ip32_defconfig: (gcc-8) FAIL
    jazz_defconfig: (gcc-8) FAIL
    jmr3927_defconfig: (gcc-8) FAIL
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
    mpc30x_defconfig: (gcc-8) FAIL
    mtx1_defconfig: (gcc-8) FAIL
    nlm_xlp_defconfig: (gcc-8) FAIL
    nlm_xlr_defconfig: (gcc-8) FAIL
    pic32mzda_defconfig: (gcc-8) FAIL
    pistachio_defconfig: (gcc-8) FAIL
    pnx8335_stb225_defconfig: (gcc-8) FAIL
    qi_lb60_defconfig: (gcc-8) FAIL
    rb532_defconfig: (gcc-8) FAIL
    rbtx49xx_defconfig: (gcc-8) FAIL
    rm200_defconfig: (gcc-8) FAIL
    rt305x_defconfig: (gcc-8) FAIL
    sb1250_swarm_defconfig: (gcc-8) FAIL
    tb0219_defconfig: (gcc-8) FAIL
    tb0226_defconfig: (gcc-8) FAIL
    tb0287_defconfig: (gcc-8) FAIL
    workpad_defconfig: (gcc-8) FAIL
    xilfpga_defconfig: (gcc-8) FAIL
    xway_defconfig: (gcc-8) FAIL

x86_64:
    x86_64_defconfig: (gcc-8) FAIL

Errors and Warnings Detected:

arc:
    axs103_defconfig (gcc-8): 1 error, 2 warnings
    axs103_smp_defconfig (gcc-8): 1 error, 2 warnings
    nsim_hs_defconfig (gcc-8): 1 error, 2 warnings
    nsim_hs_smp_defconfig (gcc-8): 1 error, 2 warnings
    nsimosci_hs_defconfig (gcc-8): 1 error, 2 warnings
    nsimosci_hs_smp_defconfig (gcc-8): 1 error, 2 warnings
    vdk_hs38_defconfig (gcc-8): 1 error, 2 warnings
    vdk_hs38_smp_defconfig (gcc-8): 1 error, 2 warnings
    zebu_hs_defconfig (gcc-8): 1 error, 2 warnings
    zebu_hs_smp_defconfig (gcc-8): 1 error, 2 warnings

arm64:
    defconfig (gcc-8): 1 error, 2 warnings

arm:
    acs5k_defconfig (gcc-8): 1 error, 2 warnings
    acs5k_tiny_defconfig (gcc-8): 1 error, 2 warnings
    assabet_defconfig (gcc-8): 1 error, 2 warnings
    at91_dt_defconfig (gcc-8): 1 error, 2 warnings
    axm55xx_defconfig (gcc-8): 1 error, 2 warnings
    badge4_defconfig (gcc-8): 1 error, 2 warnings
    bcm2835_defconfig (gcc-8): 1 error, 2 warnings
    cerfcube_defconfig (gcc-8): 1 error, 2 warnings
    clps711x_defconfig (gcc-8): 1 error, 2 warnings
    cm_x2xx_defconfig (gcc-8): 1 error, 2 warnings
    cm_x300_defconfig (gcc-8): 1 error, 2 warnings
    cns3420vb_defconfig (gcc-8): 1 error, 2 warnings
    colibri_pxa270_defconfig (gcc-8): 1 error, 2 warnings
    colibri_pxa300_defconfig (gcc-8): 1 error, 2 warnings
    collie_defconfig (gcc-8): 1 error, 2 warnings
    corgi_defconfig (gcc-8): 1 error, 2 warnings
    davinci_all_defconfig (gcc-8): 1 error, 2 warnings
    dove_defconfig (gcc-8): 1 error, 2 warnings
    ebsa110_defconfig (gcc-8): 1 error, 2 warnings
    em_x270_defconfig (gcc-8): 1 error, 2 warnings
    ep93xx_defconfig (gcc-8): 1 error, 2 warnings
    eseries_pxa_defconfig (gcc-8): 1 error, 2 warnings
    exynos_defconfig (gcc-8): 1 error, 2 warnings
    ezx_defconfig (gcc-8): 1 error, 2 warnings
    footbridge_defconfig (gcc-8): 1 error, 2 warnings
    h3600_defconfig (gcc-8): 1 error, 2 warnings
    h5000_defconfig (gcc-8): 1 error, 2 warnings
    hackkit_defconfig (gcc-8): 1 error, 2 warnings
    hisi_defconfig (gcc-8): 1 error, 2 warnings
    imote2_defconfig (gcc-8): 1 error, 2 warnings
    imx_v4_v5_defconfig (gcc-8): 1 error, 2 warnings
    imx_v6_v7_defconfig (gcc-8): 1 error, 2 warnings
    integrator_defconfig (gcc-8): 1 error, 2 warnings
    iop13xx_defconfig (gcc-8): 1 error, 2 warnings
    iop32x_defconfig (gcc-8): 1 error, 2 warnings
    iop33x_defconfig (gcc-8): 1 error, 2 warnings
    ixp4xx_defconfig (gcc-8): 1 error, 2 warnings
    jornada720_defconfig (gcc-8): 1 error, 2 warnings
    keystone_defconfig (gcc-8): 1 error, 2 warnings
    ks8695_defconfig (gcc-8): 1 error, 2 warnings
    lart_defconfig (gcc-8): 1 error, 2 warnings
    lpc32xx_defconfig (gcc-8): 1 error, 2 warnings
    lpd270_defconfig (gcc-8): 1 error, 2 warnings
    lubbock_defconfig (gcc-8): 1 error, 2 warnings
    magician_defconfig (gcc-8): 1 error, 2 warnings
    mainstone_defconfig (gcc-8): 1 error, 2 warnings
    mini2440_defconfig (gcc-8): 1 error, 2 warnings
    mmp2_defconfig (gcc-8): 1 error, 2 warnings
    moxart_defconfig (gcc-8): 1 error, 2 warnings
    multi_v4t_defconfig (gcc-8): 1 error, 2 warnings
    multi_v5_defconfig (gcc-8): 1 error, 2 warnings
    multi_v7_defconfig (gcc-8): 1 error, 2 warnings
    mv78xx0_defconfig (gcc-8): 1 error, 2 warnings
    mvebu_v5_defconfig (gcc-8): 1 error, 2 warnings
    mvebu_v7_defconfig (gcc-8): 1 error, 2 warnings
    mxs_defconfig (gcc-8): 1 error, 2 warnings
    neponset_defconfig (gcc-8): 1 error, 2 warnings
    netwinder_defconfig (gcc-8): 1 error, 2 warnings
    netx_defconfig (gcc-8): 1 error, 2 warnings
    nhk8815_defconfig (gcc-8): 1 error, 2 warnings
    nuc910_defconfig (gcc-8): 1 error, 2 warnings
    nuc950_defconfig (gcc-8): 1 error, 2 warnings
    nuc960_defconfig (gcc-8): 1 error, 2 warnings
    omap2plus_defconfig (gcc-8): 1 error, 2 warnings
    orion5x_defconfig (gcc-8): 1 error, 2 warnings
    palmz72_defconfig (gcc-8): 1 error, 2 warnings
    pcm027_defconfig (gcc-8): 1 error, 2 warnings
    prima2_defconfig (gcc-8): 1 error, 2 warnings
    pxa168_defconfig (gcc-8): 1 error, 2 warnings
    pxa255-idp_defconfig (gcc-8): 1 error, 2 warnings
    pxa3xx_defconfig (gcc-8): 1 error, 2 warnings
    pxa910_defconfig (gcc-8): 1 error, 2 warnings
    pxa_defconfig (gcc-8): 1 error, 2 warnings
    qcom_defconfig (gcc-8): 1 error, 2 warnings
    raumfeld_defconfig (gcc-8): 1 error, 2 warnings
    realview_defconfig (gcc-8): 1 error, 2 warnings
    rpc_defconfig (gcc-8): 1 error, 2 warnings
    s3c2410_defconfig (gcc-8): 1 error, 2 warnings
    s3c6400_defconfig (gcc-8): 1 error, 2 warnings
    s5pv210_defconfig (gcc-8): 1 error, 2 warnings
    sama5_defconfig (gcc-8): 1 error, 2 warnings
    shannon_defconfig (gcc-8): 1 error, 2 warnings
    shmobile_defconfig (gcc-8): 1 error, 2 warnings
    simpad_defconfig (gcc-8): 1 error, 2 warnings
    socfpga_defconfig (gcc-8): 1 error, 2 warnings
    spear13xx_defconfig (gcc-8): 1 error, 2 warnings
    spear3xx_defconfig (gcc-8): 1 error, 2 warnings
    spear6xx_defconfig (gcc-8): 1 error, 2 warnings
    spitz_defconfig (gcc-8): 1 error, 2 warnings
    sunxi_defconfig (gcc-8): 1 error, 2 warnings
    tegra_defconfig (gcc-8): 1 error, 2 warnings
    trizeps4_defconfig (gcc-8): 1 error, 2 warnings
    u300_defconfig (gcc-8): 1 error, 2 warnings
    u8500_defconfig (gcc-8): 1 error, 2 warnings
    versatile_defconfig (gcc-8): 1 error, 2 warnings
    vexpress_defconfig (gcc-8): 1 error, 2 warnings
    vt8500_v6_v7_defconfig (gcc-8): 1 error, 2 warnings
    zeus_defconfig (gcc-8): 1 error, 2 warnings
    zx_defconfig (gcc-8): 1 error, 2 warnings

i386:
    i386_defconfig (gcc-8): 1 error, 2 warnings

mips:
    ar7_defconfig (gcc-8): 1 error, 2 warnings
    ath25_defconfig (gcc-8): 1 error, 2 warnings
    ath79_defconfig (gcc-8): 1 error, 2 warnings
    bcm47xx_defconfig (gcc-8): 1 error, 2 warnings
    bigsur_defconfig (gcc-8): 1 error, 2 warnings
    bmips_be_defconfig (gcc-8): 1 error, 2 warnings
    bmips_stb_defconfig (gcc-8): 1 error, 2 warnings
    capcella_defconfig (gcc-8): 1 error, 2 warnings
    cavium_octeon_defconfig (gcc-8): 1 error, 2 warnings
    ci20_defconfig (gcc-8): 1 error, 2 warnings
    cobalt_defconfig (gcc-8): 1 error, 2 warnings
    db1xxx_defconfig (gcc-8): 1 error, 2 warnings
    decstation_defconfig (gcc-8): 1 error, 2 warnings
    e55_defconfig (gcc-8): 1 error, 2 warnings
    fuloong2e_defconfig (gcc-8): 1 error, 2 warnings
    gpr_defconfig (gcc-8): 1 error, 2 warnings
    ip22_defconfig (gcc-8): 1 error, 2 warnings
    ip27_defconfig (gcc-8): 1 error, 2 warnings
    ip28_defconfig (gcc-8): 1 error, 2 warnings
    ip32_defconfig (gcc-8): 1 error, 2 warnings
    jazz_defconfig (gcc-8): 1 error, 2 warnings
    jmr3927_defconfig (gcc-8): 1 error, 2 warnings
    lasat_defconfig (gcc-8): 1 error, 2 warnings
    lemote2f_defconfig (gcc-8): 1 error, 2 warnings
    loongson1b_defconfig (gcc-8): 1 error, 2 warnings
    loongson1c_defconfig (gcc-8): 1 error, 2 warnings
    loongson3_defconfig (gcc-8): 1 error, 2 warnings
    malta_defconfig (gcc-8): 1 error, 2 warnings
    malta_kvm_defconfig (gcc-8): 1 error, 2 warnings
    malta_kvm_guest_defconfig (gcc-8): 1 error, 2 warnings
    malta_qemu_32r6_defconfig (gcc-8): 1 error, 2 warnings
    maltaaprp_defconfig (gcc-8): 1 error, 2 warnings
    maltasmvp_defconfig (gcc-8): 1 error, 2 warnings
    maltasmvp_eva_defconfig (gcc-8): 1 error, 2 warnings
    maltaup_defconfig (gcc-8): 1 error, 2 warnings
    maltaup_xpa_defconfig (gcc-8): 1 error, 2 warnings
    markeins_defconfig (gcc-8): 1 error, 2 warnings
    mips_paravirt_defconfig (gcc-8): 1 error, 2 warnings
    mpc30x_defconfig (gcc-8): 1 error, 2 warnings
    mtx1_defconfig (gcc-8): 1 error, 2 warnings
    nlm_xlp_defconfig (gcc-8): 1 error, 2 warnings
    nlm_xlr_defconfig (gcc-8): 1 error, 2 warnings
    pic32mzda_defconfig (gcc-8): 1 error, 2 warnings
    pistachio_defconfig (gcc-8): 1 error, 2 warnings
    pnx8335_stb225_defconfig (gcc-8): 1 error, 2 warnings
    qi_lb60_defconfig (gcc-8): 1 error, 2 warnings
    rb532_defconfig (gcc-8): 1 error, 2 warnings
    rbtx49xx_defconfig (gcc-8): 1 error, 2 warnings
    rm200_defconfig (gcc-8): 1 error, 2 warnings
    rt305x_defconfig (gcc-8): 1 error, 2 warnings
    sb1250_swarm_defconfig (gcc-8): 1 error, 2 warnings
    tb0219_defconfig (gcc-8): 1 error, 2 warnings
    tb0226_defconfig (gcc-8): 1 error, 2 warnings
    tb0287_defconfig (gcc-8): 1 error, 2 warnings
    workpad_defconfig (gcc-8): 1 error, 2 warnings
    xilfpga_defconfig (gcc-8): 1 error, 2 warnings
    xway_defconfig (gcc-8): 1 error, 2 warnings

x86_64:
    x86_64_defconfig (gcc-8): 1 error, 2 warnings

Errors summary:

    169  mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=
=98maybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declarati=
on]

Warnings summary:

    169  mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=
=E2=80=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a c=
ast [-Wint-conversion]
    169  cc1: some warnings being treated as errors

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
acs5k_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 se=
ction mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section =
mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section m=
ismatches

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

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
am200epdkit_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 =
section mismatches

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section =
mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

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
assabet_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 se=
ction mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sec=
tion mismatches

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 se=
ction mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, =
0 section mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, =
0 section mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, =
0 section mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 s=
ection mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 s=
ection mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section mis=
matches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section =
mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section =
mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 s=
ection mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section m=
ismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 se=
ction mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 se=
ction mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section =
mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section =
mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 se=
ction mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 se=
ction mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section =
mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 s=
ection mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 s=
ection mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 se=
ction mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 se=
ction mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings=
, 0 section mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings=
, 0 section mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 se=
ction mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 se=
ction mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, =
0 section mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 =
section mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, =
0 section mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section =
mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

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
mtx1_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section m=
ismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
netx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section =
mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 s=
ection mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 s=
ection mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings,=
 0 section mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nuc910_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nuc960_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 se=
ction mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 se=
ction mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings,=
 0 section mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 se=
ction mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section m=
ismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section =
mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section m=
ismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0=
 section mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sectio=
n mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 s=
ection mismatches

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

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
tinyconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section =
mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 =
section mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vf610m4_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 =
section mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sec=
tion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
xilfpga_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 sect=
ion mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section=
 mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
zebu_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 secti=
on mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
zebu_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 s=
ection mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section =
mismatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 1 error, 2 warnings, 0 section mi=
smatches

Errors:
    mm/shmem.c:1933:11: error: implicit declaration of function =E2=80=98ma=
ybe_unlock_mmap_for_io=E2=80=99 [-Werror=3Dimplicit-function-declaration]

Warnings:
    mm/shmem.c:1933:9: warning: assignment to =E2=80=98struct file *=E2=80=
=99 from =E2=80=98int=E2=80=99 makes pointer from integer without a cast [-=
Wint-conversion]
    cc1: some warnings being treated as errors

---
For more info write to <info@kernelci.org>
