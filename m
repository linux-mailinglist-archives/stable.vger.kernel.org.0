Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4471F91A9F
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 03:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbfHSBUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 21:20:19 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:51311 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfHSBUT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 21:20:19 -0400
Received: by mail-wm1-f44.google.com with SMTP id 207so137996wma.1
        for <stable@vger.kernel.org>; Sun, 18 Aug 2019 18:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3M9HfCNuylapP5fC6fm7aDf2+shf254I7aoQ9e1bE0A=;
        b=frUd8J9Zd7Z8hY7SME2P4sPrfUtQ8wxYAuuClaMEF97x9ypr3B6qQMPoDn/GF87bVz
         Z3C0wpo20jOrfaVvrSY3MjsQZUkmKJdp3RaKat8lA+mQamxyWZ20rPVfJbA2fFYSVXOR
         EIoGYaCPQBcQM/viHUUQ4/mNTnLc/OOsebNd9XdC4VR3/nSKUqyd2BUBTxuno5QZ1veZ
         T8FOLTFG1wLNyb0rNuZcMbx5sC84WPT427/hJOie5asZKse3FkwGibbQEDtvrEjlGvp/
         wcargPYcl5r25fK2BxhP9SklQqfc+IdMfv55Jq236lVVbJRMgC6XPLmfJ8A3C1uopvpF
         6MmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3M9HfCNuylapP5fC6fm7aDf2+shf254I7aoQ9e1bE0A=;
        b=IDVNjwCzBMyb3d/XvvQImTwXG53XyPr7CFx7TfbhR5IMd8sufQRH9L4ZT1U1kf0Ao7
         6XTtuZHf8t0Kq4ldinq0AeqSJGScBKl0jUBBZ+wEh70YXg48pnXZqSEy4+T07TnrmXZj
         NGP90DQrPee8Y+uHdprLr9ovr9W26bSxZ/K+ZDsX5adb8YY/91BJ1vJge3Vy3/a/W/+j
         1SGyoNPWFLV1StEQR1NVumJ3TNszvhL4A1qRFJTRpouTB0BbU/QJ7CrJGqppS15DMdfn
         5V3q+wMY96PTF9Y32NeHCUAjP+/tC632wD+yDoTJ9sHvN6kx0OEdENuGObeRqM2CZEqr
         isbg==
X-Gm-Message-State: APjAAAWvBjWoF3Lp+NXlVzWlpkzg8lVCz1/I1hiR/m+WrtuwuR13+FUj
        FLVk15Y9EyjJTRaNpsq5y4pIzHfzHpE=
X-Google-Smtp-Source: APXvYqwkFWK+j3wnjGzUf+Ci55cVI2PHtYK4NEJgmOIrJjvtSKi+FMz2WGbhLyl7/AY6aGf4YwPXMQ==
X-Received: by 2002:a1c:c78d:: with SMTP id x135mr17354122wmf.82.1566177613937;
        Sun, 18 Aug 2019 18:20:13 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f18sm13508354wrx.85.2019.08.18.18.20.13
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Aug 2019 18:20:13 -0700 (PDT)
Message-ID: <5d59f94d.1c69fb81.9b1e1.1c9d@mx.google.com>
Date:   Sun, 18 Aug 2019 18:20:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.189-94-gb32df2b548e7
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 103 boots: 88 failed,
 0 passed with 15 offline (v4.9.189-94-gb32df2b548e7)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 103 boots: 88 failed, 0 passed with 15 offline =
(v4.9.189-94-gb32df2b548e7)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.189-94-gb32df2b548e7/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.189-94-gb32df2b548e7/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.189-94-gb32df2b548e7
Git Commit: b32df2b548e71a103d14d8735c392dc063ed612c
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
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          da850-lcdk:
              lab-baylibre: failing since 1 day (last pass: v4.9.189-69-g71=
1554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          dm365evm,legacy:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)

    exynos_defconfig:
        gcc-8:
          exynos4412-odroidx2:
              lab-collabora: failing since 1 day (last pass: v4.9.189-44-g7=
55768e31f44 - first fail: v4.9.189-84-gfe210ed24b65)
          exynos5250-arndale:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          exynos5250-snow:
              lab-collabora: failing since 1 day (last pass: v4.9.189-69-g7=
11554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          exynos5420-arndale-octa:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          exynos5422-odroidxu3:
              lab-baylibre: failing since 1 day (last pass: v4.9.189-69-g71=
1554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
              lab-collabora: failing since 1 day (last pass: v4.9.189-69-g7=
11554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          exynos5800-peach-pi:
              lab-collabora: failing since 1 day (last pass: v4.9.189-69-g7=
11554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)

    imx_v6_v7_defconfig:
        gcc-8:
          imx6dl-riotboard:
              lab-pengutronix: failing since 1 day (last pass: v4.9.189-69-=
g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          imx6q-wandboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          imx7s-warp:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          vf610-colibri-eval-v3:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)

    multi_v7_defconfig:
        gcc-8:
          alpine-db:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          armada-xp-openblocks-ax3-4:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          at91-sama5d4_xplained:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          bcm4708-smartrg-sr400ac:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          bcm72521-bcm97252sffe:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          bcm7445-bcm97445c:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          exynos4412-odroidx2:
              lab-collabora: failing since 1 day (last pass: v4.9.189-69-g7=
11554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          exynos5250-arndale:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          exynos5250-snow:
              lab-collabora: failing since 1 day (last pass: v4.9.189-69-g7=
11554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          exynos5420-arndale-octa:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          exynos5422-odroidxu3:
              lab-baylibre: failing since 1 day (last pass: v4.9.189-69-g71=
1554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
              lab-collabora: failing since 1 day (last pass: v4.9.189-69-g7=
11554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          exynos5800-peach-pi:
              lab-collabora: failing since 1 day (last pass: v4.9.189-44-g7=
55768e31f44 - first fail: v4.9.189-69-g711554dc8b12)
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          imx6dl-riotboard:
              lab-pengutronix: failing since 1 day (last pass: v4.9.189-69-=
g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          imx6q-sabrelite:
              lab-collabora: failing since 1 day (last pass: v4.9.189-69-g7=
11554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          imx6q-wandboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          imx7s-warp:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          meson8b-odroidc1:
              lab-baylibre: failing since 1 day (last pass: v4.9.189-69-g71=
1554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          omap3-beagle:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          omap4-panda:
              lab-baylibre: failing since 1 day (last pass: v4.9.189-69-g71=
1554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
              lab-collabora: failing since 1 day (last pass: v4.9.189-69-g7=
11554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          qemu:
              lab-mhart: failing since 1 day (last pass: v4.9.189-69-g71155=
4dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
              lab-drue: failing since 1 day (last pass: v4.9.189-69-g711554=
dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
              lab-collabora: failing since 1 day (last pass: v4.9.189-69-g7=
11554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          rk3288-veyron-jaq:
              lab-collabora: failing since 1 day (last pass: v4.9.189-69-g7=
11554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          socfpga_cyclone5_de0_sockit:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          stih410-b2120:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          sun5i-a13-olinuxino-micro:
              lab-baylibre: failing since 1 day (last pass: v4.9.189-44-g75=
5768e31f44 - first fail: v4.9.189-84-gfe210ed24b65)
          sun5i-r8-chip:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          sun7i-a20-cubietruck:
              lab-baylibre: failing since 1 day (last pass: v4.9.189-69-g71=
1554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          tegra124-jetson-tk1:
              lab-mhart: failing since 1 day (last pass: v4.9.189-69-g71155=
4dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
              lab-collabora: failing since 1 day (last pass: v4.9.189-69-g7=
11554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          tegra20-iris-512:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          tegra30-beaver:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          vf610-colibri-eval-v3:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          zynq-zc702:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)

    mvebu_v7_defconfig:
        gcc-8:
          armada-xp-openblocks-ax3-4:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          omap4-panda:
              lab-baylibre: failing since 1 day (last pass: v4.9.189-69-g71=
1554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
              lab-collabora: failing since 1 day (last pass: v4.9.189-69-g7=
11554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)

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
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          sun5i-a13-olinuxino-micro:
              lab-baylibre: failing since 1 day (last pass: v4.9.189-69-g71=
1554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          sun5i-r8-chip:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          sun7i-a20-cubietruck:
              lab-baylibre: failing since 1 day (last pass: v4.9.189-44-g75=
5768e31f44 - first fail: v4.9.189-69-g711554dc8b12)

    tegra_defconfig:
        gcc-8:
          tegra124-jetson-tk1:
              lab-mhart: failing since 1 day (last pass: v4.9.189-69-g71155=
4dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
              lab-collabora: failing since 1 day (last pass: v4.9.189-69-g7=
11554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          tegra20-iris-512:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          tegra30-beaver:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-69-g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)

arm64:

    defconfig:
        gcc-8:
          apq8016-sbc:
              lab-mhart: failing since 1 day (last pass: v4.9.189-69-g71155=
4dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-44-g755768e31f44 - first fail: v4.9.189-69-g711554dc8b12)
          juno-r2:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-44-g755768e31f44 - first fail: v4.9.189-69-g711554dc8b12)
          meson-gxbb-odroidc2:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
9-44-g755768e31f44 - first fail: v4.9.189-69-g711554dc8b12)
          meson-gxbb-p200:
              lab-baylibre: failing since 1 day (last pass: v4.9.189-69-g71=
1554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          qcom-qdf2400:
              lab-linaro-lkft: failing since 1 day (last pass: v4.9.189-69-=
g711554dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          qemu:
              lab-mhart: failing since 1 day (last pass: v4.9.189-69-g71155=
4dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
              lab-drue: failing since 1 day (last pass: v4.9.189-69-g711554=
dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          synquacer-acpi:
              lab-mhart: failing since 1 day (last pass: v4.9.189-69-g71155=
4dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)

i386:

    i386_defconfig:
        gcc-8:
          x86-celeron:
              lab-mhart: failing since 1 day (last pass: v4.9.189-69-g71155=
4dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
          x86-pentium4:
              lab-mhart: failing since 1 day (last pass: v4.9.189-69-g71155=
4dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu:
              lab-mhart: failing since 1 day (last pass: v4.9.189-69-g71155=
4dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)
              lab-drue: failing since 1 day (last pass: v4.9.189-69-g711554=
dc8b12 - first fail: v4.9.189-84-gfe210ed24b65)

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
            exynos5800-peach-pi: 2 failed labs
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
