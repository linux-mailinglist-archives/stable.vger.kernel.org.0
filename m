Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 428E53FB5EA
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 14:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236827AbhH3MWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 08:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237705AbhH3MVX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 08:21:23 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B83C06175F
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 05:20:30 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id u1so4629768plq.5
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 05:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sbdFtb4xG4nofzAF25lugNctkqEMM5MF0q0NeYDx7Bo=;
        b=FCkz9zcwEsA3WweS7ltXSmyOgAMbBiRam9WIa3AJnMEK8KT+Egon4eYQJuwU7Zkxoi
         nFNJTeR2NsFAwbEJ8oOILNkRVGI9rEJOrNyMYjnl06daAJ4YPifKjkp9qnuKz7EQnSBW
         kkucD4Z5PsVq+s/M/uVbMo6UAa2w3xfoNT4jlPW705i61vOMMzssDQJE8Mn55569/i+Y
         mfYOtTs331FI3el/6stMEmVmDr+yioW9b+z227JP+RWmVSPmesl7slb99A40w9Fltfkz
         WD+A5g9dtmdRUvWe8yvQKXEP2Aj+t/u8VSPYBKaEuqdMZEoz/obrEdDMzoZFLIxWrFh7
         HC9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sbdFtb4xG4nofzAF25lugNctkqEMM5MF0q0NeYDx7Bo=;
        b=BV0hnq12GdNPjvuJy1HCGMiXqZwW13sB5jzBqDcZZx5n/hA5Zcqhd8o3l8w73KViSd
         MAl0XJH3UYkN9XokOKtxtbG9Q3Gl4MstgUD4gP6oejJcKwfvhEDrJhFfouCmUyMjh4rg
         X43uq8d3iaAqVE8uVv+hgOU3CDSAs1uU1jZLIjIhuDenb3YHorXUNJgIA6Juha6jBCD6
         VzxoiFwmFSszjUu01I01E7JjQQ7DyZXPDkYqJbo/LWQE/VL21OLRuPe80jO9tOLZiN0C
         Wpltl3VAGnG0o1vaeoTPrutiAKSh/WDynmjTsGPgsVuHmbthw1/iWiLeVlKDIzhCMOL1
         r+Bw==
X-Gm-Message-State: AOAM531ryFMgEmO6UJsedxHlQ30JSS/ZIHfp946QoiAOB4sVOvJVlDer
        Vm/0cxK+gc6AC3tZgkuOatGjLbGqsa0nz3SV
X-Google-Smtp-Source: ABdhPJy56JE76qwhkrWnfDDuWFblVh6nt+H4ZwNYLy0cSEmLP4e532BFsQB3bx85u2z7aTHm8rwriA==
X-Received: by 2002:a17:902:f704:b029:11a:cdee:490 with SMTP id h4-20020a170902f704b029011acdee0490mr21543978plo.37.1630326029409;
        Mon, 30 Aug 2021 05:20:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m11sm4860956pjl.14.2021.08.30.05.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 05:20:29 -0700 (PDT)
Message-ID: <612ccd0d.1c69fb81.87f3.ba1c@mx.google.com>
Date:   Mon, 30 Aug 2021 05:20:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.143-28-g66b6adc3ce6e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 153 runs,
 4 regressions (v5.4.143-28-g66b6adc3ce6e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 153 runs, 4 regressions (v5.4.143-28-g66b6a=
dc3ce6e)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.143-28-g66b6adc3ce6e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.143-28-g66b6adc3ce6e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      66b6adc3ce6e26663967aae92ec0602cef07b36b =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/612c9a0466a341b32c8e2c78

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.143=
-28-g66b6adc3ce6e/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.143=
-28-g66b6adc3ce6e/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612c9a0466a341b32c8e2=
c79
        failing since 282 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612c97ec89312c7e888e2ca3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.143=
-28-g66b6adc3ce6e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.143=
-28-g66b6adc3ce6e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612c97ec89312c7e888e2=
ca4
        failing since 288 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612c9811b7632becfe8e2c96

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.143=
-28-g66b6adc3ce6e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.143=
-28-g66b6adc3ce6e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612c9811b7632becfe8e2=
c97
        failing since 288 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612c97d90ea1af5e5c8e2c88

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.143=
-28-g66b6adc3ce6e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.143=
-28-g66b6adc3ce6e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612c97d90ea1af5e5c8e2=
c89
        failing since 288 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
