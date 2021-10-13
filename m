Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6754A42B842
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 09:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238219AbhJMHDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 03:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231792AbhJMHDI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 03:03:08 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE12C061570
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 00:01:06 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id y7so1608010pfg.8
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 00:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qe5nJKCRi+vxHOeeWvCM2hHNpHDqNd46N500rwyZ3hE=;
        b=2wdKuxyGT00ecYLJCWR+VVQbGxobXp3kCdSod491v9CRjDEYkt9i6EZasDIYeMIiVf
         NTEBn0LPHriaGrlrJFToRx14AKYw8XKWx2EgOYsEZaCdfBejRP9kOezpMyUIaqbzYl7Y
         m4slc0kiPZiElyRjnws0T68Gu+2bAsmYzEeteBrGP+zfX4euT/I8JClKuAiXNcCPhWYo
         5JoCMF7w8S6UB7FrO0WZSyUlO6mfzHy9NzAAkKgCuDFbPF9nEM3WWJI74c0L/PpdKsZ+
         j5VkjsbeZGY0MRDQearI3gkADb9ucqIPba0MTzdZMlzgbBM/avAtdUaKzsACiuiVQqrR
         kW5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qe5nJKCRi+vxHOeeWvCM2hHNpHDqNd46N500rwyZ3hE=;
        b=tOH5a1YgAoFGE1UrAGzuqbnlF2E0zFUGr9sd5YRiuu7VWC2p3b4jClV9cRY1Wc2So7
         zMVYQ7mkFRUSknJz4X/ROy2492b1BaHiW6A7AhebU3y8RikVRBbYX/EpdiLnGYAsJSI3
         cahjNbpGHa1CiR3AB8sMfgzMZG6UmcZyDNFuEk7MzED1jKWahflqK2w+4hsPfxusBc3K
         qWbSuEz7gN5+5bFgO0Xhp9tNb15KNuAN1eDRhflOzebfvwDrcCCdCjPGi9z7pbMJxjKA
         6X/lfBctyYxiAj/j4NbPQfVGLZgAlx35tnpAChbHzksTe23lgP9aXLaYwUhCu24AX/dZ
         NgBg==
X-Gm-Message-State: AOAM533JOSU5O1xWZtjAiyC4I5HkDJAVSvjy3ByMafXYepNerdQhnUJU
        yhI8Sl3M3Fno4fp95Dk1cY0q2gDXqDRi4l1d
X-Google-Smtp-Source: ABdhPJyiMdSUfFztUeNKpt4ewcvOUxorHmeUe8lRzH1HiFTM8VNirkmcQ1gJc0xc34AFY5mmLzaXDA==
X-Received: by 2002:a62:6587:0:b0:44b:5c4b:fe8c with SMTP id z129-20020a626587000000b0044b5c4bfe8cmr36641510pfb.33.1634108465593;
        Wed, 13 Oct 2021 00:01:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r130sm13203989pfc.89.2021.10.13.00.01.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 00:01:05 -0700 (PDT)
Message-ID: <61668431.1c69fb81.4a196.5369@mx.google.com>
Date:   Wed, 13 Oct 2021 00:01:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.210-27-g001688c3e983
Subject: stable-rc/queue/4.19 baseline: 99 runs,
 6 regressions (v4.19.210-27-g001688c3e983)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 99 runs, 6 regressions (v4.19.210-27-g001688=
c3e983)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 1          =

panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.210-27-g001688c3e983/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.210-27-g001688c3e983
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      001688c3e983fb68ded66462677644615bcd52c6 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/616648cefd5b99109508fab0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-27-g001688c3e983/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-27-g001688c3e983/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616648cefd5b99109508f=
ab1
        failing since 0 day (last pass: v4.19.210-9-g2ca4e64e8c5a, first fa=
il: v4.19.210-28-g780ab81b91b9) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61664b25d76fb1571808fad1

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-27-g001688c3e983/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-27-g001688c3e983/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61664b25d76fb15=
71808fad4
        failing since 0 day (last pass: v4.19.210-9-g2ca4e64e8c5a, first fa=
il: v4.19.210-28-g780ab81b91b9)
        2 lines

    2021-10-13T02:57:25.244158  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/103
    2021-10-13T02:57:25.253252  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cf4 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61664586f833fb1cce08fab6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-27-g001688c3e983/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-27-g001688c3e983/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61664586f833fb1cce08f=
ab7
        failing since 333 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61664591f833fb1cce08fabc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-27-g001688c3e983/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-27-g001688c3e983/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61664591f833fb1cce08f=
abd
        failing since 333 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6166457bf833fb1cce08fab2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-27-g001688c3e983/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-27-g001688c3e983/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6166457bf833fb1cce08f=
ab3
        failing since 333 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61667b143f6d9b86ba08fab7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-27-g001688c3e983/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.210=
-27-g001688c3e983/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61667b143f6d9b86ba08f=
ab8
        failing since 333 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
