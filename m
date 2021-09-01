Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DE73FDD50
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236888AbhIANfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 09:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234332AbhIANfI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 09:35:08 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2C2C061575
        for <stable@vger.kernel.org>; Wed,  1 Sep 2021 06:34:12 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id e16so2062322pfc.6
        for <stable@vger.kernel.org>; Wed, 01 Sep 2021 06:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=X9LT1QoqkIhIIaZENVyT1SbyJlOwbvW5ENzCZFt52uQ=;
        b=U1DvjhP+X70/+TTjV26NPBj80KRIMUT8L4tuZRScaJgOeQrqTpx0ihHRYZntTxiFdY
         wLKUpnJErrjw/pbmsM6/p1l0mDyM/OmhQliB0YX1FxZOjOONa+SN0al9ColF78bT+vJv
         UcER1hvar6vB7cr1YxERSoRT3eSePJNBSUDdqqgq+eXsmPcwb6ZLcaLB+lRCMRtYsycM
         fDWxeUwy5djQVioCZpBaQJAUwecuMqnr25HjrnQyXWzTihlGspVY8tT5yRxfQeG+zswg
         5kBt9DCu8iWWvIrM+LXM7Ktx84uUeCoSzZItGkbHwV2oWjeLhCSxAUcrtsLZ+omT9UHZ
         Nu5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=X9LT1QoqkIhIIaZENVyT1SbyJlOwbvW5ENzCZFt52uQ=;
        b=rlUeS/IDkojgfYB9Kpn6JLX56DuwsJp69ySm1Vnxci9dRfzcEwGKSdEaj7oRwi4yai
         ON/qGXtMcZ1tFb41/r3L4sHDxpLuEPZlT+vJieiLTm55EsQ8vMmfaDJtQVxbFj4KRopn
         Zh+Of24zI0syIXw+7MIJ6KuzXODGvIpMRRaSLAk3iDlujB2dsSg+43QUSl93JOSeCOLy
         vYvk+KYZ4uFklIv7VqLJvKlJgiApPtND42Het+2ejLBcv6BlHsMo7DN7emAzbM3D2+jg
         E+tah+TpsDx8S1KwkImYOo0DNoWVcwvtp24QiujeR1FzpNW30L1iCozthIakpTCUmCRs
         WPGA==
X-Gm-Message-State: AOAM530j2fmGYSfPBFEIcNtOopDdNmgkgeUgRNsdxJproNPC1KYNy/rK
        HQvtpuK//5Pjh6vI78JecrFope1faoXSGU60
X-Google-Smtp-Source: ABdhPJzydtzzWXp+y7uMXclTmbHueI3gpSgYb2AsewCYNWNYZLZo/PcYcotiLxCUSbK6CBcTBXYufw==
X-Received: by 2002:a63:f242:: with SMTP id d2mr32811158pgk.384.1630503251441;
        Wed, 01 Sep 2021 06:34:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q7sm6187648pja.11.2021.09.01.06.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 06:34:10 -0700 (PDT)
Message-ID: <612f8152.1c69fb81.5cf08.0f4f@mx.google.com>
Date:   Wed, 01 Sep 2021 06:34:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.282-9-g91324741467c
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 89 runs,
 8 regressions (v4.4.282-9-g91324741467c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 89 runs, 8 regressions (v4.4.282-9-g913247414=
67c)

Regressions Summary
-------------------

platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
beagle-xm           | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig =
| 2          =

qemu_arm-virt-gicv2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-broonie  | gcc-8    | multi_v7_defconfig  =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig  =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie  | gcc-8    | multi_v7_defconfig  =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.282-9-g91324741467c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.282-9-g91324741467c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      91324741467c1bbdb3bc3e994bf1ab9c7eb4ed23 =



Test Regressions
---------------- =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
beagle-xm           | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig =
| 2          =


  Details:     https://kernelci.org/test/plan/id/612f4f6a4107837f7f8e2c97

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-9=
-g91324741467c/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-9=
-g91324741467c/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/612f4f6a4107837f=
7f8e2c9d
        failing since 1 day (last pass: v4.4.282-5-geb745ac888ff, first fai=
l: v4.4.282-7-gae87bd189213)
        1 lines

    2021-09-01T10:00:57.081164  / # =

    2021-09-01T10:00:57.081777  #
    2021-09-01T10:00:57.184939  / # #
    2021-09-01T10:00:57.185593  =

    2021-09-01T10:00:57.286897  / # #export SHELL=3D/bin/sh
    2021-09-01T10:00:57.287256  =

    2021-09-01T10:00:57.388378  / # export SHELL=3D/bin/sh. /lava-777015/en=
vironment
    2021-09-01T10:00:57.388741  =

    2021-09-01T10:00:57.489886  / # . /lava-777015/environment/lava-777015/=
bin/lava-test-runner /lava-777015/0
    2021-09-01T10:00:57.490936   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/612f4f6a4107837=
f7f8e2c9f
        failing since 1 day (last pass: v4.4.282-5-geb745ac888ff, first fai=
l: v4.4.282-7-gae87bd189213)
        28 lines

    2021-09-01T10:00:57.983417  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-09-01T10:00:57.989143  kern  :emerg : Process udevd (pid: 112, sta=
ck limit =3D 0xcb97e218)
    2021-09-01T10:00:57.993567  kern  :emerg : Stack: (0xcb97fd10 to 0xcb98=
0000)
    2021-09-01T10:00:58.001803  kern  :emerg : fd00:                       =
              bf02b83c bf010b84 cba46610 bf02b8c8   =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/612f4e384c2f56ea478e2c7d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-9=
-g91324741467c/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-9=
-g91324741467c/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612f4e384c2f56ea478e2=
c7e
        failing since 291 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie  | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/612f4ed24a905379648e2c77

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-9=
-g91324741467c/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-9=
-g91324741467c/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612f4ed24a905379648e2=
c78
        failing since 291 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/612f4e5fa27b5259588e2c89

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-9=
-g91324741467c/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-9=
-g91324741467c/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612f4e5fa27b5259588e2=
c8a
        failing since 291 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/612f4e39b160600f7f8e2c8b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-9=
-g91324741467c/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-9=
-g91324741467c/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612f4e39b160600f7f8e2=
c8c
        failing since 291 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie  | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/612f4ef97a0b6d39018e2c8d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-9=
-g91324741467c/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-9=
-g91324741467c/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612f4ef97a0b6d39018e2=
c8e
        failing since 291 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/612f4e6adb5d904cc98e2ca2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-9=
-g91324741467c/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.282-9=
-g91324741467c/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612f4e6adb5d904cc98e2=
ca3
        failing since 291 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =20
