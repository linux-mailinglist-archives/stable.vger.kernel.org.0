Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 972F330636D
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 19:35:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235240AbhA0SfC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jan 2021 13:35:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235034AbhA0Se5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jan 2021 13:34:57 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D19C061573
        for <stable@vger.kernel.org>; Wed, 27 Jan 2021 10:34:15 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id u11so1505078plg.13
        for <stable@vger.kernel.org>; Wed, 27 Jan 2021 10:34:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HPfSsxAkxxKU3K0MbfSrycdaopZhULsc8zQVaUaIkdM=;
        b=bZ1xDh+4LK5hcE+7D5/i/ah48bITWttVN/kDu1xS2Da/GN6YwKw1jSzRuIIFxdCpMS
         21TOIqouqHFmv6lP/KqT3xONwUwQJSQ0rdXlB4CjWkTdY7dE2gmbG+I7QNZiBv3WzFWX
         Ly2BQqKuA1UPnFQQn8l3ZFKxouZHhzo9Xnk4U5I3Ren4wfCJs6e21L0PQrbDCs3EhNWH
         zua8mLtaPaw2J7cwrWFR2I8xeU2iDrEpwW5DDnJVDV6IjF9gqqJbl0j1o5zGsuArHHMq
         jJPFsH8YT+F1asmEaoDKVrLNqP9StOskj3ROnoSYNo+vSgxnVV7FXnRxvnVcLTJupF+s
         eO9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HPfSsxAkxxKU3K0MbfSrycdaopZhULsc8zQVaUaIkdM=;
        b=r1kDFO6LrZ34XC9BvgpbRcd/GQhDKY0/1bfFTQhMipGgK2eZVbgN5ozvZ2oXYsoie7
         gfftpXdtBtn79IuuHVPgLcg+Yw/2x5mi5+8ZhJFEdhVqHN3tPO/gNyWAPMKe9ah2FTFK
         NK3aML8u7l96KzQDZ4aD9QXHaNapykYSppqT+fiSg0EwXwuYsGzq4C2GStInY3Epi0zz
         6OEumChnpVxz9ivRpK63hZYHjLT3f4AwGjxhLpvUccc828PIPfVd9W2ZkUUaEtuIqAyj
         ZERWJbYblOEBSjQSN1ImBvidadAlfMAaD5meHR3lFRNv2I3IAGcEkM6f4KvuzhchNUZu
         abzg==
X-Gm-Message-State: AOAM5315YWEh/EHAn6cjD6sLCL2nbF373JhUr9A9mS0ouPmRBGVIF1YW
        ydhycehxpz9PZ0+Jw3I3DbFB9slqjH46HGDp
X-Google-Smtp-Source: ABdhPJx5Bibj9V6qU5ghgBCcfNg6I9vHPB+nAFGyyg3XXOUzUX+9lezBNYRG6CoXkJWb/lWjaAGsSg==
X-Received: by 2002:a17:90a:6549:: with SMTP id f9mr7101302pjs.17.1611772455079;
        Wed, 27 Jan 2021 10:34:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h3sm3068216pgm.67.2021.01.27.10.34.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 10:34:14 -0800 (PST)
Message-ID: <6011b226.1c69fb81.ad15c.6fb6@mx.google.com>
Date:   Wed, 27 Jan 2021 10:34:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.253
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 98 runs, 11 regressions (v4.4.253)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 98 runs, 11 regressions (v4.4.253)

Regressions Summary
-------------------

platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
panda               | arm    | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-virt-gicv2 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_i386-uefi      | i386   | lab-broonie   | gcc-8    | i386_defconfig   =
   | 1          =

qemu_x86_64         | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.253/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.253
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4f907dff9d3629fc87f9608770168b68958a9f46 =



Test Regressions
---------------- =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
panda               | arm    | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60117fde89456b9b67d3e013

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.253=
/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.253=
/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60117fde89456b9=
b67d3e018
        failing since 7 days (last pass: v4.4.252-19-ga5d48e0086e76, first =
fail: v4.4.252)
        2 lines

    2021-01-27 14:59:35.895000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/113
    2021-01-27 14:59:35.903000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff26c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60117fa440fe8eff15d3dfd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.253=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.253=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60117fa440fe8eff15d3d=
fd5
        failing since 74 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60117f3ba1887124e9d3e0c6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.253=
/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.253=
/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60117f3ba1887124e9d3e=
0c7
        failing since 74 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/6011800c30bdde3ec9d3dfd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.253=
/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.253=
/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6011800c30bdde3ec9d3d=
fd8
        failing since 74 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60117ff030bdde3ec9d3dfce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.253=
/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.253=
/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-virt-gicv2.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60117ff030bdde3ec9d3d=
fcf
        failing since 74 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60117f403904548b0dd3dfd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.253=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.253=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60117f403904548b0dd3d=
fd7
        failing since 74 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60117f7ef0d2285068d3dfc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.253=
/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.253=
/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60117f7ef0d2285068d3d=
fca
        failing since 74 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60117fb640fe8eff15d3dfea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.253=
/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.253=
/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60117fb640fe8eff15d3d=
feb
        failing since 74 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/60117fbf2f8d464324d3dfd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.253=
/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.253=
/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-virt-gicv3.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60117fbf2f8d464324d3d=
fd3
        failing since 74 days (last pass: v4.4.243-14-gcb8e837cb602, first =
fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_i386-uefi      | i386   | lab-broonie   | gcc-8    | i386_defconfig   =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60117fc989456b9b67d3dfd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.253=
/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.253=
/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60117fc989456b9b67d3d=
fd2
        new failure (last pass: v4.4.253-21-g410eafab40b1) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_x86_64         | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60117e6a3cc5d6ac1dd3dff5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.253=
/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.253=
/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60117e6a3cc5d6ac1dd3d=
ff6
        new failure (last pass: v4.4.253-21-g410eafab40b1) =

 =20
