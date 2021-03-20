Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C82C342969
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 01:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhCTAYX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 20:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbhCTAX4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 20:23:56 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28CF2C061760
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 17:23:56 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so5635665pjv.1
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 17:23:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Fy2j0eF6Cgj9s+G6pPNBoj8EOF04K1r6536LdVtoov0=;
        b=WTYNrE0wvCwTknxgBZ92Tc5urXAo/Dmi4lnpU7ObA6CS/CiIo8PIDs53kxhlAyf/pn
         jfvm4g354oTFXakfQnv6R2p4uKI9mL8d7hPsEV0CgCqT2XwrScer3/IviUQccBtk5ddH
         ZJ/vYqCmNkjuDHq4QdJih2++CshY+sTizhYHEFs3zDdIo9rFad8q8lU14X4EYtan01VD
         AC8xWUt0Sxp6BwgghJyr7OrJufzxgelufVFQ/8p27TBxZl0PARubp8GhgCt3aaLxV4Ax
         UFd0OkisZ9KAasfmevk2XTaEYCbZ4qnblLg/CDGcC2obj+qe8bnrG0cSoHLWdbj856Hj
         Wgig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Fy2j0eF6Cgj9s+G6pPNBoj8EOF04K1r6536LdVtoov0=;
        b=caA15WZ1WYN8dXhWMVvdLCdsD0jjleJfFViXCiXGI0LkSjeCWMxGVW65decauln6lU
         Acp++IhfPfEI83y26ywyxrUPgu5CHzY8CHiaC2VtydCmayW1jTV4DrzhLegAbpFQbG+V
         3HOStUQ47Ehn1GarOoVz65bItznp2wtF1f70tp/I0IdA21irHZPQp4vAxuxS1mMn/8Es
         1JqVk2dqE6hZAVMpefQs5NQylQf402b0Wm/hTJ8/HQ9awiQgzmCBom4o+CscKSGhECd7
         rXrsxP1pt/tH9ZqL4IUWOcB1OlepsZT71n4nh+Tu7TB1g5XsyMRNnMQcaQWIYv8wQ6Ab
         32YQ==
X-Gm-Message-State: AOAM5303855GegjxoODIuoIH/m1Te/mYs7B6qG/om6rAtLBf5haEsL3V
        lPBwkbpJk/QPXU2z3asJtc/OqBKId9Uyyg==
X-Google-Smtp-Source: ABdhPJx9HSAzx8Eg6TovmpSJ85aQWRLq+29vZR4keHkpEiHuUHZjfa/X/ii+DeMJAVbjqlu11BNeXQ==
X-Received: by 2002:a17:90a:7344:: with SMTP id j4mr973888pjs.223.1616199835495;
        Fri, 19 Mar 2021 17:23:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g22sm6365212pju.30.2021.03.19.17.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 17:23:55 -0700 (PDT)
Message-ID: <6055409b.1c69fb81.d63aa.ff32@mx.google.com>
Date:   Fri, 19 Mar 2021 17:23:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.106-19-g8a800acdf26f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 153 runs,
 4 regressions (v5.4.106-19-g8a800acdf26f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 153 runs, 4 regressions (v5.4.106-19-g8a800=
acdf26f)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.106-19-g8a800acdf26f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.106-19-g8a800acdf26f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8a800acdf26f05d289c05e416591b6b18917b044 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60550bc423415d2f64addcc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.106=
-19-g8a800acdf26f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.106=
-19-g8a800acdf26f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60550bc423415d2f64add=
cc4
        failing since 125 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60550bb6578db18b40addcce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.106=
-19-g8a800acdf26f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.106=
-19-g8a800acdf26f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60550bb6578db18b40add=
ccf
        failing since 125 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60550bc3a4208f4adcaddcc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.106=
-19-g8a800acdf26f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.106=
-19-g8a800acdf26f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60550bc3a4208f4adcadd=
cc8
        failing since 125 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60550b5344e96585aaaddcc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.106=
-19-g8a800acdf26f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.106=
-19-g8a800acdf26f/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60550b5344e96585aaadd=
cc8
        failing since 125 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
