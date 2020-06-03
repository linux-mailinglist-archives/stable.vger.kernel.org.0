Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBB61ED7AA
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 22:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725985AbgFCUzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 16:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgFCUzp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Jun 2020 16:55:45 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6869C08C5C0
        for <stable@vger.kernel.org>; Wed,  3 Jun 2020 13:55:45 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id bg4so1246128plb.3
        for <stable@vger.kernel.org>; Wed, 03 Jun 2020 13:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kcWVZJlcNHmOiVzpVSQGcDwXL5DgoJJyBt1ybFkSvHE=;
        b=YQp0VYGo6sMdyzq8s6uNbOo5+9dQdAflVc92oVPwUdpqnBoVV0EiQhLH9GjDrlUgGy
         S86nh1acWny00ok9pzuiJVLBxQu91byb6RFpxDR4gyk8O/w0EPlJ8jrMVFbjMUZfbp4c
         NpIFPid0lplB8asz86006i5N9AnAGoHyQC2MTCw38cCridn8UJmzE6KC/+whnQR0OOEG
         3xniSicR7qHigirFUQ1Cn306dwpZ7yDbHSpt6x2sHsW5z4KBCMlSUCmZd4Fsn+RDoFPy
         k+D5K1SUz1o1UliJqtjmL/WRArz90x4XatFJAElNimRF4kUph7EBr71TKORjHnqb3wUN
         2L9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kcWVZJlcNHmOiVzpVSQGcDwXL5DgoJJyBt1ybFkSvHE=;
        b=kxXuplmRNuUumSFDoXfbPGPCmcuGyUdW05bmG0Sg9Ud3bU9FhbUVjhWus7GEsjU8O1
         YEaDrAKMJrAPxwMVmGZ/8/7xUFIpNMHV3yDgsChBvJFalXlRIwFY5b2ie7jVIIoS1ykU
         y53Jca6D1P+Aqg2pe+i7tdzJ5JatObm7D4skgPa4beWUhP9pXvNyzkNEx9l9owuwvdUP
         Id1AuVC2cxH57dtbxGj673CQYekveM3vwFHK6HTslMjDEUTke7GIRKPlPC+KRMzp4B9g
         UGLqpwwYwOzwMwxQoz1od6X5fYG5Uzh4m4EOkNk7JaWlfH7+IxtN4J64b66wC7NjN7zN
         Z8Aw==
X-Gm-Message-State: AOAM531RM/obq/Jt+ftNA8v89bzoVdE0mumapsYJVpd6ihEEYZ3dVMGk
        YYeGJ+BwLq86NVb5XqzS+QgdHTAAEHU=
X-Google-Smtp-Source: ABdhPJwP/xTxYteoVgM3mbluo51sCWLQIBPDJYG5YX1+SzpD5r1f+TzGKmnRCPhoBCBYTIvXhUKOdQ==
X-Received: by 2002:a17:90a:4d87:: with SMTP id m7mr1902195pjh.26.1591217744853;
        Wed, 03 Jun 2020 13:55:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b19sm2525521pfi.65.2020.06.03.13.55.43
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 13:55:43 -0700 (PDT)
Message-ID: <5ed80e4f.1c69fb81.c77ef.6d6b@mx.google.com>
Date:   Wed, 03 Jun 2020 13:55:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.183
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y boot: 121 boots: 3 failed,
 107 passed with 5 offline, 5 untried/unknown, 1 conflict (v4.14.183)
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
3/plan/baseline/

---------------------------------------------------------------------------=
----

stable-rc/linux-4.14.y boot: 121 boots: 3 failed, 107 passed with 5 offline=
, 5 untried/unknown, 1 conflict (v4.14.183)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.183/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.183/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.183
Git Commit: c6db52a88798e5a0dfef80041ad4d33cc8cf04eb
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 20 SoC families, 15 builds out of 161

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 21 days (last pass: v4.14=
.180 - first fail: v4.14.180-37-gad4fc99d1989)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 104 days (last pass: v4.14.170-14=
1-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.182-77-ge6499674=
2439)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-collabora: new failure (last pass: v4.14.182-77-ge6499674=
2439)

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

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-collabora: FAIL (gcc-8)
            lab-baylibre: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
