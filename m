Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA6C091AC3
	for <lists+stable@lfdr.de>; Mon, 19 Aug 2019 03:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbfHSBej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 21:34:39 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:37487 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfHSBej (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 21:34:39 -0400
Received: by mail-wr1-f41.google.com with SMTP id z11so6938129wrt.4
        for <stable@vger.kernel.org>; Sun, 18 Aug 2019 18:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=P9hHml3YB+pSOGYX0D4GMvep4cl99O7zVAqVzITDQeU=;
        b=PKeFm04ZgzC2vooj4pPHuECjwgUz3g2jH5tJnb3+PM/Q/7HN9AIrTWNZTJbBnRDGlT
         XXewY+xuH9QFXgUVdXWsj7GF+fJEgqQ+Zgb+ZscAVC7ZtzpMMEv9CwtVL+8ZItwJxEBr
         w9yRNfY0oHx+HS/j9FvhRR1e/FDNm9h0JCKRuqNBmHoeTRrD2kosGOzzewcBxu4xYlca
         BwUhTULnrKvhPS0ZdkmPA302lP8OhzXtHtcc9BEfiAbftZEpCW7gaQzpiFN1oPpfW75j
         P1gAsJ5LZwf264YJTrjXEUVEdWTdkDEVPzr6CxFNJY1Wg8yBuGZnZgUwZIjOCDUFhYVP
         kJZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=P9hHml3YB+pSOGYX0D4GMvep4cl99O7zVAqVzITDQeU=;
        b=GIMhO/SMQLL+NmubyLRxGxQTnN6uOOO8eswazralD2Qrfa+aZ2ijPV5E3Hg0BBmJ6I
         M2foKE/bXbHbsNi5e2vEXpoFtC2AXzJy5bDuj3XeC1U9Y6GIlQnsWO7cccOpJ3iHoj++
         ru1XnNJXRveRoR++alyVzJLUP4t3mQiJLqcw0Y7/2TYU1I14uAAKwzgcFFNTgbdOOQ7D
         dFkEhaNqOgp3ukarfO4Sz7XQjCywOCzme2DMsMMa3AqSMpigi+R1nrlPKBV5pTtJRvkg
         IdaNvsDECnyiFh7GKa5UkFLbt7MfKXrZDKsNpcN5BgPkc/ngZKDPHiZ2ZKZSF80RYDLY
         nyqQ==
X-Gm-Message-State: APjAAAXjoxwpI7ddRvSkp7aGIZTcNtAFjTHC9fDtDZnNyhPYK83P/MII
        V7gQeiWBDOKnCLZcC4Lsd+fSC/Teejw=
X-Google-Smtp-Source: APXvYqz8JTaSAbmwck4MajxbM+1k850y5TMS5MjdJQ/t20Zicv5kbdP5PF3BH96gmzyCXNiIkBdtIQ==
X-Received: by 2002:adf:bc84:: with SMTP id g4mr23611439wrh.135.1566178473740;
        Sun, 18 Aug 2019 18:34:33 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id 39sm43977533wrc.45.2019.08.18.18.34.33
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Aug 2019 18:34:33 -0700 (PDT)
Message-ID: <5d59fca9.1c69fb81.a2cd7.4151@mx.google.com>
Date:   Sun, 18 Aug 2019 18:34:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.2.8-251-gfe1d8effa7ac
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.2.y
Subject: stable-rc/linux-5.2.y boot: 138 boots: 119 failed,
 0 passed with 19 offline (v5.2.8-251-gfe1d8effa7ac)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 138 boots: 119 failed, 0 passed with 19 offline=
 (v5.2.8-251-gfe1d8effa7ac)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.8-251-gfe1d8effa7ac/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.8-251-gfe1d8effa7ac/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.8-251-gfe1d8effa7ac
Git Commit: fe1d8effa7ac7f34bb967d1613a6f4d8a5f8ce2b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 79 unique boards, 27 SoC families, 17 builds out of 209

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-177-gfd5=
70399d29b - first fail: v5.2.8-237-g61d06c60569f)

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          bcm2837-rpi-3-b:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-157-g9e5=
3d01dff58 - first fail: v5.2.8-237-g61d06c60569f)

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          da850-lcdk:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-157-g9e5=
3d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          dm365evm,legacy:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)

    exynos_defconfig:
        gcc-8:
          exynos4412-odroidx2:
              lab-collabora: failing since 1 day (last pass: v5.2.8-157-g9e=
53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          exynos5250-arndale:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          exynos5250-snow:
              lab-collabora: failing since 1 day (last pass: v5.2.8-157-g9e=
53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          exynos5420-arndale-octa:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          exynos5422-odroidxu3:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-157-g9e5=
3d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
              lab-collabora: failing since 1 day (last pass: v5.2.8-157-g9e=
53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          exynos5800-peach-pi:
              lab-collabora: failing since 1 day (last pass: v5.2.8-157-g9e=
53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)

    imx_v6_v7_defconfig:
        gcc-8:
          imx6dl-riotboard:
              lab-pengutronix: failing since 1 day (last pass: v5.2.8-157-g=
9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          imx6q-wandboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          imx7s-warp:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          vf610-colibri-eval-v3:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)

    multi_v7_defconfig:
        gcc-8:
          alpine-db:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          am57xx-beagle-x15:
              lab-drue: failing since 1 day (last pass: v5.2.8-157-g9e53d01=
dff58 - first fail: v5.2.8-237-g61d06c60569f)
          armada-xp-openblocks-ax3-4:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          at91-sama5d4_xplained:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          at91-sama5d4ek:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          bcm4708-smartrg-sr400ac:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          bcm72521-bcm97252sffe:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          bcm7445-bcm97445c:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          exynos4412-odroidx2:
              lab-collabora: failing since 1 day (last pass: v5.2.8-157-g9e=
53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          exynos5250-arndale:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          exynos5250-snow:
              lab-collabora: failing since 1 day (last pass: v5.2.8-157-g9e=
53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          exynos5420-arndale-octa:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          exynos5422-odroidxu3:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-157-g9e5=
3d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
              lab-collabora: failing since 1 day (last pass: v5.2.8-157-g9e=
53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          exynos5800-peach-pi:
              lab-collabora: failing since 1 day (last pass: v5.2.8-157-g9e=
53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          imx6dl-riotboard:
              lab-pengutronix: failing since 1 day (last pass: v5.2.8-157-g=
9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          imx6q-wandboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          imx7s-warp:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          meson8b-odroidc1:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-157-g9e5=
3d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          mt7623n-bananapi-bpi-r2:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          omap3-beagle:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          omap4-panda:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-157-g9e5=
3d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
              lab-collabora: failing since 1 day (last pass: v5.2.8-157-g9e=
53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          qemu:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-157-g9e5=
3d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
              lab-mhart: failing since 1 day (last pass: v5.2.8-157-g9e53d0=
1dff58 - first fail: v5.2.8-237-g61d06c60569f)
              lab-drue: failing since 1 day (last pass: v5.2.8-157-g9e53d01=
dff58 - first fail: v5.2.8-237-g61d06c60569f)
              lab-collabora: failing since 1 day (last pass: v5.2.8-157-g9e=
53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          rk3288-veyron-jaq:
              lab-collabora: failing since 1 day (last pass: v5.2.8-157-g9e=
53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          stih410-b2120:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          sun5i-a13-olinuxino-micro:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-157-g9e5=
3d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          sun5i-r8-chip:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          sun7i-a20-cubietruck:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-157-g9e5=
3d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          sun8i-h2-plus-libretech-all-h3-cc:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-157-g9e5=
3d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          sun8i-h2-plus-orangepi-zero:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-157-g9e5=
3d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          sun8i-h3-libretech-all-h3-cc:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-157-g9e5=
3d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          tegra124-jetson-tk1:
              lab-mhart: failing since 1 day (last pass: v5.2.8-157-g9e53d0=
1dff58 - first fail: v5.2.8-237-g61d06c60569f)
              lab-collabora: failing since 1 day (last pass: v5.2.8-157-g9e=
53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          tegra30-beaver:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          vf610-colibri-eval-v3:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          zynq-zc702:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)

    mvebu_v7_defconfig:
        gcc-8:
          armada-xp-openblocks-ax3-4:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)

    omap2plus_defconfig:
        gcc-8:
          am57xx-beagle-x15:
              lab-drue: failing since 1 day (last pass: v5.2.8-157-g9e53d01=
dff58 - first fail: v5.2.8-237-g61d06c60569f)
          omap3-beagle:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          omap4-panda:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-157-g9e5=
3d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
              lab-collabora: failing since 1 day (last pass: v5.2.8-157-g9e=
53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)

    oxnas_v6_defconfig:
        gcc-8:
          ox820-cloudengines-pogoplug-series-3:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-157-g9e5=
3d01dff58 - first fail: v5.2.8-237-g61d06c60569f)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 4 days (last pass: v5.2.8=
 - first fail: v5.2.8-145-g2440e485aeda)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: failing since 4 days (last pass: v5.2.8=
 - first fail: v5.2.8-145-g2440e485aeda)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          at91-sama5d4ek:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          sun5i-a13-olinuxino-micro:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-157-g9e5=
3d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          sun5i-r8-chip:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          sun7i-a20-cubietruck:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-157-g9e5=
3d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          sun8i-h2-plus-libretech-all-h3-cc:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-157-g9e5=
3d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-157-g9e5=
3d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          sun8i-h2-plus-orangepi-zero:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-157-g9e5=
3d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          sun8i-h3-libretech-all-h3-cc:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-157-g9e5=
3d01dff58 - first fail: v5.2.8-237-g61d06c60569f)

    tegra_defconfig:
        gcc-8:
          tegra124-jetson-tk1:
              lab-mhart: failing since 1 day (last pass: v5.2.8-157-g9e53d0=
1dff58 - first fail: v5.2.8-237-g61d06c60569f)
              lab-collabora: failing since 1 day (last pass: v5.2.8-157-g9e=
53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          tegra30-beaver:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)

arm64:

    defconfig:
        gcc-8:
          apq8016-sbc:
              lab-mhart: failing since 1 day (last pass: v5.2.8-177-gfd5703=
99d29b - first fail: v5.2.8-237-g61d06c60569f)
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          bcm2837-rpi-3-b:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-177-gfd5=
70399d29b - first fail: v5.2.8-237-g61d06c60569f)
              lab-mhart: failing since 1 day (last pass: v5.2.8-177-gfd5703=
99d29b - first fail: v5.2.8-237-g61d06c60569f)
          juno-r2:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          meson-axg-s400:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          meson-g12a-sei510:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-177-gfd5=
70399d29b - first fail: v5.2.8-237-g61d06c60569f)
          meson-g12a-u200:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          meson-g12a-x96-max:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-177-gfd5=
70399d29b - first fail: v5.2.8-237-g61d06c60569f)
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          meson-gxbb-odroidc2:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          meson-gxbb-p200:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-177-gfd5=
70399d29b - first fail: v5.2.8-237-g61d06c60569f)
          meson-gxl-s905d-p230:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-177-gfd5=
70399d29b - first fail: v5.2.8-237-g61d06c60569f)
          meson-gxl-s905x-libretech-cc:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-177-gfd5=
70399d29b - first fail: v5.2.8-237-g61d06c60569f)
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          meson-gxl-s905x-nexbox-a95x:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          meson-gxl-s905x-p212:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          meson-gxm-khadas-vim2:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-177-gfd5=
70399d29b - first fail: v5.2.8-237-g61d06c60569f)
          meson-gxm-nexbox-a1:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          mt7622-rfb1:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          qemu:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-177-gfd5=
70399d29b - first fail: v5.2.8-237-g61d06c60569f)
              lab-mhart: failing since 1 day (last pass: v5.2.8-177-gfd5703=
99d29b - first fail: v5.2.8-237-g61d06c60569f)
              lab-drue: failing since 1 day (last pass: v5.2.8-177-gfd57039=
9d29b - first fail: v5.2.8-237-g61d06c60569f)
              lab-collabora: failing since 1 day (last pass: v5.2.8-177-gfd=
570399d29b - first fail: v5.2.8-237-g61d06c60569f)
          r8a7796-m3ulcb:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-177-gfd5=
70399d29b - first fail: v5.2.8-237-g61d06c60569f)
              lab-collabora: failing since 1 day (last pass: v5.2.8-177-gfd=
570399d29b - first fail: v5.2.8-237-g61d06c60569f)
          rk3399-firefly:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          rk3399-gru-kevin:
              lab-collabora: failing since 1 day (last pass: v5.2.8-157-g9e=
53d01dff58 - first fail: v5.2.8-177-gfd570399d29b)
          sun50i-a64-pine64-plus:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)
          sun50i-h5-libretech-all-h3-cc:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-177-gfd5=
70399d29b - first fail: v5.2.8-237-g61d06c60569f)
          sun50i-h6-pine-h64:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-177-gfd5=
70399d29b - first fail: v5.2.8-237-g61d06c60569f)
          synquacer-acpi:
              lab-mhart: failing since 1 day (last pass: v5.2.8-177-gfd5703=
99d29b - first fail: v5.2.8-237-g61d06c60569f)

i386:

    i386_defconfig:
        gcc-8:
          x86-celeron:
              lab-mhart: failing since 1 day (last pass: v5.2.8-177-gfd5703=
99d29b - first fail: v5.2.8-237-g61d06c60569f)
          x86-pentium4:
              lab-mhart: failing since 1 day (last pass: v5.2.8-177-gfd5703=
99d29b - first fail: v5.2.8-237-g61d06c60569f)

mips:

    pistachio_defconfig:
        gcc-8:
          pistachio_marduk:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)

riscv:

    defconfig:
        gcc-8:
          sifive_fu540:
              lab-baylibre-seattle: failing since 1 day (last pass: v5.2.8-=
157-g9e53d01dff58 - first fail: v5.2.8-237-g61d06c60569f)

x86_64:

    x86_64_defconfig:
        gcc-8:
          minnowboard-turbot-E3826:
              lab-collabora: failing since 1 day (last pass: v5.2.8-177-gfd=
570399d29b - first fail: v5.2.8-237-g61d06c60569f)
          qemu:
              lab-baylibre: failing since 1 day (last pass: v5.2.8-177-gfd5=
70399d29b - first fail: v5.2.8-237-g61d06c60569f)
              lab-mhart: failing since 1 day (last pass: v5.2.8-177-gfd5703=
99d29b - first fail: v5.2.8-237-g61d06c60569f)
              lab-drue: failing since 1 day (last pass: v5.2.8-177-gfd57039=
9d29b - first fail: v5.2.8-237-g61d06c60569f)
              lab-collabora: failing since 1 day (last pass: v5.2.8-177-gfd=
570399d29b - first fail: v5.2.8-237-g61d06c60569f)

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
            meson-axg-s400: 1 failed lab
            meson-g12a-sei510: 1 failed lab
            meson-g12a-u200: 1 failed lab
            meson-g12a-x96-max: 1 failed lab
            meson-gxbb-nanopi-k2: 1 failed lab
            meson-gxbb-p200: 1 failed lab
            meson-gxl-s905d-p230: 1 failed lab
            meson-gxl-s905x-khadas-vim: 1 failed lab
            meson-gxl-s905x-libretech-cc: 2 failed labs
            meson-gxl-s905x-nexbox-a95x: 1 failed lab
            meson-gxl-s905x-p212: 1 failed lab
            meson-gxm-khadas-vim2: 1 failed lab
            meson-gxm-nexbox-a1: 1 failed lab
            qemu: 4 failed labs
            r8a7796-m3ulcb: 2 failed labs
            rk3399-firefly: 1 failed lab
            rk3399-gru-kevin: 1 failed lab
            rk3399-puma-haikou: 1 failed lab
            sun50i-a64-pine64-plus: 1 failed lab
            sun50i-h5-libretech-all-h3-cc: 1 failed lab
            sun50i-h6-pine-h64: 1 failed lab
            synquacer-acpi: 1 failed lab

riscv:
    defconfig:
        gcc-8:
            sifive_fu540: 1 failed lab

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
            qemu: 4 failed labs

arm:
    oxnas_v6_defconfig:
        gcc-8:
            ox820-cloudengines-pogoplug-series-3: 1 failed lab

    mvebu_v7_defconfig:
        gcc-8:
            armada-xp-openblocks-ax3-4: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab
            sun5i-a13-olinuxino-micro: 1 failed lab
            sun7i-a20-bananapi: 1 failed lab
            sun7i-a20-cubietruck: 1 failed lab
            sun8i-h2-plus-libretech-all-h3-cc: 1 failed lab
            sun8i-h2-plus-orangepi-r1: 1 failed lab
            sun8i-h2-plus-orangepi-zero: 1 failed lab
            sun8i-h3-libretech-all-h3-cc: 1 failed lab

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
            am57xx-beagle-x15: 1 failed lab
            omap3-beagle: 1 failed lab
            omap4-panda: 3 failed labs

    multi_v7_defconfig:
        gcc-8:
            am57xx-beagle-x15: 1 failed lab
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
            imx6q-sabrelite: 1 failed lab
            imx6q-wandboard: 1 failed lab
            imx7s-warp: 1 failed lab
            meson8b-odroidc1: 2 failed labs
            mt7623n-bananapi-bpi-r2: 1 failed lab
            omap3-beagle: 1 failed lab
            omap4-panda: 3 failed labs
            qemu: 4 failed labs
            rk3288-veyron-jaq: 1 failed lab
            stih410-b2120: 1 failed lab
            sun4i-a10-cubieboard: 1 failed lab
            sun5i-a13-olinuxino-micro: 1 failed lab
            sun7i-a20-cubietruck: 1 failed lab
            sun8i-h2-plus-libretech-all-h3-cc: 1 failed lab
            sun8i-h2-plus-orangepi-r1: 1 failed lab
            sun8i-h2-plus-orangepi-zero: 1 failed lab
            sun8i-h3-libretech-all-h3-cc: 1 failed lab
            tegra124-jetson-tk1: 2 failed labs
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
            meson-g12a-x96-max: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab
            mt7622-rfb1: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            at91-sama5d4ek: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
