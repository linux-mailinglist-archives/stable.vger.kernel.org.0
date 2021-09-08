Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3132240404F
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 22:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236055AbhIHUwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 16:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235437AbhIHUwG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 16:52:06 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A94C061575
        for <stable@vger.kernel.org>; Wed,  8 Sep 2021 13:50:57 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id gp20-20020a17090adf1400b00196b761920aso2419212pjb.3
        for <stable@vger.kernel.org>; Wed, 08 Sep 2021 13:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DGMa6kiCX936BvBYKOjo/SSidUSHbhmpWZ3mayGE5lw=;
        b=aRD/sHrm6LVJhT/n2MCnEXLDCry9rj6ofJOyvwfGiTwyhwDrkP4w/4W5aJg9xGqkXb
         WvhR7Ly2MKfaW2fsmC/21HaErs9FlurD8GG1fmq72MIg1rD9nasNZizTaU0jeNl3CFEp
         +XBySj80tAli3n1HFqIi+rb4kmVsAFDIyTmJo4hAiTIg8vXcWM2uioG08UOTsKMksf80
         cyl4uDkV6f7Sk4uqRbokM6IKeFmY3Dnx0XbKtx2ynVdxyIbp65h3FzvvdsbIkEw0jA06
         HEHVhFwd2zIC4nq1pDzN9wdBLtE22WZOnMAkiCYRR5mzqvvnYk6Y/WmHNGnvRxw59csQ
         d9lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DGMa6kiCX936BvBYKOjo/SSidUSHbhmpWZ3mayGE5lw=;
        b=t7ARpkm2KgNtb4+ro9l1OFCmTNS/BZsbFAQhUXhSFOZNTC9cn10AB3snjnS37FVVd5
         cQG4n8lBpI8YN85icW8QaKoz6F1IL1INzQMM4dDfOCQDmNycE7tlLz5E6IvwfesX4P7T
         R/+VwUqlq0kID8+Yj1RVi3QAQ6bPg63yvpMjP08C3NY3YSBqikNSq7KaAnq9a+b3vXkF
         UgWCC3FaV+hM9N6M5KNbR/ECTH6E9l+gT+X5dU936VEJQLD0h9xElT8e6+Sn0Vt5FeFR
         JlG4WUSI0IF2o0JJJ98bPiCXYVFuK7L2QimI4nRKc4qyb10Rc9iV/e7Tm+c0Q1pDY2FF
         ZFFA==
X-Gm-Message-State: AOAM533OFJafxziHv89oHVSnN026Rsm5A2bVmkVJbf65vPqiJYGbG5ed
        ylJm2gf1A7fP/gHQ3uAB56e2lttToHmdMFTV
X-Google-Smtp-Source: ABdhPJzreWWXiii9v+uvrK4rOgCeAos+5HeF5AsM38xTKYsgYyny9PrtvSlFZ+oGm+Kf4iI4RqPoNA==
X-Received: by 2002:a17:902:ec90:b0:13a:34f9:cfe9 with SMTP id x16-20020a170902ec9000b0013a34f9cfe9mr219951plg.74.1631134257055;
        Wed, 08 Sep 2021 13:50:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c21sm89291pfd.200.2021.09.08.13.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 13:50:56 -0700 (PDT)
Message-ID: <61392230.1c69fb81.ca932.06ce@mx.google.com>
Date:   Wed, 08 Sep 2021 13:50:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.246-24-gfe366f20894d
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 126 runs,
 5 regressions (v4.14.246-24-gfe366f20894d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 126 runs, 5 regressions (v4.14.246-24-gfe366=
f20894d)

Regressions Summary
-------------------

platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
qemu_i386-uefi    | i386   | lab-broonie   | gcc-8    | i386_defconfig     =
          | 1          =

qemu_x86_64       | x86_64 | lab-broonie   | gcc-8    | x86_64_defcon...6-c=
hromebook | 1          =

rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
          | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.246-24-gfe366f20894d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.246-24-gfe366f20894d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fe366f20894d0ef653241b8128d8016bfa3f21a6 =



Test Regressions
---------------- =



platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
qemu_i386-uefi    | i386   | lab-broonie   | gcc-8    | i386_defconfig     =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/6138f36943d0b7c02cd59677

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-24-gfe366f20894d/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-24-gfe366f20894d/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138f36943d0b7c02cd59=
678
        new failure (last pass: v4.14.246-24-g2dd51cbf7f11) =

 =



platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
qemu_x86_64       | x86_64 | lab-broonie   | gcc-8    | x86_64_defcon...6-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6138f612372d0ce566d59665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-24-gfe366f20894d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/=
baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-24-gfe366f20894d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/=
baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138f612372d0ce566d59=
666
        new failure (last pass: v4.14.246-24-g2dd51cbf7f11) =

 =



platform          | arch   | lab           | compiler | defconfig          =
          | regressions
------------------+--------+---------------+----------+--------------------=
----------+------------
rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
          | 3          =


  Details:     https://kernelci.org/test/plan/id/61391c59be2f215ed7d59666

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-24-gfe366f20894d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-24-gfe366f20894d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61391c59be2f215ed7d5967a
        failing since 85 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-08T20:25:44.861174  /lava-4478643/1/../bin/lava-test-case
    2021-09-08T20:25:44.878431  [   16.183075] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-08T20:25:44.878898  /lava-4478643/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61391c59be2f215ed7d59693
        failing since 85 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-08T20:25:42.430554  /lava-4478643/1/../bin/lava-test-case
    2021-09-08T20:25:42.447546  [   13.752050] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-08T20:25:42.448010  /lava-4478643/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61391c59be2f215ed7d59694
        failing since 85 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-08T20:25:41.411097  /lava-4478643/1/../bin/lava-test-case
    2021-09-08T20:25:41.416816  [   12.733262] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
