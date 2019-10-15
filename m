Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6743D76BB
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 14:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729167AbfJOMog (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 08:44:36 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33455 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726721AbfJOMof (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Oct 2019 08:44:35 -0400
Received: by mail-wr1-f66.google.com with SMTP id b9so23717751wrs.0
        for <stable@vger.kernel.org>; Tue, 15 Oct 2019 05:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fGXtVDNe676fjOk+215lSK8WpRkthWF0c0SLH43SK28=;
        b=jVbUrHgzbiK/GmwsJyVAnBRKx/5grDN2ijPzNpPA1xijluTohODaJEVKRG1yKh9VjR
         /BXQapJvVrYLx+58HElpxOLRMrr58iO/+zGKgM/dG0WkeOVv145bkNVpwk5DtWeR3TN0
         QRIs2+gxh6Vh7UDw8KfuIinYQfr3B5WEGHNUkJHOfkj0LS6S28XzIVDQa/4eaQblWt8y
         trmewNI0UXC5lfl44egpb5shM4bR4rFroqqf5dw5OXXwz1lddrFBb74TbiyeSWqJU6vu
         PTSfWx8NYl/cGPYipJ81OIpqyq6CWvU8wJUJxbCdSMRF1HzoyjtZOae1N32JOcSpqHbA
         yZTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fGXtVDNe676fjOk+215lSK8WpRkthWF0c0SLH43SK28=;
        b=JUcIw8KiRaqS2U9UN6+SXnIyKixNZcWnflDZZRG+Wahi9hjxP6GqAFPrlNNXzDrcM0
         l29UOlyVNJZcUBO9GS7EmMIOU1ggxNDIwXXAY2UfPsVtbU3tW+AFZlVfPqnfYRwgGKCi
         PP7L1K24nEYm/2hFrvj33FXwLpqUK9Lro854vN0qqg2AnuuHHZbxtQobL+LAwpcL6HRY
         UsvITS3J84r9XWoRk05HgRzcw1Mu8vOMhr28f+J1Ek2T7rfEEMKTFWHuOhFYTR+fnLko
         U2u4xeHQVJBC0xE6jbBZUZgfUjDpaAjZQqwpIpQK9MCDlLSvnNHtfRCU8cmbgZtlf+gW
         eAcA==
X-Gm-Message-State: APjAAAV7zCHoGZL68htFwEooR3SLmNDG8JeV/9tA8VCVC8gUEDApOISN
        EtwwdLcAKiDnQjL4r5v81lnsvw0KZ6lMtw==
X-Google-Smtp-Source: APXvYqxl/ZVrv2B8QSspwDbTDbmz6lrAfycKg/atYiK30VnYQ+8LNfmGL6Wsjx6csJWjA7jKTapdHg==
X-Received: by 2002:a5d:4946:: with SMTP id r6mr13902453wrs.53.1571143473042;
        Tue, 15 Oct 2019 05:44:33 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c132sm31319532wme.27.2019.10.15.05.44.32
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Oct 2019 05:44:32 -0700 (PDT)
Message-ID: <5da5bf30.1c69fb81.9a8d7.55df@mx.google.com>
Date:   Tue, 15 Oct 2019 05:44:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.9.196-86-gd3fe57936b13
Subject: stable-rc/linux-4.9.y boot: 33 boots: 3 failed,
 9 passed with 21 offline (v4.9.196-86-gd3fe57936b13)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 33 boots: 3 failed, 9 passed with 21 offline (v=
4.9.196-86-gd3fe57936b13)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.196-86-gd3fe57936b13/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.196-86-gd3fe57936b13/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.196-86-gd3fe57936b13
Git Commit: d3fe57936b139389a0a81ac9aa4c7962aba784b5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 32 unique boards, 11 SoC families, 13 builds out of 197

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.9.196-38-g78=
f8600d5168)
          da850-lcdk:
              lab-baylibre: new failure (last pass: v4.9.196-38-g78f8600d51=
68)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.9.196-38-g78=
f8600d5168)

    exynos_defconfig:
        gcc-8:
          exynos5250-arndale:
              lab-baylibre-seattle: new failure (last pass: v4.9.196-38-g78=
f8600d5168)
          exynos5420-arndale-octa:
              lab-baylibre-seattle: new failure (last pass: v4.9.196-38-g78=
f8600d5168)
          exynos5800-peach-pi:
              lab-baylibre-seattle: new failure (last pass: v4.9.196-38-g78=
f8600d5168)

    imx_v6_v7_defconfig:
        gcc-8:
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: new failure (last pass: v4.9.196-38-g78=
f8600d5168)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: new failure (last pass: v4.9.196-38-g78=
f8600d5168)
          imx6q-wandboard:
              lab-baylibre-seattle: new failure (last pass: v4.9.196-38-g78=
f8600d5168)
          imx7s-warp:
              lab-baylibre-seattle: new failure (last pass: v4.9.196-38-g78=
f8600d5168)
          vf610-colibri-eval-v3:
              lab-baylibre-seattle: new failure (last pass: v4.9.196-38-g78=
f8600d5168)

    mvebu_v7_defconfig:
        gcc-8:
          armada-xp-openblocks-ax3-4:
              lab-baylibre-seattle: new failure (last pass: v4.9.196-38-g78=
f8600d5168)

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle:
              lab-baylibre-seattle: new failure (last pass: v4.9.196-38-g78=
f8600d5168)
          omap3-beagle-xm:
              lab-baylibre-seattle: new failure (last pass: v4.9.196-38-g78=
f8600d5168)
          omap4-panda:
              lab-baylibre-seattle: new failure (last pass: v4.9.196-38-g78=
f8600d5168)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v4.9.196-38-g78=
f8600d5168)
          sun5i-r8-chip:
              lab-baylibre-seattle: new failure (last pass: v4.9.196-38-g78=
f8600d5168)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: new failure (last pass: v4.9.196-38-g78=
f8600d5168)
          sun7i-a20-cubieboard2:
              lab-baylibre: new failure (last pass: v4.9.196-38-g78f8600d51=
68)

    tegra_defconfig:
        gcc-8:
          tegra124-jetson-tk1:
              lab-baylibre: new failure (last pass: v4.9.196)
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.9.196-38-g78=
f8600d5168)
          tegra30-beaver:
              lab-baylibre-seattle: new failure (last pass: v4.9.196-38-g78=
f8600d5168)

Boot Failures Detected:

arm:
    sunxi_defconfig:
        gcc-8:
            sun7i-a20-cubieboard2: 1 failed lab

    davinci_all_defconfig:
        gcc-8:
            da850-lcdk: 1 failed lab

    tegra_defconfig:
        gcc-8:
            tegra124-jetson-tk1: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun4i-a10-cubieboard: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

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

---
For more info write to <info@kernelci.org>
