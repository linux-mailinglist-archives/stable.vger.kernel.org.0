Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDC0C79EA3
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 04:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729270AbfG3CYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 22:24:41 -0400
Received: from mail-wr1-f49.google.com ([209.85.221.49]:39538 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728962AbfG3CYl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jul 2019 22:24:41 -0400
Received: by mail-wr1-f49.google.com with SMTP id x4so10769391wrt.6
        for <stable@vger.kernel.org>; Mon, 29 Jul 2019 19:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KXaoPbrQR8cOY5xonhHKs7ogV9g+KKiBGCtdfBnXIps=;
        b=SkFmTFB2rhJ5NWnsC5igBM7kIjO0ngg1wJFLBawSLi/D7iZFnTdmbJg5nJFf2YCQpR
         PYe4Jz0I5uEOnQ1slZY0v/QZPima1nX8Sp4O7PGRUv/3YbV2mFRk6RkU8CDyCV7GkByq
         GPJkCJl3EwMt86zzopJyfXBXcqxaoQoACPncRbdyFmmVALtQxEscl/3QvcDNDZSJU8/4
         i2Bor1UjAGZrM2NOQkChjFwPcjRs4EoDjRKDyoTiSjq3HRn5w1Q14y6i9E70z4Bisl53
         C1RqN4F3GlLTXN55iv8DK+KMh8rCTLSYH21yk3Em9sADlC3ORn+sTIs9fRzzq163K3QP
         o+aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KXaoPbrQR8cOY5xonhHKs7ogV9g+KKiBGCtdfBnXIps=;
        b=UZhUtkamgQHZF5Yis59RPjuAUGzDYQQ+6Fszi710+FIyZiCyuLvABelhyepkCfENnH
         20rkOXRRhf2mWrNkQKEwoWeOSPZyDjKwx74Z+7uB2rsI5n2RmLrlIOpXiWPJoxz1JiYW
         qGb3gocA9cplBiG4ukPh1lYsuKtFKGkqQLh65qMTXt2tK66f/YLpTKgUWw5cYynA9YOz
         GPsVPuxh2rF5OsUuhHa+DTOADMF6yV2mmFcSg/bI+PHX2jPQFgBiHyNW127nyT6tFgnZ
         b+FsTfjQvmItXSXrUt+X4Gb22K7SLoeCxx+4iBegtlxAowosdzhI5MKsLK04UawgqPKV
         9cFA==
X-Gm-Message-State: APjAAAUqE2uMPlwXpShTvyjNJ7lNkdYwACZbVH2SJEIQeVUWGiv8dmlx
        L3vEXiQE2Scm+xXGuYENASGv1WHWW+Q=
X-Google-Smtp-Source: APXvYqyKJXM9q5L2USmHuoa+n70gtJ3ifVz22FQrphogBwo4K3TETPWRKPVrFInHbuDRyRGa3kWpJg==
X-Received: by 2002:a5d:518f:: with SMTP id k15mr64682073wrv.321.1564453479178;
        Mon, 29 Jul 2019 19:24:39 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n5sm48769779wmi.21.2019.07.29.19.24.38
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 19:24:38 -0700 (PDT)
Message-ID: <5d3faa66.1c69fb81.af756.a088@mx.google.com>
Date:   Mon, 29 Jul 2019 19:24:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.62-114-g0c75526c53c7
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 111 boots: 1 failed,
 70 passed with 40 offline (v4.19.62-114-g0c75526c53c7)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 111 boots: 1 failed, 70 passed with 40 offline=
 (v4.19.62-114-g0c75526c53c7)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.62-114-g0c75526c53c7/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.62-114-g0c75526c53c7/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.62-114-g0c75526c53c7
Git Commit: 0c75526c53c7c911b415119a86ace13c9d3e1724
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 64 unique boards, 26 SoC families, 17 builds out of 206

Boot Failure Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

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
