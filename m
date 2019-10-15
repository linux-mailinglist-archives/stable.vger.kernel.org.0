Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A534D76F8
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 15:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbfJONCb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 09:02:31 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34927 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbfJONCb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Oct 2019 09:02:31 -0400
Received: by mail-wm1-f68.google.com with SMTP id y21so20191403wmi.0
        for <stable@vger.kernel.org>; Tue, 15 Oct 2019 06:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rjCeZmeDDql0zs9FSFh8U4p+/4VGoTlEz7lrEobchMo=;
        b=P5e3ZnO/sJ1viK8EJBJLavYp5SfT/e+DHwAY/wSnVEfqU4ZJLQMQK/PjC+NdLN/v/U
         nCh27Bg0vYBECbdfnnBdJyTwJcL4AGBbiAgAL4rDG+0mhwYrfAukNxnBg9fxeFkIz1O4
         6htI/E4open03X9L8xBXhysq+0PDDANuLW7cQgE5nrEjZMKrVFHVmzqUhtJ+1ZNn1+7j
         dXTwMGMT0skfWEk0panFsmei6TXNdPZsJTvj2zvNsVmxRFS2/ZmRAmE1+N55VtOOvXa+
         2mC5wVekhBXHyzESXij6/fyxONfdi5Q/4Qso47RRb2Mw0ciSo4kyWSCmuV7SH+Ak8son
         Ei8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rjCeZmeDDql0zs9FSFh8U4p+/4VGoTlEz7lrEobchMo=;
        b=Zxz3xtBfAwZpyAouR/a5JopqWE9QQqxLH76nn+3LXzGOYKf5SMiqQxOSnrWwToOsIl
         kNSNv1qH7Mkrp9FFsNh7EYMT8xIo+bJQ4hh/JZL2wmbeYC0R05RZX/6PlBsti7g77RXY
         ZWyK+YHSMgeeMO0JXAc61o8ElI4Zh0fKoBXLwBSUS2q7DiR+1PdsyO7MREbQng5fQS9e
         k5kUq7C0prsURx3rj7isfOy3b4JxG0Pg8EGhrY9YTXXnzeZnlaCRdt3ykBHTDWGLwqAJ
         MT6/q1g1b9Mc4At55Bz7Tm7WwH3+obZ0NmCUidtCvbWYBSo/rgKBaFDG71ZnVv5e2jit
         dLSA==
X-Gm-Message-State: APjAAAUpoao4DgTQuUOjvfMj7h9QYd4vsFd0axaBvT7dV4Zgpp4hhGds
        boSemtJ66gOuIO97RUrZq9/k9ZgoWv6X/A==
X-Google-Smtp-Source: APXvYqwO/rJP5izYkHlg7DjHVBfGpLFD7uTobIJQaKrLo73Yp6Pu4u5Rd7z9cToWmUkRoGG0ELQThQ==
X-Received: by 2002:a7b:c395:: with SMTP id s21mr20408686wmj.114.1571144548179;
        Tue, 15 Oct 2019 06:02:28 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id o18sm2363501wrm.11.2019.10.15.06.02.27
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Oct 2019 06:02:27 -0700 (PDT)
Message-ID: <5da5c363.1c69fb81.27ff.a908@mx.google.com>
Date:   Tue, 15 Oct 2019 06:02:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.79-63-g7ac3425b7f23
Subject: stable-rc/linux-4.19.y boot: 112 boots: 9 failed,
 53 passed with 48 offline, 2 conflicts (v4.19.79-63-g7ac3425b7f23)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 112 boots: 9 failed, 53 passed with 48 offline=
, 2 conflicts (v4.19.79-63-g7ac3425b7f23)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.79-63-g7ac3425b7f23/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.79-63-g7ac3425b7f23/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.79-63-g7ac3425b7f23
Git Commit: 7ac3425b7f23293144564cedc5bb49620008fa7f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 72 unique boards, 23 SoC families, 15 builds out of 206

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.19.79)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.19.79)

    exynos_defconfig:
        gcc-8:
          exynos5250-arndale:
              lab-baylibre-seattle: new failure (last pass: v4.19.79)
          exynos5420-arndale-octa:
              lab-baylibre-seattle: new failure (last pass: v4.19.79)
          exynos5800-peach-pi:
              lab-baylibre-seattle: new failure (last pass: v4.19.79)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v4.19.79)
          sun5i-r8-chip:
              lab-baylibre-seattle: new failure (last pass: v4.19.79)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: new failure (last pass: v4.19.79)

    tegra_defconfig:
        gcc-8:
          tegra30-beaver:
              lab-baylibre-seattle: new failure (last pass: v4.19.79)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxl-s905d-p230: 1 failed lab
            meson-gxl-s905x-khadas-vim: 1 failed lab

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-cubieboard2: 1 failed lab
            sun8i-h2-plus-orangepi-r1: 1 failed lab
            sun8i-h2-plus-orangepi-zero: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-cubieboard2: 1 failed lab
            sun8i-h2-plus-orangepi-r1: 1 failed lab
            sun8i-h2-plus-orangepi-zero: 1 failed lab

    davinci_all_defconfig:
        gcc-8:
            da850-lcdk: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-axg-s400: 1 offline lab
            meson-gxl-s905x-libretech-cc: 1 offline lab
            meson-gxl-s905x-nexbox-a95x: 1 offline lab
            meson-gxm-nexbox-a1: 1 offline lab
            rk3399-firefly: 1 offline lab

arm:

    sunxi_defconfig:
        gcc-8
            sun4i-a10-cubieboard: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            armada-xp-openblocks-ax3-4: 1 offline lab
            exynos5250-arndale: 1 offline lab
            exynos5420-arndale-octa: 1 offline lab
            exynos5800-peach-pi: 1 offline lab
            imx6dl-wandboard_dual: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab
            imx7s-warp: 1 offline lab
            meson8b-odroidc1: 1 offline lab
            mt7623n-bananapi-bpi-r2: 1 offline lab
            omap3-beagle: 1 offline lab
            omap3-beagle-xm: 1 offline lab
            omap4-panda: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            stih410-b2120: 1 offline lab
            sun4i-a10-cubieboard: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab
            tegra30-beaver: 1 offline lab
            vf610-colibri-eval-v3: 1 offline lab
            zynq-zc702: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    omap2plus_defconfig:
        gcc-8
            omap3-beagle: 1 offline lab
            omap3-beagle-xm: 1 offline lab
            omap4-panda: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra30-beaver: 1 offline lab

    mvebu_v7_defconfig:
        gcc-8
            armada-xp-openblocks-ax3-4: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab
            imx7s-warp: 1 offline lab
            vf610-colibri-eval-v3: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5250-arndale: 1 offline lab
            exynos5420-arndale-octa: 1 offline lab
            exynos5800-peach-pi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

arm:
    multi_v7_defconfig:
        tegra124-jetson-tk1:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

    tegra_defconfig:
        tegra124-jetson-tk1:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
