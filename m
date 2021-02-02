Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC08E30BA7A
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 10:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhBBI7X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 03:59:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232553AbhBBI7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 03:59:18 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D698C061793
        for <stable@vger.kernel.org>; Tue,  2 Feb 2021 00:58:01 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id x9so6184244plb.5
        for <stable@vger.kernel.org>; Tue, 02 Feb 2021 00:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=X7jS4aXjExuigaUzoqUdcz2hHIUmyhRjrUH/6Oj2Gs4=;
        b=mSlCm7+jibTnklM72daLAZ2FHtGuM1KMy+CjMWyKpd6yiAfgW91HCIhhf/YccAURxp
         2gcgMkoczNqZjHiHHGdZfqvVfzsGo9C7KBPKFvM5LeueIhIk2nWl72jFptWgj+WOQ6sj
         PQ1eR3nOuFIEneztEXfjrzSKRmD23/sAcldnxMpE9jhduK5gUeQQr+zVUHurCSDcuVR4
         Usti6S0lSgKYVG2URIv1kZbOFc76WZ2uQdBeHuFK6GIyP6YBlcZ6WQtzZSP2OQck6q18
         d2iU3fKaQn61aqUf4HhTBL5wiywVhzxOwxMtI816mZ0By4R+3IXprs0n6EqXc+JPS91n
         d0pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=X7jS4aXjExuigaUzoqUdcz2hHIUmyhRjrUH/6Oj2Gs4=;
        b=ObmI3hwXEzGQE0kFJapoURQGWProjPki2NPabBOPBlMSi71+OFVhKEmXzQ27EOnSBP
         N8DyQiYk8W0TuZIiA5jb5Bc1jQRbsLvpfLKo4HQgzYGYm5exCR3f+rBykho58HqhX7VD
         N+UDqlCfgRSuTmPnkkkSsqyZzik0voiQmdA8v4jVOW9/+hhAod/Sv4s5v9EWAk1bn4kC
         XpVnrBM537jmcpKTXdbqgYhts5yg/jmgxN1iR91rq9MropulttyHMMAJvYqyRS2xE6Bu
         68OYiZBIp01Cz1z/W0D0dnUW5uilkDkqDzrM5+t6NSkbuqrGd/nv7sA3ytFbWee/rUSw
         HUJA==
X-Gm-Message-State: AOAM531K+oz0w7S5QC5G/P4sEQFIZLaSDfZBMFWNiGvzzBsW+UbbAi8q
        rscDgI3X3ueClmK/uwMwJSqKkrOaOcsWnw==
X-Google-Smtp-Source: ABdhPJzLtY9/MLTmJ9BxPyqGuA9wax+dp492w+ZccW5aecomJrPfW/vuQTisuciz5GTfcKkjoV8eUw==
X-Received: by 2002:a17:90b:17cb:: with SMTP id me11mr3232307pjb.64.1612256280398;
        Tue, 02 Feb 2021 00:58:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v19sm1972457pjg.50.2021.02.02.00.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 00:57:59 -0800 (PST)
Message-ID: <60191417.1c69fb81.82e8a.4b37@mx.google.com>
Date:   Tue, 02 Feb 2021 00:57:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.94-33-gdfa67b93f565
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 184 runs,
 6 regressions (v5.4.94-33-gdfa67b93f565)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 184 runs, 6 regressions (v5.4.94-33-gdfa67b=
93f565)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.94-33-gdfa67b93f565/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.94-33-gdfa67b93f565
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dfa67b93f565d6169dd60d400170b45f3515abb4 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60189d5d94184b03ccd3dfee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.94-=
33-gdfa67b93f565/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.94-=
33-gdfa67b93f565/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60189d5d94184b03ccd3d=
fef
        failing since 73 days (last pass: v5.4.77-152-ga3746663c3479, first=
 fail: v5.4.78) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60189ce90293eeab61d3dfd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.94-=
33-gdfa67b93f565/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.94-=
33-gdfa67b93f565/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60189ce90293eeab61d3d=
fd2
        failing since 79 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6018a43b0f1bdabf91d3dfd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.94-=
33-gdfa67b93f565/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.94-=
33-gdfa67b93f565/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6018a43b0f1bdabf91d3d=
fd2
        failing since 79 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60189cffdbafaecc98d3dfcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.94-=
33-gdfa67b93f565/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.94-=
33-gdfa67b93f565/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60189cffdbafaecc98d3d=
fce
        failing since 79 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60189ccbb5cd3c85f0d3dffe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.94-=
33-gdfa67b93f565/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.94-=
33-gdfa67b93f565/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60189ccbb5cd3c85f0d3d=
fff
        failing since 79 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6018b2f64a4a9811e6d3dffc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.94-=
33-gdfa67b93f565/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.94-=
33-gdfa67b93f565/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6018b2f64a4a9811e6d3d=
ffd
        failing since 79 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =20
