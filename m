Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89441414D88
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 17:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236440AbhIVP47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 11:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236417AbhIVP47 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 11:56:59 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEC2CC061574
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 08:55:28 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id n2so2024334plk.12
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 08:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AgyvIaNNWrKNO2XPWUFItKpxxy1quQQ8W84Q1fWQLnk=;
        b=uZJAK73+jLMHyT6fgiZNRMGaC44GY5g1hmj2CcQ5RP0u/uATM+ldoWgT6FEbvUd/L2
         1D7VgJfDJR79UPNGB2vkluf8K2sRhTd+ezTKf8vATTSfwHWDoF9xf6i6HV3MD/VPA3y5
         HJHb2q6BxMHi2LuXNNmEjU7xNca1eBI7cn41k0qPzJ5Wj0I39Ihtl8hBwCVEcLwqNEvM
         ztNW3IzEoBb7oImqZMaOORXpCSPHbMhK3PWw0ssjYsgu5copLufMf+WP9JrUWiu+kmBE
         pQYNJsNwzysGw/3dILjpHGw0HekVnEojHTXSANtMgYgvaM8WvchQ30QlohH+ff46a5kO
         cTWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AgyvIaNNWrKNO2XPWUFItKpxxy1quQQ8W84Q1fWQLnk=;
        b=b8delqpLDbqQqwzxmQp9L6v2Fln2nrLJ0ZitqkA2NtvbZ8cfnTtEx9U7Ut4/wTlExU
         I6uz5vCaitL/Qc+gZBA3u+Hab7DaAD/4m9BzZIxFjVsSMuYJA4Sn2a+CNM0WwUW8PX7s
         NExxb/HwpcXdXubNEjUGPWW1rT7msd4ZimKyUFDVfE02McjPvBOGfgC/DXnOHLlkKJQp
         11x8gDQ3l3mbpCywg6Ew/yeRtmS+qE7NCqjHbNwEWUUuHhJ8HJuAfK4W8DhC8S1xNa0S
         a4EP/KKXgwijnrKyLhFiggwDuF3TFbnIrph4ePDDg70sajcPSau41DEvZWvkInfhhu1L
         XZFw==
X-Gm-Message-State: AOAM532/g+ZyxR71RHcbiWnGZ+RHZVv7rWWgO3bzhGUMHZI4TGdpAmci
        vFjzDtwzbnY7XugfIy2P3BvbV54e2CQY1q0I
X-Google-Smtp-Source: ABdhPJw19lQet1x+YLNH/j5DlBjd0Y07NnofMklUIbk4HazCvflADuzzqvmeiamVinyuBFRrHC5u+Q==
X-Received: by 2002:a17:90b:3797:: with SMTP id mz23mr109993pjb.216.1632326128224;
        Wed, 22 Sep 2021 08:55:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c8sm2818518pfj.204.2021.09.22.08.55.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 08:55:27 -0700 (PDT)
Message-ID: <614b51ef.1c69fb81.86b51.783d@mx.google.com>
Date:   Wed, 22 Sep 2021 08:55:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.283-134-gac40fd917398
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 82 runs,
 8 regressions (v4.4.283-134-gac40fd917398)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 82 runs, 8 regressions (v4.4.283-134-gac40fd9=
17398)

Regressions Summary
-------------------

platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
beagle-xm           | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig=
 | 2          =

qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.283-134-gac40fd917398/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.283-134-gac40fd917398
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ac40fd917398affa096d59d08eca2d9e141527de =



Test Regressions
---------------- =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
beagle-xm           | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig=
 | 2          =


  Details:     https://kernelci.org/test/plan/id/614b1c9f395f7704e699a2e2

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
34-gac40fd917398/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
34-gac40fd917398/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/614b1ca0395f7704=
e699a2e8
        failing since 6 days (last pass: v4.4.283-72-gd71f8e13792e, first f=
ail: v4.4.283-116-g78a7bb31bae4)
        1 lines

    2021-09-22T12:07:41.799119  / # =

    2021-09-22T12:07:41.799680  #
    2021-09-22T12:07:41.902461  / # #
    2021-09-22T12:07:41.903003  =

    2021-09-22T12:07:42.004293  / # #export SHELL=3D/bin/sh
    2021-09-22T12:07:42.004645  =

    2021-09-22T12:07:42.105761  / # export SHELL=3D/bin/sh. /lava-873508/en=
vironment
    2021-09-22T12:07:42.106093  =

    2021-09-22T12:07:42.207178  / # . /lava-873508/environment/lava-873508/=
bin/lava-test-runner /lava-873508/0
    2021-09-22T12:07:42.208147   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/614b1ca0395f770=
4e699a2ea
        failing since 6 days (last pass: v4.4.283-72-gd71f8e13792e, first f=
ail: v4.4.283-116-g78a7bb31bae4)
        28 lines

    2021-09-22T12:07:42.722921  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-09-22T12:07:42.728849  kern  :emerg : Process udevd (pid: 106, sta=
ck limit =3D 0xcb928218)
    2021-09-22T12:07:42.733394  kern  :emerg : Stack: (0xcb929d10 to 0xcb92=
a000)
    2021-09-22T12:07:42.741316  kern  :emerg : 9d00:                       =
              bf02b83c bf010b84 cb95e010 bf02b8c8   =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/614b1ec293e3df487399a2e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
34-gac40fd917398/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
34-gac40fd917398/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b1ec293e3df487399a=
2e7
        failing since 312 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/614b264fe2e5a2d43499a2df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
34-gac40fd917398/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
34-gac40fd917398/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b264fe2e5a2d43499a=
2e0
        failing since 312 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/614b1f02e5a59e10eb99a2f8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
34-gac40fd917398/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
34-gac40fd917398/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b1f02e5a59e10eb99a=
2f9
        failing since 312 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/614b1ec33dd03f86b599a2f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
34-gac40fd917398/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
34-gac40fd917398/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b1ec33dd03f86b599a=
2f2
        failing since 312 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/614b26c713a84e988099a2e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
34-gac40fd917398/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
34-gac40fd917398/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b26c713a84e988099a=
2e8
        failing since 312 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/614b202d99e03aff8699a2ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
34-gac40fd917398/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
34-gac40fd917398/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b202d99e03aff8699a=
2ed
        failing since 312 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =20
