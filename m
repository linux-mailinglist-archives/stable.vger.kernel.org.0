Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6882FC100
	for <lists+stable@lfdr.de>; Tue, 19 Jan 2021 21:30:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729762AbhASU3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 15:29:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729688AbhASU3f (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jan 2021 15:29:35 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 534FBC061575
        for <stable@vger.kernel.org>; Tue, 19 Jan 2021 12:28:55 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id f63so5193940pfa.13
        for <stable@vger.kernel.org>; Tue, 19 Jan 2021 12:28:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GPuaA1MlVV8oD5XdjpK/X6B78kQU1emdRYVjCQ5GKmw=;
        b=yqlvjX/txST5Ef++nizsSrpf3K22Q09E7UmeMB9ed8VCmC7vSKa9AopkLfX/l3IunC
         vpabYtgL7UKr1qmyCGjdPzphWztZnR6RYBeGt/B6/kP/g+wRPqmC6KdOoWXEWWN1FQMm
         q1LTV6CQT88L3odMyl54H3sL6vTEEXYWHmGajW68kfntvoBa4FnOggRVIFYvibMZu4Ie
         O+wW39nVv1jKHOwmhLwl4mBMaLrb9FnR2/DZtincpEndimutjysF8JMmFu6421kikARs
         BdCBhApCSOaUzQWh44/g1RIEc7YolkaOSp/BWMB6CAzQH2osEcmNddx4rIGEvVm0NJJg
         xxlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GPuaA1MlVV8oD5XdjpK/X6B78kQU1emdRYVjCQ5GKmw=;
        b=sk11WBQihBcC46kNYNJuYOnPZwHp5HZajlpG3Z1bejcQh+HRJiwV/CvpM/mJj+HeT2
         YxhUz1KFRzyzJlnwqqGZgBXwiZXMcnZ3VHSPLpqYvu0LMQwht+mR0coU85FZIK+2f4Ai
         4sLPKU5GSLJcZ6y7XBJAKHlprz8TYEjwSu6ncQWunNXvQtaR0j4C6CLXI+BzDV+tItXs
         MFdp9JW5vwzqKrWH6VcIGjr783WgURnNvzBNSae+fdnc7b7Ulr9TPHvDdb8Q2CizXTX5
         5ol0owM0AN0Jiv4Za/h0INuF9ZitKpUMiiEmfHHGcqq7ajTyBR9vk99vVsUNEe1xvMGF
         ozow==
X-Gm-Message-State: AOAM533sCRnAriR6pJoo1SrS/JMc7TmPb+94jjIUH9f+dU3Z7NoijLP4
        oiZ9knnjv6J9byG2xtITTBhOlgrMSvWlLw==
X-Google-Smtp-Source: ABdhPJz8q8gDBVUWCFRFg0gdk2NbFVooX/INTfKS8gmHmfCnaoFsRiRA+UL1VKQGE/OdA56kv+FRzA==
X-Received: by 2002:aa7:9f91:0:b029:1b9:8f9b:b1af with SMTP id z17-20020aa79f910000b02901b98f9bb1afmr4666594pfr.3.1611088134541;
        Tue, 19 Jan 2021 12:28:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j6sm7255667pfg.159.2021.01.19.12.28.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 12:28:53 -0800 (PST)
Message-ID: <60074105.1c69fb81.2efc9.0f6c@mx.google.com>
Date:   Tue, 19 Jan 2021 12:28:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.252-23-gd1138eea2aad
Subject: stable-rc/linux-4.9.y baseline: 130 runs,
 6 regressions (v4.9.252-23-gd1138eea2aad)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 130 runs, 6 regressions (v4.9.252-23-gd1138=
eea2aad)

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

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.252-23-gd1138eea2aad/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.252-23-gd1138eea2aad
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d1138eea2aad08fd262fd6b161c1f2081f2d61f9 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60070b97e7f1cf14c0bb5d46

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.252=
-23-gd1138eea2aad/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.252=
-23-gd1138eea2aad/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60070b97e7f1cf14c0bb5=
d47
        failing since 66 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60070bb17135a0160ebb5d1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.252=
-23-gd1138eea2aad/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.252=
-23-gd1138eea2aad/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60070bb17135a0160ebb5=
d1d
        failing since 66 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60070b9f6af40d5917bb5d15

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.252=
-23-gd1138eea2aad/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.252=
-23-gd1138eea2aad/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60070b9f6af40d5917bb5=
d16
        failing since 66 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60070ffafab1b5cd37bb5d0f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.252=
-23-gd1138eea2aad/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.252=
-23-gd1138eea2aad/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60070ffafab1b5cd37bb5=
d10
        failing since 66 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60070b51586682a72cbb5d0e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.252=
-23-gd1138eea2aad/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.252=
-23-gd1138eea2aad/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60070b51586682a72cbb5=
d0f
        failing since 66 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
r8a7795-salvator-x   | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60070ec216440e9defbb5d0b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.252=
-23-gd1138eea2aad/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.252=
-23-gd1138eea2aad/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60070ec216440e9defbb5=
d0c
        failing since 62 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-79-gd3e70b39d31a) =

 =20
