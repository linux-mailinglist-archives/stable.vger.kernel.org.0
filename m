Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0D932E44A
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 10:05:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbhCEJEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 04:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbhCEJEb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 04:04:31 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8910C061574
        for <stable@vger.kernel.org>; Fri,  5 Mar 2021 01:04:29 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id e6so929048pgk.5
        for <stable@vger.kernel.org>; Fri, 05 Mar 2021 01:04:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=95lYDQAZratemzrlkk+D+iblESApF27KjKXQBQhROIo=;
        b=U8PqeNcS1Du8BHL1aexx3mezOBqkpjQ5rpiNrQ+9Wk3P9lyPHkxr7YllZDUg+UXGJl
         A0xsce353BUbbRHmpT1DBLnF7Og4WI8I7N5ZR8vFFIIcEaQfKZVbIhZ0c5yNY42Xp3IO
         7Bh5z+vIyOx4SzeHRf1HRUGypgj4/PKaLXDIlUcBtGHUpOVKBzuZpjYnLfAJzZlCh9+m
         0P7lN7B9l9SRDKgAJ3m2RYvrIhemPZxye/TS3XlhTpJcwvwaHczPm2Bi70Tz06TuIzRV
         MSlAObiNJw0bB3mSAsjOpoVWmUeZouzWLS535fvH+2c3AaxC6WAXbEUIKTEY/1TnZAVO
         LvbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=95lYDQAZratemzrlkk+D+iblESApF27KjKXQBQhROIo=;
        b=IARrmMzofJboYAzpkjHkuXoAu0s6GTbGp2+/4dhdm0De+qZK2XhRyERkK+sU7t6nBB
         F2XQs5950UcoA7ffOLAiE7SjPyzU+UkYu0k+FRIzP/g5a8VqBXjQ7dGxTGMWQ9m0n0Ak
         D71qiULYEpNZVhm3bdaROiJgrreR05xGEEECxQdAKdyoewhPvWVTpmHAe/UnV9Bd2bfs
         HvV8Rr0PgQNd0z7W+U+zoWYCrH/sjHOcLpIigcxwARtzB2kCr2zktfPqbgNj25E4EThT
         9kiDEjg1iJ0Yua3/HneU27pZy3HKaZ+pJCcE2IIOsRvm5K9Y73cB6n81P6VZJxt+iJ1d
         Ubeg==
X-Gm-Message-State: AOAM531lREGr58qAmqgtVS+s8Yg3JdqOY68FB4nQ59LJnpkPxdofHOvh
        TA4Pcvj1PhXODAIAhETDkPSxwzdK2MIdQAoi
X-Google-Smtp-Source: ABdhPJzoRo2YQxxzlTHgaAQnvbOvrSxl++SVcrGEIeTTeNUU3oUWOI9K7AG3p0k2HDo4refo7ZKdpg==
X-Received: by 2002:a63:e415:: with SMTP id a21mr7406067pgi.241.1614935068969;
        Fri, 05 Mar 2021 01:04:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d16sm1726158pfq.203.2021.03.05.01.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 01:04:28 -0800 (PST)
Message-ID: <6041f41c.1c69fb81.86d0e.546c@mx.google.com>
Date:   Fri, 05 Mar 2021 01:04:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.178-41-g1dffbe1ea7ec
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 108 runs,
 5 regressions (v4.19.178-41-g1dffbe1ea7ec)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 108 runs, 5 regressions (v4.19.178-41-g1dffb=
e1ea7ec)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
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
nel/v4.19.178-41-g1dffbe1ea7ec/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.178-41-g1dffbe1ea7ec
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1dffbe1ea7ec16261b2eb78fc20981601bcbed5b =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041bf60011124952eaddccb

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-41-g1dffbe1ea7ec/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-41-g1dffbe1ea7ec/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6041bf600111249=
52eaddcd0
        failing since 0 day (last pass: v4.19.178-16-gdaaebef7f79c0, first =
fail: v4.19.178-18-gecabdc57e1e82)
        2 lines

    2021-03-05 05:19:17.646000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-03-05 05:19:17.660000+00:00  <8>[   22.725616] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041e4ece34243accfaddccb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-41-g1dffbe1ea7ec/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-41-g1dffbe1ea7ec/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041e4ece34243accfadd=
ccc
        failing since 111 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041c1ef2e5281665daddcbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-41-g1dffbe1ea7ec/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-41-g1dffbe1ea7ec/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041c1ef2e5281665dadd=
cbc
        failing since 111 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041bd72e02fc24a83addcd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-41-g1dffbe1ea7ec/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-41-g1dffbe1ea7ec/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041bd72e02fc24a83add=
cd7
        failing since 111 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041c70b65cc9c3fa6addcd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-41-g1dffbe1ea7ec/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-41-g1dffbe1ea7ec/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041c70b65cc9c3fa6add=
cda
        failing since 111 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
