Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB8872D839C
	for <lists+stable@lfdr.de>; Sat, 12 Dec 2020 01:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730515AbgLLAsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 19:48:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389123AbgLLArq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 19:47:46 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BF2C0613CF
        for <stable@vger.kernel.org>; Fri, 11 Dec 2020 16:47:06 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id t8so8060892pfg.8
        for <stable@vger.kernel.org>; Fri, 11 Dec 2020 16:47:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=09U7rGNLpLrtcLPHWjQIrE2/sB8orU5C2WrOn6BHo+k=;
        b=q8RABW6PZl1LDTDuwGQjebWe2wrUUmCkNOGUls/qepL+amNvEItqHPaBWxk8FNgCi0
         2PSNmxLdihbX1rT9GhZw8/b6MceEmH0HyYA96FUHLDwbNScVrNQjxeNRZfrUjXkuzLLc
         I5UBTGb47SQ/bJUuZbJUUJfsTXKP8IL0FlWXqhs7B2Cu4OIBig3lwBDEeOzP9Qhupg8Y
         VNtsVOTO/o2B7jNiEo634FH0DFKH4s36DOuJ8zIrKt06lhJGPMDqHfU36wzbBdjcmUYW
         4CddrS9dWZgFcKForTM6IOzBmr+evLifqDr1cYuXNFXKRsP06CP5h3u0mwIQLsX7H+3v
         nbLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=09U7rGNLpLrtcLPHWjQIrE2/sB8orU5C2WrOn6BHo+k=;
        b=PpEavbXN7Y6gnHmkmKt9nNvKXLySFSUOE3GzzjKVUlkA6n5foBoG43jAYCDxbRm3WW
         LXEj0O/NGk9DRrCUWYzQZ3v1ueKUMDfzrVcm94dx4aXGM0LM5V9axDJwZd8tKDrFamk6
         nE0En6Uaywosm7qTeZ135n4i3aQIOgVyeeUrrj8Z3G7qApTdodolpt2VLWO/0RF8tecR
         DzuoHyzrRpErBRYVff3JKAaEAHhztr3+Mw2FvBZR0X0GPEr1AWqcZ0Y8qaHO0gTCk8Or
         qp3VZ1oElqSC2gVxmuIA/iwjkYfsfFfy8qSOpg5lMjLnUDc2V3M3cS0w4HFcsSTbPVtU
         qmMQ==
X-Gm-Message-State: AOAM532nWRmrrpWMGsbrcH4RlL3fNITnUaiNJDJOmCyYqoQI3jTh9wKA
        z4TiOB3sklmAlaQgh/DV7AAm0m2E9Jlgmw==
X-Google-Smtp-Source: ABdhPJypNk8mR3rddRpv9mzcbraaLXKfMB+DRCtCkHFIuhZYz1aHzvpUTHJ54NlLNLY1HSKs9MBCJQ==
X-Received: by 2002:a63:a516:: with SMTP id n22mr14097725pgf.125.1607734025288;
        Fri, 11 Dec 2020 16:47:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w31sm375437pgl.87.2020.12.11.16.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 16:47:04 -0800 (PST)
Message-ID: <5fd41308.1c69fb81.3cbf6.1141@mx.google.com>
Date:   Fri, 11 Dec 2020 16:47:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.83
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 156 runs, 5 regressions (v5.4.83)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 156 runs, 5 regressions (v5.4.83)

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

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.83/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.83
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2bff021f53b211386abad8cd661e6bb38d0fd524 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd3df5676134dab22c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.83/=
riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.83/=
riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd3df5676134dab22c94=
cba
        failing since 21 days (last pass: v5.4.77-152-ga3746663c3479, first=
 fail: v5.4.78) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd3de4263746f0669c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.83/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.83/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd3de4263746f0669c94=
cba
        failing since 27 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd3de3cab7c01f27ec94d2f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.83/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.83/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd3de3cab7c01f27ec94=
d30
        failing since 27 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd3de16845d9b50b2c94cd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.83/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.83/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd3de16845d9b50b2c94=
cd6
        failing since 27 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd3fcbcb8c8549394c94cc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.83/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.83/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd3fcbcb8c8549394c94=
cc1
        failing since 27 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =20
