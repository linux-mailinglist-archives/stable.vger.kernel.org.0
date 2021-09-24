Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E730C4171BE
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245047AbhIXM0L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244453AbhIXM0K (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 08:26:10 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0751C061574
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 05:24:37 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id y8so8750944pfa.7
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 05:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CxT4ZGZP8w6RJLU06vjzm+Hg2FdAYBMLykDAfZnUhbU=;
        b=Epj2HmK9q3fDiv28uwCj35+h9WpJ8+yljyZJVb5rYjX8RRvZZ/eCBa4sE7e4dlaUnD
         WZAKwM2WHlGkD7nH2J2bpi2qgWIg3LmbE0OtuBP3EsWKxhH5xP09sM4SiMWAb4oS1H2Z
         Iav02jvMZkSq36whrZX6cAhheLDioysbuDQuyHN4GgOvdtz4gvsV5LSChXbXTDGaqTIr
         qlrEGqGJ/omkYspryUDj4efsbhEo0nzgAuh3vtvPOVwHh8CtPTj8xtP8JbctK8dAjM0a
         tZr5lZLkUGqL0/OCrKiWjDAWhazrxgINInHvhXzZIsB+Tx6wOo+BjA7w6WEcSLtT2FWL
         Dm2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CxT4ZGZP8w6RJLU06vjzm+Hg2FdAYBMLykDAfZnUhbU=;
        b=YPfdFRLpooEn7WRAkCuajvOVrsK1zHLrTaPkF9QUzS71ufSsJp2bi1FE2iKBV7KpDo
         SNbWlCTfFB3GXLse2lc94okmBC8gwJ+4afr8bF3wjZL/Mmm1YJ72hC176z3pkyWlzhD2
         FDce0vxpxztR5FpOnvhPXUK4m/v22xPmfftzVnMLtUV+A1NPbSJPOHJG0TmumrtSBGZC
         BAT21ShNLtoe/Kiy9Glu8PnHrFAgO92hgMxGQHsihaymEnX+AM6dxH7uPUllnDXcnYFW
         bukVCDVAPT03kCPo2Aslumk3gbzZBWJEEYjJktPnx9ZB9guayBabaDEzhGrCQ/QzDzFH
         ZzLw==
X-Gm-Message-State: AOAM531piBAhrlawIVcxpvzyZSEmDoGs0HgaX3Gz26NWxv7hdqq0auR7
        qzeNWW5Yh3oUHxBIsOZX2Zzd0K2hhQmfEmiE
X-Google-Smtp-Source: ABdhPJxv7mFKLEE4Wig08wPC0mMfZrUlGVfm63PvJ/GJpl4RyoASy/XoW2KoEc8lvXKbp4Hqb5q7ng==
X-Received: by 2002:aa7:959a:0:b0:43b:adeb:ef58 with SMTP id z26-20020aa7959a000000b0043badebef58mr9727714pfj.19.1632486277211;
        Fri, 24 Sep 2021 05:24:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y17sm2461304pfa.113.2021.09.24.05.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 05:24:36 -0700 (PDT)
Message-ID: <614dc384.1c69fb81.a1b0b.7ec1@mx.google.com>
Date:   Fri, 24 Sep 2021 05:24:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.284-2-g63746d537575
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 66 runs,
 8 regressions (v4.4.284-2-g63746d537575)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 66 runs, 8 regressions (v4.4.284-2-g63746d537=
575)

Regressions Summary
-------------------

platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
beagle-xm           | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig =
| 2          =

qemu_arm-virt-gicv2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-broonie  | gcc-8    | multi_v7_defconfig  =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig  =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie  | gcc-8    | multi_v7_defconfig  =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.284-2-g63746d537575/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.284-2-g63746d537575
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      63746d537575756f21f91369c29084c826503313 =



Test Regressions
---------------- =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
beagle-xm           | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig =
| 2          =


  Details:     https://kernelci.org/test/plan/id/614d891486e8e1740d99a2da

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g63746d537575/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g63746d537575/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/614d891486e8e174=
0d99a2e0
        new failure (last pass: v4.4.284-2-g686162064cb8)
        1 lines

    2021-09-24T08:14:58.296575  =

    2021-09-24T08:14:58.400328  / # #
    2021-09-24T08:14:58.400837  =

    2021-09-24T08:14:58.502110  / # #export SHELL=3D/bin/sh
    2021-09-24T08:14:58.502426  =

    2021-09-24T08:14:58.603539  / # export SHELL=3D/bin/sh. /lava-883975/en=
vironment
    2021-09-24T08:14:58.603887  =

    2021-09-24T08:14:58.705093  / # . /lava-883975/environment/lava-883975/=
bin/lava-test-runner /lava-883975/0
    2021-09-24T08:14:58.706008  =

    2021-09-24T08:14:58.707260  / # /lava-883975/bin/lava-test-runner /lava=
-883975/0 =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/614d891486e8e17=
40d99a2e2
        new failure (last pass: v4.4.284-2-g686162064cb8)
        28 lines

    2021-09-24T08:14:59.170159  [   50.037414] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-09-24T08:14:59.222492  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-09-24T08:14:59.228456  kern  :emerg : Process udevd (pid: 110, sta=
ck limit =3D 0xcb95a218)
    2021-09-24T08:14:59.232833  kern  :emerg : Stack: (0xcb95bd10 to 0xcb95=
c000)
    2021-09-24T08:14:59.240791  kern  :emerg : bd00:                       =
              bf02b83c bf010b84 cb9cde10 bf02b8c8   =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/614d87af693b9fd51799a2f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g63746d537575/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g63746d537575/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614d87af693b9fd51799a=
2f6
        failing since 314 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie  | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/614d88674f925b8d0f99a2e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g63746d537575/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g63746d537575/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614d88674f925b8d0f99a=
2e3
        failing since 314 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/614d88076aeb31394399a2df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g63746d537575/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g63746d537575/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614d88076aeb31394399a=
2e0
        failing since 314 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/614d8786c695dafbc699a327

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g63746d537575/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g63746d537575/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614d8786c695dafbc699a=
328
        failing since 314 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie  | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/614d88662f4a36d41999a30c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g63746d537575/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g63746d537575/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614d88662f4a36d41999a=
30d
        failing since 314 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/614d87ce1e4187c17b99a2f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g63746d537575/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g63746d537575/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614d87ce1e4187c17b99a=
2fa
        failing since 314 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =20
