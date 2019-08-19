Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7378691A61
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 02:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbfHSAAU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 20:00:20 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:38478 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfHSAAU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 20:00:20 -0400
Received: by mail-wm1-f46.google.com with SMTP id m125so65165wmm.3
        for <stable@vger.kernel.org>; Sun, 18 Aug 2019 17:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4DD7UJy3miG1jcO9CquqlWCoYwX7R1VKOh/rbKtE0LY=;
        b=B7sfzARWew/i72AMHd7HBqC0+pIy7/dDu9xeLeca2RsBu0yVa40vQz4Msui/7hA+J2
         jqRgrM7/jqUTZxItegKD5oLaiveHfRqryX26FO+Hb8cocpyeozNuZnnHs4CFw3A9n1Sy
         PXgXcu32a2MQrzk/elqUpAIrgzOZqNyTWbdIX+Kxmg+4uoPN8Dpdftzj/sItsN+H3Clr
         E7R6Qcq+QYK8c7hNg2CIOdazZJ5MkFgYyQyjMtlm163241wgkVI2oPjxsAaxkdB1nNx5
         dbmS5c1KsnkbXv9Fe8CI/NgenNCVP8WecS3SH62wPqyjzCqeO9R8POcpwAvNPATOD1fa
         jxqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4DD7UJy3miG1jcO9CquqlWCoYwX7R1VKOh/rbKtE0LY=;
        b=Z8JCYxwBewS3SR4La6AoaoJbS4TQD/M6ZigpLUIPE90QG6osr7gyxWdv8Z+U8f0i6y
         DnJFrvGQQ/gWnYjUeJY0CNEbITVmY2IGjitkN6IWnUGFB15gzDza9OpQ6kCYHtNNqV0H
         Xzg1jMcwfKhd2k1dkxespx1XDpg1O7j4hZtNDotBOcx650RrIEXBjAYFdT0NTyyI3mZS
         Ajm+80isNZ3Gj7YdETGR1PfghuRRZNNqqJEl+aK0oq4zCd6Alsm8ju4OcNPT7MgrBg9j
         d5oXky+rKz5mZWTwIwL2OQEHyNXadihSEc06YcMJzHTnRmDpLSnSzXDFsd1/uj4XJEG7
         rl/g==
X-Gm-Message-State: APjAAAUbXvlUXQp6qaZI1gb6SavU5jUPwrcAgz3vE9lVIREivCAMSfnq
        o31Lu9e2bY9iRyiFRUX3AWqn6T35low=
X-Google-Smtp-Source: APXvYqwt52Gs1sb+TrPkqO2jsmRPrcop0N9rikE7rRC85/rON0oAj0pd1jHTqMck3DB9T9VcFhImqg==
X-Received: by 2002:a7b:c415:: with SMTP id k21mr16748358wmi.135.1566172815424;
        Sun, 18 Aug 2019 17:00:15 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id e11sm36017830wrc.4.2019.08.18.17.00.14
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Aug 2019 17:00:15 -0700 (PDT)
Message-ID: <5d59e68f.1c69fb81.b4ebc.fa3b@mx.google.com>
Date:   Sun, 18 Aug 2019 17:00:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.189-66-g5d14c171a0a0
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 95 boots: 81 failed,
 0 passed with 14 offline (v4.4.189-66-g5d14c171a0a0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 95 boots: 81 failed, 0 passed with 14 offline (=
v4.4.189-66-g5d14c171a0a0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.189-66-g5d14c171a0a0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.189-66-g5d14c171a0a0/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.189-66-g5d14c171a0a0
Git Commit: 5d14c171a0a070385f004b7f264a65006a63cca1
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
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          dm365evm,legacy:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)

    exynos_defconfig:
        gcc-8:
          exynos4412-odroidx2:
              lab-collabora: failing since 1 day (last pass: v4.4.189-45-g2=
44e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          exynos5250-arndale:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          exynos5250-snow:
              lab-collabora: failing since 1 day (last pass: v4.4.189-45-g2=
44e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          exynos5420-arndale-octa:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          exynos5422-odroidxu3:
              lab-baylibre: failing since 1 day (last pass: v4.4.189-45-g24=
4e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
              lab-collabora: failing since 1 day (last pass: v4.4.189-45-g2=
44e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          exynos5800-peach-pi:
              lab-collabora: failing since 1 day (last pass: v4.4.189-45-g2=
44e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)

    imx_v6_v7_defconfig:
        gcc-8:
          imx6dl-riotboard:
              lab-pengutronix: failing since 1 day (last pass: v4.4.189-45-=
g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          imx6q-wandboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          vf610-colibri-eval-v3:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)

    multi_v7_defconfig:
        gcc-8:
          alpine-db:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          armada-xp-openblocks-ax3-4:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          at91-sama5d4_xplained:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          bcm4708-smartrg-sr400ac:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          bcm72521-bcm97252sffe:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          bcm7445-bcm97445c:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          exynos4412-odroidx2:
              lab-collabora: failing since 1 day (last pass: v4.4.189-45-g2=
44e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          exynos5250-arndale:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          exynos5250-snow:
              lab-collabora: failing since 1 day (last pass: v4.4.189-45-g2=
44e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          exynos5420-arndale-octa:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          exynos5422-odroidxu3:
              lab-baylibre: failing since 1 day (last pass: v4.4.189-45-g24=
4e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          exynos5800-peach-pi:
              lab-collabora: failing since 1 day (last pass: v4.4.189-45-g2=
44e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          imx6dl-riotboard:
              lab-pengutronix: failing since 1 day (last pass: v4.4.189-35-=
ge6790d05646d - first fail: v4.4.189-45-g244e47df71ff)
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          imx6q-sabrelite:
              lab-collabora: failing since 1 day (last pass: v4.4.189-45-g2=
44e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          imx6q-wandboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          meson8b-odroidc1:
              lab-baylibre: failing since 1 day (last pass: v4.4.189-45-g24=
4e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          omap3-beagle:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          omap4-panda:
              lab-baylibre: failing since 1 day (last pass: v4.4.189-45-g24=
4e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
              lab-collabora: failing since 1 day (last pass: v4.4.189-45-g2=
44e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          qemu:
              lab-baylibre: failing since 1 day (last pass: v4.4.189-45-g24=
4e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
              lab-mhart: failing since 1 day (last pass: v4.4.189-45-g244e4=
7df71ff - first fail: v4.4.189-57-g18b9910fe35a)
              lab-drue: failing since 1 day (last pass: v4.4.189-45-g244e47=
df71ff - first fail: v4.4.189-57-g18b9910fe35a)
              lab-collabora: failing since 1 day (last pass: v4.4.189-45-g2=
44e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          rk3288-veyron-jaq:
              lab-collabora: failing since 1 day (last pass: v4.4.189-45-g2=
44e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          socfpga_cyclone5_de0_sockit:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          stih410-b2120:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          sun5i-a13-olinuxino-micro:
              lab-baylibre: failing since 1 day (last pass: v4.4.189-45-g24=
4e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          sun5i-r8-chip:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          sun7i-a20-cubietruck:
              lab-baylibre: failing since 1 day (last pass: v4.4.189-45-g24=
4e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          tegra124-jetson-tk1:
              lab-mhart: failing since 1 day (last pass: v4.4.189-45-g244e4=
7df71ff - first fail: v4.4.189-57-g18b9910fe35a)
              lab-collabora: failing since 1 day (last pass: v4.4.189-45-g2=
44e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          tegra20-iris-512:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          tegra30-beaver:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          vf610-colibri-eval-v3:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          zynq-zc702:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)

    mvebu_v7_defconfig:
        gcc-8:
          armada-xp-openblocks-ax3-4:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          omap4-panda:
              lab-baylibre: failing since 1 day (last pass: v4.4.189-45-g24=
4e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
              lab-collabora: failing since 1 day (last pass: v4.4.189-45-g2=
44e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 4 days (last pass: v4.4.1=
89 - first fail: v4.4.189-32-g35ba3146be27)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 4 days (last pass: v4.4.1=
89 - first fail: v4.4.189-32-g35ba3146be27)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-35-ge6790d05646d - first fail: v4.4.189-45-g244e47df71ff)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          sun5i-a13-olinuxino-micro:
              lab-baylibre: failing since 1 day (last pass: v4.4.189-45-g24=
4e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          sun5i-r8-chip:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          sun7i-a20-cubietruck:
              lab-baylibre: failing since 1 day (last pass: v4.4.189-45-g24=
4e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)

    tegra_defconfig:
        gcc-8:
          tegra124-jetson-tk1:
              lab-mhart: failing since 1 day (last pass: v4.4.189-45-g244e4=
7df71ff - first fail: v4.4.189-57-g18b9910fe35a)
              lab-collabora: failing since 1 day (last pass: v4.4.189-45-g2=
44e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          tegra20-iris-512:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          tegra30-beaver:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
9-45-g244e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)

arm64:

    defconfig:
        gcc-8:
          apq8016-sbc:
              lab-mhart: failing since 1 day (last pass: v4.4.189-45-g244e4=
7df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          qemu:
              lab-baylibre: failing since 1 day (last pass: v4.4.189-45-g24=
4e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
              lab-mhart: failing since 1 day (last pass: v4.4.189-45-g244e4=
7df71ff - first fail: v4.4.189-57-g18b9910fe35a)
              lab-drue: failing since 1 day (last pass: v4.4.189-45-g244e47=
df71ff - first fail: v4.4.189-57-g18b9910fe35a)
              lab-collabora: failing since 1 day (last pass: v4.4.189-45-g2=
44e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)

i386:

    i386_defconfig:
        gcc-8:
          x86-celeron:
              lab-mhart: failing since 1 day (last pass: v4.4.189-45-g244e4=
7df71ff - first fail: v4.4.189-57-g18b9910fe35a)
          x86-pentium4:
              lab-mhart: failing since 1 day (last pass: v4.4.189-45-g244e4=
7df71ff - first fail: v4.4.189-57-g18b9910fe35a)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu:
              lab-baylibre: failing since 1 day (last pass: v4.4.189-45-g24=
4e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)
              lab-mhart: failing since 1 day (last pass: v4.4.189-45-g244e4=
7df71ff - first fail: v4.4.189-57-g18b9910fe35a)
              lab-drue: failing since 1 day (last pass: v4.4.189-45-g244e47=
df71ff - first fail: v4.4.189-57-g18b9910fe35a)
              lab-collabora: failing since 1 day (last pass: v4.4.189-45-g2=
44e47df71ff - first fail: v4.4.189-57-g18b9910fe35a)

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
            sun7i-a20-bananapi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
