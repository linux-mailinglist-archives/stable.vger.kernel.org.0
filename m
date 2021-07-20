Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17F63CFA25
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 15:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbhGTM2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 08:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232364AbhGTM2s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 08:28:48 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B8DEC061574
        for <stable@vger.kernel.org>; Tue, 20 Jul 2021 06:09:26 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id u14so22424652pga.11
        for <stable@vger.kernel.org>; Tue, 20 Jul 2021 06:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4HklKZDl2gVui/qM6rH4CseHlMAz2WAG673b4D1CAaw=;
        b=pmcwotuRm42pLKlZd+vePA88JRtdm/DFamiz/PYBw6OejNd+0sNlum4pJtg2bcptiy
         D/oR6KQkKKdFm8E20kAQPdHqErDjlZp6/m9OiFJdAQcdyWEcY0ogmmlFlUBaifiEF+ZT
         0eCO36pdRNhUdPXNaLVdTgH1yz59lM2s44xetOSsJDkJPTt1bsQANTHwG1Nz03096pOz
         w9Ln5NKVO/S1Qqx368pRZ/cQl4yFw2dugBiqzy4616xHI2w8bQytIIRcgp9Sb3FRFqea
         twLM3AJql1Nkgz+CR0DrfT4pxigWqL3bwq3ZDNV8bp25eWQwdIF8ZreWz3HamB7S6e28
         iP4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4HklKZDl2gVui/qM6rH4CseHlMAz2WAG673b4D1CAaw=;
        b=psUr6XtgNLLU0e9aZ9JlcF7Jfw4w7JM8fly2RakF/8QSatmh+eQlq7TzeSbpdkf2xF
         Dyu8h6rvbZ+PsMT1prPWT4t0Qd5EHsmxw4Ixa3xFhT5TQ6VLWtssqlkVj9spfCgOz/85
         dZA2sdZCZLvTtb2igTENA5qr0IWZWTHh+Vp3wNmerwZ8equB6xvvgt+x70HeBWzBdmT3
         F8iBvWP4sp32gJRbsQW9jxZhKSVIQmdbpQW2gkPdLenSPq5vP3zLkPlp2gZ/C28HOqeZ
         b8dRUvwjli4A7w+/dCnheCr6DIcqifas6xyoXbQ/FDsMIzk51YKLQ8eFuuigu87rIKio
         Erng==
X-Gm-Message-State: AOAM530H/L/CIXTI3EDutycZZKVCuh2dakZX4WadRwf+QsFZtpErPtJ2
        MatbC+9rZWgPVjva2KPudjrUqRjFPEk1yxjd
X-Google-Smtp-Source: ABdhPJwekpBKDMnFpZGrzciiWG4wV/KnZE82O4quuMcBVct3QRHS9x8cWMOZnlKyN471uTjEgOQM9w==
X-Received: by 2002:a63:1944:: with SMTP id 4mr30258910pgz.306.1626786565814;
        Tue, 20 Jul 2021 06:09:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k16sm22858465pfu.83.2021.07.20.06.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 06:09:25 -0700 (PDT)
Message-ID: <60f6cb05.1c69fb81.c87f5.3d87@mx.google.com>
Date:   Tue, 20 Jul 2021 06:09:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.133-148-g5b0c31d40d771
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 174 runs,
 8 regressions (v5.4.133-148-g5b0c31d40d771)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 174 runs, 8 regressions (v5.4.133-148-g5b0c=
31d40d771)

Regressions Summary
-------------------

platform              | arch   | lab           | compiler | defconfig      =
              | regressions
----------------------+--------+---------------+----------+----------------=
--------------+------------
at91-sama5d4_xplained | arm    | lab-baylibre  | gcc-8    | sama5_defconfig=
              | 1          =

d2500cc               | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon..=
.6-chromebook | 1          =

d2500cc               | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfi=
g             | 1          =

hifive-unleashed-a00  | riscv  | lab-baylibre  | gcc-8    | defconfig      =
              | 1          =

qemu_arm-versatilepb  | arm    | lab-baylibre  | gcc-8    | versatile_defco=
nfig          | 1          =

qemu_arm-versatilepb  | arm    | lab-broonie   | gcc-8    | versatile_defco=
nfig          | 1          =

qemu_arm-versatilepb  | arm    | lab-cip       | gcc-8    | versatile_defco=
nfig          | 1          =

qemu_arm-versatilepb  | arm    | lab-collabora | gcc-8    | versatile_defco=
nfig          | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.133-148-g5b0c31d40d771/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.133-148-g5b0c31d40d771
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5b0c31d40d771b5f47ddc5fc813761aa13c34944 =



Test Regressions
---------------- =



platform              | arch   | lab           | compiler | defconfig      =
              | regressions
----------------------+--------+---------------+----------+----------------=
--------------+------------
at91-sama5d4_xplained | arm    | lab-baylibre  | gcc-8    | sama5_defconfig=
              | 1          =


  Details:     https://kernelci.org/test/plan/id/60f697c472378db18b1160a0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-148-g5b0c31d40d771/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-148-g5b0c31d40d771/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f697c472378db18b116=
0a1
        failing since 464 days (last pass: v5.4.30-54-g6f04e8ca5355, first =
fail: v5.4.30-81-gf163418797b9) =

 =



platform              | arch   | lab           | compiler | defconfig      =
              | regressions
----------------------+--------+---------------+----------+----------------=
--------------+------------
d2500cc               | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon..=
.6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60f699a16ae42801991161be

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-148-g5b0c31d40d771/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe=
/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-148-g5b0c31d40d771/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe=
/baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f699a16ae4280199116=
1bf
        new failure (last pass: v5.4.131) =

 =



platform              | arch   | lab           | compiler | defconfig      =
              | regressions
----------------------+--------+---------------+----------+----------------=
--------------+------------
d2500cc               | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfi=
g             | 1          =


  Details:     https://kernelci.org/test/plan/id/60f69af61659be5a5d116102

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-148-g5b0c31d40d771/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500=
cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-148-g5b0c31d40d771/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500=
cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f69af61659be5a5d116=
103
        failing since 0 day (last pass: v5.4.131, first fail: v5.4.133-149-=
g0274752daa493) =

 =



platform              | arch   | lab           | compiler | defconfig      =
              | regressions
----------------------+--------+---------------+----------+----------------=
--------------+------------
hifive-unleashed-a00  | riscv  | lab-baylibre  | gcc-8    | defconfig      =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/60f691bd9098142c8811609a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-148-g5b0c31d40d771/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unle=
ashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-148-g5b0c31d40d771/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unle=
ashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f691bd9098142c88116=
09b
        failing since 242 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform              | arch   | lab           | compiler | defconfig      =
              | regressions
----------------------+--------+---------------+----------+----------------=
--------------+------------
qemu_arm-versatilepb  | arm    | lab-baylibre  | gcc-8    | versatile_defco=
nfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60f6915628fd7e01bc11609a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-148-g5b0c31d40d771/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-148-g5b0c31d40d771/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f6915628fd7e01bc116=
09b
        failing since 247 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform              | arch   | lab           | compiler | defconfig      =
              | regressions
----------------------+--------+---------------+----------+----------------=
--------------+------------
qemu_arm-versatilepb  | arm    | lab-broonie   | gcc-8    | versatile_defco=
nfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60f69958b6ee43508111609a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-148-g5b0c31d40d771/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-148-g5b0c31d40d771/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f69958b6ee435081116=
09b
        failing since 247 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform              | arch   | lab           | compiler | defconfig      =
              | regressions
----------------------+--------+---------------+----------+----------------=
--------------+------------
qemu_arm-versatilepb  | arm    | lab-cip       | gcc-8    | versatile_defco=
nfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60f692175e2eefd0661160ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-148-g5b0c31d40d771/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-148-g5b0c31d40d771/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f692175e2eefd066116=
0af
        failing since 247 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform              | arch   | lab           | compiler | defconfig      =
              | regressions
----------------------+--------+---------------+----------+----------------=
--------------+------------
qemu_arm-versatilepb  | arm    | lab-collabora | gcc-8    | versatile_defco=
nfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60f693b104c715875c1160b5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-148-g5b0c31d40d771/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-148-g5b0c31d40d771/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f693b104c715875c116=
0b6
        failing since 247 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
