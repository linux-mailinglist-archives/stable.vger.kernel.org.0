Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E17E430BBC
	for <lists+stable@lfdr.de>; Sun, 17 Oct 2021 21:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344522AbhJQT3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Oct 2021 15:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344515AbhJQT3Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Oct 2021 15:29:16 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8645CC06161C
        for <stable@vger.kernel.org>; Sun, 17 Oct 2021 12:27:06 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id y1so9771302plk.10
        for <stable@vger.kernel.org>; Sun, 17 Oct 2021 12:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VsMRs/BBPuq/VNEj4lwzg2lx++KrtxKcQSEZvWucmss=;
        b=ZDrdeWfBUeCj7qGW5kgvDh291XIyvKRGURatdfKkBJUZwFLmlE0BkrgIKm4zDm0pXV
         8e+/akqQMoOI8aJI9mXW7XQ3FhlrsjrW6u99BUaxxqq0qc5v6J4vcQohIodlvhU1Y55D
         pZkr2GjVAFMoCZ+yFtYA2r2LdSvSAzHKYOnyQjsbLUe+lsFvWxqggR1KJXBwI6tktW8W
         LWZgJ4TI6RmA7tccVvKBV5c58dgQUOBiS9Qb68ld2BvFXJqQ6yKgTauUmWB0xenmPu/l
         fT4KFXdwkGAaDxcko0QkJAuracuXzGiYEdB5WIdGOjlB8HVUDmfCiGBnCdgr8xI+k95z
         J46A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VsMRs/BBPuq/VNEj4lwzg2lx++KrtxKcQSEZvWucmss=;
        b=YqImfpKZgkbQu1Dfx90VqzptqSWezZkCFXFV3juwusfxbsiCcWKr1Z6cyURiY+WfLq
         2OresHaVJKntRxhRCTWn6aoBJXaLX8uIHIZRZnsfiD2uR8alfjMnL5tbXW8HjlwxT7bo
         OLtwxNuKYdi/xKx5qSgAFw85sLq3x5BDkVNwFOsdKr7EqD2gYoHDItLHOmNyTHLCwq/E
         FrXneCLKmXxRPr5g4xCojr/DZ/LT8H32Tn4P/ds+L4oPll0T9zUVCIjb4FFQ9/1bMDU0
         EbXMs3jyupfXc6DTMMQmLzRwDSD/FDGfT9Fl/TF3BhdMnt0upYeUOPM0icjKVVjibx0Z
         NOzQ==
X-Gm-Message-State: AOAM530NzUEYsa3JRnP7jiztLVj8p549ynBWcLWkSSoptXy53C4czwqo
        xqFdmxQCziJMoYL4u3bJRiDyVvutGHGUVfRJ
X-Google-Smtp-Source: ABdhPJwLOE9nQ+YCZJ3cR4dutj+56Sto1gxcEYqMzebFzSGsYXSV5IPkxI+C1vnlWMgdIW4X0E+VPg==
X-Received: by 2002:a17:90b:1c09:: with SMTP id oc9mr16898986pjb.33.1634498825896;
        Sun, 17 Oct 2021 12:27:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q73sm11287145pfc.179.2021.10.17.12.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 12:27:05 -0700 (PDT)
Message-ID: <616c7909.1c69fb81.a8bca.fdca@mx.google.com>
Date:   Sun, 17 Oct 2021 12:27:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.4.289
X-Kernelci-Report-Type: test
Subject: stable/linux-4.4.y baseline: 71 runs, 9 regressions (v4.4.289)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y baseline: 71 runs, 9 regressions (v4.4.289)

Regressions Summary
-------------------

platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
beagle-xm           | arm  | lab-baylibre    | gcc-8    | omap2plus_defconf=
ig | 2          =

qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/=
v4.4.289/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.4.y
  Describe: v4.4.289
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      c67099a5bc53d1a24058ba5afe873f16cd290e16 =



Test Regressions
---------------- =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
beagle-xm           | arm  | lab-baylibre    | gcc-8    | omap2plus_defconf=
ig | 2          =


  Details:     https://kernelci.org/test/plan/id/616c44d492e43098913358e7

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.289/ar=
m/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.289/ar=
m/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/616c44d492e43098=
913358ea
        new failure (last pass: v4.4.288)
        1 lines

    2021-10-17T15:44:03.791124  / # #
    2021-10-17T15:44:03.791856  =

    2021-10-17T15:44:03.895043  / # #
    2021-10-17T15:44:03.895683  =

    2021-10-17T15:44:03.997060  / # #export SHELL=3D/bin/sh
    2021-10-17T15:44:03.997540  =

    2021-10-17T15:44:04.098666  / # export SHELL=3D/bin/sh. /lava-949985/en=
vironment
    2021-10-17T15:44:04.099006  =

    2021-10-17T15:44:04.200232  / # . /lava-949985/environment/lava-949985/=
bin/lava-test-runner /lava-949985/0
    2021-10-17T15:44:04.201566   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/616c44d492e4309=
8913358ec
        new failure (last pass: v4.4.288)
        28 lines

    2021-10-17T15:44:04.698427  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-10-17T15:44:04.704230  kern  :emerg : Process udevd (pid: 106, sta=
ck limit =3D 0xcb930218)
    2021-10-17T15:44:04.708615  kern  :emerg : Stack: (0xcb931d10 to 0xcb93=
2000)
    2021-10-17T15:44:04.716714  kern  :emerg : 1d00:                       =
              bf03883c bf01db84 cb957e10 bf0388c8
    2021-10-17T15:44:04.728540  kern  :emerg : 1d20: cb957e10 bf20[   49.99=
5208] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D28>   =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/616c3eff8ef9708bb633590c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.289/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.289/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616c3eff8ef9708bb6335=
90d
        failing since 329 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/616c3ff7b8dfafc54d3358e3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.289/ar=
m/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.289/ar=
m/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616c3ff7b8dfafc54d335=
8e4
        failing since 329 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/616c3ef4afe68a64283358e1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.289/ar=
m/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.289/ar=
m/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616c3ef4afe68a6428335=
8e2
        failing since 329 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/616c3efeafe68a64283358f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.289/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.289/ar=
m/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616c3efeafe68a6428335=
8f8
        failing since 329 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/616c3f43f1afe88ee23358f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.289/ar=
m/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.289/ar=
m/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616c3f43f1afe88ee2335=
8f5
        failing since 329 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/616c3f43c58c38e8483358fb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.289/ar=
m/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.289/ar=
m/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616c3f43c58c38e848335=
8fc
        failing since 329 days (last pass: v4.4.243, first fail: v4.4.245) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/616c3ef28ef9708bb63358ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.289/ar=
m/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.289/ar=
m/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616c3ef28ef9708bb6335=
8ee
        failing since 329 days (last pass: v4.4.243, first fail: v4.4.245) =

 =20
