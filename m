Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E996F8348
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 00:13:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfKKXNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 18:13:41 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34400 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfKKXNl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 18:13:41 -0500
Received: by mail-wr1-f68.google.com with SMTP id e6so16533204wrw.1
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 15:13:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jy5OAAqO9jydb3iNWTvuxDjoTHKLlnaa8GD8zIYTqus=;
        b=V6BpyaSeptuxn42boHLj86T2YSm6fdz2/tWxh4JkN/73xPLR48fyNwFCrnlx2hc7Ym
         RTQfRNrsFNqRoA7yVI9GCqaESD5Whyv3a4qcQz4bCyOD2mub9LL2efXknxvIbMGFYGbx
         ajKW6teficrEd4Ui2uWD61PEf6ywDC9rO+TvqUcpVhkh+3ZUVqQV4u9/am96bnBDdOs3
         EWCsOsNN7wZyQSDuTOJdIDPdYDMFhp646gQTCgxkLvRY+hTWr8Ua65Q78IfgXjSC12t+
         6VQ9ScdpusUY212zM6wUiL3MtYNOGTypOYVmOevUNqZDxAEDSUF76LMZQWgH5xfK8dgI
         AJyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jy5OAAqO9jydb3iNWTvuxDjoTHKLlnaa8GD8zIYTqus=;
        b=QZQmlhunmD2cT3Bk3U2h7zBGH6cCn7Zdrqfn0f41v386CP+lIMNO9p11m7m2nVuOLE
         bdd4k+pK8s6srBMkIWtgAT19A97CRd2QLceoattFgeuHU4CHGMCFFJkLBcgoEWDQLqjU
         eIt20gSKwG+Ax87DL0Thw0gA8oUbl/CQCs3I0GWQZLieTR56Qcu48Aor/ZmV1w58g9yK
         FW/YDNwpuV76O4ZHPol0LTWAukaTxJ5QNyLWs9M8017pXgSlrx2phCdMihJh1D8PISMj
         hWRfrnj+UNZ2gjqhyVU6kXJaKCzfKv/0O9TWRVHFDaSxe6vyvo+ip8oVLSaSlCyR8lAl
         6+zg==
X-Gm-Message-State: APjAAAV5hCoHF77YFDUPyUMei8dAZDKb85kQXSCeImtoMwHpoHa1KtbV
        Ujy/X1AmuV3FenlytXkTRgQwfppXmLariQ==
X-Google-Smtp-Source: APXvYqynfoyoB3NupRDBeriC3e4pewF6kK8uN0Cnox2yfi95yIO9mxiV3lAZstRWP8qtDelXBLlrXw==
X-Received: by 2002:adf:f585:: with SMTP id f5mr22579967wro.272.1573514016469;
        Mon, 11 Nov 2019 15:13:36 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id x7sm44834376wrg.63.2019.11.11.15.13.35
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 15:13:35 -0800 (PST)
Message-ID: <5dc9eb1f.1c69fb81.f357e.6344@mx.google.com>
Date:   Mon, 11 Nov 2019 15:13:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.153-104-ga67492b55c53
Subject: stable-rc/linux-4.14.y boot: 59 boots: 59 failed,
 0 passed (v4.14.153-104-ga67492b55c53)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 59 boots: 59 failed, 0 passed (v4.14.153-104-g=
a67492b55c53)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.153-104-ga67492b55c53/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.153-104-ga67492b55c53/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.153-104-ga67492b55c53
Git Commit: a67492b55c53045e9c0b9969f04410723448c1ee
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 31 unique boards, 12 SoC families, 9 builds out of 201

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2836-rpi-2-b:
              lab-collabora: failing since 1 day (last pass: v4.14.153 - fi=
rst fail: v4.14.153-40-gf7fb2676f8a6)
          bcm2837-rpi-3-b:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)

    exynos_defconfig:
        gcc-8:
          exynos4412-odroidx2:
              lab-collabora: failing since 1 day (last pass: v4.14.153 - fi=
rst fail: v4.14.153-40-gf7fb2676f8a6)
          exynos5800-peach-pi:
              lab-collabora: failing since 1 day (last pass: v4.14.153 - fi=
rst fail: v4.14.153-40-gf7fb2676f8a6)

    multi_v7_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-baylibre: failing since 1 day (last pass: v4.14.151 - fir=
st fail: v4.14.153-68-g0d12dcf336c6)
          bcm2836-rpi-2-b:
              lab-collabora: failing since 1 day (last pass: v4.14.153 - fi=
rst fail: v4.14.153-40-gf7fb2676f8a6)
          exynos4412-odroidx2:
              lab-collabora: failing since 1 day (last pass: v4.14.153 - fi=
rst fail: v4.14.153-40-gf7fb2676f8a6)
          exynos5800-peach-pi:
              lab-collabora: failing since 1 day (last pass: v4.14.153 - fi=
rst fail: v4.14.153-40-gf7fb2676f8a6)
          imx6q-sabrelite:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          meson8b-odroidc1:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          omap4-panda:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          rk3288-rock2-square:
              lab-collabora: failing since 1 day (last pass: v4.14.153 - fi=
rst fail: v4.14.153-40-gf7fb2676f8a6)
          rk3288-veyron-jaq:
              lab-collabora: failing since 1 day (last pass: v4.14.153 - fi=
rst fail: v4.14.153-40-gf7fb2676f8a6)
          sun5i-a13-olinuxino-micro:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          sun7i-a20-cubieboard2:
              lab-clabbe: failing since 1 day (last pass: v4.14.153 - first=
 fail: v4.14.153-40-gf7fb2676f8a6)
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          sun8i-h2-plus-orangepi-zero:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          tegra124-jetson-tk1:
              lab-collabora: failing since 1 day (last pass: v4.14.153 - fi=
rst fail: v4.14.153-40-gf7fb2676f8a6)
          tegra124-nyan-big:
              lab-collabora: failing since 1 day (last pass: v4.14.153 - fi=
rst fail: v4.14.153-40-gf7fb2676f8a6)

    omap2plus_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-baylibre: failing since 1 day (last pass: v4.14.151 - fir=
st fail: v4.14.153-68-g0d12dcf336c6)
          omap4-panda:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)

    sunxi_defconfig:
        gcc-8:
          sun5i-a13-olinuxino-micro:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          sun7i-a20-cubieboard2:
              lab-clabbe: failing since 1 day (last pass: v4.14.153 - first=
 fail: v4.14.153-40-gf7fb2676f8a6)
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          sun8i-a33-olinuxino:
              lab-clabbe: failing since 1 day (last pass: v4.14.153 - first=
 fail: v4.14.153-40-gf7fb2676f8a6)
          sun8i-h2-plus-orangepi-zero:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)

    tegra_defconfig:
        gcc-8:
          tegra124-jetson-tk1:
              lab-collabora: failing since 1 day (last pass: v4.14.153 - fi=
rst fail: v4.14.153-40-gf7fb2676f8a6)
          tegra124-nyan-big:
              lab-collabora: failing since 1 day (last pass: v4.14.153 - fi=
rst fail: v4.14.153-40-gf7fb2676f8a6)

arm64:

    defconfig:
        gcc-8:
          bcm2837-rpi-3-b:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          meson-gxbb-p200:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          meson-gxl-s905x-libretech-cc:
              lab-clabbe: failing since 1 day (last pass: v4.14.153 - first=
 fail: v4.14.153-40-gf7fb2676f8a6)
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          qemu_arm64-virt-gicv2:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          r8a7795-salvator-x:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          r8a7796-m3ulcb:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          sun50i-a64-bananapi-m64:
              lab-clabbe: failing since 1 day (last pass: v4.14.153 - first=
 fail: v4.14.153-40-gf7fb2676f8a6)

x86_64:

    x86_64_defconfig:
        gcc-8:
          minnowboard-turbot-E3826:
              lab-collabora: failing since 1 day (last pass: v4.14.153 - fi=
rst fail: v4.14.153-40-gf7fb2676f8a6)

Boot Failures Detected:

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 2 failed labs

arm:
    tegra_defconfig:
        gcc-8:
            tegra124-jetson-tk1: 1 failed lab
            tegra124-nyan-big: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            am335x-boneblack: 1 failed lab
            bcm2836-rpi-2-b: 1 failed lab
            exynos4412-odroidx2: 1 failed lab
            exynos5422-odroidxu3: 2 failed labs
            exynos5800-peach-pi: 1 failed lab
            imx6q-sabrelite: 2 failed labs
            meson8b-odroidc1: 1 failed lab
            omap4-panda: 2 failed labs
            qemu_arm-virt-gicv2: 2 failed labs
            qemu_arm-virt-gicv3: 2 failed labs
            rk3288-rock2-square: 1 failed lab
            rk3288-veyron-jaq: 1 failed lab
            sun5i-a13-olinuxino-micro: 1 failed lab
            sun7i-a20-cubieboard2: 2 failed labs
            sun8i-a33-olinuxino: 1 failed lab
            sun8i-h2-plus-orangepi-zero: 1 failed lab
            tegra124-jetson-tk1: 1 failed lab
            tegra124-nyan-big: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun5i-a13-olinuxino-micro: 1 failed lab
            sun7i-a20-cubieboard2: 2 failed labs
            sun8i-a33-olinuxino: 1 failed lab
            sun8i-h2-plus-orangepi-zero: 1 failed lab

    exynos_defconfig:
        gcc-8:
            exynos4412-odroidx2: 1 failed lab
            exynos5422-odroidxu3: 2 failed labs
            exynos5800-peach-pi: 1 failed lab

    bcm2835_defconfig:
        gcc-8:
            bcm2836-rpi-2-b: 1 failed lab
            bcm2837-rpi-3-b: 1 failed lab

    omap2plus_defconfig:
        gcc-8:
            am335x-boneblack: 1 failed lab
            omap4-panda: 2 failed labs

x86_64:
    x86_64_defconfig:
        gcc-8:
            minnowboard-turbot-E3826: 1 failed lab
            qemu_x86_64: 2 failed labs

arm64:
    defconfig:
        gcc-8:
            bcm2837-rpi-3-b: 1 failed lab
            meson-gxbb-p200: 1 failed lab
            meson-gxl-s905x-khadas-vim: 1 failed lab
            meson-gxl-s905x-libretech-cc: 2 failed labs
            qemu_arm64-virt-gicv2: 2 failed labs
            qemu_arm64-virt-gicv3: 2 failed labs
            r8a7795-salvator-x: 1 failed lab
            r8a7796-m3ulcb: 2 failed labs
            rk3399-gru-kevin: 1 failed lab
            sun50i-a64-bananapi-m64: 1 failed lab

---
For more info write to <info@kernelci.org>
