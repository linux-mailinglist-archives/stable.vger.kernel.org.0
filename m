Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2644135E5
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 17:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233990AbhIUPLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 11:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233919AbhIUPLj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 11:11:39 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58D0DC061575
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 08:10:11 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id t4so13614553plo.0
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 08:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DU3klU+YDzEZR+HhTNBoGaFRrX2/2VSYwHM88vd+9dc=;
        b=xHsleCv6OXLrBo7Pt995DjYloYeBwqFQ0Z576z5yg4wdjCKGHXPVhcUEwBUN7qJUXj
         ozHe3MMt9DM5roTCp3BwdIf43BSTUqCXK1uWh7tjfTYzvd6Km3ZXoJKSSuBcEo3yUGEK
         wapSj9Xx3UoExUb4O3nzluMjHNBb7VMASHcnn23NJxx1FSwdJGIUyLVmvhEs9Hdw3aaD
         X9BsReNbxmVBdyDvOY7zZX9gTh2O7HCnEmczAgEHdc4Kh0nbGr6jbyiUvKoaWycmjK+h
         mXXzEjZXg9paFovblEYimjKMipc66lSyocziWTVoAqUkyqI0M3uzz/cXB3vZEbkqMmcG
         PNqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DU3klU+YDzEZR+HhTNBoGaFRrX2/2VSYwHM88vd+9dc=;
        b=knDLtmaaybzcRW2CQAwzP/2PdMAzUQgBsQ+6dsmcHCG7Z5hhmZPri9YmArIMdldWSv
         APcLQGV+5TUtbbhwupPNnibsyxYyq05++UYkYbcMu6MnZxs8z8gZAPyFLbOlm/03a0x5
         S9DIghRdpRc9eKNFTWQjlsm0Rp5tei8G/1CHEuV5PL51rxTbImWd561vkkOGf5V6fnwq
         opDu5WPQoqCJTZN5MuRYmvXOEMvURMcEDDSxDa80XrTgLBJhs6p7c1ogpIIiqcyIMItz
         QyuksYtpaa9t7BOvEOjz+C3Kz6d8XhUP6tjPPl0OA0Vew8EowhrLJi/rFA2kafRTRRZc
         05xg==
X-Gm-Message-State: AOAM532hLBriby3YFlg9yYCEmemVfLAesN9iIkbroCiAn4mbVYQcKkiq
        U6wPatkiA+GlhP4+UPET2VBqX2k8rsMNnEuM
X-Google-Smtp-Source: ABdhPJwwpQIy6veOcrEh2winqU88MgPXa/7zPd7WXfw73ZwdysJnnRkKk4OCujzHYb6LsdppHHX9hw==
X-Received: by 2002:a17:90a:5d0f:: with SMTP id s15mr5910636pji.10.1632237010664;
        Tue, 21 Sep 2021 08:10:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t14sm18721788pga.62.2021.09.21.08.10.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 08:10:10 -0700 (PDT)
Message-ID: <6149f5d2.1c69fb81.39bb3.6b63@mx.google.com>
Date:   Tue, 21 Sep 2021 08:10:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.147-260-g17452f118b54
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 156 runs,
 4 regressions (v5.4.147-260-g17452f118b54)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 156 runs, 4 regressions (v5.4.147-260-g17452f=
118b54)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig | =
1          =

rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.147-260-g17452f118b54/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.147-260-g17452f118b54
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      17452f118b54a6412a11595aaaf5c3ea1d827ce6 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6149c4094ba879afcf99a2e3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.147-2=
60-g17452f118b54/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.147-2=
60-g17452f118b54/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6149c4094ba879afcf99a=
2e4
        new failure (last pass: v5.4.146-37-gfc59747b7e74) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6149e2fe897842ee9d99a2f5

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.147-2=
60-g17452f118b54/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.147-2=
60-g17452f118b54/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6149e2ff897842ee9d99a309
        failing since 98 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-21T13:49:26.128777  /lava-4550248/1/../bin/lava-test-case
    2021-09-21T13:49:26.145553  <8>[   17.817838] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-21T13:49:26.146051  /lava-4550248/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6149e2ff897842ee9d99a321
        failing since 98 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-21T13:49:24.703290  /lava-4550248/1/../bin/lava-test-case
    2021-09-21T13:49:24.721422  <8>[   16.392912] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6149e2ff897842ee9d99a322
        failing since 98 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-21T13:49:23.684578  /lava-4550248/1/../bin/lava-test-case
    2021-09-21T13:49:23.689623  <8>[   15.373568] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
