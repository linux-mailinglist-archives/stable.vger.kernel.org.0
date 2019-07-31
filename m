Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B6707C88B
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 18:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727941AbfGaQY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 12:24:26 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:35661 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbfGaQY0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 12:24:26 -0400
Received: by mail-wr1-f48.google.com with SMTP id y4so70379911wrm.2
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 09:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mgHCDernO/31h+J7cD8mLdmFCwI6F4yuEunEacTwYk0=;
        b=nxiF6YfT/GUJVNda8t1jYM/yHmsdOLwtS9CGin43vj6kA3q2T2KtJLhCaZ5J8y1uhL
         QP+3KRqqGkxZud+LhwDcLDirTnh1omn7kBe46T0S100bVEcY6WSgBhuXaTNUpitKU6SZ
         UDQurXCYeFRe3hMDc1vzAvfF3iuj2nmQ/+5hewHSB3loL17aAddNRxrr++dnbvLd/lYW
         o5nrxYm2XqZ+3l9MaR5JF3qMurC2g15nmqBWlNI8D533j205LWmn9wKUOWveth6t3FnX
         y5KixrKyw59/wWTBv1c33p7tlfn5apAyeJxbGvog+/FXOXeXnrZybmZ2hOgzTV29HZ8J
         3vgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mgHCDernO/31h+J7cD8mLdmFCwI6F4yuEunEacTwYk0=;
        b=oRpJFDqfuEqEMK7bfVPTTTVPmqBC17tyGkOyfu/n3tyjKPrmbdkFgiLDA6rRYiVcIH
         6PVa103z3UvsfwW9fz7weRCjXkfqVFZbzOEsF5YI6g+M0fPSBEUpHl9WC2wrLd5vkHPT
         IVv8QiP5QRyC95WnD9qL7P1KBGyrmut53y3ts+NFw8lHdi7QKpOLYHz3Xy1igPP7F9GI
         mmO7i69fQh7wfOALE8bbeaYjCDkvQKoPkgpkwVyJMLMEWWQLceT/BjP9pnKaDJ/JHrH3
         AL1HczfVoi15HlIDTdfxHG2XXfTGGSmFp/1kiwW43c0hL9qBEFqA+XaNwqv1D95/uuO/
         u5Yw==
X-Gm-Message-State: APjAAAWBr3D2nB0kcoxGkrqb8milPBimIVP3x23ZCk3WHStM5RR1xB5k
        sARzvm58ZrrVIRHPo05fQz4zoajKAMU=
X-Google-Smtp-Source: APXvYqyT9BKe3d/VTU0q4rPnt45VIL6nHgF49sOhSDG8+vvDNDiIH+deDnNcbr8/UQscQnQXg9xUNA==
X-Received: by 2002:adf:fdcc:: with SMTP id i12mr14379665wrs.88.1564590264279;
        Wed, 31 Jul 2019 09:24:24 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t185sm59208983wma.11.2019.07.31.09.24.23
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 09:24:23 -0700 (PDT)
Message-ID: <5d41c0b7.1c69fb81.731be.5ff9@mx.google.com>
Date:   Wed, 31 Jul 2019 09:24:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.62-124-g59a35b3f56e4
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 125 boots: 1 failed,
 84 passed with 40 offline (v4.19.62-124-g59a35b3f56e4)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 125 boots: 1 failed, 84 passed with 40 offline=
 (v4.19.62-124-g59a35b3f56e4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.62-124-g59a35b3f56e4/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.62-124-g59a35b3f56e4/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.62-124-g59a35b3f56e4
Git Commit: 59a35b3f56e49c0786df0ac8ef2665a63c7a3e60
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 72 unique boards, 27 SoC families, 17 builds out of 206

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
