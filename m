Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125831E71F5
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 03:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438257AbgE2BNg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 21:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438235AbgE2BNe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 May 2020 21:13:34 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FFD9C08C5C6
        for <stable@vger.kernel.org>; Thu, 28 May 2020 18:13:34 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 185so481477pgb.10
        for <stable@vger.kernel.org>; Thu, 28 May 2020 18:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=y5ryPFIoMRZmIvZupMp6JNIq6TLpf+xT20Jio3FxeZM=;
        b=OoJKES2V3KvR/2pP6rZSngPMZylHSH7TDYIN+jIOvAFJnVcIzIOFI3BZGt2etr+rjm
         dxXtG7rgVT3nQk19BdEx7fAMveoaS86ZutDBIOihbhFo+2Ps1wMfVnG5Kmkjg5pZ1KSb
         2BU5saEdBW0CFwDgabmY7F6/fIFtX6+8kEwNs57Z1TuIwUv+HqPhgsdHTiFGvU84XNsB
         BagQQCztlemX/O9Uj4KvHjV/DXASP/ysFNAsWkD9g/Kqx2+fgJF0vpKXDiVmwrkcFFrV
         JQLBRrqEfbCVHR6tAwzKZf4wrTbaysc7dgpouGBSdvUCqidWkS7ZQfiM2PKr780YsgPg
         mzVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=y5ryPFIoMRZmIvZupMp6JNIq6TLpf+xT20Jio3FxeZM=;
        b=Uga5BcSIQ7XZAP12ph+zhGltZt/7sKEJnmfGtaJC5H/Srm1ZEbjZeVZpoGYg6FX74x
         ze5Hy4ANFZ2STi5SZaKGE0EdHhJO9MXTVLA8t6tk2mVVjuWfd+hNrc5JywVnH/HOmUGU
         D6haiI1XLv7/DLEXU4TFhqzm42oEZHL5Wrlokm1Hlr3iJk2yzJn5K0vGrW90pJZ+88hK
         /1nvQPRbjnlKKmSYBqR264Grf3H8vhATPnQhzCA0oSXj/NndytiQbQ5q6al9ZLwI2cOK
         FiWVJcIz81gRW+yqQrjfGLRt3JKbDqQhRD00wBNzFCz8SGu4kDt9sE8aUn79cwXcY1rP
         J2eA==
X-Gm-Message-State: AOAM5319U1ocvmE56FonTDXSzIW64wa89ni2Q4q8Zra/qR9DF4515Gmh
        i2KE6lCrDlrO5+sjHTOwvXUOi/n2154=
X-Google-Smtp-Source: ABdhPJxqivInWXGfnhxpFyGQlVh/Tm5EwgQ9sQV7u7VmnyRHTddQn986BD0PHJhAmu2iri8fV+hXZA==
X-Received: by 2002:a63:dd43:: with SMTP id g3mr5946810pgj.286.1590714813881;
        Thu, 28 May 2020 18:13:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t201sm2785750pfc.104.2020.05.28.18.13.32
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2020 18:13:33 -0700 (PDT)
Message-ID: <5ed061bd.1c69fb81.44d62.1fdc@mx.google.com>
Date:   Thu, 28 May 2020 18:13:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.19.125
Subject: stable-rc/linux-4.19.y boot: 44 boots: 1 failed,
 40 passed with 3 offline (v4.19.125)
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
https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/kernel/v4.19.12=
5/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.19.y boot: 44 boots: 1 failed, 40 passed with 3 offline (=
v4.19.125)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.19.y/kernel/v4.19.125/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.19.=
y/kernel/v4.19.125/

Tree: stable-rc
Branch: linux-4.19.y
Git Describe: v4.19.125
Git Commit: 2d16cf4817bc6944a2adb5bf4db607c8258e87da
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 39 unique boards, 15 SoC families, 14 builds out of 166

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 15 days (last pass: v4.19=
.122 - first fail: v4.19.122-48-g92ba0b6b33ad)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 76 days (last pass: v4.19.108-87-=
g624c124960e8 - first fail: v4.19.109)

Boot Failure Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-gxm-nexbox-a1: 1 offline lab

arm:

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
