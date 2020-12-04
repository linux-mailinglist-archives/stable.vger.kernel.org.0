Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 378E72CE5F6
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 03:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgLDCuk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 21:50:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbgLDCuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 21:50:40 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F1DC061A4F
        for <stable@vger.kernel.org>; Thu,  3 Dec 2020 18:49:54 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id p21so3048068pjv.0
        for <stable@vger.kernel.org>; Thu, 03 Dec 2020 18:49:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pTKqFiTQJRpwTSnAy/K5axElw5GzyqiUmX3nYzB+Zho=;
        b=tdLMC8G21IsWLdvQDlu8zodOXgFLdDvldKhmHaKMUu5MaO3aGZzGc7ZGppSTIOuK5L
         nJWOKL/ab86dR3brl7I3oltCTI29+j2u2+VZCAl9rHoPiBnuBJFjldJPZ9w8QUb2EDSZ
         S04TAiTmDSGjn/y6UI9pB359nt4ZilqmIg7H5mm9R3S97rK2DvmRRGk9mv5uJnzTI4NR
         jbgL9JklOnPcO1Asmoz29jrYR+7F7ZqJi2++tMZMwMzvntOVdBbaO/sb2Z/jsBiPo1Ev
         RZSC5e7ayU8aj8GFaIUSWyZezrTF1Fv67XbwHMPcuu3jsgxPsQxbjaI/l3HJm6XcscZj
         95dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pTKqFiTQJRpwTSnAy/K5axElw5GzyqiUmX3nYzB+Zho=;
        b=Jnt/C97Oe6ORh5iQFDAo/GLNp5/zjxBXuVurw+8ympQqCQECS0aSh53dklPIDzP1Ar
         ytsQgV87IUFesW9kyBj/KRSVd7HWzna0fMuQQ7A6fh1koS81yPcz5m63MOvqIKt8wC7A
         shGGs2eUqGmKUm3qKMVGyG5IDr/eL2AfcPvq+DAGrzlCqObTdlDtbfqUsdDqoUO4IRaY
         uABOHcwnQhRve1mGMwxWBfZ2Y62CSd+iepZtFlqWkiFHhvxrCZWWGdPhfAErvZnsj347
         LXkrQiiRoavJiuBkMmmtX9SpvNEV5xZ18qtMVTPObrY87zppJM/9to8U2MuiO2c6/wQ/
         DZTw==
X-Gm-Message-State: AOAM531yjJ7DmU7xjm86vDN6O+sy1KmBioVyOL3YK+LcTjUEXwoSlFWc
        MSz5hTf1O7LlAHvPIeDJwhPOVxE5qkxa/g==
X-Google-Smtp-Source: ABdhPJwmvSQdFdUxVCJyQKnXg1T3dLJUqoxLA+yzIdpTHXRALDkY77Oi4XtDuG22t6oc+ej7n5VVMg==
X-Received: by 2002:a17:90a:a45:: with SMTP id o63mr2091680pjo.146.1607050193576;
        Thu, 03 Dec 2020 18:49:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s7sm1100908pfh.207.2020.12.03.18.49.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 18:49:52 -0800 (PST)
Message-ID: <5fc9a3d0.1c69fb81.9a153.44eb@mx.google.com>
Date:   Thu, 03 Dec 2020 18:49:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.210-7-g5c828e58d4a6
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 169 runs,
 8 regressions (v4.14.210-7-g5c828e58d4a6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 169 runs, 8 regressions (v4.14.210-7-g5c828e=
58d4a6)

Regressions Summary
-------------------

platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
panda                | arm    | lab-collabora   | gcc-8    | omap2plus_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =

qemu_x86_64          | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =

qemu_x86_64-uefi     | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.210-7-g5c828e58d4a6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.210-7-g5c828e58d4a6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5c828e58d4a6b7c196a7a214ec0a8c41076a7b9f =



Test Regressions
---------------- =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
panda                | arm    | lab-collabora   | gcc-8    | omap2plus_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc972a894843df955c94cc4

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c828e58d4a6/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c828e58d4a6/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fc972a894843df=
955c94cc9
        failing since 5 days (last pass: v4.14.209-11-ge2326a479d95, first =
fail: v4.14.209-14-gefcf305b1a7e8)
        2 lines

    2020-12-03 23:20:04.647000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/99
    2020-12-03 23:20:04.656000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc96f4ded634d1630c94cd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c828e58d4a6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c828e58d4a6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc96f4ded634d1630c94=
cd9
        failing since 20 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc96f684103b5178fc94cf0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c828e58d4a6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c828e58d4a6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc96f684103b5178fc94=
cf1
        failing since 20 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc96f2a89ec4f9bf7c94cf8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c828e58d4a6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c828e58d4a6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc96f2a89ec4f9bf7c94=
cf9
        failing since 20 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc96eeca88744be41c94cc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c828e58d4a6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c828e58d4a6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc96eeca88744be41c94=
cc6
        failing since 20 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc972e94336d8add7c94cba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c828e58d4a6/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c828e58d4a6/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc972e94336d8add7c94=
cbb
        failing since 20 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_x86_64          | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc972704922ba1456c94cd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c828e58d4a6/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c828e58d4a6/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc972704922ba1456c94=
cd6
        failing since 0 day (last pass: v4.14.210-7-gc5d4ef27476b9, first f=
ail: v4.14.210-7-g5c0c3ae0c166) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_x86_64-uefi     | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc9720e928775b6bec94cf0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c828e58d4a6/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.210=
-7-g5c828e58d4a6/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc9720e928775b6bec94=
cf1
        new failure (last pass: v4.14.210-7-g5c0c3ae0c166) =

 =20
