Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A32FF3933B5
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 18:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235777AbhE0Q22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 12:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235623AbhE0Q21 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 12:28:27 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE9FC061574
        for <stable@vger.kernel.org>; Thu, 27 May 2021 09:26:53 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id m8-20020a17090a4148b029015fc5d36343so758128pjg.1
        for <stable@vger.kernel.org>; Thu, 27 May 2021 09:26:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IYyc3PUwllWih+k5oP9SRV2v/IMCyUU+WPXF5klDl6M=;
        b=xSjc9/2qIrpcWGv6AAw9BqsQJXOn+5EaKkblm+KN2DMemIUzbnZhVCWFQOvatYNb10
         lreHxDKzE9j9bcTenxpHnHRvTNJKWGHllkHgNHyxdc7qlSLr+yGMOS/77GOmv/K3o1ZL
         uXyV9Fozeebax/a/mTldq3MrkqDzHnmo6E0fjNjhP3o+EDxvVMimaeabVM4A1eD5gCDc
         OF7diQdIqtMAdMQyhlj4Ydlnr7Ct/DenqRNzEcoYX9K383c1cl30uW9tZbUoRcRrQFO6
         sAoDQA7RHp2k+qXOgcY9u3xBuoIVG7lxv++hnEdNjKCwnmj78j+xeQR+xYfTOa6TF8rV
         Brug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IYyc3PUwllWih+k5oP9SRV2v/IMCyUU+WPXF5klDl6M=;
        b=JXlk090e5C51cqQcRIHVAMRegXgTadDH2f/VnPg9Rrh/mL6x/n4OteDwUHDqK4jsh4
         6oO2yAJRJp24C46ImTBVuRky8pwIGBSyXIVP2AXvgtr2u0OZ5zBoXL92LqHf+kX31pmg
         GgxpDcaF6NO4lWn9aEyDIqS6GbLGd1U9LVaSpcld53jKONXo8CREjmBubhAnZRURND8A
         y7ziGgFZZ0oIyVyMGb4+w+T7QQpQAbcynZ5c7ym6Lh0FrGk7RjjC2hr9hatlNbMDGJ5r
         YNm3CL135kcoo+0UM04wCz/zLnHIwWopP5IvC9NHGvpzngXTMYV9a69yeJa6uucxuHva
         mUeA==
X-Gm-Message-State: AOAM532LtOPeOa5f339m+QOMcqycbmy5+eKHCzXujDXxr/ltUBM5U9TJ
        R+WbzaPk0eFkDfYMPc3vCw5HDFWVHeoPVQ==
X-Google-Smtp-Source: ABdhPJyAX9ERpkuD8GbrC3lNBEuWHrqSexfgh6p1w6HnAf0W3nBNxfhZc5G6PatljjmvZ2EqnYm4fw==
X-Received: by 2002:a17:90a:7601:: with SMTP id s1mr10368819pjk.66.1622132812457;
        Thu, 27 May 2021 09:26:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m2sm2294425pgu.85.2021.05.27.09.26.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 09:26:52 -0700 (PDT)
Message-ID: <60afc84c.1c69fb81.bf07f.7995@mx.google.com>
Date:   Thu, 27 May 2021 09:26:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.192-2-g48f1190e2531
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 136 runs,
 5 regressions (v4.19.192-2-g48f1190e2531)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 136 runs, 5 regressions (v4.19.192-2-g48f119=
0e2531)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.192-2-g48f1190e2531/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.192-2-g48f1190e2531
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      48f1190e2531b6454df78ae41234516e59f68a48 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60af90fe8265fb3e3ab3afa9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-2-g48f1190e2531/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905=
d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-2-g48f1190e2531/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905=
d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60af90fe8265fb3e3ab3a=
faa
        new failure (last pass: v4.19.190-394-g3428025b39e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60af8f1e3c77e7837eb3afb0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-2-g48f1190e2531/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-2-g48f1190e2531/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60af8f1e3c77e7837eb3a=
fb1
        failing since 194 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60af8ed6ca7f46ddf4b3afa3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-2-g48f1190e2531/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-2-g48f1190e2531/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60af8ed6ca7f46ddf4b3a=
fa4
        failing since 194 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60af8e9da33dd661a1b3afa5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-2-g48f1190e2531/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-2-g48f1190e2531/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60af8e9da33dd661a1b3a=
fa6
        failing since 194 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60af8e5224b0e52beab3af9d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-2-g48f1190e2531/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-2-g48f1190e2531/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60af8e5224b0e52beab3a=
f9e
        failing since 194 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
