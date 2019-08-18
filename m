Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC57191992
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 22:43:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfHRUn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 16:43:57 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37818 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726042AbfHRUn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 16:43:57 -0400
Received: by mail-wr1-f68.google.com with SMTP id z11so6584707wrt.4
        for <stable@vger.kernel.org>; Sun, 18 Aug 2019 13:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=eAP7UUqYHZuVDXFzeQ32duPdyaTeT0F2LHgdn6Bvms0=;
        b=VK0uDRl34e559cARFYpOyJMWvEU5HB25s9G44FFc5OuWSmiTn8gPlDJdIEE1ANzpGb
         iVuSa/hIbe9dVLs4OehwBBwYRrxVAcW2EriM0Q7w1RquQXnYPezyLs9rux9mmOserDJv
         LmKSSsNQB+RtCwZ926eDtGtOKG23tnk/ulgtowTJfvQSJ+D3hkwHhX1QhaBmmF/6JQBM
         p0Xmv8S83n6WiDWBcf3zDe59KLjGSKVrcS+NAWVwcpqci9gWTcqSxIgvBYW3u2b/JKQb
         weeAO1/7fUOqk6Ll9AB1iq3tFMFrTQPPdpn/GQRFSNmMotw3pNEPQULBoWOGB0MioU9J
         770A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=eAP7UUqYHZuVDXFzeQ32duPdyaTeT0F2LHgdn6Bvms0=;
        b=RqEuN6ltQo96j4HQ69U9RBcDAe0lEOKWc+63EUeJ1HtCl/tnlxp2MUxumO9n6pUCum
         I/kgfyXhF/2JLFgBkl/eksNUjAu8zKKDPu2ntMGPg06MqiYGRWE9WqlmPfMwhvGM0elu
         MCBP/DdoIBJf1AaYKWXD0wevm5ZrwsAVXREKPB2zzI8YmgVNyLXCD+wxCyTB9juB9hOH
         0nU/UbJWgN6fdfYejmc8dA5JEbvXV/LRKvlbcJEIQJg/UmUoyzPEsZkFlKP3Bqo4CQvq
         DI0tocC+WmLQFtsAq6LMxWoVBSGDHp/QhQ3Zijpezh+Do8i9bISBJtKe1vJDFjiBXr2A
         TiTg==
X-Gm-Message-State: APjAAAVO15t2Vf6Jq+iVe8cu6hCQbiA5sS0/CT7ODpsEM73TzSrh7GUg
        2bJZURufWUpeq9ofd0ntRGimjd3hn9g=
X-Google-Smtp-Source: APXvYqxPT22IbXM5pjuBuxG/hi7KA6a+BG8MaW9HqKLPypN6MFsGGkaxjOTC7wS1w8PnpMf34Xe0dw==
X-Received: by 2002:a05:6000:128d:: with SMTP id f13mr23510395wrx.241.1566161033811;
        Sun, 18 Aug 2019 13:43:53 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t8sm34097772wra.73.2019.08.18.13.43.53
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Aug 2019 13:43:53 -0700 (PDT)
Message-ID: <5d59b889.1c69fb81.5bc75.4610@mx.google.com>
Date:   Sun, 18 Aug 2019 13:43:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.8-237-g61d06c60569f
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 73 boots: 72 failed,
 0 passed with 1 untried/unknown (v5.2.8-237-g61d06c60569f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 73 boots: 72 failed, 0 passed with 1 untried/un=
known (v5.2.8-237-g61d06c60569f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.8-237-g61d06c60569f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.8-237-g61d06c60569f/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.8-237-g61d06c60569f
Git Commit: 61d06c60569fc8034ceb181649fca58350b83012
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 39 unique boards, 17 SoC families, 13 builds out of 209

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v5.2.8-177-gfd570399d29=
b)

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2837-rpi-3-b:
              lab-baylibre: new failure (last pass: v5.2.8-157-g9e53d01dff5=
8)

    davinci_all_defconfig:
        gcc-8:
          da850-lcdk:
              lab-baylibre: new failure (last pass: v5.2.8-157-g9e53d01dff5=
8)

    exynos_defconfig:
        gcc-8:
          exynos4412-odroidx2:
              lab-collabora: new failure (last pass: v5.2.8-157-g9e53d01dff=
58)
          exynos5250-snow:
              lab-collabora: new failure (last pass: v5.2.8-157-g9e53d01dff=
58)
          exynos5422-odroidxu3:
              lab-baylibre: new failure (last pass: v5.2.8-157-g9e53d01dff5=
8)
              lab-collabora: new failure (last pass: v5.2.8-157-g9e53d01dff=
58)
          exynos5800-peach-pi:
              lab-collabora: new failure (last pass: v5.2.8-157-g9e53d01dff=
58)

    imx_v6_v7_defconfig:
        gcc-8:
          imx6dl-riotboard:
              lab-pengutronix: new failure (last pass: v5.2.8-157-g9e53d01d=
ff58)

    multi_v7_defconfig:
        gcc-8:
          am57xx-beagle-x15:
              lab-drue: new failure (last pass: v5.2.8-157-g9e53d01dff58)
          exynos4412-odroidx2:
              lab-collabora: new failure (last pass: v5.2.8-157-g9e53d01dff=
58)
          exynos5250-snow:
              lab-collabora: new failure (last pass: v5.2.8-157-g9e53d01dff=
58)
          exynos5422-odroidxu3:
              lab-baylibre: new failure (last pass: v5.2.8-157-g9e53d01dff5=
8)
              lab-collabora: new failure (last pass: v5.2.8-157-g9e53d01dff=
58)
          exynos5800-peach-pi:
              lab-collabora: new failure (last pass: v5.2.8-157-g9e53d01dff=
58)
          imx6dl-riotboard:
              lab-pengutronix: new failure (last pass: v5.2.8-157-g9e53d01d=
ff58)
          imx6q-sabrelite:
              lab-collabora: new failure (last pass: v5.2.8-157-g9e53d01dff=
58)
          meson8b-odroidc1:
              lab-baylibre: new failure (last pass: v5.2.8-157-g9e53d01dff5=
8)
          omap4-panda:
              lab-baylibre: new failure (last pass: v5.2.8-157-g9e53d01dff5=
8)
              lab-collabora: new failure (last pass: v5.2.8-157-g9e53d01dff=
58)
          qemu:
              lab-baylibre: new failure (last pass: v5.2.8-157-g9e53d01dff5=
8)
              lab-mhart: new failure (last pass: v5.2.8-157-g9e53d01dff58)
              lab-drue: new failure (last pass: v5.2.8-157-g9e53d01dff58)
              lab-collabora: new failure (last pass: v5.2.8-157-g9e53d01dff=
58)
          rk3288-veyron-jaq:
              lab-collabora: new failure (last pass: v5.2.8-157-g9e53d01dff=
58)
          sun5i-a13-olinuxino-micro:
              lab-baylibre: new failure (last pass: v5.2.8-157-g9e53d01dff5=
8)
          sun7i-a20-cubietruck:
              lab-baylibre: new failure (last pass: v5.2.8-157-g9e53d01dff5=
8)
          sun8i-h2-plus-libretech-all-h3-cc:
              lab-baylibre: new failure (last pass: v5.2.8-157-g9e53d01dff5=
8)
          sun8i-h2-plus-orangepi-zero:
              lab-baylibre: new failure (last pass: v5.2.8-157-g9e53d01dff5=
8)
          sun8i-h3-libretech-all-h3-cc:
              lab-baylibre: new failure (last pass: v5.2.8-157-g9e53d01dff5=
8)
          tegra124-jetson-tk1:
              lab-mhart: new failure (last pass: v5.2.8-157-g9e53d01dff58)
              lab-collabora: new failure (last pass: v5.2.8-157-g9e53d01dff=
58)

    omap2plus_defconfig:
        gcc-8:
          am57xx-beagle-x15:
              lab-drue: new failure (last pass: v5.2.8-157-g9e53d01dff58)
          omap4-panda:
              lab-baylibre: new failure (last pass: v5.2.8-157-g9e53d01dff5=
8)
              lab-collabora: new failure (last pass: v5.2.8-157-g9e53d01dff=
58)

    oxnas_v6_defconfig:
        gcc-8:
          ox820-cloudengines-pogoplug-series-3:
              lab-baylibre: new failure (last pass: v5.2.8-157-g9e53d01dff5=
8)

    sunxi_defconfig:
        gcc-8:
          sun5i-a13-olinuxino-micro:
              lab-baylibre: new failure (last pass: v5.2.8-157-g9e53d01dff5=
8)
          sun7i-a20-cubietruck:
              lab-baylibre: new failure (last pass: v5.2.8-157-g9e53d01dff5=
8)
          sun8i-h2-plus-libretech-all-h3-cc:
              lab-baylibre: new failure (last pass: v5.2.8-157-g9e53d01dff5=
8)
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v5.2.8-157-g9e53d01dff5=
8)
          sun8i-h2-plus-orangepi-zero:
              lab-baylibre: new failure (last pass: v5.2.8-157-g9e53d01dff5=
8)
          sun8i-h3-libretech-all-h3-cc:
              lab-baylibre: new failure (last pass: v5.2.8-157-g9e53d01dff5=
8)

    tegra_defconfig:
        gcc-8:
          tegra124-jetson-tk1:
              lab-mhart: new failure (last pass: v5.2.8-157-g9e53d01dff58)
              lab-collabora: new failure (last pass: v5.2.8-157-g9e53d01dff=
58)

arm64:

    defconfig:
        gcc-8:
          apq8016-sbc:
              lab-mhart: new failure (last pass: v5.2.8-177-gfd570399d29b)
          bcm2837-rpi-3-b:
              lab-baylibre: new failure (last pass: v5.2.8-177-gfd570399d29=
b)
              lab-mhart: new failure (last pass: v5.2.8-177-gfd570399d29b)
          meson-g12a-sei510:
              lab-baylibre: new failure (last pass: v5.2.8-177-gfd570399d29=
b)
          meson-g12a-x96-max:
              lab-baylibre: new failure (last pass: v5.2.8-177-gfd570399d29=
b)
          meson-gxbb-p200:
              lab-baylibre: new failure (last pass: v5.2.8-177-gfd570399d29=
b)
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: new failure (last pass: v5.2.8-177-gfd570399d29=
b)
          meson-gxl-s905x-libretech-cc:
              lab-baylibre: new failure (last pass: v5.2.8-177-gfd570399d29=
b)
          meson-gxm-khadas-vim2:
              lab-baylibre: new failure (last pass: v5.2.8-177-gfd570399d29=
b)
          qemu:
              lab-baylibre: new failure (last pass: v5.2.8-177-gfd570399d29=
b)
              lab-mhart: new failure (last pass: v5.2.8-177-gfd570399d29b)
              lab-drue: new failure (last pass: v5.2.8-177-gfd570399d29b)
              lab-collabora: new failure (last pass: v5.2.8-177-gfd570399d2=
9b)
          r8a7796-m3ulcb:
              lab-baylibre: new failure (last pass: v5.2.8-177-gfd570399d29=
b)
              lab-collabora: new failure (last pass: v5.2.8-177-gfd570399d2=
9b)
          rk3399-gru-kevin:
              lab-collabora: failing since 1 day (last pass: v5.2.8-157-g9e=
53d01dff58 - first fail: v5.2.8-177-gfd570399d29b)
          sun50i-h5-libretech-all-h3-cc:
              lab-baylibre: new failure (last pass: v5.2.8-177-gfd570399d29=
b)
          sun50i-h6-pine-h64:
              lab-baylibre: new failure (last pass: v5.2.8-177-gfd570399d29=
b)
          synquacer-acpi:
              lab-mhart: new failure (last pass: v5.2.8-177-gfd570399d29b)

i386:

    i386_defconfig:
        gcc-8:
          x86-celeron:
              lab-mhart: new failure (last pass: v5.2.8-177-gfd570399d29b)
          x86-pentium4:
              lab-mhart: new failure (last pass: v5.2.8-177-gfd570399d29b)

x86_64:

    x86_64_defconfig:
        gcc-8:
          minnowboard-turbot-E3826:
              lab-collabora: new failure (last pass: v5.2.8-177-gfd570399d2=
9b)
          qemu:
              lab-baylibre: new failure (last pass: v5.2.8-177-gfd570399d29=
b)
              lab-mhart: new failure (last pass: v5.2.8-177-gfd570399d29b)
              lab-drue: new failure (last pass: v5.2.8-177-gfd570399d29b)
              lab-collabora: new failure (last pass: v5.2.8-177-gfd570399d2=
9b)

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
            meson-g12a-sei510: 1 failed lab
            meson-g12a-x96-max: 1 failed lab
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
            am57xx-beagle-x15: 1 failed lab
            omap4-panda: 2 failed labs

    multi_v7_defconfig:
        gcc-8:
            am57xx-beagle-x15: 1 failed lab
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
