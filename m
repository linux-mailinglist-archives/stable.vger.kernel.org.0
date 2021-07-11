Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C4D3C3F2B
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 22:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhGKU27 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 16:28:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbhGKU26 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 16:28:58 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDACC0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 13:26:10 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id j3so6057375plx.7
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 13:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TsoRNdRl4LYHWWvjQL6i2KOCdffTJeTQ2Y0D2BJaHhY=;
        b=Nc1967nN3GAAq/Jqz+q16cGgfCxx7Vp50qHUyWnKJ6ltv7F3Edix1sXxG/lCWhcofi
         x4ImZhza5ze0ho1NXbE0CdDfPk761xCN6gEEBq6ZVe0aVIm3hEfdEp3N8AbrPBBe43Z8
         sQJQQTiNPZc1RTc5yjZx4tyb9GUZj09BKpl1M6G8Rmwg+cdmpTp//3HVxErpyo0H5Bo2
         WIfHrAiEtA+Zs1Dju5rNkmSi71oD79GaPioS8Qjp0nqLvGOjjXhQqBsGFJqwsxUE9grD
         PqFgdTuHIr/VtpMU+8fVG/9b87Zd9Prku47TV7TAvKwXvgjST+3kMZnEZH6LOap+b+N5
         5+vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TsoRNdRl4LYHWWvjQL6i2KOCdffTJeTQ2Y0D2BJaHhY=;
        b=andkc2HH0pOx1y7TPo9naiWyJUuRB9wAkOoR3hQtxgCTqsudrp4VX89wfyETS0bzWT
         p50trUfFPSfd7lveYwERMpIt9ec00/H6fNC2o9veZrHl8N4BwG0akpbJhQc15UPYtvmF
         TpQLtTZY/GxDBMMJOhZDH1shES7DlqKnHM3DoSksJLEBylAfWWkep0FIdI0pSVhkJL3o
         mh7egYJuKKeq8rmEu2LMH4DHeB8X/7zi23cvOenrVjJcfUMU3y1XuGBUEK/Y5FfgD5Ns
         Dr6EGpML2cVaMec4TFsvzeOXgbL8+a+qMCOyUjC/V33ErldqVNnQOoAboFfEg5YWusul
         Fp4A==
X-Gm-Message-State: AOAM53208cVzpqgrMKCqy3qQgFpod8guePAWL3tTcX84AW2mBlLoJ0fg
        /fSlF4pphXKy2qdBNipOI8K8MVb7QWU3UV8R
X-Google-Smtp-Source: ABdhPJxBu/s2x7lZBqmRrLMxHMQVeAtim+hAM6/TTS+rBPuGGJyU3edusBiDRr6b6Q0Clf7Di6eUSw==
X-Received: by 2002:a17:902:ec86:b029:129:ab4e:9ab2 with SMTP id x6-20020a170902ec86b0290129ab4e9ab2mr26677631plg.12.1626035169861;
        Sun, 11 Jul 2021 13:26:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b20sm13077247pfl.9.2021.07.11.13.26.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 13:26:09 -0700 (PDT)
Message-ID: <60eb53e1.1c69fb81.ab95b.751e@mx.google.com>
Date:   Sun, 11 Jul 2021 13:26:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.12.16-682-g36eea3662e2d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.12
Subject: stable-rc/queue/5.12 baseline: 189 runs,
 9 regressions (v5.12.16-682-g36eea3662e2d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 189 runs, 9 regressions (v5.12.16-682-g36eea=
3662e2d)

Regressions Summary
-------------------

platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
d2500cc             | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...6=
-chromebook | 1          =

d2500cc             | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig =
            | 1          =

hip07-d05           | arm64  | lab-collabora | gcc-8    | defconfig        =
            | 1          =

imx8mp-evk          | arm64  | lab-nxp       | gcc-8    | defconfig        =
            | 1          =

r8a77950-salvator-x | arm64  | lab-baylibre  | gcc-8    | defconfig        =
            | 1          =

r8a77960-ulcb       | arm64  | lab-baylibre  | gcc-8    | defconfig        =
            | 1          =

rk3288-veyron-jaq   | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g           | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.16-682-g36eea3662e2d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.16-682-g36eea3662e2d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      36eea3662e2dc4524b0faebf3c471b09a22c3250 =



Test Regressions
---------------- =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
d2500cc             | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...6=
-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb2c835cab800717117978

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
682-g36eea3662e2d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/b=
aseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
682-g36eea3662e2d/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/b=
aseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb2c835cab800717117=
979
        new failure (last pass: v5.12.15-11-g1a88438d15d2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
d2500cc             | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig =
            | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb2f2bbcf7594b1c11797e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
682-g36eea3662e2d/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
682-g36eea3662e2d/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb2f2bbcf7594b1c117=
97f
        new failure (last pass: v5.12.15-11-g1a88438d15d2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
hip07-d05           | arm64  | lab-collabora | gcc-8    | defconfig        =
            | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb2e18fdcf89fb4a11797f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
682-g36eea3662e2d/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
682-g36eea3662e2d/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb2e18fdcf89fb4a117=
980
        failing since 10 days (last pass: v5.12.13-109-g5add6842f3ea, first=
 fail: v5.12.13-109-g47e1fda87919) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
imx8mp-evk          | arm64  | lab-nxp       | gcc-8    | defconfig        =
            | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb280d2a6d9ec5d3117999

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
682-g36eea3662e2d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
682-g36eea3662e2d/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb280d2a6d9ec5d3117=
99a
        new failure (last pass: v5.12.15-11-g1a88438d15d2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
r8a77950-salvator-x | arm64  | lab-baylibre  | gcc-8    | defconfig        =
            | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb24975f93ab4aa111796a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
682-g36eea3662e2d/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
682-g36eea3662e2d/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb24975f93ab4aa1117=
96b
        new failure (last pass: v5.12.15-11-g1a88438d15d2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
r8a77960-ulcb       | arm64  | lab-baylibre  | gcc-8    | defconfig        =
            | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb23ebc736f6280011797b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
682-g36eea3662e2d/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77960-ulcb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
682-g36eea3662e2d/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77960-ulcb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb23ebc736f62800117=
97c
        new failure (last pass: v5.12.15-11-g1a88438d15d2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
rk3288-veyron-jaq   | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g           | 3          =


  Details:     https://kernelci.org/test/plan/id/60eb38c4d38fab45f011797e

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
682-g36eea3662e2d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.16-=
682-g36eea3662e2d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60eb38c4d38fab45f0117992
        failing since 26 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-07-11T18:30:16.215802  /lava-4177138/1/../bin/lava-test-case
    2021-07-11T18:30:16.233104  <8>[   14.410711] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-11T18:30:16.233358  /lava-4177138/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60eb38c4d38fab45f01179a9
        failing since 26 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-07-11T18:30:14.788069  /lava-4177138/1/../bin/lava-test-case
    2021-07-11T18:30:14.806019  <8>[   12.982517] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60eb38c4d38fab45f01179aa
        failing since 26 days (last pass: v5.12.10-48-g5e97c6651365, first =
fail: v5.12.10-173-gfd0b35fa0b0c)

    2021-07-11T18:30:13.769190  /lava-4177138/1/../bin/lava-test-case
    2021-07-11T18:30:13.774563  <8>[   11.963690] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
