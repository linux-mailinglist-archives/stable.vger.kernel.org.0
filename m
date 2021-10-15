Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF58442FD15
	for <lists+stable@lfdr.de>; Fri, 15 Oct 2021 22:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233669AbhJOUof (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 16:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233367AbhJOUoe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 16:44:34 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D56C061570
        for <stable@vger.kernel.org>; Fri, 15 Oct 2021 13:42:28 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id t184so8479658pfd.0
        for <stable@vger.kernel.org>; Fri, 15 Oct 2021 13:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TyNvP7xPd6NItu67NP3ogaE2s/ayGZPMghL8CD8sK1o=;
        b=Kn16PcVTkUUs/mMbluDYoCf+V10m6Ud6Z93NuDcs2uKF493lAIXp91to2CUHBNCt9a
         TvADPRaJf4WPqIIHwffbk8/rhT2hD6DYWIt/8o3lzYJZlcb3NnWmkgK7ZQSLIe9Vct7r
         r8xwk8TD33UTGdmNyt+tfd0dX+9hgBRfncBLdYlK/EOSrD8gukx/gUr1IR4xK8UL7Vob
         oixzlksVi7Jq0kN8YuTztq+DiM2mHpRKiMcPx/LwM6de0GrHaMi+ckU8ZmRV443uXp/z
         vHdtow7C28uiOVtL8B5XMJj5wJIWgCrwMbOLdG4lBEEFDt3Sp71eBXWE56H8cyAFY4sN
         aVGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TyNvP7xPd6NItu67NP3ogaE2s/ayGZPMghL8CD8sK1o=;
        b=GvV6AKgpDI/HzVGTWmh7A4UUQR8LyA5BunLFTOnIrVUjhZUzNjP/D4NfAyNARwkGY2
         GiCTugr9zG8h3AzsSfMmU1EdPQXkUr55CEmj57NjKO85SxogGKK+xBN8L/SzNMs6Lgmy
         +u938zaGhREsOCPvteb/qZ8p+xv7Pvq7SSLrFsedZp87He8QQ3X0tmun2W5kxNkRYPsT
         Zz4m7Ag90bOWm6jMA3mMx7vuJ2RyFD05YxysMRAOuTX1vcrFvLqur8NVYwh7MbrigGYT
         hTS87iaCa5o5GxahIMzYgjasf4Ln1jCPWfnIW2nLUxqBaYmyftz5u91O+bK74IsLEDBh
         I7WA==
X-Gm-Message-State: AOAM533+W/ghb+wr4pRrobREIbB+HIlW1s71IhHJuhANbvw8TmmRhUCT
        aKPnrEOWKp7pd+KFMNpNbCwccty+n0VQKZLY
X-Google-Smtp-Source: ABdhPJyRZVZIu6zVvF/RWgxapBgfQ6/8+bOEi6C9jf0QKDCq0akhS4nyg0GNQq5yrhJClhaON0gxOQ==
X-Received: by 2002:a63:7d01:: with SMTP id y1mr10848845pgc.343.1634330547458;
        Fri, 15 Oct 2021 13:42:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u66sm5890285pfc.114.2021.10.15.13.42.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 13:42:27 -0700 (PDT)
Message-ID: <6169e7b3.1c69fb81.331a.1fed@mx.google.com>
Date:   Fri, 15 Oct 2021 13:42:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.211-12-g9f51dcb3279c
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 86 runs,
 3 regressions (v4.19.211-12-g9f51dcb3279c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 86 runs, 3 regressions (v4.19.211-12-g9f51dc=
b3279c)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.211-12-g9f51dcb3279c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.211-12-g9f51dcb3279c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9f51dcb3279c0e999aa2919a7aaea7574ad8aa79 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6169addb0351f1a9873358dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.211=
-12-g9f51dcb3279c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.211=
-12-g9f51dcb3279c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6169addb0351f1a987335=
8dd
        failing since 335 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6169ae84602ee97e1a3358e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.211=
-12-g9f51dcb3279c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.211=
-12-g9f51dcb3279c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6169ae84602ee97e1a335=
8e9
        failing since 335 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6169ae7d4eb2945c16335906

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.211=
-12-g9f51dcb3279c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.211=
-12-g9f51dcb3279c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6169ae7d4eb2945c16335=
907
        failing since 335 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
