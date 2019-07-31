Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E84327D07E
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 00:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729949AbfGaWLd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 18:11:33 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:37417 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729680AbfGaWLc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 18:11:32 -0400
Received: by mail-wm1-f52.google.com with SMTP id f17so61227328wme.2
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 15:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pC56YGbeYf3m5HiSsuUFBRFbJBYncd52nkgIo2N2iXQ=;
        b=gER+NlLpaFI1s1k4Uq8kEoYUNMvRbaoHoD4dYWw26aTtpegKNxZBkyavP8AJVNfSOe
         kndbivh99iwIH21ubqg8AMDElJM/2hbeQgOVLTOtV8DUx/5QRhIwz8AYE+ioeUgFeLqG
         fxLq6rXiyYNnJ2hBwmkzgOc2j3NJs5hT2tq/Lnnn/ikX7E2cnmjDhDfe8LGpgw3YiePD
         S+wFJU563qyQxx7TpBWM4Qi+AfDEu7piAIhcBQdr0eV/KKUvPNzsTSZYFoiZrvIGqu4K
         SQ4NwjYJRoRLPuhN+4eZOCDo7O0vjrBICvYQaFnsBM5rdNQeiZW+Zq7AtQdRE94ffezn
         1VzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pC56YGbeYf3m5HiSsuUFBRFbJBYncd52nkgIo2N2iXQ=;
        b=qBiiEnwy+/G57oN1yjVXADif/YFTl7ZmnYPoMUsLe9c82dGN1Im+iVWxngLRvbXAy2
         ZgZaf4NpY/cIibIF4W0cG7ZGj+IoN6Nh/KMuoiy/GK4attvswQYch4uW4Rt8Z8SR6fkO
         V45pgC++qKSWDpY3iNH2DDh02MvBgiw7Mharn8mUPXgcR1KtiFjkOelLr9wuonhKqLY3
         Ngyk8kZjUu1/tce984X1QFmf/nyqYIWSnQKUjyCekRH2SCzRZmpWIZEzheUCRtwAKHE5
         p+8CROPuWNx67enx6KxteqEWH5YPf6ZgvW8wypgwNMRLNmIroREvgQPKnz2R9r3ZF7WK
         w7ZQ==
X-Gm-Message-State: APjAAAXLFZGZSlrtQBt8EmBqAL3hte6feYrgbFdASxPar4FNGQ5URFyc
        z2vhkZHEyDj+Ed0MI4v5W1ZlLousHF0=
X-Google-Smtp-Source: APXvYqwgPh7azAFteDu+Ys/07zyxBd/22OaQHFtwnWLE6SDkV3oOiGjMmQtazJAUCD0ocw5z+bgdNQ==
X-Received: by 2002:a1c:b146:: with SMTP id a67mr109869934wmf.124.1564611090535;
        Wed, 31 Jul 2019 15:11:30 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j17sm115792370wrb.35.2019.07.31.15.11.29
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 15:11:29 -0700 (PDT)
Message-ID: <5d421211.1c69fb81.35920.0ab5@mx.google.com>
Date:   Wed, 31 Jul 2019 15:11:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.62-131-ga4090d312ea0
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 118 boots: 1 failed,
 74 passed with 40 offline, 3 untried/unknown (v4.19.62-131-ga4090d312ea0)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 118 boots: 1 failed, 74 passed with 40 offline=
, 3 untried/unknown (v4.19.62-131-ga4090d312ea0)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.62-131-ga4090d312ea0/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.62-131-ga4090d312ea0/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.62-131-ga4090d312ea0
Git Commit: a4090d312ea03a428da2996a6374b1a3a604ff93
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 67 unique boards, 27 SoC families, 17 builds out of 206

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
