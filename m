Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF55E1E130E
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 18:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388593AbgEYQvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 12:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388093AbgEYQvA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 12:51:00 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A53C061A0E
        for <stable@vger.kernel.org>; Mon, 25 May 2020 09:51:00 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 185so641151pgb.10
        for <stable@vger.kernel.org>; Mon, 25 May 2020 09:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WOc6pweHVwHxtycn4sSHaXIQBVpZNTSBG827U0E3ZZE=;
        b=GeQCNRBnPD+uoEePAm9nSZAj9v/xwmlx5emMJh3FNOZ42GJAe19Dti+md5mBrDEY1f
         FCUPreSu9vPYdpHiN8ZGHRJJLZ6onFG/kPux6JVGsI0rROWSvSgwDnuiIeULkpTwJRZG
         +lT82KjFr/8g0bOP6dObr0KnTf0dWK9/SOt9xOLJIIoFWMqGC5cFv+lb86nInqyT3kc9
         EBhJ3iprU819z6UuUg1s23N0SiwJNocPtDAG2vGLHc99xQZQ7YhKNFrppyxpJy+dO5y+
         lMJvLvOnyRHhhJUSfRX50VSBgT+FrFEQE5vcFu0RUkDsEKFC8V/tCSkt/ygeZ9/9u8SW
         2LjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WOc6pweHVwHxtycn4sSHaXIQBVpZNTSBG827U0E3ZZE=;
        b=NWs9Ypmt3yarAMUlP2NLpJEIjUFt8x/zhjmNX20kurD/05SUhcPqamXEQDEG6nEeIx
         UvXd7eavnrZqqkJBHFrxj4eSSi6UzlPgO+ZPbMT+4FyUzZP3XThvrrwn5g8MAtD/j4s/
         UR04vxJ650gOsHUVnhanH+BnfSH9g5NeL+JreNVgENtRCrqj4t7gFDOFmUrj8eiT+y54
         +ngVluxvP2VkzzpnuYqIg33R19A8lv0y30mXrQvjZtRYZVua+VnAEZqO6Vc5c/r07Ykv
         afjQbiqjNCRJu95ojNbmmzv49XHpH3N+hXnyqrqp5ThL9zAjJuWuvquQ7m11W897xVdq
         gqQg==
X-Gm-Message-State: AOAM531O042Dagaj8t5gVtYCxUj0lXwCcPBQJud5MA3Dt3DQ0GS4YCHj
        pIDK9GMoNd1e8Yg9eYy9zaZf+xWybXw=
X-Google-Smtp-Source: ABdhPJzlNJQiO2KTWc4sdBhAcn73YU6P786Jip2opUYzrHWbABgzsqwPMp4EK8LWQJGmNMi8po+jAg==
X-Received: by 2002:a63:f242:: with SMTP id d2mr28205000pgk.212.1590425459549;
        Mon, 25 May 2020 09:50:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o11sm13191289pfd.195.2020.05.25.09.50.58
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2020 09:50:58 -0700 (PDT)
Message-ID: <5ecbf772.1c69fb81.d3686.22e3@mx.google.com>
Date:   Mon, 25 May 2020 09:50:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.181
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 117 boots: 3 failed,
 104 passed with 7 offline, 3 untried/unknown (v4.14.181)
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
https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/kernel/v4.14.18=
1/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.14.y boot: 117 boots: 3 failed, 104 passed with 7 offline=
, 3 untried/unknown (v4.14.181)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.181/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.181/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.181
Git Commit: a41ba30d9df20fe141c92aacbb56b6b077f19716
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 71 unique boards, 21 SoC families, 18 builds out of 201

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.14.180-115-g=
53d55a576a17)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.14.180-115-g=
53d55a576a17)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 12 days (last pass: v4.14=
.180 - first fail: v4.14.180-37-gad4fc99d1989)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 95 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.180-115-g53d55a5=
76a17)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

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

---
For more info write to <info@kernelci.org>
