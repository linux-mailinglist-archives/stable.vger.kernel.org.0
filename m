Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E479942E98C
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 08:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235828AbhJOHAp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 03:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235787AbhJOHAo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 03:00:44 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461DAC061570
        for <stable@vger.kernel.org>; Thu, 14 Oct 2021 23:58:38 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id w14so5818595pll.2
        for <stable@vger.kernel.org>; Thu, 14 Oct 2021 23:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=H6PTyPqOthznHx65xJu5Rond5sLPCvMCpDJo/A1zxoc=;
        b=CTfy8RemfFru5FzUNpUuvb5K6BGX5kpQnkxiQlWS4IyJquNFDtWH+EEilMP036Z6Xs
         cMAnMX6/MSKaKd1IKlqdWCX+i/nebr0SF4+W2auwUvLGJ6G9X2sazIuD6X56VXdah+td
         HWkta4Ker0m1dymHrcdcPOw/c/rsDUU5zoy/y6sbdQVziz5Pt7w3gTDWYMyzLKgBelpa
         M+3H6xnsCzlmA4fBFiKB+Z5aaDh9srpGliMAtz1yTI9pvkgWY5vwqxHTSpokiDkIrS5q
         BQizy0FeAN8po40p8AqcvjEqnT3WBxOPnC8Hzoc2Dsc+6eyIdkw0dLUCq8e8pTkHcSmK
         pzkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=H6PTyPqOthznHx65xJu5Rond5sLPCvMCpDJo/A1zxoc=;
        b=4ZqTuyaZ6EiIPXRAzrRK3xrcAZQg+Rz6fxZDLPH+pgR/aHSA0lxDr0e9EtUzKva+dW
         uDxjYSNhZ8dGto+wCe7PpHsGne53IQ1Cs21RQ3+U8voIeI1Ib6zeDODnp05snJn7Dsbf
         Q9UfTLbfEkaFdMkk+x8lR/YOqWqZLIOo9mOPfaS9FLnrYD/qQhpn4m7HfJuXbcVmyjNw
         oH8Ix6kjPeo6v2eTu+dx0btvTmRwGAbzZEMbhVMusrI90rKVgdAZ7Inm8NUjuh4jts0k
         VwM2SI93SFJXCSdf1Ha+AmeEu51rNJ9UUFePNc9d/PkQ0S66DMJ+Uo93OXOWbwXcyP8W
         AbtQ==
X-Gm-Message-State: AOAM531bF/xoJKMHt+BdN4z9y6Ap4lkvUjd6j+APTxo70yUUQlIIICXK
        D5YYeBWOn7CYCTCmMwKdGYvxJzcEJDuE9Ihu
X-Google-Smtp-Source: ABdhPJyPXnGRi2Pp9qUABkP2N9mdGJgU6kVrTpmqp75g7K3MsTYJ7yaGkOgJM/pSM2rqH37a246b1w==
X-Received: by 2002:a17:903:32c7:b0:13e:ea76:f8cb with SMTP id i7-20020a17090332c700b0013eea76f8cbmr9559205plr.74.1634281117310;
        Thu, 14 Oct 2021 23:58:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u24sm4127684pfm.27.2021.10.14.23.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Oct 2021 23:58:36 -0700 (PDT)
Message-ID: <6169269c.1c69fb81.dcf0b.d71f@mx.google.com>
Date:   Thu, 14 Oct 2021 23:58:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.286-26-g2660ee946a02
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 83 runs,
 3 regressions (v4.9.286-26-g2660ee946a02)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 83 runs, 3 regressions (v4.9.286-26-g2660ee=
946a02)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.286-26-g2660ee946a02/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.286-26-g2660ee946a02
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2660ee946a0246c54d930bc9fa6d2239ce8014b8 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6168e85272a7f30fe43358e1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-26-g2660ee946a02/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-26-g2660ee946a02/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6168e85272a7f30fe4335=
8e2
        failing since 334 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6168e8ed2523ff61683358dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-26-g2660ee946a02/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-26-g2660ee946a02/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6168e8ed2523ff6168335=
8de
        failing since 334 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6168e8dd16303a09b13358ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-26-g2660ee946a02/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-26-g2660ee946a02/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6168e8dd16303a09b1335=
8eb
        failing since 334 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =20
