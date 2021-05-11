Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49A0F37B0FC
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 23:47:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbhEKVs5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 May 2021 17:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbhEKVs4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 May 2021 17:48:56 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39C2C061574
        for <stable@vger.kernel.org>; Tue, 11 May 2021 14:47:49 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id gj14so12411600pjb.5
        for <stable@vger.kernel.org>; Tue, 11 May 2021 14:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=J5gsA0MLD+REahAqm6TklpcGRlEB82PsYxWXtLvYYiw=;
        b=MhNGyLDGmOGOxK9Ql8uUBz6WGbR8XuGoXdBgocMYq1tv99qUAXaRMyq7x6P7wVsrnF
         5TNQo/UsZJLZqOtMK4yG/bETYFKRnu0ky7gcvdnhB72OcCQfdtFH+6BhKgC18D2ZYmiX
         CH7/AdPFxtdSo3QIcQa+/Z4bdNn2/fn2Ey91wtVZveXhPm77lQR4V2MFmmLXQfLyUp67
         dTUpRUGhvuRRi9cUZEADUQ0V4JshT6sGp0STQ8bvyD8uT8GdS5B1heaqrNEOJ7OP/Hxc
         Ji7ImpQW+grvAolsqfNXxR1ELj/oyY/SspCVGf5s2ohKzZIIitFHbZJt8uMUhnWh4GJQ
         xbeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=J5gsA0MLD+REahAqm6TklpcGRlEB82PsYxWXtLvYYiw=;
        b=bVAWmt/Cwgi20S+eGPZrt5oFaXseBWlBjwSMBab5UY/SRaYQaXKk/zcqC5CeWmOnvY
         NVhV2eaAuR2M84h4bEqxbBlEl66ANQOWlXRria5pyn9swz/3iP8J9GYpNH9NCqkadYG6
         PUeF8O6ligxC4z48fZQpHIC8+Mgns3J97scSRDZTwkxNZPcMGi0CIuBRcsxfej7I+Li0
         8GQXqVnGD4dtMjaUiAED8LLfz3nxHlZfPYDRDBJH/8EYTPqcBio5ykntVtqDIKJp71je
         KbMY4iUZgq98TVVN5Oer0M3AJou+NWMqk3++gTup0G2oEa0J4KW4/OsuCyVYT8NE8dM4
         TI4A==
X-Gm-Message-State: AOAM533FrvUeD1H6fq6T5C5OPld+BaJpkctqWhzgf7iuCNvXQNiuqMwk
        K9kZh4vH55VvnljzJVZ9K5tZhofGmsopKQIs
X-Google-Smtp-Source: ABdhPJymW8cX6nCCDweNpZ6e21RUHvgxQytYUqO4xDPsZn6Cqv27VvsmB//PVy/SK/w2wGWfmq10vg==
X-Received: by 2002:a17:902:9685:b029:ef:70fd:a5a2 with SMTP id n5-20020a1709029685b02900ef70fda5a2mr2862418plp.20.1620769669273;
        Tue, 11 May 2021 14:47:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h1sm13896881pfh.72.2021.05.11.14.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 May 2021 14:47:48 -0700 (PDT)
Message-ID: <609afb84.1c69fb81.98352.c3b1@mx.google.com>
Date:   Tue, 11 May 2021 14:47:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.118
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Report-Type: test
Subject: stable/linux-5.4.y baseline: 173 runs, 6 regressions (v5.4.118)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 173 runs, 6 regressions (v5.4.118)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.118/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.118
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      16022114de9869743d6304290815cdb8a8c7deaa =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/609ac4c5ea4a937c17d08f1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.118/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.118/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609ac4c5ea4a937c17d08=
f1d
        failing since 173 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609ac3b2b7aa79c408d08f21

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.118/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.118/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609ac3b2b7aa79c408d08=
f22
        failing since 173 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609ac3aa7a502ac493d08f24

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.118/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.118/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609ac3aa7a502ac493d08=
f25
        failing since 173 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609ac3cfbf1fb62927d08f34

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.118/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.118/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609ac3cfbf1fb62927d08=
f35
        failing since 173 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609ac35851002e5713d08f1d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.118/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.118/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609ac35851002e5713d08=
f1e
        failing since 173 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609ac34f0b8f716569d08f3b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.118/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.118/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609ac34f0b8f716569d08=
f3c
        failing since 173 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20
