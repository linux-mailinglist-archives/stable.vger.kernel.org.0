Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE588D76A1
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 14:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726168AbfJOMeS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 08:34:18 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44636 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbfJOMeS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Oct 2019 08:34:18 -0400
Received: by mail-wr1-f67.google.com with SMTP id z9so23637243wrl.11
        for <stable@vger.kernel.org>; Tue, 15 Oct 2019 05:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nixrBB+LB5quOtw+0GrjR14PMS0jaFiIAASwSpRYNXg=;
        b=PqqCjfXcsP77/+jRcIpw+VHkSeRGkPbVCjVTDgxDXjWTUCo/tAd1059wrbTPtFssZq
         sGIDoL7aVoSl6boJDex/iRP1elKmCEqoq3ekjv97we8dtry8voc1QWzQ8fP93zotMLGv
         JT0Mfo57vLEMvFX1Cr/+1HUjYdu7LfbKrJXY6KwdSGqlKQjN/7LASBDgODUWZxhH0OTL
         KQGnHmVkZZxnQ0Oj1px3v6RewdaQR3PjfrOQmxkXEapgHCmrNxMYnOmI1NW7smR9ezVv
         MvhAJG6e3jX/0hwldJpiDK4dw6WxGN3feqpXAq1iowCbRg8SP/gc1VVdbWb/I3QgPX0g
         IJaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nixrBB+LB5quOtw+0GrjR14PMS0jaFiIAASwSpRYNXg=;
        b=MR5JjAPkD9xQhE4yp/r1V4qKDluKonZ7v3+FnPS7K1lQ2ysCqnPNn4KqOlv254SzA0
         l03z8P9WFdFQCk39reKAXNey1/C8p2gdzjTk2Kn/9auNVWQE9uTsxsBfz1MQPx46wWYy
         ptwlvqvNdiaGTntBfHjpedzbY+g7Z0i4Mv6jarno/W0XuRVKC+Fep6qVWXwM451YUUnQ
         r+zSScnxfNqfTe2RrrlBmR+dhwTmUrrg8zhvTpPcRvzuq2LiVSDr5ShJBogUvZvYwLDD
         ba8vNWOTWbwBts0zRGzWOgA7rSSTQ9H5x9J3e+i2t+VsRTWgBIsSa8RxZHpuZhmiQjw9
         TeFA==
X-Gm-Message-State: APjAAAUkK59nfu4/c+AyXZqcjbZ7uKM3wgvJ4ae2ilIEPAEswP2hT3MF
        7elglb7Ku6jEB1rhubyxm7jKjv1a4MuG2Q==
X-Google-Smtp-Source: APXvYqyby5OkJLs/3KbIlowKsXnLsptcfg1taPsXs8QS2XThwI1Q6sGBdVMLc/+83G54qtL7YYUA7w==
X-Received: by 2002:a05:6000:1051:: with SMTP id c17mr5055888wrx.124.1571142854755;
        Tue, 15 Oct 2019 05:34:14 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a18sm31192673wrs.27.2019.10.15.05.34.12
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Oct 2019 05:34:14 -0700 (PDT)
Message-ID: <5da5bcc6.1c69fb81.5072.4f63@mx.google.com>
Date:   Tue, 15 Oct 2019 05:34:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.196-78-ge661a3bf292f
Subject: stable-rc/linux-4.4.y boot: 76 boots: 3 failed,
 29 passed with 42 offline, 2 conflicts (v4.4.196-78-ge661a3bf292f)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 76 boots: 3 failed, 29 passed with 42 offline, =
2 conflicts (v4.4.196-78-ge661a3bf292f)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.196-78-ge661a3bf292f/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.196-78-ge661a3bf292f/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.196-78-ge661a3bf292f
Git Commit: e661a3bf292fb2b142edac964eb856d60a3807dc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 43 unique boards, 17 SoC families, 13 builds out of 190

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.4.196-31-gc0=
3a561a2969)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.4.196-31-gc0=
3a561a2969)

    exynos_defconfig:
        gcc-8:
          exynos5250-arndale:
              lab-baylibre-seattle: new failure (last pass: v4.4.196-31-gc0=
3a561a2969)
          exynos5420-arndale-octa:
              lab-baylibre-seattle: new failure (last pass: v4.4.196-31-gc0=
3a561a2969)
          exynos5800-peach-pi:
              lab-baylibre-seattle: new failure (last pass: v4.4.196-31-gc0=
3a561a2969)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v4.4.196-31-gc0=
3a561a2969)
          sun5i-r8-chip:
              lab-baylibre-seattle: new failure (last pass: v4.4.196-31-gc0=
3a561a2969)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: new failure (last pass: v4.4.196-31-gc0=
3a561a2969)

    tegra_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.4.196-31-gc0=
3a561a2969)
          tegra30-beaver:
              lab-baylibre-seattle: new failure (last pass: v4.4.196-31-gc0=
3a561a2969)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-cubieboard2: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-cubieboard2: 1 failed lab

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

arm:

    sunxi_defconfig:
        gcc-8
            sun4i-a10-cubieboard: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            armada-xp-openblocks-ax3-4: 1 offline lab
            bcm4708-smartrg-sr400ac: 1 offline lab
            exynos5250-arndale: 1 offline lab
            exynos5420-arndale-octa: 1 offline lab
            exynos5800-peach-pi: 1 offline lab
            imx6dl-wandboard_dual: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab
            meson8b-odroidc1: 1 offline lab
            omap3-beagle: 1 offline lab
            omap3-beagle-xm: 1 offline lab
            omap4-panda: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            sun4i-a10-cubieboard: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab
            tegra20-iris-512: 1 offline lab
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
            tegra20-iris-512: 1 offline lab
            tegra30-beaver: 1 offline lab

    mvebu_v7_defconfig:
        gcc-8
            armada-xp-openblocks-ax3-4: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab
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
