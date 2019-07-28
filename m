Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57C3C77F77
	for <lists+stable@lfdr.de>; Sun, 28 Jul 2019 14:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbfG1Mvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Jul 2019 08:51:48 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41527 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbfG1Mvs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Jul 2019 08:51:48 -0400
Received: by mail-wr1-f67.google.com with SMTP id c2so55707525wrm.8
        for <stable@vger.kernel.org>; Sun, 28 Jul 2019 05:51:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=B7cbmw2M/JyjOqIVCKUcPn6PcdF6/E0lOW0WCl+cShA=;
        b=dVNWgMe7L6EH7cmBwwLk88QBtFWmhvfY/4EsL6eUkEwjfbD8SYbWYnH4msYR5mCfTG
         Wt3Ih2H4KQdfbU4Ru3QXgJQgJ2w7Y6gfH4RCRk0VYJA51A97/NFrgMQ9L59+P8Qqb5xn
         pmy2cVIx/WNWsgvdpK4/+7gwu6l+YkKxQ6lk1J09A8hOINU2SDIx9Rg4zIyzueG5a+Hh
         +jhLYJeM2S+NL4kvm/u2EM6TNkY5I6LjHugtTmMmbjJF5xF5Mp+419ioOl6s3MmH5LPi
         cn7PuB2BRtqPeQk1FZcvAReQzgs6Y3jRLHLfYM+LrcwDIdYPL0TgRMOlaieak39R1tAc
         yAAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=B7cbmw2M/JyjOqIVCKUcPn6PcdF6/E0lOW0WCl+cShA=;
        b=no4joTQgl7FjnBItK/Nv79bPJE86KZ+MtattwZzZr3mARZBnAbNEV7Km2IKWiqt/jJ
         m7VLgH8C9aaZtoM+kqhENzKz9unbYOBx5at7iO19jlYGOJj7Yzsp6s+jy+HfXz1GSZww
         n7AbR+wLRq3HwDSyLH0xa9rcU14VGrgnOgbkMf/3adroi8TnCWSEToChaorwjFPVBODi
         olr6z0ySBg4B3udEEBHLSEq+cCMEBwV86uQMVBkusMs+IB7W+VOl6TCvlH4YCmwL6P0d
         P6vN3bpI1sT85BQcojG9/kn1wIJN0/jumUVukvaPRgMxJ6uDL7cjuLCsN0qDz4DEELB9
         cpSA==
X-Gm-Message-State: APjAAAWaB9HpxHdgCz5csYEvzy9zYTqlEmxUbXNjPN6fKWRULMEOGF6b
        aNLuYIkxNhONegHuwEdq7G7FNkHo
X-Google-Smtp-Source: APXvYqxLuWxr4ux8iy+Alf2weMQt87C4TkxUZrYFXW7XE3m8zhQDvBFFl88P3rAeXPZmszw6KVoqDw==
X-Received: by 2002:a5d:4212:: with SMTP id n18mr111287994wrq.261.1564318305702;
        Sun, 28 Jul 2019 05:51:45 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g8sm61323098wme.20.2019.07.28.05.51.45
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Jul 2019 05:51:45 -0700 (PDT)
Message-ID: <5d3d9a61.1c69fb81.a33dd.6c6c@mx.google.com>
Date:   Sun, 28 Jul 2019 05:51:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.1.21
X-Kernelci-Branch: linux-5.1.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.1.y boot: 99 boots: 1 failed,
 54 passed with 44 offline (v5.1.21)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.1.y boot: 99 boots: 1 failed, 54 passed with 44 offline (=
v5.1.21)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.1.y/kernel/v5.1.21/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.1.y=
/kernel/v5.1.21/

Tree: stable-rc
Branch: linux-5.1.y
Git Describe: v5.1.21
Git Commit: 4a9b1eb8bc3ba4ad8b3b1aa3317cf8d4a3aaad83
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 62 unique boards, 24 SoC families, 15 builds out of 209

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm4708-smartrg-sr400ac: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
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
            qcom-apq8064-ifc6410: 1 offline lab
            stih410-b2120: 1 offline lab
            sun4i-a10-cubieboard: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab
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
