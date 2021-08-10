Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64FF3E85D7
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 00:01:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234856AbhHJWCL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 18:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234814AbhHJWCK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Aug 2021 18:02:10 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD12C061765
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 15:01:48 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id j1so190615pjv.3
        for <stable@vger.kernel.org>; Tue, 10 Aug 2021 15:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nv4UUJDMcApdzkYd1mQJiiTUm9H6Zs/F5CD3qlrnZRQ=;
        b=VNmfPUGqYLOEL2vwoQcHxbgFaSLZyzC0RagwE30oBmKdi5H4Em2PGWiihY0qKczzK5
         4+Jkq1fablpFuHHLNWIzdp60P30qIQ1db9CdwgVKo7uHNLAHwh8TycCXQpM5MQ2GGpRu
         eDPEqTMQBUU2NfrgPK53CTDCL1l6Ki12qJa+g5k6m6RgCCSdTgpeT4n3Olsr31Xd39cV
         uZTBbb1jz+tc6KDcZSA0pxHhjFOpIXwmkSAmrCBnUGpCQ7tCfpVkK9e+vk2kX0awwLOl
         LAZJfHhTSeRtM5t8j8+P/lJN83n8OVMcnDdYnQfuLlVlIQtcrEDjZ+/9pqkrwA069KQ1
         5hVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nv4UUJDMcApdzkYd1mQJiiTUm9H6Zs/F5CD3qlrnZRQ=;
        b=KMZhF3Q0SyZXYAEncbC5/NxpY4giF/3EMddN4eLZuSzkc7yQRqcJejxJvZ80CJL6b/
         saEQPSwsP3FBe2FTg+snXVT+d1UobgKGk2orc5Ybvd4/xyCHNqec23ICma3jrrotfFNk
         A7uOGrz0ZuCwhuL7GlpEYMwSp5JxDVfMFtcFGvftgTSqkrhenGJ7+BsZiFwKUD3EfTrS
         xz4+RHBawl4cWbnTA/T19Gh4YShMrjX4/VXSGFTAulJSD1kYeBGQ/Ti5xGkPwTZKnS0Q
         sGuzjTkrPBi7poeYSNpvnGiskJ9+C/BxX2+t13DofEx12zuPqRYXu5QWyACQ2oy83P2e
         kptw==
X-Gm-Message-State: AOAM532SQxUOMPPLbGrVdGOIE3X0hiS8kEAlWj+dmmtIxp0at2qBpdaT
        aM6uBPpNu4mhQOquFt12LSOk1MeQt0ZNX/C8
X-Google-Smtp-Source: ABdhPJzokNAVZVtKS2xXr1Hil4UHrD/cWjMc5pLjBj5TtpNqZc3cxpCipQKWe0+BqjwzAETyrI33ZA==
X-Received: by 2002:a17:90a:1387:: with SMTP id i7mr21153217pja.169.1628632907545;
        Tue, 10 Aug 2021 15:01:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u15sm25543878pfn.91.2021.08.10.15.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 15:01:47 -0700 (PDT)
Message-ID: <6112f74b.1c69fb81.98c7.b770@mx.google.com>
Date:   Tue, 10 Aug 2021 15:01:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.57-135-gf96c18966416
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 93 runs,
 5 regressions (v5.10.57-135-gf96c18966416)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 93 runs, 5 regressions (v5.10.57-135-gf96c18=
966416)

Regressions Summary
-------------------

platform                 | arch | lab           | compiler | defconfig     =
     | regressions
-------------------------+------+---------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre  | gcc-8    | multi_v7_defco=
nfig | 2          =

rk3288-veyron-jaq        | arm  | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.57-135-gf96c18966416/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.57-135-gf96c18966416
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f96c189664169a35cae69a4065656758ee8b10b2 =



Test Regressions
---------------- =



platform                 | arch | lab           | compiler | defconfig     =
     | regressions
-------------------------+------+---------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre  | gcc-8    | multi_v7_defco=
nfig | 2          =


  Details:     https://kernelci.org/test/plan/id/6112c345a3c12f416db1369e

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
135-gf96c18966416/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
135-gf96c18966416/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6112c345a3c12f4=
16db136a2
        new failure (last pass: v5.10.57-125-ge4a7485167f0)
        4 lines

    2021-08-10T18:19:20.799982  kern  :alert : 8<--- cut here ---
    2021-08-10T18:19:20.830849  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address 0032001c
    2021-08-10T18:19:20.831151  kern  :alert : pgd =3D (ptrval)
    2021-08-10T18:19:20.832232  kern  :a<8>[   39.681480] <LAVA_SIGNAL_TEST=
CASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>
    2021-08-10T18:19:20.832539  lert : [0032001c] *pgd=3D00000000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6112c345a3c12f4=
16db136a3
        new failure (last pass: v5.10.57-125-ge4a7485167f0)
        60 lines

    2021-08-10T18:19:20.847963  kern  :emerg : Internal error: Oops: 5 [#1]=
 SMP ARM
    2021-08-10T18:19:20.889900  kern  :emerg : Process udevd (pid: 134, sta=
ck limit =3D 0x(ptrval))
    2021-08-10T18:19:20.890204  kern  :emerg : Stack: (0xc39e3bf8 to 0xc39e=
4000)
    2021-08-10T18:19:20.890729  kern  :emerg : 3be0:                       =
                                c3a661b0 c3a661b4
    2021-08-10T18:19:20.891000  kern  :emerg : 3c00: c3a66000 c3a66014 c144=
ab40 c09c6c8c c39e2000 ef86c2a0 8010000f c3a66000
    2021-08-10T18:19:20.891251  kern  :emerg : 3c20: 0031fffc ffce0777 c19c=
7874 c2001a80 c3a65800 ef86cc80 c09d43e4 c144ab40
    2021-08-10T18:19:20.891748  kern  :emerg : 3c40: c19c7858 ffce0777 c19c=
7874 c3a15000 c3084f80 c3a66000 c3a66014 c144ab40
    2021-08-10T18:19:20.932964  kern  :emerg : 3c60: c19c7858 0000000c c19c=
7874 c09d43b4 c1448868 00000000 c3a6600c c3a66000
    2021-08-10T18:19:20.933528  kern  :emerg : 3c80: fffffdfb c2298c10 c3ae=
ae00 c09aa2d4 c3a66000 bf048000 fffffdfb bf044138
    2021-08-10T18:19:20.933805  kern  :emerg : 3ca0: c3afae40 c325c908 0000=
0120 c3a300c0 c3aeae00 c0a03f30 c3a11680 c3a11680 =

    ... (34 line(s) more)  =

 =



platform                 | arch | lab           | compiler | defconfig     =
     | regressions
-------------------------+------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq        | arm  | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/6112c6d72d962205beb1366d

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
135-gf96c18966416/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
135-gf96c18966416/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6112c6d72d962205beb13685
        failing since 56 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-10T18:34:42.638700  /lava-4343554/1/../bin/lava-test-case
    2021-08-10T18:34:42.639074  <8>[   14.636437] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6112c6d82d962205beb1369c
        failing since 56 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-10T18:34:41.229687  /lava-4343554/1/../bin/lava-test-case<8>[  =
 13.211895] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-08-10T18:34:41.230080  =

    2021-08-10T18:34:41.230409  /lava-4343554/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6112c6d82d962205beb1369d
        failing since 56 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-10T18:34:40.194800  /lava-4343554/1/../bin/lava-test-case
    2021-08-10T18:34:40.195146  <8>[   12.192386] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
