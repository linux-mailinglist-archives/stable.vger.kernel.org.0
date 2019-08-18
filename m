Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8097919A6
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 23:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbfHRVMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 17:12:22 -0400
Received: from mail-wr1-f42.google.com ([209.85.221.42]:46568 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbfHRVMV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 17:12:21 -0400
Received: by mail-wr1-f42.google.com with SMTP id z1so6596895wru.13
        for <stable@vger.kernel.org>; Sun, 18 Aug 2019 14:12:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LrLnFjgD9ezkwgqIAhWCBVlobYp0D2aTW1E2F1YBmww=;
        b=iJEb1alHPisZGXlymt6Ew06tz/MDy5ivqblgJBLo+kIfVQKYuzR6KLBdOqWuszUfyY
         YM1G4GvVzqDeu3NtmJMsHjlOzVETLcSPPvh6PdRQ71C0bdEherz07fbJ4pP1gAepPcM6
         e4D5fD2H3PLv9Igm11ct5/p0Og6TzP4ykg0HIEqaGMniYGgCidGLR9gqiUhswF0f+DtR
         jbps0HNY9tLztf1zMcdOs9Lr9H6E2hYNuJx+zjjTV94ghL6gfvSaAP9/gM71JPWYGaJT
         Gpgxc26ZrBKhDZIw8xK49oqsFP1nf1p6tFeqzRyTOrxfiHjQ/pOmFgfr+YUWtda9ZNvg
         JuaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LrLnFjgD9ezkwgqIAhWCBVlobYp0D2aTW1E2F1YBmww=;
        b=iZk/NSY4TNhPoY17WHbZptIVBTOGzrq0e4iBwmU87DK8HjHlDRTo1+oOdhguPsM5XJ
         8aBh0dgKajjEbVxF5sEO/J/jfjXaQQGhdyx6g/Ggp976tYME1TWd/RHf6U0Xax/RtFTH
         LTKszNjqFQLBj0rThgvAp8Hiou37tmJL8NGRzJHwcOhFYgjq3FktMs4cgrfhZ57UkRsP
         dqF8eG1ZR7Lysyjd4SYj4HUt0jeIEUR4sxfPRRTlvj77sVNSA8XPrxVI/O++VWv4gt20
         wVUuQ0mqhlESGKdJEsQzTNq/L+L6+0DcYZO/8D9EL0BeMpdGqPX4VAAQEi7D+Ge6yZ2G
         CMRg==
X-Gm-Message-State: APjAAAUztlmJNDYYOxaivUquJ8HCjDFxXtQX45+z75jtkemHLRvZLEwl
        0+jIsdM1oujngWcDio1G7DodbouZ+H4=
X-Google-Smtp-Source: APXvYqxcEFZ8o0YMHjMC3PS9cyMaMXyKuRVulcV+nfM2k43oLCMIvLcaFcS9LxvYiQOy7gGJLzyHcw==
X-Received: by 2002:adf:ab18:: with SMTP id q24mr21178018wrc.354.1566162736686;
        Sun, 18 Aug 2019 14:12:16 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id i30sm10311942wmb.20.2019.08.18.14.12.15
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Aug 2019 14:12:16 -0700 (PDT)
Message-ID: <5d59bf30.1c69fb81.5b6a1.0849@mx.google.com>
Date:   Sun, 18 Aug 2019 14:12:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.138-113-gbe36e71554f9
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 122 boots: 107 failed,
 0 passed with 15 offline (v4.14.138-113-gbe36e71554f9)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 122 boots: 107 failed, 0 passed with 15 offlin=
e (v4.14.138-113-gbe36e71554f9)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.138-113-gbe36e71554f9/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.138-113-gbe36e71554f9/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.138-113-gbe36e71554f9
Git Commit: be36e71554f996d29cc256dab1d8e0b1f3a1d25e
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
              lab-baylibre: new failure (last pass: v4.14.138-91-g248e04a69=
071)

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          da850-lcdk:
              lab-baylibre: new failure (last pass: v4.14.138-91-g248e04a69=
071)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)

    exynos_defconfig:
        gcc-8:
          exynos4412-odroidx2:
              lab-collabora: new failure (last pass: v4.14.138-91-g248e04a6=
9071)
          exynos5250-arndale:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          exynos5250-snow:
              lab-collabora: new failure (last pass: v4.14.138-91-g248e04a6=
9071)
          exynos5420-arndale-octa:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          exynos5422-odroidxu3:
              lab-baylibre: new failure (last pass: v4.14.138-91-g248e04a69=
071)
              lab-collabora: new failure (last pass: v4.14.138-91-g248e04a6=
9071)
          exynos5800-peach-pi:
              lab-collabora: new failure (last pass: v4.14.138-91-g248e04a6=
9071)
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)

    imx_v6_v7_defconfig:
        gcc-8:
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          imx6q-wandboard:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          imx7s-warp:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          vf610-colibri-eval-v3:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)

    multi_v7_defconfig:
        gcc-8:
          alpine-db:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          armada-xp-openblocks-ax3-4:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          at91-sama5d4_xplained:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          exynos4412-odroidx2:
              lab-collabora: new failure (last pass: v4.14.138-91-g248e04a6=
9071)
          exynos5250-arndale:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          exynos5250-snow:
              lab-collabora: new failure (last pass: v4.14.138-91-g248e04a6=
9071)
          exynos5420-arndale-octa:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          exynos5422-odroidxu3:
              lab-baylibre: new failure (last pass: v4.14.138-91-g248e04a69=
071)
              lab-collabora: new failure (last pass: v4.14.138-91-g248e04a6=
9071)
          exynos5800-peach-pi:
              lab-collabora: new failure (last pass: v4.14.138-91-g248e04a6=
9071)
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          imx6dl-riotboard:
              lab-pengutronix: new failure (last pass: v4.14.138-91-g248e04=
a69071)
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          imx6q-sabrelite:
              lab-collabora: new failure (last pass: v4.14.138-91-g248e04a6=
9071)
          imx6q-wandboard:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          imx7s-warp:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          meson8b-odroidc1:
              lab-baylibre: new failure (last pass: v4.14.138-91-g248e04a69=
071)
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          mt7623n-bananapi-bpi-r2:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          omap3-beagle:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.14.138-91-g248e04a69=
071)
              lab-collabora: new failure (last pass: v4.14.138-91-g248e04a6=
9071)
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          qemu:
              lab-baylibre: new failure (last pass: v4.14.138-91-g248e04a69=
071)
              lab-linaro-lkft: new failure (last pass: v4.14.138-91-g248e04=
a69071)
              lab-mhart: new failure (last pass: v4.14.138-91-g248e04a69071)
              lab-drue: new failure (last pass: v4.14.138-91-g248e04a69071)
              lab-collabora: new failure (last pass: v4.14.138-91-g248e04a6=
9071)
          rk3288-veyron-jaq:
              lab-collabora: new failure (last pass: v4.14.138-91-g248e04a6=
9071)
          socfpga_cyclone5_de0_sockit:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          stih410-b2120:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          sun5i-a13-olinuxino-micro:
              lab-baylibre: new failure (last pass: v4.14.138-91-g248e04a69=
071)
          sun5i-r8-chip:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          sun7i-a20-cubietruck:
              lab-baylibre: new failure (last pass: v4.14.138-91-g248e04a69=
071)
          sun8i-h2-plus-orangepi-zero:
              lab-baylibre: new failure (last pass: v4.14.138-91-g248e04a69=
071)
          tegra124-jetson-tk1:
              lab-mhart: new failure (last pass: v4.14.138-91-g248e04a69071)
              lab-collabora: new failure (last pass: v4.14.138-91-g248e04a6=
9071)
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          tegra30-beaver:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          vf610-colibri-eval-v3:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          zynq-zc702:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)

    mvebu_v7_defconfig:
        gcc-8:
          armada-xp-openblocks-ax3-4:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.14.138-91-g248e04a69=
071)
              lab-collabora: new failure (last pass: v4.14.138-91-g248e04a6=
9071)
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 3 days (last pass: v4.14.=
138 - first fail: v4.14.138-70-g736c2f07319a)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 3 days (last pass: v4.14.=
138 - first fail: v4.14.138-70-g736c2f07319a)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
38-73-g1a4682459a61 - first fail: v4.14.138-91-g248e04a69071)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          sun5i-a13-olinuxino-micro:
              lab-baylibre: new failure (last pass: v4.14.138-91-g248e04a69=
071)
          sun5i-r8-chip:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          sun7i-a20-cubietruck:
              lab-baylibre: new failure (last pass: v4.14.138-91-g248e04a69=
071)
          sun8i-h2-plus-orangepi-zero:
              lab-baylibre: new failure (last pass: v4.14.138-91-g248e04a69=
071)

    tegra_defconfig:
        gcc-8:
          tegra124-jetson-tk1:
              lab-mhart: new failure (last pass: v4.14.138-91-g248e04a69071)
              lab-collabora: new failure (last pass: v4.14.138-91-g248e04a6=
9071)
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          tegra30-beaver:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)

arm64:

    defconfig:
        gcc-8:
          apq8016-sbc:
              lab-mhart: new failure (last pass: v4.14.138-91-g248e04a69071)
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          bcm2837-rpi-3-b:
              lab-baylibre: new failure (last pass: v4.14.138-91-g248e04a69=
071)
              lab-mhart: new failure (last pass: v4.14.138-91-g248e04a69071)
          juno-r2:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          meson-gxbb-nanopi-k2:
              lab-baylibre: new failure (last pass: v4.14.138-91-g248e04a69=
071)
          meson-gxbb-odroidc2:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          meson-gxl-s905d-p230:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: new failure (last pass: v4.14.138-91-g248e04a69=
071)
          meson-gxl-s905x-libretech-cc:
              lab-baylibre: new failure (last pass: v4.14.138-91-g248e04a69=
071)
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          meson-gxl-s905x-nexbox-a95x:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          meson-gxl-s905x-p212:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          meson-gxm-nexbox-a1:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          mt7622-rfb1:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          qemu:
              lab-baylibre: new failure (last pass: v4.14.138-91-g248e04a69=
071)
              lab-linaro-lkft: new failure (last pass: v4.14.138-91-g248e04=
a69071)
              lab-mhart: new failure (last pass: v4.14.138-91-g248e04a69071)
              lab-drue: new failure (last pass: v4.14.138-91-g248e04a69071)
              lab-collabora: new failure (last pass: v4.14.138-91-g248e04a6=
9071)
          r8a7796-m3ulcb:
              lab-baylibre: new failure (last pass: v4.14.138-91-g248e04a69=
071)
              lab-collabora: new failure (last pass: v4.14.138-91-g248e04a6=
9071)
          rk3399-firefly:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          rk3399-gru-kevin:
              lab-collabora: new failure (last pass: v4.14.138-91-g248e04a6=
9071)
          rk3399-puma-haikou:
              lab-theobroma-systems: new failure (last pass: v4.14.138-91-g=
248e04a69071)
          sun50i-a64-pine64-plus:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)
          synquacer-acpi:
              lab-mhart: new failure (last pass: v4.14.138-91-g248e04a69071)

i386:

    i386_defconfig:
        gcc-8:
          x86-celeron:
              lab-mhart: new failure (last pass: v4.14.138-91-g248e04a69071)
          x86-pentium4:
              lab-mhart: new failure (last pass: v4.14.138-91-g248e04a69071)

mips:

    pistachio_defconfig:
        gcc-8:
          pistachio_marduk:
              lab-baylibre-seattle: new failure (last pass: v4.14.138-91-g2=
48e04a69071)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu:
              lab-baylibre: new failure (last pass: v4.14.138-91-g248e04a69=
071)
              lab-linaro-lkft: new failure (last pass: v4.14.138-91-g248e04=
a69071)
              lab-mhart: new failure (last pass: v4.14.138-91-g248e04a69071)
              lab-drue: new failure (last pass: v4.14.138-91-g248e04a69071)
              lab-collabora: new failure (last pass: v4.14.138-91-g248e04a6=
9071)

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
            sun7i-a20-bananapi: 1 failed lab
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
            exynos5800-peach-pi: 2 failed labs

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
