Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35683DB26D
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 06:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhG3ElP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Jul 2021 00:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbhG3ElO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Jul 2021 00:41:14 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5AD5C061765
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 21:41:09 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso12664128pjo.1
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 21:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qnk9hqL5RACOPDlkz+WqGGNi8DAWVrnwkGeMC6zZCKM=;
        b=m/6uYyno+lqa0/aQEmeCr/0U+FhKoaraG246HHt5Jl89Y1A3BJX8h3qQXkoLGGwgYN
         9lkTj8dGdYeLAJabFT4Wx2vShUcnPpvzktiSuALXDfP6yiACTLtQUQe02R3/Q0SXQMle
         zAlnHpzmQGSVzYEhPTLJMuozjaUw1asroRl/3AbmXzh+ytXHQria7qXymJlJnM2gUv5W
         Y6mnFqBRL8//lyN1aaNRQm4Hmx2i5ZRRIu8Gc+sxGnDc9Rirc1eZapKydq1ezO+GNZQJ
         54JpR9VN9vnQEW+bPHigvhYwdWC0vCyQoRxZu6i/POoT76QmHxbKKHW7is/XB+ggFl+K
         YQEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qnk9hqL5RACOPDlkz+WqGGNi8DAWVrnwkGeMC6zZCKM=;
        b=s4q/siY+5dbR6LcqrOF3eG65ZlytlpeFrArmBut70+S5ipDnIWb+f4MBWrN0h3vTuB
         jIXPNmI4Qzns5BouQJDGkPlRrxRZoLK+0DwUpHgkNWZttxLCaKfR/8k/E7Bpz2OhSdN+
         pKtr/Ns0hxbl5+N1LOD4sdZK4X4gUlySi4mgdFiCCkDnbcr71Z68LiFU3dVg+WI0jlaE
         KQZPu2c985QkoroP0JkDNqggCMgCmy7nUNxh8Iy2WjNl8rPEQS72MA36cgNKjftWcTda
         omkS17/KmTXrRNHbc2JlaoiyKKWKBh73wE4uVwrrxCUGf7JpUHXhivdoejUchu0QY5di
         d1fw==
X-Gm-Message-State: AOAM532cGzxhqZaeoU+oiDByAYUrh9VSOO++cp7cSV/0egIjZ6pP5uIr
        HCvzxk63JdIV3k3KNRVXyBVil6cV6Y5JDE4Q
X-Google-Smtp-Source: ABdhPJxClKo2Qqi6L9IgKH6SZySTboVLt8mdA/Urt8V9NCJ0K5Dyr8E+mUIfLKDDmugEqmZzR6sCHQ==
X-Received: by 2002:a17:90a:1f43:: with SMTP id y3mr1023576pjy.0.1627620068893;
        Thu, 29 Jul 2021 21:41:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z21sm513951pjh.19.2021.07.29.21.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 21:41:08 -0700 (PDT)
Message-ID: <610382e4.1c69fb81.87f9f.1d00@mx.google.com>
Date:   Thu, 29 Jul 2021 21:41:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.277-10-g7d39dda8af40
Subject: stable-rc/queue/4.4 baseline: 83 runs,
 8 regressions (v4.4.277-10-g7d39dda8af40)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 83 runs, 8 regressions (v4.4.277-10-g7d39dda8=
af40)

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
el/v4.4.277-10-g7d39dda8af40/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.277-10-g7d39dda8af40
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7d39dda8af40a61a8b1d7105faef6d8fe307d2b7 =



Test Regressions
---------------- =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
beagle-xm           | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig=
 | 2          =


  Details:     https://kernelci.org/test/plan/id/61034d1dfc6450254c5018c9

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
0-g7d39dda8af40/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
0-g7d39dda8af40/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61034d1dfc645025=
4c5018cf
        failing since 0 day (last pass: v4.4.276-46-g56094b963ae9, first fa=
il: v4.4.277-10-g3def64b8a44b)
        1 lines

    2021-07-30T00:51:23.599933  =

    2021-07-30T00:51:23.703867  / # #
    2021-07-30T00:51:23.704446  =

    2021-07-30T00:51:23.805743  / # #export SHELL=3D/bin/sh
    2021-07-30T00:51:23.806132  =

    2021-07-30T00:51:23.907265  / # export SHELL=3D/bin/sh. /lava-623516/en=
vironment
    2021-07-30T00:51:23.907645  =

    2021-07-30T00:51:24.008700  / # . /lava-623516/environment/lava-623516/=
bin/lava-test-runner /lava-623516/0
    2021-07-30T00:51:24.009881  =

    2021-07-30T00:51:24.011541  / # /lava-623516/bin/lava-test-runner /lava=
-623516/0 =

    ... (8 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61034d1dfc64502=
54c5018d1
        failing since 0 day (last pass: v4.4.276-46-g56094b963ae9, first fa=
il: v4.4.277-10-g3def64b8a44b)
        28 lines

    2021-07-30T00:51:24.523019  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-07-30T00:51:24.529135  kern  :emerg : Process udevd (pid: 108, sta=
ck limit =3D 0xcb932218)
    2021-07-30T00:51:24.534065  kern  :emerg : Stack: (0xcb933d10 to 0xcb93=
4000)
    2021-07-30T00:51:24.542789  kern  :emerg : 3d00:                       =
              bf03283c bf017b84 cb923010 bf0328c8
    2021-07-30T00:51:24.555050  kern  :emerg : 3d20: cb923010 bf1fb0a8 0000=
0002 cb[   50.182708] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Df=
ail UNITS=3Dlines MEASUREMENT=3D28>   =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61034ea0c6026062695018c1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
0-g7d39dda8af40/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
0-g7d39dda8af40/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61034ea0c602606269501=
8c2
        failing since 258 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61035047b5b7939c375018c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
0-g7d39dda8af40/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
0-g7d39dda8af40/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61035047b5b7939c37501=
8c3
        failing since 258 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/610353575d22929c015018df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
0-g7d39dda8af40/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
0-g7d39dda8af40/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610353575d22929c01501=
8e0
        failing since 258 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61034e77da328d310e5018d6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
0-g7d39dda8af40/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
0-g7d39dda8af40/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61034e77da328d310e501=
8d7
        failing since 258 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61034fea19a361cf225018e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
0-g7d39dda8af40/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
0-g7d39dda8af40/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61034fea19a361cf22501=
8e6
        failing since 258 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/610352e1721df832195018d7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
0-g7d39dda8af40/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.277-1=
0-g7d39dda8af40/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610352e1721df83219501=
8d8
        failing since 258 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =20
