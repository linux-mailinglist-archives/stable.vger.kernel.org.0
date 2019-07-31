Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A75527CA01
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 19:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730465AbfGaRLV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 13:11:21 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37578 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730447AbfGaRLU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 13:11:20 -0400
Received: by mail-wm1-f67.google.com with SMTP id f17so60501537wme.2
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 10:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6aqp1SROVBPGL6PpjE2cr1MAchAQrVyyqOfG2x3pN60=;
        b=CwOXUl0MReCpzU50Di3jcj1sp90+SrT9ymFVLLW+kzzNVzKgdJe6lZ59om6p3/zp9z
         jmViIjzyLh5vEedqaDT1FjopdkXSJDCLktjSIYGD6fvDW9LahjlNI5OaoxWhi0c1akUt
         wNSyrtEI+jxqMRwkDZytwxdROSNPKMQS7rJHxawukvi3nQkNQHamItNVUvkZAIvppTUH
         h5ybVIcrz+ssPTK27gEl312GI6wKfTq/p2RMc7bwzmkLPXY7lTp8hJbZ2w/8jv7EUy9F
         kFD32irTRDO5zt084euUF6uM4sSSnDYW6o8/pNzLV6TCnglmw+psTbLlm1JYgzgF6AhS
         Zf1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6aqp1SROVBPGL6PpjE2cr1MAchAQrVyyqOfG2x3pN60=;
        b=P0DBmSXaIHB+nGBZfrkZ0tkXFhXHMyxINKLkNb7QdVtA+qTWLAbHLcXp3ccL1BHXZm
         eGW6RrmjNXN4fte9vBb7vRTzEP/cllm9/WNClLXcy0wfxrWsEDrwvz4DhVjFOJL8hF1t
         9+xq4ZdP0rs7hMoe/5l+lQDyeDZbOsYQkXpgY+jfp3sc6nMtgtwcbe8z7kT1oW+iWytn
         OukAqSz0PdlZ5fpVEBQuaeri9yNIDxjfy9mKvT48uiXmFYtvWO47wSzhtObeedl3/Q39
         EleOcgkncaESiSXV2eJ20pa3Ji85WrT9Q5PJjgjHOMxxCSsNLR8MMEIK0+NTRGuBm5Sb
         B1Qg==
X-Gm-Message-State: APjAAAVJHctLrcc+ehbFhBh1TeJRQw+AVKC0gcG3a2K9EENGQmgHVldC
        9CQXjuyfWLucbGp75QToaXI58kUYkHc=
X-Google-Smtp-Source: APXvYqwzh7idYmCnLleTnITaxTDfCUDwSORC72sCzi3NhL8anxwlgNNwoCWQzklgCrMSzZsYC6R4eA==
X-Received: by 2002:a05:600c:1007:: with SMTP id c7mr106884083wmc.161.1564593078910;
        Wed, 31 Jul 2019 10:11:18 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id z1sm72397365wrp.51.2019.07.31.10.11.18
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 10:11:18 -0700 (PDT)
Message-ID: <5d41cbb6.1c69fb81.feef2.f9fa@mx.google.com>
Date:   Wed, 31 Jul 2019 10:11:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.186-152-g312c583f6950
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 91 boots: 1 failed,
 57 passed with 32 offline, 1 conflict (v4.4.186-152-g312c583f6950)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 91 boots: 1 failed, 57 passed with 32 offline, =
1 conflict (v4.4.186-152-g312c583f6950)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.186-152-g312c583f6950/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.186-152-g312c583f6950/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.186-152-g312c583f6950
Git Commit: 312c583f695014a27e3ce0ab568e819e38e9ba3a
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
            lab-linaro-lkft: PASS (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)
            lab-mhart: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
