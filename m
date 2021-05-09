Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 187823775F0
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 10:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhEIIki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 04:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbhEIIki (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 04:40:38 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2953C061573
        for <stable@vger.kernel.org>; Sun,  9 May 2021 01:39:33 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id l10-20020a17090a850ab0290155b06f6267so8411298pjn.5
        for <stable@vger.kernel.org>; Sun, 09 May 2021 01:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+l6ieyJttUkmhv2EBxdA/4hzN2CizXK3oK1//3jwlEg=;
        b=mLiHBw8/WvXtaeYh6007IWgMEvAbYy6QIsCd/9t8dAcAQuI4KKmRKMiW1VXn9it5su
         TmPsofpeDBV5fpAFfwD5QUP1mw2C6tsOKiIg5MDVqwHXicG1BbCXdsJ85wdc/VTYJcj2
         4yPoE3EMcrfKPaSXLAUhek3ejmAFYcXw/N3a9SyvM1hrIWbHSSiJzk2oDovHYstI8O+T
         3JTqpdx4F/EsDgajtCh3yTNU/Cs+u8+fBFHETEdzigmUCRR6dCet1sUwL5tpYOvg5V9L
         EzOE0n6+9OmJnOneC/O3iRY13dAPCWIw3sj24/JOAOK1RuQG5yT8v24oTSQeqIngeGvT
         u7Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+l6ieyJttUkmhv2EBxdA/4hzN2CizXK3oK1//3jwlEg=;
        b=C6PyC3eP35x44mudgyoiwvJD01ES6v9c+YXLZRqLU/lmh/WnJT1ieYxgLycAfRqziV
         xiF/1q2JpAAoelHkv/yoTwKTFEYnnCppIMsnDrK8rdeoAF1txcpUAtF8qM8bFRoLbN4F
         dZ7yFXjxoGVfz8gq+2tf36XzybVUoAFhve0Nb1THBjBO/H+jY53MWpeC8DLgmGn8aohP
         wmrP+LBH9yaJsF5fbSYpF8oxRoc7Sbo///XU2df9DYpVsLKNbiJgGtxdt3aW4NXmmTKN
         X7JUyjdBhiOR5uTMW08OXrW+Zqin6R5Kxn0qGzGcY7eeANIxt8wJblj8fYOMC7vIbJN3
         kOSQ==
X-Gm-Message-State: AOAM533M4cM4ZCMxaDkpSDsX7iYXK88m8Wb2jnaOUefzUc2U0DmTk27g
        Bwd/6zqTc99XyJDDRQsxFGs9ZsZU3XEboPtS
X-Google-Smtp-Source: ABdhPJxiWxV7bpmQ0YoGIk8tkPm06h0tD48LDrghGj7xAyX/6nTg60Vt6ZqSx7eyRAkBKe1zPW9cug==
X-Received: by 2002:a17:90b:3684:: with SMTP id mj4mr34959524pjb.50.1620549573412;
        Sun, 09 May 2021 01:39:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w1sm8387650pgp.31.2021.05.09.01.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 01:39:33 -0700 (PDT)
Message-ID: <60979fc5.1c69fb81.23e2d.9c07@mx.google.com>
Date:   Sun, 09 May 2021 01:39:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.190-83-g35921575dce6b
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 135 runs,
 5 regressions (v4.19.190-83-g35921575dce6b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 135 runs, 5 regressions (v4.19.190-83-g35921=
575dce6b)

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
nel/v4.19.190-83-g35921575dce6b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.190-83-g35921575dce6b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      35921575dce6b20830f79f30804b84529b314408 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60976b72333bb0c8c36f5467

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-83-g35921575dce6b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-83-g35921575dce6b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60976b72333bb0c8c36f5=
468
        failing since 176 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60976b74333bb0c8c36f546a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-83-g35921575dce6b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-83-g35921575dce6b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60976b74333bb0c8c36f5=
46b
        failing since 176 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60976b6ed7fc5eebc06f5476

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-83-g35921575dce6b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-83-g35921575dce6b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60976b6ed7fc5eebc06f5=
477
        failing since 176 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60976c9261985f83436f547c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-83-g35921575dce6b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-83-g35921575dce6b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60976c9261985f83436f5=
47d
        failing since 176 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60976b1fedde0e8ad06f5468

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-83-g35921575dce6b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-83-g35921575dce6b/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60976b1fedde0e8ad06f5=
469
        failing since 176 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
