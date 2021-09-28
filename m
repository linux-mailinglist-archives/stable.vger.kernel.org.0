Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 651D241B2A8
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 17:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241484AbhI1PLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 11:11:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241455AbhI1PLJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 11:11:09 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCDE3C06161C
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 08:09:29 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id y8so19178636pfa.7
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 08:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MWZNbocW2aV6gY8siD+IMmG4NGrKgpsEf+3SY06m3ek=;
        b=EdhMyChe2WSOqK1Aiazw188voNh6L+KbYxxHxpma5/dIfFvwQbhsA6tl64FoAq9KPz
         SCMv4Aik9fwDwVxVK3zJgMB9zmkJgGSvwrZsJhk36SwARp1fJZz47wG9RXEUNbRAMumN
         bjQqbo+tCnWSxspfzfxBaCZH/FgTTBSoTTaT4XkVsdVDBaUUGB/W4n4JjWOTjzgVkF28
         rf9X5CV6cmuKn9tNgiW85ZJK/+Dp7eYLH6HdO3/iHJtTzs52Atoct25hhV6HWzrXQsrn
         1Sr84qEYfGZoCWvz8SLEVIpRlEEIYiMxWbMa6sgFqE3OHsoMajszCr9gIkxwk0LJe/a6
         Zygw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MWZNbocW2aV6gY8siD+IMmG4NGrKgpsEf+3SY06m3ek=;
        b=6MNMFgfx+22hZokehI28oRFfueB3XaTg795TryF1R+kLk7GpBf4Q5J3m4GpDZv4xta
         O9Ovo0DDgShxR8DybdnoY+FOOJ+1IqXxSFKxy49b6KwzQ8YsrOBVhU7uPLVK4NrwMLqW
         8Msygw0leQZdjoTR2nDKZhU8tAeTrVZiSrXT3Rz4JdWuR1J7SKc5Z60MtZrdaJPYIvL0
         3ADf9RXJ+mlb0WYEqQyGOB4Z5MGcFCAo3l80txDu5aySyuTYTWiL18Vrw+lf/GCBNnKS
         XKTyhg0JWUg55x+LX/253lYzUU8LPYj5TxJHx886FP8BtN/H9Ew7AKF+viUBnM1r8owo
         mlNA==
X-Gm-Message-State: AOAM533ztTCWYNACDgvt9rnTazhKvlDNgafTJAdjmpifMPNfu25tAM87
        29P7tCRrc1aQj7fWwO7tqWvzIsAywEWqwV3L
X-Google-Smtp-Source: ABdhPJwxxE7ZpVQyEHQyRf8UgHbUhN1hjJjMmQntjd8zb4qjvJWeT6RXhgxHe59H4DG2kUu0PyvRtA==
X-Received: by 2002:a63:e115:: with SMTP id z21mr5182435pgh.306.1632841769108;
        Tue, 28 Sep 2021 08:09:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k9sm20649387pfi.86.2021.09.28.08.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 08:09:28 -0700 (PDT)
Message-ID: <61533028.1c69fb81.715c0.44c4@mx.google.com>
Date:   Tue, 28 Sep 2021 08:09:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.149-69-gaa1e7cd620d9
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 168 runs,
 8 regressions (v5.4.149-69-gaa1e7cd620d9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 168 runs, 8 regressions (v5.4.149-69-gaa1e7=
cd620d9)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.149-69-gaa1e7cd620d9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.149-69-gaa1e7cd620d9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aa1e7cd620d9f606f5b03b2e2d3ab68f5540359c =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6152f83dc9115574d099a2f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.149=
-69-gaa1e7cd620d9/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.149=
-69-gaa1e7cd620d9/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6152f83dc9115574d099a=
2f6
        failing since 312 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6152f76c4f644c5a1d99a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.149=
-69-gaa1e7cd620d9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.149=
-69-gaa1e7cd620d9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6152f76c4f644c5a1d99a=
2de
        failing since 317 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6152fd5781da04a0cc99a2e3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.149=
-69-gaa1e7cd620d9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.149=
-69-gaa1e7cd620d9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6152fd5781da04a0cc99a=
2e4
        failing since 317 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6152f76f9ebd6f305599a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.149=
-69-gaa1e7cd620d9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.149=
-69-gaa1e7cd620d9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6152f76f9ebd6f305599a=
2de
        failing since 317 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6152fab22a6275a8cb99a2f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.149=
-69-gaa1e7cd620d9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.149=
-69-gaa1e7cd620d9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6152fab22a6275a8cb99a=
2f3
        failing since 317 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 3          =


  Details:     https://kernelci.org/test/plan/id/615309555b5a5df17899a2eb

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.149=
-69-gaa1e7cd620d9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.149=
-69-gaa1e7cd620d9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/615309555b5a5df17899a2ff
        failing since 105 days (last pass: v5.4.125, first fail: v5.4.125-8=
5-g4a2dfe908c1e)

    2021-09-28T12:23:26.874533  /lava-4593121/1/../bin/lava-test-case
    2021-09-28T12:23:26.891517  <8>[   15.310357] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-28T12:23:26.892011  /lava-4593121/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/615309555b5a5df17899a317
        failing since 105 days (last pass: v5.4.125, first fail: v5.4.125-8=
5-g4a2dfe908c1e)

    2021-09-28T12:23:25.448042  /lava-4593121/1/../bin/lava-test-case
    2021-09-28T12:23:25.466476  <8>[   13.884334] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/615309555b5a5df17899a318
        failing since 105 days (last pass: v5.4.125, first fail: v5.4.125-8=
5-g4a2dfe908c1e)

    2021-09-28T12:23:24.429377  /lava-4593121/1/../bin/lava-test-case
    2021-09-28T12:23:24.434815  <8>[   12.864913] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
