Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E2634F931
	for <lists+stable@lfdr.de>; Wed, 31 Mar 2021 08:50:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233985AbhCaGuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Mar 2021 02:50:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233895AbhCaGtb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Mar 2021 02:49:31 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2981C061574
        for <stable@vger.kernel.org>; Tue, 30 Mar 2021 23:49:30 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d8so7406187plh.11
        for <stable@vger.kernel.org>; Tue, 30 Mar 2021 23:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EZmDKYHWMEknYGlsqlQ/nzjZH43ehW7aClnxaEaLj2Y=;
        b=Bj309ra9WOFglE5vskHYIg31LPVxbgiJ3SwtmF2cRinh/23W6LVlFHgSleh80eubLk
         lo2H0UmoLgq/2kn4FiBELnM3uxkt8vhLZ8EeoWrF+Q9UGkFx4dBbCv5yxfii3bPJMvtj
         61BeLhKN17pEPlh5N6xEMxY4xrgqkvTci0ISoPESHFUkNtgNIZpYYsXJe3vfNQJcjrPG
         pVirGnm70RKh0XKG/IaHMi9A78ywEUQk/GfxVVbrX9nOvtwmLtPUBI5KLwIDzFW6d1kV
         iqUe4dFghLghV6cO6p1mULlhaepJyfK5SrFvupx1uuh4ybOzuR3GBjrmNdWfLa/8uH4G
         bp8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EZmDKYHWMEknYGlsqlQ/nzjZH43ehW7aClnxaEaLj2Y=;
        b=O+RKaxxcGJZqZ+lhKPESqTMzbun3Ka75W0VBI3qv1o4a/IM0UExUoeLfCRfbfti0Oe
         nSLPSaLR7K9Gr0fT8pXW0fioNxNso5Bfj/xbFudlpuumRm7oe2tpNfvGg7Lrse4fgHZZ
         /SVTBBUFlaeVvrBD+HbD3hG5aNt3cYym0HZpi/giqz5I1lwpZcsqRdXga8aNptyGeI5G
         raXPfWacqxHFJSXTR+J+6MSPncrNu6/dU2nQiAUvp+V+y9tFyuagSsPbWr7MgvcKHPR5
         6rkb26rWBXsGORfGLBF8h45hwfO+NqfU1iu7XYSp4t3ECY85OFPWt9uvKSPS7ZjEpt2v
         hetQ==
X-Gm-Message-State: AOAM530Rt1mWgWvIo0Ys4ihqj9CrAQZLTMEE9ztUdzH6PMNSSFuJMlUg
        uaeQos02Fj+W7muAYMB2+1Zy5A4v8ObS6A==
X-Google-Smtp-Source: ABdhPJycN8D8pZZPD4HTwEgrF1p0xjhbZmTccoos/00BXfTjJgmUPo+sSautu5gPEAsCTInw50Anag==
X-Received: by 2002:a17:902:a412:b029:e5:d7dd:9e41 with SMTP id p18-20020a170902a412b02900e5d7dd9e41mr1915847plq.78.1617173370277;
        Tue, 30 Mar 2021 23:49:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i7sm1068160pfq.184.2021.03.30.23.49.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 23:49:30 -0700 (PDT)
Message-ID: <60641b7a.1c69fb81.450bb.3161@mx.google.com>
Date:   Tue, 30 Mar 2021 23:49:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.264-15-g17e27e1979c92
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 98 runs,
 6 regressions (v4.9.264-15-g17e27e1979c92)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 98 runs, 6 regressions (v4.9.264-15-g17e27e19=
79c92)

Regressions Summary
-------------------

platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =

qemu_x86_64          | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =

qemu_x86_64-uefi     | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.264-15-g17e27e1979c92/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.264-15-g17e27e1979c92
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      17e27e1979c92e5d2d872599acd4902b716db570 =



Test Regressions
---------------- =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6063e7cd45f1d94c1ddac6b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-1=
5-g17e27e1979c92/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-1=
5-g17e27e1979c92/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6063e7cd45f1d94c1ddac=
6b3
        failing since 137 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6063e77bf24c09d6c4dac6cb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-1=
5-g17e27e1979c92/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-1=
5-g17e27e1979c92/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6063e77bf24c09d6c4dac=
6cc
        failing since 137 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6063e87dfc60aee5a2dac6e7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-1=
5-g17e27e1979c92/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-1=
5-g17e27e1979c92/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6063e87dfc60aee5a2dac=
6e8
        failing since 137 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6063e727103fe22c1ddac6bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-1=
5-g17e27e1979c92/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-1=
5-g17e27e1979c92/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6063e727103fe22c1ddac=
6be
        failing since 137 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_x86_64          | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:     https://kernelci.org/test/plan/id/6063e8be1e56fbf027dac6bf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-1=
5-g17e27e1979c92/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-1=
5-g17e27e1979c92/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6063e8be1e56fbf027dac=
6c0
        failing since 0 day (last pass: v4.9.263-53-geb8bb9695a00b, first f=
ail: v4.9.263-54-ga0adee90d086) =

 =



platform             | arch   | lab             | compiler | defconfig     =
      | regressions
---------------------+--------+-----------------+----------+---------------=
------+------------
qemu_x86_64-uefi     | x86_64 | lab-baylibre    | gcc-8    | x86_64_defconf=
ig    | 1          =


  Details:     https://kernelci.org/test/plan/id/6063e8bc1e56fbf027dac6bc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-1=
5-g17e27e1979c92/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.264-1=
5-g17e27e1979c92/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6063e8bc1e56fbf027dac=
6bd
        new failure (last pass: v4.9.263-54-ga0adee90d086) =

 =20
