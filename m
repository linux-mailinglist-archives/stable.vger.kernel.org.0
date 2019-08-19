Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96FF391AB5
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 03:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbfHSB1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 21:27:35 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:42109 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfHSB1f (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 21:27:35 -0400
Received: by mail-wr1-f66.google.com with SMTP id b16so6917483wrq.9
        for <stable@vger.kernel.org>; Sun, 18 Aug 2019 18:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zHOcnOo8IANaW6QyZsWukiE6y1WBMD3uFvQOo7wdUEw=;
        b=GkRqV2/VpTANUhT3x7GECJF73hBrMMCB++RmBQDsWJUdUzifktCYLAHHVX88JaZWYX
         GKoyVWzw3jnFHj5oi8/9tZt0wO7VL3rh3WV9E8V4X+RYvXZYthOdGLPXiFL4livoCmzT
         KORN5p+982FLTe7HaBu4YbbZ1jJhHWeERpS5M+9NHUBVrqTB/TbF1D/hsKzPeYj4O3CB
         7Z4mMO+OkyOuAefBYGRhXKt02BVE76zpr8NwUgFH2g1Ro21JNIDcypVYNTRYqvJa8N5i
         8b2kx/CuNP3XBBjTG6fKuz+ZbaQKyziYJlAsVGE5rPQIZAi3jT8DVjr1XARsAuPzWy+W
         sI4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zHOcnOo8IANaW6QyZsWukiE6y1WBMD3uFvQOo7wdUEw=;
        b=ujNmkBvmoFKrf7zFQu4ds6b+3VzOh1+tfoZACPjGrSb+rEHfmjmU+8m7QHj74r4h58
         4OypRr1q+V5D52Rr0BibnZ2cEf4qY6HfK/y3tdsIw6P52bOMF1KgdGktJcUObVzj4LkC
         G733mU8pEOu70VwTEb41df/sZqh82Jg/VrCPo5UJYqMHtWifbGsTA/ZZSepqUNbrfx3m
         HRUI5Y7DH9YM5wDV0UCX/6o1W9mFploFHJ7pN3m5Nb/vkRFNSNWNhTlcL5VPOYN7dBHH
         x/k/W4q57L6Z1QiKtS/orna61/ksS9XN/lqoAf/y9Pi+cIsgl03eRxjeugNNnEsbuW0P
         Mr6g==
X-Gm-Message-State: APjAAAXmUbIlyzkZj7qcZ5ljVsZWkwZZE7Kvx+n5dfXMZn0O/px1UgFZ
        GjoAW3IUJNUbqG8FB1HXeG6DZF0UCnw=
X-Google-Smtp-Source: APXvYqyPYFRApdLwNoH4Ayhh+k7hnTka2HccnpG3hqV357wNloEehWJS6oHjOxJBse1foegZuYUSeg==
X-Received: by 2002:a5d:6981:: with SMTP id g1mr23071588wru.193.1566178051613;
        Sun, 18 Aug 2019 18:27:31 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g7sm13116491wmg.8.2019.08.18.18.27.30
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Aug 2019 18:27:31 -0700 (PDT)
Message-ID: <5d59fb03.1c69fb81.618a0.de92@mx.google.com>
Date:   Sun, 18 Aug 2019 18:27:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.66-161-g9e23c103b009
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y boot: 69 boots: 68 failed,
 0 passed with 1 untried/unknown (v4.19.66-161-g9e23c103b009)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 69 boots: 68 failed, 0 passed with 1 untried/u=
nknown (v4.19.66-161-g9e23c103b009)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.66-161-g9e23c103b009/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.66-161-g9e23c103b009/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.66-161-g9e23c103b009
Git Commit: 9e23c103b009ef3d113389e541b8a3e7b718b093
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 36 unique boards, 17 SoC families, 13 builds out of 206

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: failing since 1 day (last pass: v4.19.66-117-g0=
60dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2837-rpi-3-b:
              lab-baylibre: failing since 1 day (last pass: v4.19.66-117-g0=
60dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)

    davinci_all_defconfig:
        gcc-8:
          da850-lcdk:
              lab-baylibre: failing since 1 day (last pass: v4.19.66-117-g0=
60dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)

    exynos_defconfig:
        gcc-8:
          exynos4412-odroidx2:
              lab-collabora: failing since 1 day (last pass: v4.19.66-117-g=
060dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          exynos5250-snow:
              lab-collabora: failing since 1 day (last pass: v4.19.66-117-g=
060dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          exynos5422-odroidxu3:
              lab-baylibre: failing since 1 day (last pass: v4.19.66-117-g0=
60dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
              lab-collabora: failing since 1 day (last pass: v4.19.66-117-g=
060dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)

    imx_v6_v7_defconfig:
        gcc-8:
          imx6dl-riotboard:
              lab-pengutronix: failing since 1 day (last pass: v4.19.66-117=
-g060dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)

    multi_v7_defconfig:
        gcc-8:
          exynos4412-odroidx2:
              lab-collabora: failing since 1 day (last pass: v4.19.66-117-g=
060dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          exynos5250-snow:
              lab-collabora: failing since 1 day (last pass: v4.19.66-117-g=
060dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          exynos5422-odroidxu3:
              lab-baylibre: failing since 1 day (last pass: v4.19.66-117-g0=
60dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          meson8b-odroidc1:
              lab-baylibre: failing since 1 day (last pass: v4.19.66-117-g0=
60dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          omap4-panda:
              lab-baylibre: failing since 1 day (last pass: v4.19.66-117-g0=
60dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
              lab-collabora: failing since 1 day (last pass: v4.19.66-117-g=
060dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          qemu:
              lab-mhart: failing since 1 day (last pass: v4.19.66-117-g060d=
c63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
              lab-drue: failing since 1 day (last pass: v4.19.66-117-g060dc=
63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          sun5i-a13-olinuxino-micro:
              lab-baylibre: failing since 1 day (last pass: v4.19.66-117-g0=
60dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          sun7i-a20-cubietruck:
              lab-baylibre: failing since 1 day (last pass: v4.19.66-117-g0=
60dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          sun8i-h2-plus-libretech-all-h3-cc:
              lab-baylibre: failing since 1 day (last pass: v4.19.66-117-g0=
60dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: failing since 1 day (last pass: v4.19.66-117-g0=
60dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          sun8i-h2-plus-orangepi-zero:
              lab-baylibre: failing since 1 day (last pass: v4.19.66-117-g0=
60dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          sun8i-h3-libretech-all-h3-cc:
              lab-baylibre: failing since 1 day (last pass: v4.19.66-117-g0=
60dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          tegra124-jetson-tk1:
              lab-mhart: failing since 1 day (last pass: v4.19.66-117-g060d=
c63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
              lab-collabora: failing since 1 day (last pass: v4.19.66-117-g=
060dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)

    omap2plus_defconfig:
        gcc-8:
          omap4-panda:
              lab-baylibre: failing since 1 day (last pass: v4.19.66-117-g0=
60dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
              lab-collabora: failing since 1 day (last pass: v4.19.66-117-g=
060dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)

    oxnas_v6_defconfig:
        gcc-8:
          ox820-cloudengines-pogoplug-series-3:
              lab-baylibre: failing since 1 day (last pass: v4.19.66-117-g0=
60dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)

    sunxi_defconfig:
        gcc-8:
          sun5i-a13-olinuxino-micro:
              lab-baylibre: failing since 1 day (last pass: v4.19.66-117-g0=
60dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          sun7i-a20-cubietruck:
              lab-baylibre: failing since 1 day (last pass: v4.19.66-117-g0=
60dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          sun8i-h2-plus-libretech-all-h3-cc:
              lab-baylibre: failing since 1 day (last pass: v4.19.66-117-g0=
60dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: failing since 1 day (last pass: v4.19.66-117-g0=
60dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          sun8i-h2-plus-orangepi-zero:
              lab-baylibre: failing since 1 day (last pass: v4.19.66-117-g0=
60dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          sun8i-h3-libretech-all-h3-cc:
              lab-baylibre: failing since 1 day (last pass: v4.19.66-117-g0=
60dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)

    tegra_defconfig:
        gcc-8:
          tegra124-jetson-tk1:
              lab-mhart: failing since 1 day (last pass: v4.19.66-117-g060d=
c63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
              lab-collabora: failing since 1 day (last pass: v4.19.66-117-g=
060dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)

arm64:

    defconfig:
        gcc-8:
          apq8016-sbc:
              lab-mhart: failing since 1 day (last pass: v4.19.66-117-g060d=
c63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          bcm2837-rpi-3-b:
              lab-baylibre: failing since 1 day (last pass: v4.19.66-117-g0=
60dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
              lab-mhart: failing since 1 day (last pass: v4.19.66-117-g060d=
c63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          meson-gxbb-p200:
              lab-baylibre: failing since 1 day (last pass: v4.19.66-117-g0=
60dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          meson-gxl-s905x-libretech-cc:
              lab-baylibre: failing since 1 day (last pass: v4.19.66-117-g0=
60dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          meson-gxm-khadas-vim2:
              lab-baylibre: failing since 1 day (last pass: v4.19.66-117-g0=
60dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          qemu:
              lab-mhart: failing since 1 day (last pass: v4.19.66-117-g060d=
c63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
              lab-drue: failing since 1 day (last pass: v4.19.66-117-g060dc=
63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
              lab-collabora: failing since 1 day (last pass: v4.19.66-117-g=
060dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          r8a7796-m3ulcb:
              lab-baylibre: failing since 1 day (last pass: v4.19.66-117-g0=
60dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
              lab-collabora: failing since 1 day (last pass: v4.19.66-117-g=
060dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          sun50i-h5-libretech-all-h3-cc:
              lab-baylibre: failing since 1 day (last pass: v4.19.66-117-g0=
60dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          sun50i-h6-pine-h64:
              lab-baylibre: failing since 1 day (last pass: v4.19.66-117-g0=
60dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          synquacer-acpi:
              lab-mhart: failing since 1 day (last pass: v4.19.66-117-g060d=
c63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)

i386:

    i386_defconfig:
        gcc-8:
          x86-celeron:
              lab-mhart: failing since 1 day (last pass: v4.19.66-117-g060d=
c63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          x86-pentium4:
              lab-mhart: failing since 1 day (last pass: v4.19.66-117-g060d=
c63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)

x86_64:

    x86_64_defconfig:
        gcc-8:
          minnowboard-turbot-E3826:
              lab-collabora: failing since 1 day (last pass: v4.19.66-117-g=
060dc63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
          qemu:
              lab-mhart: failing since 1 day (last pass: v4.19.66-117-g060d=
c63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)
              lab-drue: failing since 1 day (last pass: v4.19.66-117-g060dc=
63c0495 - first fail: v4.19.66-147-gc92b54ff2a17)

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
