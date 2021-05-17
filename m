Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4B1383A40
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 18:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242743AbhEQQnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 12:43:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243735AbhEQQnm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 12:43:42 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46987C026CC0
        for <stable@vger.kernel.org>; Mon, 17 May 2021 08:53:00 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id k19so5245544pfu.5
        for <stable@vger.kernel.org>; Mon, 17 May 2021 08:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=f1yNncOFm9+TuTjZjSNFpvoCBKnA7WDDTeltdWtEZG0=;
        b=nFIAKfSyjAuCYxTZPu5uJC+HdwJMFrukPC06WSknuMNY8penJ3gbJWbHAkJ4y6QvGn
         ZsvKAx17JkbIoqaIKfato8Mr4s+gdUFlNiByCfWgKome5h9FzxZjuLeQONfTEHWNCh40
         reOGMu6xpENof58Y+PVFEkMW6k1rnlfs8OJhD1oOHw6PYpeZL9rPy1+xUHNq0gqdM5SW
         5UW129dmoQsoDxX1yQELYQsJa1nBf/8Eu33cTvPtAoh2P03WyQ+1uHDSIHkVtOHrXU/g
         ReUxF/N6ml47l16aNZfGLjYwU7mRZscmHABI9cfU/HTeNpIVPyDdtv/mDDA3xSoFOlN8
         vx0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=f1yNncOFm9+TuTjZjSNFpvoCBKnA7WDDTeltdWtEZG0=;
        b=GHJRtbvvMMZajgdsMxTYwWmQvSxKlfKHSxSfWJJU+0wPU6TOy52JG4wkv/EknKMInz
         0IAA45Bu+/OHFZlQDYF/RlnVj3sc+v54jTXHFAIPixnFdKKCXnMsp0hL9NCFOJ3gNKyE
         Uszm4r8VLaab/HCeFMfvy+de07iMzjqUZFoBjzylsiabmXnnCY30n0pkOPnCwjd/2Hz0
         Pwm8ZVFq0VAoB5pTY4wOA1hVOATwwEBy1KauTgux70dlFDcmvqKvHPl4TF+Txz0vsfKX
         MG/aPBu1N+1Pj93RhS4SakYnPZ0W/9h5fgI+Y1L+BTbxF2afrIjAHVN3rbZImWaC8J+z
         xoDA==
X-Gm-Message-State: AOAM530Fa05vUZj8/cS8HCb0YOp3YBhDqiZv4CMUZi4aZqpevVsUYTyl
        ZoBfbIuXnWFmQ5krz1Oy3IUz55KWk4WbIK20
X-Google-Smtp-Source: ABdhPJz/eEg7EBvBYOajaH6Cbn5Rxjs+5p7i9BLgvXLCTMzxQzbYBUHeTlA04523Rw0Lm9dK94JEMA==
X-Received: by 2002:a65:6849:: with SMTP id q9mr205236pgt.377.1621266779549;
        Mon, 17 May 2021 08:52:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h24sm10560242pfn.180.2021.05.17.08.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 08:52:59 -0700 (PDT)
Message-ID: <60a2915b.1c69fb81.78bdc.35af@mx.google.com>
Date:   Mon, 17 May 2021 08:52:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.232-298-g9164fb19163e
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 102 runs,
 4 regressions (v4.14.232-298-g9164fb19163e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 102 runs, 4 regressions (v4.14.232-298-g9164=
fb19163e)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.232-298-g9164fb19163e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.232-298-g9164fb19163e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9164fb19163e6bd09035e297c822a0b7efd7a308 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60a2603bb110e138adb3afae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-298-g9164fb19163e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-298-g9164fb19163e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a2603bb110e138adb3a=
faf
        failing since 77 days (last pass: v4.14.222-11-g13b8482a0f700, firs=
t fail: v4.14.222-120-gdc8887cba23e) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a25cf1454927fbe4b3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-298-g9164fb19163e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-298-g9164fb19163e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a25cf1454927fbe4b3a=
f98
        failing since 184 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a25cff4ca27ab9f5b3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-298-g9164fb19163e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-298-g9164fb19163e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a25cff4ca27ab9f5b3a=
f98
        failing since 184 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a25cfed32e03cc03b3afe8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-298-g9164fb19163e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-298-g9164fb19163e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a25cfed32e03cc03b3a=
fe9
        failing since 184 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
