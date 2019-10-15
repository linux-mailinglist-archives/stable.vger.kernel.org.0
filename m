Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F331D7782
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 15:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbfJONf4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Oct 2019 09:35:56 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54141 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728880AbfJONf4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Oct 2019 09:35:56 -0400
Received: by mail-wm1-f65.google.com with SMTP id i16so20909131wmd.3
        for <stable@vger.kernel.org>; Tue, 15 Oct 2019 06:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rMPNNJTRmOcFQb8w1clCMdsorkWwqgw5ONPCEIkCNF0=;
        b=ZX03KkbrloocaYvXLjMAorw/3SXX/Dr6PYHqjtIDdPhgAeV5GhJXd654oIPH1w6rjX
         BT7tN55pG0S+zkzNHR+s8zLxUEz7T83PtSzCSvQYd3s9bISmDw3KaB9DkxctxfQdf3X2
         RJ6ZXbqbhy9LZKXVGQV/SBprkmKJ2kKMWbrE+0tQ/ylhC3VQNjEnXcBOduxldR2TMGgz
         Sluu4u0LwpJHU5+S8HfpOuKzFoMctRAgA5oX0VkBvIB/O/O/pJwcO/HjdNFgEcOKCryU
         KTEMWk2sTUobKKMZNbZB/RVFAAHUe+YBicjtXZZ+lEX6pp7oV1ClrmjjcE6ak1EAG9Gj
         aPyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rMPNNJTRmOcFQb8w1clCMdsorkWwqgw5ONPCEIkCNF0=;
        b=YTipfgVVC2gK1iA1OoVkod21QBi8MpS+OJAITCywlCcso201Sr/ckfbvSBqXMBGBRi
         ezel79tXuUc6VV4/9EueCfEwv7M32ti0T9NNJ3ZKMN57j2EUo79Xy9UBBzVjDiulFl27
         j+3GLAgbrcNBJnBISeb6/d3tWTZlKJ/1r01EyFr8XVhLYjrzvP+0SqjwiQtnWF0ik+1I
         vKZ1sUoUrF/FHbW6qhtELf0S+RBGh9YkbyBkvBtSr/V1ubjoqlYfDesYtKLWUoMOAYSX
         uxI0IHnZ353qRYOhGi90t0BJRbOw3DNEB0fpUlx3mgD/duPR6EaKZ5BrDXGxFS0siA7R
         s3HA==
X-Gm-Message-State: APjAAAX6FbqKnna4HfPpMMakq8hXNuu9oyLnTE0UEYeglzeTe+YQcmEl
        oJLfhninzBPbmo7SATeSTS0NF4pikRbYYg==
X-Google-Smtp-Source: APXvYqxqzsc7CRbFPqdgTAmZ0KEHZxMBRMdsb/HwhvgIwZk+RdDMpRMNpYs3ICeVanLmfXaOHhkXkw==
X-Received: by 2002:a1c:ed04:: with SMTP id l4mr20368692wmh.116.1571146553114;
        Tue, 15 Oct 2019 06:35:53 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id h63sm37681270wmf.15.2019.10.15.06.35.52
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Oct 2019 06:35:52 -0700 (PDT)
Message-ID: <5da5cb38.1c69fb81.31478.314d@mx.google.com>
Date:   Tue, 15 Oct 2019 06:35:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.149-55-g36877e44b1b1
Subject: stable-rc/linux-4.14.y boot: 100 boots: 5 failed,
 42 passed with 48 offline, 3 untried/unknown,
 2 conflicts (v4.14.149-55-g36877e44b1b1)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 100 boots: 5 failed, 42 passed with 48 offline=
, 3 untried/unknown, 2 conflicts (v4.14.149-55-g36877e44b1b1)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.149-55-g36877e44b1b1/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.149-55-g36877e44b1b1/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.149-55-g36877e44b1b1
Git Commit: 36877e44b1b1240facb137f2fc612a085fb06f00
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 62 unique boards, 21 SoC families, 13 builds out of 201

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.14.149)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.14.149)

    exynos_defconfig:
        gcc-8:
          exynos5250-arndale:
              lab-baylibre-seattle: new failure (last pass: v4.14.149)
          exynos5420-arndale-octa:
              lab-baylibre-seattle: new failure (last pass: v4.14.149)
          exynos5800-peach-pi:
              lab-baylibre-seattle: new failure (last pass: v4.14.149)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v4.14.149)
          sun5i-r8-chip:
              lab-baylibre-seattle: new failure (last pass: v4.14.149)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: new failure (last pass: v4.14.149)

    tegra_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.14.149)
          tegra30-beaver:
              lab-baylibre-seattle: new failure (last pass: v4.14.149)

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

    multi_v7_defconfig:
        gcc-8:
            sun7i-a20-cubieboard2: 1 failed lab

    davinci_all_defconfig:
        gcc-8:
            da850-lcdk: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            meson-gxl-s905x-libretech-cc: 1 offline lab
            meson-gxl-s905x-nexbox-a95x: 1 offline lab
            meson-gxm-nexbox-a1: 1 offline lab

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
