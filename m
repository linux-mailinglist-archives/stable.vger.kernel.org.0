Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4B0391AA2
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 03:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbfHSBWu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 21:22:50 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:36927 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfHSBWu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 21:22:50 -0400
Received: by mail-wr1-f51.google.com with SMTP id z11so6922885wrt.4
        for <stable@vger.kernel.org>; Sun, 18 Aug 2019 18:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sOED8uf2+35XByguShKI1CdsG6dzn/R8mUt8KzxyE08=;
        b=J2wNJSGR+KKpj988UcQ7FFgVVgiYc7EEwEymazz8aH2zGQuV6I395MVitK6c9+k4tq
         7HWXaYFtL/8NiTLdsditKT3Pur8Al9c+O+Sp4b2gQnJ6dyjerzuZuc011w4bIXDziRUV
         tsbLSy7KQByy5fPmcvyKVAbVzbMFcSoSimrdG1oXOld4X/RnSfxGy6FyADJdoIbyAbIf
         wD8IbtcaYlItb4LDOyZ9C8IQH56LFCOh9u/HO47qvA+lPVi5o3T8rhuqAyJiUAPHrco5
         FRT1tOyTpZE8O+sDxVh/SrFEhC3JVAAlmVw3AqV7sA+XblRIIL09qVVt+qMXLl4WXUHR
         X8bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sOED8uf2+35XByguShKI1CdsG6dzn/R8mUt8KzxyE08=;
        b=dVgkppHup6k+SKxOCjK+9Ts+GU9QeaK0IUet1sUUTRyUaSslrOFwlDuhZGfF5mg1nd
         4zzogrSPjAKJGsFcAKyJEZOLFCozf6WUtv4gHMoS9lTnFyZ0m5pi7t0grBz8wEx9HsNk
         flpCzKrt7mf79aBQDDp0XTvt2jY8qteW5ZoRdTLWSZ9S+1Uwev8zsf+r+u0APtzyFVFr
         RgEe6V/2BFQl7fxcWjqGHZf2YxOYNe0tDnY1aw2J5WBC1cTHgfSyK1BJ6aKWiDvnUuEn
         jKSAkl7zC4CCR6I5N6bUlkBlZbqW1e6gu3e0qE1nMyxjAEuFaAmv8u4DJSmUKKYDTRfS
         hslQ==
X-Gm-Message-State: APjAAAWSoGC+AnywDSbOw5tS6kIGJuyFoGiALwyuVEwWk+VyjY8tpBEB
        zYUtR2G0jMwTDGOGbmZw73JXzKba0F8=
X-Google-Smtp-Source: APXvYqxJpTtidJDRKf3vKMQtJnSTvw4GP7otVyVPaTkJ/FS1TKqp2xv0qZpaFaaP2kPr5GMBrlNdLw==
X-Received: by 2002:a5d:568e:: with SMTP id f14mr22831026wrv.167.1566177765205;
        Sun, 18 Aug 2019 18:22:45 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j20sm31971028wre.65.2019.08.18.18.22.44
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Aug 2019 18:22:44 -0700 (PDT)
Message-ID: <5d59f9e4.1c69fb81.56c06.c327@mx.google.com>
Date:   Sun, 18 Aug 2019 18:22:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.138-126-gd7a63a72ea28
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 122 boots: 105 failed,
 0 passed with 17 offline (v4.14.138-126-gd7a63a72ea28)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 122 boots: 105 failed, 0 passed with 17 offlin=
e (v4.14.138-126-gd7a63a72ea28)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.138-126-gd7a63a72ea28/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.138-126-gd7a63a72ea28/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.138-126-gd7a63a72ea28
Git Commit: d7a63a72ea281a360d17df4b69a2bf07fdd18c99
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 25 SoC families, 16 builds out of 201

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-73-g1a4682459a61 - first fail: v4.14.138-91-g248e04a69071)
          bcm2837-rpi-3-b:
              lab-baylibre: failing since 1 day (last pass: v4.14.138-91-g2=
48e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          da850-lcdk:
              lab-baylibre: failing since 1 day (last pass: v4.14.138-91-g2=
48e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          dm365evm,legacy:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)

    exynos_defconfig:
        gcc-8:
          exynos4412-odroidx2:
              lab-collabora: failing since 1 day (last pass: v4.14.138-91-g=
248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          exynos5250-arndale:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          exynos5250-snow:
              lab-collabora: failing since 1 day (last pass: v4.14.138-91-g=
248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          exynos5420-arndale-octa:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          exynos5422-odroidxu3:
              lab-baylibre: failing since 1 day (last pass: v4.14.138-91-g2=
48e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          exynos5800-peach-pi:
              lab-collabora: failing since 1 day (last pass: v4.14.138-91-g=
248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)

    imx_v6_v7_defconfig:
        gcc-8:
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          imx6q-wandboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          imx7s-warp:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          vf610-colibri-eval-v3:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)

    multi_v7_defconfig:
        gcc-8:
          alpine-db:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          armada-xp-openblocks-ax3-4:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          at91-sama5d4_xplained:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          exynos4412-odroidx2:
              lab-collabora: failing since 1 day (last pass: v4.14.138-91-g=
248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          exynos5250-arndale:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          exynos5250-snow:
              lab-collabora: failing since 1 day (last pass: v4.14.138-91-g=
248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          exynos5420-arndale-octa:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          exynos5422-odroidxu3:
              lab-baylibre: failing since 1 day (last pass: v4.14.138-91-g2=
48e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          exynos5800-peach-pi:
              lab-collabora: failing since 1 day (last pass: v4.14.138-91-g=
248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          imx6dl-riotboard:
              lab-pengutronix: failing since 1 day (last pass: v4.14.138-91=
-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          imx6q-sabrelite:
              lab-collabora: failing since 1 day (last pass: v4.14.138-91-g=
248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          imx6q-wandboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          imx7s-warp:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          meson8b-odroidc1:
              lab-baylibre: failing since 1 day (last pass: v4.14.138-91-g2=
48e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          mt7623n-bananapi-bpi-r2:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          omap3-beagle:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          omap4-panda:
              lab-baylibre: failing since 1 day (last pass: v4.14.138-91-g2=
48e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
              lab-collabora: failing since 1 day (last pass: v4.14.138-91-g=
248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          qemu:
              lab-mhart: failing since 1 day (last pass: v4.14.138-91-g248e=
04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
              lab-drue: failing since 1 day (last pass: v4.14.138-91-g248e0=
4a69071 - first fail: v4.14.138-113-gbe36e71554f9)
              lab-collabora: failing since 1 day (last pass: v4.14.138-91-g=
248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          socfpga_cyclone5_de0_sockit:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          stih410-b2120:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          sun5i-a13-olinuxino-micro:
              lab-baylibre: failing since 1 day (last pass: v4.14.138-91-g2=
48e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          sun5i-r8-chip:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          sun7i-a20-cubietruck:
              lab-baylibre: failing since 1 day (last pass: v4.14.138-91-g2=
48e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          sun8i-h2-plus-orangepi-zero:
              lab-baylibre: failing since 1 day (last pass: v4.14.138-91-g2=
48e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          tegra124-jetson-tk1:
              lab-mhart: failing since 1 day (last pass: v4.14.138-91-g248e=
04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
              lab-collabora: failing since 1 day (last pass: v4.14.138-91-g=
248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          tegra20-iris-512:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          tegra30-beaver:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          vf610-colibri-eval-v3:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          zynq-zc702:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)

    mvebu_v7_defconfig:
        gcc-8:
          armada-xp-openblocks-ax3-4:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          omap4-panda:
              lab-baylibre: failing since 1 day (last pass: v4.14.138-91-g2=
48e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
              lab-collabora: failing since 1 day (last pass: v4.14.138-91-g=
248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 4 days (last pass: v4.14.=
138 - first fail: v4.14.138-70-g736c2f07319a)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 4 days (last pass: v4.14.=
138 - first fail: v4.14.138-70-g736c2f07319a)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-73-g1a4682459a61 - first fail: v4.14.138-91-g248e04a69071)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          sun5i-a13-olinuxino-micro:
              lab-baylibre: failing since 1 day (last pass: v4.14.138-91-g2=
48e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          sun5i-r8-chip:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          sun7i-a20-cubietruck:
              lab-baylibre: failing since 1 day (last pass: v4.14.138-91-g2=
48e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          sun8i-h2-plus-orangepi-zero:
              lab-baylibre: failing since 1 day (last pass: v4.14.138-91-g2=
48e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)

    tegra_defconfig:
        gcc-8:
          tegra124-jetson-tk1:
              lab-mhart: failing since 1 day (last pass: v4.14.138-91-g248e=
04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
              lab-collabora: failing since 1 day (last pass: v4.14.138-91-g=
248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          tegra20-iris-512:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          tegra30-beaver:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)

arm64:

    defconfig:
        gcc-8:
          apq8016-sbc:
              lab-mhart: failing since 1 day (last pass: v4.14.138-91-g248e=
04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          bcm2837-rpi-3-b:
              lab-mhart: failing since 1 day (last pass: v4.14.138-91-g248e=
04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          juno-r2:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          meson-gxbb-nanopi-k2:
              lab-baylibre: failing since 1 day (last pass: v4.14.138-91-g2=
48e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          meson-gxbb-odroidc2:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          meson-gxl-s905d-p230:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          meson-gxl-s905x-libretech-cc:
              lab-baylibre: failing since 1 day (last pass: v4.14.138-91-g2=
48e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          meson-gxl-s905x-nexbox-a95x:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          meson-gxl-s905x-p212:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          meson-gxm-nexbox-a1:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          mt7622-rfb1:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          qemu:
              lab-mhart: failing since 1 day (last pass: v4.14.138-91-g248e=
04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
              lab-drue: failing since 1 day (last pass: v4.14.138-91-g248e0=
4a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          r8a7796-m3ulcb:
              lab-baylibre: failing since 1 day (last pass: v4.14.138-91-g2=
48e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
              lab-collabora: failing since 1 day (last pass: v4.14.138-91-g=
248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          rk3399-firefly:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          rk3399-puma-haikou:
              lab-theobroma-systems: failing since 1 day (last pass: v4.14.=
138-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          sun50i-a64-pine64-plus:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          synquacer-acpi:
              lab-mhart: failing since 1 day (last pass: v4.14.138-91-g248e=
04a69071 - first fail: v4.14.138-113-gbe36e71554f9)

i386:

    i386_defconfig:
        gcc-8:
          x86-celeron:
              lab-mhart: failing since 1 day (last pass: v4.14.138-91-g248e=
04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
          x86-pentium4:
              lab-mhart: failing since 1 day (last pass: v4.14.138-91-g248e=
04a69071 - first fail: v4.14.138-113-gbe36e71554f9)

mips:

    pistachio_defconfig:
        gcc-8:
          pistachio_marduk:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-91-g248e04a69071 - first fail: v4.14.138-113-gbe36e71554f9)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu:
              lab-mhart: failing since 1 day (last pass: v4.14.138-91-g248e=
04a69071 - first fail: v4.14.138-113-gbe36e71554f9)
              lab-drue: failing since 1 day (last pass: v4.14.138-91-g248e0=
4a69071 - first fail: v4.14.138-113-gbe36e71554f9)

Boot Failures Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            apq8016-sbc: 1 failed lab
            bcm2837-rpi-3-b: 2 failed labs
            meson-gxbb-nanopi-k2: 1 failed lab
            meson-gxbb-p200: 1 failed lab
            meson-gxl-s905d-p230: 1 failed lab
            meson-gxl-s905x-khadas-vim: 1 failed lab
            meson-gxl-s905x-libretech-cc: 2 failed labs
            meson-gxl-s905x-nexbox-a95x: 1 failed lab
            meson-gxl-s905x-p212: 1 failed lab
            meson-gxm-nexbox-a1: 1 failed lab
            qcom-qdf2400: 1 failed lab
            qemu: 5 failed labs
            r8a7796-m3ulcb: 2 failed labs
            rk3399-firefly: 1 failed lab
            rk3399-gru-kevin: 1 failed lab
            rk3399-puma-haikou: 1 failed lab
            sun50i-a64-pine64-plus: 1 failed lab
            synquacer-acpi: 1 failed lab

mips:
    pistachio_defconfig:
        gcc-8:
            pistachio_marduk: 1 failed lab

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
            sun8i-h2-plus-orangepi-zero: 1 failed lab

    imx_v6_v7_defconfig:
        gcc-8:
            imx6dl-riotboard: 1 failed lab
            imx6dl-wandboard_dual: 1 failed lab
            imx6dl-wandboard_solo: 1 failed lab
            imx6q-wandboard: 1 failed lab
            imx7s-warp: 1 failed lab
            vf610-colibri-eval-v3: 1 failed lab

    bcm2835_defconfig:
        gcc-8:
            bcm2837-rpi-3-b: 1 failed lab

    omap2plus_defconfig:
        gcc-8:
            omap3-beagle: 1 failed lab
            omap4-panda: 3 failed labs

    multi_v7_defconfig:
        gcc-8:
            armada-xp-openblocks-ax3-4: 1 failed lab
            exynos4412-odroidx2: 1 failed lab
            exynos5250-arndale: 1 failed lab
            exynos5250-snow: 1 failed lab
            exynos5420-arndale-octa: 1 failed lab
            exynos5422-odroidxu3: 2 failed labs
            exynos5800-peach-pi: 2 failed labs
            imx6dl-riotboard: 1 failed lab
            imx6dl-wandboard_dual: 1 failed lab
            imx6dl-wandboard_solo: 1 failed lab
            imx6q-sabrelite: 1 failed lab
            imx6q-wandboard: 1 failed lab
            imx7s-warp: 1 failed lab
            meson8b-odroidc1: 2 failed labs
            mt7623n-bananapi-bpi-r2: 1 failed lab
            omap3-beagle: 1 failed lab
            omap4-panda: 3 failed labs
            qemu: 5 failed labs
            rk3288-veyron-jaq: 1 failed lab
            stih410-b2120: 1 failed lab
            sun4i-a10-cubieboard: 1 failed lab
            sun5i-a13-olinuxino-micro: 1 failed lab
            sun7i-a20-cubietruck: 1 failed lab
            sun8i-h2-plus-orangepi-zero: 1 failed lab
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
            exynos5800-peach-pi: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab
            mt7622-rfb1: 1 offline lab

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
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
