Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4EB4823D9
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 19:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfHERSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 13:18:11 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:34895 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbfHERSL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 13:18:11 -0400
Received: by mail-wm1-f67.google.com with SMTP id l2so73729921wmg.0
        for <stable@vger.kernel.org>; Mon, 05 Aug 2019 10:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=voIGteRKzC/qSuQGdpeb7TWmnO42XbJGR9gOLDIKzNg=;
        b=LHGYSI8t6Ak6gpvFLlbWHsPOIN31PnTNuJpL5G6YrNTDiBoSgtlImHIhm8VdABaC5E
         LkB9WaYxSzGgEclqFpHshcb/CKADjV0OB5DgWQBihsvcU0EhnzUVs+WBLfVKyasXCgdH
         1+sUqxkxFwLCrB3I9IKraYM8K/o1A8xiaK3806SSrzzEUAX4rg+qY7sDniIDbBh4/sR9
         2SigIlyjeMlNQOW+nGzlO/nvxv3E73EKuCrGfAS9OZkunlMgk7yDl948Wfn/2tpFspFO
         8wQW6SIIhx5c+sW0YEIfyuqCv+aOifZc1saEAq1PyIJZPKkO3dTkGqq8JvcriaYxgGBS
         QXXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=voIGteRKzC/qSuQGdpeb7TWmnO42XbJGR9gOLDIKzNg=;
        b=XeDkVSo2WBmFUvC6szz/X+iDWCFR8INJNqNoeMoMieUQpMn/TScv6vXjHs789ApQc1
         UYul8IkbdEC6s0ZItcibisIqmOtl5xjlyx3a/O59onTAqnNRKmZBwcXw745B658hfMpM
         +P/c2a8QhJD8CMjFEDsx2cthq+DaknDEj6ansKVU0A9kTBx6r05a675FTYys/3ULny+F
         s+JIiGZhm7ouKZ8w1XZgOreZp2mmgL9u8bMqRTKVibs2e+4DgLGX02BsqUX6hgz0xDST
         aN8av36eR9LtYrntRMjqWwaJpzTRH/ZNouE34197ExNPwvyQqAcuBKOMN0NoKp0e+wNq
         BjjQ==
X-Gm-Message-State: APjAAAWuZRs+zHGgQ/Nkv3nS+rjSkpgN3bAHBQ2ZHRt6JdknTACRaomp
        /knqTyzX1IDCGZvNQLaJDLBk/CEVSO4=
X-Google-Smtp-Source: APXvYqz3RuKTtvQ7eBHAaHW44a233Hg06vU7NVYGpOiQId2pcMwEppKSv8nJKsWiYqJMJVdszL6ssw==
X-Received: by 2002:a1c:988a:: with SMTP id a132mr19140680wme.165.1565025489117;
        Mon, 05 Aug 2019 10:18:09 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v204sm102527483wma.20.2019.08.05.10.18.07
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 10:18:08 -0700 (PDT)
Message-ID: <5d4864d0.1c69fb81.d637e.44dc@mx.google.com>
Date:   Mon, 05 Aug 2019 10:18:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.187-23-gb9a28e18ca89
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 93 boots: 1 failed,
 54 passed with 38 offline (v4.4.187-23-gb9a28e18ca89)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 93 boots: 1 failed, 54 passed with 38 offline (=
v4.4.187-23-gb9a28e18ca89)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.187-23-gb9a28e18ca89/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.187-23-gb9a28e18ca89/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.187-23-gb9a28e18ca89
Git Commit: b9a28e18ca89602f69c795d8e0438f59d92cbf7b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 20 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
6-157-gd9815060e3ec - first fail: v4.4.187)
          sun5i-r8-chip:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
6-157-gd9815060e3ec - first fail: v4.4.187)
          sun7i-a20-bananapi:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.4.18=
6-157-gd9815060e3ec - first fail: v4.4.187)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

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
            bcm4708-smartrg-sr400ac: 1 offline lab
            bcm72521-bcm97252sffe: 1 offline lab
            bcm7445-bcm97445c: 1 offline lab
            exynos5250-arndale: 1 offline lab
            exynos5420-arndale-octa: 1 offline lab
            exynos5800-peach-pi: 1 offline lab
            imx6dl-wandboard_dual: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab
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
            vf610-colibri-eval-v3: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun4i-a10-cubieboard: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
