Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7238019E
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 22:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436922AbfHBUQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 16:16:42 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:39351 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390716AbfHBUQl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 16:16:41 -0400
Received: by mail-wr1-f48.google.com with SMTP id x4so25214750wrt.6
        for <stable@vger.kernel.org>; Fri, 02 Aug 2019 13:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=COhvxAG7dKbMVjZPTbLk0Ko7IhtsmcqCfbyUU7QKoKI=;
        b=ocO7cOfARxsSQ5O1r3KVEDSqNj1+gpf8Vu7TZ8bt3y7/KyqbFvWlpxPQUvxf0VYej5
         3LGVIpRAYbpDPg8UyVqm3N2UFdtnaVw5UH3Jn7KoS+FtyWDfVmWyFczLjZJ7alfP9nwG
         mY0JDDjddAjRtyl4GOKbO0HZmBESoVdboVb+whFzZepEyV296rWhjbXeQuIQFU/UF69Y
         LvvogwAF0D2pDl+Bgl2ex9AuVYms+JTZdbCJr04obgvifdIQ2E4oJZyFfLase2a8SK4Y
         FDBApTrXvQ7A0oribXv1o8RE2wlQqVlWDdu8qa0YmhXgcCBcK+EBFbn3/sZyZ74SX8s/
         WQFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=COhvxAG7dKbMVjZPTbLk0Ko7IhtsmcqCfbyUU7QKoKI=;
        b=Ndx3kcGC4UGDVP8xsYh1X1MDm8stiJ5iDA4YLWIO9P4ZfnF+WSnzD5ZpZ7DkBkowYJ
         eMzGEXDYR5xjUubu8gxyO5Af3j6s08YN90VmqVg6tGzft841WI7ihiYymlSMXZQAJbTS
         LjVa1XivU08fZ1W/5e+++dWi6AOUt8k34ZCxwnoi2CqAQUSgbcDa5zMnOMU3YtFBAJsl
         BnWCJx3t4ScVzb+byOfOX6ZaSUoM7MsEFZz98nDIhnJwiuFLjg5wHe40CnnqFJbzhhFR
         dJUoNQhXpjwF9UL8mX3ta86Ksxvr57eF3mwUrCpm0cht5cLklKok0YJV6WzndA1hXR/x
         bIBA==
X-Gm-Message-State: APjAAAXOG+NLbvxisPYtmH/YJ/Cun6GZn9jtsV7CJ8YoqxJzPMcXCHYE
        j0WImjFR9yKxj7WEXh+HixU3zeGq08I=
X-Google-Smtp-Source: APXvYqy2C7BdhxHaYI609e23LRtAhX5IbK2qxJ68jJhrqcCpd0lQlHMogtsrBvlCbKWXG036XBeizQ==
X-Received: by 2002:adf:f60a:: with SMTP id t10mr112847303wrp.258.1564776999680;
        Fri, 02 Aug 2019 13:16:39 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f2sm71550465wrq.48.2019.08.02.13.16.39
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 13:16:39 -0700 (PDT)
Message-ID: <5d449a27.1c69fb81.8f6ca.10ba@mx.google.com>
Date:   Fri, 02 Aug 2019 13:16:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.134-319-g8c06cc9d4172
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 118 boots: 1 failed,
 76 passed with 41 offline (v4.14.134-319-g8c06cc9d4172)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 118 boots: 1 failed, 76 passed with 41 offline=
 (v4.14.134-319-g8c06cc9d4172)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.134-319-g8c06cc9d4172/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.134-319-g8c06cc9d4172/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.134-319-g8c06cc9d4172
Git Commit: 8c06cc9d417294ee552cee5025f8dad9a982a026
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 64 unique boards, 26 SoC families, 16 builds out of 201

Boot Failure Detected:

arc:
    hsdk_defconfig:
        gcc-8:
            hsdk: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
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
