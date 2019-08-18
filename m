Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB5C919B9
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 23:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbfHRV0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 17:26:09 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:50583 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbfHRV0J (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 17:26:09 -0400
Received: by mail-wm1-f52.google.com with SMTP id v15so1297907wml.0
        for <stable@vger.kernel.org>; Sun, 18 Aug 2019 14:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=C66DRNkzbdUlzxkmwpPjcYbj7DluYTAUulJ7fIke34k=;
        b=xyAwUZRqeM9u1IDurmXhQttlQwJQaRpQmwb6g56pS5yKqzLyNnS3/973k5HDqpFOFx
         N6w0Yajv6L1Fv2GLmM6OVkk54rfIvhX3dElmqBlXJC8t7ASfIxRN2XTcAYKoUxUZ/fuX
         bqyLDjhVslqKsGQ32QxJiAX1zvLHE/VJ6D9bi3jkGW2iFjnNvg5Ns0XeHkabVchTObxE
         NhXyClnk2ZGUhZ1haAVYV0PRtgG5RTH3pDM2rZx47uC8cbP1dZdywbaI9MEHA+p44sAp
         nQg1sIqNbeP3gtWgtIetGeKSMdHIj7Db4/adKfhOkYcKOBzStVK3vF9e+OhTsRadfgPU
         355A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=C66DRNkzbdUlzxkmwpPjcYbj7DluYTAUulJ7fIke34k=;
        b=HLezbibNDcLIQ/f3llqhIReWJbRZWCu866x6oQ6FoSxzfFstz+DViYIEc7xpRR0Njd
         8uc45Z57jJFtw8FZHU9MDEuhBoqQdMbt5SsZL+pKk227hBksVA+HtO9125tUY6WzIo5/
         3RkjVpjhVJABl7vikdjoRCbiuS5oXEierqVIC4Uc7IuZgYWhEok0Y7thCClocQmUxBwA
         mNvn+b9hvySEbDtftPSgYCOIv87AosgpIQhUpBsa52M0xu+ACtFo/rk8LdWaw7hIzx1I
         I8UhCMxz8Ozk6G3s1sx1iZ/R6JD8f6ObWihaetTnBKldSksCGc6Y7SXxoOy0A/kr8IMZ
         mOTQ==
X-Gm-Message-State: APjAAAXh+RbslLx/nLYy41LNJ0D6mmW49bpZPfdc1WHZ01OYHd2NW5tp
        2zlv0G4NU8DYnfc7HLgo1pM2j5mqyUY=
X-Google-Smtp-Source: APXvYqy5rb+XvL6or1xR0dFTkGEvdjHeDyzDRDJxTkMf3YkDj2YUyuc6CsvuPrh2itZ8OWXspJJO8g==
X-Received: by 2002:a1c:e710:: with SMTP id e16mr17491925wmh.38.1566163565177;
        Sun, 18 Aug 2019 14:26:05 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g7sm40059wmh.1.2019.08.18.14.26.04
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Aug 2019 14:26:04 -0700 (PDT)
Message-ID: <5d59c26c.1c69fb81.6c778.030a@mx.google.com>
Date:   Sun, 18 Aug 2019 14:26:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.66-147-gc92b54ff2a17
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 69 boots: 69 failed,
 0 passed (v4.19.66-147-gc92b54ff2a17)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 69 boots: 69 failed, 0 passed (v4.19.66-147-gc=
92b54ff2a17)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.66-147-gc92b54ff2a17/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.66-147-gc92b54ff2a17/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.66-147-gc92b54ff2a17
Git Commit: c92b54ff2a170eb48c205760d8cbb391b1c100f1
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 36 unique boards, 17 SoC families, 13 builds out of 206

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2837-rpi-3-b:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)

    davinci_all_defconfig:
        gcc-8:
          da850-lcdk:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)

    exynos_defconfig:
        gcc-8:
          exynos4412-odroidx2:
              lab-collabora: new failure (last pass: v4.19.66-117-g060dc63c=
0495)
          exynos5250-snow:
              lab-collabora: new failure (last pass: v4.19.66-117-g060dc63c=
0495)
          exynos5422-odroidxu3:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)
              lab-collabora: new failure (last pass: v4.19.66-117-g060dc63c=
0495)

    imx_v6_v7_defconfig:
        gcc-8:
          imx6dl-riotboard:
              lab-pengutronix: new failure (last pass: v4.19.66-117-g060dc6=
3c0495)

    multi_v7_defconfig:
        gcc-8:
          exynos4412-odroidx2:
              lab-collabora: new failure (last pass: v4.19.66-117-g060dc63c=
0495)
          exynos5250-snow:
              lab-collabora: new failure (last pass: v4.19.66-117-g060dc63c=
0495)
          exynos5422-odroidxu3:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)
              lab-collabora: new failure (last pass: v4.19.66-117-g060dc63c=
0495)
          meson8b-odroidc1:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)
              lab-collabora: new failure (last pass: v4.19.66-117-g060dc63c=
0495)
          qemu:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)
              lab-mhart: new failure (last pass: v4.19.66-117-g060dc63c0495)
              lab-drue: new failure (last pass: v4.19.66-117-g060dc63c0495)
              lab-collabora: new failure (last pass: v4.19.66-117-g060dc63c=
0495)
          sun5i-a13-olinuxino-micro:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)
          sun7i-a20-cubietruck:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)
          sun8i-h2-plus-libretech-all-h3-cc:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)
          sun8i-h2-plus-orangepi-zero:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)
          sun8i-h3-libretech-all-h3-cc:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)
          tegra124-jetson-tk1:
              lab-mhart: new failure (last pass: v4.19.66-117-g060dc63c0495)
              lab-collabora: new failure (last pass: v4.19.66-117-g060dc63c=
0495)

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)
              lab-collabora: new failure (last pass: v4.19.66-117-g060dc63c=
0495)

    oxnas_v6_defconfig:
        gcc-8:
          ox820-cloudengines-pogoplug-series-3:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)

    sunxi_defconfig:
        gcc-8:
          sun5i-a13-olinuxino-micro:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)
          sun7i-a20-cubietruck:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)
          sun8i-h2-plus-libretech-all-h3-cc:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)
          sun8i-h2-plus-orangepi-zero:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)
          sun8i-h3-libretech-all-h3-cc:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)

    tegra_defconfig:
        gcc-8:
          tegra124-jetson-tk1:
              lab-mhart: new failure (last pass: v4.19.66-117-g060dc63c0495)
              lab-collabora: new failure (last pass: v4.19.66-117-g060dc63c=
0495)

arm64:

    defconfig:
        gcc-8:
          apq8016-sbc:
              lab-mhart: new failure (last pass: v4.19.66-117-g060dc63c0495)
          bcm2837-rpi-3-b:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)
              lab-mhart: new failure (last pass: v4.19.66-117-g060dc63c0495)
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)
          meson-gxl-s905x-libretech-cc:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)
          meson-gxm-khadas-vim2:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)
          qemu:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)
              lab-mhart: new failure (last pass: v4.19.66-117-g060dc63c0495)
              lab-drue: new failure (last pass: v4.19.66-117-g060dc63c0495)
              lab-collabora: new failure (last pass: v4.19.66-117-g060dc63c=
0495)
          r8a7796-m3ulcb:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)
              lab-collabora: new failure (last pass: v4.19.66-117-g060dc63c=
0495)
          rk3399-puma-haikou:
              lab-theobroma-systems: new failure (last pass: v4.19.66-117-g=
060dc63c0495)
          sun50i-h5-libretech-all-h3-cc:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)
          sun50i-h6-pine-h64:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)
          synquacer-acpi:
              lab-mhart: new failure (last pass: v4.19.66-117-g060dc63c0495)

i386:

    i386_defconfig:
        gcc-8:
          x86-celeron:
              lab-mhart: new failure (last pass: v4.19.66-117-g060dc63c0495)
          x86-pentium4:
              lab-mhart: new failure (last pass: v4.19.66-117-g060dc63c0495)

x86_64:

    x86_64_defconfig:
        gcc-8:
          minnowboard-turbot-E3826:
              lab-collabora: new failure (last pass: v4.19.66-117-g060dc63c=
0495)
          qemu:
              lab-baylibre: new failure (last pass: v4.19.66-117-g060dc63c0=
495)
              lab-mhart: new failure (last pass: v4.19.66-117-g060dc63c0495)
              lab-drue: new failure (last pass: v4.19.66-117-g060dc63c0495)
              lab-collabora: new failure (last pass: v4.19.66-117-g060dc63c=
0495)

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
            meson-gxl-s905x-khadas-vim: 1 failed lab
            meson-gxl-s905x-libretech-cc: 1 failed lab
            meson-gxm-khadas-vim2: 1 failed lab
            qemu: 4 failed labs
            r8a7796-m3ulcb: 2 failed labs
            rk3399-gru-kevin: 1 failed lab
            rk3399-puma-haikou: 1 failed lab
            sun50i-h5-libretech-all-h3-cc: 1 failed lab
            sun50i-h6-pine-h64: 1 failed lab
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
            qemu: 4 failed labs

arm:
    oxnas_v6_defconfig:
        gcc-8:
            ox820-cloudengines-pogoplug-series-3: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun5i-a13-olinuxino-micro: 1 failed lab
            sun7i-a20-cubietruck: 1 failed lab
            sun8i-h2-plus-libretech-all-h3-cc: 1 failed lab
            sun8i-h2-plus-orangepi-r1: 1 failed lab
            sun8i-h2-plus-orangepi-zero: 1 failed lab
            sun8i-h3-libretech-all-h3-cc: 1 failed lab

    imx_v6_v7_defconfig:
        gcc-8:
            imx6dl-riotboard: 1 failed lab

    bcm2835_defconfig:
        gcc-8:
            bcm2837-rpi-3-b: 1 failed lab

    omap2plus_defconfig:
        gcc-8:
            omap4-panda: 2 failed labs

    multi_v7_defconfig:
        gcc-8:
            exynos4412-odroidx2: 1 failed lab
            exynos5250-snow: 1 failed lab
            exynos5422-odroidxu3: 2 failed labs
            exynos5800-peach-pi: 1 failed lab
            imx6dl-riotboard: 1 failed lab
            imx6q-sabrelite: 1 failed lab
            meson8b-odroidc1: 1 failed lab
            omap4-panda: 2 failed labs
            qemu: 4 failed labs
            rk3288-veyron-jaq: 1 failed lab
            sun5i-a13-olinuxino-micro: 1 failed lab
            sun7i-a20-cubietruck: 1 failed lab
            sun8i-h2-plus-libretech-all-h3-cc: 1 failed lab
            sun8i-h2-plus-orangepi-r1: 1 failed lab
            sun8i-h2-plus-orangepi-zero: 1 failed lab
            sun8i-h3-libretech-all-h3-cc: 1 failed lab
            tegra124-jetson-tk1: 2 failed labs

    davinci_all_defconfig:
        gcc-8:
            da850-lcdk: 1 failed lab

    tegra_defconfig:
        gcc-8:
            tegra124-jetson-tk1: 2 failed labs

    exynos_defconfig:
        gcc-8:
            exynos4412-odroidx2: 1 failed lab
            exynos5250-snow: 1 failed lab
            exynos5422-odroidxu3: 2 failed labs
            exynos5800-peach-pi: 1 failed lab

---
For more info write to <info@kernelci.org>
