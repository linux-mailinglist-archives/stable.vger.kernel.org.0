Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1151140029F
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 17:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349704AbhICPwi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 11:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349658AbhICPwi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 11:52:38 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74651C061575
        for <stable@vger.kernel.org>; Fri,  3 Sep 2021 08:51:38 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id fs6so3895421pjb.4
        for <stable@vger.kernel.org>; Fri, 03 Sep 2021 08:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5MN+o4BCs6jzUrrKxEc5Asf+8khW24luJpGHtN7ih88=;
        b=WRVwLJu6d/BZjIt1+75B0LvaaUAfbffRHASC8LdtTc/IWg6dRBaEjrFPPMrlrAFgn+
         /25NV4kSEBgP1t/S0o/nagdRYI0uFjb7fQ2zNJ3LbZe0my5bZ637zvac2NfkJK4uK+Nb
         S/9RhCSx8VDHjKSD43VTsN+LdFCjiaDw5G0IbdNoSMGeYfaZlAiTyoJiCboHGCVimLJN
         hzgVk5Ztescnc2Nw6V3iiQ2C8yLEYNOYRN5vAfBZH1IneRug9yFkvqe9d08eBMXclYfJ
         1cofVxLbfcif86ZJpQSMATuaq501WqLb+bItYPnZrQje4mInCq53mS/GLTm7ObPfgRij
         F7lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5MN+o4BCs6jzUrrKxEc5Asf+8khW24luJpGHtN7ih88=;
        b=JRSjB2RORLGLzVnuiCnw2FQIrx3ndATpN6EPSYkjyxxStiT2yhAtfX8PIxjdjvr5vB
         gKsHbCGQ5i6PKtAZmjp66YDTffsP+c7txQ+861l0R5wpluzlxT2hJQspapDUEr4AN9pF
         4UdeCr56AXo0ifV5jBNNF2jOcR7maP1sZc73a0mgMNBkx58vKhu1pcDxBHKTxggS9eiQ
         U/1qWc8wNX5DrqJmBJeoWjW+qZdaOGHTJzkdzzqRPVPcMahN6SceSQo8NtpoQfcy2d7R
         dkiC+6Dl6PX2amZiAqB5qd/yiVJ/TZtcoJf9tMHYuLZaNAsUFxLuU6ACDj8I3KI9YUME
         Xl8Q==
X-Gm-Message-State: AOAM533psIJ3wdbe17P3NiBBzbO7+kaZwZ6Q3lxOdW5zSuOrtComMM6B
        y1trq9pvzfXKVTV5EmsUgsWYcyfFNgQJpOgE
X-Google-Smtp-Source: ABdhPJx3qrbDEvptE0Q2u9IIULRGtoKBW0gX3WMrjhnAVhpUWDASBBAYjos4w3uTSqlt2GXvUBCakw==
X-Received: by 2002:a17:90a:2e88:: with SMTP id r8mr10297327pjd.169.1630684297703;
        Fri, 03 Sep 2021 08:51:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p4sm7249326pgc.15.2021.09.03.08.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 08:51:37 -0700 (PDT)
Message-ID: <61324489.1c69fb81.1fa86.2ad6@mx.google.com>
Date:   Fri, 03 Sep 2021 08:51:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.283
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 102 runs, 9 regressions (v4.4.283)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 102 runs, 9 regressions (v4.4.283)

Regressions Summary
-------------------

platform            | arch   | lab          | compiler | defconfig         =
  | regressions
--------------------+--------+--------------+----------+-------------------=
--+------------
beagle-xm           | arm    | lab-baylibre | gcc-8    | omap2plus_defconfi=
g | 2          =

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

qemu_x86_64-uefi    | x86_64 | lab-broonie  | gcc-8    | x86_64_defconfig  =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.283/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.283
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cbc3014d0d917ba60a8ca3938316ef022ef11f8a =



Test Regressions
---------------- =



platform            | arch   | lab          | compiler | defconfig         =
  | regressions
--------------------+--------+--------------+----------+-------------------=
--+------------
beagle-xm           | arm    | lab-baylibre | gcc-8    | omap2plus_defconfi=
g | 2          =


  Details:     https://kernelci.org/test/plan/id/61321385cac222feb0d59666

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61321385cac222fe=
b0d5966c
        new failure (last pass: v4.4.282-11-gd0f43d936dd1)
        1 lines

    2021-09-03T12:22:11.416706  / # #
    2021-09-03T12:22:11.417457  =

    2021-09-03T12:22:11.520818  / # #
    2021-09-03T12:22:11.521479  =

    2021-09-03T12:22:11.622784  / # #export SHELL=3D/bin/sh
    2021-09-03T12:22:11.623152  =

    2021-09-03T12:22:11.724273  / # export SHELL=3D/bin/sh. /lava-790794/en=
vironment
    2021-09-03T12:22:11.724616  =

    2021-09-03T12:22:11.825763  / # . /lava-790794/environment/lava-790794/=
bin/lava-test-runner /lava-790794/0
    2021-09-03T12:22:11.826879   =

    ... (10 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61321385cac222f=
eb0d5966e
        new failure (last pass: v4.4.282-11-gd0f43d936dd1)
        28 lines

    2021-09-03T12:22:12.288578  [   49.939270] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-09-03T12:22:12.340456  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-09-03T12:22:12.346128  kern  :emerg : Process udevd (pid: 115, sta=
ck limit =3D 0xcba34218)
    2021-09-03T12:22:12.350464  kern  :emerg : Stack: (0xcba35d10 to 0xcba3=
6000)
    2021-09-03T12:22:12.358884  kern  :emerg : 5d00:                       =
              bf02b83c bf010b84 cb963e10 bf02b8c8   =

 =



platform            | arch   | lab          | compiler | defconfig         =
  | regressions
--------------------+--------+--------------+----------+-------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/613211ef039fb95edcd5966f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613211ef039fb95edcd59=
670
        failing since 292 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab          | compiler | defconfig         =
  | regressions
--------------------+--------+--------------+----------+-------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-broonie  | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/61321fb25a7c68bef4d5969f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61321fb25a7c68bef4d59=
6a0
        failing since 292 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab          | compiler | defconfig         =
  | regressions
--------------------+--------+--------------+----------+-------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-cip      | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/613211e435ba133473d59666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613211e435ba133473d59=
667
        failing since 292 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab          | compiler | defconfig         =
  | regressions
--------------------+--------+--------------+----------+-------------------=
--+------------
qemu_arm-virt-gicv3 | arm    | lab-baylibre | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6132123e96f4eef2d5d5966d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6132123e96f4eef2d5d59=
66e
        failing since 292 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab          | compiler | defconfig         =
  | regressions
--------------------+--------+--------------+----------+-------------------=
--+------------
qemu_arm-virt-gicv3 | arm    | lab-broonie  | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/61321fda9495b54408d59679

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61321fda9495b54408d59=
67a
        failing since 292 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab          | compiler | defconfig         =
  | regressions
--------------------+--------+--------------+----------+-------------------=
--+------------
qemu_arm-virt-gicv3 | arm    | lab-cip      | gcc-8    | multi_v7_defconfig=
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6132121186c06d7befd59665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6132121186c06d7befd59=
666
        failing since 292 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab          | compiler | defconfig         =
  | regressions
--------------------+--------+--------------+----------+-------------------=
--+------------
qemu_x86_64-uefi    | x86_64 | lab-broonie  | gcc-8    | x86_64_defconfig  =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/61321dbe4aa7ef5c68d5968b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.283=
/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61321dbe4aa7ef5c68d59=
68c
        new failure (last pass: v4.4.282-11-gd0f43d936dd1) =

 =20
