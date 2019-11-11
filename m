Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB48F7476
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 14:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbfKKNEO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 08:04:14 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50980 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbfKKNEO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 08:04:14 -0500
Received: by mail-wm1-f67.google.com with SMTP id l17so12442302wmh.0
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 05:04:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ctk7OE4QGtU9YE8qWey4CgJhEUODOOF27E4QKPNDgvU=;
        b=G+zKr2sAnuOmTxHHdFMNcB7qubPqMsvTPdaPtifq+uZHrSseSFaqLz8P0o3P+V5g0P
         UfF9jXosYhajPFeYQxzPsmnOoeINLKvytcpsFVcjVSXCItza8THRPTnBVOibSYA1OiZs
         +IjgAY3IAZEDcSiK8ryGHiBNFgMWw1ONhx5Dvd4GwlH2+/o54BhCejgh3J3DmuFyqu10
         ELp3F+FEreQPN1dT8GWNY4U+VXlq1b+1yxMV/cApCcZ4p543AQuBcm/vFUgnGONW1Mpy
         cNgFTNzcy+MxFLF2h9ryy0R4celkjiOhAT9z5d75vwTtCbwAplirqi4k2sRtnLXQyXSG
         bvyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ctk7OE4QGtU9YE8qWey4CgJhEUODOOF27E4QKPNDgvU=;
        b=DLbHI1CsPA55oIA6nVUP2EHUOyMTug+qcsEpkb52X936e/DYVG28bsWc7GW20+tGAe
         irhUKymVllAWAgssKUIO0mX8pMe1CKAGt1miciEFFgh37fJjkazyvbXlvaS5RtGm1RWu
         wxei8wNFq9DEpq83XQ75oRz5RoYfPCrWKzgj3rvvWb6z781yLMo86ORiztoIhbp9fp5a
         PZh3GDAcpt/OykvAxOes5b0Twx1CpIEKFaT4NxQND3EgM3G0yToYkckVyJvUIn+on/p0
         olXnimhbV56fvCDX5s4X6yjJzddGOc5e4K/IXslLdbYk42lsDNdz7eaxZTKIQbqs/YiS
         WZZw==
X-Gm-Message-State: APjAAAXUkUyLXI9FGiCo+/CNZ9wx8vMioRVwu9Ew71dPDxoLz75dIS8z
        OPRTQf8qel5LSPq1U5zKjiBUsKsZzZQUkQ==
X-Google-Smtp-Source: APXvYqwcdC+oKSrQ5u2JcPoGkBCswJoP4CEWFKINLVeOli7QriTtPwL8CJIv0oO4H/5zoFMzZ0nHZw==
X-Received: by 2002:a1c:6144:: with SMTP id v65mr20983372wmb.53.1573477450713;
        Mon, 11 Nov 2019 05:04:10 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id v8sm22244682wra.79.2019.11.11.05.04.09
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 05:04:10 -0800 (PST)
Message-ID: <5dc95c4a.1c69fb81.6f4ac.cb7c@mx.google.com>
Date:   Mon, 11 Nov 2019 05:04:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.4.200-23-g4cb9b88c651a
Subject: stable-rc/linux-4.4.y boot: 80 boots: 6 failed,
 64 passed with 7 offline, 3 conflicts (v4.4.200-23-g4cb9b88c651a)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 80 boots: 6 failed, 64 passed with 7 offline, 3=
 conflicts (v4.4.200-23-g4cb9b88c651a)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.200-23-g4cb9b88c651a/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.200-23-g4cb9b88c651a/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.200-23-g4cb9b88c651a
Git Commit: 4cb9b88c651a2fff886dd64b6d797343e7ddb4dd
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 41 unique boards, 17 SoC families, 13 builds out of 190

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            exynos4412-odroidx2: 1 failed lab
            exynos5422-odroidxu3: 1 failed lab
            rk3288-rock2-square: 1 failed lab
            rk3288-veyron-jaq: 1 failed lab
            tegra124-jetson-tk1: 1 failed lab
            tegra124-nyan-big: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            sun5i-r8-chip: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            dm365evm,legacy: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

arm:
    multi_v7_defconfig:
        exynos5800-peach-pi:
            lab-collabora: FAIL (gcc-8)
            lab-baylibre-seattle: PASS (gcc-8)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
