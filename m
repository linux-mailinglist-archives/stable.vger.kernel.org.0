Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 544F9F76A1
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 15:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfKKOlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 09:41:03 -0500
Received: from mail-wm1-f47.google.com ([209.85.128.47]:37163 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbfKKOlD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 09:41:03 -0500
Received: by mail-wm1-f47.google.com with SMTP id b17so5182236wmj.2
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 06:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2aGJ8DD/YTV56h/JBH9zNq+M/X173xxhf0ZX08+oxPs=;
        b=BrKUIag86kcbv5F/o/vhxJ+QXQljreEXHkSSoaHYhfZfheIiqygtzULfEprZym0fx+
         1cbZIXq6IfzRzgOTy1Bp0Z5QQwFHR23+vg6PNsS+rFOy83z5szuvcfIEyVxL4QMUeks/
         9fQ1dwWItltMGeIExYxRnElLXOo2q2/xUuB7q8Wcr90inUTjdMD4xMDrJxrjRkDb1oqZ
         5yeYTjvEES2u/6qRlBuUJMnbyFA5BVEG1aT/cmBOPs+7wDaGrfSxllHtqXkZVDIFZTfI
         U9+mye2b4MO3zEXKP4yBRH6RipzBt9DHkOkcOaKkHlX5QlMV7CpDsX9P8Nqmn/f0nXkv
         z0eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2aGJ8DD/YTV56h/JBH9zNq+M/X173xxhf0ZX08+oxPs=;
        b=Sp3rOH707sdjP/E3ZVaMSLijxKU2kXShiEQLKHrlIH90NzSUalljNZiH3WWx3ALXQh
         JAQiclGR2Nhv0T2shIqVj7yUDLQcbc5VU0mMCqw0duXiJQC3dD0ZzViwGq5AZxa2wazv
         ASp6/w/mm0SjBlag49qPNiPC8iUjQFYSYHKOJP9rzXUgXjzLILTx5co+cFSfvBD9lkhz
         aAEA+aBIhhfGw17JDLBT3Js0ZLFsov3T97uUi0Dg0ECtH006OeZD/H50BY9uGvyvbOyH
         Dk5nst24jNguWdBjpXjbcLxja2jnNAGL2QgjNsZN7nYH635RAgR/HtgxpAmKcw+eEFA4
         9fYQ==
X-Gm-Message-State: APjAAAWPyl9kPl6F5od9ZwIvpxN8tPlA87r26qrP4QwVufSfG89cPFxl
        YvRxonH8PgKXerngSvzE5HRLFmiPmBQAvg==
X-Google-Smtp-Source: APXvYqy74cE+W0xenbalQURJUrEYEjmNBpNmYuInNhy+pNPZh+Lg99wS1IptzzhZujFiED8YSyOK/w==
X-Received: by 2002:a1c:9d07:: with SMTP id g7mr20930179wme.53.1573483257597;
        Mon, 11 Nov 2019 06:40:57 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c4sm4271487wrp.86.2019.11.11.06.40.56
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 06:40:56 -0800 (PST)
Message-ID: <5dc972f8.1c69fb81.261a5.3c14@mx.google.com>
Date:   Mon, 11 Nov 2019 06:40:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.153-40-gf7fb2676f8a6
Subject: stable-rc/linux-4.14.y boot: 109 boots: 100 failed,
 0 passed with 8 offline, 1 untried/unknown (v4.14.153-40-gf7fb2676f8a6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 109 boots: 100 failed, 0 passed with 8 offline=
, 1 untried/unknown (v4.14.153-40-gf7fb2676f8a6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.153-40-gf7fb2676f8a6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.153-40-gf7fb2676f8a6/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.153-40-gf7fb2676f8a6
Git Commit: f7fb2676f8a620fe1763cc6e2f57ad6c0bd1e22a
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 60 unique boards, 21 SoC families, 13 builds out of 201

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          bcm2836-rpi-2-b:
              lab-collabora: new failure (last pass: v4.14.153)
          bcm2837-rpi-3-b:
              lab-baylibre: new failure (last pass: v4.14.153)

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)

    exynos_defconfig:
        gcc-8:
          exynos4412-odroidx2:
              lab-collabora: new failure (last pass: v4.14.153)
          exynos5250-arndale:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          exynos5420-arndale-octa:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          exynos5422-odroidxu3:
              lab-collabora: new failure (last pass: v4.14.153)
          exynos5800-peach-pi:
              lab-collabora: new failure (last pass: v4.14.153)
              lab-baylibre-seattle: new failure (last pass: v4.14.153)

    imx_v6_v7_defconfig:
        gcc-8:
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          imx6q-wandboard:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          imx7s-warp:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          vf610-colibri-eval-v3:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)

    multi_v7_defconfig:
        gcc-8:
          alpine-db:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          armada-xp-openblocks-ax3-4:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          bcm2836-rpi-2-b:
              lab-collabora: new failure (last pass: v4.14.153)
          exynos4412-odroidx2:
              lab-collabora: new failure (last pass: v4.14.153)
          exynos5250-arndale:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          exynos5420-arndale-octa:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          exynos5422-odroidxu3:
              lab-collabora: new failure (last pass: v4.14.153)
          exynos5800-peach-pi:
              lab-collabora: new failure (last pass: v4.14.153)
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          imx6q-sabrelite:
              lab-collabora: new failure (last pass: v4.14.153)
              lab-baylibre: new failure (last pass: v4.14.153)
          imx6q-wandboard:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          imx7s-warp:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          meson8b-odroidc1:
              lab-baylibre: new failure (last pass: v4.14.153)
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          mt7623n-bananapi-bpi-r2:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          omap3-beagle:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          omap3-beagle-xm:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          omap4-panda:
              lab-collabora: new failure (last pass: v4.14.153)
              lab-baylibre: new failure (last pass: v4.14.153)
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          qemu_arm-virt-gicv2:
              lab-collabora: new failure (last pass: v4.14.153)
              lab-baylibre: new failure (last pass: v4.14.153)
          qemu_arm-virt-gicv3:
              lab-collabora: new failure (last pass: v4.14.153)
              lab-baylibre: new failure (last pass: v4.14.153)
          rk3288-rock2-square:
              lab-collabora: new failure (last pass: v4.14.153)
          rk3288-veyron-jaq:
              lab-collabora: new failure (last pass: v4.14.153)
          socfpga_cyclone5_de0_sockit:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          stih410-b2120:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          sun5i-a13-olinuxino-micro:
              lab-baylibre: new failure (last pass: v4.14.153)
          sun5i-r8-chip:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          sun7i-a20-cubieboard2:
              lab-clabbe: new failure (last pass: v4.14.153)
              lab-baylibre: new failure (last pass: v4.14.153)
          sun8i-a83t-bananapi-m3:
              lab-clabbe: new failure (last pass: v4.14.153)
          sun8i-h2-plus-orangepi-zero:
              lab-baylibre: new failure (last pass: v4.14.153)
          sun8i-h3-orangepi-pc:
              lab-clabbe: new failure (last pass: v4.14.153)
          tegra124-jetson-tk1:
              lab-collabora: new failure (last pass: v4.14.153)
          tegra124-nyan-big:
              lab-collabora: new failure (last pass: v4.14.153)
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          tegra30-beaver:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          vf610-colibri-eval-v3:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          zynq-zc702:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)

    mvebu_v7_defconfig:
        gcc-8:
          armada-xp-openblocks-ax3-4:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          omap3-beagle-xm:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          omap4-panda:
              lab-collabora: new failure (last pass: v4.14.153)
              lab-baylibre: new failure (last pass: v4.14.153)
              lab-baylibre-seattle: new failure (last pass: v4.14.153)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          sun5i-a13-olinuxino-micro:
              lab-baylibre: new failure (last pass: v4.14.153)
          sun5i-r8-chip:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          sun7i-a20-cubieboard2:
              lab-clabbe: new failure (last pass: v4.14.153)
              lab-baylibre: new failure (last pass: v4.14.153)
          sun8i-a33-olinuxino:
              lab-clabbe: new failure (last pass: v4.14.153)
          sun8i-a83t-bananapi-m3:
              lab-clabbe: new failure (last pass: v4.14.153)
          sun8i-h2-plus-orangepi-zero:
              lab-baylibre: new failure (last pass: v4.14.153)
          sun8i-h3-orangepi-pc:
              lab-clabbe: new failure (last pass: v4.14.153)

    tegra_defconfig:
        gcc-8:
          tegra124-jetson-tk1:
              lab-collabora: new failure (last pass: v4.14.153)
          tegra124-nyan-big:
              lab-collabora: new failure (last pass: v4.14.153)
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          tegra30-beaver:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)

arm64:

    defconfig:
        gcc-8:
          bcm2837-rpi-3-b:
              lab-baylibre: new failure (last pass: v4.14.153)
          juno-r2:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v4.14.153)
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: new failure (last pass: v4.14.153)
          meson-gxl-s905x-libretech-cc:
              lab-clabbe: new failure (last pass: v4.14.153)
              lab-baylibre: new failure (last pass: v4.14.153)
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          meson-gxl-s905x-nexbox-a95x:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          meson-gxm-nexbox-a1:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          mt7622-rfb1:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)
          qemu_arm64-virt-gicv2:
              lab-collabora: new failure (last pass: v4.14.153)
              lab-baylibre: new failure (last pass: v4.14.153)
          qemu_arm64-virt-gicv3:
              lab-collabora: new failure (last pass: v4.14.153)
              lab-baylibre: new failure (last pass: v4.14.153)
          r8a7796-m3ulcb:
              lab-collabora: new failure (last pass: v4.14.153)
              lab-baylibre: new failure (last pass: v4.14.153)
          rk3399-gru-kevin:
              lab-collabora: new failure (last pass: v4.14.153)
          sun50i-a64-bananapi-m64:
              lab-clabbe: new failure (last pass: v4.14.153)
          sun50i-a64-pine64-plus:
              lab-baylibre-seattle: new failure (last pass: v4.14.153)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-collabora: new failure (last pass: v4.14.153)
              lab-baylibre: new failure (last pass: v4.14.153)

x86_64:

    x86_64_defconfig:
        gcc-8:
          minnowboard-turbot-E3826:
              lab-collabora: new failure (last pass: v4.14.153)
          qemu_x86_64:
              lab-collabora: new failure (last pass: v4.14.153)
              lab-baylibre: new failure (last pass: v4.14.153)

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
            tegra20-iris-512: 1 failed lab
            tegra30-beaver: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            alpine-db: 1 failed lab
            armada-xp-openblocks-ax3-4: 1 failed lab
            bcm2836-rpi-2-b: 1 failed lab
            exynos4412-odroidx2: 1 failed lab
            exynos5250-arndale: 1 failed lab
            exynos5420-arndale-octa: 1 failed lab
            exynos5422-odroidxu3: 1 failed lab
            exynos5800-peach-pi: 2 failed labs
            imx6dl-wandboard_dual: 1 failed lab
            imx6dl-wandboard_solo: 1 failed lab
            imx6q-sabrelite: 2 failed labs
            imx6q-wandboard: 1 failed lab
            imx7s-warp: 1 failed lab
            meson8b-odroidc1: 2 failed labs
            mt7623n-bananapi-bpi-r2: 1 failed lab
            omap3-beagle: 1 failed lab
            omap3-beagle-xm: 1 failed lab
            omap4-panda: 3 failed labs
            qemu_arm-virt-gicv2: 2 failed labs
            qemu_arm-virt-gicv3: 2 failed labs
            rk3288-rock2-square: 1 failed lab
            rk3288-veyron-jaq: 1 failed lab
            socfpga_cyclone5_de0_sockit: 1 failed lab
            stih410-b2120: 1 failed lab
            sun4i-a10-cubieboard: 1 failed lab
            sun5i-a13-olinuxino-micro: 1 failed lab
            sun7i-a20-cubieboard2: 2 failed labs
            sun8i-a33-olinuxino: 1 failed lab
            sun8i-a83t-bananapi-m3: 1 failed lab
            sun8i-h2-plus-orangepi-zero: 1 failed lab
            sun8i-h3-orangepi-pc: 1 failed lab
            tegra124-jetson-tk1: 1 failed lab
            tegra124-nyan-big: 1 failed lab
            tegra20-iris-512: 1 failed lab
            tegra30-beaver: 1 failed lab
            zynq-zc702: 1 failed lab

    davinci_all_defconfig:
        gcc-8:
            da850-evm: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab
            sun5i-a13-olinuxino-micro: 1 failed lab
            sun7i-a20-cubieboard2: 2 failed labs
            sun8i-a33-olinuxino: 1 failed lab
            sun8i-a83t-bananapi-m3: 1 failed lab
            sun8i-h2-plus-orangepi-zero: 1 failed lab
            sun8i-h3-orangepi-pc: 1 failed lab

    imx_v6_v7_defconfig:
        gcc-8:
            imx6dl-wandboard_dual: 1 failed lab
            imx6dl-wandboard_solo: 1 failed lab
            imx6q-wandboard: 1 failed lab
            imx7s-warp: 1 failed lab
            vf610-colibri-eval-v3: 1 failed lab

    exynos_defconfig:
        gcc-8:
            exynos4412-odroidx2: 1 failed lab
            exynos5250-arndale: 1 failed lab
            exynos5420-arndale-octa: 1 failed lab
            exynos5422-odroidxu3: 1 failed lab
            exynos5800-peach-pi: 2 failed labs

    bcm2835_defconfig:
        gcc-8:
            bcm2835-rpi-b: 1 failed lab
            bcm2836-rpi-2-b: 1 failed lab
            bcm2837-rpi-3-b: 1 failed lab

    omap2plus_defconfig:
        gcc-8:
            omap3-beagle: 1 failed lab
            omap3-beagle-xm: 1 failed lab
            omap4-panda: 3 failed labs

    mvebu_v7_defconfig:
        gcc-8:
            armada-xp-openblocks-ax3-4: 1 failed lab

x86_64:
    x86_64_defconfig:
        gcc-8:
            minnowboard-turbot-E3826: 1 failed lab
            qemu_x86_64: 2 failed labs

arm64:
    defconfig:
        gcc-8:
            bcm2837-rpi-3-b: 1 failed lab
            juno-r2: 1 failed lab
            meson-gxbb-p200: 1 failed lab
            meson-gxl-s905x-khadas-vim: 1 failed lab
            meson-gxl-s905x-libretech-cc: 3 failed labs
            meson-gxl-s905x-nexbox-a95x: 1 failed lab
            meson-gxm-nexbox-a1: 1 failed lab
            mt7622-rfb1: 1 failed lab
            qemu_arm64-virt-gicv2: 2 failed labs
            qemu_arm64-virt-gicv3: 2 failed labs
            r8a7796-m3ulcb: 2 failed labs
            rk3399-gru-kevin: 1 failed lab
            sun50i-a64-pine64-plus: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab
            vf610-colibri-eval-v3: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
