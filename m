Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4A6342CF80
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 02:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229569AbhJNAY2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 20:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbhJNAY1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 20:24:27 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D4DC061570
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 17:22:23 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id m21so3862308pgu.13
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 17:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BpBif/h7FTHDJ5ad4rGKXDQcFFOJNKgAlmBEnsCDwo0=;
        b=K+pTS2yJRp+mTL8mKmyGuUBpuQeFwfg0Y2XgBpFF4MA+uBzTkDvgjVkNK/yYF9bKGi
         L1L1A7zv19TEDGvtA78v1/sS9y/Aoo4evw4W/DAug2iqV/qN8BmPGE4FpNVIfq59QQdo
         31mSAih0BLAah0dZ0qQUWwBw9xCZPJYl0Jwp3w3ZtI+67zos81ZEsgvxx3f748/AEdvm
         DQQXmmwGKqwTWjTrXExiMAwrM4WWM2xwity9npYNITG+EiOmgFW+3wrP1Dl89jJy3s66
         IwWgtfMXUZLABLfAdU5XkP3EINZ5S9LJQLYMMaoPOVJoMGqBU96V2SFYXArhPia/kee2
         vVLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BpBif/h7FTHDJ5ad4rGKXDQcFFOJNKgAlmBEnsCDwo0=;
        b=u8OcP748ekzIMB1IrFoFq7GXXD9lfWQnNTwC60z0IQly7CpeBOdl5nPndU51RkA8qb
         LQO6Xh79ZGS2HlfN+PKlFSFDjSlM1IzMTP9k3E+BONWohmMTW8kXyY+BX2nirb3Neybc
         NME4ApZJzcMg0S2pIsYTa1ArJEwb7luXu10g3ErwUcRB2xJJDeMoZvUi4Vf5Q8Eb1pbk
         ISG/90cMkxiN2ACX1OVHA1xFkoMLIMFeDbHrzsksWkyVEDU7lU5BuKSv3b0rYN1fWc5m
         8mfABxxS5DfZQ80W3IDJ/sRrdRTySmPhVdGrfxj01fdZh8ihBmRR/LaWZ6zJCY+i+b1r
         HMWA==
X-Gm-Message-State: AOAM533rzyrvCJdtZawMWv1FU1tG/9MMgiRRyIkzrt75DVsM3qmPR2T7
        JcjQMO+MyoGBmbw4YPe2klatquvwXElUCSXvaKM=
X-Google-Smtp-Source: ABdhPJwfLplBA/7qyKv6nB1j8OIgwFPTp+G0KjDiIg5YyvOTin4PDrqdVLhOHTVufHiT8Eo+cmVH4g==
X-Received: by 2002:a63:b04c:: with SMTP id z12mr1792444pgo.371.1634170943035;
        Wed, 13 Oct 2021 17:22:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z6sm617619pjr.17.2021.10.13.17.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 17:22:22 -0700 (PDT)
Message-ID: <6167783e.1c69fb81.2a6f.2eeb@mx.google.com>
Date:   Wed, 13 Oct 2021 17:22:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.288-18-ga8ec20dcebd9
Subject: stable-rc/queue/4.4 baseline: 61 runs,
 9 regressions (v4.4.288-18-ga8ec20dcebd9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 61 runs, 9 regressions (v4.4.288-18-ga8ec20dc=
ebd9)

Regressions Summary
-------------------

platform            | arch   | lab          | compiler | defconfig         =
  | regressions
--------------------+--------+--------------+----------+-------------------=
--+------------
beagle-xm           | arm    | lab-baylibre | gcc-8    | omap2plus_defconfi=
g | 2          =

d2500cc             | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig  =
  | 1          =

qemu_arm-virt-gicv2 | arm    | lab-baylibre | gcc-8    | multi_v7_defconfig=
  | 1          =

qemu_arm-virt-gicv2 | arm    | lab-broonie  | gcc-8    | multi_v7_defconfig=
  | 1          =

qemu_arm-virt-gicv2 | arm    | lab-cip      | gcc-8    | multi_v7_defconfig=
  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-baylibre | gcc-8    | multi_v7_defconfig=
  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-broonie  | gcc-8    | multi_v7_defconfig=
  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-cip      | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.288-18-ga8ec20dcebd9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.288-18-ga8ec20dcebd9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a8ec20dcebd964738f470f5fddd9e33ed86a8360 =



Test Regressions
---------------- =



platform            | arch   | lab          | compiler | defconfig         =
  | regressions
--------------------+--------+--------------+----------+-------------------=
--+------------
beagle-xm           | arm    | lab-baylibre | gcc-8    | omap2plus_defconfi=
g | 2          =


  Details:     https://kernelci.org/test/plan/id/61673df00d8c60147d08faab

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-ga8ec20dcebd9/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-ga8ec20dcebd9/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61673df00d8c6014=
7d08faae
        new failure (last pass: v4.4.288-11-geb29710977ab)
        1 lines

    2021-10-13T20:13:21.652652  / #
    2021-10-13T20:13:21.654083   #
    2021-10-13T20:13:21.758086  / # #
    2021-10-13T20:13:21.758830  =

    2021-10-13T20:13:21.860256  / # #export SHELL=3D/bin/sh
    2021-10-13T20:13:21.860732  =

    2021-10-13T20:13:21.962057  / # export SHELL=3D/bin/sh. /lava-941733/en=
vironment
    2021-10-13T20:13:21.962495  =

    2021-10-13T20:13:22.063732  / # . /lava-941733/environment/lava-941733/=
bin/lava-test-runner /lava-941733/0
    2021-10-13T20:13:22.065055   =

    ... (10 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61673df00d8c601=
47d08fab0
        new failure (last pass: v4.4.288-11-geb29710977ab)
        28 lines

    2021-10-13T20:13:22.595268  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-10-13T20:13:22.601118  kern  :emerg : Process udevd (pid: 108, sta=
ck limit =3D 0xcb940218)
    2021-10-13T20:13:22.605448  kern  :emerg : Stack: (0xcb941d10 to 0xcb94=
2000)
    2021-10-13T20:13:22.613614  kern  :emerg : 1d00:                       =
              bf02b83c bf010b84 cba52810 bf02b8c8
    2021-10-13T20:13:22.626759  kern  :emerg : 1d20: cba52810 bf26a0a8 0000=
0002 cb[   49.519805] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Df=
ail UNITS=3Dlines MEASUREMENT=3D28>   =

 =



platform            | arch   | lab          | compiler | defconfig         =
  | regressions
--------------------+--------+--------------+----------+-------------------=
--+------------
d2500cc             | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig  =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/61673ed5b215e0cc9008fade

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-ga8ec20dcebd9/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-ga8ec20dcebd9/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61673ed5b215e0c=
c9008fae3
        new failure (last pass: v4.4.288-11-geb29710977ab)
        1 lines

    2021-10-13T20:17:20.487491  kern  :emerg : do_IRQ: 0.236 No irq handler=
 for vector
    2021-10-13T20:17:20.498930  [   14.235789] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2021-10-13T20:17:20.499324  + set +x   =

 =



platform            | arch   | lab          | compiler | defconfig         =
  | regressions
--------------------+--------+--------------+----------+-------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6167400085c213b3af08fab7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-ga8ec20dcebd9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-ga8ec20dcebd9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6167400085c213b3af08f=
ab8
        failing since 334 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab          | compiler | defconfig         =
  | regressions
--------------------+--------+--------------+----------+-------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-broonie  | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6167404100d0a5f68c08fac1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-ga8ec20dcebd9/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-ga8ec20dcebd9/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6167404100d0a5f68c08f=
ac2
        failing since 334 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab          | compiler | defconfig         =
  | regressions
--------------------+--------+--------------+----------+-------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-cip      | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/61674019ae3244108c08fab2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-ga8ec20dcebd9/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-ga8ec20dcebd9/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61674019ae3244108c08f=
ab3
        failing since 334 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab          | compiler | defconfig         =
  | regressions
--------------------+--------+--------------+----------+-------------------=
--+------------
qemu_arm-virt-gicv3 | arm    | lab-baylibre | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/61674028ae3244108c08fac2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-ga8ec20dcebd9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-ga8ec20dcebd9/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61674028ae3244108c08f=
ac3
        failing since 334 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab          | compiler | defconfig         =
  | regressions
--------------------+--------+--------------+----------+-------------------=
--+------------
qemu_arm-virt-gicv3 | arm    | lab-broonie  | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/616740e1ae6348ccc508faaf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-ga8ec20dcebd9/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-ga8ec20dcebd9/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616740e1ae6348ccc508f=
ab0
        failing since 334 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab          | compiler | defconfig         =
  | regressions
--------------------+--------+--------------+----------+-------------------=
--+------------
qemu_arm-virt-gicv3 | arm    | lab-cip      | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/616740a539da362f1a08faab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-ga8ec20dcebd9/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-1=
8-ga8ec20dcebd9/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616740a539da362f1a08f=
aac
        failing since 334 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =20
