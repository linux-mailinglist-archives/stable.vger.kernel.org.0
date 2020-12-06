Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830812D0588
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 15:41:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgLFOlJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 09:41:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbgLFOlJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 09:41:09 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC97C0613D0
        for <stable@vger.kernel.org>; Sun,  6 Dec 2020 06:40:29 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id z12so5861500pjn.1
        for <stable@vger.kernel.org>; Sun, 06 Dec 2020 06:40:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SvA+4Lat7U07oc3634oI3O26UlcMoFGliHSN3nYjgZg=;
        b=UTdlz/QDaZwWw9KAiXvOkvRXmuitxczt0LK5pdj38724SIDOBBWqtHLYcbG0TjEU0o
         A3HOwmBFvUuKBxsmvwqz90EktubPFa+gckgvfsChu4A7YrkBJwt0VOo3yUxCPtV0qH2Q
         LOEYyzGCq+kCkug11L98UNhm7HCKR3QlmDDBA9bm9NK3MIhKu3Oj2rJLqEvT0jRbaOhw
         03wwUajWUALlIzb7wjymCP7LZ17xjOsihHol9ovx5KtsSRuj24kNFNoatIvePADzpM0v
         ih8DQNHBjEPFv7JiYp2i1e2G85iADst4fjXxVgPrZ6eDgq8B5aB4nB5Szrk4w1+CZR48
         RXIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SvA+4Lat7U07oc3634oI3O26UlcMoFGliHSN3nYjgZg=;
        b=EucVtPOg+sQfx6n3O6boqFSYe2XfPVLcHNlggt5Qkzy+XsmQjB22cQRMNE4B3sm8+m
         Cu1/6WP7DJEspWKTVcpDs9IGTutV1UfuKCXo8yDis13Ypx5eOvk768LAQdPIsVG6zq9e
         RI/n3vNzKDftF8gAWM7u3XAqRXUJJo6Wp2wbtEgkaOHPhi11K2lpAdGZKzZASBPwQp1g
         HSm5Uajt6JDQW6mu2/BNDiQjjJe0kJ7I2y8MNlkTM9kULWAoel6xj71ZwoGQNz2qN8gH
         ruejSP/ncQ5sWuSoqmOJlbnRl+XnLJ4WfJ2WvUMRs6V8HXYQhQl8f8hKZoz7Hyc8Hq15
         +ASQ==
X-Gm-Message-State: AOAM5303aom9a8q5/7G3luy891LxX6yWmIc3XJ32R699EvqFwPGvcE5D
        bBXC1zDcVfpAMYsHfhe+t0swJZ+0xFWr0Q==
X-Google-Smtp-Source: ABdhPJy43EnCFyEMcN+I0isj4Jtf2EOmNvPDo6gHSYMe1nQGDXpmO394ammPgNwz7MIXLimi6U7y6w==
X-Received: by 2002:a17:902:c215:b029:da:b079:b9a3 with SMTP id 21-20020a170902c215b02900dab079b9a3mr11773160pll.67.1607265628148;
        Sun, 06 Dec 2020 06:40:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n21sm11390086pfo.182.2020.12.06.06.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 06:40:27 -0800 (PST)
Message-ID: <5fcced5b.1c69fb81.b41b2.aa5d@mx.google.com>
Date:   Sun, 06 Dec 2020 06:40:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.210-20-gc32b9f7cbda7
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 153 runs,
 6 regressions (v4.14.210-20-gc32b9f7cbda7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 153 runs, 6 regressions (v4.14.210-20-gc32b9=
f7cbda7)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
imx6ul-pico-hobbit   | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defcon=
fig | 1          =

panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.210-20-gc32b9f7cbda7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.210-20-gc32b9f7cbda7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c32b9f7cbda70b05bc06d66bbdff0887fcdc9125 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
imx6ul-pico-hobbit   | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccba481ae11f46dbc94d24

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-20-gc32b9f7cbda7/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-20-gc32b9f7cbda7/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccba481ae11f46dbc94=
d25
        new failure (last pass: v4.14.210-7-g5c828e58d4a6) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccbaf90adeb86e71c94cff

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-20-gc32b9f7cbda7/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-20-gc32b9f7cbda7/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fccbaf90adeb86=
e71c94d04
        failing since 7 days (last pass: v4.14.209-11-ge2326a479d95, first =
fail: v4.14.209-14-gefcf305b1a7e8)
        2 lines =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccb896da9cc064dcc94ced

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-20-gc32b9f7cbda7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-20-gc32b9f7cbda7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccb896da9cc064dcc94=
cee
        failing since 22 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccb88495e4beebe3c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-20-gc32b9f7cbda7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-20-gc32b9f7cbda7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccb88495e4beebe3c94=
cba
        failing since 22 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccb88003c837d897c94cd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-20-gc32b9f7cbda7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-20-gc32b9f7cbda7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccb88003c837d897c94=
cd7
        failing since 22 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccb846c52ba89d6ac94cd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-20-gc32b9f7cbda7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-20-gc32b9f7cbda7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccb846c52ba89d6ac94=
cd2
        failing since 22 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =20
