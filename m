Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980D6427E7D
	for <lists+stable@lfdr.de>; Sun, 10 Oct 2021 05:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhJJDOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 23:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbhJJDOU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Oct 2021 23:14:20 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6853EC061570
        for <stable@vger.kernel.org>; Sat,  9 Oct 2021 20:12:22 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 187so11603406pfc.10
        for <stable@vger.kernel.org>; Sat, 09 Oct 2021 20:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=O44V/ECrn8Auw+E17yB/Y96xtLTueoPZl7/GkH3RW84=;
        b=KVlmVqE6mSccjrayjf0pR9SK2YTUc6iKUZ+baO+69J5M1FZ5KAXs1HlIKk+2i6meed
         rqCL6oqCNvzU41fDEXgU+gGEbTLLOsoh6R+dWXJzJ1rKVQ2TDCGhh+9tS5hHaP7oUWN5
         fzE9PFIJQE9O65Wb/FMQzhx3w01DEnKnxJI5JhtBN9EqQaIatL2K6l133wEO4trMMX5h
         wBGwyuIwRG8E2q4fwxtneXDXG9YMBD1ZQ+Y+437IbSSM/F2thnFn2G5Q1y3zkztLTs+a
         2kRpEItg3DIKoF1DWUNUMfWV3VbRkhkbJd09BpDgpCef9vcMosyoeoHdis6lbJ5PZz0+
         YiZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=O44V/ECrn8Auw+E17yB/Y96xtLTueoPZl7/GkH3RW84=;
        b=gX09xazXsYbObcfoREyBfr8qRupSijSOzf6LZO6buRRqL2OGy31jCcd1Znqd9AcA1F
         WfNdD/tx/9ts5hMF0VkXSVkknam0DnctBoNUl3b1JklkTiYpriQzB9dtSUwVZzUqdFyH
         PCJHTPlwggcVi7BYJHN2iJaohWfZK24WpyFnzjjrLgyO3mkNUWaXNMB6h9lh7V6X7Im+
         gr6R4v9rTj9a9U1ntOzl92ZfsU4HH1AkU1iQ5Gw+fRZISmMSetcBpXls+2NgvOBFxE5A
         lJVNGFbC/sieylqH+7nIIkHpobgYiCeyDvgcwOjpOMHR4834YxZUEgiqhvOeFXa1ACq7
         QxcA==
X-Gm-Message-State: AOAM533bGU9uwZM9pGpwV6u7qpaJsYBlsp7JLn9zH31gA7PhuIJpFBby
        CP4EytKoC34btiE+4J4QOuWyW1VLgVBzQaHm
X-Google-Smtp-Source: ABdhPJzFJxwAuEPqQLQlSCYYw1dbHt1y0aoPy2FqbhTTu6nqIvuGiBLLOSujIjuSbSehNo1HmNDfdA==
X-Received: by 2002:a63:f749:: with SMTP id f9mr12398561pgk.77.1633835541491;
        Sat, 09 Oct 2021 20:12:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m186sm3445416pfb.165.2021.10.09.20.12.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 20:12:21 -0700 (PDT)
Message-ID: <61625a15.1c69fb81.39b3f.a012@mx.google.com>
Date:   Sat, 09 Oct 2021 20:12:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.288-3-g3ddb0794ea78
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 105 runs,
 10 regressions (v4.4.288-3-g3ddb0794ea78)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 105 runs, 10 regressions (v4.4.288-3-g3ddb079=
4ea78)

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

qemu_arm-virt-gicv2 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.288-3-g3ddb0794ea78/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.288-3-g3ddb0794ea78
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3ddb0794ea78cb4d70cd7442de2ba344e9a6a45c =



Test Regressions
---------------- =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
beagle-xm           | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig=
 | 2          =


  Details:     https://kernelci.org/test/plan/id/61621f172ca641835d99a2f5

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-3=
-g3ddb0794ea78/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-3=
-g3ddb0794ea78/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61621f172ca64183=
5d99a2fb
        new failure (last pass: v4.4.287-7-gc30cf7335f7d)
        1 lines

    2021-10-09T23:00:23.026991  / #
    2021-10-09T23:00:23.027749   #
    2021-10-09T23:00:23.130903  / # #
    2021-10-09T23:00:23.131430  =

    2021-10-09T23:00:23.232750  / # #export SHELL=3D/bin/sh
    2021-10-09T23:00:23.233160  =

    2021-10-09T23:00:23.334281  / # export SHELL=3D/bin/sh. /lava-936205/en=
vironment
    2021-10-09T23:00:23.334621  =

    2021-10-09T23:00:23.435808  / # . /lava-936205/environment/lava-936205/=
bin/lava-test-runner /lava-936205/0
    2021-10-09T23:00:23.436862   =

    ... (10 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61621f172ca6418=
35d99a2fd
        new failure (last pass: v4.4.287-7-gc30cf7335f7d)
        28 lines

    2021-10-09T23:00:23.897547  [   49.992614] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-09T23:00:23.949539  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-10-09T23:00:23.955388  kern  :emerg : Process udevd (pid: 115, sta=
ck limit =3D 0xcb9c6218)
    2021-10-09T23:00:23.959753  kern  :emerg : Stack: (0xcb9c7d10 to 0xcb9c=
8000)
    2021-10-09T23:00:23.967940  kern  :emerg : 7d00:                       =
              bf02b83c bf010b84 cb959010 bf02b8c8   =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61621f0ff7f0162bb199a308

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-3=
-g3ddb0794ea78/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-3=
-g3ddb0794ea78/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61621f0ff7f0162bb199a=
309
        failing since 330 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6162309910898c3aa999a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-3=
-g3ddb0794ea78/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-3=
-g3ddb0794ea78/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6162309910898c3aa999a=
2db
        failing since 330 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61622036371757c36b99a2f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-3=
-g3ddb0794ea78/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-3=
-g3ddb0794ea78/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61622036371757c36b99a=
2f5
        failing since 330 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6162225bae1f7f225299a2f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-3=
-g3ddb0794ea78/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-3=
-g3ddb0794ea78/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6162225bae1f7f225299a=
2f5
        failing since 330 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61621ebe4e9aece83999a2e3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-3=
-g3ddb0794ea78/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-3=
-g3ddb0794ea78/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61621ebe4e9aece83999a=
2e4
        failing since 330 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie   | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/616230710e4daa8e5a99a2db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-3=
-g3ddb0794ea78/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-3=
-g3ddb0794ea78/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616230710e4daa8e5a99a=
2dc
        failing since 330 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61621f96a32a9dcc0899a358

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-3=
-g3ddb0794ea78/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-3=
-g3ddb0794ea78/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61621f96a32a9dcc0899a=
359
        failing since 330 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/616221cdd2aee7850299a30a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-3=
-g3ddb0794ea78/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.288-3=
-g3ddb0794ea78/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616221cdd2aee7850299a=
30b
        failing since 330 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =20
