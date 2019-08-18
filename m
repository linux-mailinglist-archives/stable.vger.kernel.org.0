Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC74A9198E
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 22:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726247AbfHRUha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 16:37:30 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:56039 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfHRUh3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 16:37:29 -0400
Received: by mail-wm1-f51.google.com with SMTP id f72so1242130wmf.5
        for <stable@vger.kernel.org>; Sun, 18 Aug 2019 13:37:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kj+JkuS8Zr9UDVSkhE/L4bwJ1UlXRyX2fY27Pf7Hq/g=;
        b=TOcKi2gaxf0nMlJ4X/FWinnAcOy5ohFsrPn9wHL9HHsWCJL7m8w/r08RKRj1nwZBbv
         IBmHaGGMIb6DYSV2XX16yxxOc242kR6peCF6gc3G+IM8skpU+bncIjTQc1nYwg7b0jya
         4exkFT9H4Me9Aptwfu1+etg5Qzb63MwwFNR2PtYDFv1bU8DhvPpqpYzwtXA3mU/1YZY2
         0i2aeCTu4gisVpGN4YTWllbNuRRV9Lla8Xg67uPaxLQy9ZoQXyw6zG8sran1b1xD1PXH
         5nBfDEAZkm2BJgB5zrIwewy8kD5j5gA14ToQS1yuw6kWxXJuJx/E7DAHYszGDQuiR7aW
         EMFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kj+JkuS8Zr9UDVSkhE/L4bwJ1UlXRyX2fY27Pf7Hq/g=;
        b=ntu1x+2kG8wtPyNU8uea1fA5iQuz3mKM1OUMjm8WBi+CM8Ui/ZwVRlj8sCvrFOgBud
         Lwxhl+mRdmoazSyO4yFe14hIFGsor6MNWb9FcAB18Go8nHEln8P2ezLAp0Nvhxd2JrT5
         UWv0u9xZhl48jRVsH+61ofmmO8ZaU9NZUo7GgskS5GC8PWo32O7NeRcfjdniKp4FBjir
         cvc/C+sEe1uERHJXQMzcjhdtQcY9nHWvrLivPmM6tZxe+fHPz6m68CE/JQcdevDyP7zw
         2G5LC5QSsnYv9b0Om2w8jpQrq60knIXLiADbOQm/MswoHQGn3dRqin9buINNlx/veHY3
         uV3w==
X-Gm-Message-State: APjAAAUP5rk7i+3dbegvsyOBWOnVSiARxYWPqo47QePyRxpx3Db1MrvG
        c5tP07ja9KiEppl7IRcP1x6Ex6RYUGM=
X-Google-Smtp-Source: APXvYqzzcesqv15D+nYgMM5+4NJq1yxFm6IRQTJexDQTpvC9flQ2z2NGrbQJSlRXBVE8+TRER/o27w==
X-Received: by 2002:a1c:be19:: with SMTP id o25mr16321182wmf.54.1566160645481;
        Sun, 18 Aug 2019 13:37:25 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n14sm39671021wra.75.2019.08.18.13.37.24
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Aug 2019 13:37:25 -0700 (PDT)
Message-ID: <5d59b705.1c69fb81.a452d.e66b@mx.google.com>
Date:   Sun, 18 Aug 2019 13:37:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.189-84-gfe210ed24b65
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 103 boots: 87 failed,
 0 passed with 16 offline (v4.9.189-84-gfe210ed24b65)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 103 boots: 87 failed, 0 passed with 16 offline =
(v4.9.189-84-gfe210ed24b65)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.189-84-gfe210ed24b65/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.189-84-gfe210ed24b65/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.189-84-gfe210ed24b65
Git Commit: fe210ed24b655ecf3cbc0a9a59d4a27bca605d73
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 22 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-44-g755768e31f44 - first fail: v4.9.189-69-g711554dc8b12)

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          da850-lcdk:
              lab-baylibre: new failure (last pass: v4.9.189-69-g711554dc8b=
12)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)

    exynos_defconfig:
        gcc-8:
          exynos4412-odroidx2:
              lab-collabora: new failure (last pass: v4.9.189-44-g755768e31=
f44)
          exynos5250-arndale:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          exynos5250-snow:
              lab-collabora: new failure (last pass: v4.9.189-69-g711554dc8=
b12)
          exynos5420-arndale-octa:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          exynos5422-odroidxu3:
              lab-baylibre: new failure (last pass: v4.9.189-69-g711554dc8b=
12)
              lab-collabora: new failure (last pass: v4.9.189-69-g711554dc8=
b12)
          exynos5800-peach-pi:
              lab-collabora: new failure (last pass: v4.9.189-69-g711554dc8=
b12)
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)

    imx_v6_v7_defconfig:
        gcc-8:
          imx6dl-riotboard:
              lab-pengutronix: new failure (last pass: v4.9.189-69-g711554d=
c8b12)
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          imx6q-wandboard:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          imx7s-warp:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          vf610-colibri-eval-v3:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)

    multi_v7_defconfig:
        gcc-8:
          alpine-db:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          armada-xp-openblocks-ax3-4:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          at91-sama5d4_xplained:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          bcm4708-smartrg-sr400ac:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          bcm72521-bcm97252sffe:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          bcm7445-bcm97445c:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          exynos4412-odroidx2:
              lab-collabora: new failure (last pass: v4.9.189-69-g711554dc8=
b12)
          exynos5250-arndale:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          exynos5250-snow:
              lab-collabora: new failure (last pass: v4.9.189-69-g711554dc8=
b12)
          exynos5420-arndale-octa:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          exynos5422-odroidxu3:
              lab-baylibre: new failure (last pass: v4.9.189-69-g711554dc8b=
12)
              lab-collabora: new failure (last pass: v4.9.189-69-g711554dc8=
b12)
          exynos5800-peach-pi:
              lab-collabora: failing since 1 day (last pass: v4.9.189-44-g7=
55768e31f44 - first fail: v4.9.189-69-g711554dc8b12)
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          imx6dl-riotboard:
              lab-pengutronix: new failure (last pass: v4.9.189-69-g711554d=
c8b12)
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          imx6q-sabrelite:
              lab-collabora: new failure (last pass: v4.9.189-69-g711554dc8=
b12)
          imx6q-wandboard:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          imx7s-warp:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          meson8b-odroidc1:
              lab-baylibre: new failure (last pass: v4.9.189-69-g711554dc8b=
12)
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          omap3-beagle:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.9.189-69-g711554dc8b=
12)
              lab-collabora: new failure (last pass: v4.9.189-69-g711554dc8=
b12)
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          qemu:
              lab-baylibre: new failure (last pass: v4.9.189-69-g711554dc8b=
12)
              lab-linaro-lkft: new failure (last pass: v4.9.189-69-g711554d=
c8b12)
              lab-mhart: new failure (last pass: v4.9.189-69-g711554dc8b12)
              lab-drue: new failure (last pass: v4.9.189-69-g711554dc8b12)
              lab-collabora: new failure (last pass: v4.9.189-69-g711554dc8=
b12)
          rk3288-veyron-jaq:
              lab-collabora: new failure (last pass: v4.9.189-69-g711554dc8=
b12)
          socfpga_cyclone5_de0_sockit:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          stih410-b2120:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          sun5i-a13-olinuxino-micro:
              lab-baylibre: new failure (last pass: v4.9.189-44-g755768e31f=
44)
          sun5i-r8-chip:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          sun7i-a20-cubietruck:
              lab-baylibre: new failure (last pass: v4.9.189-69-g711554dc8b=
12)
          tegra124-jetson-tk1:
              lab-mhart: new failure (last pass: v4.9.189-69-g711554dc8b12)
              lab-collabora: new failure (last pass: v4.9.189-69-g711554dc8=
b12)
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          tegra30-beaver:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          vf610-colibri-eval-v3:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          zynq-zc702:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)

    mvebu_v7_defconfig:
        gcc-8:
          armada-xp-openblocks-ax3-4:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.9.189-69-g711554dc8b=
12)
              lab-collabora: new failure (last pass: v4.9.189-69-g711554dc8=
b12)
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-44-g755768e31f44 - first fail: v4.9.189-69-g711554dc8b12)

    socfpga_defconfig:
        gcc-8:
          socfpga_cyclone5_de0_sockit:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-44-g755768e31f44 - first fail: v4.9.189-69-g711554dc8b12)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          sun5i-a13-olinuxino-micro:
              lab-baylibre: new failure (last pass: v4.9.189-69-g711554dc8b=
12)
          sun5i-r8-chip:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          sun7i-a20-cubietruck:
              lab-baylibre: failing since 1 day (last pass: v4.9.189-44-g75=
5768e31f44 - first fail: v4.9.189-69-g711554dc8b12)

    tegra_defconfig:
        gcc-8:
          tegra124-jetson-tk1:
              lab-mhart: new failure (last pass: v4.9.189-69-g711554dc8b12)
              lab-collabora: new failure (last pass: v4.9.189-69-g711554dc8=
b12)
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)
          tegra30-beaver:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-69-g71=
1554dc8b12)

arm64:

    defconfig:
        gcc-8:
          apq8016-sbc:
              lab-mhart: new failure (last pass: v4.9.189-69-g711554dc8b12)
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-44-g755768e31f44 - first fail: v4.9.189-69-g711554dc8b12)
          juno-r2:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-44-g755768e31f44 - first fail: v4.9.189-69-g711554dc8b12)
          meson-gxbb-odroidc2:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-44-g755768e31f44 - first fail: v4.9.189-69-g711554dc8b12)
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v4.9.189-69-g711554dc8b=
12)
          qcom-qdf2400:
              lab-linaro-lkft: new failure (last pass: v4.9.189-69-g711554d=
c8b12)
          qemu:
              lab-baylibre: new failure (last pass: v4.9.189-69-g711554dc8b=
12)
              lab-linaro-lkft: new failure (last pass: v4.9.189-69-g711554d=
c8b12)
              lab-mhart: new failure (last pass: v4.9.189-69-g711554dc8b12)
              lab-drue: new failure (last pass: v4.9.189-69-g711554dc8b12)
              lab-collabora: new failure (last pass: v4.9.189-69-g711554dc8=
b12)
          synquacer-acpi:
              lab-mhart: new failure (last pass: v4.9.189-69-g711554dc8b12)

i386:

    i386_defconfig:
        gcc-8:
          x86-celeron:
              lab-mhart: new failure (last pass: v4.9.189-69-g711554dc8b12)
          x86-pentium4:
              lab-mhart: new failure (last pass: v4.9.189-69-g711554dc8b12)

x86_64:

    x86_64_defconfig:
        gcc-8:
          minnowboard-turbot-E3826:
              lab-collabora: new failure (last pass: v4.9.189-69-g711554dc8=
b12)
          qemu:
              lab-baylibre: new failure (last pass: v4.9.189-69-g711554dc8b=
12)
              lab-linaro-lkft: new failure (last pass: v4.9.189-69-g711554d=
c8b12)
              lab-mhart: new failure (last pass: v4.9.189-69-g711554dc8b12)
              lab-drue: new failure (last pass: v4.9.189-69-g711554dc8b12)
              lab-collabora: new failure (last pass: v4.9.189-69-g711554dc8=
b12)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            apq8016-sbc: 1 failed lab
            meson-gxbb-p200: 1 failed lab
            qcom-qdf2400: 1 failed lab
            qemu: 5 failed labs
            synquacer-acpi: 1 failed lab

i386:
    i386_defconfig:
        gcc-8:
            x86-celeron: 1 failed lab
            x86-pentium4: 1 failed lab

x86_64:
    x86_64_defconfig:
        gcc-8:
            minnowboard-turbot-E3826: 1 failed lab
            qemu: 5 failed labs

arm:
    mvebu_v7_defconfig:
        gcc-8:
            armada-xp-openblocks-ax3-4: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab
            sun5i-a13-olinuxino-micro: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab
            sun7i-a20-cubietruck: 1 failed lab

    imx_v6_v7_defconfig:
        gcc-8:
            imx6dl-riotboard: 1 failed lab
            imx6dl-wandboard_dual: 1 failed lab
            imx6dl-wandboard_solo: 1 failed lab
            imx6q-wandboard: 1 failed lab
            imx7s-warp: 1 failed lab
            vf610-colibri-eval-v3: 1 failed lab

    omap2plus_defconfig:
        gcc-8:
            omap3-beagle: 1 failed lab
            omap4-panda: 3 failed labs

    multi_v7_defconfig:
        gcc-8:
            armada-xp-openblocks-ax3-4: 1 failed lab
            bcm4708-smartrg-sr400ac: 1 failed lab
            bcm72521-bcm97252sffe: 1 failed lab
            bcm7445-bcm97445c: 1 failed lab
            exynos4412-odroidx2: 1 failed lab
            exynos5250-arndale: 1 failed lab
            exynos5250-snow: 1 failed lab
            exynos5420-arndale-octa: 1 failed lab
            exynos5422-odroidxu3: 2 failed labs
            exynos5800-peach-pi: 1 failed lab
            imx6dl-riotboard: 1 failed lab
            imx6dl-wandboard_dual: 1 failed lab
            imx6dl-wandboard_solo: 1 failed lab
            imx6q-sabrelite: 1 failed lab
            imx6q-wandboard: 1 failed lab
            imx7s-warp: 1 failed lab
            meson8b-odroidc1: 2 failed labs
            omap3-beagle: 1 failed lab
            omap4-panda: 3 failed labs
            qemu: 5 failed labs
            rk3288-veyron-jaq: 1 failed lab
            stih410-b2120: 1 failed lab
            sun4i-a10-cubieboard: 1 failed lab
            sun5i-a13-olinuxino-micro: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab
            sun7i-a20-cubietruck: 1 failed lab
            tegra124-jetson-tk1: 2 failed labs
            tegra20-iris-512: 1 failed lab
            tegra30-beaver: 1 failed lab
            vf610-colibri-eval-v3: 1 failed lab
            zynq-zc702: 1 failed lab

    davinci_all_defconfig:
        gcc-8:
            da850-evm: 1 failed lab
            da850-lcdk: 1 failed lab
            dm365evm,legacy: 1 failed lab

    tegra_defconfig:
        gcc-8:
            tegra124-jetson-tk1: 2 failed labs
            tegra20-iris-512: 1 failed lab
            tegra30-beaver: 1 failed lab

    exynos_defconfig:
        gcc-8:
            exynos4412-odroidx2: 1 failed lab
            exynos5250-arndale: 1 failed lab
            exynos5250-snow: 1 failed lab
            exynos5420-arndale-octa: 1 failed lab
            exynos5422-odroidxu3: 2 failed labs
            exynos5800-peach-pi: 2 failed labs

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

---
For more info write to <info@kernelci.org>
