Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47299401F6E
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 20:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235314AbhIFSMN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 14:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235188AbhIFSMM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 14:12:12 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E88E8C061575
        for <stable@vger.kernel.org>; Mon,  6 Sep 2021 11:11:07 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id k17so4348915pls.0
        for <stable@vger.kernel.org>; Mon, 06 Sep 2021 11:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4FfuIQJ7LKnrfkakDKiLyTHB32W57S9pNMa8ozy7qoA=;
        b=L7LUqYNw5eAqOATkDjMq7WgcVNvtGjsz3sgTtsj8OF08LSuBCl9tj7YC7u3XkzRtdO
         RhD2gYWNVqP4H0Kgwk8dZ7ePzdaxFRoE4tL/mOuO3666qeIy+OBmkBVuw/h+yZW3tOKC
         jJwRDAcNdxX7GAdY36322lTVcjkK1YJln2kfuD/9WqGPqN1mfEEAIpJD5dwYpirEq+jA
         qegdE8fNT9VZy5q0FX+/KDgi+fgBmal6HJUTrkssG3p+KoLYcqGBw5lsD+suNTxE9lkq
         fYTAUBhXmX3b3UstIEFEiF0IC2nQ/fL/ZDqSN4FMofjXs+pyYR5f4nyJLDcH1kJREFK5
         erjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4FfuIQJ7LKnrfkakDKiLyTHB32W57S9pNMa8ozy7qoA=;
        b=HqMIEkkyUS8yzqJtiXtBKt6Yrm7VId+vBraOsduhezZf9DeYW5LzIrIO3qshVFwckB
         5cv4iy++aTG1lxEj5H4OjtXsfdCk89j3OP9rk+5Z4yKG+wusKcHsfnG0KE9EQH+MwEs0
         i2JXUkwzYmQYsSD9E0Zl32AnVoLDRGk7UwRR0eWUnp+OGNnlfs5B/ffwCzA/+fmgZ+wO
         IpyJFCkj1AtNUd3CWP2Lw+O/OF1TcxCBsoBk/s+Ara01JmQDVLzEHlu4MPxhAnaOrWUp
         Y7US1kEAVmPi9B/G4NKuxLsF/kzBDgV3M/1Nn4E7PI3xa+RJBrx9F0WRkOMbLNxNarhC
         z+nw==
X-Gm-Message-State: AOAM532l34DJNm5/v9tKPC3GAL3BGKpUAM9hItpe12ruGkS639VNVYC+
        rZWvkjBtBsbWcgqiIMO1zYCQo7EMH2bsvIs1
X-Google-Smtp-Source: ABdhPJx2Ai17Ety9OFNlrQ6d+v9PhHQGkSj2j04jcVRs4StdZVp9aAFOGPWQwVa5cbDHpU4AlpRWjw==
X-Received: by 2002:a17:90a:aa14:: with SMTP id k20mr368290pjq.88.1630951867274;
        Mon, 06 Sep 2021 11:11:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u24sm8367122pfm.85.2021.09.06.11.11.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 11:11:07 -0700 (PDT)
Message-ID: <613659bb.1c69fb81.dc2d9.74fc@mx.google.com>
Date:   Mon, 06 Sep 2021 11:11:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.282-16-g4e95aed01b45
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 147 runs,
 6 regressions (v4.9.282-16-g4e95aed01b45)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 147 runs, 6 regressions (v4.9.282-16-g4e95a=
ed01b45)

Regressions Summary
-------------------

platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =

qemu_x86_64          | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig=
    | 1          =

r8a7795-salvator-x   | arm64  | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.282-16-g4e95aed01b45/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.282-16-g4e95aed01b45
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4e95aed01b456b4f17fd8453960fa58d6be6717b =



Test Regressions
---------------- =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/613628855b2aee7153d59686

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-16-g4e95aed01b45/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-16-g4e95aed01b45/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613628855b2aee7153d59=
687
        failing since 295 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6136291ab5796799dbd596a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-16-g4e95aed01b45/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-16-g4e95aed01b45/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6136291ab5796799dbd59=
6a7
        failing since 295 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/613628ccf95a39158dd5969a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-16-g4e95aed01b45/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-16-g4e95aed01b45/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613628ccf95a39158dd59=
69b
        failing since 295 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/613629318e567413b4d59685

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-16-g4e95aed01b45/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-16-g4e95aed01b45/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613629318e567413b4d59=
686
        failing since 295 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_x86_64          | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:     https://kernelci.org/test/plan/id/61362713454c6420c1d596a3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-16-g4e95aed01b45/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x=
86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-16-g4e95aed01b45/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x=
86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61362713454c6420c1d59=
6a4
        new failure (last pass: v4.9.282) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
r8a7795-salvator-x   | arm64  | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/6136276276b94e1988d59666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-16-g4e95aed01b45/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.282=
-16-g4e95aed01b45/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6136276276b94e1988d59=
667
        failing since 292 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
