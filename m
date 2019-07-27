Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E35D4775D7
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 04:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbfG0CJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 22:09:57 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40806 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfG0CJ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 22:09:56 -0400
Received: by mail-wr1-f65.google.com with SMTP id r1so56148099wrl.7
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 19:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=u+EbFX8sFMH8pWi0TV6CAS/I0F4j3WfAGkd0Fx8VVEw=;
        b=Mm8KMQEtFO+HQkeg3UKE8OrfafUtgu+UYohXPqUtLaMJd10nnwpcvEqf2e6aosH9o4
         Dj8xnTtkuIdCmR5t17cdBk/peLFVwLLudJ9CU1qVJi1Ik/DbCGxhjYP0L3Nj6pzaboHl
         xWiJFWEkUOtzLJPhUAPjy4quvhisiGTshUBuHdkIps15FCvJ/+JTG4aZIJoA67kDn9iz
         lO0YH4HAFEfsmsFcY5cQNXiWh+LZGHe5Nc0GJYAArQzaLhqFWQsGf2yOgNQMe5kp6aHx
         iyRLWNePc8WWPdxjyZCqE2Q7SjrRs1SelDKUPecyNQ6TFZanHr9x0oYY8ylo1ubB5uE3
         6+uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=u+EbFX8sFMH8pWi0TV6CAS/I0F4j3WfAGkd0Fx8VVEw=;
        b=T6vmKJvS+W370z5gt8lxeCnLWT/zH79INvkhS5OrdDsLDyp5p18WrPAOU6Fm2sy2ga
         JqEYThct9rEEdSwA774qFG+9/uws24FyBB8tM/H8YFBm9oYIVHFzwkpakrsYWmIb+9Jh
         cnNssvXMIxVFP1cvUUGSgrTp/IQznz2/4bJVc7kNVfI/EcXPmD/eYBONNiPvlNYXgxid
         t0oFMsiP6cPmCL4VxulvpFv4DJZUMxxCrEaM2FUBk9itQYqWeIRGRZuiMi4RLkPbTYIj
         ZyrhYNVf+MxNFWed9p+lzVxC7nGZAile6mIysiUMfeQhGyFOSHlTpt9/g8UvhK7Q8Q4M
         gQ0g==
X-Gm-Message-State: APjAAAX6cKro3EwQsDhpLkx9qxsC8XKqZ19RPWNT1R5e/KbTsxOLC4y4
        gke9q5X2J3So8qkyIA5zHFBXYQ+OjpQ=
X-Google-Smtp-Source: APXvYqxS/vQ4/1At6+exahrk/FR+sRNfwOrT13antJPuHKss5L2OGni8zOBXBt6JryokyXlRlCmFBA==
X-Received: by 2002:adf:ef08:: with SMTP id e8mr15389149wro.209.1564193394279;
        Fri, 26 Jul 2019 19:09:54 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c3sm58515345wrx.19.2019.07.26.19.09.53
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 19:09:53 -0700 (PDT)
Message-ID: <5d3bb271.1c69fb81.6eec6.8dd5@mx.google.com>
Date:   Fri, 26 Jul 2019 19:09:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.2.3-67-gd61e440a1852
X-Kernelci-Branch: linux-5.2.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.2.y boot: 129 boots: 1 failed,
 83 passed with 45 offline (v5.2.3-67-gd61e440a1852)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 129 boots: 1 failed, 83 passed with 45 offline =
(v5.2.3-67-gd61e440a1852)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.3-67-gd61e440a1852/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.3-67-gd61e440a1852/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.3-67-gd61e440a1852
Git Commit: d61e440a1852a64d8a2d0d358b9582b19157e039
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 28 SoC families, 17 builds out of 209

Boot Failure Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap4-panda: 1 failed lab

Offline Platforms:

riscv:

    defconfig:
        gcc-8
            sifive_fu540: 1 offline lab

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
