Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC383F12EF
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 07:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbhHSFu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 01:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbhHSFu7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 01:50:59 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64CD1C061756
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 22:50:23 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id qe12-20020a17090b4f8c00b00179321cbae7so4010666pjb.2
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 22:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VRLEpoi/0+q67oS51A5mrYMuSyDYnfRE/cyJ0FRdIrE=;
        b=FjxufYuFD+HVY7Ak3RUrlCj+OiQFKSa6+q8qrUwx6b8Lb6MqBqWDqPy3uo3631BHIk
         SsWbKjgY/iE+McVPL8epKUUcBwXD8fGJVrEXLpMW6MJS7Y1iraaAOJYBO8V9j0pWI9rw
         hKGPzHA1PHyfZU2zb3yiF9DSjyPEgzdmYq3eyNGvLAM47khLl4v1u9AUsaC6LUb7xvDP
         CmU5o5Vyc08r6316Hf9SK3+ULlVXGCseg4OaiqEFYBj5anhlciFBC669z7MS6NWUksZN
         GNytVa1Q1d/EEjZxcKZYvnOSQCaGkDe2Kknbm9sU9+EW20mbzDV36AuIAk6KTnN7Kvec
         cgtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VRLEpoi/0+q67oS51A5mrYMuSyDYnfRE/cyJ0FRdIrE=;
        b=L/gsjVnJr10IeWK+amOraMIvNBF+vSZcEcde5cXaVygmJd0HyLXjDiohhuf2sW2BAk
         N0o5A4ZsIrwITC9SvRVxZsSQT536stx2sAeh2YwwlvLCsYjijnDXUi5mkJ+3ZV6kwv0X
         9VoUulU/AEt8uzvAK+oQrRgzIaSgL6GMuIygBlqRiIQfukPmoIFLEyIAyepnCL37hTOJ
         lh9IR8bQaZuTGExmLu44Ls4XrwXDao1JBDz3a8xAtEt02wnpLIOSagsa/zIHmUk+JbfZ
         pArUO3iXgeQuTk9BSgh3vOQvx1HuyDoUdJxdW5sHpxveFKnSNl0byNnjF8kqmimb9WrB
         DySQ==
X-Gm-Message-State: AOAM531rLN9odh7fW9Kxw1oqgElvHGtdbNRBNIvurDx7OrQ8LCGIh70i
        ge4fLrEwlGigkUCe/5ENMg1rDEuG0+83q1Ed
X-Google-Smtp-Source: ABdhPJycOnViuMhNRkhNymuwNxKGOF6NltegIPllJ04HX4UXmcRByWv8PSKO1B1GumCGsvpdZrzKLQ==
X-Received: by 2002:a17:90a:ad06:: with SMTP id r6mr12977270pjq.25.1629352222850;
        Wed, 18 Aug 2021 22:50:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x7sm1706602pfj.200.2021.08.18.22.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 22:50:22 -0700 (PDT)
Message-ID: <611df11e.1c69fb81.6a016.736c@mx.google.com>
Date:   Wed, 18 Aug 2021 22:50:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.204-49-geba022e67dff
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 124 runs,
 6 regressions (v4.19.204-49-geba022e67dff)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 124 runs, 6 regressions (v4.19.204-49-geba02=
2e67dff)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.204-49-geba022e67dff/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.204-49-geba022e67dff
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eba022e67dff04436df64d3e7c2077e377abc4a5 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/611dbdc4478fd75d1eb1366a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-49-geba022e67dff/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-49-geba022e67dff/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611dbdc4478fd75d1eb13=
66b
        failing since 278 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/611dbdbe87b9a51825b13665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-49-geba022e67dff/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-49-geba022e67dff/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611dbdbe87b9a51825b13=
666
        failing since 278 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/611dbe2932f612621fb13663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-49-geba022e67dff/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-49-geba022e67dff/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611dbe2932f612621fb13=
664
        failing since 278 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
rk3288-veyron-jaq    | arm  | lab-collabora | gcc-8    | multi_v7_defconfig=
  | 3          =


  Details:     https://kernelci.org/test/plan/id/611dc9a86caa4f4675b13680

  Results:     64 PASS, 6 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-49-geba022e67dff/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.204=
-49-geba022e67dff/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611dc9a86caa4f4675b13698
        failing since 65 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-19T03:01:40.468144  /lava-4382433/1/../bin/lava-test-case
    2021-08-19T03:01:40.485503  <8>[   17.462267] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-19T03:01:40.485784  /lava-4382433/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611dc9a86caa4f4675b136b1
        failing since 65 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-19T03:01:38.027348  /lava-4382433/1/../bin/lava-test-case
    2021-08-19T03:01:38.045040  <8>[   15.020965] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-19T03:01:38.045500  /lava-4382433/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611dc9a86caa4f4675b136b2
        failing since 65 days (last pass: v4.19.194-28-g6098ecdead2c, first=
 fail: v4.19.194-67-g1b5dea188d94)

    2021-08-19T03:01:37.007496  /lava-4382433/1/../bin/lava-test-case
    2021-08-19T03:01:37.014446  <8>[   14.001486] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
