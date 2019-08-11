Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DCFD894E2
	for <lists+stable@lfdr.de>; Mon, 12 Aug 2019 01:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbfHKXhn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Aug 2019 19:37:43 -0400
Received: from mail-wr1-f50.google.com ([209.85.221.50]:45536 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfHKXhm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Aug 2019 19:37:42 -0400
Received: by mail-wr1-f50.google.com with SMTP id q12so12818820wrj.12
        for <stable@vger.kernel.org>; Sun, 11 Aug 2019 16:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=o7rzErCT/XfhEzn9rB1q3jzvI62NjJtdHOw9bvWDu4g=;
        b=PXZ8nsMZs1oXMLtaDyCB9qNUPDBwldkPCWCWWipVVt6P9JyRc61aadgLBSXxqKgGBV
         Q9lCPxACOy/2VaJogNx95DbKxB4K0k/BsLHpoP4dk93woPq39g3UIpacikvkksYsgfL3
         rZVRN1sl7W8W3cLZpv13xUpo6Kq4SNnPyNPpH5KGAauDqX7a9lHE3qrFqC+KXsplI8pZ
         hAO1a4ux4Ut/lCEHM+vRh0emSLwJ5iixFhYx3zeRH7Voa3iznYavhuW3scKPEMW0UZJH
         MWECvlLULyRe5GGMT6dxWmXrlhCQDhDGqn37X9AbsxJXBmyo6eHIj+wcmi7ZIj2JZaRS
         dSdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=o7rzErCT/XfhEzn9rB1q3jzvI62NjJtdHOw9bvWDu4g=;
        b=AWeIoH+XdhNdUaBGEJX2CNmNWP6hihvod9+wDIVNMfjmmfhj5X8x/IBcolCTviYCzO
         HpDjn3q8stJOGaVS8moqIeyQOtsVN+iRkIkCG4PBUa+ZWZrAg7vV8/sjmad/IOUogIZe
         EnOWPMwoTXSNR1iOBN0GzQuvMdl4A+Fofa+JMOfbNHQ25PR1maIgaeAVyXYw7MLt04t+
         7c7eC/7jdVX29+jbzC+Y37F5BJ/uZo/odRgNrJszOge3u/9S3xsuyJ5strJsVx66OcXS
         TEnTkcGIJWIDKPylyMPxIGF5crUJNw0rJj3J0syfe4kemTTGNoWhc8xhR67JvjLqrl+W
         BEaQ==
X-Gm-Message-State: APjAAAV+TJRhR3d6WkkX8aDsYMs9iLADy/vVhSU9SG8MGxhkUmd3fwgd
        VYrcorwv6UqG39SiQpgeU8platFbW9c=
X-Google-Smtp-Source: APXvYqxroSHFdU0YA61k9eHnloQwDQ7rBcxDosvaG6YdgHiwuJEIlS43ofWS/L6PfEBb+vlDHxXKQg==
X-Received: by 2002:a5d:56c7:: with SMTP id m7mr37936749wrw.64.1565566658732;
        Sun, 11 Aug 2019 16:37:38 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n12sm11749119wmc.24.2019.08.11.16.37.37
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Aug 2019 16:37:38 -0700 (PDT)
Message-ID: <5d50a6c2.1c69fb81.3079d.bdee@mx.google.com>
Date:   Sun, 11 Aug 2019 16:37:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.189
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 102 boots: 0 failed,
 49 passed with 53 offline (v4.9.189)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 102 boots: 0 failed, 49 passed with 53 offline =
(v4.9.189)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.189/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.189/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.189
Git Commit: 4bd718dba6581ebd392539ad659642552fb5826c
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 22 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 2 days (last pass: v4.9.1=
87-43-g228fba508ff1 - first fail: v4.9.187-71-g399cf2b4ebf0)

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)

    exynos_defconfig:
        gcc-8:
          exynos5250-arndale:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          exynos5420-arndale-octa:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          exynos5800-peach-pi:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)

    imx_v6_v7_defconfig:
        gcc-8:
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          imx6q-wandboard:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          imx7s-warp:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          vf610-colibri-eval-v3:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)

    multi_v7_defconfig:
        gcc-8:
          alpine-db:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          armada-xp-openblocks-ax3-4:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          at91-sama5d4_xplained:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          bcm4708-smartrg-sr400ac:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          bcm72521-bcm97252sffe:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          bcm7445-bcm97445c:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          exynos5250-arndale:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          exynos5420-arndale-octa:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          exynos5800-peach-pi:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          imx6q-wandboard:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          imx7s-warp:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          meson8b-odroidc1:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          omap3-beagle:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          omap4-panda:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          socfpga_cyclone5_de0_sockit:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          stih410-b2120:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          sun5i-r8-chip:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          tegra30-beaver:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          vf610-colibri-eval-v3:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          zynq-zc702:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)

    mvebu_v7_defconfig:
        gcc-8:
          armada-xp-openblocks-ax3-4:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          omap4-panda:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          qcom-apq8064-ifc6410:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: failing since 2 days (last pass: v4.9.1=
87-43-g228fba508ff1 - first fail: v4.9.187-71-g399cf2b4ebf0)

    socfpga_defconfig:
        gcc-8:
          socfpga_cyclone5_de0_sockit:
              lab-baylibre-seattle: failing since 2 days (last pass: v4.9.1=
87-43-g228fba508ff1 - first fail: v4.9.187-71-g399cf2b4ebf0)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          sun5i-r8-chip:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)

    tegra_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)
          tegra30-beaver:
              lab-baylibre-seattle: new failure (last pass: v4.9.188-33-g26=
0869840af4)

arm64:

    defconfig:
        gcc-8:
          apq8016-sbc:
              lab-baylibre-seattle: failing since 2 days (last pass: v4.9.1=
87-43-g228fba508ff1 - first fail: v4.9.187-71-g399cf2b4ebf0)
          juno-r2:
              lab-baylibre-seattle: failing since 2 days (last pass: v4.9.1=
87-43-g228fba508ff1 - first fail: v4.9.187-71-g399cf2b4ebf0)
          meson-gxbb-odroidc2:
              lab-baylibre-seattle: failing since 2 days (last pass: v4.9.1=
87-43-g228fba508ff1 - first fail: v4.9.187-71-g399cf2b4ebf0)

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

    mvebu_v7_defconfig:
        gcc-8
            armada-xp-openblocks-ax3-4: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun4i-a10-cubieboard: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab
            imx7s-warp: 1 offline lab
            vf610-colibri-eval-v3: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    omap2plus_defconfig:
        gcc-8
            omap3-beagle: 1 offline lab
            omap4-panda: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            armada-xp-openblocks-ax3-4: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
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
            socfpga_cyclone5_de0_sockit: 1 offline lab
            stih410-b2120: 1 offline lab
            sun4i-a10-cubieboard: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab
            tegra20-iris-512: 1 offline lab
            tegra30-beaver: 1 offline lab
            vf610-colibri-eval-v3: 1 offline lab
            zynq-zc702: 1 offline lab

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab
            tegra30-beaver: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5250-arndale: 1 offline lab
            exynos5420-arndale-octa: 1 offline lab
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
