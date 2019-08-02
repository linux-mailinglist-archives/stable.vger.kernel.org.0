Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 224AE8022C
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 23:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbfHBVR5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 17:17:57 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53509 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727611AbfHBVR5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 17:17:57 -0400
Received: by mail-wm1-f67.google.com with SMTP id x15so69216549wmj.3
        for <stable@vger.kernel.org>; Fri, 02 Aug 2019 14:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UPT3G6MPwj+qn6G61hBhHdmhCvAjtlI+CKa1nkb+aoo=;
        b=xAP6nlh2T0TM2PcNCKlJ1L3pieOInp8WYDS4fA+5a8Ebuarjoc5JFoxqUxASKyFA+n
         tRbzWzO+ZHPCrqoIv6JDvOcGR1g2uRjV6t7tn7k1GpQg0CQLiB8/A7KirB5runP926E2
         3hhAu3Cz/IAI8TwuDwjnMCANvldElCnScJHOgYe6JxNEVXk7LnhrLJnA4/omaFKdZWYs
         ZCjLG6xI0TtO/wpJrYfWstqeyClZ9SkThnuUpQyTXkFTdHa4XrQUmdrtaR/gSGuEPZJY
         o+LEGICA00urwT2nk8WOL4mPyEe8GzwHr4ptABDRWm/LjIBuDIK0ePAMYtix2ZajEIfc
         WFgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UPT3G6MPwj+qn6G61hBhHdmhCvAjtlI+CKa1nkb+aoo=;
        b=FS3GyqI9q22YZyi/BPtGjUJ94+QwMP93nQUTPL9usm+9hsAXclj2rA7NjeqRVsFGr+
         ZTQPKvSPZIlPRexC6rozuN1rIyhxAaXJHfP6CaRRkbGNW9yZk7j90wyFqAZCF6HvOxVZ
         Hqzlzb+AMhhH3NFdIpRA0XQo99Agv/jWhZ+YcG+1idSH1t13aQ3FVqZmVYFriWlp2Nu0
         WHDc3zQSAmglGZAdi4a6lIgb6BP06kfAHUTYdcSUlu79frkA/UMzMavlgqtc8t4P/MjI
         58IxykLv1o+XqVlFrtuSIipmriGLEWokpUsADJ46FHbLSKQwNWWCHAYVxqoQyeOfF9Df
         rYmA==
X-Gm-Message-State: APjAAAUZfh3vxh0sMIejXiOYmJmXwUDehP0bY2SSDiOj72z/GjWkn5kA
        iQCBMuBJxENwgBrmSR87Rd7ZJazTN28=
X-Google-Smtp-Source: APXvYqxftB5Csiu9otgVZDvdHPgqSRL1w++Y2+RwXS2p09oZTwi3T6+uAt+zTWWQKzdKnwbv6xY9PA==
X-Received: by 2002:a7b:c5c2:: with SMTP id n2mr5657773wmk.92.1564780675109;
        Fri, 02 Aug 2019 14:17:55 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id p6sm83035340wrq.97.2019.08.02.14.17.53
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 14:17:54 -0700 (PDT)
Message-ID: <5d44a882.1c69fb81.c17e8.744b@mx.google.com>
Date:   Fri, 02 Aug 2019 14:17:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.186-157-gd9815060e3ec
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 92 boots: 1 failed,
 58 passed with 32 offline, 1 conflict (v4.4.186-157-gd9815060e3ec)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 92 boots: 1 failed, 58 passed with 32 offline, =
1 conflict (v4.4.186-157-gd9815060e3ec)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.186-157-gd9815060e3ec/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.186-157-gd9815060e3ec/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.186-157-gd9815060e3ec
Git Commit: d9815060e3ec2433dfffc8a3dcaed9842b1798c7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 44 unique boards, 20 SoC families, 14 builds out of 190

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

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
            lab-drue: PASS (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
