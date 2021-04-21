Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC823367322
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 21:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237440AbhDUTFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 15:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245485AbhDUTFb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 15:05:31 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F02C06138A
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 12:04:57 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id m12so10092075pgr.9
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 12:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JnrmvGlc0oj3kgzLBZThYPOLbhq/WZv843g5mLcCQhc=;
        b=sy+AY1lYLNYMJ5VtJ5bEeSMfxNgN8lQ4uLFCQRLCbPjPzef/vUfZBR7+2qQCtDTFGl
         VTw7KLNMbHZWi2I+JUUnh/cYw/W0hfItg6/BWuk51Ud1TlHE7daiL1nuPZj0pyy5FVeT
         Y9iuglRjhv/qG8csdOcL6bfJZORIB4f165pL5iIiHbbZC3UB3SVBdPo/vaRHPACZS1c6
         ECG6sFWn2VntTwfpoq3VfQY7gMNI7sD2hIroy6QJ15MJ2RiY5VAJq94Uan423jt7Kxk6
         1rrXGG9VJU5NFHjhN9NtHeQS36+BDtn6vyR+7v4AYB15rpbplIViSw8iOohGsMxE2D9j
         6i5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JnrmvGlc0oj3kgzLBZThYPOLbhq/WZv843g5mLcCQhc=;
        b=beoltOVvyjcNQXetlnllSehTD45N6WmbOtsIDdJZ/q8Q4G2Mfm98TMNSpNIfmMkLXv
         kSnB0NMFpRa5tDNNKoelpNAa9cvpwe9rrUrMfM2NE53N+BqknkuH+6PnLWc3gURbdvMh
         lyrXKw8NmaheMtfYrdG/A8VCaVAGk40KxbGlZxPq/fBmgQTOUaDlUpQv08A8SQB+nA7A
         YYnCGxg14i47BwwPPNm/4w53MmqyWbMC315dasMi/8WVVsPVMT53+Xg8ur678bhciEdD
         hB/RPXa6NtO+xnGanUVeOLvAjMinKuBUhjgrWUZ3YmSnrOhz3B0eFhlI438rOxyfqwde
         AoPQ==
X-Gm-Message-State: AOAM5330BAprOYrGuQyBinzBo7i+qZaRz7G9DBxBduKSsrTDHTIKZ9Dp
        eU8tOqEEeUTEzPR+Pt7AmuaFFWvLMl86aNta20I=
X-Google-Smtp-Source: ABdhPJx3CZ+3aNvo4+FRirvuEdJwR9GI/A0Y7r1Jg/yK0Y4L+qsjw/+kJw3X7VGsK5hVLkm3VWd3mg==
X-Received: by 2002:a63:1024:: with SMTP id f36mr23254275pgl.299.1619031896856;
        Wed, 21 Apr 2021 12:04:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ir3sm2743976pjb.42.2021.04.21.12.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 12:04:56 -0700 (PDT)
Message-ID: <60807758.1c69fb81.be44a.81c3@mx.google.com>
Date:   Wed, 21 Apr 2021 12:04:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.114
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 103 runs, 4 regressions (v5.4.114)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 103 runs, 4 regressions (v5.4.114)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.114/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.114
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a7eb81c1d11ae311c25db88c25a7d5228fe5680a =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60803eacc2b6fc0e2c9b77df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.114=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.114=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60803eacc2b6fc0e2c9b7=
7e0
        failing since 157 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60803e9689e75b399b9b77bc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.114=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.114=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60803e9689e75b399b9b7=
7bd
        failing since 157 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60803eb8c5c8d339f89b77bf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.114=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.114=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60803eb8c5c8d339f89b7=
7c0
        failing since 157 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60804957cdbc75e0db9b7795

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.114=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.114=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60804957cdbc75e0db9b7=
796
        failing since 157 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
