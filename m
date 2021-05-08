Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96AC377014
	for <lists+stable@lfdr.de>; Sat,  8 May 2021 08:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhEHG3F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 May 2021 02:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbhEHG3E (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 May 2021 02:29:04 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0410C061574
        for <stable@vger.kernel.org>; Fri,  7 May 2021 23:28:03 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id 10so9569200pfl.1
        for <stable@vger.kernel.org>; Fri, 07 May 2021 23:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RN2Nh+UN08mC0uEg+Ea9RlHmuV2fQOpEeXi3k907C3M=;
        b=Scvc92f0tZorm0wZUStLZJ5fajxfi1NhEpJyaSLj34xeQRwU6SjDPYkC/JehvfhQ60
         2pSy7qREaO6IZNI+vQ7m29H8o0xXZfmWkrqY5ITd4VJR3nNVo7Y+ZHXKK+paEHYdBDvd
         i1HhwwiO1+pStocBk4FnMe01PCcCDlenMQFojBRX5iIqUnnPDJCzs/v9q44SB1QxvOza
         Q7o8NCXZObVIMw6xCwBayqGRP2JCXAbpmC108gRT50HOyKlD1S1Cd0jFFkVIxY+SHTND
         SsfQvZRA/QDFaXDbfQmLpKxpZlxO/rGFsAjbPZda9c8WIsRh46mTxADmMHn5AtXtStTn
         ieEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RN2Nh+UN08mC0uEg+Ea9RlHmuV2fQOpEeXi3k907C3M=;
        b=i3I0esHap8PJJHjXQFbsRSyrFIw1aE3c6ou6RNkvw3Nzdgfj4gWp1Hg64gy3ha3m16
         WnKTr3uzT18F4QabfpTaD6ERoD8FnLAOqE+LaPelW8As6hfyWEN7EOP8/hUHzF1YO9fu
         iie9dfStAacY/2EEnSK8W1jiwPtfXjoi7KjKepIwCwcQS0q1N8qLaXNo99CwSuABPXip
         ECvC7CjLr0SIoDevkZP1R6CoBQuRinvT4LwEf85nXBQVc6qLnr0yJ8hAppqEYEnes64q
         Zl0cz2uSXfFgemxxMGk5kH7TguEVmfYhKKjW2bd6ywWwPU8c5kSkDat0e+fWTuF9hH82
         O4SA==
X-Gm-Message-State: AOAM533oknVlBmbvzpRP3lgtu1q9ngzNVo/Xt6YURQfIYwEcQ/bH1zJh
        sbd3wcC1cFcnqYGvMHseDv2QpOz6J54cFjZX
X-Google-Smtp-Source: ABdhPJxazjvTFT2RX+pUQE9Lk90bv+HpItL1JHpiBLi+xHkIoK29kykKEWSyYcG5PWEM44fs/HsAbg==
X-Received: by 2002:a65:62c5:: with SMTP id m5mr13710598pgv.319.1620455282959;
        Fri, 07 May 2021 23:28:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q23sm6160190pgt.42.2021.05.07.23.28.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 23:28:02 -0700 (PDT)
Message-ID: <60962f72.1c69fb81.1eeb1.359b@mx.google.com>
Date:   Fri, 07 May 2021 23:28:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.190-22-g9e71e8407589
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 128 runs,
 7 regressions (v4.19.190-22-g9e71e8407589)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 128 runs, 7 regressions (v4.19.190-22-g9e71e=
8407589)

Regressions Summary
-------------------

platform                     | arch | lab             | compiler | defconfi=
g           | regressions
-----------------------------+------+-----------------+----------+---------=
------------+------------
panda                        | arm  | lab-collabora   | gcc-8    | omap2plu=
s_defconfig | 1          =

qemu_arm-versatilepb         | arm  | lab-baylibre    | gcc-8    | versatil=
e_defconfig | 1          =

qemu_arm-versatilepb         | arm  | lab-broonie     | gcc-8    | versatil=
e_defconfig | 1          =

qemu_arm-versatilepb         | arm  | lab-cip         | gcc-8    | versatil=
e_defconfig | 1          =

qemu_arm-versatilepb         | arm  | lab-collabora   | gcc-8    | versatil=
e_defconfig | 1          =

qemu_arm-versatilepb         | arm  | lab-linaro-lkft | gcc-8    | versatil=
e_defconfig | 1          =

sun8i-h3-libretech-all-h3-cc | arm  | lab-baylibre    | gcc-8    | multi_v7=
_defconfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.190-22-g9e71e8407589/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.190-22-g9e71e8407589
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9e71e8407589b6628bee7ac864f6dcc1a5b578d5 =



Test Regressions
---------------- =



platform                     | arch | lab             | compiler | defconfi=
g           | regressions
-----------------------------+------+-----------------+----------+---------=
------------+------------
panda                        | arm  | lab-collabora   | gcc-8    | omap2plu=
s_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6095fe7d876a9ae3206f5477

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-22-g9e71e8407589/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-22-g9e71e8407589/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6095fe7d876a9ae=
3206f547c
        failing since 3 days (last pass: v4.19.189-7-ge7f760cab9781, first =
fail: v4.19.189-8-g29354ef37e26)
        2 lines

    2021-05-08 02:59:04.256000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-05-08 02:59:04.273000+00:00  <8>[   23.579559] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform                     | arch | lab             | compiler | defconfi=
g           | regressions
-----------------------------+------+-----------------+----------+---------=
------------+------------
qemu_arm-versatilepb         | arm  | lab-baylibre    | gcc-8    | versatil=
e_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6095fcadbdf9368e186f547d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-22-g9e71e8407589/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-22-g9e71e8407589/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6095fcadbdf9368e186f5=
47e
        failing since 175 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                     | arch | lab             | compiler | defconfi=
g           | regressions
-----------------------------+------+-----------------+----------+---------=
------------+------------
qemu_arm-versatilepb         | arm  | lab-broonie     | gcc-8    | versatil=
e_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6095fca5bdf9368e186f547a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-22-g9e71e8407589/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-22-g9e71e8407589/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6095fca5bdf9368e186f5=
47b
        failing since 175 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                     | arch | lab             | compiler | defconfi=
g           | regressions
-----------------------------+------+-----------------+----------+---------=
------------+------------
qemu_arm-versatilepb         | arm  | lab-cip         | gcc-8    | versatil=
e_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6095fc8610b5b0b3b96f546d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-22-g9e71e8407589/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-22-g9e71e8407589/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6095fc8610b5b0b3b96f5=
46e
        failing since 175 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                     | arch | lab             | compiler | defconfi=
g           | regressions
-----------------------------+------+-----------------+----------+---------=
------------+------------
qemu_arm-versatilepb         | arm  | lab-collabora   | gcc-8    | versatil=
e_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6095fc4d1aa9991efd6f547e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-22-g9e71e8407589/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-22-g9e71e8407589/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6095fc4d1aa9991efd6f5=
47f
        failing since 175 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                     | arch | lab             | compiler | defconfi=
g           | regressions
-----------------------------+------+-----------------+----------+---------=
------------+------------
qemu_arm-versatilepb         | arm  | lab-linaro-lkft | gcc-8    | versatil=
e_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609608bb481ed3ec6f6f5482

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-22-g9e71e8407589/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-22-g9e71e8407589/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609608bb481ed3ec6f6f5=
483
        failing since 175 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                     | arch | lab             | compiler | defconfi=
g           | regressions
-----------------------------+------+-----------------+----------+---------=
------------+------------
sun8i-h3-libretech-all-h3-cc | arm  | lab-baylibre    | gcc-8    | multi_v7=
_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/609609b0c643ae07c16f5467

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-22-g9e71e8407589/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8i-=
h3-libretech-all-h3-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-22-g9e71e8407589/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8i-=
h3-libretech-all-h3-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609609b0c643ae07c16f5=
468
        new failure (last pass: v4.19.189-13-g97b3901c14448) =

 =20
