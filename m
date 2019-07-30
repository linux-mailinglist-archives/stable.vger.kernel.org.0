Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 559EE7A012
	for <lists+stable@lfdr.de>; Tue, 30 Jul 2019 06:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbfG3EhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Jul 2019 00:37:20 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:45830 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728454AbfG3EhU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Jul 2019 00:37:20 -0400
Received: by mail-wr1-f44.google.com with SMTP id f9so64116167wre.12
        for <stable@vger.kernel.org>; Mon, 29 Jul 2019 21:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IKvcXX/eT/DR+rMRg3lv79piuFEXlK9Mo4sTjRSAWw4=;
        b=zfGs41/3D3Qy9cN4AVuYL2Qj/0LubySOYDPX9CmOHbJ7GkdIuj4+QaN2KXPb2ItJdZ
         sRISEMFIa88iM4cM1hqTxVzVgjfCPqKvo7Ywag9RyrsJaPzF2f5wuuobJILPiOnzTYiZ
         8NoU16OMhmk37Nl2YJrIZo/MhjXffILyObgeJZdGbfaQgewVLRKpJ7q5GhDDRd2LgS6v
         R7hGx21IfeiX7tlOdCZSANGkjxJBVmiRwenOfmOMCQIi+8fccOKy8WnANaSqDYPdxisW
         tXL9T+x35uxJ6i60xJJI5MXucsOMMm9OQJj2jglBQZt5rgGiJaslzNtxwsCnWZKA7RT7
         XfoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IKvcXX/eT/DR+rMRg3lv79piuFEXlK9Mo4sTjRSAWw4=;
        b=bKsDN3+3T/BqomucpwUKofvc8KmUhtlhjc0438BvI7BLryd2hG9GShEc4ZQ2QttYzu
         7yE8A3P1kqbnUskuTa82ZnVXPTrzv+kJswXxUdOGh/ey8ZXzTU6sOcuNv9vn/ShQ3DOt
         /39R4KW3OtruAGKdPKzUVuPPNsVeEO2rCkVHeBuChi3IVh1fpicBDVOXTJUsElTnJYDg
         J9lQCawMrg/ojzoDKzBxHMZJBpJIgbIz2N03WLVhAQ3c1QROQ8nxZ/SjqNyKo1xGqKFl
         R4S27NEWJF03VoW6x4dxjf5ZokCq8oH85Ed7lQt+PDjejE35/CHYZSx2Fc/unfp0YX3N
         yUbg==
X-Gm-Message-State: APjAAAUNSBMktIQ9i5FMFllT8RsDVp0gldSNdDnsROJysEiZA8mTC6fZ
        4dLXN9VbB9JYBb1vlOMc47YJJ7Ns6P0=
X-Google-Smtp-Source: APXvYqy7Tf6DRDDasRU1PGRHyMqA4tw+ulQ1TMQJYPnQpUJX1JD/NxVV/RehqhklvGEK35qOOKOalA==
X-Received: by 2002:a5d:528d:: with SMTP id c13mr41087699wrv.247.1564461438313;
        Mon, 29 Jul 2019 21:37:18 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p63sm14836941wmp.45.2019.07.29.21.37.17
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 21:37:17 -0700 (PDT)
Message-ID: <5d3fc97d.1c69fb81.1ee75.0ae2@mx.google.com>
Date:   Mon, 29 Jul 2019 21:37:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.186-211-ge7a6807764e7
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 87 boots: 0 failed,
 52 passed with 35 offline (v4.9.186-211-ge7a6807764e7)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 87 boots: 0 failed, 52 passed with 35 offline (=
v4.9.186-211-ge7a6807764e7)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.186-211-ge7a6807764e7/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.186-211-ge7a6807764e7/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.186-211-ge7a6807764e7
Git Commit: e7a6807764e7f39a1865570cc4f4f81b356c32cd
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 43 unique boards, 21 SoC families, 15 builds out of 197

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
