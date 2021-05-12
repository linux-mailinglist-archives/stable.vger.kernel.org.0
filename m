Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA08537EDC8
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 00:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235922AbhELUwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 16:52:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389208AbhELUvU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 16:51:20 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69956C06138C
        for <stable@vger.kernel.org>; Wed, 12 May 2021 13:46:47 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id c13so6150874pfv.4
        for <stable@vger.kernel.org>; Wed, 12 May 2021 13:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Qj7Z4nBHT1MqkQzuXIpYAyBA8YUDJIbma574yzvkI1o=;
        b=ts8OLXSwQwMRAi6kOsGhLag9mFJDH38n/qpuMv0YOdzPDosK1gZM4ZrJqwo6bDSkkw
         +qVisTJ25ZMulSRPC3/J0L1K+lqnVp6/bNjYKYdvFqZBc5sIGL+uTFhlXao4iWA3B69L
         1h9tVywtcwXkKPSNrrBqIUeBQTZ4rjCv0zcm9/e56ChLpMaKbi9jamBaVy6Hb8C9iKxf
         jnVYH3JVrRCmMyIX9TTbuNLnEDFxoMehXqsuTNFMMhl5aiArE69onC6M/xGtqsGBlo9u
         aV3TfKrqoS5NBfFsmm7bZlTNuP7HG5J53c0wCi7WfLtBrMqoCbse4V2Qj0UsoMopDXNM
         UYjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Qj7Z4nBHT1MqkQzuXIpYAyBA8YUDJIbma574yzvkI1o=;
        b=GOHIZG0SncELmAv38dIzjAss1mx7f3Nlge1Niim8x+0zv6LGRkW8cYE2tuMjnysiw9
         oq4/Tmv5KaUyak6uI5uCSqy+alc94u3p6JorB9dGM1s0Npu5S15h5RCPtstIx+K4zWad
         SI9icFC5umxvbnFWIwQnWi/J7no4sLWdzzmUJRh8u2BN5Jd9RSTBqb6fusMF/n9r0LOe
         gfbXWy56r4RZWW6W1JPkNGQURgm1lwwbQXB2fiS8ntsMDEPrlBTUDg8zGdOsiHXFNIFQ
         pL0zFRkHja3v/rnLDs0RQ5lKgTlb0So+1Z2zBfRyzCxRltBUMsBMajMnodw0STuEVQYk
         uybg==
X-Gm-Message-State: AOAM532RJszvM4XhOev+N1AYuAvGK2xKljcfFWge5WCez1+5q9OFJtSb
        /QQlPbxMywlXtzGcoQj2agQJwG36FgmDC1g+
X-Google-Smtp-Source: ABdhPJxpoTBeMUBTOUzFpf0appG6z1+Jes8lxeBVmI0GI3euoE0pv/wOn8F7ob3VCb2ccDD0MaUYnw==
X-Received: by 2002:a62:5cc3:0:b029:203:54be:e4c9 with SMTP id q186-20020a625cc30000b029020354bee4c9mr37173849pfb.80.1620852406863;
        Wed, 12 May 2021 13:46:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 14sm567467pfl.1.2021.05.12.13.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 13:46:46 -0700 (PDT)
Message-ID: <609c3eb6.1c69fb81.97091.2b0d@mx.google.com>
Date:   Wed, 12 May 2021 13:46:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.190-303-ga5a0802d82250
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 143 runs,
 4 regressions (v4.19.190-303-ga5a0802d82250)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 143 runs, 4 regressions (v4.19.190-303-ga5a0=
802d82250)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.190-303-ga5a0802d82250/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.190-303-ga5a0802d82250
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a5a0802d8225086d75e161f55af5ae53b2d919bb =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609c0a1c138f4b99a6199277

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-303-ga5a0802d82250/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-303-ga5a0802d82250/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c0a1c138f4b99a6199=
278
        failing since 179 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609c0a03747d4aa83819928c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-303-ga5a0802d82250/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-303-ga5a0802d82250/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c0a03747d4aa838199=
28d
        failing since 179 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609c09f2a6b1d10b25199289

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-303-ga5a0802d82250/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-303-ga5a0802d82250/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c09f2a6b1d10b25199=
28a
        failing since 179 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609c098ec61a0e6412199289

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-303-ga5a0802d82250/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-303-ga5a0802d82250/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c098ec61a0e6412199=
28a
        failing since 179 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
