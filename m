Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17154421760
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 21:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238245AbhJDTZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 15:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237266AbhJDTZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 15:25:09 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65E3EC061745
        for <stable@vger.kernel.org>; Mon,  4 Oct 2021 12:23:20 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id rj12-20020a17090b3e8c00b0019f88e44d85so187409pjb.4
        for <stable@vger.kernel.org>; Mon, 04 Oct 2021 12:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=S7lZitUZtL8ClQjA52+iJmXfCDtfnKOZRgq4gYOQpdk=;
        b=Svsd9JIjuocFsGtuJy8fVc1OCzjdqBztpkiJ0diWc/WsOQaNZjAfIG+qcoD1etVnf6
         QpiNyPuZYyLGQ76FqOkmSbadP9zW0qzhf+YP6Xsz2ra8O+TIq+HiJfr4BjVrgmZhg7Xt
         st3dsnxeZePy4ViP30tb3/7Ckho9yf1jgXwHf5vtH4jbXeeKKJeNwbYTnSZVucZ2S/vw
         9lTJdQg8havWnwEJ4sC8mOs3yxXknXANPHeEG1ncYTtQhLNao0W4NLExxK9A0pPO5WEp
         mYRQUEtKnjZxM+hsaBmJQcp+HTS1XtySIvq9R2y83hYiXBKOxJP4k50RbjUzMP4VQkQU
         P1FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=S7lZitUZtL8ClQjA52+iJmXfCDtfnKOZRgq4gYOQpdk=;
        b=O14oCqDQ/M82U27IF0P0YupQk27JSfBmxhI6MlFCYBPFRA6zoFf5gd6X+50AgFKgn4
         7Ok59W1CPbZ3ThG72P1D12TwMcsAbwaBzUnyeIW8AMvx8WBjwe7DCVjuLIiGEwGKRHOe
         ZB9NPSY+5t9lPAzxhw3VWniao7WE3RuwDh1TFc46aPp9HmrwEOLFZM3VCGI3ZVR71nbU
         yMm+KKYynT/pq1WZIufN8DLZBOsBifu7mXyfCuytBumjJvmMCPp3Y4eQtxQ82xoQYszl
         JvWjj+8i/n+Bp2YEpqUNsAJTzVLGxM1RrANKL5W5cHKz0k0LB5RRDUI+KcJZfCvhg05Q
         UVNw==
X-Gm-Message-State: AOAM533Djg8Kp40XL9vfg6bwjIOP5205KwoKMH5r/esKt64Ck3Q6uvKX
        L8ZPCxc6ZdAsjcHJlR79PQYWPidwVyE/MVrc
X-Google-Smtp-Source: ABdhPJzxXFzJI+OFwzHZ6pEiOLsZx35ntIZ7g4boX2+x9sTowO721VCjXpBQzE4ym35wbD//Kos6hw==
X-Received: by 2002:a17:90b:f8d:: with SMTP id ft13mr14045967pjb.137.1633375399788;
        Mon, 04 Oct 2021 12:23:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h9sm17141151pjg.9.2021.10.04.12.23.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 12:23:19 -0700 (PDT)
Message-ID: <615b54a7.1c69fb81.bb8b7.202b@mx.google.com>
Date:   Mon, 04 Oct 2021 12:23:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.70-93-g42da4b1238c5
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 161 runs,
 5 regressions (v5.10.70-93-g42da4b1238c5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 161 runs, 5 regressions (v5.10.70-93-g42da4b=
1238c5)

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
nel/v5.10.70-93-g42da4b1238c5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.70-93-g42da4b1238c5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      42da4b1238c5aa9878308f223346b2fd84d3b39d =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/615b1feb8217db706799a358

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.70-=
93-g42da4b1238c5/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.70-=
93-g42da4b1238c5/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b1feb8217db706799a=
359
        failing since 95 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/615b34bd71ec7d3aa399a2e4

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.70-=
93-g42da4b1238c5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.70-=
93-g42da4b1238c5/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/615b34bd71ec7d3aa399a2f8
        failing since 111 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-10-04T17:07:00.299967  /lava-4641868/1/../bin/lava-test-case<8>[  =
 13.258461] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-10-04T17:07:00.300281  =

    2021-10-04T17:07:00.300474  /lava-4641868/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/615b34bd71ec7d3aa399a310
        failing since 111 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-10-04T17:06:58.876033  /lava-4641868/1/../bin/lava-test-case<8>[  =
 11.834103] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-10-04T17:06:58.876449  =

    2021-10-04T17:06:58.876718  /lava-4641868/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/615b34bd71ec7d3aa399a311
        failing since 111 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-10-04T17:06:57.839481  /lava-4641868/1/../bin/lava-test-case
    2021-10-04T17:06:57.844628  <8>[   10.814442] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/615b2000940751618f99a2ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.70-=
93-g42da4b1238c5/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.70-=
93-g42da4b1238c5/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b2000940751618f99a=
2f0
        failing since 21 days (last pass: v5.10.63-26-gfb6b5e198aab, first =
fail: v5.10.64-214-g93e17c2075d7) =

 =20
