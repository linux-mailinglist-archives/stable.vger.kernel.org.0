Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 948157DB3D
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 14:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbfHAMUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 08:20:33 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:53178 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728791AbfHAMUd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 08:20:33 -0400
Received: by mail-wm1-f53.google.com with SMTP id s3so64408295wms.2
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 05:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=30IntTd8FD8xLtdTEx6uvBNbduD5Rf3CyIscCOmjY2s=;
        b=tjqzxT5SXRVXMd5AI9DmIia6n3fdG07Jq66pFvwcs4uNX8Gp8HOplKGUK3PyphueUC
         yNF8+TN8tghcAjI3WgAI0jc9BxW0p4kVsVVc/ylC5xGGAci65xHFRJ50e5X8LqSotNGq
         OlDCf2VX4+Qio+s+7e+iB/lSjPDg+EaIp251eJUpGSyVjlKd+OsPPiVMXNWY7LVYfQdm
         XUvcKJa8O2CzwmRX3y8/da68UVzJa3U29g3hsBqdmuBuPD/uZe5BX6SFp6wZha6+yuOv
         D4KmWXe8p37xlfdISImZGgC9ET6ImbBwfTki/UrGQx7nU0P/gOUqE3PEpn7Og+BPK9W3
         N7Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=30IntTd8FD8xLtdTEx6uvBNbduD5Rf3CyIscCOmjY2s=;
        b=B5EI1RcNUXh/XT6iztQqJL2vD7MqXl4+tbXlVvUVrKTUITwyg9WVM1zbARrX4zN/2V
         JVyElhPlfT7vUynlxvtgTTwl5u/cIGyGnWlRBuwAqrW5pz9E30MCE7zoLr+LwVLdmJ8E
         7FBokg9dawYhxQ3v2VOQ38YBfWWguvMIbH+SofgOLaNrl3kB+YCnZ3V2xtFUrwI2EpbL
         UGzWXYoC+KZBoYxzm09zlw8q4RmlbFyThdrGIdTB/36o2ccj3brnsL2nCIHnlwkKRkrw
         3wAXSGT1kYW7RGsL25ETb7DaJEzmLgnHIwihY7XcVYuI6ERZ6y6CuEA1i7d8jtkIh2Rn
         JzXQ==
X-Gm-Message-State: APjAAAXbA20YMTK/kybpTWLj60t7UspQ3ujxpXSw+HT4Vy/juQeYAXs3
        vRwHxyCwexzcyjT8CbPRuJxlmwnhw9E=
X-Google-Smtp-Source: APXvYqyFGM73TT5CS/Wl4V/sdn8YihLb/WkSJFngI1HY357MQslp1qSSyHwSo/J18Liq4wER+yHbvA==
X-Received: by 2002:a1c:f90f:: with SMTP id x15mr38503709wmh.69.1564662031254;
        Thu, 01 Aug 2019 05:20:31 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g19sm84088497wmg.10.2019.08.01.05.20.30
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 05:20:30 -0700 (PDT)
Message-ID: <5d42d90e.1c69fb81.f8288.2c9a@mx.google.com>
Date:   Thu, 01 Aug 2019 05:20:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.62-133-g2d6175fac9d8
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 120 boots: 0 failed,
 66 passed with 40 offline, 14 untried/unknown (v4.19.62-133-g2d6175fac9d8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 120 boots: 0 failed, 66 passed with 40 offline=
, 14 untried/unknown (v4.19.62-133-g2d6175fac9d8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.62-133-g2d6175fac9d8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.62-133-g2d6175fac9d8/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.62-133-g2d6175fac9d8
Git Commit: 2d6175fac9d88d63c3985b0bcb1f53b7001c5a4b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 26 SoC families, 17 builds out of 206

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab
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
