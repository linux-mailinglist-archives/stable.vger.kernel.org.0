Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 102DD2F7A0D
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387724AbhAOMop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733289AbhAOMom (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 07:44:42 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C2DC061757
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 04:44:01 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id q4so4641811plr.7
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 04:44:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rZfWo4XXX05bN2AYqW9bKeampTb0CsUayBsKIzQFCvI=;
        b=oYAPrXMXnnI3d0kLN88RsSCZfd8rCSde7RQwDufgkt8aJcYYaqIE5xXTSYb5uXDsqt
         vwEAQ6WEVCeauPGFlmXggrKdvF9WbrtaGvgm/4v/3STmaZ01xAI9yXj4aacg7TJv0ufz
         yjv15VXQtWWp48QUFEJaTYAcGFfpeCnKB3N4da6bMo5hYo2wn1HKMWQJ5MgigAk2Y48h
         hk1q+uftkDCPMy2bs3nsWMWGYvVIAQI3Srv6yZ186CP8dBo85U3+MxkezXsfLeFmJ/7H
         EyMIOV7hGzEcVTQI0SBY2B4vrXsdA6OSJ4AoOCDjuPqju3q7qH3Z+rdmJPCoq9I9eX4q
         YuHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rZfWo4XXX05bN2AYqW9bKeampTb0CsUayBsKIzQFCvI=;
        b=bba2dNnakWxY0ZVhxNkGO7/pebydi1L7p2HQ2PZ2yKincTv+ZCJs/+Y87hw+6FHaY5
         Jccwpp2APyI4SaHtMLK+oPI/K73rbsP0n2Jot0LAGFgn62gzk9BWFlzd8gwVpm4/UIGW
         7ptoyk6I8C2rdqe9/zXVxsBIgY+/J0TPyqGhq7mr7T8REF47HCYnhSBwwSahNWBnRNz4
         ysEmTtLxXAeUyhu+SajKD3xdUxNKadJSHOvU6xCf7AIduqcLv1AaDXdqRJO6ubHoa8nh
         W5Lur14ZlutyYLfllPJw6VsjUTo04DuSeqGy8UVrC1/dsXCnpXVQLd1aoBupOO1N7OHn
         QmDw==
X-Gm-Message-State: AOAM530SpJnxwXwOk/NllQW1A/2m/lvVpMjICJkWIrWymzT3E5qqyy3c
        guoZGx2MoNgWO0bc/JSti3MMB8HGVQaihA==
X-Google-Smtp-Source: ABdhPJwiK4j+Srnlg6Bl7DQmOx2f8ZNPkkBSapjQPMSZRzD8DvjU6dEjn7CU8+gpF9M3tck0TI2P9g==
X-Received: by 2002:a17:90b:1202:: with SMTP id gl2mr10688891pjb.123.1610714641067;
        Fri, 15 Jan 2021 04:44:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o14sm8591474pgr.44.2021.01.15.04.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 04:44:00 -0800 (PST)
Message-ID: <60018e10.1c69fb81.12a8c.4dbe@mx.google.com>
Date:   Fri, 15 Jan 2021 04:44:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.251-7-gb79c6ec864b18
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 109 runs,
 14 regressions (v4.4.251-7-gb79c6ec864b18)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 109 runs, 14 regressions (v4.4.251-7-gb79c6ec=
864b18)

Regressions Summary
-------------------

platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
panda               | arm    | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =

qemu_arm-virt-gicv2 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig  | 1          =

qemu_arm-virt-gicv2 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig  | 1          =

qemu_arm-virt-gicv2 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig  | 1          =

qemu_arm-virt-gicv2 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig  | 1          =

qemu_arm-virt-gicv2 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig  | 1          =

qemu_i386           | i386   | lab-baylibre    | gcc-8    | i386_defconfig =
     | 1          =

qemu_i386-uefi      | i386   | lab-baylibre    | gcc-8    | i386_defconfig =
     | 1          =

qemu_x86_64         | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconfi=
g    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.251-7-gb79c6ec864b18/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.251-7-gb79c6ec864b18
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b79c6ec864b183ebd7f1c0493ca73e28bb5ddb52 =



Test Regressions
---------------- =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
panda               | arm    | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60015b1ad0a53eacc3c94ce4

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.251-7=
-gb79c6ec864b18/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.251-7=
-gb79c6ec864b18/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60015b1ad0a53ea=
cc3c94ce9
        failing since 4 days (last pass: v4.4.250-3-g00441213386a, first fa=
il: v4.4.250-4-g585b96e43cef)
        2 lines

    2021-01-15 09:06:30.556000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff26c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-01-15 09:06:30.576000+00:00  [   19.303863] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/60015ab391f4b733c3c94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.251-7=
-gb79c6ec864b18/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.251-7=
-gb79c6ec864b18/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60015ab391f4b733c3c94=
cc9
        failing since 62 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_arm-virt-gicv2 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/60015aba91f4b733c3c94cd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.251-7=
-gb79c6ec864b18/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.251-7=
-gb79c6ec864b18/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60015aba91f4b733c3c94=
cd5
        failing since 62 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_arm-virt-gicv2 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/60015ac991f4b733c3c94d09

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.251-7=
-gb79c6ec864b18/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.251-7=
-gb79c6ec864b18/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60015ac991f4b733c3c94=
d0a
        failing since 62 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_arm-virt-gicv2 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/60016aefcf08162c46c94ce9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.251-7=
-gb79c6ec864b18/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.251-7=
-gb79c6ec864b18/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60016aefcf08162c46c94=
cea
        failing since 62 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_arm-virt-gicv2 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/60016b74c57fc5350ec94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.251-7=
-gb79c6ec864b18/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.251-7=
-gb79c6ec864b18/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60016b74c57fc5350ec94=
cba
        failing since 62 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_arm-virt-gicv3 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/60015ad62eaed8e194c94ccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.251-7=
-gb79c6ec864b18/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.251-7=
-gb79c6ec864b18/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60015ad62eaed8e194c94=
ccd
        failing since 62 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_arm-virt-gicv3 | arm    | lab-broonie     | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/60015ab291f4b733c3c94cc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.251-7=
-gb79c6ec864b18/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.251-7=
-gb79c6ec864b18/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60015ab291f4b733c3c94=
cc6
        failing since 62 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_arm-virt-gicv3 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/60015adb6b5d7026d5c94ccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.251-7=
-gb79c6ec864b18/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.251-7=
-gb79c6ec864b18/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60015adb6b5d7026d5c94=
cce
        failing since 62 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_arm-virt-gicv3 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/60016ca9f9fd8754a6c94cea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.251-7=
-gb79c6ec864b18/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.251-7=
-gb79c6ec864b18/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60016ca9f9fd8754a6c94=
ceb
        failing since 62 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_arm-virt-gicv3 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/60016b75d9ef30b4d2c94cbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.251-7=
-gb79c6ec864b18/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.251-7=
-gb79c6ec864b18/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60016b75d9ef30b4d2c94=
cbc
        failing since 62 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_i386           | i386   | lab-baylibre    | gcc-8    | i386_defconfig =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60015b703a76b82895c94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.251-7=
-gb79c6ec864b18/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.251-7=
-gb79c6ec864b18/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60015b703a76b82895c94=
cc3
        failing since 0 day (last pass: v4.4.251-7-g049de8acf043a, first fa=
il: v4.4.251-7-g43cef06eec96) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_i386-uefi      | i386   | lab-baylibre    | gcc-8    | i386_defconfig =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60015b5cc8f0b0ee1dc94cba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.251-7=
-gb79c6ec864b18/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-u=
efi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.251-7=
-gb79c6ec864b18/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-u=
efi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60015b5cc8f0b0ee1dc94=
cbb
        failing since 0 day (last pass: v4.4.251-7-g049de8acf043a, first fa=
il: v4.4.251-7-g43cef06eec96) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_x86_64         | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconfi=
g    | 1          =


  Details:     https://kernelci.org/test/plan/id/60015aed2eaed8e194c94ce2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.251-7=
-gb79c6ec864b18/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.251-7=
-gb79c6ec864b18/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60015aed2eaed8e194c94=
ce3
        failing since 0 day (last pass: v4.4.251-7-g049de8acf043a, first fa=
il: v4.4.251-7-g43cef06eec96) =

 =20
