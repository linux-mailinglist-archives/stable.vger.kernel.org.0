Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDB081CDF3D
	for <lists+stable@lfdr.de>; Mon, 11 May 2020 17:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729956AbgEKPkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 May 2020 11:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729725AbgEKPkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 May 2020 11:40:02 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B566C061A0C
        for <stable@vger.kernel.org>; Mon, 11 May 2020 08:40:01 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id t11so4737273pgg.2
        for <stable@vger.kernel.org>; Mon, 11 May 2020 08:40:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=axf1Sh1HYDw4aTwjM52aNvVffF+ggFgj2CCTXsrVD3k=;
        b=ecRmNkjom8mWcFLayp7iDN7X6j2HY7NqHsTOn2Yu4Ryxg4k1l/RCQIE1n88weAoN8d
         Rf86APh2FUlJoE+z8S8IVzNytdmgIQuYCPTEKXiztjhOvDcZhoZ+Gtkl0kQhVLuFHX5q
         2PuG8p5eT9ZP4h0VqFAbIYpKwWqf2H69mIGKAGcBvkOjs5et9IbTVPVBYRD9winrnc/p
         ixQgu7ULnNC/bnUL+WZ7T1R0AZB7bOdYt9Q+xkWnnYGTtd1CMFqpzBDsrUlQVn/6xK4V
         Z0RYISHGUb89ZB8Pi3FCzge6MBamQfzIKjFfB/uRTn6krDk086MUj+JT/sVWQrjknwGW
         Brqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=axf1Sh1HYDw4aTwjM52aNvVffF+ggFgj2CCTXsrVD3k=;
        b=uTE1iK3LY6r3qFpV19edDpnFdb8FGTViwpRMI73U8e4UVj19ee/pgGAVC31MeL3Lw5
         yPuAmc0Iuy7G6ArhaOrYMC4bds96RU/qFUwSAdk6jjPKFJ2gJsRni08vpkrs8ZHKBIoH
         Z1J5LVFkmU3ZEaOc1D08qFlCpVMl7QNIOo6L4FVbTBNaAIX9M6VuWVV/st0UvBRbqbeM
         HvCm7LS8thKtuuc/qBkiHWqFBpyVGXObTpUGhRHBDmdWhVpx33iOw16SpSvXrQvwlEtQ
         4L4x1HSpXb2PvHW/LjV0dpbnqFn8VR/HFDvPmlDAo34sLnUqsGypmCeI4qXgOuEfLNEk
         dr7g==
X-Gm-Message-State: AGi0PuauwvsT9AqL6nXqB7/pAWh+UhWi9G4Fv5xX3INl/dhGF16o/yMy
        KXO7hFyuOor9eref7O+0PxlaZdrEJNM=
X-Google-Smtp-Source: APiQypKzyFomeFH6CGGY9PYxXfcO0AqvmlVQX6CA+fxxMZeGSwj2S+PV+1ukEGDSadtSa8r1lSL11A==
X-Received: by 2002:a63:2485:: with SMTP id k127mr15271543pgk.159.1589211600260;
        Mon, 11 May 2020 08:40:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i21sm4589713pgn.20.2020.05.11.08.39.59
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 08:39:59 -0700 (PDT)
Message-ID: <5eb971cf.1c69fb81.d6599.0934@mx.google.com>
Date:   Mon, 11 May 2020 08:39:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.180
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 125 boots: 3 failed,
 104 passed with 13 offline, 5 untried/unknown (v4.14.180)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 125 boots: 3 failed, 104 passed with 13 offlin=
e, 5 untried/unknown (v4.14.180)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.180/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.180/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.180
Git Commit: ab9dfda232481dcfaf549ce774004d116fc80c13
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 19 SoC families, 18 builds out of 201

Boot Regressions Detected:

arm:

    imx_v6_v7_defconfig:
        gcc-8:
          imx6dl-wandboard_dual:
              lab-baylibre-seattle: new failure (last pass: v4.14.179-23-g3=
b9862300234)
          imx6dl-wandboard_solo:
              lab-baylibre-seattle: new failure (last pass: v4.14.179-23-g3=
b9862300234)

    omap2plus_defconfig:
        gcc-8:
          omap3-beagle:
              lab-baylibre-seattle: new failure (last pass: v4.14.179-23-g3=
b9862300234)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 81 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.179-23-g3b986230=
0234)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    omap2plus_defconfig:
        gcc-8
            omap3-beagle: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra30-beaver: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            imx6dl-wandboard_dual: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab
            omap3-beagle: 1 offline lab
            stih410-b2120: 1 offline lab
            tegra30-beaver: 1 offline lab

    imx_v6_v7_defconfig:
        gcc-8
            imx6dl-wandboard_dual: 1 offline lab
            imx6dl-wandboard_solo: 1 offline lab
            imx6q-wandboard: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
