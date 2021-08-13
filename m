Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19F9F3EBC20
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 20:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbhHMSfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 14:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbhHMSfh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 14:35:37 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E10C061756
        for <stable@vger.kernel.org>; Fri, 13 Aug 2021 11:35:10 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id l11so13146084plk.6
        for <stable@vger.kernel.org>; Fri, 13 Aug 2021 11:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YbOEkpVYtN40zf0744n1FdDbXyCbxibu++NKkfhU6rU=;
        b=tcNXpCI4yFKALk7n0b9CE8wQiU/CgMx617gB5as8mnwKkIsls1RbLcAfwiUKYcJhqO
         xiAFgEX5gQLBpdnOZ2YfoLV3R6UA+JHyUsCGfzo5oIX/6npnncPepLCllpknbo4aInSd
         scBcu/5kIm8B1ZHmLJWUkBEELdzMZ0jC4Zb1T8veGAud8wCnC/IyqsKq/sgxFuN38kOq
         O6KJV2wpAgoAoUBdPWzh2b5XGavTrPQdhV4XTKxvO1am2mXnVdNi2jWMqSfmSOy9nThF
         QfMO9+F2LItfAiyxI0QWB+4JBK1TS71J4CLmgEI5OhJjwFCwPJ6j9i5tEbThJg1zngZE
         kVsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YbOEkpVYtN40zf0744n1FdDbXyCbxibu++NKkfhU6rU=;
        b=BrlqkrtfOEa3q1KsBF8PaHTaJPCMlYD1uTCJDN3Qya5uP14NxENFyIvqnA71GHWPmE
         ezhfnd/oqP5Y+5l8Eapeq3ow5MObpgyqJokvRFzVoEVNhV7bDchUlLay+HkrzmWaWEtk
         v53Y1DdELg9jCHXE1nmOc6QxqmLAMy0CKLw5+1wP/zVXlRsdvLTbcEFyEKH4Mgc55Qgg
         fiZwrBHEde3bLBSSbBTq0lsf6QsGG/Q1/ncAAJXAvcemwrvm+esCbfVppcqa6tDJ0OcL
         iqPEaRYQl1r/lf4C1Mp1/fPz+Q8zySIApp2D65PbGil6rs5pFQT0XYAFhGGJ0rOPNBAq
         l1JQ==
X-Gm-Message-State: AOAM533vKV3Cz0mNd+cms4LZsT5zZwoyRMXiyOIt7/hG1GCTSElJ/u0c
        gAxQA5IoYZXa9t6ZFDMwnt+Ffl2ZNKmAl9dE
X-Google-Smtp-Source: ABdhPJwlnsdDb7LbzZyFnbYStg58bAbEGPj4wLMDbdfLAW/QojyTQ58bs/BSrwFVBpb39hlpcU0u8Q==
X-Received: by 2002:a17:90b:e08:: with SMTP id ge8mr3808684pjb.204.1628879709784;
        Fri, 13 Aug 2021 11:35:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h20sm3104360pfn.173.2021.08.13.11.35.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 11:35:09 -0700 (PDT)
Message-ID: <6116bb5d.1c69fb81.87b57.79ff@mx.google.com>
Date:   Fri, 13 Aug 2021 11:35:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.243-42-g4a17fc57c110
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 98 runs,
 4 regressions (v4.14.243-42-g4a17fc57c110)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 98 runs, 4 regressions (v4.14.243-42-g4a17fc=
57c110)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
qemu_i386         | i386 | lab-collabora | gcc-8    | i386_defconfig     | =
1          =

rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.243-42-g4a17fc57c110/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.243-42-g4a17fc57c110
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4a17fc57c1105a58707d26a5116d611bf8c4b265 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
qemu_i386         | i386 | lab-collabora | gcc-8    | i386_defconfig     | =
1          =


  Details:     https://kernelci.org/test/plan/id/61169211ce41ac7f10b13686

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.243=
-42-g4a17fc57c110/i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i38=
6.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.243=
-42-g4a17fc57c110/i386/i386_defconfig/gcc-8/lab-collabora/baseline-qemu_i38=
6.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61169211ce41ac7f10b13=
687
        new failure (last pass: v4.14.243-38-gcd75c55a5afc) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6116868b5f8103dbd4b13661

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.243=
-42-g4a17fc57c110/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.243=
-42-g4a17fc57c110/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6116868b5f8103dbd4b13679
        failing since 59 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-13T14:49:30.398245  /lava-4358440/1/../bin/lava-test-case
    2021-08-13T14:49:30.403596  [   17.944245] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6116868b5f8103dbd4b13692
        failing since 59 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-13T14:49:27.967272  /lava-4358440/1/../bin/lava-test-case
    2021-08-13T14:49:27.984614  [   15.512684] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-13T14:49:27.984843  /lava-4358440/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6116868b5f8103dbd4b13693
        failing since 59 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-13T14:49:26.948254  /lava-4358440/1/../bin/lava-test-case
    2021-08-13T14:49:26.954044  [   14.493578] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
