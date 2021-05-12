Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F222237EFA6
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 01:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231303AbhELXUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 19:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243468AbhELXPM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 19:15:12 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19447C061375
        for <stable@vger.kernel.org>; Wed, 12 May 2021 16:11:20 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id 10so20060985pfl.1
        for <stable@vger.kernel.org>; Wed, 12 May 2021 16:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XgWeIuI1A/aQ11mzdxt6VH8rJlOV2B3t5vnZscNR5uI=;
        b=xjDpxFt6zM3W3IbNYtHc3U9J48qOWUslCZE01FyNbXYpLXkmmCRDACfcl+PeAt++88
         48Js6poalQr2CVF+5tPIQ2UfQEg1ZTtZG5AD6Lrah8x/vYlyyb1EdopO4qg0OnvXFxOq
         Jt1xGWQWHW22DgW+blNEpmiMH9sDPY7eDoQC6neh3+b87FvVo2zFh15QRGHRrzuT+L9C
         8j7Zpa9A90Yhqh+hd8nG83C/qrT8XGiPhe2zQJwDwxQGq62QMngrhiI6rmsDK+c83ZA8
         1JYDXyl4zCnGMshr2hD51iJy6Hs7Z77JxpIXSkqdp1dRf5Nn1j+1JsRkqie0NwRMB44W
         J9WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XgWeIuI1A/aQ11mzdxt6VH8rJlOV2B3t5vnZscNR5uI=;
        b=LsbnyGZqxB+pHRmEvORBPLibn/GU65Hvhv0Cpvf5z15jraSw+QZehxijr0VhWfkMnA
         Q1pKO9Io9ed931cJ+lqk3Hwbsi6Gyi+8EWuFPWv3CF0mwgCcMYDnWItUX97TQ+0CLQje
         ZEJi3hzVT6oX3Gd7P2rSMjlUJMeNGHDfbU58tb99o+JrpoT2ov/UUGJY5pFHD03F8Cot
         IQhLGD0gmZDwKoBCU6QwjNG0eYDi4cG0o4A6UXO5sfz4oSo+YGKd/mQmiYMe+sLHQ4E/
         b4kIpKMlSSaXsjbyXvBQqd37wcWmZrfVL4VPBfBq8Req/vHX8XBoeqh49tC6/h1Bq/n/
         4U+w==
X-Gm-Message-State: AOAM533sjnzylj5IMuycfpwGv1xWBNsVSlcSJR93hs3Pud3phyS62cgA
        F6tx5pfP7fb14Q1J2XIpRJjN0n4E6MpinJmO
X-Google-Smtp-Source: ABdhPJwE1xoqym3QiFriTyJO4b5sP18to0CE5zNMxdb+l27zE1xdcl04aY3KrGI8iuwbG0ppKbpBkQ==
X-Received: by 2002:a62:644d:0:b029:2d1:1c84:dae5 with SMTP id y74-20020a62644d0000b02902d11c84dae5mr1024163pfb.77.1620861079268;
        Wed, 12 May 2021 16:11:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k15sm712255pfi.0.2021.05.12.16.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 16:11:18 -0700 (PDT)
Message-ID: <609c6096.1c69fb81.417b9.35af@mx.google.com>
Date:   Wed, 12 May 2021 16:11:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.232-232-g9c77c2c725f84
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 126 runs,
 5 regressions (v4.14.232-232-g9c77c2c725f84)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 126 runs, 5 regressions (v4.14.232-232-g9c77=
c2c725f84)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.232-232-g9c77c2c725f84/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.232-232-g9c77c2c725f84
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9c77c2c725f84f437fb12e11a9487186b8b57654 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/609c2f4a508ab2f06d19928c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-232-g9c77c2c725f84/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-232-g9c77c2c725f84/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c2f4a508ab2f06d199=
28d
        failing since 72 days (last pass: v4.14.222-11-g13b8482a0f700, firs=
t fail: v4.14.222-120-gdc8887cba23e) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/609c2d10e34bfc33311992aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-232-g9c77c2c725f84/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-232-g9c77c2c725f84/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c2d10e34bfc3331199=
2ab
        failing since 179 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/609c2cf7013ba75716199293

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-232-g9c77c2c725f84/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-232-g9c77c2c725f84/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c2cf7013ba75716199=
294
        failing since 179 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/609c2d2ff4a0e094a919927b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-232-g9c77c2c725f84/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-232-g9c77c2c725f84/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c2d2ff4a0e094a9199=
27c
        failing since 179 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/609c2ccdbea51a43e519927b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-232-g9c77c2c725f84/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-232-g9c77c2c725f84/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609c2ccdbea51a43e5199=
27c
        failing since 179 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
