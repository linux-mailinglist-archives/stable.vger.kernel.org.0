Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C82A2CE5A1
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 03:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgLDCVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 21:21:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbgLDCVW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 21:21:22 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBDEC061A4F
        for <stable@vger.kernel.org>; Thu,  3 Dec 2020 18:20:42 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id l23so2284163pjg.1
        for <stable@vger.kernel.org>; Thu, 03 Dec 2020 18:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=b6juGMnwJWSjKhjEFkuyZV/KFmOJkMkIPyWpBb8W7gs=;
        b=WmhzjGy+r3Qq3qD23KG1NLOwLZRfOyEW+FSRprQVgty+/29h3WDRt4TDKJmOx86Qdi
         7ZuskSJfWk6aUyEd+k1SfeEpNXo2dd1T/yZMoNRlt7KyD3kTPZiQnJYIjPBF/GSzy1K7
         u5jhd5OqETnn/YXuo3GI/x0Cdc6rhbm6XH1pNA8dxKynTehLiXohwmu3PiebH4KTa+Kz
         P1Ge8t0EHYbUKduY0IplavCeYYAPre5R1AVhZbVGjGVUJxe0clZxdjNHzch8Q/ARuvTu
         OYxMpnfjlGMUO0QELVD/ErGSRmimjHi6GlXOP9fH0qXyyWLC3A7UzK6V9u/9gntqcZFu
         Kj4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=b6juGMnwJWSjKhjEFkuyZV/KFmOJkMkIPyWpBb8W7gs=;
        b=NYSb0e9876+EaWrZwZWv2+7dUYQkIHqcGPxCosuVhlddrJy8NYf93iKww/4pQa1kps
         2TWxebDOdo7hEGRu+3deQugfdUXB4C+QXY+IDFx++hrUI/1THq5Mq5khF65YHKWS9Z/z
         BFwIrgfHfFYnQDIoGUD0RaXTs5JgLtJQr0dv8KEem7DNYKD7CDIoTjM3V6h39256h+CJ
         sdAaMzgvyDWGZxticB4HAn2ceRDVJ7gBhXH6i6Q+zloDOR/GXTnDmTdx6uleGaOrgzYQ
         qILzlnszskCMd0xUGlo+N6a2tMQUWBM7hU89gLTW/wjMBHvxM3OsA/3PRjifCbgQ/7Nv
         fkAw==
X-Gm-Message-State: AOAM533TmrtbYGShLFwfIusWPVSeYzLLJjWuHbI++5Dgdd+4Gy94PzuM
        ExwMimhLWOiSgkzPrFumpZMQY/G8aOmbXg==
X-Google-Smtp-Source: ABdhPJx6RmWFtKsH6oVLaE+eyYB3KRz6zRWFF2S5NqPiMkmdWi2qHv8N1Y+KAk/wyD7lVpUAhZ2WVA==
X-Received: by 2002:a17:902:8e86:b029:d9:e12a:8888 with SMTP id bg6-20020a1709028e86b02900d9e12a8888mr1746156plb.51.1607048441397;
        Thu, 03 Dec 2020 18:20:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s30sm2353320pgl.39.2020.12.03.18.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 18:20:40 -0800 (PST)
Message-ID: <5fc99cf8.1c69fb81.e9c1a.5f0e@mx.google.com>
Date:   Thu, 03 Dec 2020 18:20:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.247-4-gef81364d5eda
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 127 runs,
 13 regressions (v4.4.247-4-gef81364d5eda)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 127 runs, 13 regressions (v4.4.247-4-gef81364=
d5eda)

Regressions Summary
-------------------

platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
beagle-xm           | arm  | lab-baylibre    | gcc-8    | omap2plus_defconf=
ig | 2          =

panda               | arm  | lab-collabora   | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.247-4-gef81364d5eda/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.247-4-gef81364d5eda
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ef81364d5eda82e4bf7cc418a70a5c95efaf230e =



Test Regressions
---------------- =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
beagle-xm           | arm  | lab-baylibre    | gcc-8    | omap2plus_defconf=
ig | 2          =


  Details:     https://kernelci.org/test/plan/id/5fc96408d6ba9b9e2cc94ccb

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-gef81364d5eda/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-gef81364d5eda/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fc96408d6ba9b9e=
2cc94cce
        new failure (last pass: v4.4.247-4-g656b68158912a)
        1 lines

    2020-12-03 22:15:50.528000+00:00  Connected to omap3-beagle-xm console =
[channel connected] (~$quit to exit)
    2020-12-03 22:15:50.529000+00:00  (user:) is already connected
    2020-12-03 22:15:50.529000+00:00  (user:khilman) is already connected
    2020-12-03 22:15:50.529000+00:00  (user:) is already connected
    2020-12-03 22:15:50.530000+00:00  (user:) is already connected
    2020-12-03 22:15:50.530000+00:00  (user:) is already connected
    2020-12-03 22:15:50.530000+00:00  (user:) is already connected
    2020-12-03 22:15:50.531000+00:00  (user:) is already connected
    2020-12-03 22:15:50.531000+00:00  (user:) is already connected
    2020-12-03 22:15:50.531000+00:00  (user:) is already connected =

    ... (476 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fc96408d6ba9b9=
e2cc94cd0
        new failure (last pass: v4.4.247-4-g656b68158912a)
        28 lines

    2020-12-03 22:17:39.443000+00:00  kern  :emerg : Stack: (0xcb92dd10 to =
0xcb92e000)
    2020-12-03 22:17:39.451000+00:00  kern  :emerg : dd00:                 =
                    bf02b83c bf010b84 cba56c10 bf02b8c8
    2020-12-03 22:17:39.460000+00:00  kern  :emerg : dd20: cba56c10 bf1f70a=
8 00000002 cb9ae010 cba56c10 bf246b54 cbc0a6f0 cbc0a6f0
    2020-12-03 22:17:39.468000+00:00  kern  :emerg : dd40: 00000000 0000000=
0 ce226930 c01fb3c4 ce226930 ce226930 c0857d24 00000001
    2020-12-03 22:17:39.476000+00:00  kern  :emerg : dd60: ce226930 cbc0a6f=
0 cbc0a7b0 00000000 ce226930 c0857d24 00000001 c09612c0
    2020-12-03 22:17:39.484000+00:00  kern  :emerg : dd80: ffffffed bf24afc=
8 fffffdfb 00000027 00000001 c00ce2b4 bf24b148 c0407354
    2020-12-03 22:17:39.493000+00:00  kern  :emerg : dda0: c09612c0 c120ca3=
0 bf24afc8 00000000 00000027 c0405828 c09612c0 c09612f4
    2020-12-03 22:17:39.501000+00:00  kern  :emerg : ddc0: bf24afc8 0000000=
0 00000000 c04059d0 00000000 bf24afc8 c0405944 c0403cf4
    2020-12-03 22:17:39.509000+00:00  kern  :emerg : dde0: ce0c38a4 ce22091=
0 bf24afc8 cbcc3540 c09dbb68 c0404e40 bf249b50 c095e460
    2020-12-03 22:17:39.517000+00:00  kern  :emerg : de00: cbbd57c0 bf24afc=
8 c095e460 cbbd57c0 bf24e000 c0406408 c095e460 c095e460 =

    ... (16 line(s) more)  =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
panda               | arm  | lab-collabora   | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc963ee3e5d76b783c94cba

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-gef81364d5eda/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-gef81364d5eda/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fc963ee3e5d76b=
783c94cbf
        new failure (last pass: v4.4.247-4-ga92d60286ae0)
        2 lines =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc9630534f9693d1dc94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-gef81364d5eda/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-gef81364d5eda/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc9630534f9693d1dc94=
cc3
        failing since 20 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc9676b0479e1aebbc94cd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-gef81364d5eda/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-gef81364d5eda/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc9676b0479e1aebbc94=
cd1
        failing since 20 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc962edbdb5d7666fc94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-gef81364d5eda/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-gef81364d5eda/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc962edbdb5d7666fc94=
cba
        failing since 20 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc962e4c209e3060ec94ce6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-gef81364d5eda/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-gef81364d5eda/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc962e4c209e3060ec94=
ce7
        failing since 20 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc962f75aae73c156c94cd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-gef81364d5eda/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-gef81364d5eda/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc962f75aae73c156c94=
cd8
        failing since 20 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc962efbdb5d7666fc94cc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-gef81364d5eda/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-gef81364d5eda/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc962efbdb5d7666fc94=
cc6
        failing since 20 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc9672ada955d1306c94cd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-gef81364d5eda/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-gef81364d5eda/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc9672ada955d1306c94=
cd2
        failing since 20 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc962e8c209e3060ec94cee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-gef81364d5eda/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-gef81364d5eda/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc962e8c209e3060ec94=
cef
        failing since 20 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc962e6c209e3060ec94ceb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-gef81364d5eda/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-gef81364d5eda/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc962e6c209e3060ec94=
cec
        failing since 20 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc962f6ca3505ce5dc94cd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-gef81364d5eda/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.247-4=
-gef81364d5eda/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc962f6ca3505ce5dc94=
cd7
        failing since 20 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =20
