Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81449311FE8
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 21:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbhBFUVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Feb 2021 15:21:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhBFUVp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Feb 2021 15:21:45 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431AEC06174A
        for <stable@vger.kernel.org>; Sat,  6 Feb 2021 12:21:05 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id e12so5323565pls.4
        for <stable@vger.kernel.org>; Sat, 06 Feb 2021 12:21:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zuxem9W2JVJN+AsG5Qz/+pMc6Kn1D4KMPi8eIZpRKAE=;
        b=wuBkUzp+uVfzEoySfoe6EENW2bI+T6NxWb3Bdk5mBMlNEE/Awe5Rdtt+X+tsIqZcmk
         ZnrVMQZYLE+47EvpwxGheu578oKtvSGeGNwWFtzC2eG30LmLTqu/eGfIfqZK+NUJZig5
         /EdoWvzWLV3UvrAPf+b4+ix2CyUD4EAg4P+k1506199dk3v0UfE1bxg7gSFahHRzU6gZ
         O4PGB7qbe4VYHI7co8pPGP8532oKc6N4w4bVIf4lj6rAoqCYoaxMnxmOUVgpLZA8KvI3
         iHJjiGrYDaUh4DSSXG2cF9vq5Nlgd+iiXV8uvpeWApfzCSjO5M8nR21+SksWOch2KTKB
         YjZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zuxem9W2JVJN+AsG5Qz/+pMc6Kn1D4KMPi8eIZpRKAE=;
        b=OqYqIJPX062gcPJbX+SWjIBIs/GgG4PtRyP1BqPHY6EhDFmB/MgPqcMVVf5rcPFT2q
         vF1j41KIgSug39UfIczkVSNEq/TU7K7D69R4KMGmHjdnMhTnkN2SQMgDRRkzaQ+asDXZ
         5gPMkLOXsdDQ1bkYpriaFy1ISbHG9OIeNkwAYEMD3YFPmV7T32+7RAYKQuv8GscvRhZD
         /fLk9tYI8TcUf6V6RFB8oQ5F4vCDbmfIT9mTyklgtwFn0nldbQvCAil0aHI+EWyDGTmx
         ZhejlxImnQQpDYMbH0CXiQyuJ4c/4RjRtQoZRRcbCmBUSEXIGYXHQVWI/RGrygUd96G8
         N9LQ==
X-Gm-Message-State: AOAM531RHc/CbgnkXvlADDQlYysdad1tboSNfZgZUMyey43ftdnVNQpa
        lXQWQTZD2tfT/Z9Ixng4ZmDhk7rWMq1+gA==
X-Google-Smtp-Source: ABdhPJxnx41DA3TeDNrNgA0JjltlrpuKkBzl/AYT58eXhNju49nFRrI5B10VjUrTinbd5WWWXBV0Eg==
X-Received: by 2002:a17:90a:950c:: with SMTP id t12mr9824903pjo.226.1612642864174;
        Sat, 06 Feb 2021 12:21:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a6sm13057427pfr.43.2021.02.06.12.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Feb 2021 12:21:03 -0800 (PST)
Message-ID: <601efa2f.1c69fb81.fd766.b20a@mx.google.com>
Date:   Sat, 06 Feb 2021 12:21:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.256-15-g96b5080c036c0
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 103 runs,
 13 regressions (v4.4.256-15-g96b5080c036c0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 103 runs, 13 regressions (v4.4.256-15-g96b508=
0c036c0)

Regressions Summary
-------------------

platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
dove-cubox          | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfi=
g  | 1          =

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

qemu_i386-uefi      | i386 | lab-baylibre    | gcc-8    | i386_defconfig   =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.256-15-g96b5080c036c0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.256-15-g96b5080c036c0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      96b5080c036c0bf4ccb0a0539e63e7e15b98688d =



Test Regressions
---------------- =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
dove-cubox          | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/601ec7b5da066082393abe98

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.256-1=
5-g96b5080c036c0/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove=
-cubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.256-1=
5-g96b5080c036c0/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove=
-cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601ec7b5da066082393ab=
e99
        new failure (last pass: v4.4.256-14-g2d58dd4004a4) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
panda               | arm  | lab-collabora   | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/601ec858a67b7be9cf3abe6a

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.256-1=
5-g96b5080c036c0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.256-1=
5-g96b5080c036c0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/601ec858a67b7be=
9cf3abe71
        failing since 0 day (last pass: v4.4.255-14-ge5269953cc26, first fa=
il: v4.4.256-14-g2d58dd4004a4)
        2 lines

    2021-02-06 16:48:18.649000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff26c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/601ec7358a0b6502ff3abe9f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.256-1=
5-g96b5080c036c0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.256-1=
5-g96b5080c036c0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601ec7358a0b6502ff3ab=
ea0
        failing since 84 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/601ec7d043a96e31d43abe66

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.256-1=
5-g96b5080c036c0/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.256-1=
5-g96b5080c036c0/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601ec7d043a96e31d43ab=
e67
        failing since 84 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/601ec74e37101599eb3abe8c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.256-1=
5-g96b5080c036c0/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.256-1=
5-g96b5080c036c0/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601ec74e37101599eb3ab=
e8d
        failing since 84 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/601ec7a7da066082393abe8c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.256-1=
5-g96b5080c036c0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.256-1=
5-g96b5080c036c0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601ec7a7da066082393ab=
e8d
        failing since 84 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/601ec75066f117b1673abe8b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.256-1=
5-g96b5080c036c0/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.256-1=
5-g96b5080c036c0/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601ec75066f117b1673ab=
e8c
        failing since 84 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/601ec794db9cefac863abe77

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.256-1=
5-g96b5080c036c0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.256-1=
5-g96b5080c036c0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601ec794db9cefac863ab=
e78
        failing since 84 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/601ec8e0a5b312baca3abe7a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.256-1=
5-g96b5080c036c0/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.256-1=
5-g96b5080c036c0/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601ec8e0a5b312baca3ab=
e7b
        failing since 84 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/601ec886d57ddd5ff63abe90

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.256-1=
5-g96b5080c036c0/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.256-1=
5-g96b5080c036c0/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601ec886d57ddd5ff63ab=
e91
        failing since 84 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/601ec891b9d8b65f063abe63

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.256-1=
5-g96b5080c036c0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.256-1=
5-g96b5080c036c0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601ec891b9d8b65f063ab=
e64
        failing since 84 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/601ec7516a9e1de7363abe65

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.256-1=
5-g96b5080c036c0/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.256-1=
5-g96b5080c036c0/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601ec7516a9e1de7363ab=
e66
        failing since 84 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_i386-uefi      | i386 | lab-baylibre    | gcc-8    | i386_defconfig   =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/601ec604e4960299fe3abe81

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.256-1=
5-g96b5080c036c0/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.256-1=
5-g96b5080c036c0/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601ec604e4960299fe3ab=
e82
        new failure (last pass: v4.4.256-14-g2d58dd4004a4) =

 =20
