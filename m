Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0B61C9D84
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 23:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgEGVij (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 May 2020 17:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbgEGVij (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 May 2020 17:38:39 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B6AC05BD43
        for <stable@vger.kernel.org>; Thu,  7 May 2020 14:38:39 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id u10so2607108pls.8
        for <stable@vger.kernel.org>; Thu, 07 May 2020 14:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fTS201rL0eXI40/c/DQs4xE8yn6MhGTjoR5UjIZWa7o=;
        b=B9v9qg3GNkmjkBustQU5jlDULK9JMpNWjlhGzrI3+mssg8vcLfiPvb9TnMmLlj3aN4
         s+LI/XP/GwVMLi/XUDYRWmwIhFoqVXs7ybfE4JijhbD3UsSTKiQeIktZIIYorXGocWSK
         wpZkAOI1rEAQv+YccTvU+0LJ2vvAFNFhMH7Bt1X3OAZDAqbu0oC+B20Lqu5hYZ1umVCr
         TiHgj/AlNuuU1BBM0uZJsjnOKNoDemtpCs8Xxeu1FMu0diH1N8TALuhMO0cFOtCAsFtn
         y/UrtfzJVCltlrn5PYXBCvezQzTRv4pDqn/UYq5PRVKnsjPAyXDqI3kg4TBRbxvPX7ck
         sDAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fTS201rL0eXI40/c/DQs4xE8yn6MhGTjoR5UjIZWa7o=;
        b=aHna2cAr74pjmFpaJz4pWA5D3m82uwms2vK6TOUNzMYhd+osSWVtZ9PqGoOjyt98vq
         rDTlDYxd3z8LIsWpmea4JpAo6qipsP8m77xs+VSh1x1hJEK7vkpEPCm0id/N1uqSaObS
         wfT/jWTzd3f6ilcJziwS9v43tWIX9Cyo0qqhqXmQvrLJPawg8nnJqNcYIlKZGKRG2wU3
         tnvPAApoPBsIJj8LfAkkw0zL8pF5HKTBd1YMWi+6Wj7X8A+f/siKGFPy42iF7TwLhMzw
         IoJjywYsed9Ip+v+arsp11d0opgnRDj4PP5DTEBYr9XWa/KhSd5GSa1W+6r2/QUdsfGw
         sD3g==
X-Gm-Message-State: AGi0PuaMblwhKaCbmPixF/hi7MvTLDdI/MfR/UchxsIPFMdfm5sE8nDg
        6cn+JHFM2Ys87i8YVQSKjmmDcz1BmUo=
X-Google-Smtp-Source: APiQypJqpOR+P3Rl4NNnPb0usT0O/jF4aJiNXkZTMgNUddfZS5GecWX2ItoCU25d+QTrPOFeyC1+Vg==
X-Received: by 2002:a17:902:8601:: with SMTP id f1mr15805132plo.122.1588887518437;
        Thu, 07 May 2020 14:38:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r26sm5950380pfq.75.2020.05.07.14.38.37
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 14:38:37 -0700 (PDT)
Message-ID: <5eb47fdd.1c69fb81.cc1b2.3d05@mx.google.com>
Date:   Thu, 07 May 2020 14:38:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.222-321-gb1cd678a0c39
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 42 boots: 9 failed,
 23 passed with 5 offline, 5 untried/unknown (v4.4.222-321-gb1cd678a0c39)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 42 boots: 9 failed, 23 passed with 5 offline, 5=
 untried/unknown (v4.4.222-321-gb1cd678a0c39)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.222-321-gb1cd678a0c39/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.222-321-gb1cd678a0c39/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.222-321-gb1cd678a0c39
Git Commit: b1cd678a0c3999314bdefe2f279faaa2d2ef5c01
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 33 unique boards, 9 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.4.222-166-g7=
ab45cabed0b)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.4.222-166-g7=
ab45cabed0b)

    imx_v6_v7_defconfig:
        gcc-8:
          imx6dl-riotboard:
              lab-pengutronix: new failure (last pass: v4.4.222-166-g7ab45c=
abed0b)
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: new failure (last pass: v4.4.222-166-g7=
ab45cabed0b)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: new failure (last pass: v4.4.222-166-g7=
ab45cabed0b)

    omap2plus_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-baylibre: new failure (last pass: v4.4.222-166-g7ab45cabe=
d0b)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 89 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: new failure (last pass: v4.4.222-166-g7=
ab45cabed0b)
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.4.222-166-g7ab45cabe=
d0b)
          sun7i-a20-cubieboard2:
              lab-clabbe: new failure (last pass: v4.4.222-166-g7ab45cabed0=
b)
          sun7i-a20-olinuxino-lime2:
              lab-baylibre: new failure (last pass: v4.4.222-166-g7ab45cabe=
d0b)

Boot Failures Detected:

arm:
    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab
            sun4i-a10-olinuxino-lime: 1 failed lab
            sun7i-a20-cubieboard2: 1 failed lab
            sun7i-a20-olinuxino-lime2: 1 failed lab

    imx_v6_v7_defconfig:
        gcc-8:
            imx6dl-riotboard: 1 failed lab
            imx6dl-wandboard_dual: 1 failed lab
            imx6dl-wandboard_solo: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6q-wandboard: 1 offline lab

---
For more info write to <info@kernelci.org>
