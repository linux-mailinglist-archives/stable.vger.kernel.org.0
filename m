Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98E3D1ED3E1
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 18:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgFCQA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 12:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725855AbgFCQA4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 12:00:56 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A03EDC08C5C0
        for <stable@vger.kernel.org>; Wed,  3 Jun 2020 09:00:56 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id o6so2068358pgh.2
        for <stable@vger.kernel.org>; Wed, 03 Jun 2020 09:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZEyoJnDF6Eckkzoc1k1vwUbm3IBRXBSBRQZv1qajftg=;
        b=z8HEMG1Uv47So9o49U0pHJwb1uNIe47H0IYqkFt8JJ+mtfyPdXYDGosvWuQ7OgF0qU
         P3vKPQg5ajey64oJoRvUFk7APPiDNmIjyQoyGRpQa/wjt9wCX4Tvh/0UCWqg+7XYGsvc
         HMByVFZSqbVConoCGY9ZeLFkjZ9lFWg4t0mMk2Mae7AYuvsmhVHVGNT88i7D6N4siO8K
         afsx/oVo6XeQi00yCfU2dwUZ0d9JBgpH8OA+w+QxzivfpbjrpJzlOgSSPvztO1rGxVnB
         0GAH2DYz6NuhFgg+2kAi8nh1/wgm3b5wsrLw+tyUFVfvwZ59SIBjk3IfAdxHBxG2N42A
         DHSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZEyoJnDF6Eckkzoc1k1vwUbm3IBRXBSBRQZv1qajftg=;
        b=n/NclF5TRGXBtJe9qQ/uuQb9n1svALz0tIvh8aXH2HFy0F1EIycNz8P/SMx9TurEyn
         1FL1AMk4j++veTt06nc7LDyv5h2dXz9Gl+J2ubQaENd8dsW2sH8/35AneEyQdD6dyq9E
         7lIx/Dk5ZwLbx92DcvmoStrSE3RulQqqvjZm/NpXt5m9ByLEt9g+naYOiHqONXl94DMt
         btVzG2EzmlFZBz3AGI3OkdHzaJO8Y6wwP4VmH0F7J+rgXmczbsoOdVTB7LWGKPjttHpt
         Qp40g5kM35FfjfVdmXBPfwqwIfoaJS1sfIkHrSJ2fN6BUOWv2RQptElztCthrXiRf5dD
         q+AQ==
X-Gm-Message-State: AOAM530oIGrSYaUbIUOef4S4KQBwHFq5v125mFEsf51nulDnIZf1T2/u
        c/1WXE0U+6G9ebAQO3u46trqJlt6vgQ=
X-Google-Smtp-Source: ABdhPJwR02zl/0hvfcXnC94hMvh7uHeYbNVjo1pTbF5kHZC7hO8GJpSswsjocQoJH7Fxmw+roJhS7Q==
X-Received: by 2002:a63:3587:: with SMTP id c129mr115229pga.190.1591200054872;
        Wed, 03 Jun 2020 09:00:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i3sm2805084pjv.1.2020.06.03.09.00.53
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 09:00:54 -0700 (PDT)
Message-ID: <5ed7c936.1c69fb81.605a6.70e2@mx.google.com>
Date:   Wed, 03 Jun 2020 09:00:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.6.16
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.6.y boot: 87 boots: 3 failed,
 75 passed with 2 offline, 6 untried/unknown, 1 conflict (v5.6.16)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

******************************************
* WARNING: Boot tests are now deprecated *
******************************************

As kernelci.org is expanding its functional testing capabilities, the conce=
pt
of boot testing is now deprecated.  Boot results are scheduled to be droppe=
d on
*5th June 2020*.  The full schedule for boot tests deprecation is available=
 on
this GitHub issue: https://github.com/kernelci/kernelci-backend/issues/238

The new equivalent is the *baseline* test suite which also runs sanity chec=
ks
using dmesg and bootrr: https://github.com/kernelci/bootrr

See the *baseline results for this kernel revision* on this page:
https://kernelci.org/test/job/stable-rc/branch/linux-5.6.y/kernel/v5.6.16/p=
lan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-5.6.y boot: 87 boots: 3 failed, 75 passed with 2 offline, 6=
 untried/unknown, 1 conflict (v5.6.16)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.16/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.16/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.16
Git Commit: 960a4cc3ec49f8292d0f837f0a6b28b03c54f042
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 73 unique boards, 19 SoC families, 15 builds out of 162

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2837-rpi-3-b:
              lab-baylibre: failing since 1 day (last pass: v5.6.15-178-gc7=
2fcbc7d224 - first fail: v5.6.15-175-g4ceaad0d95e7)

    exynos_defconfig:
        gcc-8:
          exynos5422-odroidxu3:
              lab-collabora: new failure (last pass: v5.6.15-175-g4ceaad0d9=
5e7)

    sunxi_defconfig:
        gcc-8:
          sun8i-a83t-bananapi-m3:
              lab-clabbe: new failure (last pass: v5.6.15-175-g4ceaad0d95e7)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.6.15-175-g4ceaad0d9=
5e7)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-collabora: new failure (last pass: v5.6.15-175-g4ceaad0d9=
5e7)

Boot Failures Detected:

arm:
    exynos_defconfig:
        gcc-8:
            exynos5422-odroidxu3: 1 failed lab

    bcm2835_defconfig:
        gcc-8:
            bcm2837-rpi-3-b: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-collabora: FAIL (gcc-8)
            lab-baylibre: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
