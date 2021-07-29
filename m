Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790833DABD1
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 21:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbhG2TYV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 15:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbhG2TYV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 15:24:21 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7406C0613C1
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 12:24:17 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id ca5so11674156pjb.5
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 12:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Lf/89ngVKc3XZPDwnNhpCv0Pckyhdkf/3a+vWKihhS4=;
        b=f6fL9TiF3vJ6EnvZ2PzpJMA7m6FcTLuDsSaEb8U2EA8qERdMjltulzKA4vsPyOTEmb
         eIs/TAjIM0bt6K1Wn+mDIuSjJmc9ecPRf08wqgFXcL+0Kn/sl3FA2bnW8jGQKEN1Byxw
         bcIwviiB1eSjn+p6LnHvD+d59JR2dCty9iHWX+FsJhAnu+QBzd404QNdQOjQPNnVma2B
         xbbr/dev2kOOPNsOxeUohG672YT9y+DIUFbMlu1Yztgg6zzOQL1YgX3wpCuOFE3o9Cfw
         Jmey9vZwYkk+t7A4G9tHpt6oln61olZju1DTc9MavkjPLBMdgIn0QHWkjBSnvgYoEQYo
         6IxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Lf/89ngVKc3XZPDwnNhpCv0Pckyhdkf/3a+vWKihhS4=;
        b=TYseRKV4mK1iORIbl1rVdlGS72H1fHAFAsK4PrpWUHs0MZYM+Vme516PGGD1vaTrU3
         uk7o6yK91ogdulW9mPGuB8P2MC7S1QNElcbaD67DnMm0YteLnEI70psoDf3UPoKqUfyd
         JmIcuVkehlfZiBUs3k4fI/JEFx8rpVdxlLwl8l9ddbmM6xA0lbbDrBnmxnoHv72Pmucv
         X2F2Vm9FEbX7ZVwt+L3NlUFN1BfzFDDIHNnsHU2ZlOnkFIC2Do3pI8dnmcnTnK24YU7P
         FQK4Oer/tnyiTcuO3wFOSyDqqxCU78Z1fW1AQoBWDUc9FuzFoS51QVbHen8Swg3w1zei
         Fc4w==
X-Gm-Message-State: AOAM532m2AshjIyNpeoGVUQHuGmMcYQli8WhKnIXZ0VOJlVZJJHRF1nd
        v+F5tUWdbOfTKImJDQm3Z6QrXqcKHRXeLbAq
X-Google-Smtp-Source: ABdhPJxVTDG4WhS0zO7Ip1KVHFiGrpnSwuZJ9mpPTfjvOvKToFeHi83/GpnqKj3a/PoH3tbg9de+KA==
X-Received: by 2002:a17:90b:4a4d:: with SMTP id lb13mr16435203pjb.221.1627586657216;
        Thu, 29 Jul 2021 12:24:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y12sm1877417pgk.7.2021.07.29.12.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 12:24:16 -0700 (PDT)
Message-ID: <61030060.1c69fb81.eace3.5964@mx.google.com>
Date:   Thu, 29 Jul 2021 12:24:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.277-10-g3def64b8a44b
Subject: stable-rc/queue/4.4 baseline: 86 runs,
 8 regressions (v4.4.277-10-g3def64b8a44b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 86 runs, 8 regressions (v4.4.277-10-g3def64b8=
a44b)

Regressions Summary
-------------------

platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
beagle-xm           | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig=
 | 2          =

qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.277-10-g3def64b8a44b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.277-10-g3def64b8a44b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3def64b8a44b332ccf343eeb63d028b79a7d8601 =



Test Regressions
---------------- =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
beagle-xm           | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig=
 | 2          =


  Details:     https://kernelci.org/test/plan/id/6102cebf76ee237ab35018dc

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
0-g3def64b8a44b/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
0-g3def64b8a44b/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/6102cebf76ee237a=
b35018e2
        new failure (last pass: v4.4.276-46-g56094b963ae9)
        1 lines

    2021-07-29T15:52:14.606214  / #
    2021-07-29T15:52:14.606894   #
    2021-07-29T15:52:14.709750  / # #
    2021-07-29T15:52:14.710275  =

    2021-07-29T15:52:14.811506  / # #export SHELL=3D/bin/sh
    2021-07-29T15:52:14.811887  =

    2021-07-29T15:52:14.912768  / # export SHELL=3D/bin/sh. /lava-620640/en=
vironment
    2021-07-29T15:52:14.913125  =

    2021-07-29T15:52:15.014267  / # . /lava-620640/environment/lava-620640/=
bin/lava-test-runner /lava-620640/0
    2021-07-29T15:52:15.015182   =

    ... (10 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6102cebf76ee237=
ab35018e4
        new failure (last pass: v4.4.276-46-g56094b963ae9)
        28 lines

    2021-07-29T15:52:15.478227  [   50.124664] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-07-29T15:52:15.530225  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-07-29T15:52:15.536243  kern  :emerg : Process udevd (pid: 112, sta=
ck limit =3D 0xcb97e218)
    2021-07-29T15:52:15.540293  kern  :emerg : Stack: (0xcb97fd10 to 0xcb98=
0000)
    2021-07-29T15:52:15.548302  kern  :emerg : fd00:                       =
              bf02b83c bf010b84 cbb33a10 bf02b8c8   =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6102ce2576d92607045018e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
0-g3def64b8a44b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
0-g3def64b8a44b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6102ce2576d9260704501=
8e1
        failing since 257 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6102ce37381def33345018ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
0-g3def64b8a44b/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
0-g3def64b8a44b/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6102ce37381def3334501=
8ed
        failing since 257 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6102d54766d2dc7a6a5018cd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
0-g3def64b8a44b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
0-g3def64b8a44b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6102d54766d2dc7a6a501=
8ce
        failing since 257 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6102ce2676d92607045018e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
0-g3def64b8a44b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
0-g3def64b8a44b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6102ce2676d9260704501=
8e7
        failing since 257 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6102ce4168b28967785018cc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
0-g3def64b8a44b/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
0-g3def64b8a44b/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6102ce4168b2896778501=
8cd
        failing since 257 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6102d59c8518a3f5755018db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
0-g3def64b8a44b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
0-g3def64b8a44b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6102d59c8518a3f575501=
8dc
        failing since 257 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =20
