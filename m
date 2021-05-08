Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49F19377155
	for <lists+stable@lfdr.de>; Sat,  8 May 2021 13:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230257AbhEHLJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 May 2021 07:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230234AbhEHLJs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 May 2021 07:09:48 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55288C061574
        for <stable@vger.kernel.org>; Sat,  8 May 2021 04:08:46 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id b15so9735589pfl.4
        for <stable@vger.kernel.org>; Sat, 08 May 2021 04:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2UnphZ4SpJoVhbSr4AtwEC9qJHiu7mH09SMKXAcg0jo=;
        b=lnOiVldj97jD/PhSkkMHip3dtKDSNUuXyUkw0a1AaQ3X2GZz/ebeF6GP0JtCcAfa8u
         qXCEhh3garIByuqPjEiVe4se0WuUi9haLkKr5PVNGyC9emvb7k7f1oOeWn5dO8AnM/Sa
         01csA4CxYi1/Xo9IxD35ysDZHyKJOyBVsZHKUibiKB+43rrTWGL5Y3+StJZbS+jrsqlQ
         BOqQ4G8mbGVI6JQCw6nZLMp8pyrQ6I12J4PNjZngCJU9/69/4TuIk/TwpyOzKHXElVHE
         l5tr4i6V52quFRVjwVOjceBNulX5WPgyzC6V3OsP6cFab6q8nEqWhDLWBkmGfIv/RJVK
         O6Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2UnphZ4SpJoVhbSr4AtwEC9qJHiu7mH09SMKXAcg0jo=;
        b=r0TL3gKhg4eLiW5GhLu8WUMoe5oxvfWbGoEOQtDW0xHU6XvhvRZsuuFEwyQ0xQR4F+
         R5JXXj6yBhOLzFy8KBQH1tFz9GFjTujJO+KjrdnVkBHyBylTv2TgTFE/Rq8cigZc3esp
         jSKRezLnlMCjSmidZOLhFAhppYtvqnloi76eGhG5WqI/8bCSUBWiOb83eJb6Tt+fwQfa
         BSagJEZEJuUW0ZMz50qu+uiyiDZdFag5LZWHLOd5jd/xh9f4j5SHbyio/5cs6CdMDQkG
         hsFjMtpHy3RlGL97uoAvT/HJJ3NAD4moohPV6sCKz0xW8vc57I/KAG3Aq5cFJSo38YJM
         MyXA==
X-Gm-Message-State: AOAM532rVYxho5aEyrbKRqvkD+lpGJoIQV9j5sU7gpzWQR13UyuMnvuv
        Ib1AOqXe9SyQtWb77a1GfZQ7uxn2DhTIQO/Q
X-Google-Smtp-Source: ABdhPJxA1WkHMO3yFse8ptd52cB6UgnMwELQnybQdchlET8E+uSClqXezvw8bQ+GLAQe/jVS1o41hw==
X-Received: by 2002:a63:4b21:: with SMTP id y33mr15123899pga.287.1620472125467;
        Sat, 08 May 2021 04:08:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b65sm6760124pga.83.2021.05.08.04.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 May 2021 04:08:45 -0700 (PDT)
Message-ID: <6096713d.1c69fb81.b90e2.4c2d@mx.google.com>
Date:   Sat, 08 May 2021 04:08:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.268-47-gb943c8386f9e
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 108 runs,
 6 regressions (v4.9.268-47-gb943c8386f9e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 108 runs, 6 regressions (v4.9.268-47-gb943c83=
86f9e)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.268-47-gb943c8386f9e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.268-47-gb943c8386f9e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b943c8386f9e580e558559d5a40f65bad3b3633f =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60963ee403c400cb0a6f546a

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-4=
7-gb943c8386f9e/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-4=
7-gb943c8386f9e/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60963ee403c400c=
b0a6f546f
        new failure (last pass: v4.9.268-15-g03886d347dda5)
        2 lines

    2021-05-08 07:33:52.653000+00:00  [   20.416748] usb 3-1.1: New USB dev=
ice found, idVendor=3D0424, idProduct=3Dec00
    2021-05-08 07:33:52.661000+00:00  [   20.416809] usb 3-1.1: New USB dev=
ice strings: Mfr=3D0, Product=3D0, SerialNumber=3D0
    2021-05-08 07:33:52.689000+00:00  [   20.455657] smsc95xx v1.0.5
    2021-05-08 07:33:52.718000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/126
    2021-05-08 07:33:52.726000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60963c2d6d9dadfe226f547e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-4=
7-gb943c8386f9e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-4=
7-gb943c8386f9e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60963c2d6d9dadfe226f5=
47f
        failing since 175 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60963c36b61275e8896f5467

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-4=
7-gb943c8386f9e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-4=
7-gb943c8386f9e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60963c36b61275e8896f5=
468
        failing since 175 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60963c3fb61275e8896f5473

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-4=
7-gb943c8386f9e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-4=
7-gb943c8386f9e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60963c3fb61275e8896f5=
474
        failing since 175 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60963bd53f525ca5366f5469

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-4=
7-gb943c8386f9e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-4=
7-gb943c8386f9e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60963bd53f525ca5366f5=
46a
        failing since 175 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60963c859e7c3a44db6f5468

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-4=
7-gb943c8386f9e/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-4=
7-gb943c8386f9e/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60963c859e7c3a44db6f5=
469
        failing since 175 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
