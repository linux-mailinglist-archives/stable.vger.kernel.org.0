Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0B13E0D17
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 06:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbhHEEXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 00:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhHEEXW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 00:23:22 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F78C061765
        for <stable@vger.kernel.org>; Wed,  4 Aug 2021 21:23:07 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id i10so5584851pla.3
        for <stable@vger.kernel.org>; Wed, 04 Aug 2021 21:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=L50bSE6ckx9JTqwyLgzHIyLzVJuatf7nQPt1hUjoNTA=;
        b=rYCpjltOcaz1GmPZaJjMrIch0GUrSGtykGj9ObHfufYPzQkUEjMwOx86KuZs8j8blw
         dUqfV+CDBp7NO5p0bE6cy1zBjZYFO24cy4MJiXlxeLu+/0jfsmNeCDx8l2lSPlKOGUjW
         eUGJIzo1GJ18pDPh3SemBwxZwXK8hJnKBenjQzj4ateRfS9HwF/IYOyR+XMAdOcv+T+y
         wQ3Z3kSUG3+RrBaadjEoIBKa9pYbTkeS7ck+J3iOa83Xd1ff3VG1sn+UHQBGDRsbYi4O
         4dm/WMyh62HKeYc/2demgvXO7wK4Ug9TIwsEJshKl3vYScaOTvvhFDJtNwcfc6mzTp1g
         LfrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=L50bSE6ckx9JTqwyLgzHIyLzVJuatf7nQPt1hUjoNTA=;
        b=sS0qzEA45JwlkAIshb/HANe+psfNr84he04YJMOFVRLCNz1Px5QUFLkXxoUc+OCYbf
         eYUpbipYAftyeJbBYrSnLugCKFZolV6IfY1AC1IMF5hMWYop9DcNqoQq8TaHNlurs+UC
         mihWEMEOA/swx9hDVJ6ds4CPLO2df7IaNyU0xaGBlX7csC9iTB2/56nPAXxr+j2obavm
         EjDYl+C3l/d6tFUo9PgQFi7mHZ1yaY6OmPIQPwdlyNsVBX7UF0t2MsTYoEnBg0raKaUA
         Uz/dz1xLlQ6fiV1oLcuuJTajezvvUzhUL3xvauoZioFRj8MRfdQyxSTCSiQAt/QT07cf
         1zZQ==
X-Gm-Message-State: AOAM530rH/7dy/9UOcxABLQd8npsXJZiAIA9OqWazTi5z7hHJAC8OvA1
        rMgDigBoO6kXG54Dbq+WQKSpIEdlzAX+ex60
X-Google-Smtp-Source: ABdhPJxEqwWVHfeay0tNRaK0RZMNFfPSsozv/ZiTQIU9fcHBZbRyJe7H74tj1Wm6MgnkXmJFfkMFbQ==
X-Received: by 2002:a62:7bd4:0:b029:3b7:29bf:b0f with SMTP id w203-20020a627bd40000b02903b729bf0b0fmr3191572pfc.15.1628137386880;
        Wed, 04 Aug 2021 21:23:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y9sm5483433pgr.10.2021.08.04.21.23.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 21:23:06 -0700 (PDT)
Message-ID: <610b67aa.1c69fb81.153c4.14e1@mx.google.com>
Date:   Wed, 04 Aug 2021 21:23:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.138
X-Kernelci-Report-Type: test
Subject: stable/linux-5.4.y baseline: 116 runs, 5 regressions (v5.4.138)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 116 runs, 5 regressions (v5.4.138)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
bcm2837-rpi-3-b-32   | arm   | lab-baylibre    | gcc-8    | bcm2835_defconf=
ig   | 1          =

hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.138/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.138
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      7b90d57b09fa3513a31e6f05f07a5f1f19438e15 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
bcm2837-rpi-3-b-32   | arm   | lab-baylibre    | gcc-8    | bcm2835_defconf=
ig   | 1          =


  Details:     https://kernelci.org/test/plan/id/610b348cd1cc65abebb1366a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.138/ar=
m/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.138/ar=
m/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b348cd1cc65abebb13=
66b
        failing since 4 days (last pass: v5.4.136, first fail: v5.4.137) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/610b2d53d2cbb1372db13663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.138/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.138/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b2d53d2cbb1372db13=
664
        failing since 259 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/610b2d1c709f761344b13677

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.138/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.138/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b2d1c709f761344b13=
678
        failing since 259 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/610b2d19709f761344b1366e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.138/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.138/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b2d19709f761344b13=
66f
        failing since 259 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/610b5baaccb4569204b13680

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.138/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.138/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b5baaccb4569204b13=
681
        failing since 259 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20
