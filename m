Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3770030EB81
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 05:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbhBDEQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 23:16:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhBDEQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 23:16:45 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C685C061573
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 20:16:05 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id lw17so4420960pjb.0
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 20:16:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bwquqmuUdIlNHACvcM2Tx0reemYW/ZuNNLggYhs/7eE=;
        b=JdsekSOhXX/huijcIptOqhq9zf+4LPxgQvX5+/1wrRyeWAXg0Z7q30luHOqgheJ1j1
         9tl5e+mT9HbFHhoZue1lDjd37D3PcrI7qlhCafXCF/StB0smfEpccSConOOgp6iu62Av
         qwb3apLWycuouJZex6eR7HBl7F4kmJgXWpTELlDb82KfHDWzOCKsAhn7U7krDH4rWFxG
         miCPaXyqm6d2qYQpZzkfBE+DTDvK7ThAUKtpX0buEF4tBUfwQjyhi8UFKuRHzBa3oK0X
         O+XVbLHeZpdQaHZ+3i8byb4eCO0sPHAYNwV4JIngWgr8C8WbGIR3uxun5TLJdA8zU0yd
         VoEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bwquqmuUdIlNHACvcM2Tx0reemYW/ZuNNLggYhs/7eE=;
        b=Po0gC9jPDLRy3D6xPxl6sJ/ZR9QotlzPxgNHFXvl9S/va+viQTGYedv02bVPUIcBD9
         8kx2ZYZlUg9oVkkk9btCtPL29z7XZu7qvKXwDkt80jrA/U4KvkVsdW3rOLxvhy0eAdi1
         zcDO7KHG+NjeyTNys0yOmDigeEN/VRCD8JFo105P2XSp1cFBpx1CgSutyi4ovUma8qk6
         l6xgjEBTo3P4iFcL1QhXXuiDCjKE3NxEaqhNCU5epQiZAA2NawyOn0u3JaA6M5Yz4raq
         /Xjq4/idP0P6Ncvz09c9eSURLxYMvMI/XA6gRY0gOUwCqeB88D7rHy7mHBvZzUFpY944
         h7kQ==
X-Gm-Message-State: AOAM533jDJcI2Lw9oQxEXWeKPVxTQPmL04l0ZR/r/2sOUWeFDezZ9Icq
        b7tUBBJp3g3xwAZhoIBuJXIYCAUCfIMHWA==
X-Google-Smtp-Source: ABdhPJzTZDpJbLAn1L/pPPp7hqO32SAdO7xGzaAozgtjEiuyrbCDjtc5Uma0y8d3GPqv3yn812pQLw==
X-Received: by 2002:a17:902:a383:b029:e0:10e6:6ed7 with SMTP id x3-20020a170902a383b02900e010e66ed7mr6456665pla.5.1612412164260;
        Wed, 03 Feb 2021 20:16:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w6sm3844676pfq.162.2021.02.03.20.16.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 20:16:03 -0800 (PST)
Message-ID: <601b7503.1c69fb81.b90ee.9eee@mx.google.com>
Date:   Wed, 03 Feb 2021 20:16:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.254-32-g22fc97eddae5
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 101 runs,
 7 regressions (v4.9.254-32-g22fc97eddae5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 101 runs, 7 regressions (v4.9.254-32-g22fc97e=
ddae5)

Regressions Summary
-------------------

platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
panda                | arm    | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =

qemu_x86_64          | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig=
    | 1          =

sun8i-h3-orangepi-pc | arm    | lab-clabbe    | gcc-8    | sunxi_defconfig =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.254-32-g22fc97eddae5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.254-32-g22fc97eddae5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      22fc97eddae536490ad5d424a6cd1f875546739e =



Test Regressions
---------------- =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
panda                | arm    | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/601b4234c1316e9c913abe79

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
2-g22fc97eddae5/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
2-g22fc97eddae5/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/601b4234c1316e9=
c913abe80
        failing since 3 days (last pass: v4.9.253-30-g6cb2db3a6d706, first =
fail: v4.9.254-3-g1ef1a4ed104f)
        2 lines

    2021-02-04 00:39:12.757000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-02-04 00:39:12.773000+00:00  [   20.515716] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/601b41c7d8cb8109ef3abe70

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
2-g22fc97eddae5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
2-g22fc97eddae5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601b41c7d8cb8109ef3ab=
e71
        failing since 82 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/601b41bf8d86b123f73abe74

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
2-g22fc97eddae5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
2-g22fc97eddae5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601b41bf8d86b123f73ab=
e75
        failing since 82 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/601b41af114fa619d43abe80

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
2-g22fc97eddae5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
2-g22fc97eddae5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601b41af114fa619d43ab=
e81
        failing since 82 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/601b415e141fb1f76d3abe65

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
2-g22fc97eddae5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
2-g22fc97eddae5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601b415e141fb1f76d3ab=
e66
        failing since 82 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_x86_64          | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:     https://kernelci.org/test/plan/id/601b4122fd01bb1f9f3abe65

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
2-g22fc97eddae5/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
2-g22fc97eddae5/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601b4122fd01bb1f9f3ab=
e66
        new failure (last pass: v4.9.254-32-ge997477de456) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
sun8i-h3-orangepi-pc | arm    | lab-clabbe    | gcc-8    | sunxi_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/601b4368f4a3cec9873abe6f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
2-g22fc97eddae5/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-oran=
gepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.254-3=
2-g22fc97eddae5/arm/sunxi_defconfig/gcc-8/lab-clabbe/baseline-sun8i-h3-oran=
gepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601b4368f4a3cec9873ab=
e70
        new failure (last pass: v4.9.254-32-ge997477de456) =

 =20
