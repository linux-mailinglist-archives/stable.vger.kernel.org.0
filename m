Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCB6B7D0E6
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 00:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730681AbfGaWSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 18:18:54 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:33596 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731352AbfGaWSy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 18:18:54 -0400
Received: by mail-wr1-f44.google.com with SMTP id n9so71463419wru.0
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 15:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8fl6hJJ9eFETO2TgYlL3H2UQVM1tBoyyRzKzzQlhQkc=;
        b=gR1A2k4J0kMZ/JpjjHiJKWthMxz4atl9riMM2pq2nzpoeNRPePiNPvhJkIEuPAKqUG
         9sATVJtB7nBV0pagPVA0YTQT2l7o7WflqrZlrRmPjzkgOscbBUBaDdqc/5sFdxARoiw4
         m+N0YB378tmzcu4tVeWO0TsK6RvFemVPrJQDV+Mr0Lztdq7Umo71IwnM058N1s0jHUN+
         AStToHaKQEmWCux7kdCW7o2sOSmLXwrLClfcmtiLPfMY9A8fCe4CCkWQ8Yx1P5tG9IfU
         Xw3tqcoyvZyzn5WizV7hbff03qqCiHUEdvlmurubL6+4lg8DJSzLnsvsJElawTwcBfEH
         gOAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8fl6hJJ9eFETO2TgYlL3H2UQVM1tBoyyRzKzzQlhQkc=;
        b=EL5pgEdFTxYb4KtILoP5to5hajJxFmTyRe3MklT44RciJqLTt1HA0NjcLSOyoaDHVL
         5sRfq0zsf3PbIA6COEsDqR8H126RBm320zMt/BkRwVSagIQo4loRoZQBtRBJKIw9a8z5
         fs+pgw1P9N++KXC2g0g2fL6SDM5NJiKnnga5V1v5NzymGY4xKgjscbWerglZfRTRhZMz
         tIpkEp/pN7EJLrxM+JCJ17zKigGE4KsbD+E6SoiscLh15Kqa7cSjfxDbW1fUk/xlzZaP
         DrQRKPNjalWbkk9IRiQd/nSxdr4TF2RAYa0YfmCew3cdfrlqLfRk4k0vuDGw9DpaLBjJ
         Ix4g==
X-Gm-Message-State: APjAAAVnLhuZLUOJiJsqaypi9XUSq5zIEq5iZXJ5TKEzmoKsL9VyRqIo
        IzSUjXHHDOPl9cCna+l1qEZIfj882X4=
X-Google-Smtp-Source: APXvYqxbO1v6DHw7nV73+axT0wTW6tNfwxtnny8e3jeJPmFzQbh2FQl/nlidjz5sf4T1YPCxoiKwBg==
X-Received: by 2002:a5d:6389:: with SMTP id p9mr111384830wru.297.1564611532484;
        Wed, 31 Jul 2019 15:18:52 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y7sm51291890wmm.19.2019.07.31.15.18.51
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 15:18:52 -0700 (PDT)
Message-ID: <5d4213cc.1c69fb81.fea3.5126@mx.google.com>
Date:   Wed, 31 Jul 2019 15:18:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.134-310-gd37a2dd002e6
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 119 boots: 1 failed,
 77 passed with 41 offline (v4.14.134-310-gd37a2dd002e6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 119 boots: 1 failed, 77 passed with 41 offline=
 (v4.14.134-310-gd37a2dd002e6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.134-310-gd37a2dd002e6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.134-310-gd37a2dd002e6/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.134-310-gd37a2dd002e6
Git Commit: d37a2dd002e65e2975c6462a65745ee46383f49f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 65 unique boards, 26 SoC families, 16 builds out of 201

Boot Failure Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
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
            qcom-apq8064-ifc6410: 1 offline lab
            stih410-b2120: 1 offline lab
            sun4i-a10-cubieboard: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab
            tegra20-iris-512: 1 offline lab
            vf610-colibri-eval-v3: 1 offline lab

    omap2plus_defconfig:
        gcc-8
            omap3-beagle: 1 offline lab
            omap4-panda: 1 offline lab

    qcom_defconfig:
        gcc-8
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
            sun7i-a20-bananapi: 1 offline lab

---
For more info write to <info@kernelci.org>
