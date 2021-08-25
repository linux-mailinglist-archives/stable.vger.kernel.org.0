Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E44FF3F6C98
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 02:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236157AbhHYA0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 20:26:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234259AbhHYA0N (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 20:26:13 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A3BC061757
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 17:25:28 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d17so13259208plr.12
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 17:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=i6aZ+kAAV6rCFDIPWwnpItUn6Bi4nDb7cVQ1/zjaHkY=;
        b=YE9zpA1gRtxGkyRRUUHzAj9E+YqbQ2n4u2r+FgJVxjrpWsjmYQdRBbx3NJ4G5iBZCX
         gu15h1f8eueBCczH4nGxISafW+pL5pBRswet3OSh2EB8kTCo/fil0at1QYMavOqlDm8x
         qO8BMG9qbxWJcdtFtqVKkIPd4zhX1PZGTXmR/PgxENXM4C4rN4PK9tHGNDyAQ09KdCFR
         AawM4BOKt4evR2WRZYCNvy/+B8gRuF8gOyZiAmssOJ0hqUBvMzG0p791GpmdTZmJtaJe
         i9MhHaD/4fm5q1OEQQdJIQvykM+l41sYpC4FxI5kgXnjcNOZOdMuJzY41W1l0M4TYEoN
         DJaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=i6aZ+kAAV6rCFDIPWwnpItUn6Bi4nDb7cVQ1/zjaHkY=;
        b=ckllgR+0n+FNM02kFmz3bNt7aWn1VJxm2oV6VZzPtfON/dCdcwLZSznZbAQO0JvRxd
         6GHYb+5yONTEmFmo3GYou0ZtHVYcbhEO8/4TjNtrLTocRbOvv3Iu48qVyibslyKrc5xW
         hOJ4x9dqkawFKjbCLw6bxkNWI6+Hdkqdlhj9nBLNm18mKCEYxGaTVSF2QjCTxfERgnOk
         H8QP2mJxraXZsl9uzrRvC/tpGybHakJ4bS+kC730Qjeph+XY/arpVAUcyi+mG6ZwpKhS
         Upx8gcjvjrBi/WDc+cX6TzQ6pVB6YBMRumGG4bk9DjQwvW+9KlzHRzb9PIOH0ZOOwmMf
         pl9w==
X-Gm-Message-State: AOAM5337iZfnGwnSfoApRbFdgt2snF5DmXEkQUGCIP62qLUn5819fqP6
        hh/f4uAmE6rHUjHS4Oi+lZyk8KHL8RaIlZBy
X-Google-Smtp-Source: ABdhPJxxVicfdPEhx7PD9Vt2BLzrIa2rXSJDQ1Vp3ePB7OtjFu26r/0iAom/PHoxiaacYtfiNnM/QA==
X-Received: by 2002:a17:902:9a03:b029:12d:72e2:f7a1 with SMTP id v3-20020a1709029a03b029012d72e2f7a1mr35057503plp.49.1629851127541;
        Tue, 24 Aug 2021 17:25:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 138sm14750478pfz.187.2021.08.24.17.25.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 17:25:27 -0700 (PDT)
Message-ID: <61258df7.1c69fb81.cc905.7cc2@mx.google.com>
Date:   Tue, 24 Aug 2021 17:25:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.281-31-ga11850845e93
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 104 runs,
 11 regressions (v4.4.281-31-ga11850845e93)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 104 runs, 11 regressions (v4.4.281-31-ga118=
50845e93)

Regressions Summary
-------------------

platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
beagle-xm           | arm  | lab-baylibre    | gcc-8    | omap2plus_defconf=
ig | 2          =

dove-cubox          | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.281-31-ga11850845e93/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.281-31-ga11850845e93
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a11850845e9394a250678b2ec8b714825343f776 =



Test Regressions
---------------- =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
beagle-xm           | arm  | lab-baylibre    | gcc-8    | omap2plus_defconf=
ig | 2          =


  Details:     https://kernelci.org/test/plan/id/6125546d9002d798aa8e2cb9

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.281=
-31-ga11850845e93/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.281=
-31-ga11850845e93/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/6125546d9002d798=
aa8e2cbf
        new failure (last pass: v4.4.281)
        1 lines

    2021-08-24T20:19:37.807170  / #
    2021-08-24T20:19:37.807840   #
    2021-08-24T20:19:37.910678  / # #
    2021-08-24T20:19:37.911196  =

    2021-08-24T20:19:38.012430  / # #export SHELL=3D/bin/sh
    2021-08-24T20:19:38.012782  =

    2021-08-24T20:19:38.113908  / # export SHELL=3D/bin/sh. /lava-731661/en=
vironment
    2021-08-24T20:19:38.114212  =

    2021-08-24T20:19:38.215183  / # . /lava-731661/environment/lava-731661/=
bin/lava-test-runner /lava-731661/0
    2021-08-24T20:19:38.216423   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6125546d9002d79=
8aa8e2cc1
        new failure (last pass: v4.4.281)
        28 lines

    2021-08-24T20:19:38.730696  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-08-24T20:19:38.736572  kern  :emerg : Process udevd (pid: 109, sta=
ck limit =3D 0xcb954218)
    2021-08-24T20:19:38.741019  kern  :emerg : Stack: (0xcb955d10 to 0xcb95=
6000)
    2021-08-24T20:19:38.749315  kern  :emerg : 5d00:                       =
              bf02b83c bf010b84 cb8e6010 bf02b8c8   =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
dove-cubox          | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/612555da14b5c1748a8e2c7d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.281=
-31-ga11850845e93/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dov=
e-cubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.281=
-31-ga11850845e93/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dov=
e-cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612555da14b5c1748a8e2=
c7e
        failing since 6 days (last pass: v4.4.279-38-g82678f26470c, first f=
ail: v4.4.281-12-g24f70255b87a) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/6125565734d980a0d58e2c9d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.281=
-31-ga11850845e93/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.281=
-31-ga11850845e93/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6125565734d980a0d58e2=
c9e
        failing since 283 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/6125566c34d980a0d58e2cb6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.281=
-31-ga11850845e93/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.281=
-31-ga11850845e93/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6125566c34d980a0d58e2=
cb7
        failing since 283 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/6125566434d980a0d58e2cae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.281=
-31-ga11850845e93/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.281=
-31-ga11850845e93/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6125566434d980a0d58e2=
caf
        failing since 283 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/61255712df620d1b6b8e2c7b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.281=
-31-ga11850845e93/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.281=
-31-ga11850845e93/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61255712df620d1b6b8e2=
c7c
        failing since 283 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/6125565934d980a0d58e2ca0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.281=
-31-ga11850845e93/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.281=
-31-ga11850845e93/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6125565934d980a0d58e2=
ca1
        failing since 283 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/612556787476c99d7c8e2c89

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.281=
-31-ga11850845e93/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.281=
-31-ga11850845e93/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612556787476c99d7c8e2=
c8a
        failing since 283 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/6125568c064f02b32a8e2c8f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.281=
-31-ga11850845e93/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.281=
-31-ga11850845e93/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6125568c064f02b32a8e2=
c90
        failing since 283 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/612557914aa23a5fd18e2c7c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.281=
-31-ga11850845e93/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.281=
-31-ga11850845e93/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612557914aa23a5fd18e2=
c7d
        failing since 283 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =20
