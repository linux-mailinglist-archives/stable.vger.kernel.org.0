Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87280403DC9
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 18:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbhIHQr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 12:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240257AbhIHQrZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 12:47:25 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA670C061757
        for <stable@vger.kernel.org>; Wed,  8 Sep 2021 09:46:17 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id f11-20020a17090aa78b00b0018e98a7cddaso1935818pjq.4
        for <stable@vger.kernel.org>; Wed, 08 Sep 2021 09:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=S6lZZfwo9KjJhhxw6xRyWkH84MZWNIv0IJ/2mTerCxQ=;
        b=UNeTqcjj+otWzoM8OzbaHUpec3r1FLuzmpReModCto2PyK5t8xiorZyazzc7/Ea4L6
         wdzE7X8520ZQROo+uYjglozTnEL6zvULF+AMwc1tBc/3VA0/aEfZnXGt1FonVs+idd05
         bZ/8rJuUIy/Uc2lXZSaSgNaLYFu/tZqIxJdQBdQprI15TwNAg1zUzJor6PQxJJIGHwDC
         P3z+7qy/U4uKMNyX8h9IEL1GZtc/YtT4iordAfLBzmSk6Oy2PJd4WladafK+PDB/JA6+
         28QIAq1CAOd3rZk/H12rEHe9dn1+fsOr2xXcIHy8cAEOVOQVr1gntplqvsacIWjh8ktK
         ZMZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=S6lZZfwo9KjJhhxw6xRyWkH84MZWNIv0IJ/2mTerCxQ=;
        b=PP/ltIAP9RHoZxcKqHTRpoegJmvM0GPgsBT7dvQ4fneAE/zJBI/YsdT4ZH/HgZIL1o
         Tp+FSUJqjI5oTGb0X9VyYQ5ccl/Lu6SkE2w2AHNo4K7576+SbUJpaG2CGTLqYpVBlsoN
         GKfK1Mg1kVvzCB7SErTrNhJunEY/A+86O7P7tdPU0d4+wLq4TxlTexApJGe8Wj3kcuhe
         wNs9kemuLqM5U3N+gUZH5OBumXtlA5igfsXRVyOXQmGgHO1ru/s+nd/a9wQ90E798HpG
         rxRgb27jqTBbzrVyISiMeUl1hvveIWMKUoXnOLvVAjOoRttLugs3PV+ea9dLUqWMaYMY
         57gg==
X-Gm-Message-State: AOAM533KK8+VbZISsSsKOq4M0OtbEeUJ3AxHxWifo9X5z2AiU1o3C0tp
        08QkkH8khOJHUucty6hh2MybJpFiz5x//zZT
X-Google-Smtp-Source: ABdhPJw8rxTN37dtNJBaPj2Qa5qjP8gfRVLY+wVLyQMp9X/hJLuuWk+dPxHlB1pyTST6TO0hNFxP8g==
X-Received: by 2002:a17:903:1106:b0:13a:e0b:5ea6 with SMTP id n6-20020a170903110600b0013a0e0b5ea6mr3813182plh.29.1631119577135;
        Wed, 08 Sep 2021 09:46:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 191sm2908187pfv.7.2021.09.08.09.46.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 09:46:16 -0700 (PDT)
Message-ID: <6138e8d8.1c69fb81.85297.81e5@mx.google.com>
Date:   Wed, 08 Sep 2021 09:46:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.63-1-g56ca228bc595
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 204 runs,
 5 regressions (v5.10.63-1-g56ca228bc595)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 204 runs, 5 regressions (v5.10.63-1-g56ca228=
bc595)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =

rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.63-1-g56ca228bc595/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.63-1-g56ca228bc595
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      56ca228bc595cfde71e0f711e22d42f1d780adc8 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6138b5a910d9fa0950d59676

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
1-g56ca228bc595/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
1-g56ca228bc595/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138b5a910d9fa0950d59=
677
        failing since 69 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/6138d156dd0060ef60d59672

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
1-g56ca228bc595/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
1-g56ca228bc595/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6138d156dd0060ef60d59686
        failing since 85 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-08T15:05:40.825372  /lava-4476463/1/../bin/lava-test-case
    2021-09-08T15:05:40.842643  <8>[   14.109196] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6138d156dd0060ef60d5969e
        failing since 85 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-08T15:05:38.388257  <8>[   11.666062] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>
    2021-09-08T15:05:39.419524  /lava-4476463/1/../bin/lava-test-case<8>[  =
 12.685338] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-09-08T15:05:39.420098  =

    2021-09-08T15:05:39.420564  /lava-4476463/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6138d156dd0060ef60d5969f
        failing since 85 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-08T15:05:38.382746  /lava-4476463/1/../bin/lava-test-case   =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6138b5a7bdd55e2e2bd5967a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
1-g56ca228bc595/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.63-=
1-g56ca228bc595/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banana=
pi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138b5a7bdd55e2e2bd59=
67b
        new failure (last pass: v5.10.63) =

 =20
