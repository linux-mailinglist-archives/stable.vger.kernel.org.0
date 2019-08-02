Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F31A7FFCC
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 19:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405677AbfHBRmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 13:42:23 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:42441 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403848AbfHBRmX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 13:42:23 -0400
Received: by mail-wr1-f53.google.com with SMTP id x1so28092271wrr.9
        for <stable@vger.kernel.org>; Fri, 02 Aug 2019 10:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ge8ybRHz87bvskL1B6MsWm0d9xID58OcX/VyTrLLRlU=;
        b=g1lTieUViJSU5CJltellYPLSnUo68jANS+5u4coHLxrw7e9ZWp0jAmgROXb3YJj+hq
         vUxD0ZEpqOQGIC1DUwcumiAjTSLYoRZXyy4vhLXU0wBuejtnU5mum0yx9xsAHXw5TqVU
         c+lGEpFmZv5OpTNNS0WKBsvTaO7y76eXUJJELD3x5Mh9vuhZwEuooOZZSXYxICUQxaHA
         D3OZDihKBafQJ0VSMvWlPxW9kY4HzxzYvwfRO0MsNtc7oD+aQp0BAqRquNR7zdjZLMDf
         xCRIAWwilFnh1/vyTwv9BUGTKX5HqBBi5RhAtHWjeLBH0PkAeIaSTgKUeZH6rA0zGasA
         c8hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ge8ybRHz87bvskL1B6MsWm0d9xID58OcX/VyTrLLRlU=;
        b=MqCstsDfgDx11cIuijeFLvP8nhSeicXmSohVPch/WJ1R0QQTEPJ+UGk/b0PRQbH+/T
         4OlvDnIbq3J/G2TlJjDqacjtd7r7qiSkA5Ee+Fa2BTF86wtFfsP3PcL/0gZvIERczi0b
         IT4CDoaX73yZDQUK8Oyz0EOavpIYHy/Z3wRDhhZpnCXh+CWlDkB3n9MMu61sTqFIE87e
         wl2fRGapayZWLz06n62QO/lfKLpA3LCkBpxN7pdZWjpMTKs9ggP4CwsXOSCO7H56Qh9+
         wwtl+pZj8qoWL37zTkUYIypKYgDvQyqGn80zt5o134oAuHHGgRYRnCM5m6eznjHt2Mag
         PVqA==
X-Gm-Message-State: APjAAAU+hjUvwIdsOUlyQzb4w4dbCGP17aX12f1rSyvzfA9Yu7Ft31va
        lZ4oUdVrmIL2MLeTcC4t1tDAtsv3adI=
X-Google-Smtp-Source: APXvYqwc6R/1x64nRgkfLd/YDojpbk4ED5tUOckTwPzPH+Tgfi8fOTtfBvQRX2JIVils3NXCNQPWeA==
X-Received: by 2002:a5d:494d:: with SMTP id r13mr3724047wrs.152.1564767740834;
        Fri, 02 Aug 2019 10:42:20 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c1sm174632750wrh.1.2019.08.02.10.42.19
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 10:42:20 -0700 (PDT)
Message-ID: <5d4475fc.1c69fb81.f6d50.d117@mx.google.com>
Date:   Fri, 02 Aug 2019 10:42:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.62-148-g63a8dab46af2
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.19.y boot: 124 boots: 1 failed,
 83 passed with 40 offline (v4.19.62-148-g63a8dab46af2)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y boot: 124 boots: 1 failed, 83 passed with 40 offline=
 (v4.19.62-148-g63a8dab46af2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.62-148-g63a8dab46af2/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.62-148-g63a8dab46af2/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.62-148-g63a8dab46af2
Git Commit: 63a8dab46af2b65ecdb5a83662d94a3a26be973e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 70 unique boards, 27 SoC families, 17 builds out of 206

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
