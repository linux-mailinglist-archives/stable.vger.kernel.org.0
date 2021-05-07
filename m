Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE14376D3D
	for <lists+stable@lfdr.de>; Sat,  8 May 2021 01:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhEGXX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 19:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbhEGXX0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 19:23:26 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8177C061574
        for <stable@vger.kernel.org>; Fri,  7 May 2021 16:22:24 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id z18so2443043plg.8
        for <stable@vger.kernel.org>; Fri, 07 May 2021 16:22:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4bQlLFqOBBlUSUWLUGr0gpY1ysSQVhwIKJjZUJdFSBU=;
        b=oW3JouUPGIraHbYB8zwYvdLpA5/jeMx3gvUadpFwjPQZ6D625ZJUvSA8Q3thcMDEhM
         t9WZKJ09NL3bvomgymf2h2IExkoSqOKUAiotRlgT1HVk0AfuRQ22i7zA0nbWMgIDFyxN
         NOuQinocxpuCrAT+TaGUh9HP82zPZ/bTJnQv2hJG3SfGfBHBS18//aWqpcuIh1h4nozq
         M8UTxFZA8dORQFpf7Ln4oEuzfrcSz8dQZTxAOav54z0ugHLm3sccAfcEnAI91Hug1LEF
         7git+JSue8mTzV95NAqzYt+s1jxyVMDG0fcsmUeMhkoWda22YlBNNTyv3kkztF2jIEOx
         NHkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4bQlLFqOBBlUSUWLUGr0gpY1ysSQVhwIKJjZUJdFSBU=;
        b=tZuiyb/PhCqUkOzEXzKfRZRGJxj4mlnGJclgKA0Ngc+LYVJPGz9zpZRKBeSVzdu/dU
         nmFq2eIEOiMhKRd7s9/lLjJ7h0jRiOcSXutgZpWY54FoETyxtjDK7NFh/4YC/E5MXjQr
         FRid08Ehp+wZoQmfWQz7QohjazAFibqsN8vQbYZgQajsYITYwao3CXVj2XfYHcPbWGv+
         3zguvPNQ5KPRYMvZz8aWQ29MLUdgoFnblRZIo8SdRqvE/Wf3xQ2NDt7xhvY4DkhmFj3K
         sLuRq1TjmdUImJohLYZt9mb4NHbRMODkGlZtjx3DXkyGw1AdUcCkyuqRATqd6xBjiysO
         MGSw==
X-Gm-Message-State: AOAM530aniXm9N0e7GT9h+GT/dQuF91GQWJyKdiTEWLpaHXOZ7C1gcLI
        9t4AKshDxRZRmECobxrMjdGeXu64zgN4cSjH
X-Google-Smtp-Source: ABdhPJwnAZyqO6lcsDiATvArbwq/cfxrRb2ylSkvROmDrKMp7bDXVZay98Jzxk5wQFGTTJikcjSlJA==
X-Received: by 2002:a17:902:8c97:b029:ee:f8c1:7bbe with SMTP id t23-20020a1709028c97b02900eef8c17bbemr12751466plo.8.1620429744084;
        Fri, 07 May 2021 16:22:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j79sm3564884pfd.184.2021.05.07.16.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 16:22:23 -0700 (PDT)
Message-ID: <6095cbaf.1c69fb81.afb16.bf96@mx.google.com>
Date:   Fri, 07 May 2021 16:22:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.268-14-g745cd6554a55
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 78 runs,
 9 regressions (v4.4.268-14-g745cd6554a55)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 78 runs, 9 regressions (v4.4.268-14-g745cd655=
4a55)

Regressions Summary
-------------------

platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_x86_64         | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.268-14-g745cd6554a55/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.268-14-g745cd6554a55
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      745cd6554a5535d794f5daf90fea01947ad022b7 =



Test Regressions
---------------- =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60959218de5bd9a5266f5476

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-1=
4-g745cd6554a55/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-1=
4-g745cd6554a55/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60959218de5bd9a5266f5=
477
        failing since 174 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60959238e0323745356f5498

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-1=
4-g745cd6554a55/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-1=
4-g745cd6554a55/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60959238e0323745356f5=
499
        failing since 174 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60959208bd783860756f5467

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-1=
4-g745cd6554a55/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-1=
4-g745cd6554a55/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60959208bd783860756f5=
468
        failing since 174 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60959211de5bd9a5266f546a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-1=
4-g745cd6554a55/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-1=
4-g745cd6554a55/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60959211de5bd9a5266f5=
46b
        failing since 174 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60959219f6dfa823886f5467

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-1=
4-g745cd6554a55/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-1=
4-g745cd6554a55/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60959219f6dfa823886f5=
468
        failing since 174 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6095923950b6cc23336f5491

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-1=
4-g745cd6554a55/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-1=
4-g745cd6554a55/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6095923950b6cc23336f5=
492
        failing since 174 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60959232f6dfa823886f5479

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-1=
4-g745cd6554a55/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-1=
4-g745cd6554a55/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60959232f6dfa823886f5=
47a
        failing since 174 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6095920550b6cc23336f5470

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-1=
4-g745cd6554a55/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-1=
4-g745cd6554a55/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6095920550b6cc23336f5=
471
        failing since 174 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
  | regressions
--------------------+--------+---------------+----------+------------------=
--+------------
qemu_x86_64         | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/609591227cf99746606f5479

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-1=
4-g745cd6554a55/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86=
_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.268-1=
4-g745cd6554a55/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86=
_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609591227cf99746606f5=
47a
        new failure (last pass: v4.4.268-13-g23948c626e12) =

 =20
