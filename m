Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C753EDC56
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 19:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbhHPRXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 13:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbhHPRXi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 13:23:38 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E25C061764
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 10:23:06 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id a5so21473735plh.5
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 10:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JbkoYVj2iCvy1DJfI1TLQI1cdazUuA0pNhcMhk9L/YA=;
        b=UKKioYpmJgkww71ZPFO5NiwN69APnS0t0FX/r5hgcsEgUipdaXIgIv6ikzvbs+1x9q
         hnLCDlikaFMS2dJkdkxQy9Zvk/rvF8wnBMehvRwGiaKtLkllt/Q+SsG2VrMvbB8Qd/Vh
         oQBtwZzAF2XJ1tl/li+ilOVy+OlM/ev6cCDey/qQAmpkCtExPwfg+SlODgury+QMO6jn
         rMrsfV72kh9DnWj4aNNNfvKt8oDGubNUMoVkkSnHlIlxJUSX1/nDrL0uXhM8NytEVifx
         UQ4ZcpA1gC0B+HDavXC+f/pNtsVQGjPOdxjjr/r+K0dSfyuHJJp2qb53Eieige4+oTV2
         mr7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JbkoYVj2iCvy1DJfI1TLQI1cdazUuA0pNhcMhk9L/YA=;
        b=Ybo/XQHUFCc43hp1O5lklaghfNTy76em5LeArhevSSp0bCm1G45U3Ujq13eeAvzyUN
         HHzT/zmBNjI/MnFb5JVEZIibG65Fy0yA1aUe3lfn+kliRvG9i41x3b5V4PoyBzjSed/9
         T/Apl6QbdkVlzh4Fl1Ed1Cu1QT0jDNOFfBDPBle62SkiG8LUeIPArNC6fd4RWKi+a5JM
         EwLR+kPC+DoACpLNrh/DkFgyv/AQMMWomGOZ8vlk1WBaCZEb4xYRa5FcyIB/u9zTgWcA
         e9NVFlILrNKkjbAZXgwP3SdsafsnreeCKY/3+8/dbgWDvpa/8yUzWZOHrgo3ecYJl68J
         8QPg==
X-Gm-Message-State: AOAM533U5B+gCfFA2vAAfIINZgEACzLWbx7F1ghiSDvxsjhjJ6vy0GKK
        B4+8eAI32Sobnj5PLJC1KW9GdovdAaEaUSpp
X-Google-Smtp-Source: ABdhPJwhsL3U9qrxr0k357lbdKz17qv4oimQuGIA0GCYi6Atx80L9ILcX/reMcr/4djgGSFlt4rWmA==
X-Received: by 2002:a17:90a:9511:: with SMTP id t17mr204139pjo.194.1629134585805;
        Mon, 16 Aug 2021 10:23:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c9sm14813290pgq.58.2021.08.16.10.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 10:23:05 -0700 (PDT)
Message-ID: <611a9ef9.1c69fb81.e49a3.7a4f@mx.google.com>
Date:   Mon, 16 Aug 2021 10:23:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.141-62-g5e64ed094a87
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 175 runs,
 5 regressions (v5.4.141-62-g5e64ed094a87)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 175 runs, 5 regressions (v5.4.141-62-g5e64ed0=
94a87)

Regressions Summary
-------------------

platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
rk3288-veyron-jaq   | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 4          =

sun8i-a33-olinuxino | arm  | lab-clabbe    | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.141-62-g5e64ed094a87/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.141-62-g5e64ed094a87
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5e64ed094a8712f2fedf9d4b08e24071e753db96 =



Test Regressions
---------------- =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
rk3288-veyron-jaq   | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 4          =


  Details:     https://kernelci.org/test/plan/id/611a6db4d8e4bec3f5b1369b

  Results:     66 PASS, 4 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.141-6=
2-g5e64ed094a87/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.141-6=
2-g5e64ed094a87/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611a6db4d8e4bec3f5b136b3
        failing since 62 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-16T13:52:28.169558  /lava-4370627/1/../bin/lava-test-case<8>[  =
 16.026395] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-08-16T13:52:28.169857  =

    2021-08-16T13:52:28.170042  /lava-4370627/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611a6db4d8e4bec3f5b136cb
        failing since 62 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-16T13:52:26.727782  /lava-4370627/1/../bin/lava-test-case
    2021-08-16T13:52:26.732833  <8>[   14.601372] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611a6db4d8e4bec3f5b136cc
        failing since 62 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-16T13:52:25.708764  /lava-4370627/1/../bin/lava-test-case
    2021-08-16T13:52:25.714115  <8>[   13.581903] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.cros-ec-keyb-probed: https://kernelci.org/test/case/id/=
611a6db4d8e4bec3f5b136dc
        new failure (last pass: v5.4.141-61-g6fb21a963637)

    2021-08-16T13:52:24.413918  /lava-4370627/1/../bin/lava-test-case<8>[  =
 12.286023] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dcros-ec-keyb-probed RESULT=
=3Dfail>
    2021-08-16T13:52:24.414424     =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
sun8i-a33-olinuxino | arm  | lab-clabbe    | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/611a6ed3c4d57bd341b13662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.141-6=
2-g5e64ed094a87/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-a33-=
olinuxino.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.141-6=
2-g5e64ed094a87/arm/multi_v7_defconfig/gcc-8/lab-clabbe/baseline-sun8i-a33-=
olinuxino.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611a6ed3c4d57bd341b13=
663
        new failure (last pass: v5.4.141-61-g6fb21a963637) =

 =20
