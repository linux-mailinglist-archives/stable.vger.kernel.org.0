Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6D5418A87
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 20:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhIZSnz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 14:43:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhIZSnz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Sep 2021 14:43:55 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C0A3C061570
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 11:42:18 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id k26so9131090pfi.5
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 11:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0emdbXW5hedhtiTFILc1KD7mLA9bCbS+F/BKxpL5K1I=;
        b=CM/Em4wpZbEniUTN2csQ5VtbvjK5nxBackT6/eGLkfZac23zfwKYVaWG9zIOluRYG/
         6xwT+VCsy6XAZ6Wlt13Qlj8IYx3/roSEdhNSMe9gouJlE2+4NFpoNmOe2Q65Z5z5p1BB
         W1u2utHZj34T/NgluX5DDItLMPIGSexiOhoz7E1sHdYvzsRXp6NYlJB2YNr6tWBsCrDt
         GlUvhBvD3j8rewoBUbz6A2AhijQOkk8Y0yx12c8TyJQB3PFymWyFkgkfGzrlTEA9lmb2
         +fk2yuWEHZjJOFSpLYr/HnAtFgg44kcQPd9tg/fHD1OO2qNdul0/exkMl1Bu6kDUFTh8
         o+4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0emdbXW5hedhtiTFILc1KD7mLA9bCbS+F/BKxpL5K1I=;
        b=4EAc/CQwp9fHfv6cCTcly0I8vFDZQdCLGPi4v8QFY0clbLJfxvjT0sDeljlYMpjM57
         PzR4saqvznv565fd2s5TvhKi3aUlsC/eT2fLHne8EXkTePAX9n+rXZQzOjdZBknN3EOs
         9RqZYwyyrpt0PbZNLW4VADP8GVtMs0M0AbYtCo3l1mCWsOIKkhzpcGxE540HEJI8DG7h
         6RL7/9Cznp0y7QKzXnSz6/z2/BZosKnYTwlfnVHV59LIODb9zC0oqrJenkFVv3i+qIlD
         /h+j+v6gFEmbgAcgIwkb3YqDKvNguaDeOXnZp0Wb4JeY2fhVJj/5CQExC3ZOSW5VoIG4
         5nLg==
X-Gm-Message-State: AOAM530X8uGi7feF389ajVygOxXgBjnq86YUV2h7usMS/k0SLs+s33gZ
        iBqITOo5EqGXH3lXK7iuqzbvSBJ/LvfY3hnd
X-Google-Smtp-Source: ABdhPJwPR6zTBYXk0rFAxaLAJLp0OBPDNBKHs120Y8wtGfy9AuQS8wsSXcfQuDr+c4volGemttm7Wg==
X-Received: by 2002:a63:4607:: with SMTP id t7mr13345082pga.332.1632681737774;
        Sun, 26 Sep 2021 11:42:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ft14sm16824569pjb.34.2021.09.26.11.42.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Sep 2021 11:42:17 -0700 (PDT)
Message-ID: <6150bf09.1c69fb81.8a6a8.96f4@mx.google.com>
Date:   Sun, 26 Sep 2021 11:42:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.248
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y baseline: 48 runs, 6 regressions (v4.14.248)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 48 runs, 6 regressions (v4.14.248)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.248/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.248
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      f11944f1aa1cda3fd8b4edc71e3cf9dceb40234f =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6150859cc8222f257699a2e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.248/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.248/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6150859cc8222f257699a=
2e9
        failing since 311 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615085a8357455b28099a2e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.248/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.248/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615085a8357455b28099a=
2e3
        failing since 311 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/615085336d4bd6c87299a2ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.248/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.248/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615085336d4bd6c87299a=
2ef
        failing since 311 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/61508571c19292bd3199a303

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.248/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.248/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61508571c19292bd3199a317
        failing since 101 days (last pass: v4.14.236, first fail: v4.14.237)

    2021-09-26T14:36:06.801312  /lava-4585436/1/../bin/lava-test-case
    2021-09-26T14:36:06.818145  [   16.903294] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-26T14:36:06.818478  /lava-4585436/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61508571c19292bd3199a330
        failing since 101 days (last pass: v4.14.236, first fail: v4.14.237)

    2021-09-26T14:36:04.368412  /lava-4585436/1/../bin/lava-test-case
    2021-09-26T14:36:04.373671  [   14.471724] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61508571c19292bd3199a331
        failing since 101 days (last pass: v4.14.236, first fail: v4.14.237)

    2021-09-26T14:36:03.350201  /lava-4585436/1/../bin/lava-test-case
    2021-09-26T14:36:03.355697  [   13.452667] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
