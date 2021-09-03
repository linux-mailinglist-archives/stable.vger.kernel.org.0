Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E99F4006B3
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 22:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236901AbhICUgk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 16:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233814AbhICUgk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 16:36:40 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3541C061575
        for <stable@vger.kernel.org>; Fri,  3 Sep 2021 13:35:39 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id k17so257671pls.0
        for <stable@vger.kernel.org>; Fri, 03 Sep 2021 13:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VAZ0oFh4X7xpzzFEzHh/By0rXT4NLZdUpBVp1mgAzPs=;
        b=SgyMrXIuRydK8FLgJOID6pePkVA7OCDa6kFD836xBr5Q0yKcuEMoDk9zDdYNLqvyoa
         EqOIgjbXUxRBzANDN5JXvrgCzJ+fkbfV7NmqIJb6T5niUTIjEjFsS8ClgC/lKjbMMM3i
         uvyz2mTL2S/8XCPP0qDJzvkGUQrKUdSC9nKhP7O4BH8I8qcgnXeQm5f2jlHcaxynHYLq
         cqnTgMgoAl4+R8Jz4SFAQC081PspYhghrTeh1OGTPKPcID1nPOZBo1qia5T9AhtElcBM
         AOZNsPM0AjnCMtOKBCJ2AxKq4v/4hCPUT4MxByOCnUxPH3+ikyqbn5tc5tyKCcUIOwmh
         10sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VAZ0oFh4X7xpzzFEzHh/By0rXT4NLZdUpBVp1mgAzPs=;
        b=UGAaGHmtSQfLuL0Z6FEceLD/RyviYUqGXGpjfJDwormdg86JLXLH5rs+xDDQ7lf17w
         KyEu4G90BPv1NDgMER3HDy2CC+y2lGbZ2yBnsIyd2qJeob/8zh7rhdroIHwGVVAknPcT
         ll1WV6FdbyCNEG9/ZRI1T/WBcGLEVkRliTMHDFYBuXGeYxC6pkC2llfmlMIDAQLvMX6x
         wGjsNapGCvdIk+o8QZi8OUB3xsyasb946x9RfJiJzQuX17XIKEascP3KV6RUvev8WTKe
         XiblPHdUpBhex4sWrtdWPPWD5Y2Q1IlD+eh+y7icabBpDydAFGPHN0/xFQmQzD/kP6ux
         tlgw==
X-Gm-Message-State: AOAM533+nzKEL5Cy5jFwElkpeH4LbpHZwx7ICU4ryfxw8YXvDjcuDSrr
        LEuwzalTMdObXAifkekDL101gbsKPqu49kyA
X-Google-Smtp-Source: ABdhPJymeFUouoxEyTLPE8v8zG+lO/daBiBU4JoPgt7hI0PyFe3oHbwsDTtmyP+5tai3XNkMRujkRQ==
X-Received: by 2002:a17:90a:bd08:: with SMTP id y8mr663449pjr.123.1630701338903;
        Fri, 03 Sep 2021 13:35:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z131sm229447pfc.159.2021.09.03.13.35.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 13:35:38 -0700 (PDT)
Message-ID: <6132871a.1c69fb81.12402.11f6@mx.google.com>
Date:   Fri, 03 Sep 2021 13:35:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.283-1-gc1a7ae0d83fa
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 98 runs,
 8 regressions (v4.4.283-1-gc1a7ae0d83fa)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 98 runs, 8 regressions (v4.4.283-1-gc1a7ae0d8=
3fa)

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
el/v4.4.283-1-gc1a7ae0d83fa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.283-1-gc1a7ae0d83fa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c1a7ae0d83fa9ffd43fc2a2034339b8579d057e6 =



Test Regressions
---------------- =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
beagle-xm           | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig =
| 2          =


  Details:     https://kernelci.org/test/plan/id/613253037e1d10e99cd5967d

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
-gc1a7ae0d83fa/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
-gc1a7ae0d83fa/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/613253037e1d10e9=
9cd59683
        failing since 3 days (last pass: v4.4.282-5-geb745ac888ff, first fa=
il: v4.4.282-7-gae87bd189213)
        1 lines

    2021-09-03T16:53:05.489268  / # #
    2021-09-03T16:53:05.490162  =

    2021-09-03T16:53:05.593457  / # #
    2021-09-03T16:53:05.594024  =

    2021-09-03T16:53:05.695165  / # #export SHELL=3D/bin/sh
    2021-09-03T16:53:05.695545  =

    2021-09-03T16:53:05.796695  / # export SHELL=3D/bin/sh. /lava-792089/en=
vironment
    2021-09-03T16:53:05.797045  =

    2021-09-03T16:53:05.898216  / # . /lava-792089/environment/lava-792089/=
bin/lava-test-runner /lava-792089/0
    2021-09-03T16:53:05.899142   =

    ... (10 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/613253037e1d10e=
99cd59685
        failing since 3 days (last pass: v4.4.282-5-geb745ac888ff, first fa=
il: v4.4.282-7-gae87bd189213)
        28 lines

    2021-09-03T16:53:06.361114  [   50.036529] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-09-03T16:53:06.413096  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-09-03T16:53:06.418820  kern  :emerg : Process udevd (pid: 106, sta=
ck limit =3D 0xcb90e218)
    2021-09-03T16:53:06.423121  kern  :emerg : Stack: (0xcb90fd10 to 0xcb91=
0000)
    2021-09-03T16:53:06.431466  kern  :emerg : fd00:                       =
              bf02b83c bf010b84 cb96c410 bf02b8c8   =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/61325287fb8a99d50ed59696

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
-gc1a7ae0d83fa/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
-gc1a7ae0d83fa/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61325287fb8a99d50ed59=
697
        failing since 293 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie  | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6132565bf835b783cbd59683

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
-gc1a7ae0d83fa/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
-gc1a7ae0d83fa/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6132565bf835b783cbd59=
684
        failing since 293 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/613254d14966186605d5967c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
-gc1a7ae0d83fa/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
-gc1a7ae0d83fa/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613254d14966186605d59=
67d
        failing since 293 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6132524bbec154548ad59681

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
-gc1a7ae0d83fa/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
-gc1a7ae0d83fa/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6132524bbec154548ad59=
682
        failing since 293 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie  | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6132561ea48b7dd501d59693

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
-gc1a7ae0d83fa/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
-gc1a7ae0d83fa/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6132561ea48b7dd501d59=
694
        failing since 293 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/613254b128c75d99cbd59694

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
-gc1a7ae0d83fa/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
-gc1a7ae0d83fa/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613254b128c75d99cbd59=
695
        failing since 293 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =20
