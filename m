Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E799091991
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 22:40:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfHRUjo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 16:39:44 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:44251 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727118AbfHRUjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 16:39:44 -0400
Received: by mail-wr1-f46.google.com with SMTP id p17so6562360wrf.11
        for <stable@vger.kernel.org>; Sun, 18 Aug 2019 13:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6VqBA7Ly7uGAR8UtV7jo6fAwbrZpmE6VQF4dAWldZwU=;
        b=YIF2nMsk21H6AGxWSD5WIZUkccy0+uCor0x543bywghEQkg5n2HZtkHC0lMeuJ1crQ
         2UrIaNv4Dg2RFFpQ9RML9iawjIlPTKNco5VwPTMNmu7sFleiCLxbvqW4HeUj/zaB7+S3
         Qbb8P9c4QnV7cuxrLo480Wjt1sktebPROflG4SZ10IsA6H8tnav/dKeedE0LGi0reguW
         oYN4PLlmMwYSkmG0kkEaXqLOrBxzimVNi3boNuZQp/ZhceGYCtFZ04RMLDkdLMSi+AbK
         sXLtGgihG2IMokPxHoKvVZ9s6NnJL+RUTAsXxDXYe9C3mdDovbA0HCLZFH7uvwuKcRDc
         L7ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6VqBA7Ly7uGAR8UtV7jo6fAwbrZpmE6VQF4dAWldZwU=;
        b=LvgW5fKVdKlwyP8w/nW2MzA/HYYQ8bxv4+d9/bMFDP+4YIC6h04fZG77TTvOrWsT6Y
         2769aIcljttL4YtLLXuZMyR0L3Rfc31Ydl90TsUa/tfafaSIj2SavLqYMjAMHyNE/Vcl
         IYQBF0iMz5rzX3fVbkyRQdoMhwDhNxU9S9Yz9VtwANm2sGQAfjVPLfnsOFx45evRsnGk
         +XTFpE/s5NiJKUKCRx6b93pDrtIWvPgQJrPqdj78qj/Lm3zjldlucrQCBsjuavHGhoKp
         wLaex4pB1AQpSEHDfbE6ONp/mdsCTnswgdr0i7wsRWzEjP73EAKIhfhwfZ0a4cPMSGzt
         nO/Q==
X-Gm-Message-State: APjAAAWbIst+huuPEsySJNQ0nCnr19rCBRPvlcILlvxu7CZySmTvWQMx
        AVbNukYlSbzq+IC34Gp4F2jcZKkcNtY=
X-Google-Smtp-Source: APXvYqwF/5T4875tbWMKT4RUaCcJdITtPuCa1BqbUNNdi8ysIuCZOY7ifuA9xiU8UoxXRAdOxNwiXg==
X-Received: by 2002:a5d:4083:: with SMTP id o3mr10023472wrp.150.1566160780694;
        Sun, 18 Aug 2019 13:39:40 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id k124sm29876365wmk.47.2019.08.18.13.39.40
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Aug 2019 13:39:40 -0700 (PDT)
Message-ID: <5d59b78c.1c69fb81.d0cbf.1a8a@mx.google.com>
Date:   Sun, 18 Aug 2019 13:39:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.189-57-g18b9910fe35a
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 95 boots: 83 failed,
 0 passed with 12 offline (v4.4.189-57-g18b9910fe35a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 95 boots: 83 failed, 0 passed with 12 offline (=
v4.4.189-57-g18b9910fe35a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.189-57-g18b9910fe35a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.189-57-g18b9910fe35a/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.189-57-g18b9910fe35a
Git Commit: 18b9910fe35ac4697da9776abc33cca4f8b03b60
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 20 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-35-ge6790d05646d - first fail: v4.4.189-45-g244e47df71ff)

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)

    exynos_defconfig:
        gcc-8:
          exynos4412-odroidx2:
              lab-collabora: new failure (last pass: v4.4.189-45-g244e47df7=
1ff)
          exynos5250-arndale:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          exynos5250-snow:
              lab-collabora: new failure (last pass: v4.4.189-45-g244e47df7=
1ff)
          exynos5420-arndale-octa:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          exynos5422-odroidxu3:
              lab-baylibre: new failure (last pass: v4.4.189-45-g244e47df71=
ff)
              lab-collabora: new failure (last pass: v4.4.189-45-g244e47df7=
1ff)
          exynos5800-peach-pi:
              lab-collabora: new failure (last pass: v4.4.189-45-g244e47df7=
1ff)
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)

    imx_v6_v7_defconfig:
        gcc-8:
          imx6dl-riotboard:
              lab-pengutronix: new failure (last pass: v4.4.189-45-g244e47d=
f71ff)
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          imx6q-wandboard:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          vf610-colibri-eval-v3:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)

    multi_v7_defconfig:
        gcc-8:
          alpine-db:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          armada-xp-openblocks-ax3-4:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          at91-sama5d4_xplained:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          bcm4708-smartrg-sr400ac:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          bcm72521-bcm97252sffe:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          bcm7445-bcm97445c:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          exynos4412-odroidx2:
              lab-collabora: new failure (last pass: v4.4.189-45-g244e47df7=
1ff)
          exynos5250-arndale:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          exynos5250-snow:
              lab-collabora: new failure (last pass: v4.4.189-45-g244e47df7=
1ff)
          exynos5420-arndale-octa:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          exynos5422-odroidxu3:
              lab-baylibre: new failure (last pass: v4.4.189-45-g244e47df71=
ff)
              lab-collabora: new failure (last pass: v4.4.189-45-g244e47df7=
1ff)
          exynos5800-peach-pi:
              lab-collabora: new failure (last pass: v4.4.189-45-g244e47df7=
1ff)
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          imx6dl-riotboard:
              lab-pengutronix: failing since 1 day (last pass: v4.4.189-35-=
ge6790d05646d - first fail: v4.4.189-45-g244e47df71ff)
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          imx6q-sabrelite:
              lab-collabora: new failure (last pass: v4.4.189-45-g244e47df7=
1ff)
          imx6q-wandboard:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          meson8b-odroidc1:
              lab-baylibre: new failure (last pass: v4.4.189-45-g244e47df71=
ff)
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          omap3-beagle:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.4.189-45-g244e47df71=
ff)
              lab-collabora: new failure (last pass: v4.4.189-45-g244e47df7=
1ff)
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          qemu:
              lab-baylibre: new failure (last pass: v4.4.189-45-g244e47df71=
ff)
              lab-linaro-lkft: new failure (last pass: v4.4.189-45-g244e47d=
f71ff)
              lab-mhart: new failure (last pass: v4.4.189-45-g244e47df71ff)
              lab-drue: new failure (last pass: v4.4.189-45-g244e47df71ff)
              lab-collabora: new failure (last pass: v4.4.189-45-g244e47df7=
1ff)
          rk3288-veyron-jaq:
              lab-collabora: new failure (last pass: v4.4.189-45-g244e47df7=
1ff)
          socfpga_cyclone5_de0_sockit:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          stih410-b2120:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          sun5i-a13-olinuxino-micro:
              lab-baylibre: new failure (last pass: v4.4.189-45-g244e47df71=
ff)
          sun5i-r8-chip:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          sun7i-a20-cubietruck:
              lab-baylibre: new failure (last pass: v4.4.189-45-g244e47df71=
ff)
          tegra124-jetson-tk1:
              lab-mhart: new failure (last pass: v4.4.189-45-g244e47df71ff)
              lab-collabora: new failure (last pass: v4.4.189-45-g244e47df7=
1ff)
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          tegra30-beaver:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          vf610-colibri-eval-v3:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          zynq-zc702:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)

    mvebu_v7_defconfig:
        gcc-8:
          armada-xp-openblocks-ax3-4:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          omap4-panda:
              lab-baylibre: new failure (last pass: v4.4.189-45-g244e47df71=
ff)
              lab-collabora: new failure (last pass: v4.4.189-45-g244e47df7=
1ff)
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 3 days (last pass: v4.4.1=
89 - first fail: v4.4.189-32-g35ba3146be27)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 3 days (last pass: v4.4.1=
89 - first fail: v4.4.189-32-g35ba3146be27)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-35-ge6790d05646d - first fail: v4.4.189-45-g244e47df71ff)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          sun5i-a13-olinuxino-micro:
              lab-baylibre: new failure (last pass: v4.4.189-45-g244e47df71=
ff)
          sun5i-r8-chip:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          sun7i-a20-cubietruck:
              lab-baylibre: new failure (last pass: v4.4.189-45-g244e47df71=
ff)

    tegra_defconfig:
        gcc-8:
          tegra124-jetson-tk1:
              lab-mhart: new failure (last pass: v4.4.189-45-g244e47df71ff)
              lab-collabora: new failure (last pass: v4.4.189-45-g244e47df7=
1ff)
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)
          tegra30-beaver:
              lab-baylibre-seattle: new failure (last pass: v4.4.189-45-g24=
4e47df71ff)

arm64:

    defconfig:
        gcc-8:
          apq8016-sbc:
              lab-mhart: new failure (last pass: v4.4.189-45-g244e47df71ff)
          qemu:
              lab-baylibre: new failure (last pass: v4.4.189-45-g244e47df71=
ff)
              lab-linaro-lkft: new failure (last pass: v4.4.189-45-g244e47d=
f71ff)
              lab-mhart: new failure (last pass: v4.4.189-45-g244e47df71ff)
              lab-drue: new failure (last pass: v4.4.189-45-g244e47df71ff)
              lab-collabora: new failure (last pass: v4.4.189-45-g244e47df7=
1ff)

i386:

    i386_defconfig:
        gcc-8:
          x86-celeron:
              lab-mhart: new failure (last pass: v4.4.189-45-g244e47df71ff)
          x86-pentium4:
              lab-mhart: new failure (last pass: v4.4.189-45-g244e47df71ff)

x86_64:

    x86_64_defconfig:
        gcc-8:
          minnowboard-turbot-E3826:
              lab-collabora: new failure (last pass: v4.4.189-45-g244e47df7=
1ff)
          qemu:
              lab-baylibre: new failure (last pass: v4.4.189-45-g244e47df71=
ff)
              lab-linaro-lkft: new failure (last pass: v4.4.189-45-g244e47d=
f71ff)
              lab-mhart: new failure (last pass: v4.4.189-45-g244e47df71ff)
              lab-drue: new failure (last pass: v4.4.189-45-g244e47df71ff)
              lab-collabora: new failure (last pass: v4.4.189-45-g244e47df7=
1ff)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            apq8016-sbc: 1 failed lab
            qcom-qdf2400: 1 failed lab
            qemu: 5 failed labs

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
