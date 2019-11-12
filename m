Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F115AF86DA
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 03:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfKLCTR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 21:19:17 -0500
Received: from mail-wr1-f42.google.com ([209.85.221.42]:40884 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbfKLCTR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 21:19:17 -0500
Received: by mail-wr1-f42.google.com with SMTP id i10so16756540wrs.7
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 18:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:in-reply-to
         :references:subject:to:from:cc;
        bh=N2pB7A1+M/tGMIJX4WLJD4oMISZoZphK8KZOxQiOHCM=;
        b=QswbLHbDv0JYvzGPviCBuVltYWyR5tx6WaeKn/aHqJGHESaPXqtJcldrNjBXztNeN4
         h77o+yY19AsRkM9Df8FAidJRS3epsn7bzsX5cQzG5gXsxbUhiIArg+fEKfnh4/gCGADT
         FFw+MTeJTgcM4lJwk9La8xymVnRzYeb+JJ5W+dnYNNmqOjxxZDJ1ifMNJYoIpFvIYVvH
         DM6VKFi3mG5TmNuNTozKnfiopAPIzRa9Djm3rI8wHCPN54sKtT9vUnygvAy+HWRgT1QY
         1zsvxKPX8n1alKBz/OaMinsee4eFzlq6h2hMiYmqIPoeWn5rU5zN1guaup79UudEs/eM
         tZ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:in-reply-to:references:subject:to:from:cc;
        bh=N2pB7A1+M/tGMIJX4WLJD4oMISZoZphK8KZOxQiOHCM=;
        b=QyLwgYJR1na02EilrXTC9tDvSrDUXqRzyjBwD6wIasV4DNz46Mx1q1oxr/FuLv+0Xh
         YqZtjCSdtggwDyVDOq2DmtDxOwljVP+ev7ktOd4DzdXgwv+WZNziQaeaAuxMjJGOA+Ot
         Sa709wbyUaFXlPP8jmI2cxXFGODsJgFCaKJB23B9cNoTqQrNwmfkrW5ym/3rarzZEzmB
         as9b0ksDmUnkJwgMkq8sfT6WdLh3zgtICrD5oskeN+XjDqYbilxgJARFbGFcZNywrCrz
         h7o5Bj6Mk1R5rvBCHCoX5BifI0Ph8zh10mnbNMAzHALKxKFC4o2zs4dcpegJ5Wtn94Kf
         Tq1Q==
X-Gm-Message-State: APjAAAXfKwxRRg0IqKrNIOq61xAyBqoBA4cD/N37IXyAsE7eftDMeXli
        80rTOTLdIK6mqoHTvaJyMjllTw==
X-Google-Smtp-Source: APXvYqwc1ikWLln78aHMda+87Sj+x7QsNTVnMWo2UD5O26Hq2lMVlDsDVFn/tMpj+cBh27XAIUaL4g==
X-Received: by 2002:adf:8b09:: with SMTP id n9mr21958469wra.95.1573525152975;
        Mon, 11 Nov 2019 18:19:12 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j3sm16282536wrs.70.2019.11.11.18.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 18:19:12 -0800 (PST)
Message-ID: <5dca16a0.1c69fb81.35eb7.dbb1@mx.google.com>
Date:   Mon, 11 Nov 2019 18:19:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.153-106-ga46a2b6a665b
In-Reply-To: <20191111181421.390326245@linuxfoundation.org>
References: <20191111181421.390326245@linuxfoundation.org>
Subject: Re: [PATCH 4.14 000/105] 4.14.154-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 112 boots: 104 failed, 0 passed with 8 offline=
 (v4.14.153-106-ga46a2b6a665b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.153-106-ga46a2b6a665b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.153-106-ga46a2b6a665b/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.153-106-ga46a2b6a665b
Git Commit: a46a2b6a665bee1f0e231d13d5c04472bafec941
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 61 unique boards, 21 SoC families, 13 builds out of 201

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          bcm2836-rpi-2-b:
              lab-collabora: failing since 1 day (last pass: v4.14.153 - fi=
rst fail: v4.14.153-40-gf7fb2676f8a6)

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          dm365evm,legacy:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)

    exynos_defconfig:
        gcc-8:
          exynos4412-odroidx2:
              lab-collabora: failing since 1 day (last pass: v4.14.153 - fi=
rst fail: v4.14.153-40-gf7fb2676f8a6)
          exynos5250-arndale:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          exynos5420-arndale-octa:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          exynos5800-peach-pi:
              lab-collabora: failing since 1 day (last pass: v4.14.153 - fi=
rst fail: v4.14.153-40-gf7fb2676f8a6)
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)

    imx_v6_v7_defconfig:
        gcc-8:
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          imx6q-wandboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          imx7s-warp:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          vf610-colibri-eval-v3:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)

    multi_v7_defconfig:
        gcc-8:
          alpine-db:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          am335x-boneblack:
              lab-baylibre: failing since 1 day (last pass: v4.14.151 - fir=
st fail: v4.14.153-68-g0d12dcf336c6)
          armada-xp-openblocks-ax3-4:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          bcm2836-rpi-2-b:
              lab-collabora: failing since 1 day (last pass: v4.14.153 - fi=
rst fail: v4.14.153-40-gf7fb2676f8a6)
          exynos4412-odroidx2:
              lab-collabora: failing since 1 day (last pass: v4.14.153 - fi=
rst fail: v4.14.153-40-gf7fb2676f8a6)
          exynos5250-arndale:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          exynos5420-arndale-octa:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          exynos5800-peach-pi:
              lab-collabora: failing since 1 day (last pass: v4.14.153 - fi=
rst fail: v4.14.153-40-gf7fb2676f8a6)
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          imx6q-sabrelite:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          imx6q-wandboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          imx7s-warp:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          meson8b-odroidc1:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          mt7623n-bananapi-bpi-r2:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          omap3-beagle:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          omap3-beagle-xm:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          omap4-panda:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          rk3288-rock2-square:
              lab-collabora: failing since 1 day (last pass: v4.14.153 - fi=
rst fail: v4.14.153-40-gf7fb2676f8a6)
          rk3288-veyron-jaq:
              lab-collabora: failing since 1 day (last pass: v4.14.153 - fi=
rst fail: v4.14.153-40-gf7fb2676f8a6)
          socfpga_cyclone5_de0_sockit:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          stih410-b2120:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          sun5i-a13-olinuxino-micro:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          sun5i-r8-chip:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          sun7i-a20-cubieboard2:
              lab-clabbe: failing since 1 day (last pass: v4.14.153 - first=
 fail: v4.14.153-40-gf7fb2676f8a6)
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          sun8i-a83t-bananapi-m3:
              lab-clabbe: failing since 1 day (last pass: v4.14.153 - first=
 fail: v4.14.153-40-gf7fb2676f8a6)
          sun8i-h2-plus-orangepi-zero:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          tegra124-jetson-tk1:
              lab-collabora: failing since 1 day (last pass: v4.14.153 - fi=
rst fail: v4.14.153-40-gf7fb2676f8a6)
          tegra124-nyan-big:
              lab-collabora: failing since 1 day (last pass: v4.14.153 - fi=
rst fail: v4.14.153-40-gf7fb2676f8a6)
          tegra20-iris-512:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          tegra30-beaver:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          vf610-colibri-eval-v3:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          zynq-zc702:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)

    mvebu_v7_defconfig:
        gcc-8:
          armada-xp-openblocks-ax3-4:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)

    omap2plus_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-baylibre: failing since 1 day (last pass: v4.14.151 - fir=
st fail: v4.14.153-68-g0d12dcf336c6)
          omap3-beagle:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          omap3-beagle-xm:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          omap4-panda:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          sun5i-a13-olinuxino-micro:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          sun5i-r8-chip:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          sun7i-a20-cubieboard2:
              lab-clabbe: failing since 1 day (last pass: v4.14.153 - first=
 fail: v4.14.153-40-gf7fb2676f8a6)
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          sun8i-a33-olinuxino:
              lab-clabbe: failing since 1 day (last pass: v4.14.153 - first=
 fail: v4.14.153-40-gf7fb2676f8a6)
          sun8i-a83t-bananapi-m3:
              lab-clabbe: failing since 1 day (last pass: v4.14.153 - first=
 fail: v4.14.153-40-gf7fb2676f8a6)
          sun8i-h2-plus-orangepi-zero:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)

    tegra_defconfig:
        gcc-8:
          tegra124-jetson-tk1:
              lab-collabora: failing since 1 day (last pass: v4.14.153 - fi=
rst fail: v4.14.153-40-gf7fb2676f8a6)
          tegra124-nyan-big:
              lab-collabora: failing since 1 day (last pass: v4.14.153 - fi=
rst fail: v4.14.153-40-gf7fb2676f8a6)
          tegra20-iris-512:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          tegra30-beaver:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)

arm64:

    defconfig:
        gcc-8:
          bcm2837-rpi-3-b:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          juno-r2:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          meson-gxbb-p200:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          meson-gxl-s905x-libretech-cc:
              lab-clabbe: failing since 1 day (last pass: v4.14.153 - first=
 fail: v4.14.153-40-gf7fb2676f8a6)
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          meson-gxl-s905x-nexbox-a95x:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          meson-gxm-nexbox-a1:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          mt7622-rfb1:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)
          r8a7795-salvator-x:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          r8a7796-m3ulcb:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          sun50i-a64-bananapi-m64:
              lab-clabbe: failing since 1 day (last pass: v4.14.153 - first=
 fail: v4.14.153-40-gf7fb2676f8a6)
          sun50i-a64-pine64-plus:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.14.1=
53 - first fail: v4.14.153-40-gf7fb2676f8a6)

Boot Failures Detected:

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 2 failed labs

arm:
    tegra_defconfig:
        gcc-8:
            tegra124-jetson-tk1: 1 failed lab
            tegra124-nyan-big: 1 failed lab
            tegra20-iris-512: 1 failed lab
            tegra30-beaver: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            alpine-db: 1 failed lab
            am335x-boneblack: 1 failed lab
            armada-xp-openblocks-ax3-4: 1 failed lab
            bcm2836-rpi-2-b: 1 failed lab
            exynos4412-odroidx2: 1 failed lab
            exynos5250-arndale: 1 failed lab
            exynos5420-arndale-octa: 1 failed lab
            exynos5422-odroidxu3: 2 failed labs
            exynos5800-peach-pi: 2 failed labs
            imx6dl-wandboard_dual: 1 failed lab
            imx6dl-wandboard_solo: 1 failed lab
            imx6q-sabrelite: 2 failed labs
            imx6q-wandboard: 1 failed lab
            imx7s-warp: 1 failed lab
            meson8b-odroidc1: 2 failed labs
            mt7623n-bananapi-bpi-r2: 1 failed lab
            omap3-beagle: 1 failed lab
            omap4-panda: 3 failed labs
            qemu_arm-virt-gicv2: 2 failed labs
            qemu_arm-virt-gicv3: 2 failed labs
            rk3288-rock2-square: 1 failed lab
            rk3288-veyron-jaq: 1 failed lab
            socfpga_cyclone5_de0_sockit: 1 failed lab
            stih410-b2120: 1 failed lab
            sun4i-a10-cubieboard: 1 failed lab
            sun5i-a13-olinuxino-micro: 1 failed lab
            sun7i-a20-cubieboard2: 2 failed labs
            sun8i-a33-olinuxino: 1 failed lab
            sun8i-a83t-bananapi-m3: 1 failed lab
            sun8i-h2-plus-orangepi-zero: 1 failed lab
            tegra124-jetson-tk1: 1 failed lab
            tegra124-nyan-big: 1 failed lab
            tegra20-iris-512: 1 failed lab
            tegra30-beaver: 1 failed lab
            vf610-colibri-eval-v3: 1 failed lab
            zynq-zc702: 1 failed lab

    davinci_all_defconfig:
        gcc-8:
            da850-evm: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab
            sun5i-a13-olinuxino-micro: 1 failed lab
            sun7i-a20-cubieboard2: 2 failed labs
            sun8i-a33-olinuxino: 1 failed lab
            sun8i-a83t-bananapi-m3: 1 failed lab
            sun8i-h2-plus-orangepi-zero: 1 failed lab

    imx_v6_v7_defconfig:
        gcc-8:
            imx6dl-wandboard_dual: 1 failed lab
            imx6dl-wandboard_solo: 1 failed lab
            imx6q-wandboard: 1 failed lab
            imx7s-warp: 1 failed lab
            vf610-colibri-eval-v3: 1 failed lab

    exynos_defconfig:
        gcc-8:
            exynos4412-odroidx2: 1 failed lab
            exynos5250-arndale: 1 failed lab
            exynos5420-arndale-octa: 1 failed lab
            exynos5422-odroidxu3: 2 failed labs
            exynos5800-peach-pi: 2 failed labs

    bcm2835_defconfig:
        gcc-8:
            bcm2835-rpi-b: 1 failed lab
            bcm2836-rpi-2-b: 1 failed lab
            bcm2837-rpi-3-b: 1 failed lab

    omap2plus_defconfig:
        gcc-8:
            am335x-boneblack: 1 failed lab
            omap3-beagle: 1 failed lab
            omap3-beagle-xm: 1 failed lab
            omap4-panda: 3 failed labs

    mvebu_v7_defconfig:
        gcc-8:
            armada-xp-openblocks-ax3-4: 1 failed lab

x86_64:
    x86_64_defconfig:
        gcc-8:
            minnowboard-turbot-E3826: 1 failed lab
            qemu_x86_64: 2 failed labs

arm64:
    defconfig:
        gcc-8:
            bcm2837-rpi-3-b: 1 failed lab
            juno-r2: 1 failed lab
            meson-gxbb-p200: 1 failed lab
            meson-gxl-s905x-khadas-vim: 1 failed lab
            meson-gxl-s905x-libretech-cc: 3 failed labs
            meson-gxl-s905x-nexbox-a95x: 1 failed lab
            meson-gxm-nexbox-a1: 1 failed lab
            mt7622-rfb1: 1 failed lab
            qemu_arm64-virt-gicv2: 2 failed labs
            qemu_arm64-virt-gicv3: 2 failed labs
            r8a7795-salvator-x: 1 failed lab
            r8a7796-m3ulcb: 2 failed labs
            rk3399-gru-kevin: 1 failed lab
            sun50i-a64-bananapi-m64: 1 failed lab
            sun50i-a64-pine64-plus: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            omap3-beagle-xm: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
