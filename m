Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01A31C8041
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 05:02:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728371AbgEGDCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 23:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727095AbgEGDCU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 May 2020 23:02:20 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77104C061A0F
        for <stable@vger.kernel.org>; Wed,  6 May 2020 20:02:20 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x2so2235412pfx.7
        for <stable@vger.kernel.org>; Wed, 06 May 2020 20:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8CoaeW17SyP89ht0c2xAw3Mp519f5fhORtKTwLAWTlQ=;
        b=IJUsdaS2Etg6glDwrgSp42dYdT7yEucMOf/R2Mfz2NWAJ/onVE9omNAAbNjS5FH2qP
         NeCIEDGBZzhbtilSc5zAV2Rv0fJFxXp2CwMc/rCVu5lNnP95+ZGEATY1MxVYYQWVNBtv
         vep3dElDSNTr67VpAfLtpewkuH8Q31cYDCnTMtw5imiwhMtgMxNpN/EsAVZX78YpHp21
         HqBfIF76lB38rXFRz8CqsS9j5BTxi7XPJb3effIIvKL/LeA6C0QBIlYyncwMuloPi6s1
         mXXux+O/8SEA0pVXTKl5wGUdQHSLrg17i2Z60n5JiVInM1FSZPFLAPFbZutLADbpjvPZ
         sPuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8CoaeW17SyP89ht0c2xAw3Mp519f5fhORtKTwLAWTlQ=;
        b=ItLBN7HKoXLGPBpe0IFgD42xDzATO/8NDKWq4uLt6aFmxWn2LvpQmiA+0MJzz9blSn
         YV3iSwCTVOHjA3UNKNK4leLu6FYxh+95r+tJYSJT/TI2aRnIvtE44XQ7ZX1ku8W1RYEZ
         Zb5GGVdGgBm7Avbmhki5H83mViCS/BQXVtrq3Pxg8jqr7tT+/F7Vhke32aWUmhNT/5W5
         TbuTEIr6nh//KDxcdtVzOI9R35/t5otYApP23cy3oAasLc9P2OdgKHrr3XTB2+Sj/1tx
         CTDis/XBJMfhbDqAQYQzorhrjrJDdROQ+PDbzKZw869A/YBzPYemxiq7eydOJ5ypCEzX
         ApXg==
X-Gm-Message-State: AGi0Pua7KBg/3xzSpYOUykaF443EdGDyRXJtOvpu3QTLcxw5TtnW4HCa
        p6cK0kDKEAExe0lw2+dCAROpM61pOSAkRQ==
X-Google-Smtp-Source: APiQypJpowH8RotWFBV1vOW29NkOSLo495zhgvCg53nq2qURFt7PYgXG3nbYkSYTRGf13uajyDVxrA==
X-Received: by 2002:a63:ef41:: with SMTP id c1mr9269414pgk.13.1588820539672;
        Wed, 06 May 2020 20:02:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nl10sm6451275pjb.41.2020.05.06.20.02.17
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 20:02:17 -0700 (PDT)
Message-ID: <5eb37a39.1c69fb81.06e6.73c9@mx.google.com>
Date:   Wed, 06 May 2020 20:02:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.222-166-g7ab45cabed0b
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 43 boots: 2 failed,
 33 passed with 2 offline, 4 untried/unknown,
 2 conflicts (v4.4.222-166-g7ab45cabed0b)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 43 boots: 2 failed, 33 passed with 2 offline, 4=
 untried/unknown, 2 conflicts (v4.4.222-166-g7ab45cabed0b)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.222-166-g7ab45cabed0b/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.222-166-g7ab45cabed0b/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.222-166-g7ab45cabed0b
Git Commit: 7ab45cabed0becc5018c917eb494b860da28dd02
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 34 unique boards, 10 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 88 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: new failure (last pass: v4.4.222)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-baylibre: new failure (last pass: v4.4.222)

Boot Failures Detected:

arm:
    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
