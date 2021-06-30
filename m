Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB7E3B8A5A
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 00:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232585AbhF3WPI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 18:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232459AbhF3WPI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 18:15:08 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32B5C061756
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 15:12:37 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id v13so2317165ple.9
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 15:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Urdv9088pTfXgxauct2mSvYS89uediPlD53qjl/yawU=;
        b=anz4MRustgY4DddZJm1LMFpYGdZ8CXNJWRWGd9d3B7O9l82fzN6jMfcJl7HB5rulM1
         /SA3ucrWV2Th/sLyo98A0jf9kVFxeeZeJ+7XMl7wFLZAYlvnuum3+sxAz5Ljw8fCY7jt
         nNcPl/duBAJlllrmcBk/7rLr5JnPqq7MQDTA4nq+B4wHqa0k71uLT+bH515jlF4x1jZZ
         M1pMdCQV3m5qC7ye8chTRsiqPcp62WuXXjtXbHN3aJAGjT8irmQrWkDpm9Oh4LnkLPl6
         r69ZRbWhYdw8h5WmkpUBke5n2Vp+nc6Ck8eyfO0sGipBaURJsSE5JHQ/pDHT8hdriagi
         rHbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Urdv9088pTfXgxauct2mSvYS89uediPlD53qjl/yawU=;
        b=IXhTOaVoMK5sCR2jsEUxxOoMPy6/VFp6Fmzsmet+TQotM1heWMNlvuLG7N49NQsUES
         mJ0kJ6sbp/8wAitZHE4SLunINltk2qTJNLD6nzoaG3pvSlzzb+d5RIRZehJOhbFxaei0
         /EQ167OkvGuwKXcaxWfhEPt23iKf/ddc8qqwvT0vnP06hJGzvcTyqobMvK/enfPv7x0u
         3pXkbQ2UighBBetUew8omCB5+hb0GpgYdWJBl/k2dp4kMRaq2G7FIH8Wk4zJqTtvaZ+3
         LKzexSxKjWn9UDbn77V/xR0KEr52Cz4rcop02gQji6+uZEACE2zqQ0n9+lWXf6/0Toc8
         mQOg==
X-Gm-Message-State: AOAM5326MVuqU/PVgIFPieccMUyJJu2/JxkL43Est5canqP80I20VBQA
        h97GrXSJYKkfCXz6olJDxPCAec8ObueMtKuT
X-Google-Smtp-Source: ABdhPJzZ++riMhk5VFP/wvb9rfkf4BULN87XsCkKiMG0ODweew56WKwWG/ZgmibIOKcgkhsZERUB+Q==
X-Received: by 2002:a17:90b:2504:: with SMTP id ns4mr6674615pjb.140.1625091157117;
        Wed, 30 Jun 2021 15:12:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d127sm22260493pfc.50.2021.06.30.15.12.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 15:12:36 -0700 (PDT)
Message-ID: <60dcec54.1c69fb81.41d58.2c18@mx.google.com>
Date:   Wed, 30 Jun 2021 15:12:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.129
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 146 runs, 5 regressions (v5.4.129)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 146 runs, 5 regressions (v5.4.129)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
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
el/v5.4.129/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.129
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      82ffbc138a1fc9076f55e626bd8352fc9a2ca9e9 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/60dcb5ea431cb189f023bc25

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.129=
/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.129=
/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dcb5ea431cb189f023b=
c26
        failing since 222 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60dcb8d054f1dc311d23bbcf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.129=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.129=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dcb8d054f1dc311d23b=
bd0
        failing since 228 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60dcc09083ef0ce09623bbdf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.129=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.129=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dcc09083ef0ce09623b=
be0
        failing since 228 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60dcb8cd8b855c4a6d23bbd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.129=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.129=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dcb8cd8b855c4a6d23b=
bd6
        failing since 228 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60dcc363f59a6c68fc23bbe2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.129=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.129=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dcc363f59a6c68fc23b=
be3
        failing since 228 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
