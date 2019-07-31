Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE3E7D039
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 23:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727600AbfGaVnp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 17:43:45 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:44941 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727360AbfGaVnp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 17:43:45 -0400
Received: by mail-wr1-f44.google.com with SMTP id p17so71262265wrf.11
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 14:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vklFMinGCCJ3bPt6RO8G80SBIJyWLyA+Mu+duA6eTTo=;
        b=p+kJSv1PV5hzkxVu/vlGPQ/VEV0LkRgV50vpfrpwkOQfNMESfkNuu0mUjxzQ+G7XYg
         3/ucVYu+/NfK0Ts8wnpRqpf4tzKWoShIYPd3BKKB5LLWgt464gyu2rOAyTbCdATrlq2X
         zp5iWjkO2HPa/7Kad4xdgZg60Q799DV+x8sd+uGX/A7KIPjw7dY9/iy907BYWQu9v3W6
         bwcsJOdrecfqyC06LkNAyeBlwribfm9H26hwDnktv+pKhUJz2g2U5v3vNR1ul0sjxPsH
         P2fo/Rgf4XmpyznOKVB4oE0dNuLhe80EbWttvBOx75/cBuyDVfpUrFjCUfehYHGZaa5U
         5k7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vklFMinGCCJ3bPt6RO8G80SBIJyWLyA+Mu+duA6eTTo=;
        b=McEueNvmkDTQMPuh5MG/Q4BCaulsJFO312rcCQXdzDnNtn4vg7R7G/hDLkEicAU0xp
         Z9RRn0qiaXk952KNcxAQ2Jwr8MdlfB97H0BGDi5JCFVqBn8+muNNQb3tNzwe24V7S6Pt
         sTRzcViXz8TE0Ze9Va31ryGEZiyBQ0WseNsvMLKBSm1dET0ywrIHLqj82sCINY0qIOhi
         UttW+lhoNpCQWggTvH+MXp3iNBhOYfixfb1qlbHjzzeybkxu1an+8NXT/ROrDGGGxwqy
         kF8TDAiysSnNpH2gKmOYTxr0ikrZaYanduLK8kDh4An+Uzd4BKAwaFFO2nx05YRtS31E
         3vJw==
X-Gm-Message-State: APjAAAWjUHjyaodeoVqnio9arZCEJOqkRAhlAL+umvqrwyZgRP8lWVkk
        veIxQGkJJiaZ7yRJInljjztowvev+GY=
X-Google-Smtp-Source: APXvYqzZdIMxNWNmg5wMuqj3AZ7vZ8F7aGfDua8X2ODceZofZyU/Xa8th3gn+FZXk67+nM6TIHI/uQ==
X-Received: by 2002:a5d:5448:: with SMTP id w8mr135508323wrv.180.1564609422270;
        Wed, 31 Jul 2019 14:43:42 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id j189sm81372495wmb.48.2019.07.31.14.43.40
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 14:43:40 -0700 (PDT)
Message-ID: <5d420b8c.1c69fb81.8eca7.7363@mx.google.com>
Date:   Wed, 31 Jul 2019 14:43:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.186-220-g49d1c2e96b78
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 99 boots: 0 failed,
 64 passed with 35 offline (v4.9.186-220-g49d1c2e96b78)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 99 boots: 0 failed, 64 passed with 35 offline (=
v4.9.186-220-g49d1c2e96b78)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.186-220-g49d1c2e96b78/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.186-220-g49d1c2e96b78/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.186-220-g49d1c2e96b78
Git Commit: 49d1c2e96b7891914c40702a379f1c4b936aae62
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 50 unique boards, 23 SoC families, 15 builds out of 197

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxbb-odroidc2: 1 offline lab

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
