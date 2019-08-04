Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAEDC80C09
	for <lists+stable@lfdr.de>; Sun,  4 Aug 2019 20:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbfHDSnQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Aug 2019 14:43:16 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:36344 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726392AbfHDSnQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Aug 2019 14:43:16 -0400
Received: by mail-wr1-f50.google.com with SMTP id n4so82268566wrs.3
        for <stable@vger.kernel.org>; Sun, 04 Aug 2019 11:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nqHd75BtlXYYIGX85OIyC/Q/HOdBaJPIfLMIS7PdYrg=;
        b=bb6og71pgk+LNpaWeQHb23cYvIgOWaIPGbhAiUZc1yLxCMXDNkemkNuJvUl2x1+roF
         fFNllVFk/oE289kbvaBt200E6ywJ8IUTsrtlwehQl++/rf+W/E6UnNAx6OUrx5CELXV0
         OovmE3Lmr+/oHPXDIMcvjke5O2k4+KxuHh03GuTltQGdvuaU7qRO4+VzXw/lp7VdBQtT
         EHun34rZi8D50KAzZPsp5xkYtLIRgoy+Ph2oxC2ac1z+XnjjH2OxLtEzARcK4yLcavpt
         kqWOlVGDiHC/iJWZYqLKNdjMubhy1ZEq2wQFgAuVy3DooUp2SmmcRUJwLTb0m6OCYbWw
         JZ9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nqHd75BtlXYYIGX85OIyC/Q/HOdBaJPIfLMIS7PdYrg=;
        b=EUBiBiTXOg2vN7L/OzKllhV+l2ke4znOBIdXPn/A6OMcNtogWRg4yiCdcUcg3J3Zpa
         toec4CDIVQ/PDWvWCIlWRmkQzS8YPQt6A0wNqBXOp4I1Gv980Af/NwDTneQ2RTLZjcXI
         eZH+NPd2FOxXbvTJuRJVIiTcQGSQrHShVR401EdIDz79xTLeYu9RtCo/aUi7qVx6Uoyx
         aZebQ8SYgzpa9H/i24r04aaJJjlufjenqoVL2JzTAnqtTcSI/CbFEOzsAiWDqAZxGLSW
         aD4GHEtMCCKPnwZ7aFJ5I8ax3f3TZhMkLEKpJZVZzwUanG0ra2OaS2Rmrqr1dMvwwi4H
         u2jg==
X-Gm-Message-State: APjAAAVoMmaqdHWWe20QZ6FFrTVTNQmFn5eH9Te21mjo2G8CyF+Wwbip
        HZJw/MeY5y8svig/N7EC5mOsQzX9
X-Google-Smtp-Source: APXvYqyNb/jP/TGcO1sVNMpSUh+6Js5ZdE8jcNrUYcxA2hbpc2ruRyzhHNAfJtrhzG10GYkqYlmPcw==
X-Received: by 2002:a5d:48cf:: with SMTP id p15mr110363788wrs.151.1564944193124;
        Sun, 04 Aug 2019 11:43:13 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y16sm174612667wrg.85.2019.08.04.11.43.12
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Aug 2019 11:43:12 -0700 (PDT)
Message-ID: <5d472740.1c69fb81.39b2e.9642@mx.google.com>
Date:   Sun, 04 Aug 2019 11:43:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.2.6
X-Kernelci-Branch: linux-5.2.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.2.y boot: 130 boots: 0 failed,
 79 passed with 51 offline (v5.2.6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 130 boots: 0 failed, 79 passed with 51 offline =
(v5.2.6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.6/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.6
Git Commit: ec97ca18aa3a9123b5b64339e5993347295ebf88
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 26 SoC families, 17 builds out of 209

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: new failure (last pass: v5.2.4-235-g443=
97d30b22d)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: new failure (last pass: v5.2.4-235-g443=
97d30b22d)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v5.2.4-235-g443=
97d30b22d)
          sun5i-r8-chip:
              lab-baylibre-seattle: new failure (last pass: v5.2.4-235-g443=
97d30b22d)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: new failure (last pass: v5.2.4-235-g443=
97d30b22d)

Offline Platforms:

riscv:

    defconfig:
        gcc-8
            sifive_fu540: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-axg-s400: 1 offline lab
            meson-g12a-u200: 1 offline lab
            meson-g12a-x96-max: 1 offline lab
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
            bcm4708-smartrg-sr400ac: 1 offline lab
            bcm72521-bcm97252sffe: 1 offline lab
            bcm7445-bcm97445c: 1 offline lab
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
