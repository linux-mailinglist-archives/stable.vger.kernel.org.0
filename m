Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6376A32DFE9
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 04:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhCEDIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Mar 2021 22:08:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhCEDIS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Mar 2021 22:08:18 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE32FC061574
        for <stable@vger.kernel.org>; Thu,  4 Mar 2021 19:08:16 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id h4so381456pgf.13
        for <stable@vger.kernel.org>; Thu, 04 Mar 2021 19:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GzQgkFn3oMdgCOwqbZ7JJq1Z4AllaDD0/w9eKEhLzKc=;
        b=ulurJmceOKxtzgS3Rl8Ugt/gh8pFlh40VulIwiBCI1PjfaaoRA87VyDEALEc/lArNx
         P6X0MhbXVWtXCj7fdbtpFITZmU9Bwa9LiB5i84Z4Mh8EQQOgqsgd7Y0wRy1In8JRXZT/
         7x2vtMz3+JaAgztGsq2OaoUUqbv3R14eXUGIzsS/dmTMeDY+6/7m/l2mcvRUp1zxq3L4
         cS4/ft1aIDychI59LyeGfyG1OSodbJfQOmke1sqaNGmuCMO+vgBTQASwgR5w0NCucKTt
         trNl+OSpu0y3tzBENrwWFEuig7Syf4Lhs7y4MI7s8vhS3jbX+/0qpkDx/jb6rRz+RG/c
         /grg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GzQgkFn3oMdgCOwqbZ7JJq1Z4AllaDD0/w9eKEhLzKc=;
        b=Eld0CrSR5wMmaFPSWOId/W2CKYgQ0YDOH/cy/2M3tyxsGTtDWQoITSdT2tbarPP3t7
         6QeOUZUWbMj6mXXM7+L9H8bTVyarbs5gRFd0bIc96p81uoTp9mf/NrbfMUO+7lYzG5lL
         NioMTQMsknTtyNqxqKAIM+mVJNu04XWdkisOfRvXd+IuphKel8IGBOhcm8CxWjTYCsUA
         vv/pnvttyv+NSXwH76vYgqxQe1Ady3HwxBT8aP3SqQmDj5PdegL8+pxlfZn/ycRw7jlJ
         brnCEznheJPatBZTBBZqjqX0/zn/JdYYEmuAhU8ETKFpAEoFu73b5+ds2bGMKwF3VzaR
         colg==
X-Gm-Message-State: AOAM531CoRvZGmFNSI7kouOw3Bztu4OWbe9m+i0bx1qxz/Ru8znT4hO+
        WW3evQ5XoETPZgX/rlK59RyRXT30fLUkfew4
X-Google-Smtp-Source: ABdhPJzss128l77OjsMRsR+bvFCATshlR83AcnLty6nr0OVd1L+2ImktgSDAev8no4I1HdVllx1EdA==
X-Received: by 2002:a05:6a00:2286:b029:1ae:6c7f:31ce with SMTP id f6-20020a056a002286b02901ae6c7f31cemr6597641pfe.6.1614913696132;
        Thu, 04 Mar 2021 19:08:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h6sm650539pfv.84.2021.03.04.19.08.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 19:08:15 -0800 (PST)
Message-ID: <6041a09f.1c69fb81.a4d3f.31ee@mx.google.com>
Date:   Thu, 04 Mar 2021 19:08:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.259-11-ge047656ab33d0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 75 runs,
 7 regressions (v4.4.259-11-ge047656ab33d0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 75 runs, 7 regressions (v4.4.259-11-ge047656a=
b33d0)

Regressions Summary
-------------------

platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
panda               | arm  | lab-collabora   | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.259-11-ge047656ab33d0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.259-11-ge047656ab33d0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e047656ab33d0ac5e45cf131734fddb8f3479585 =



Test Regressions
---------------- =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
panda               | arm  | lab-collabora   | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60416dfbd0e2b4eb53addcc9

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.259-1=
1-ge047656ab33d0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.259-1=
1-ge047656ab33d0/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60416dfbd0e2b4e=
b53addcce
        new failure (last pass: v4.4.259-11-gca91a46b5f164)
        2 lines

    2021-03-04 23:32:07.542000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff26c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-03-04 23:32:07.557000+00:00  [   19.302520] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/6041726457be0c83a4addcbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.259-1=
1-ge047656ab33d0/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.259-1=
1-ge047656ab33d0/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041726457be0c83a4add=
cbc
        failing since 111 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60416edb76d6af1026addccf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.259-1=
1-ge047656ab33d0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.259-1=
1-ge047656ab33d0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60416edb76d6af1026add=
cd0
        failing since 111 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60416efdc647094e56addcc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.259-1=
1-ge047656ab33d0/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.259-1=
1-ge047656ab33d0/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60416efdc647094e56add=
cc7
        failing since 111 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/604174038a15b2a4acaddcb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.259-1=
1-ge047656ab33d0/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.259-1=
1-ge047656ab33d0/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604174038a15b2a4acadd=
cb9
        failing since 111 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60416f6d5c95449752addd23

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.259-1=
1-ge047656ab33d0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.259-1=
1-ge047656ab33d0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60416f6d5c95449752add=
d24
        failing since 111 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60416efe76d6af1026addcdd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.259-1=
1-ge047656ab33d0/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.259-1=
1-ge047656ab33d0/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60416efe76d6af1026add=
cde
        failing since 111 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =20
