Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660BE3E29FA
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 13:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245691AbhHFLpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 07:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245692AbhHFLpw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 07:45:52 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D80EC06179B
        for <stable@vger.kernel.org>; Fri,  6 Aug 2021 04:45:36 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id u16so6720642ple.2
        for <stable@vger.kernel.org>; Fri, 06 Aug 2021 04:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IfMAZQMARQxsggLzjKIlEum0zxS8Y0tP1sdre4+NM3o=;
        b=n257qxp0LcG8ZX/cqDEPRgUR4MySxMRLM2PyG3bSZf+jDIRRUwtR055ZaKxKNbHuo7
         b6QyIvFYPwERr+9jbzSCS0EdcSAcLpIr6jqqX3Qu6rnFPyGhGCWVv2mL15rdh+c+1MTi
         V3MaksyUihJjIAsuPVFJJIFOnVlVD3RbNHjGqiEmKxn5SbsG4GGxFgSrZnrH4GDoDbGt
         jYbFW33PPdKBtBS3wkd+WWupHEzC9TOMHFhK636nH33ivv6YRanPr5718c5SoKckJUzT
         h5hUA7tvvzifQ23CdRaNWDTI4DaJN4hBVGtno4iXNl7B5VqJfiAFZ8/x2j/ohw/Uzd+V
         sU6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IfMAZQMARQxsggLzjKIlEum0zxS8Y0tP1sdre4+NM3o=;
        b=SGGJ0aZo7/+NLp0H7GiMDkR3LpvGIVhLnbS2Jd5H+0sMAhqKW4vjhQZ9g0qE/I3ayF
         KH6Pn/2+y8KlKXvyV2jG/Re/gKdvj/lgrN/Db975BHEtxI0BtqzHvCvZ0PmI7xD4xPws
         sxMqRJjLtnxRD5J9Y8tIa8B+oUpKW2uUNvFTNiRBmpsbcK1WCpLDp+rs/EwddhmaeThx
         LDJtwnLd+R8KJO8Qn8PZIpV4VZ+9ZtmZ9UbQtBCJqiKM1pCREkj30SZRUkZn7/hJDYi1
         Rwf3tyts3JD9eu46cT4qDnZwkMjh7CWQFCmyhLWbHkT6/bVxwcD3qFj1F7W/AcxpMSfd
         YxfQ==
X-Gm-Message-State: AOAM531JEahydi67rIugoUUFYc1VliG25OXUANbNUcMZF0fcML2JkUUr
        rxKxpmJLyQDNHw6iGevbILKahBNsMsL7fw==
X-Google-Smtp-Source: ABdhPJxzkoWGicvPNd/zDgkqngVmB9WMo4Wnlnea5dMqnm94B2+j9s90itsJ70HQU7bypbxLKDsWTw==
X-Received: by 2002:a63:e70f:: with SMTP id b15mr734986pgi.182.1628250333347;
        Fri, 06 Aug 2021 04:45:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n123sm12131189pga.69.2021.08.06.04.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 04:45:32 -0700 (PDT)
Message-ID: <610d20dc.1c69fb81.77236.38de@mx.google.com>
Date:   Fri, 06 Aug 2021 04:45:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.278-6-gb5c110080728
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 66 runs,
 8 regressions (v4.4.278-6-gb5c110080728)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 66 runs, 8 regressions (v4.4.278-6-gb5c110080=
728)

Regressions Summary
-------------------

platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
beagle-xm           | arm  | lab-baylibre    | gcc-8    | omap2plus_defconf=
ig | 2          =

qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.278-6-gb5c110080728/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.278-6-gb5c110080728
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b5c1100807285640542b2b991ee294568b6155c6 =



Test Regressions
---------------- =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
beagle-xm           | arm  | lab-baylibre    | gcc-8    | omap2plus_defconf=
ig | 2          =


  Details:     https://kernelci.org/test/plan/id/610ce604ac9c51e14eb13684

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-6=
-gb5c110080728/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-6=
-gb5c110080728/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/610ce604ac9c51e1=
4eb13687
        new failure (last pass: v4.4.278-4-g5d1652b6a891)
        1 lines

    2021-08-06T07:34:14.937198  / # =

    2021-08-06T07:34:14.937908  #
    2021-08-06T07:34:15.041151  / # #
    2021-08-06T07:34:15.041670  =

    2021-08-06T07:34:15.142953  / # #export SHELL=3D/bin/sh
    2021-08-06T07:34:15.143365  =

    2021-08-06T07:34:15.244500  / # export SHELL=3D/bin/sh. /lava-655973/en=
vironment
    2021-08-06T07:34:15.244949  =

    2021-08-06T07:34:15.346193  / # . /lava-655973/environment/lava-655973/=
bin/lava-test-runner /lava-655973/0
    2021-08-06T07:34:15.347404   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/610ce604ac9c51e=
14eb13689
        new failure (last pass: v4.4.278-4-g5d1652b6a891)
        28 lines

    2021-08-06T07:34:15.859116  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-08-06T07:34:15.864485  kern  :emerg : Process udevd (pid: 105, sta=
ck limit =3D 0xcb8e6218)
    2021-08-06T07:34:15.869003  kern  :emerg : Stack: (0xcb8e7d10 to 0xcb8e=
8000)
    2021-08-06T07:34:15.877062  kern  :emerg : 7d00:                       =
              bf03883c bf01db84 cb96aa10 bf0388c8   =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/610ce8f9ffe20f7fa2b1368b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-6=
-gb5c110080728/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-6=
-gb5c110080728/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610ce8f9ffe20f7fa2b13=
68c
        failing since 265 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/610cea387d0a4a2705b13692

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-6=
-gb5c110080728/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-6=
-gb5c110080728/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610cea387d0a4a2705b13=
693
        failing since 265 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/610cea462f29fd0375b13662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-6=
-gb5c110080728/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-6=
-gb5c110080728/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610cea462f29fd0375b13=
663
        failing since 265 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/610ce988072fe222ceb13669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-6=
-gb5c110080728/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-6=
-gb5c110080728/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610ce988072fe222ceb13=
66a
        failing since 265 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-cip         | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/610cea437d0a4a2705b136b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-6=
-gb5c110080728/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-6=
-gb5c110080728/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610cea437d0a4a2705b13=
6b3
        failing since 265 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
   | regressions
--------------------+------+-----------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/610cea5bd999b92de7b13688

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-6=
-gb5c110080728/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.278-6=
-gb5c110080728/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610cea5bd999b92de7b13=
689
        failing since 265 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =20
