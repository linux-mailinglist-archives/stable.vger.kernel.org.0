Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE697DC82
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 15:26:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731227AbfHAN0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 09:26:20 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38344 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731138AbfHAN0T (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 09:26:19 -0400
Received: by mail-wm1-f66.google.com with SMTP id s15so41842747wmj.3
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 06:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ygiMt7D+UUPzNtAjEIP/DslqUuv3wEIPtBF6V5M4JVE=;
        b=O2yZEzyU8WvUUKRilJRCSsDjvRu9M65Fv3BJhwB+jVGoWTvimx/RVeyTKxrT21msiV
         IihOry4Vl8ZctGyOBPbmZmMZdndPa9Q6FQXuJwhPceWMV9x/evMURDw81lNsZZyi0etb
         Knx5Zrg7Tb6T683TM06EZw2gBd2UJEXq9o60pvSxmuqc6+p9p3Jy+qzDjVaQddX9zTHl
         oW31bhgdgctRZW1Zic5P1G7zjeq+LDpoQx0TNufPPaQgL755FOi8ncW7hXUe0BrQCIsT
         4VesX3LoKfXtn9VRa/VGGWwvnqK+ghJ92tldbep0qnmtcpYJA1a8K42NpE479CP2QJHL
         bWjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ygiMt7D+UUPzNtAjEIP/DslqUuv3wEIPtBF6V5M4JVE=;
        b=rIWu3EaYw6KfNNeqgYAK8RhSY1/bQNFFI9eWIimOwKqVCWaLc9jVy08My4v6tPz9la
         bORUvfZvnLv846xbcLqvjkMUUjDgxCwbjqKpTJPeRuGgDrHx9HweDtT+iE1zSuF8+0AX
         LsyqTM7APRKMKziIjTZFBdRtC4B8fFL0jlILRvtVl6QtJINe8YDEcvaWzrUoMKL1aep4
         eIjxYYc9KRpk5tu3kQAxvcWrGNZZRivAAXNAxMfoJmiklsE9Vz8TyQwqcDwkLFDky7oA
         JpsLd4Anh+VhFgd9mkqkCNTlnqE5/54XhiRWHkxIumRD2CyubT+UfAMIeKmI0MG/7tEA
         GRCw==
X-Gm-Message-State: APjAAAXC1vVWOHLen8+bX50eFhKl+LtiDCagFzxUp9z381rpdFM30Vyq
        qMq7/dZ/bgVWia7TrLugtPT1Epir0lA=
X-Google-Smtp-Source: APXvYqzQGWc7Zo/WdME0w0uimr1UtYGYDb7/b1e6pd/MVstOBWpglgxpfdL1twxQKN0QeaY1eDQ7Mw==
X-Received: by 2002:a1c:7606:: with SMTP id r6mr1849473wmc.118.1564665977521;
        Thu, 01 Aug 2019 06:26:17 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id g10sm54200080wrw.60.2019.08.01.06.26.16
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 06:26:16 -0700 (PDT)
Message-ID: <5d42e878.1c69fb81.9104.158e@mx.google.com>
Date:   Thu, 01 Aug 2019 06:26:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.186-155-gad2e7f4d5a83
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 86 boots: 2 failed,
 51 passed with 32 offline, 1 conflict (v4.4.186-155-gad2e7f4d5a83)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 86 boots: 2 failed, 51 passed with 32 offline, =
1 conflict (v4.4.186-155-gad2e7f4d5a83)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.186-155-gad2e7f4d5a83/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.186-155-gad2e7f4d5a83/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.186-155-gad2e7f4d5a83
Git Commit: ad2e7f4d5a837932c07c937dee0c5bf8fbcdf2e7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 43 unique boards, 19 SoC families, 14 builds out of 190

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

arm:
    multi_v7_defconfig:
        gcc-8:
            exynos5250-snow: 1 failed lab

Offline Platforms:

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
            vf610-colibri-eval-v3: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun4i-a10-cubieboard: 1 offline lab
            sun7i-a20-bananapi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-linaro-lkft: PASS (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)
            lab-mhart: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
