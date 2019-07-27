Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B350C775C1
	for <lists+stable@lfdr.de>; Sat, 27 Jul 2019 03:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfG0Byq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 21:54:46 -0400
Received: from mail-wr1-f45.google.com ([209.85.221.45]:39499 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfG0Byq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 21:54:46 -0400
Received: by mail-wr1-f45.google.com with SMTP id x4so2979313wrt.6
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 18:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ywTssN1OaLJLOAgn1zE68C9sTfGOc1ktG4PsTxTsZPs=;
        b=N2inLDKcRIk7yzNGtTvPAfBmh1FlTWv/QSMmb9hRFrlim+AcKqSUAgmo+NCnTrRGGQ
         ilv7p4HL7U5nY/Zld92W0AyVqYT5cJ77J2ryFdTdxtjzhUiyy/r51FciKq9V4BzMX4td
         BAZf+XfQ2FxYu884xMYUKIv5EawxDisR/VyfoyRv6dkQD1W9c8tgiQzwS1gcEUU4V4fG
         ivlTMPVhda+XBA5Y9MUtxQ+OI7Sl6tMbOaqhjPbVDwhsi6xIu5lDKulMw39QIOUvzrz2
         HGogEZCxq6zJIPFverAg/KEgfvkcA248XNqwmOF+Qc21bz2CrBWMxV3LG4DIwFYJ0fJ/
         dksQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ywTssN1OaLJLOAgn1zE68C9sTfGOc1ktG4PsTxTsZPs=;
        b=pKhUxjDhhY0Gkfo4cbacmSIpI44pFoiPQ/UBUKYrGfmfSYcKPGhVas5SlSDG2788ks
         i8/A80NHVUjFse+7D71MCLdqfUa73l/vPf329c7wdfs77MhvtbLPww2FglIBQqRGLZQ3
         iewJqeurApLxxHOJuPf7eHxCnbGdZaavCPek3iECHQJg1w//XgGTA9wQArnNg9DlVD7A
         3cIQsrhFLwYfy3xREidIMr3RJQgOTjbiyJr9PStSvYvdau8hr7Qqb+6RB8P3EpQ6WP7w
         d2aEFI/aV0CCGTZGd42nrCHbEuVGd+3ejJPpcqqN15ya/gtg3wrZC8WoIJklVhjzr6wD
         MdWg==
X-Gm-Message-State: APjAAAX1qhq6dRzRMlAZrgN8bKbXPmaJrkUEu92k8I9qp4tv0vPIiYL8
        KPnmohtGFci4RrAmH1E9OmicA1kI30A=
X-Google-Smtp-Source: APXvYqwTQ4twrGI6FJuUEVkE4hkrt1wHbWnObH8hIpoJB3qmrjZrkdpB8gonEnq3aDAJSN9Kgei2Ag==
X-Received: by 2002:adf:e790:: with SMTP id n16mr87301698wrm.120.1564192484483;
        Fri, 26 Jul 2019 18:54:44 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t24sm49121210wmj.14.2019.07.26.18.54.43
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2019 18:54:43 -0700 (PDT)
Message-ID: <5d3baee3.1c69fb81.11a25.4097@mx.google.com>
Date:   Fri, 26 Jul 2019 18:54:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.61-51-g213a5f3ac1f5
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 118 boots: 1 failed,
 77 passed with 40 offline (v4.19.61-51-g213a5f3ac1f5)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 118 boots: 1 failed, 77 passed with 40 offline=
 (v4.19.61-51-g213a5f3ac1f5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.61-51-g213a5f3ac1f5/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.61-51-g213a5f3ac1f5/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.61-51-g213a5f3ac1f5
Git Commit: 213a5f3ac1f5e2af0e25fd4b26497590ec290be0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 68 unique boards, 27 SoC families, 17 builds out of 206

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
