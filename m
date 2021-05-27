Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F68393441
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 18:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233221AbhE0Qpc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 12:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234169AbhE0Qpc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 12:45:32 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE690C061574
        for <stable@vger.kernel.org>; Thu, 27 May 2021 09:43:57 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id y202so1014806pfc.6
        for <stable@vger.kernel.org>; Thu, 27 May 2021 09:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LLUgJ1inI5la0Gd0thBD8r/1m49zBWZCySigvvfhoxs=;
        b=sW/Gh95JSgawY6FlAJDhl8u76ZzKutYXtFRoGT4rg8Ipp8bgtQqYAG0jftDYK3WrV/
         S3IChOCzcVqlL0qxJO+zyIaE05g3JQBLBb2a9WtjDSWyEwawNjCvc4mQV9PYi2wZXx8K
         WzujAiD7H43dalIJ7IJIX5cBeDcly6KOPWiHQPylM3fjvfdikJFUccTKcY57Lofug22N
         7FNPbyT4WTN9DelpKcD/LHHhh7+atRXPjY9U7/qUUkYOuCqftlajBidKJj+E+QdGEScL
         y7JPsDBvhNjHqv519slwV7m2IPybCwIfkkSLRMvDz9Vf56ccYlDJtQuEBuas0LwlFSds
         dS5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LLUgJ1inI5la0Gd0thBD8r/1m49zBWZCySigvvfhoxs=;
        b=rFvKrO+c1+BBJogu8CpcX+oITLAfcNWeGiR6Sovm1VzStPvCSRxbeo6HYPo9PVREao
         HGc8pDTaz6A3C4QHSOzC5BM8EmMjQq4gu1t5u9rSdCSkmsfr/j1RTOBkcIlr3ab50YJD
         eWj6Duynb1RMyP9t5cYVlHuzJmZ+CdzO5KFOka3dE3izLLYfNCtRX2voO7TSpwoZr0SR
         ETK0hhVPD2RIA93hLlzF7/kK2EcnBwzHzKjyrs+aL5my1K+sTbfL/4Z9GRevD11Ij+DV
         oYtVcdp2IBc/Kj09XLUJpyy9HMMJrCGZVDoe9RCbba6IKQOermg7T39HX8I/d40T9THl
         3w1Q==
X-Gm-Message-State: AOAM530rXROLtwwVaffWEk+59Oc3NSvXZtvmRj9/TWbPwtW2vOyB13ZB
        ixklq2SD+lUTxcQKz+yftU8HwIR+eviMrQ==
X-Google-Smtp-Source: ABdhPJyRoVJJBigmdUwj3ZwqBRhkEcyf/CgKgZekZW0HFYNVfZQ7O9R8WOXxsGNWMKDLDhX8E1Jhaw==
X-Received: by 2002:a63:6387:: with SMTP id x129mr4477364pgb.58.1622133837213;
        Thu, 27 May 2021 09:43:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u12sm2325409pfm.2.2021.05.27.09.43.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 09:43:56 -0700 (PDT)
Message-ID: <60afcc4c.1c69fb81.45bd9.7f8c@mx.google.com>
Date:   Thu, 27 May 2021 09:43:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.234-5-g29aeef6830de
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 111 runs,
 5 regressions (v4.14.234-5-g29aeef6830de)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 111 runs, 5 regressions (v4.14.234-5-g29aeef=
6830de)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.234-5-g29aeef6830de/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.234-5-g29aeef6830de
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      29aeef6830deb8ce6bc7d5221f0d553d22222042 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60afc9e935ad66ea9ab3afd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-5-g29aeef6830de/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-5-g29aeef6830de/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60afc9e935ad66ea9ab3a=
fd1
        failing since 87 days (last pass: v4.14.222-11-g13b8482a0f700, firs=
t fail: v4.14.222-120-gdc8887cba23e) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60af918bf0fca549c9b3afb3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-5-g29aeef6830de/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-5-g29aeef6830de/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60af918bf0fca549c9b3a=
fb4
        failing since 194 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60af917e17587d46ecb3afc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-5-g29aeef6830de/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-5-g29aeef6830de/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60af917e17587d46ecb3a=
fc5
        failing since 194 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60af9113c3846b89cfb3afab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-5-g29aeef6830de/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-5-g29aeef6830de/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60af9113c3846b89cfb3a=
fac
        failing since 194 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60af910ec3846b89cfb3afa5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-5-g29aeef6830de/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-5-g29aeef6830de/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60af910ec3846b89cfb3a=
fa6
        failing since 194 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
