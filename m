Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92852D054A
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 14:41:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727931AbgLFNlf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 08:41:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727924AbgLFNle (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 08:41:34 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FF6EC0613D0
        for <stable@vger.kernel.org>; Sun,  6 Dec 2020 05:40:54 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id b5so2011339pjl.0
        for <stable@vger.kernel.org>; Sun, 06 Dec 2020 05:40:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2VsUHbi+ba13e9gaoldcBgvoCyaWoXMVIikZILyVGGI=;
        b=RADxqhfnGX5VaD1QOU3nww478OFO2QnFFnTTUZvIZAgu9hzQx/PMxvdkJL0nsDxAN/
         E83A9GPCZNwp7siixB+lrzYXa4AaFodnTGo3kqaFnFnlsIaBXIt6zlfYpD5YpNzaKb3/
         53cvNazTKRu2qt4YVHzzLapx+zc7O8dYh0//+5+wbGgMeY8Zx96DbLpZmvNARuwol6RE
         ReECSweHYTyGWOmciFA4TZlF/7NutX9EO4rLKjkQ7t+4atJWgtvq+4o4FIQiUc7lb40m
         ASUAL+CiY+aX5b55F8yRFobu+7/mrr5ETXR8MmK39n5yplDgAh5SAlV1tXfs0FMt6BOj
         HBZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2VsUHbi+ba13e9gaoldcBgvoCyaWoXMVIikZILyVGGI=;
        b=Yypi2HljTMoLoM9YvwGhLyqfuLju0rk6OjO2alBzd9z9Os1p8DEOTuMYQS/AQXLdmL
         GPy2JaG9lPXzqWes+ING2l7slQj/g78XDA7osKULiXLD15lgLGda+TuWt8x8upJG642D
         2VKjwCdl8I1gVAHmjYmVMI/uCn99Ra3d1boWIxBtNOQZVSmMWg9TA/vV71/y4YhQqUko
         hpy/Msm0quag5UOFvMvMm7/7NmJ1bMlnJIMYruRT9AZx6SjYLtDv8i+0avu75sydnjwJ
         brtBEeoL0UhyTg9zfXmrJJU75jmGPdmTSp612DSuHcXvFuWxJL8NWMS/bcREiRhNf+Wn
         iY5Q==
X-Gm-Message-State: AOAM532K4z86d3YL/bMzwteFZy6JZEpaOzDLMxb3Y/gU4/G+cxGONonv
        82ttSl0MBSisBZUwrtxPQ+A13Mx5/R0EFg==
X-Google-Smtp-Source: ABdhPJwEATj4C+bzlBjxya9zqnZwho1nyYtcJzz3TzoaitqAAQsUxiYjvNtxICwcTo0vhB6tHk+rAQ==
X-Received: by 2002:a17:902:9f97:b029:da:357b:22b0 with SMTP id g23-20020a1709029f97b02900da357b22b0mr11601617plq.73.1607262053417;
        Sun, 06 Dec 2020 05:40:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b14sm10036343pgj.9.2020.12.06.05.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 05:40:52 -0800 (PST)
Message-ID: <5fccdf64.1c69fb81.2ea60.6381@mx.google.com>
Date:   Sun, 06 Dec 2020 05:40:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.81-34-gefcfcd5689e6
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 178 runs,
 6 regressions (v5.4.81-34-gefcfcd5689e6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 178 runs, 6 regressions (v5.4.81-34-gefcfcd56=
89e6)

Regressions Summary
-------------------

platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
at91-sama5d4_xplained | arm   | lab-baylibre    | gcc-8    | sama5_defconfi=
g     | 1          =

hifive-unleashed-a00  | riscv | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =

qemu_arm-versatilepb  | arm   | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.81-34-gefcfcd5689e6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.81-34-gefcfcd5689e6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      efcfcd5689e691f184d8d60ef6c4d8b42eae2d10 =



Test Regressions
---------------- =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
at91-sama5d4_xplained | arm   | lab-baylibre    | gcc-8    | sama5_defconfi=
g     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccadacf612f1d6e1c94ccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-34=
-gefcfcd5689e6/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-34=
-gefcfcd5689e6/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccadacf612f1d6e1c94=
cce
        failing since 38 days (last pass: v5.4.72-409-gbbe9df5e07cf, first =
fail: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
hifive-unleashed-a00  | riscv | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccacb0727de95850c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-34=
-gefcfcd5689e6/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-34=
-gefcfcd5689e6/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccacb0727de95850c94=
cba
        failing since 16 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccab1e6ff589de3fc94cd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-34=
-gefcfcd5689e6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-34=
-gefcfcd5689e6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccab1e6ff589de3fc94=
cd9
        failing since 22 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccab4798723a45e3c94d06

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-34=
-gefcfcd5689e6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-34=
-gefcfcd5689e6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccab4798723a45e3c94=
d07
        failing since 22 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccab236ff589de3fc94cdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-34=
-gefcfcd5689e6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-34=
-gefcfcd5689e6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccab236ff589de3fc94=
cdc
        failing since 22 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccaae132494e3e10c94d08

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-34=
-gefcfcd5689e6/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.81-34=
-gefcfcd5689e6/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccaae132494e3e10c94=
d09
        failing since 22 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
