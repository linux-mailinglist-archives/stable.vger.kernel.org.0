Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E350280C18
	for <lists+stable@lfdr.de>; Sun,  4 Aug 2019 21:12:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfHDTMa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Aug 2019 15:12:30 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:32963 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbfHDTMa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Aug 2019 15:12:30 -0400
Received: by mail-wr1-f41.google.com with SMTP id n9so82348029wru.0
        for <stable@vger.kernel.org>; Sun, 04 Aug 2019 12:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1oHZ3nrqZmJsCoKqXfu5SgsoRqE9VVMOm26jx3PHEgc=;
        b=GAGfJ34HONE5qH2pH/fb03zyu6sxjynoox1kr9Z1MphgCgj1aEbQrIgLLI3kiDRSlg
         uCXAEpKp3vi4IEfu/6/14f4DdBg0VQz9ZHnmg8nscxC5LkOdMBQb9jR/A/gNdmGMXNBP
         ayvmUs0BVtp8jK81bQrIpLPXsVMstqoe4tL5op5dQ9wSelr0oyWaC/F4Ynz7SmNV+J7d
         5bSRAZtPfv3VrlFF9kgeBFCinlCIaaGaQYTOQQ9PM9/nxMCB7PDZPhaluUm9rDvrNC3A
         DJzYJC+Lr8bHW3izkJ+SBLBm1z+1N6QFW355At+Z+xsV/7HWJ6HJLGHEJIegtUD2cRwg
         F0Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1oHZ3nrqZmJsCoKqXfu5SgsoRqE9VVMOm26jx3PHEgc=;
        b=BKgSG/LEwpA/8QDOIAwrpgtV/+eHn718lPzA1cUs9+/50wzgbr7xBJKf4rGte6J5Xp
         5Cb0IEicpjFONFz4hiPO8VgP06Q4W9m3dC1UFgWFMFjXXQxURY1owkZ8bF1hrijTNX8I
         mZgXV1wWxH3+jPHFJ0R265ffVBHB+Hq+6scDBy/JloZl+9pJDpPDFKpeI9BLlQLc4w5c
         5UDjb9mo1jYCY7e9bU57PTOrLPyMGN98S8PocC7gP8RFu8CDW9+By6T6A13U8SU/qFpX
         RseWulYm9KuArq/JSYMVrR5THxTjlMWb2ioSyyrG/e7INCKL0gj+/0jRVZP/O64dmHe1
         ncFQ==
X-Gm-Message-State: APjAAAUZBYmwwIgslfPame/Lxik7PtyfR/LooHmXSzAQX/B6BKy3TyWT
        ebuYL+v/S9zrP75UezHRNi79Dyvh
X-Google-Smtp-Source: APXvYqx4+jzlaeMVwyW6XtpRkHHmfcopYDm53lCTmIDV6Cnw8rnRVsXvMMma0ct5AvXFYlVT8LJ+ow==
X-Received: by 2002:adf:f204:: with SMTP id p4mr39799138wro.317.1564945948118;
        Sun, 04 Aug 2019 12:12:28 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p14sm67604087wrx.17.2019.08.04.12.12.27
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Aug 2019 12:12:27 -0700 (PDT)
Message-ID: <5d472e1b.1c69fb81.fc0d4.2f0c@mx.google.com>
Date:   Sun, 04 Aug 2019 12:12:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.64
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 122 boots: 1 failed,
 75 passed with 45 offline, 1 untried/unknown (v4.19.64)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 122 boots: 1 failed, 75 passed with 45 offline=
, 1 untried/unknown (v4.19.64)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.64/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.64/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.64
Git Commit: b3060a1a313ff7a545d658378f62fe9c250acdee
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 69 unique boards, 26 SoC families, 17 builds out of 206

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: new failure (last pass: v4.19.62-148-g6=
3a8dab46af2)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: new failure (last pass: v4.19.62-148-g6=
3a8dab46af2)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v4.19.62-148-g6=
3a8dab46af2)
          sun5i-r8-chip:
              lab-baylibre-seattle: new failure (last pass: v4.19.62-148-g6=
3a8dab46af2)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: new failure (last pass: v4.19.62-148-g6=
3a8dab46af2)

Boot Failure Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-axg-s400: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab
            meson-gxl-s905d-p230: 1 offline lab
            meson-gxl-s905x-libretech-cc: 1 offline lab
            meson-gxl-s905x-nexbox-a95x: 1 offline lab
            meson-gxl-s905x-p212: 1 offline lab
            meson-gxm-nexbox-a1: 1 offline lab
            rk3399-firefly: 1 offline lab
            sun50i-a64-pine64-plus: 1 offline lab

mips:

    pistachio_defconfig:
        gcc-8
            pistachio_marduk: 1 offline lab

arm:

    exynos_defconfig:
        gcc-8
            exynos5250-arndale: 1 offline lab
            exynos5420-arndale-octa: 1 offline lab
            exynos5800-peach-pi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5250-arndale: 1 offline lab
            exynos5420-arndale-octa: 1 offline lab
            exynos5800-peach-pi: 1 offline lab
            imx6dl-wandboard_dual: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab
            imx7s-warp: 1 offline lab
            meson8b-odroidc1: 1 offline lab
            omap3-beagle: 1 offline lab
            omap4-panda: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            stih410-b2120: 1 offline lab
            sun4i-a10-cubieboard: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab
            vf610-colibri-eval-v3: 1 offline lab

    omap2plus_defconfig:
        gcc-8
            omap3-beagle: 1 offline lab
            omap4-panda: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab
            imx7s-warp: 1 offline lab
            vf610-colibri-eval-v3: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun4i-a10-cubieboard: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
