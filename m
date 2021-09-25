Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490B1417FCB
	for <lists+stable@lfdr.de>; Sat, 25 Sep 2021 07:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233807AbhIYFGk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Sep 2021 01:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbhIYFGk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Sep 2021 01:06:40 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F15A0C061571
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 22:05:05 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id j14so7960175plx.4
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 22:05:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=NECUQJtGombBY5hfXYw8ldMAYkvVTqWJp5wsxdbehGo=;
        b=YmG/GwfKvfT8q8W2FNWHXmT0rcqR4Q9tZFGWM9Mtz9OA4AJzMdeA7ChIcumU04m7so
         XjEoejPsg2F57MHaihq+FEbIbmJ1kLiPFDezT/a+ax1Wx6fZpJ8esPWnVTKARv44kEak
         pVW1lZWqwNeQf51ebdMj3eEIHC8jOt9A1w7u6irV1oToKxlyl1oWkkjlBI51kxI2k24e
         i8n4cORWEVkxLjIcMKhSe0gn5Q9klQATfY4IfWdSAVSlETx6de9XZ3aZ2AFShrYf3QnA
         cHE0vpOmqh/ILPfdBfttlisobGzJCmrmsD2+4GkKMN3ffJwCIjG5a7ZLM47l07J2BwJ9
         zqAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=NECUQJtGombBY5hfXYw8ldMAYkvVTqWJp5wsxdbehGo=;
        b=wXvMubz84KBd6TjGwQ6TGe+xg7mOBVuCZw1bbT9yCcIHLMYCxNTiodMyKWkSqNAh2u
         CACTPWLu6Qv8YZ07v8Nkf8X6VaTlylG6ljMByvbQK/XBBm0ARwsBlgJn18jvwDbodsKV
         Zs7LOPJrzWLwpOHAq6tyuSZWpeLmH8yi3RRfKRqVkDXSxvZC70nmiRMGaExL/XDW+Fww
         N07o2y6biMyDS1N+2iD1+To5eXfYdNhiPq+vPqzOynXunpd2uTdOi8osZ/VvA3MfyAiG
         r6Y5jLqhcTg6t/EhYoGy6oMe8TcfhDpOcevDwTTquxLrEejiN1lyUXCLhROo8MnEphNR
         LZsg==
X-Gm-Message-State: AOAM533fOaxbbSzLA9SWkgL6t1PMwuxTZmndluf3IAIpDBPgVVX0BJrO
        GraJkusqOGmq7+sQCrnm8wgqlL6ETRiZ0FFG
X-Google-Smtp-Source: ABdhPJw9D7w7iYeWH2xZRGvpd8l8Ic+4gUbGWDCCcejGcydPWZIwmlHvrdnWfeipY1HmSzRu/gpxvg==
X-Received: by 2002:a17:90a:1d0:: with SMTP id 16mr6539833pjd.60.1632546304262;
        Fri, 24 Sep 2021 22:05:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e7sm9743144pfv.158.2021.09.24.22.05.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 22:05:03 -0700 (PDT)
Message-ID: <614eadff.1c69fb81.3970c.1711@mx.google.com>
Date:   Fri, 24 Sep 2021 22:05:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.148-51-g0e003dbb1df4
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 73 runs,
 5 regressions (v5.4.148-51-g0e003dbb1df4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 73 runs, 5 regressions (v5.4.148-51-g0e003d=
bb1df4)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.148-51-g0e003dbb1df4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.148-51-g0e003dbb1df4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0e003dbb1df4d725d5018dbfdebac3caa9a1133a =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/614e7915a129e6a81299a2e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.148=
-51-g0e003dbb1df4/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.148=
-51-g0e003dbb1df4/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614e7915a129e6a81299a=
2e7
        failing since 308 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/614e73b7d9659f194699a2ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.148=
-51-g0e003dbb1df4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.148=
-51-g0e003dbb1df4/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614e73b7d9659f194699a=
2ef
        failing since 314 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/614e73c2d9659f194699a2f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.148=
-51-g0e003dbb1df4/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.148=
-51-g0e003dbb1df4/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614e73c2d9659f194699a=
2f5
        failing since 314 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/614e73c50bf525347599a2e3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.148=
-51-g0e003dbb1df4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.148=
-51-g0e003dbb1df4/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614e73c50bf525347599a=
2e4
        failing since 314 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/614ea25e4616df1ec199a2db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.148=
-51-g0e003dbb1df4/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.148=
-51-g0e003dbb1df4/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614ea25e4616df1ec199a=
2dc
        failing since 314 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
