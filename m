Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FFB373491
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 07:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbhEEFKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 01:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231709AbhEEFKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 01:10:07 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4981DC061574
        for <stable@vger.kernel.org>; Tue,  4 May 2021 22:09:11 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id t4so497151plc.6
        for <stable@vger.kernel.org>; Tue, 04 May 2021 22:09:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9iczGvuGNeosKzu3kZIrzZEndmxRez+HxPc+YbpHPoA=;
        b=g+dzNKdNZIVh6+ylXpO6NQKmwDFeC22nt0yx5wMcHBHubks0xxcpY5gg24Ord88hSV
         0XIAgwTM6ds+4veMdIaiMryFIKN9fw7OOZXssYF1Y9PpA2VYrNmbCAtAHxJoZ74lQy9n
         QKzhcGi+TE7pEixPmp3uYMub7Sh8TVNCLrhwLI70G0VMr7c4JQhESRZ5IgcA7rRh68qS
         dpSL4EnxHoQ5sqR4pMHMfI4FPrLPol7/B8jJwMT67sj9LJjt8czYL/ENrIR9gzw3fRyt
         puw6EqetP0PYN+U2Nm9YVwAU5zib5f1Mv3YtdMUEjTPi9/KcvdVowjnabQwRz+BZTmIn
         j+yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9iczGvuGNeosKzu3kZIrzZEndmxRez+HxPc+YbpHPoA=;
        b=gl6pOQiRZZSulT9RhmINEl/1clcFT6V23WBWupPdquyMP5X/cyMdZ0FqDotzy7yf6S
         iNBuj/uIWpw1IcFn1f5HewCs4wA9/CYUiyFbVvwtxi0sHbosgtSj7KaZt79Q624LAlyi
         wxVlJelhSbr8hUbG3RnQ9dwbG6M2aHCm+QNQvIv0q575iTlGJIOLRJpdmAxt1mSICHhm
         BKSCIbhim5JtNdsX3tgaq17sS1BMKocVYDHvcpqF//f44H6kP9L3EqIv8m7sbfKBYI6U
         KSN0fQTYpTHvOSeHk1vxAIkZKFdwLL1dIgwoqSbguU0des2LeK5dSI7vMY/4l6y4NK1g
         yYCw==
X-Gm-Message-State: AOAM532v9sU4p9dBYNK7vlA+7tT3R2RIKFbxHIALx/NFf6broJsFRAmA
        gJMwSBg808pIK19cYTkSX+jZhOUgkVrQBxub
X-Google-Smtp-Source: ABdhPJyOCi4gu0lkfpV6mbPzC5ff+FsdHh9jZ27Ys5P4NjFD67vDdjKhRGgUSjhABIw/XwaIa6KNzg==
X-Received: by 2002:a17:90a:e558:: with SMTP id ei24mr31478793pjb.43.1620191350502;
        Tue, 04 May 2021 22:09:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h20sm13464147pfv.6.2021.05.04.22.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 22:09:10 -0700 (PDT)
Message-ID: <60922876.1c69fb81.5cbb6.327d@mx.google.com>
Date:   Tue, 04 May 2021 22:09:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.268-3-gf00dcad1af0ae
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 55 runs,
 4 regressions (v4.9.268-3-gf00dcad1af0ae)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 55 runs, 4 regressions (v4.9.268-3-gf00dcad=
1af0ae)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.268-3-gf00dcad1af0ae/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.268-3-gf00dcad1af0ae
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f00dcad1af0ae4a206aaec5871c266af4477cdf4 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6091ee712876dd0912843f1b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-3-gf00dcad1af0ae/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-3-gf00dcad1af0ae/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091ee712876dd0912843=
f1c
        failing since 171 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6091ee772876dd0912843f24

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-3-gf00dcad1af0ae/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-3-gf00dcad1af0ae/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091ee772876dd0912843=
f25
        failing since 171 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6091ee6b71a7952a9f843f1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-3-gf00dcad1af0ae/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-3-gf00dcad1af0ae/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091ee6b71a7952a9f843=
f1d
        failing since 171 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
r8a7795-salvator-x   | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/6091f2a927e42df944843f1e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-3-gf00dcad1af0ae/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.268=
-3-gf00dcad1af0ae/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091f2a927e42df944843=
f1f
        failing since 167 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
