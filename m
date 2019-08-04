Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EFF480C30
	for <lists+stable@lfdr.de>; Sun,  4 Aug 2019 21:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbfHDT1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Aug 2019 15:27:47 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:40709 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbfHDT1r (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Aug 2019 15:27:47 -0400
Received: by mail-wr1-f49.google.com with SMTP id r1so82208432wrl.7
        for <stable@vger.kernel.org>; Sun, 04 Aug 2019 12:27:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZuG5jwM45BNwr0Hjl5WntwRa2hpAktIjoLNp8c9uIxM=;
        b=XsaLKcBbK9Q1+m8YO+yufaB2R2lNVs3OfIEl1OVPhrjWzqk9jh+sEZvYhCKLsvH9Re
         AdCtf8Quw1rRSwzEI0qZnMWXBTXlyfLZyOOAFeuffKJ+BwD34PTVzSdbWsEATYHhpYVj
         jlItpGjsIVPhBMkkU2eDpW+FmtfTTPIUV6KfCOcDU++v0ROF9fcRbMiwVBh1mWT/9OWf
         I3AjKG6MGt5iLD8O6h+6onvIiD+nIN4GX4EgbI/VJ2CKtsWjJQcE4WKkQE9ZpUACBCai
         BVfw1+UX1A+U2DXck7a5waRWXMSCe04m8Ka9L2AUwzELdXYqTw+dZTKl4+h7qWowpcHZ
         atlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZuG5jwM45BNwr0Hjl5WntwRa2hpAktIjoLNp8c9uIxM=;
        b=A52G2TwfDSuyZqUWjJZ/pH86PRIVMl61YJGl/8vdWTfda38DTSvY6LFXsWkYdN+8pU
         wU1EZUPxrEVcHBtvcu59L8CZSVKAsTV4CBVTa8BjYXJ7PYEAobR3AWiJ3qLHZhcReQlb
         XTHqveJkhZHHdiYF6zuSqpTgD1iEFGrGqEVxetCCRPB1hTS+OD6P0t/Uz3qyvot4hEcp
         WNEzaOVZbzDBUxtFoKHpCDeqpbMBInj2rjA0RcjNf0qzuRFj75Z0G9iBt6vrYoJjbJYM
         f1U6PXepnO3xbu5z1WdtaQBPzxp0xZV9VonBrmdSLgYLImw9CuTUiuyTi6JG7PbtMsrk
         f7Gg==
X-Gm-Message-State: APjAAAWvTsonfRw5gNwzfuqzMk5gZ0x7nqG2z5VltI9TuO0O59Yuv2Uh
        ZDpP9iGvUUH2BudXY1CTBMRYw8Rm
X-Google-Smtp-Source: APXvYqzSo/mcvCyGJqG757MSPM8rDFah6hYsGoLXZZjeQZCC+3JkxyHq27w0hJxX3n0wnJb5m2ntSw==
X-Received: by 2002:a5d:5388:: with SMTP id d8mr12950281wrv.299.1564946865287;
        Sun, 04 Aug 2019 12:27:45 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f3sm67322307wrt.56.2019.08.04.12.27.44
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Aug 2019 12:27:44 -0700 (PDT)
Message-ID: <5d4731b0.1c69fb81.21b90.6a0a@mx.google.com>
Date:   Sun, 04 Aug 2019 12:27:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.136
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 116 boots: 1 failed,
 69 passed with 46 offline (v4.14.136)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 116 boots: 1 failed, 69 passed with 46 offline=
 (v4.14.136)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.136/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.136/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.136
Git Commit: 7d80e1218adf6d1aa5270587192789e218fef706
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 63 unique boards, 25 SoC families, 16 builds out of 201

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v4.14.134-319-g=
8c06cc9d4172)
          sun5i-r8-chip:
              lab-baylibre-seattle: new failure (last pass: v4.14.134-319-g=
8c06cc9d4172)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: new failure (last pass: v4.14.134-319-g=
8c06cc9d4172)

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

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

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
            tegra20-iris-512: 1 offline lab
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
