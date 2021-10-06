Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4554424870
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 23:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239566AbhJFVER (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 17:04:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239496AbhJFVEQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 17:04:16 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A803C061746
        for <stable@vger.kernel.org>; Wed,  6 Oct 2021 14:02:24 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id 145so3428419pfz.11
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 14:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VNZx/eHeWJB5a+fFN88dKeKLwtKYqIj2UjOkylRAzus=;
        b=IlGknkK/BaI5c9HlNViPV+kSdvyY/9SQxcodBTGSGqC8Jq0PjrOvuiAJR6VTEEN+C+
         kpne1Dq+cc3TEt8ZAS+3lAS8L7bs43NMZHUzWtdT89xYvw8pUGUZqXzUqS6P1TPOJEIt
         mttaBYBw8QLYUFdHVJ3m77fOlNRa2t1zaaNgS8oVOIAu77j5CZJmVbjdLOQSMb7G1rmx
         Av1t4+hViJqf3uU9SEGRnXpmwVPgfdMgTNUFpYOTwiNiVAIWSVekX2+CbIakIZeQCE0q
         Pckmm3Tqupo86TG3ugmDkbRlX5LqLZ6UWrpw0zt9W+E+mTyqQoQjw8bf6Ytw3aPpRbH3
         VLLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VNZx/eHeWJB5a+fFN88dKeKLwtKYqIj2UjOkylRAzus=;
        b=3EZ5mRHb1+N2bujUmwiZc+320xJ2CPj+uNrrAMX229phLLvMe1wm6SCEedbSYWavPy
         v54pfohGxTsFo/+Nl4gmE1apUgaJqTDMEskQJ8ZN8VUTdrzTiznlbhjyJat+5bZ9Cokl
         TDo6qDeckcS1l9UNOPpfbddeyn4LcnXXVwqL45B5PLeBojkKyDCKQBqpbDEpLk3LdsQ3
         t9MJgW/BkZ8Dn+bX1n2VC6XYUKWaPKw4VDgwYdaovhEMPccNglYleojiCFv14nb4I+ox
         Kbr6Y3kML0gbDwYGkkX9/IMwTITwrlANdP1e/EEsHovFGk+0X5Nww9HtNAHd0IbnBcZo
         ZGAw==
X-Gm-Message-State: AOAM533JtAfvdeH8VFePjfgnBE3N9B9U7PUtAh0B8KU01p+JRVHYfW0S
        9CJlfNkyHiLxAS7rGS+xayfT6gDCiHg7d6qf
X-Google-Smtp-Source: ABdhPJxaSoWx4Md6bOF16MKS+NdrcVluxi7NSkFq1ZauZKGysQkcJ9DkIPGKKNIbvhVJcKf9pRTRmQ==
X-Received: by 2002:a63:af4a:: with SMTP id s10mr185390pgo.469.1633554143437;
        Wed, 06 Oct 2021 14:02:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 73sm1529672pfv.125.2021.10.06.14.02.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 14:02:23 -0700 (PDT)
Message-ID: <615e0edf.1c69fb81.6028e.4750@mx.google.com>
Date:   Wed, 06 Oct 2021 14:02:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.208-95-g4e87b1c850b9
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 119 runs,
 5 regressions (v4.19.208-95-g4e87b1c850b9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 119 runs, 5 regressions (v4.19.208-95-g4e87b=
1c850b9)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
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
nel/v4.19.208-95-g4e87b1c850b9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.208-95-g4e87b1c850b9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4e87b1c850b9219b59b04b976f4cf42ba0bb7c99 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/615dd8795d65da90f199a30f

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4e87b1c850b9/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4e87b1c850b9/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/615dd8795d65da9=
0f199a315
        new failure (last pass: v4.19.208-95-g55efedf0abfc)
        2 lines

    2021-10-06T17:10:06.687160  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/110
    2021-10-06T17:10:06.696008  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cf4 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/615dd7652cf955a8ff99a2f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4e87b1c850b9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4e87b1c850b9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615dd7652cf955a8ff99a=
2f2
        failing since 326 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/615dd8455752b857ae99a355

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4e87b1c850b9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4e87b1c850b9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615dd8455752b857ae99a=
356
        failing since 326 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/615dd7fe9cf764e80299a2e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4e87b1c850b9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4e87b1c850b9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615dd7fe9cf764e80299a=
2e8
        failing since 326 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/615dd6f9c3e8e55dbc99a2ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4e87b1c850b9/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.208=
-95-g4e87b1c850b9/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615dd6f9c3e8e55dbc99a=
2ed
        failing since 326 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
