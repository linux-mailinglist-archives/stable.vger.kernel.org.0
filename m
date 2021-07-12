Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4B923C5B18
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 13:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233606AbhGLK7k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 06:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235163AbhGLK7U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Jul 2021 06:59:20 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03ED7C0613E5
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 03:56:31 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id d9-20020a17090ae289b0290172f971883bso11915759pjz.1
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 03:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=48EUNEFcOAiPKcvD2kzp0FiP/3pC6TXo5YmbEFt/5hs=;
        b=ChNrjgoJZDcaTTeEVnF3LxGP/zD3RZ3YBT3dToIS2OFOB6S8OGIcPsr65C0+rpK353
         WlnhXNriMg3PBuNLIxHu1qkPjRP865k35aPVpIa/VvNWo2vAi2ciBoyrLcRUMcrKJYQj
         134c7mul6gvTfyNqvRyQ2LmaC/uWqObDS0rdb5KnZ6iLhJsoyDpGZ86ZKSDmK9PSZZF7
         uvKt+A3zC4vMFXlNBWCgZG3TrOFTWiInN5xuVsGQ9qrLvFqH4FQ/ujtLZYOYufeUf7Bm
         k5fI4jRMXhTA53wQQg85uTvXLDgXtK1ITi1727Wm+2tHBmakYRX/aooNI24NNmsLC9Ov
         TOBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=48EUNEFcOAiPKcvD2kzp0FiP/3pC6TXo5YmbEFt/5hs=;
        b=HY3PSjlGMS2o3Cs1hMeC4OmeVeu/1/8bJPNUzDwb49NSmK8AAb5Vx65wcEJcrQhsyW
         p80ZI1NjeBFMCHqkXVLjtwLeYN/zM6+8cVjUK5Vtpi+e4gNP4QmV5FLaqaG+ev4RA4SX
         W+265oOqQM8fBpd5ks8JHqJoQbSzDS3PiN7NQxOaZZEIbCQn5f2XcfTyIHObqEKjajuw
         DmFaNfzVEngtorbRkcm8BTgmUTFHVAo0QnbzygsVWjaVwXhWA0Fl0uYtVieCQQpaEqRA
         gE6Xrf1rzxYCVbdQ9pMxpzR4Xr7CMu0s/flM1OKSBjc06UqfbRm62X5V31nF0z/WEgqx
         b+Xg==
X-Gm-Message-State: AOAM5312tAs6SAVWwKfhjkwH8BNHLmw3hSRt7cAN1rmbSRWrvkVEyIw2
        Z2lXMZSczlWmOj5qPg8HMgOIWZAfsbyqezOw
X-Google-Smtp-Source: ABdhPJw1/SVGuNuKYqeQj3gya+N+5e+tIkE/uNdIx5Ao8RTHRfFDKt0ZWnA8kieJGGxP2CFd/NJ80w==
X-Received: by 2002:a17:902:a9c1:b029:129:cfd5:a948 with SMTP id b1-20020a170902a9c1b0290129cfd5a948mr21894354plr.55.1626087390357;
        Mon, 12 Jul 2021 03:56:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v21sm15187051pfu.192.2021.07.12.03.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 03:56:30 -0700 (PDT)
Message-ID: <60ec1fde.1c69fb81.19300.bdc9@mx.google.com>
Date:   Mon, 12 Jul 2021 03:56:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.131-349-ge00f43b5589ca
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 158 runs,
 6 regressions (v5.4.131-349-ge00f43b5589ca)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 158 runs, 6 regressions (v5.4.131-349-ge00f=
43b5589ca)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.131-349-ge00f43b5589ca/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.131-349-ge00f43b5589ca
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e00f43b5589cadab273a70c441394d45f6614ece =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60ebe8d2ac497ab959117981

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-349-ge00f43b5589ca/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unle=
ashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-349-ge00f43b5589ca/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unle=
ashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ebe8d2ac497ab959117=
982
        failing since 233 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60ebeabc449c256d891179ab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-349-ge00f43b5589ca/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s=
905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-349-ge00f43b5589ca/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s=
905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ebeabc449c256d89117=
9ac
        new failure (last pass: v5.4.131-349-g11c6e4069b3c5) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ebe77d645cd56a9211799d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-349-ge00f43b5589ca/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-349-ge00f43b5589ca/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ebe77d645cd56a92117=
99e
        failing since 239 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ebe7886f264bdb33117978

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-349-ge00f43b5589ca/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-349-ge00f43b5589ca/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ebe7886f264bdb33117=
979
        failing since 239 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ebe789cd642aa900117977

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-349-ge00f43b5589ca/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-349-ge00f43b5589ca/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ebe789cd642aa900117=
978
        failing since 239 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ec02caa21f4814a211796d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-349-ge00f43b5589ca/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.131=
-349-ge00f43b5589ca/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ec02caa21f4814a2117=
96e
        failing since 239 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
