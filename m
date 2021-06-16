Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0D83A9D97
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 16:29:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233920AbhFPObR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 10:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233914AbhFPObQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 10:31:16 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DEABC061574
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 07:29:10 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id g24so1815439pji.4
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 07:29:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=j7QnuoqXzyWwXmwvWMBVTSsXOctC9xT11cERHuNBk24=;
        b=SJ82p+JjJJkC7lGK9z7tpJ3JHM475pCrQQhNWdi1b3ZuEvMMvX4rI88WMl/1kos11c
         CWLJfqr5OSCBe5pIu2xs8Pbiwo8pOn6DADzalMmwje2fiST9xX6+vzvndMpxkQbUBG1V
         8niVso7/86AY3KJ5HCcCCBP7uZbhuhm6r0Dh5+W7Gc4qZq8jff8qK6r2lMemA6zscYFy
         xJnBJwcbqd8A5PD9zYXObWS80nXpHgAVCiGQWOQ1Asz7QHl/8wRczx+sAs7ocq7kHiKU
         hRKi1RZgWGeH0UJgjJMVSfTiUPKNS9CMwyCnYddv8M1y1dbGdgGOE8xOn7xj2+Xt6bnC
         vrcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=j7QnuoqXzyWwXmwvWMBVTSsXOctC9xT11cERHuNBk24=;
        b=Ey+yhAW26XY6u9jWLrmeQ/+dZDcGq5Dz8nzopIWqsypm/0d0kB5VxOCbL2+p1HJBUT
         5yqdXgP/J+enYfkpUv1C0MqpAOiD0zzJguaneg5cRPmfbOnkxPZYUUieR8dvmMgpD0fN
         lGf7LCr3aU6n75vh+v4eQowhO6x6zednUaODrkt4PmBoul96STZ37wSFJXUvV06U4vTq
         EIlROPo+Di5U1T7E+B2z4BbIzxvnS8koVmBU3V2Y0H5GoijHThR81mf9P4sUCVDuHD+4
         QAP6JuAxkDtTXK94xFnsWljAF45tCd8Ity2LrfN7WhcNs+8nwRszeCKNmg9Vf4ess/JA
         8Bpg==
X-Gm-Message-State: AOAM533Dvjj9yDeF159ZDfIjCJzvRvWunGQ0/JxXTgpyNrpTYTJi/QYe
        y13tu4tJBm1bPoVUgBNBGhsP42hfBNBOP7Nt
X-Google-Smtp-Source: ABdhPJxopCGk1wSBDFmZVxMFrnu44EkhUQIuqE0u7C5kEQtil8PNsKe2j7a1LVllXUgrKOtJq8C8HA==
X-Received: by 2002:a17:90a:f304:: with SMTP id ca4mr28513pjb.177.1623853749704;
        Wed, 16 Jun 2021 07:29:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n6sm2555959pgt.7.2021.06.16.07.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 07:29:09 -0700 (PDT)
Message-ID: <60ca0ab5.1c69fb81.8450a.6b4d@mx.google.com>
Date:   Wed, 16 Jun 2021 07:29:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.272-42-gfe168fa6de1a
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 118 runs,
 5 regressions (v4.9.272-42-gfe168fa6de1a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 118 runs, 5 regressions (v4.9.272-42-gfe168fa=
6de1a)

Regressions Summary
-------------------

platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =

qemu_x86_64          | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.272-42-gfe168fa6de1a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.272-42-gfe168fa6de1a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fe168fa6de1a39a0989f4185719e24b343fa7b8d =



Test Regressions
---------------- =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9d69dab32c309be413271

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
2-gfe168fa6de1a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
2-gfe168fa6de1a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9d69dab32c309be413=
272
        failing since 214 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9d76946d693cde8413285

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
2-gfe168fa6de1a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
2-gfe168fa6de1a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9d76946d693cde8413=
286
        failing since 214 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9db3267c5321dba413281

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
2-gfe168fa6de1a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
2-gfe168fa6de1a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9db3267c5321dba413=
282
        failing since 214 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9e3a678a4ab217c4132bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
2-gfe168fa6de1a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
2-gfe168fa6de1a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9e3a678a4ab217c413=
2be
        failing since 214 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_x86_64          | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:     https://kernelci.org/test/plan/id/60c9d89631eff25091413289

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
2-gfe168fa6de1a/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86=
_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-4=
2-gfe168fa6de1a/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86=
_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9d89631eff25091413=
28a
        new failure (last pass: v4.9.272-42-g3a4807ec2fca) =

 =20
