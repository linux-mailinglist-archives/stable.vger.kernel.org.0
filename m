Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61DAF33A14B
	for <lists+stable@lfdr.de>; Sat, 13 Mar 2021 22:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234410AbhCMVIk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Mar 2021 16:08:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234331AbhCMVIY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Mar 2021 16:08:24 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8175C061574
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 13:08:24 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id u18so13491632plc.12
        for <stable@vger.kernel.org>; Sat, 13 Mar 2021 13:08:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0S3h5WYvDVDc0/EZTAMVvgZtBjqmpwLEBXgragd1xZw=;
        b=PeOtpOv3FkT7C19RrVhRYl3T9hEtdqDezUlyCw+Gjatj1mUoFai/kATHhuDz5HPLra
         4nuGaDJuNSfGXel6bqyxli8zea0Pkp2l5BXikMrQjU6W85l1LAMuuYp5VcZieqzZXFre
         Txfxhdh2BX9Jf9VBTv1EqRXDsjf0ljLWwWhlZ3NSupgvHAcV4//Z6tZ/f482JS4q3Cm1
         XwmAbWFSzKi8K1hiT0fAqHbMCaQM8ZPrrJHCveYWHij17jxkENIHvjG4PsMqk6Epzvrr
         zKTZZDwTsRDBXr+IfbiKFiXBTcZK90CBSfwVBtdlWpV7w51AvE9IWZj6m7UdwqTR6GQi
         Aq1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0S3h5WYvDVDc0/EZTAMVvgZtBjqmpwLEBXgragd1xZw=;
        b=ritFBBs9R6LpSxvqWAwKmJeH1p3dgygks58/Gh2203nudP0BvcRHPN4wyOk2dwHtkW
         Xdz+7nydLWuhE77WKo4jsZzjF0XM1Gypp/bTbXks70Hgy5Fn4e+9QzjrU3oL1VEzuSzP
         WMY24U6sIDZrXXMCsETAPWev+lqXrBPbZ17yzgvi8pkczKhSpETDNlPpAZWQfaJXWYp0
         SM5+Yu3UOTCtmBo5ABlGfhX3vvrikgHXvKejSoERw7lOChM00lsrx700rYpV36KaiqG4
         ay5POccYfxd9x5L6r1boyaGaubsTqD4jRD77w1Nng4oT7r8XqPv9AtTWVp+T5twEUzNO
         4mUQ==
X-Gm-Message-State: AOAM531w1mFtPaJGMEQ2Sj5+1vsFAjvMOU+aVyHcQ4WrDxKCDKL/H+bs
        p6x6ywbLY3MYiLg32axBzNYuTE7nAspNFQ==
X-Google-Smtp-Source: ABdhPJwK3Y6vDeESg4q65Q00hgJVuQj/0WRtnR88+kdgzwYGozXEa+imXn59slqBCWK6eKkoS+kb1Q==
X-Received: by 2002:a17:90a:d58a:: with SMTP id v10mr5344385pju.36.1615669704017;
        Sat, 13 Mar 2021 13:08:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q184sm8934621pfc.78.2021.03.13.13.08.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Mar 2021 13:08:23 -0800 (PST)
Message-ID: <604d29c7.1c69fb81.3d685.6acb@mx.google.com>
Date:   Sat, 13 Mar 2021 13:08:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.180-96-g96b1140178d95
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 109 runs,
 5 regressions (v4.19.180-96-g96b1140178d95)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 109 runs, 5 regressions (v4.19.180-96-g96b11=
40178d95)

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
nel/v4.19.180-96-g96b1140178d95/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.180-96-g96b1140178d95
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      96b1140178d95c7437921195f999dab2689ec92c =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604cf8817339a81b57addcb6

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-96-g96b1140178d95/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-96-g96b1140178d95/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/604cf8817339a81=
b57addcbb
        failing since 1 day (last pass: v4.19.180-18-g4334f738815bb, first =
fail: v4.19.180-40-g3f0127cea9d86)
        2 lines

    2021-03-13 17:37:59.697000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/105
    2021-03-13 17:37:59.706000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-03-13 17:37:59.721000+00:00  <8>[   22.995758] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604cf703e36e028640addcb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-96-g96b1140178d95/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-96-g96b1140178d95/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604cf703e36e028640add=
cba
        failing since 119 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604cf6ff4453936516addcbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-96-g96b1140178d95/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-96-g96b1140178d95/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604cf6ff4453936516add=
cbc
        failing since 119 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604cf6956ba7b012f5addd20

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-96-g96b1140178d95/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-96-g96b1140178d95/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604cf6956ba7b012f5add=
d21
        failing since 119 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604cf6ace104947ed7addcdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-96-g96b1140178d95/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.180=
-96-g96b1140178d95/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604cf6ace104947ed7add=
cde
        failing since 119 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
