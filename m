Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1094D79F82
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 05:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfG3D2e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 23:28:34 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:39008 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbfG3D2d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 23:28:33 -0400
Received: by mail-wm1-f44.google.com with SMTP id u25so44878366wmc.4
        for <stable@vger.kernel.org>; Mon, 29 Jul 2019 20:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3H8HzMsuloNzCatYKYD2aCuZ4wdUjxBb7w2vguXBYNI=;
        b=qkNvZ6Sf+8169T4sqSOLYw7vIxwRl70r1R92NpZLICWPHgv6W110kV/s1YnvNnajmM
         EMKgvN+JFRnFWhZnREtwLc2ASYggUCHZCTQSdPqHU36DdpUGsXkbqvx0410SHEKIizwA
         hlCFh2pOxPOg7pgR53iPjbuWLKxONToIiJCAq+5mfMVVSW9QZ9NPIAivKwAeW99mRloM
         GVW/bF+BNc4dWeYVjoWu1n9oTY2BtzZaLD/M0PAek9t45LM4vt9Ld34oY4C6c3oxtLKp
         wipLJVvJCgDM6lhUb0w7oSrQ9RA8sdcxBBf1HiBX7e+lFeithgaiXkhmHY+e+4baDZgH
         n95w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3H8HzMsuloNzCatYKYD2aCuZ4wdUjxBb7w2vguXBYNI=;
        b=cx2lkmHsbT2V7nSnF45y46VlWwnb3J1BfnOow04YHOVqSnR9WGRKn76USH0u2i6fla
         AFEl/6fKcuiI7T9DXW7T+Nc9wqWFNNhrbz8WynFq/gbdtK3YknTjp/J64eHz/KNHJvfH
         cS7XCCh9mkpp2wja70wTwzBe4QSDHz3X49alSdL1+fIWSHECD3JWKGO49PGXDpblG+g/
         GvOgQTpDFfWR8ATQdp7shfOW0HeUD6ii/C4DSfMlZAbxmp3yRDuwNGAkZ46KLUhlmVfT
         vx+/35B2TDJ4yxBtori+anQ8lwuYU3vjs3rmmJg2U4IhALWqo6tS7oWiBlGWIP+ZJNwr
         X8eQ==
X-Gm-Message-State: APjAAAWAqtTTd9PwKeiXtw6Xt1RNyteo6MDfChvDzzNzeKsEX/v5Amam
        LwkvMBqxBb5kRaX3z+dZjxRSnJWgDPM=
X-Google-Smtp-Source: APXvYqwOD83mDGeSb0sHxODb/pWXWtT+924+iRLt8NX+2mPyQkL0kflAMucrhQFEjo7d1o64DcVZeQ==
X-Received: by 2002:a1c:a997:: with SMTP id s145mr99587612wme.106.1564457311377;
        Mon, 29 Jul 2019 20:28:31 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id y24sm46789389wmi.10.2019.07.29.20.28.30
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 20:28:30 -0700 (PDT)
Message-ID: <5d3fb95e.1c69fb81.883a.e12e@mx.google.com>
Date:   Mon, 29 Jul 2019 20:28:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.134-294-gf6ba73a2e356
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 106 boots: 1 failed,
 64 passed with 41 offline (v4.14.134-294-gf6ba73a2e356)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 106 boots: 1 failed, 64 passed with 41 offline=
 (v4.14.134-294-gf6ba73a2e356)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.134-294-gf6ba73a2e356/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.134-294-gf6ba73a2e356/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.134-294-gf6ba73a2e356
Git Commit: f6ba73a2e356d3f40ed298dbf4097561f2cd9973
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 58 unique boards, 25 SoC families, 16 builds out of 201

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
