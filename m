Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6AB32E0EA
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 05:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbhCEE7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 23:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhCEE7C (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 23:59:02 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD34AC061574
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 20:59:01 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id w18so1175663pfu.9
        for <stable@vger.kernel.org>; Thu, 04 Mar 2021 20:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fkNDeeH8nuaIrdz/CejFpuphgRcRBsmGnBdBIhfziAA=;
        b=uFi/mNscJovtLDcie6yo3vuqP4gCaGCc908uqAMvKiShEOC+tTAa/z51di2MrDjCTX
         p0BlqE9IkPr5RNVa2T0Ab+qlHhyBxGbwgcYfcfzctopWj7l7hPxhwLeureM4HX/HK6sN
         7GI/EE0CLHpd1eq0cJeWGSdaVCVJ+V5HhIRv6T3ak49XHcO0hVo01PzwqmB0yPYOr+Ee
         yj79Bl4K84MdF+EEwTtmrAqyYsD6SN5bkg+LDev/xx0/tX8nauyZIWSBbeA/TYcks+wr
         XfltZ5VqZ/BNBV8eaDZCBXy3KC2W+0E6dT39vSm6b+t4Zgh9EznWATsvzc4R6yA46B1A
         lOeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fkNDeeH8nuaIrdz/CejFpuphgRcRBsmGnBdBIhfziAA=;
        b=QLYwxpJGbhk8KQnfkkKdG9Ddf/P5dNt8BbRWRQCYIs24i9oMiQz4j/VkqQjTKWNm4K
         qFjfvUGMFIq6sbUwa6vfvpERdadVk1kqiIU8wUCGxFO5PkDSrJvsxHdMh01fn/Sn5LSo
         zltpP5GU0HZ4pGBgfAMv8Rfvg7fqawkDPpnAJb+3FGA4zgMGOMiiFwUPYhtsyRaGjP75
         yC8FJjQqawKwGlvEfGWst1DtR7tifEM8/t1uLJabOD8UbZee0rymhBtHZLxd8K8NXn9A
         2kJ4cL9LmwxSY5JVNj6QWI+Oj/QhXC/T1MisaRG/6kuHHHVqCCITcpQB/0akAXckZsFK
         IIsw==
X-Gm-Message-State: AOAM533VPKZR9hS7Xst3yNu+2roI8+s0bRov2vsysv1BVRJbVB/N6ALF
        78BNX0FM/2KnTT2ojvQQwzFIm7tJTxVnZxGd
X-Google-Smtp-Source: ABdhPJznmAKHl8TmlWq/XldvFyfO00RYuqZig62ctDunKnVVRcegvrKU+KxERyWVswFCeoSjNOPgiQ==
X-Received: by 2002:aa7:9843:0:b029:1ed:a151:306 with SMTP id n3-20020aa798430000b02901eda1510306mr7099727pfq.11.1614920341041;
        Thu, 04 Mar 2021 20:59:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b3sm836029pgd.48.2021.03.04.20.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 20:59:00 -0800 (PST)
Message-ID: <6041ba94.1c69fb81.8c2a0.368e@mx.google.com>
Date:   Thu, 04 Mar 2021 20:59:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.178-20-g343507cdf71e2
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 106 runs,
 5 regressions (v4.19.178-20-g343507cdf71e2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 106 runs, 5 regressions (v4.19.178-20-g34350=
7cdf71e2)

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
nel/v4.19.178-20-g343507cdf71e2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.178-20-g343507cdf71e2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      343507cdf71e21d856c8968c70776633efff316f =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604189b497924823c4addce3

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-20-g343507cdf71e2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-20-g343507cdf71e2/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/604189b59792482=
3c4addce8
        failing since 0 day (last pass: v4.19.178-16-gdaaebef7f79c0, first =
fail: v4.19.178-18-gecabdc57e1e82)
        2 lines

    2021-03-05 01:30:24.135000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-03-05 01:30:24.154000+00:00  <8>[   22.922515] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041adad7b4e68b9d4addcbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-20-g343507cdf71e2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-20-g343507cdf71e2/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041adad7b4e68b9d4add=
cbe
        failing since 111 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041853210580f48ebaddcce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-20-g343507cdf71e2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-20-g343507cdf71e2/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041853210580f48ebadd=
ccf
        failing since 111 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604184f96ca6b567d6addcdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-20-g343507cdf71e2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-20-g343507cdf71e2/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604184f96ca6b567d6add=
cde
        failing since 111 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604185048f023d5046addcd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-20-g343507cdf71e2/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.178=
-20-g343507cdf71e2/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604185048f023d5046add=
cd9
        failing since 111 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
