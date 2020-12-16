Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97AFA2DC32D
	for <lists+stable@lfdr.de>; Wed, 16 Dec 2020 16:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbgLPPeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Dec 2020 10:34:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725957AbgLPPeb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Dec 2020 10:34:31 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8346C0617A7
        for <stable@vger.kernel.org>; Wed, 16 Dec 2020 07:33:50 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id k65so7577067pgk.0
        for <stable@vger.kernel.org>; Wed, 16 Dec 2020 07:33:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YNrLARZ/wYZBP54orcJkW/9nFywgwArcWheVkPEQRyI=;
        b=ot7ZfKGxI8C+n4VD+CD1Y0FeizXc/VxZFHoZAJaZuxKODAYZFx+KADDMpapmAFPvta
         e8sWY73m5zCmz5FXEq4VXHaqmH15Uv6zlIMW7nVS45mVRPAajFCQEax9DFKOqGm5oCli
         weeyefAk5Zzyn0I4S+dlwXEV9vNdk+nRMoTiOtOCakHWPB+9oVKysNPbzd7JilUuhZE0
         2azBH20OXSZLmC6G9kThz0ARWQCs5CjJomjEFlQjfTJ17zVLkmmTu1tFxqZ8hHzUc9Pg
         YWKX7RZRj+2H+96DU+oorSoEBplKIcmk4juisWYHe4gblKqxU1DdH3CcBk476pmtgrtt
         RDqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YNrLARZ/wYZBP54orcJkW/9nFywgwArcWheVkPEQRyI=;
        b=MTjMsiyjDdqkOipQH4TXm2FRnXPD0ARnrcSOyOZkCGKrlkxfUyyjBfu+qofr2Ao6FK
         FyFzx9/mDGWIHOMnftkUyzu+McEkTSAjYTcsmsNaZqd2QNPjRPGuIVz7QL6ZYvkZWnqR
         CkBZhh6OxS8NlhE0gGsVlAVTevRaR9zbT1rx8GrkEytps9MAZKPbXitQVYlof6w6NkZ5
         n17WBFAUdwxUbguNTNqAsqxWGJyGhuLXiqc55SA+aKjwji2BK3nL4PAUUazdXIrU7N0Q
         ifBDep9/4GjhE70p3D1UJ8fVNs1xP+NxNWwGlFgsFMMwOcbu1cybT47Ct4gBYcEAPNWw
         nesg==
X-Gm-Message-State: AOAM531tR9kgPw5EV/rXGp9/rAK1M1SMeesaUJqwbgDj01uorYXufzR8
        3HUuyQyDCVLOW7RILovF6f+6ZeLj6fDEEQ==
X-Google-Smtp-Source: ABdhPJwCaE515gwgHCfPU2vzqu69o1Y42//Lya2U/Ni3DQSCGRIHvzkmMipH0/jwSXeUP7x53OJxhA==
X-Received: by 2002:a63:db41:: with SMTP id x1mr33866735pgi.446.1608132829889;
        Wed, 16 Dec 2020 07:33:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h20sm3046825pgv.23.2020.12.16.07.33.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 07:33:49 -0800 (PST)
Message-ID: <5fda28dd.1c69fb81.4618d.6637@mx.google.com>
Date:   Wed, 16 Dec 2020 07:33:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.212-16-g8846756b47f8e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 111 runs,
 5 regressions (v4.14.212-16-g8846756b47f8e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 111 runs, 5 regressions (v4.14.212-16-g88467=
56b47f8e)

Regressions Summary
-------------------

platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =

meson-gxm-q200             | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =

qemu_arm-versatilepb       | arm   | lab-baylibre    | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-cip         | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-linaro-lkft | gcc-8    | versatile=
_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.212-16-g8846756b47f8e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.212-16-g8846756b47f8e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8846756b47f8e002a40a7dc6db1b26143365299b =



Test Regressions
---------------- =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd9f3faf2e6b93caac94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-g8846756b47f8e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s9=
05x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-g8846756b47f8e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s9=
05x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd9f3faf2e6b93caac94=
cba
        failing since 2 days (last pass: v4.14.212-2-ga950f1bfe7736, first =
fail: v4.14.212-9-g0472cccb2d80) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
meson-gxm-q200             | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd9f9103ed0e88735c94ccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-g8846756b47f8e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-g8846756b47f8e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd9f9103ed0e88735c94=
ccd
        failing since 8 days (last pass: v4.14.210-20-gc32b9f7cbda7, first =
fail: v4.14.210-20-g5ea7913395d3) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-baylibre    | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd9f406f2e6b93caac94cd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-g8846756b47f8e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-g8846756b47f8e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd9f406f2e6b93caac94=
cd5
        failing since 32 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-cip         | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd9f40aa6dec610dac94ccf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-g8846756b47f8e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-g8846756b47f8e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd9f40aa6dec610dac94=
cd0
        failing since 32 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-linaro-lkft | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fda17e4fbbf4c3adac94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-g8846756b47f8e/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-g8846756b47f8e/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fda17e4fbbf4c3adac94=
cba
        failing since 32 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =20
