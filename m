Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4A147C9C1
	for <lists+stable@lfdr.de>; Wed, 31 Jul 2019 19:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbfGaRBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Jul 2019 13:01:23 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:37426 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbfGaRBX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Jul 2019 13:01:23 -0400
Received: by mail-wm1-f42.google.com with SMTP id f17so60474077wme.2
        for <stable@vger.kernel.org>; Wed, 31 Jul 2019 10:01:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OBhU3Ov7j2YUeUIQPbFUscNIvwRm1+QOrZpoKK1+hOU=;
        b=bbdZJhS3AjBXq6fhDIBFIkXefPtg7c+2Xl4Gx14YOEz+MYLpWq6ktAvEmlf6wnf3UB
         0Dd6D5L5bHspKOitJ14lxJmaC15IdE2JAeGTYO9VN7Wf7Df+HbuS9KnLIBAJssXNKdMg
         i5Ldq+uV8IN/0Lbu9aHR+29/kZUxq7y/eiqzoqbevaWTo8EtzRk7vLnkCXlHvovmrMF5
         3Z5b1YObl6ZAjOCpVIOIvgMhrm2PWywIz5DC9EGtxYphAmy1XnCtdzYyIlazqqVAxZOW
         FF7jf2aGnhxZTcvHMSispPuipkPCy5NJuJhoK9koEYkhGK73yd8Xa4ECuWTfG4/J1EQ0
         FVPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OBhU3Ov7j2YUeUIQPbFUscNIvwRm1+QOrZpoKK1+hOU=;
        b=Yx5NUucsjWmX2bNi5Ffm+2Y7uIebvPt/Mk+yuRv6O972UUbV/yKjVVSchcHN0OVNoo
         pF0UfH6wFe6/Agw3nOSY2Zpai2JBXm60BIq3BjdCu7zMT9xZxBGxpC4n7kXCG0Ru93VJ
         9MyEQVRmP3nQJmUnHOANbCmsF7oK232DtHJYSe6J7xi14Vzg13oSnb/RxrSNIQPEdvKY
         JguJ/PZT/EIIhlJR4rVNMmSXOswSsiROfz3nuS0HelFN5arzcXMEoVFzrr3c4Ewgc9X5
         QYxS2VsQaMtS9OLSNV8EFdXk6WLEdA90kW1lktDNbMf1uuP8mUxuRLfSLPjABwGBxokx
         +f3w==
X-Gm-Message-State: APjAAAUWVco+SkCde9l2LdgF9L5O3wxA3mrd7ywhT1ImHwyXsF0OfQOh
        yNFK/wfnDUwoTPctGRwx1y/NAzLptrs=
X-Google-Smtp-Source: APXvYqw6LMsbU6aeFYv5YbWy14vVswT5gNPAvNfIq5szuOZSeopEjqRouE+FjS029Sul1rHejY1jnA==
X-Received: by 2002:a1c:4b0b:: with SMTP id y11mr87324081wma.25.1564592480971;
        Wed, 31 Jul 2019 10:01:20 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id a64sm4790069wmf.1.2019.07.31.10.01.19
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 31 Jul 2019 10:01:20 -0700 (PDT)
Message-ID: <5d41c960.1c69fb81.bc923.09bd@mx.google.com>
Date:   Wed, 31 Jul 2019 10:01:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.186-216-gf61b5d80bbfa
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 100 boots: 0 failed,
 65 passed with 35 offline (v4.9.186-216-gf61b5d80bbfa)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 100 boots: 0 failed, 65 passed with 35 offline =
(v4.9.186-216-gf61b5d80bbfa)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.186-216-gf61b5d80bbfa/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.186-216-gf61b5d80bbfa/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.186-216-gf61b5d80bbfa
Git Commit: f61b5d80bbfaa5820eddeb363b965c6e175974d0
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
