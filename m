Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 154961219FE
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 20:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbfLPTdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 14:33:21 -0500
Received: from mail-wr1-f53.google.com ([209.85.221.53]:33161 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbfLPTdV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 14:33:21 -0500
Received: by mail-wr1-f53.google.com with SMTP id b6so8751584wrq.0
        for <stable@vger.kernel.org>; Mon, 16 Dec 2019 11:33:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3rFQ3V1JyjhzK/FNhp9Vbf0G3vBAShrjiAYynp1WPPc=;
        b=k5CiqcLwQsXHHH3drITuZ9aKY6s39ucqvVXU/zDb7NcIvPXyPQ037zExhEfGdfel9a
         rTxXtqjfDp14iRf84Tl+bt9CzDe8lmbrd/qGtSYRDbMsmGZXpyM+MSJifgsuLdG3u+SO
         rkYJ0YTJ4zKvXG2jHkvuqxVCTbY5AE+aAhGF7Pckj9mf7M05PAs7XJlVXMCBYbYmyvUQ
         XqtGJqoU/XPGVSirvDDdhSpF41X4fY9N4+Sy2Asn72oJI8WZq9HbJ401Lz7CZQGRQxqU
         Lzru3pnZvmbCR4oK2/HgdSYEDiOHJgSFB6SDvGSBj0jIUrxUgF8o+nKD2WTKnzhGp2tA
         i5JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3rFQ3V1JyjhzK/FNhp9Vbf0G3vBAShrjiAYynp1WPPc=;
        b=SSk5yn7WcgWGseYso8aUzv1rxBkHNoOt0YSIcykqehH9Wi5v87o29HtxOvzAF89tfJ
         NMjapwvL/PKbDbx6ZCxV1cxyWrl5P4cwJUrgRj6UqHk8RIe7c29ieHLz2Zv9dJ/5Ylje
         ddLtirxI5g8XJdkzI9KLECkTKtg2nOE+y7cP1o2zLl30KozFZOddPqXn7bAiHXu4b/XP
         xc206IEMMi5ylziu0IZGGjkIE5HahcM6kIA6uA38FjWLofBQ3cS0jWspRQXfdJTjpRMA
         Gn7HUvhfd8ckwr+mR7wg5F312u8MlXCRthbjnw1PlKCRoW/zuKcm1TKlW+HXRa6rOwUl
         jq+Q==
X-Gm-Message-State: APjAAAX1umT0QstRdycCimO+nG/2j4FfIJWnU5ofeKUvyZKijPv+G9Fa
        V6lGfLBW5/OfE0Ta0ZyYY9iznel82tE=
X-Google-Smtp-Source: APXvYqyhKJxTGjIrd+qT9i4DMujlp7uHMb891z9xI8PhgN/G0hq6zKxjH/pqsYvubR5e+hhLaZXOmA==
X-Received: by 2002:adf:dc8d:: with SMTP id r13mr33625445wrj.357.1576524789685;
        Mon, 16 Dec 2019 11:33:09 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y7sm728665wmd.1.2019.12.16.11.33.07
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 11:33:07 -0800 (PST)
Message-ID: <5df7dbf3.1c69fb81.721f4.4f2d@mx.google.com>
Date:   Mon, 16 Dec 2019 11:33:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: build
X-Kernelci-Kernel: v4.14.158-268-gb5ad3dcc64ef
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y build: 201 builds: 195 failed, 6 passed,
 390 errors, 196 warnings (v4.14.158-268-gb5ad3dcc64ef)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y build: 201 builds: 195 failed, 6 passed, 390 errors,=
 196 warnings (v4.14.158-268-gb5ad3dcc64ef)

Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.158-268-gb5ad3dcc64ef/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.158-268-gb5ad3dcc64ef
Git Commit: b5ad3dcc64ef682d96b28afb6a66ce8136cbb92f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Built: 6 unique architectures

Build Failures Detected:

arc:
    allnoconfig: (gcc-8) FAIL
    axs103_defconfig: (gcc-8) FAIL
    axs103_smp_defconfig: (gcc-8) FAIL
    haps_hs_defconfig: (gcc-8) FAIL
    haps_hs_smp_defconfig: (gcc-8) FAIL
    hsdk_defconfig: (gcc-8) FAIL
    nsim_hs_defconfig: (gcc-8) FAIL
    nsim_hs_smp_defconfig: (gcc-8) FAIL
    nsimosci_hs_defconfig: (gcc-8) FAIL
    nsimosci_hs_smp_defconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL
    vdk_hs38_defconfig: (gcc-8) FAIL
    vdk_hs38_smp_defconfig: (gcc-8) FAIL

arm64:
    allnoconfig: (gcc-8) FAIL
    defconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL

arm:
    acs5k_defconfig: (gcc-8) FAIL
    acs5k_tiny_defconfig: (gcc-8) FAIL
    am200epdkit_defconfig: (gcc-8) FAIL
    aspeed_g4_defconfig: (gcc-8) FAIL
    aspeed_g5_defconfig: (gcc-8) FAIL
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
    gemini_defconfig: (gcc-8) FAIL
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
    omap1_defconfig: (gcc-8) FAIL
    omap2plus_defconfig: (gcc-8) FAIL
    orion5x_defconfig: (gcc-8) FAIL
    palmz72_defconfig: (gcc-8) FAIL
    pcm027_defconfig: (gcc-8) FAIL
    pleb_defconfig: (gcc-8) FAIL
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
    tango4_defconfig: (gcc-8) FAIL
    tct_hammer_defconfig: (gcc-8) FAIL
    tegra_defconfig: (gcc-8) FAIL
    trizeps4_defconfig: (gcc-8) FAIL
    u300_defconfig: (gcc-8) FAIL
    u8500_defconfig: (gcc-8) FAIL
    versatile_defconfig: (gcc-8) FAIL
    vexpress_defconfig: (gcc-8) FAIL
    viper_defconfig: (gcc-8) FAIL
    vt8500_v6_v7_defconfig: (gcc-8) FAIL
    xcep_defconfig: (gcc-8) FAIL
    zeus_defconfig: (gcc-8) FAIL
    zx_defconfig: (gcc-8) FAIL

i386:
    allnoconfig: (gcc-8) FAIL
    i386_defconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL

mips:
    32r2el_defconfig: (gcc-8) FAIL
    allnoconfig: (gcc-8) FAIL
    ar7_defconfig: (gcc-8) FAIL
    ath25_defconfig: (gcc-8) FAIL
    ath79_defconfig: (gcc-8) FAIL
    bcm47xx_defconfig: (gcc-8) FAIL
    bcm63xx_defconfig: (gcc-8) FAIL
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
    msp71xx_defconfig: (gcc-8) FAIL
    mtx1_defconfig: (gcc-8) FAIL
    nlm_xlp_defconfig: (gcc-8) FAIL
    nlm_xlr_defconfig: (gcc-8) FAIL
    omega2p_defconfig: (gcc-8) FAIL
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
    tinyconfig: (gcc-8) FAIL
    vocore2_defconfig: (gcc-8) FAIL
    workpad_defconfig: (gcc-8) FAIL
    xilfpga_defconfig: (gcc-8) FAIL
    xway_defconfig: (gcc-8) FAIL

x86_64:
    allnoconfig: (gcc-8) FAIL
    tinyconfig: (gcc-8) FAIL
    x86_64_defconfig: (gcc-8) FAIL

Errors and Warnings Detected:

arc:
    allnoconfig (gcc-8): 2 errors, 1 warning
    axs103_defconfig (gcc-8): 2 errors, 1 warning
    axs103_smp_defconfig (gcc-8): 2 errors, 1 warning
    haps_hs_defconfig (gcc-8): 2 errors, 1 warning
    haps_hs_smp_defconfig (gcc-8): 2 errors, 1 warning
    hsdk_defconfig (gcc-8): 2 errors, 1 warning
    nsim_hs_defconfig (gcc-8): 2 errors, 1 warning
    nsim_hs_smp_defconfig (gcc-8): 2 errors, 1 warning
    nsimosci_hs_defconfig (gcc-8): 2 errors, 1 warning
    nsimosci_hs_smp_defconfig (gcc-8): 2 errors, 1 warning
    tinyconfig (gcc-8): 2 errors, 1 warning
    vdk_hs38_defconfig (gcc-8): 2 errors, 1 warning
    vdk_hs38_smp_defconfig (gcc-8): 2 errors, 1 warning

arm64:
    allnoconfig (gcc-8): 2 errors, 1 warning
    defconfig (gcc-8): 2 errors, 1 warning
    tinyconfig (gcc-8): 2 errors, 1 warning

arm:
    acs5k_defconfig (gcc-8): 2 errors, 1 warning
    acs5k_tiny_defconfig (gcc-8): 2 errors, 1 warning
    am200epdkit_defconfig (gcc-8): 2 errors, 1 warning
    aspeed_g4_defconfig (gcc-8): 2 errors, 1 warning
    aspeed_g5_defconfig (gcc-8): 2 errors, 1 warning
    assabet_defconfig (gcc-8): 2 errors, 1 warning
    at91_dt_defconfig (gcc-8): 2 errors, 1 warning
    axm55xx_defconfig (gcc-8): 2 errors, 1 warning
    badge4_defconfig (gcc-8): 2 errors, 1 warning
    bcm2835_defconfig (gcc-8): 2 errors, 1 warning
    cerfcube_defconfig (gcc-8): 2 errors, 1 warning
    clps711x_defconfig (gcc-8): 2 errors, 1 warning
    cm_x2xx_defconfig (gcc-8): 2 errors, 1 warning
    cm_x300_defconfig (gcc-8): 2 errors, 1 warning
    cns3420vb_defconfig (gcc-8): 2 errors, 1 warning
    colibri_pxa270_defconfig (gcc-8): 2 errors, 1 warning
    colibri_pxa300_defconfig (gcc-8): 2 errors, 1 warning
    collie_defconfig (gcc-8): 2 errors, 1 warning
    corgi_defconfig (gcc-8): 2 errors, 1 warning
    davinci_all_defconfig (gcc-8): 2 errors, 1 warning
    dove_defconfig (gcc-8): 2 errors, 1 warning
    ebsa110_defconfig (gcc-8): 2 errors, 1 warning
    em_x270_defconfig (gcc-8): 2 errors, 1 warning
    ep93xx_defconfig (gcc-8): 2 errors, 1 warning
    eseries_pxa_defconfig (gcc-8): 2 errors, 1 warning
    exynos_defconfig (gcc-8): 2 errors, 1 warning
    ezx_defconfig (gcc-8): 2 errors, 1 warning
    footbridge_defconfig (gcc-8): 2 errors, 1 warning
    gemini_defconfig (gcc-8): 2 errors, 1 warning
    h3600_defconfig (gcc-8): 2 errors, 1 warning
    h5000_defconfig (gcc-8): 2 errors, 1 warning
    hackkit_defconfig (gcc-8): 2 errors, 1 warning
    hisi_defconfig (gcc-8): 2 errors, 1 warning
    imote2_defconfig (gcc-8): 2 errors, 1 warning
    imx_v4_v5_defconfig (gcc-8): 2 errors, 1 warning
    imx_v6_v7_defconfig (gcc-8): 2 errors, 1 warning
    integrator_defconfig (gcc-8): 2 errors, 1 warning
    iop13xx_defconfig (gcc-8): 2 errors, 1 warning
    iop32x_defconfig (gcc-8): 2 errors, 1 warning
    iop33x_defconfig (gcc-8): 2 errors, 1 warning
    ixp4xx_defconfig (gcc-8): 2 errors, 1 warning
    jornada720_defconfig (gcc-8): 2 errors, 1 warning
    keystone_defconfig (gcc-8): 2 errors, 1 warning
    ks8695_defconfig (gcc-8): 2 errors, 1 warning
    lart_defconfig (gcc-8): 2 errors, 1 warning
    lpc32xx_defconfig (gcc-8): 2 errors, 1 warning
    lpd270_defconfig (gcc-8): 2 errors, 1 warning
    lubbock_defconfig (gcc-8): 2 errors, 1 warning
    magician_defconfig (gcc-8): 2 errors, 1 warning
    mainstone_defconfig (gcc-8): 2 errors, 1 warning
    mini2440_defconfig (gcc-8): 2 errors, 1 warning
    mmp2_defconfig (gcc-8): 2 errors, 1 warning
    moxart_defconfig (gcc-8): 2 errors, 1 warning
    multi_v4t_defconfig (gcc-8): 2 errors, 1 warning
    multi_v5_defconfig (gcc-8): 2 errors, 1 warning
    multi_v7_defconfig (gcc-8): 2 errors, 1 warning
    mv78xx0_defconfig (gcc-8): 2 errors, 1 warning
    mvebu_v5_defconfig (gcc-8): 2 errors, 1 warning
    mvebu_v7_defconfig (gcc-8): 2 errors, 1 warning
    mxs_defconfig (gcc-8): 2 errors, 1 warning
    neponset_defconfig (gcc-8): 2 errors, 1 warning
    netwinder_defconfig (gcc-8): 2 errors, 1 warning
    netx_defconfig (gcc-8): 2 errors, 1 warning
    nhk8815_defconfig (gcc-8): 2 errors, 1 warning
    nuc910_defconfig (gcc-8): 2 errors, 1 warning
    nuc950_defconfig (gcc-8): 2 errors, 1 warning
    nuc960_defconfig (gcc-8): 2 errors, 1 warning
    omap1_defconfig (gcc-8): 2 errors, 1 warning
    omap2plus_defconfig (gcc-8): 2 errors, 1 warning
    orion5x_defconfig (gcc-8): 2 errors, 1 warning
    palmz72_defconfig (gcc-8): 2 errors, 1 warning
    pcm027_defconfig (gcc-8): 2 errors, 1 warning
    pleb_defconfig (gcc-8): 2 errors, 1 warning
    prima2_defconfig (gcc-8): 2 errors, 1 warning
    pxa168_defconfig (gcc-8): 2 errors, 1 warning
    pxa255-idp_defconfig (gcc-8): 2 errors, 1 warning
    pxa3xx_defconfig (gcc-8): 2 errors, 1 warning
    pxa910_defconfig (gcc-8): 2 errors, 1 warning
    pxa_defconfig (gcc-8): 2 errors, 1 warning
    qcom_defconfig (gcc-8): 2 errors, 1 warning
    raumfeld_defconfig (gcc-8): 2 errors, 1 warning
    realview_defconfig (gcc-8): 2 errors, 1 warning
    rpc_defconfig (gcc-8): 2 errors, 1 warning
    s3c2410_defconfig (gcc-8): 2 errors, 1 warning
    s3c6400_defconfig (gcc-8): 2 errors, 1 warning
    s5pv210_defconfig (gcc-8): 2 errors, 1 warning
    sama5_defconfig (gcc-8): 2 errors, 1 warning
    shannon_defconfig (gcc-8): 2 errors, 1 warning
    shmobile_defconfig (gcc-8): 2 errors, 1 warning
    simpad_defconfig (gcc-8): 2 errors, 1 warning
    socfpga_defconfig (gcc-8): 2 errors, 1 warning
    spear13xx_defconfig (gcc-8): 2 errors, 1 warning
    spear3xx_defconfig (gcc-8): 2 errors, 1 warning
    spear6xx_defconfig (gcc-8): 2 errors, 1 warning
    spitz_defconfig (gcc-8): 2 errors, 1 warning
    sunxi_defconfig (gcc-8): 2 errors, 1 warning
    tango4_defconfig (gcc-8): 2 errors, 1 warning
    tct_hammer_defconfig (gcc-8): 2 errors, 1 warning
    tegra_defconfig (gcc-8): 2 errors, 1 warning
    trizeps4_defconfig (gcc-8): 2 errors, 1 warning
    u300_defconfig (gcc-8): 2 errors, 1 warning
    u8500_defconfig (gcc-8): 2 errors, 1 warning
    versatile_defconfig (gcc-8): 2 errors, 1 warning
    vexpress_defconfig (gcc-8): 2 errors, 1 warning
    viper_defconfig (gcc-8): 2 errors, 1 warning
    vt8500_v6_v7_defconfig (gcc-8): 2 errors, 1 warning
    xcep_defconfig (gcc-8): 2 errors, 1 warning
    zeus_defconfig (gcc-8): 2 errors, 1 warning
    zx_defconfig (gcc-8): 2 errors, 1 warning

i386:
    allnoconfig (gcc-8): 2 errors, 1 warning
    i386_defconfig (gcc-8): 2 errors, 1 warning
    tinyconfig (gcc-8): 2 errors, 1 warning

mips:
    32r2el_defconfig (gcc-8): 2 errors, 1 warning
    allnoconfig (gcc-8): 2 errors, 1 warning
    ar7_defconfig (gcc-8): 2 errors, 1 warning
    ath25_defconfig (gcc-8): 2 errors, 1 warning
    ath79_defconfig (gcc-8): 2 errors, 1 warning
    bcm47xx_defconfig (gcc-8): 2 errors, 1 warning
    bcm63xx_defconfig (gcc-8): 2 errors, 1 warning
    bigsur_defconfig (gcc-8): 2 errors, 1 warning
    bmips_be_defconfig (gcc-8): 2 errors, 1 warning
    bmips_stb_defconfig (gcc-8): 2 errors, 1 warning
    capcella_defconfig (gcc-8): 2 errors, 1 warning
    cavium_octeon_defconfig (gcc-8): 2 errors, 1 warning
    ci20_defconfig (gcc-8): 2 errors, 1 warning
    cobalt_defconfig (gcc-8): 2 errors, 1 warning
    db1xxx_defconfig (gcc-8): 2 errors, 1 warning
    decstation_defconfig (gcc-8): 2 errors, 1 warning
    e55_defconfig (gcc-8): 2 errors, 1 warning
    fuloong2e_defconfig (gcc-8): 2 errors, 1 warning
    gpr_defconfig (gcc-8): 2 errors, 1 warning
    ip22_defconfig (gcc-8): 2 errors, 1 warning
    ip27_defconfig (gcc-8): 2 errors, 1 warning
    ip28_defconfig (gcc-8): 2 errors, 1 warning
    ip32_defconfig (gcc-8): 2 errors, 1 warning
    jazz_defconfig (gcc-8): 2 errors, 1 warning
    jmr3927_defconfig (gcc-8): 2 errors, 1 warning
    lasat_defconfig (gcc-8): 2 errors, 1 warning
    lemote2f_defconfig (gcc-8): 2 errors, 1 warning
    loongson1b_defconfig (gcc-8): 2 errors, 1 warning
    loongson1c_defconfig (gcc-8): 2 errors, 1 warning
    loongson3_defconfig (gcc-8): 2 errors, 1 warning
    malta_defconfig (gcc-8): 2 errors, 1 warning
    malta_kvm_defconfig (gcc-8): 2 errors, 1 warning
    malta_kvm_guest_defconfig (gcc-8): 2 errors, 1 warning
    malta_qemu_32r6_defconfig (gcc-8): 2 errors, 1 warning
    maltaaprp_defconfig (gcc-8): 2 errors, 1 warning
    maltasmvp_defconfig (gcc-8): 2 errors, 1 warning
    maltasmvp_eva_defconfig (gcc-8): 2 errors, 1 warning
    maltaup_defconfig (gcc-8): 2 errors, 1 warning
    maltaup_xpa_defconfig (gcc-8): 2 errors, 1 warning
    markeins_defconfig (gcc-8): 2 errors, 1 warning
    mips_paravirt_defconfig (gcc-8): 2 errors, 1 warning
    mpc30x_defconfig (gcc-8): 2 errors, 1 warning
    msp71xx_defconfig (gcc-8): 2 errors, 1 warning
    mtx1_defconfig (gcc-8): 2 errors, 1 warning
    nlm_xlp_defconfig (gcc-8): 2 errors, 1 warning
    nlm_xlr_defconfig (gcc-8): 2 errors, 1 warning
    omega2p_defconfig (gcc-8): 2 errors, 1 warning
    pic32mzda_defconfig (gcc-8): 2 errors, 1 warning
    pistachio_defconfig (gcc-8): 2 errors, 1 warning
    pnx8335_stb225_defconfig (gcc-8): 2 errors, 1 warning
    qi_lb60_defconfig (gcc-8): 2 errors, 1 warning
    rb532_defconfig (gcc-8): 2 errors, 1 warning
    rbtx49xx_defconfig (gcc-8): 2 errors, 1 warning
    rm200_defconfig (gcc-8): 2 errors, 1 warning
    rt305x_defconfig (gcc-8): 2 errors, 1 warning
    sb1250_swarm_defconfig (gcc-8): 2 errors, 1 warning
    tb0219_defconfig (gcc-8): 2 errors, 1 warning
    tb0226_defconfig (gcc-8): 2 errors, 1 warning
    tb0287_defconfig (gcc-8): 2 errors, 1 warning
    tinyconfig (gcc-8): 2 errors, 1 warning
    vocore2_defconfig (gcc-8): 2 errors, 1 warning
    workpad_defconfig (gcc-8): 2 errors, 1 warning
    xilfpga_defconfig (gcc-8): 2 errors, 1 warning
    xway_defconfig (gcc-8): 2 errors, 1 warning

x86_64:
    allnoconfig (gcc-8): 2 errors, 1 warning
    tinyconfig (gcc-8): 2 errors, 2 warnings
    x86_64_defconfig (gcc-8): 2 errors, 1 warning

Errors summary:

    195  include/linux/mm.h:438:19: error: static declaration of =E2=80=98p=
ud_devmap=E2=80=99 follows non-static declaration
    189  include/asm-generic/pgtable.h:854:52: error: implicit declaration =
of function =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]
    3    include/asm-generic/pgtable.h:854:52: error: implicit declaration =
of function =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_mkdevma=
p=E2=80=99? [-Werror=3Dimplicit-function-declaration]
    3    include/asm-generic/pgtable.h:854:52: error: implicit declaration =
of function =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pte_devmap=
=E2=80=99? [-Werror=3Dimplicit-function-declaration]

Warnings summary:

    195  cc1: some warnings being treated as errors
    1    .config:1027:warning: override: UNWINDER_GUESS changes choice state

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D

Detailed per-defconfig build reports:

---------------------------------------------------------------------------=
-----
32r2el_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
acs5k_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
acs5k_tiny_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section mis=
matches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (x86_64, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pte_devmap=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section mi=
smatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (i386, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section mi=
smatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_mkdevmap=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
allnoconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mi=
smatches

---------------------------------------------------------------------------=
-----
allnoconfig (arm64, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section m=
ismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
am200epdkit_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ar7_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
aspeed_g4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
aspeed_g5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
assabet_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
at91_dt_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ath25_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ath79_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
axm55xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
axs103_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
axs103_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
badge4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bcm2835_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bcm47xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bcm63xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bigsur_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bmips_be_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
bmips_stb_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
capcella_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cavium_octeon_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, =
0 section mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cerfcube_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ci20_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
clps711x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cm_x2xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cm_x300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cns3420vb_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
cobalt_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
colibri_pxa270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, =
0 section mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
colibri_pxa300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, =
0 section mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
collie_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
corgi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
davinci_all_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
db1xxx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
decstation_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
defconfig (arm64, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section mis=
matches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
dove_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
e55_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ebsa110_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
efm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
em_x270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ep93xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
eseries_pxa_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
exynos_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ezx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section m=
ismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
footbridge_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
fuloong2e_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
gemini_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
gpr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
h3600_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
h5000_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
hackkit_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
haps_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
haps_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
hisi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
hsdk_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
i386_defconfig (i386, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_mkdevmap=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
imote2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
imx_v4_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
imx_v6_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
integrator_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
iop13xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
iop32x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
iop33x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip22_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip27_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip28_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ip32_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ixp4xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
jazz_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
jmr3927_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
jornada720_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
keystone_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
ks8695_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lart_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lasat_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lemote2f_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson1b_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson1c_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
loongson3_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lpc18xx_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sect=
ion mismatches

---------------------------------------------------------------------------=
-----
lpc32xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lpd270_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
lubbock_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
magician_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mainstone_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_kvm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_kvm_guest_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning=
, 0 section mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
malta_qemu_32r6_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning=
, 0 section mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaaprp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltasmvp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltasmvp_eva_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, =
0 section mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaup_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
maltaup_xpa_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 =
section mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
markeins_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mini2440_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mips_paravirt_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, =
0 section mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mmp2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
moxart_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mpc30x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mps2_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section=
 mismatches

---------------------------------------------------------------------------=
-----
msp71xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mtx1_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
multi_v4t_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
multi_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
multi_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mv78xx0_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mvebu_v5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mvebu_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
mxs_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section m=
ismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
neponset_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
netwinder_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
netx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nhk8815_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nlm_xlp_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nlm_xlr_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsim_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsim_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsimosci_hs_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 s=
ection mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nsimosci_hs_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning,=
 0 section mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nuc910_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nuc950_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
nuc960_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
omap1_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
omap2plus_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
omega2p_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
orion5x_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
palmz72_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pcm027_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pic32mzda_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pistachio_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pleb_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pnx8335_stb225_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning,=
 0 section mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
prima2_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa168_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa255-idp_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa3xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa910_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
pxa_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section m=
ismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
qcom_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
qi_lb60_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
raumfeld_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rb532_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rbtx49xx_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
realview_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rm200_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rpc_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section m=
ismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
rt305x_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
s3c2410_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
s3c6400_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
s5pv210_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
sama5_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
sb1250_swarm_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0=
 section mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
shannon_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
shmobile_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
simpad_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
socfpga_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
spear13xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
spear3xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
spear6xx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
spitz_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
stm32_defconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 sectio=
n mismatches

---------------------------------------------------------------------------=
-----
sunxi_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tango4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sectio=
n mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tb0219_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tb0226_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tb0287_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 secti=
on mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tct_hammer_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 se=
ction mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tegra_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section mis=
matches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (i386, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section mis=
matches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_mkdevmap=E2=
=80=99? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section mism=
atches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (arm, gcc-8) =E2=80=94 PASS, 0 errors, 0 warnings, 0 section mis=
matches

---------------------------------------------------------------------------=
-----
tinyconfig (x86_64, gcc-8) =E2=80=94 FAIL, 2 errors, 2 warnings, 0 section =
mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pte_devmap=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    .config:1027:warning: override: UNWINDER_GUESS changes choice state
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
tinyconfig (arm64, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section mi=
smatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
trizeps4_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
u300_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
u8500_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vdk_hs38_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vdk_hs38_smp_defconfig (arc, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 =
section mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
versatile_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vexpress_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
viper_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vocore2_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
vt8500_v6_v7_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 =
section mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
workpad_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
x86_64_defconfig (x86_64, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sec=
tion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pte_devmap=E2=80=
=99? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
xcep_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
xilfpga_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 sect=
ion mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
xway_defconfig (mips, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section=
 mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
zeus_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section =
mismatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---------------------------------------------------------------------------=
-----
zx_defconfig (arm, gcc-8) =E2=80=94 FAIL, 2 errors, 1 warning, 0 section mi=
smatches

Errors:
    include/asm-generic/pgtable.h:854:52: error: implicit declaration of fu=
nction =E2=80=98pud_devmap=E2=80=99; did you mean =E2=80=98pud_val=E2=80=99=
? [-Werror=3Dimplicit-function-declaration]
    include/linux/mm.h:438:19: error: static declaration of =E2=80=98pud_de=
vmap=E2=80=99 follows non-static declaration

Warnings:
    cc1: some warnings being treated as errors

---
For more info write to <info@kernelci.org>
