Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2192DF067
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 17:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgLSQPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 11:15:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgLSQPx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 19 Dec 2020 11:15:53 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9FCC0613CF
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 08:15:12 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id w1so6055932pjc.0
        for <stable@vger.kernel.org>; Sat, 19 Dec 2020 08:15:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ki9v73Wer1eSB+iiSSbzK0lMq4tLbCoxPSI7a4dPUlo=;
        b=WH1ppNiwxTytv+8t9LfzwW6my9KDhHiS8iJhef/V8GNiW8sbeVC6o6ANz9YRMGnAc0
         h7UBHHO5FutFzZjPvifr34/U+R8bSOlV64QQ/YjVsIRUf08ZAeU69atnwbAInhr54bm/
         cNKWyBYpZqtNs28vj3Z2AZS9rqziUxPO8wli18PM8TnkzdBJrzqArnJllUY8cAxWtJ91
         ceTO5NCB2GQnwQKhqjj6yiv2sWsM5CyIlYU9W5tVKFFGX81iIdb+DcaxE/yBEW429ntI
         ECWPkd5GdCkrPsacOZHVo8BbqvoS1fcotjJWrt+OiM1vI0WaCOxfIa1Wk7PB+iahSXJ8
         IMiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ki9v73Wer1eSB+iiSSbzK0lMq4tLbCoxPSI7a4dPUlo=;
        b=P3s+Y6f1XYQxN7v00G6WWw/u2U3qBWetV6ahQnrlwKhnHtsFEEahkFObKgmpwV7zds
         YWD3ZPZUj3babv1WQRAHqXuMPsM4Zdl72Ao0+tP3Jj/AFYdQbVQdjXUlb79DFmRKM9/U
         GrZUkyDfwPRE575OAL735DPESTWoUi2erj6zpk3y5YySyXse/wKCp4ZYXj9AD9uhF3ll
         CKJunmX09QiROf07/ldZFNwkBn1TH/SdqkCvLWsqGvkzP3iifitqVPjcU+XqUhdiwmZG
         6zSrzoxygWpCn82RYepoABoQycEFOHJXbU5S0VOH4VsysQEEKOCx3QriuZuJg8Py6Oi9
         CjRQ==
X-Gm-Message-State: AOAM531HE0FY8uUZF+rtB/jMeaH33SARwiltAROMchS2lgE/LRMIUKfi
        oX4Wwu881563lLqbw5fku/1ULhVBnnFtAg==
X-Google-Smtp-Source: ABdhPJzpbEoYktc0zJ2z1pWem9gx/w59xFx9u77EcC9+E8Fcm+iT+ZRUuHLnIiYx5glO6xjDp1rIDA==
X-Received: by 2002:a17:90a:520e:: with SMTP id v14mr9623213pjh.9.1608394511903;
        Sat, 19 Dec 2020 08:15:11 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o14sm6857640pgr.44.2020.12.19.08.15.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Dec 2020 08:15:11 -0800 (PST)
Message-ID: <5fde270f.1c69fb81.af1d4.3415@mx.google.com>
Date:   Sat, 19 Dec 2020 08:15:11 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.248-20-g064f72560703
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 98 runs,
 11 regressions (v4.4.248-20-g064f72560703)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 98 runs, 11 regressions (v4.4.248-20-g064f725=
60703)

Regressions Summary
-------------------

platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
panda               | arm    | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =

qemu_arm-virt-gicv2 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig  | 1          =

qemu_arm-virt-gicv2 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig  | 1          =

qemu_arm-virt-gicv2 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig  | 1          =

qemu_arm-virt-gicv2 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig  | 1          =

qemu_i386           | i386   | lab-baylibre    | gcc-8    | i386_defconfig =
     | 1          =

qemu_x86_64         | x86_64 | lab-collabora   | gcc-8    | x86_64_defconfi=
g    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.248-20-g064f72560703/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.248-20-g064f72560703
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      064f72560703cdb2c966d06101540665a8a607da =



Test Regressions
---------------- =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
panda               | arm    | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddf4c431cad7fa58c94ce7

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
0-g064f72560703/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
0-g064f72560703/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fddf4c431cad7f=
a58c94cec
        failing since 2 days (last pass: v4.4.248-8-g93a7ed462351b, first f=
ail: v4.4.248-8-g682a596b505e8)
        2 lines =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddf56bb3103ad358c94cd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
0-g064f72560703/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
0-g064f72560703/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddf56bb3103ad358c94=
cd1
        failing since 35 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_arm-virt-gicv2 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddf562283fd9f940c94d05

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
0-g064f72560703/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
0-g064f72560703/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddf562283fd9f940c94=
d06
        failing since 35 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_arm-virt-gicv2 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddf564283fd9f940c94d08

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
0-g064f72560703/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
0-g064f72560703/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddf564283fd9f940c94=
d09
        failing since 35 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_arm-virt-gicv2 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddf565b78efcd725c94cbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
0-g064f72560703/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
0-g064f72560703/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddf565b78efcd725c94=
cbf
        failing since 35 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_arm-virt-gicv3 | arm    | lab-baylibre    | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddf565b3103ad358c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
0-g064f72560703/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
0-g064f72560703/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddf565b3103ad358c94=
cba
        failing since 35 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_arm-virt-gicv3 | arm    | lab-cip         | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddf568d0e3d618e9c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
0-g064f72560703/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
0-g064f72560703/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddf568d0e3d618e9c94=
cba
        failing since 35 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_arm-virt-gicv3 | arm    | lab-collabora   | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddf63b1daedf8394c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
0-g064f72560703/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
0-g064f72560703/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddf63b1daedf8394c94=
cba
        failing since 35 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_arm-virt-gicv3 | arm    | lab-linaro-lkft | gcc-8    | multi_v7_defcon=
fig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddf579584928446ec94cf0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
0-g064f72560703/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
0-g064f72560703/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddf579584928446ec94=
cf1
        failing since 35 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_i386           | i386   | lab-baylibre    | gcc-8    | i386_defconfig =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddf3db63fa7cf5aec94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
0-g064f72560703/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
0-g064f72560703/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddf3db63fa7cf5aec94=
cba
        new failure (last pass: v4.4.248-8-g682a596b505e8) =

 =



platform            | arch   | lab             | compiler | defconfig      =
     | regressions
--------------------+--------+-----------------+----------+----------------=
-----+------------
qemu_x86_64         | x86_64 | lab-collabora   | gcc-8    | x86_64_defconfi=
g    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fddf4d5f223ac71eac94ce8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
0-g064f72560703/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qemu_x=
86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.248-2=
0-g064f72560703/x86_64/x86_64_defconfig/gcc-8/lab-collabora/baseline-qemu_x=
86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fddf4d5f223ac71eac94=
ce9
        new failure (last pass: v4.4.248-8-g682a596b505e8) =

 =20
