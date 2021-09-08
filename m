Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1311404017
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 22:12:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350438AbhIHUNU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 16:13:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348220AbhIHUNT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 16:13:19 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1092C061757
        for <stable@vger.kernel.org>; Wed,  8 Sep 2021 13:12:11 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso2118924pjh.5
        for <stable@vger.kernel.org>; Wed, 08 Sep 2021 13:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=G5m+z8GsK48Fso0acQmD5C+kbXudW+uJEAiZARGKvuI=;
        b=hIU0AN7+gEqLjqBJB5Am7fhPd7hXMWpN3RjE1xcE7chIhyYJCHSag0LDLKWt0yrAEK
         CFrLirZzNdskC34gIg9DCwXEfzy4vgzT3SklQwbNMtunbkpQhJDrE0NSYQGNopJ0b0kx
         OmBs8V9KrSRUiYX27Xo/J1JK4Veh732QWEtL6uzhMsVnTDos6Zf6BK4c6xOhvds9s8k9
         zCuREJjjTJIBMPHzzRjK0cvxntB/kJH2Btx4wiqFGer0UhLyzKY+rc4p8oHKE2tTk6pP
         Jp87TnlJ3FmwdxWWT7g3eCg+6N09WTNRsc99aSkF1QThQy6cMluEzzelyVJ3RK8J3YFl
         9Bmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=G5m+z8GsK48Fso0acQmD5C+kbXudW+uJEAiZARGKvuI=;
        b=lwPqx8Kg4NtmU4qiWahxKKDdPlprsWNgEE9HGZgeqiYOaTezTELW5TXh1p1r39qoRQ
         iR/bIZhMC15rblxOj5KzSyMW0POfn9cbzBEBvUAUq1EF4hZrGMoBM5bCzfgxgm15s3oz
         syiRxiNh6BEE2RoN3Pi9QUvxiKoFN3RieYCRAybg0THhW/IvQeYU2iv6KhMEa7sJQuHN
         UBCkb40DTVNyUwFz3vtuafl01DsQi1mF55/RRk66NY9Jd+oj14X07NHRW+k57T1dF7it
         3J+kgDNDBvh/9s9X9SvHWrOVJO6MzR5aMLDLVZBEzzUelztzagtDYbgwefl966B12MZJ
         pq0A==
X-Gm-Message-State: AOAM533TIzcp6O/yTPQ70AFjb3VnjVuePn4xlQSXvf/77vRPpB+90NMR
        XApVH5YdOqEiFp9S5SyPvgy0bkrvVhteWZeW
X-Google-Smtp-Source: ABdhPJzQTgcR17wPFpTL9nlGB0LlaR68+NAf8GKVvzylrn+gIRuKxFIs8LqJexQI9X5rSSEydpTlDw==
X-Received: by 2002:a17:90a:7301:: with SMTP id m1mr51932pjk.164.1631131930880;
        Wed, 08 Sep 2021 13:12:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t9sm61525pfe.73.2021.09.08.13.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 13:12:10 -0700 (PDT)
Message-ID: <6139191a.1c69fb81.37848.0511@mx.google.com>
Date:   Wed, 08 Sep 2021 13:12:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.283-25-gffed6cf754be
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 123 runs,
 9 regressions (v4.4.283-25-gffed6cf754be)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 123 runs, 9 regressions (v4.4.283-25-gffed6cf=
754be)

Regressions Summary
-------------------

platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g           | 1          =

qemu_arm-virt-gicv2 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g           | 1          =

qemu_arm-virt-gicv2 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g           | 1          =

qemu_arm-virt-gicv2 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g           | 1          =

qemu_arm-virt-gicv3 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g           | 1          =

qemu_x86_64-uefi    | x86_64 | lab-broonie   | gcc-8    | x86_64_defcon...6=
-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.283-25-gffed6cf754be/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.283-25-gffed6cf754be
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ffed6cf754be9d5cf1c5163b58bf7eacbdff52de =



Test Regressions
---------------- =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/6138e58e03039e218cd5968b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-2=
5-gffed6cf754be/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-2=
5-gffed6cf754be/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138e58e03039e218cd59=
68c
        failing since 298 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv2 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/6138eced2e007c3775d5969a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-2=
5-gffed6cf754be/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-2=
5-gffed6cf754be/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138eced2e007c3775d59=
69b
        failing since 298 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv2 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/6138e5bdec2a9d47b1d59675

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-2=
5-gffed6cf754be/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-2=
5-gffed6cf754be/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138e5bdec2a9d47b1d59=
676
        failing since 298 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv2 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/6138e68569e6a7a46bd59671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-2=
5-gffed6cf754be/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-2=
5-gffed6cf754be/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138e68569e6a7a46bd59=
672
        failing since 298 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv3 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/6138e57ad060def6f9d596c9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-2=
5-gffed6cf754be/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-2=
5-gffed6cf754be/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138e57ad060def6f9d59=
6ca
        failing since 298 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv3 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/6138ecec2e007c3775d59697

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-2=
5-gffed6cf754be/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-2=
5-gffed6cf754be/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138ecec2e007c3775d59=
698
        failing since 298 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv3 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/6138e5afc405e98830d5968d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-2=
5-gffed6cf754be/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-2=
5-gffed6cf754be/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138e5afc405e98830d59=
68e
        failing since 298 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_arm-virt-gicv3 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/6138e64cef01f2381ed59667

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-2=
5-gffed6cf754be/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-2=
5-gffed6cf754be/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138e64cef01f2381ed59=
668
        failing since 298 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
qemu_x86_64-uefi    | x86_64 | lab-broonie   | gcc-8    | x86_64_defcon...6=
-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6138ea936596a9e156d596a8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-2=
5-gffed6cf754be/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/ba=
seline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-2=
5-gffed6cf754be/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/ba=
seline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138ea936596a9e156d59=
6a9
        new failure (last pass: v4.4.283-25-gea9fbdf4004a) =

 =20
