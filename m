Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6CF23ECAC1
	for <lists+stable@lfdr.de>; Sun, 15 Aug 2021 21:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbhHOTyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Aug 2021 15:54:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbhHOTyv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Aug 2021 15:54:51 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717D1C061764
        for <stable@vger.kernel.org>; Sun, 15 Aug 2021 12:54:21 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id n12so17816785plf.4
        for <stable@vger.kernel.org>; Sun, 15 Aug 2021 12:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6tj/vpU4jGt/1yQ3H/0uIVa8KzMn6y+Fef9YTOf5in0=;
        b=hTAj8Zo2Ii114HnCKyNiJcGgaKShPFnYMiQfL+WRC+UVZ8JCvE+RKB0bW/hnRQO6f4
         L2gvoth7xT0iPwuuVdjVMvjSfEv2HXIp6FMEvuX9IUKRRh2xIf9wS646XEk1wWb6edTw
         HpwXxL1U3KLw49KgbLy3iu4R8X/NR/hs9c/F7tfJFENiz+SHRiAz1sdpNd7SKy6cTVFN
         q55LpNEYCviZHWvm5B48dZwRHcaJ/MqRJFbEGafcYPLahAGiiQBim7BLaTdq0pmqn5ni
         BJ3oO9KlOeoiQlipDs9njFH6yZek3p87NJ/sg0wQaI7nMvfQZm2wVUqSJWug1TN2+gEm
         cjtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6tj/vpU4jGt/1yQ3H/0uIVa8KzMn6y+Fef9YTOf5in0=;
        b=EHxbmKn48TRB8eYyIkZ+5lZcFJmKcPii9uqFDM6iz0AIN1dFjWn+Tb8xE2BQmGolXe
         gETwvsNiESSlyXWOz6Ra/cDHkAd0UWl72uzzFFtQqAAZ83Hm5ElJgANXyiMMA6ThrPVt
         CdqfHsPl4jxmcHCGHfopoBkFb/3TVm9IYJ0l2GYtrjsnol2fgM0jw5Q1DdZ6lmWxFH5L
         sQN/aCSkQC0IICFBn/qjy3YHkUjeGmZEVT8TqRBafz9/HakumWJjAL3UJ5dhl0LuX+xF
         sLLo8LJy0O+PocRp3k9XFPICXre9bVG5ZEhGaeuWUGtByPb60rekmhOpRsd5ageRiJIV
         ovLw==
X-Gm-Message-State: AOAM532ymm2G7Vb6nKC51lNXJpczQ3fsvJ4an0rHwHljYljTmVjO/uIN
        Vrj+k0tPMmEWipxBzus+xvM7ijPPkblVTwoR
X-Google-Smtp-Source: ABdhPJz6RkmQr+C5gCOmmUj2jy5xNMaV2R5NiHniPmTpZD65KvNrcc7Hyyi+41J2gjuQ1i2e3p51Ow==
X-Received: by 2002:a17:902:dac2:b029:12d:78d8:a15d with SMTP id q2-20020a170902dac2b029012d78d8a15dmr10248753plx.45.1629057260545;
        Sun, 15 Aug 2021 12:54:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w2sm7143933pjq.5.2021.08.15.12.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 12:54:20 -0700 (PDT)
Message-ID: <611970ec.1c69fb81.3732a.3046@mx.google.com>
Date:   Sun, 15 Aug 2021 12:54:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.9.280
X-Kernelci-Report-Type: test
Subject: stable/linux-4.9.y baseline: 115 runs, 5 regressions (v4.9.280)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 115 runs, 5 regressions (v4.9.280)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.280/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.280
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      89a3a5a52bc58d04109f03011e8164ce24e94b01 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61193b81abdca4a3c5b13690

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.280/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.280/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61193b81abdca4a3c5b13=
691
        failing since 269 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61193b9a11bbdde454b13673

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.280/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.280/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61193b9a11bbdde454b13=
674
        failing since 269 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61193b25ccb261a77bb13688

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.280/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.280/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61193b25ccb261a77bb13=
689
        failing since 269 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61193b3736a1676c29b13669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.280/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.280/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61193b3736a1676c29b13=
66a
        failing since 269 days (last pass: v4.9.243, first fail: v4.9.244) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61193df51cbf16cfadb13677

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.280/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.280/ar=
m64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61193df51cbf16cfadb13=
678
        failing since 269 days (last pass: v4.9.243, first fail: v4.9.244) =

 =20
