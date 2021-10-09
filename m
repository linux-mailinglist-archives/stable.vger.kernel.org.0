Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F49B427C7D
	for <lists+stable@lfdr.de>; Sat,  9 Oct 2021 20:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbhJISID (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Oct 2021 14:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhJISID (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Oct 2021 14:08:03 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18114C061570
        for <stable@vger.kernel.org>; Sat,  9 Oct 2021 11:06:06 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id s75so6517380pgs.5
        for <stable@vger.kernel.org>; Sat, 09 Oct 2021 11:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=apD9AbRooZXNgkr1AhySl9JoV+JgGmwR3kliQTe+7rs=;
        b=D4+BATBOEGSjGUgm5C6sZzUZNQofYV+qMjT92+QsTDkTA790BTxbRWeLDm8Zx99OS7
         WYNedX0Ddly3iuDN02Uy/Bl6KoErtv2q+3oC7w2SBLgZa8oJrHHV1dOFt3NoDIqAzTs6
         kx6xXBvwmvS9WHs2rjKGmHIl0lEZxQi3HbVBDw5rHCVs3PxnOOHiM/gxLm+r4zAHVURY
         PBfNJhj4oq547pFA50DoA1MPIORHh1vYxPVUCzZL5e/Rub78v9w3hAghn4mPHOcjnZbo
         /fDcBX5/pS4Lv3sw6OL2eyHrAMZFrriNEHZYUOrPJVE+TAsrR5+soYDzpdJibMa9dEjY
         p13A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=apD9AbRooZXNgkr1AhySl9JoV+JgGmwR3kliQTe+7rs=;
        b=ZHH9VCn4BfOT5cCXZQcJimZxn3kYK7smPuuWGIacGsXXyJkxdmQ0vynPT6udoiHSed
         2X9elj6fkG/WKWLTb+7v87dYY8ndCCaxtLqnfMMQLH4JLCq/RTgUU/+TsAzrmCNqa6th
         NhgsvFKmvjAk8hBUALOD+aldygu1SSVrkbz/Z2VRhvHwC2UYhOQNSOCwoTel9Ogi8OQl
         gQOOpE34Ew5CzCaAOxBM4RbmtUY6pQCgHDBvqx/4opIHU1hlSSk/z1XDDeHxRRojVr8J
         GTyZfkpZPJiJ7zZhhQ9vTcySP6bVTQOo4UbNJEIiD9x++A+aE29UA0myu/n2pHEfbYCF
         utAQ==
X-Gm-Message-State: AOAM533Z7c4StOE1QmgjEdDXLowedAFJhFhC8W6X3aW86SGFF/3w21rg
        dbu+1AYI5sRVgkTSZs1F7PaVF6rUz6SwVuAh
X-Google-Smtp-Source: ABdhPJxSoF6LAicOyU9HbE0iiDUpCIGZWushFjgtCZf4cvGPj/F8JmZFmdiYNkLKY2oOduzFW27RNA==
X-Received: by 2002:aa7:8b0d:0:b0:44c:89ca:7844 with SMTP id f13-20020aa78b0d000000b0044c89ca7844mr16612996pfd.19.1633802765313;
        Sat, 09 Oct 2021 11:06:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p18sm3328998pgk.28.2021.10.09.11.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 11:06:05 -0700 (PDT)
Message-ID: <6161da0d.1c69fb81.eefb4.94ae@mx.google.com>
Date:   Sat, 09 Oct 2021 11:06:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.286
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.9.y
Subject: stable/linux-4.9.y baseline: 103 runs, 6 regressions (v4.9.286)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 103 runs, 6 regressions (v4.9.286)

Regressions Summary
-------------------

platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig          | 1          =

qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig          | 1          =

qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig          | 1          =

qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig          | 1          =

qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig          | 1          =

qemu_x86_64-uefi     | x86_64 | lab-broonie     | gcc-8    | x86_64_defcon.=
..6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.286/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.286
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      9e8a7b701479b322a44324f1160f2c33e47489e9 =



Test Regressions
---------------- =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6161a23f7cc9b4514599a2eb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.286/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.286/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161a23f7cc9b4514599a=
2ec
        failing since 324 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6161a25cec239d638899a2e3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.286/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.286/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161a25cec239d638899a=
2e4
        failing since 324 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6161a23d521a4d73b699a2ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.286/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.286/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161a23d521a4d73b699a=
2ef
        failing since 324 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6161a1e5f7e9a9f1aa99a318

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.286/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.286/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161a1e5f7e9a9f1aa99a=
319
        failing since 324 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6161a1e9f4d7934a4e99a30b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.286/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.286/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6161a1e9f4d7934a4e99a=
30c
        failing since 324 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi     | x86_64 | lab-broonie     | gcc-8    | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61619f281f0e42c87a99a317

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.286/x8=
6_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/baseline-qemu_x86_64=
-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.286/x8=
6_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/baseline-qemu_x86_64=
-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61619f281f0e42c87a99a=
318
        new failure (last pass: v4.9.285) =

 =20
