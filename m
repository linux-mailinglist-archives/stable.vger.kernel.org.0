Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 779417FECA
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 18:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729969AbfHBQlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 12:41:55 -0400
Received: from mail-wr1-f41.google.com ([209.85.221.41]:38557 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729353AbfHBQly (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 12:41:54 -0400
Received: by mail-wr1-f41.google.com with SMTP id g17so77837933wrr.5
        for <stable@vger.kernel.org>; Fri, 02 Aug 2019 09:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Dphdj/Uz7mdS+pm5iwRrav9KP/Zk7d3Qu4ZS5Ckwgh8=;
        b=MQW7QE3lbl25NKVa7GuBFzot9TtzQN2Lt8eu/mEc3mVD6YD7RVw8Jk+tSEKvFixlhu
         HrD9Ya3He/O3vc3t5E2xyeDJU0OnMdMTRQ/D1Gl4upn+QsPy4qFUrL8Bd4QjLWI0ioZQ
         IjWL2/XjCf7gbm77raUOWu4ECuub/C9vudli5F1SfQQf0Rb581EJrq4MZyZj7gfW5jud
         oqiiNMpatOioUVJXdGGZtVCZ72E5uTB3s59xDViWSlt9vckPpbsYbvCEB9yvibdrkWdk
         ruhhYuqIgYUV/k9I3jyOw1DpCtuXuMn7D2x6vL4qVQ48vIGCJQhbJgIsw/92/2hANrBs
         79/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Dphdj/Uz7mdS+pm5iwRrav9KP/Zk7d3Qu4ZS5Ckwgh8=;
        b=mIngZ5A2cecrJwiCqX6zsMfvzwEgkiraY3GTgaNTKUGS6QgbyuOMgsjPmIy33ZBg/o
         aa3QmMCX0UXx85kkrtSUExCtuKvGmjLfnlpQ5oWKjr0LQq4kt42/s+cZzw7ejVQ1A2G0
         U4DTsfl+Aew8gddKNwRB0HZEPu8ceK5qzA9t/QWFulGf3LqW3ron/FQfZ7EsBUfmfihG
         zeHMaK9raui2XMVEiV7x9/M1wwaC6zJpWE2r9BCa5WSRJPrjmoCNN2kQIQ96D3ztSBHT
         sLKMK/+aa7ztavFUgkI8j402/3j+Z0q0Vv/b49bA5Azyi0QYN6kkDY970I4BCVbQohSA
         FjQA==
X-Gm-Message-State: APjAAAUTf9ai8HdUqx46gnmzpR5omBvQDm86X6M1wkBfReaG30yc1dRz
        71QVbRdvZ1oczhXEVSf7+1U0OGMYGxg=
X-Google-Smtp-Source: APXvYqz4qOY2+QVKbLemzF6UU0pf5VMipvSVI8CvcpeDmcKukS4ZyL6uSfYcMKRjQ5gM3za96vnLRw==
X-Received: by 2002:a05:6000:14b:: with SMTP id r11mr73844847wrx.196.1564764112911;
        Fri, 02 Aug 2019 09:41:52 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id w24sm58460470wmc.30.2019.08.02.09.41.52
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 09:41:52 -0700 (PDT)
Message-ID: <5d4467d0.1c69fb81.46a14.9904@mx.google.com>
Date:   Fri, 02 Aug 2019 09:41:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.2.4-236-gbe893953fcc2
X-Kernelci-Branch: linux-5.2.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.2.y boot: 136 boots: 0 failed,
 90 passed with 45 offline, 1 untried/unknown (v5.2.4-236-gbe893953fcc2)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.2.y boot: 136 boots: 0 failed, 90 passed with 45 offline,=
 1 untried/unknown (v5.2.4-236-gbe893953fcc2)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.2.y/kernel/v5.2.4-236-gbe893953fcc2/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.2.y=
/kernel/v5.2.4-236-gbe893953fcc2/

Tree: stable-rc
Branch: linux-5.2.y
Git Describe: v5.2.4-236-gbe893953fcc2
Git Commit: be893953fcc2e52d00dca6f23ade35fd35cc9364
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 79 unique boards, 28 SoC families, 17 builds out of 209

Offline Platforms:

riscv:

    defconfig:
        gcc-8
            sifive_fu540: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab
            meson-g12a-u200: 1 offline lab
            meson-g12a-x96-max: 1 offline lab
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
