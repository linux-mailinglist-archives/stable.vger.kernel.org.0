Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908223D0BE1
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 12:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236097AbhGUIry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 04:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235281AbhGUIoC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Jul 2021 04:44:02 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51313C0617AA
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 02:24:12 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id e14so655496plh.8
        for <stable@vger.kernel.org>; Wed, 21 Jul 2021 02:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XwUvrKgdvsfL2K1dPIDn3FnbLhum0osg/ht131snDm4=;
        b=WnvlzaeAitKKqzWIHWYDODUCAXLTwzUUEJlmljzIOpIvd4CLUGt/A86Unx6qoCuV68
         uIZlnQfMJH6ztpbONxW8XqsJoORp2qb7SJDu8zK9Gzlo6SStOj5jXf4PZb0gy8xwEF90
         auUvoSr6f59XOHMtNWpHNC/5w5avvLIrsK2rR07pBWxyLuna1ezUsQ5RET/2lwL3rNc5
         0CXlExlELiuaHIO/HxnnAKxetOUXMKFzL36wGtabxlpy7cHkvhUxmf2wp4MFb0tKeqnA
         /pFitUj8EWq3aIkOZViK3ALEIJMQLY2HFGj9HAO/AkzNfzg+C1KXqWSskOk/O7St54nU
         yZ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XwUvrKgdvsfL2K1dPIDn3FnbLhum0osg/ht131snDm4=;
        b=MVoDynR6OFjV77grodBY2HohQYskx+zUATd5oGz1bJDK7eLGdQMHLuffq8ljcVRJHQ
         q+Oq3hTJYTW2nuNrp1OccmnZUDuIzjZ/JAG7xlOgd7rGE0uNckvZr2kBqbEObOY4EVxe
         VOrxL960c1oNGNFzDYsq+YUlFwvZFO02TBFPzodAWfd9RY8cxEY8IcgiHos4aihr5iVs
         SqpX/KHFVyEorZG98wf+oLF2gb4QLSSlF2KnDrky/g5EYIDJjxhx7JKqaEsQp1bPZjQe
         EHhu3+uNNhNX1kPiVMyNJowNt9vwHDUB1dK973BoyxVxA7ZsaEPpKJt30qQsg1Xi32HL
         +9rw==
X-Gm-Message-State: AOAM5318lotDcFy7vCi5ZSRAQLpn18R32OzYezTp4mULhhQQXaGJXXbb
        QyGJjc6NYF5STaRbURZrls/OUe4w1zkaUwqV
X-Google-Smtp-Source: ABdhPJy5WXTProZmcRoT/+QdOsUQxksnRMxQhMndwVWjZCjPebTBuxlyKPMcaMdMp+92sWZsr+bWIQ==
X-Received: by 2002:a17:903:31d5:b029:129:18a9:6267 with SMTP id v21-20020a17090331d5b029012918a96267mr26713938ple.43.1626859451612;
        Wed, 21 Jul 2021 02:24:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d6sm27412583pgq.88.2021.07.21.02.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jul 2021 02:24:11 -0700 (PDT)
Message-ID: <60f7e7bb.1c69fb81.93cf1.4b97@mx.google.com>
Date:   Wed, 21 Jul 2021 02:24:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.134
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
Subject: stable/linux-5.4.y baseline: 172 runs, 10 regressions (v5.4.134)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 172 runs, 10 regressions (v5.4.134)

Regressions Summary
-------------------

platform              | arch   | lab           | compiler | defconfig      =
              | regressions
----------------------+--------+---------------+----------+----------------=
--------------+------------
at91-sama5d4_xplained | arm    | lab-baylibre  | gcc-8    | sama5_defconfig=
              | 1          =

d2500cc               | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfi=
g             | 1          =

d2500cc               | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon..=
.6-chromebook | 1          =

hifive-unleashed-a00  | riscv  | lab-baylibre  | gcc-8    | defconfig      =
              | 1          =

qemu_arm-versatilepb  | arm    | lab-baylibre  | gcc-8    | versatile_defco=
nfig          | 1          =

qemu_arm-versatilepb  | arm    | lab-cip       | gcc-8    | versatile_defco=
nfig          | 1          =

qemu_arm-versatilepb  | arm    | lab-collabora | gcc-8    | versatile_defco=
nfig          | 1          =

rk3288-veyron-jaq     | arm    | lab-collabora | gcc-8    | multi_v7_defcon=
fig           | 3          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.134/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.134
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      9afc0c209685bc239e45b6ca1ea07186b78c7437 =



Test Regressions
---------------- =



platform              | arch   | lab           | compiler | defconfig      =
              | regressions
----------------------+--------+---------------+----------+----------------=
--------------+------------
at91-sama5d4_xplained | arm    | lab-baylibre  | gcc-8    | sama5_defconfig=
              | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7afa5057e837fac85c25a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.134/ar=
m/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.134/ar=
m/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7afa5057e837fac85c=
25b
        failing since 398 days (last pass: v5.4.46, first fail: v5.4.47) =

 =



platform              | arch   | lab           | compiler | defconfig      =
              | regressions
----------------------+--------+---------------+----------+----------------=
--------------+------------
d2500cc               | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfi=
g             | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7af92ce5f424ae985c27c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.134/x8=
6_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.134/x8=
6_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7af92ce5f424ae985c=
27d
        failing since 1 day (last pass: v5.4.131, first fail: v5.4.133) =

 =



platform              | arch   | lab           | compiler | defconfig      =
              | regressions
----------------------+--------+---------------+----------+----------------=
--------------+------------
d2500cc               | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon..=
.6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7b23a740752517d85c2cd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.134/x8=
6_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.134/x8=
6_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7b23a740752517d85c=
2ce
        failing since 1 day (last pass: v5.4.131, first fail: v5.4.133) =

 =



platform              | arch   | lab           | compiler | defconfig      =
              | regressions
----------------------+--------+---------------+----------+----------------=
--------------+------------
hifive-unleashed-a00  | riscv  | lab-baylibre  | gcc-8    | defconfig      =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7ae6130b051da2785c2a0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.134/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.134/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7ae6130b051da2785c=
2a1
        failing since 244 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform              | arch   | lab           | compiler | defconfig      =
              | regressions
----------------------+--------+---------------+----------+----------------=
--------------+------------
qemu_arm-versatilepb  | arm    | lab-baylibre  | gcc-8    | versatile_defco=
nfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7c28dd7c26e958685c28b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.134/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.134/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7c28dd7c26e958685c=
28c
        failing since 244 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform              | arch   | lab           | compiler | defconfig      =
              | regressions
----------------------+--------+---------------+----------+----------------=
--------------+------------
qemu_arm-versatilepb  | arm    | lab-cip       | gcc-8    | versatile_defco=
nfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7afee37bf40c07985c2b6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.134/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.134/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7afee37bf40c07985c=
2b7
        failing since 244 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform              | arch   | lab           | compiler | defconfig      =
              | regressions
----------------------+--------+---------------+----------+----------------=
--------------+------------
qemu_arm-versatilepb  | arm    | lab-collabora | gcc-8    | versatile_defco=
nfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60f7b45e108c32d5f385c25a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.134/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.134/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f7b45e108c32d5f385c=
25b
        failing since 244 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform              | arch   | lab           | compiler | defconfig      =
              | regressions
----------------------+--------+---------------+----------+----------------=
--------------+------------
rk3288-veyron-jaq     | arm    | lab-collabora | gcc-8    | multi_v7_defcon=
fig           | 3          =


  Details:     https://kernelci.org/test/plan/id/60f7dd6a97ebebba6485c257

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.134/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.134/ar=
m/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60f7dd6a97ebebba6485c26b
        failing since 34 days (last pass: v5.4.125, first fail: v5.4.126)

    2021-07-21T08:39:50.478939  =

    2021-07-21T08:39:51.492787  /lava-4223671/1/../bin/lava-test-case
    2021-07-21T08:39:51.509960  <8>[   14.811133] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60f7dd6a97ebebba6485c283
        failing since 34 days (last pass: v5.4.125, first fail: v5.4.126)

    2021-07-21T08:39:50.068007  /lava-4223671/1/../bin/lava-test-case
    2021-07-21T08:39:50.085064  <8>[   13.386097] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-21T08:39:50.085294  /lava-4223671/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60f7dd6a97ebebba6485c284
        failing since 34 days (last pass: v5.4.125, first fail: v5.4.126)

    2021-07-21T08:39:49.053367  /lava-4223671/1/../bin/lava-test-case<8>[  =
 12.366633] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-07-21T08:39:49.053806     =

 =20
