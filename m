Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62F2E3978FF
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 19:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233871AbhFARY5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 13:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233853AbhFARY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 13:24:57 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A932C061574
        for <stable@vger.kernel.org>; Tue,  1 Jun 2021 10:23:15 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id h12-20020a17090aa88cb029016400fd8ad8so75089pjq.3
        for <stable@vger.kernel.org>; Tue, 01 Jun 2021 10:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9MtYf1wk/B0IphomNqm8OLRTouCJRdgXYQNTHZDHU6o=;
        b=HqzqpiMqCDOsUCPo75l4fNSylATwSbe3b/y/0ooG4kRjL4o4iwE15/79mhO1YqLPGh
         +mhJpeaTbyR+m1yotK1DJGOSqDRDyIaxdmso2mSKMxHyhyCF4b9XiZGrKmKzjJ51QWsQ
         HgHAAUhA/0V6Iee68NZGtmwy7AbETr/remq98ehT5VLfb+6czgD+tUJLaSzJtkI+MyWA
         Hum0x1DoVLh00094oLJTlQirZMGq34mpRL8cpMWRJqupB1fbuaHMEj1oJHx9et1rVBeC
         2Z+yrwIgp7kZGCKlBCHfNQyBKVn0arV+elpvmWlN9nvi0lHnbhHVxuNWw+qQHWt6YETb
         KAQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9MtYf1wk/B0IphomNqm8OLRTouCJRdgXYQNTHZDHU6o=;
        b=M+eXE32FhXahLnnZeED7497IrEyNRbXYMTO5vr17BVqQcw9O1+vOZPr2DNeo2Ji05E
         oewnxxvnWD/PBn0tHK/1U70GiEH0/r8/OiSSKdMqwpDk0/ErwCSbf7vQdH9J4z2siZgT
         Wi2qDJt7EGbeyX8GTFcKf2SIhiDdSZaF9Q4aaOCvSp2NF4kqkIa+Hd6z3NtTrxSefFkG
         n0FsbODGu42tufQevSCamYyYeaIUZZQUaCiC9mcyzKSm5p+j9DraGRpgm1wIwBO3BldS
         TGLZJFTbT7NmLWkd9pm5OR4FAUofxGGPdShausKkx+29rbDdxAaNMCUrzKO4DFYZ9Yxc
         Z1Ww==
X-Gm-Message-State: AOAM531cNTrWowykOTm45S0RpuxSBDewJ7u3pj8Mx64GX1XV3E000eTI
        7//GulvsFNxhQKaBBmaS0geoAWwu8rpQ1SXc
X-Google-Smtp-Source: ABdhPJy6Eju6hzQbwINcjtAolfaqvHk7wR5cOxVawApgTq+ZgTSnUQFkzKW2oiZ9jiFaZoc+jFZJ8w==
X-Received: by 2002:a17:902:eccb:b029:106:def0:2717 with SMTP id a11-20020a170902eccbb0290106def02717mr7151715plh.66.1622568194799;
        Tue, 01 Jun 2021 10:23:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l5sm13500973pff.20.2021.06.01.10.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jun 2021 10:23:14 -0700 (PDT)
Message-ID: <60b66d02.1c69fb81.b4aba.b740@mx.google.com>
Date:   Tue, 01 Jun 2021 10:23:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.192-115-ge92a0c50d733
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 170 runs,
 5 regressions (v4.19.192-115-ge92a0c50d733)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 170 runs, 5 regressions (v4.19.192-115-ge92a=
0c50d733)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.192-115-ge92a0c50d733/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.192-115-ge92a0c50d733
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e92a0c50d7334dd85cc9964c6b0c4ba47262a416 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b630fa2f9e1ba72db3afbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-115-ge92a0c50d733/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-115-ge92a0c50d733/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b630fa2f9e1ba72db3a=
fc0
        failing since 199 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b630e862cee06a93b3afc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-115-ge92a0c50d733/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-115-ge92a0c50d733/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b630e862cee06a93b3a=
fc2
        failing since 199 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b630c03f0d41887bb3afc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-115-ge92a0c50d733/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-115-ge92a0c50d733/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b630c03f0d41887bb3a=
fc2
        failing since 199 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b645eb119b7f175bb3afaa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-115-ge92a0c50d733/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-115-ge92a0c50d733/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b645eb119b7f175bb3a=
fab
        failing since 199 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b63f801c6c9dafffb3afbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-115-ge92a0c50d733/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-115-ge92a0c50d733/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b63f801c6c9dafffb3a=
fbe
        failing since 199 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
