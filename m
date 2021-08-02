Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3F43DDDE6
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 18:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhHBQnT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 12:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229903AbhHBQnT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Aug 2021 12:43:19 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE2FC06175F
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 09:43:09 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id nh14so14223438pjb.2
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 09:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ISpjOHnIB338263iZLcDLQYT4yK9dmTEPk/M5cXoa2o=;
        b=GupNdX8oJh6bU6xC31QmIxQNzZh13DSHIaKv5om28hhrmmVgEuQyHJH76a3qXPtclw
         LtJfbRpZbis2KJkLBVj7HYsuvtRHEzljr1qmi8y06irAlXhSHDfMhCSt81hBgJtEi4b2
         lglQ6BEgo0MQyJoX4eiS1Q4bEPjI7a/PkeSdNM/vdr5lbAjcoBvqCd/NPsKILcWAZNeq
         prbMu48oFiIecf/WWBdUaEbGgoKpcf/cIYiUODcscRlQze9+WKQy/fpMsLS2bYLYcHtP
         YYEZ8M9ALGAPdrz5v5FkLIn2HUahZ/M+4wwT8gy7Ekn+5+hm4xn3yPhD7kvMrSJfP00b
         EaYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ISpjOHnIB338263iZLcDLQYT4yK9dmTEPk/M5cXoa2o=;
        b=rJw8lf8z4B1kjdVnXy2WX6mqqCyFzM49CpxWzzu9pWY4bgK25+dZnGhic/3mtFfP4l
         s9W/WUwNCuzAay4dlAuc9PT9ElZUWAwBe9JuI64arK/rquh6CarvPTPs5XUdExFHQiR8
         mQW0/jZbTR5x/2T5I8JgEIUTcFBK1h8q4dK19D4Xl9iQkWyP2X6UoUPkNsDYIugew8Ht
         bYQeUwkavg3juLIxI1kwK5OOYOuhg3QWBICZg9ypCmc/GRmggMUM1YU+GWhghF4mCeeH
         aPblWXLUe41xw+kak1r8waxpax03BLzQ2RrozG1mGaPaB24iIUsyRbe75JVW6XxyxSpI
         Ku4Q==
X-Gm-Message-State: AOAM5332GBa9sh7p4URnqaENL8fSedTzxIPCQSUz8EMHs73m+VEzJ9YX
        Xpa1J6KjJv2j6om7wn1dehbhuee7hGmtmGy/
X-Google-Smtp-Source: ABdhPJwA+MgZraKkrtHF99U9SVpMY8DAy45EkI4havav29hXO/ErE3AkbNZfMhXGAam8jYhzWIhcRg==
X-Received: by 2002:a17:902:6bc8:b029:117:6a8a:f7af with SMTP id m8-20020a1709026bc8b02901176a8af7afmr14450909plt.51.1627922589075;
        Mon, 02 Aug 2021 09:43:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g19sm11191124pjl.25.2021.08.02.09.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 09:43:08 -0700 (PDT)
Message-ID: <6108209c.1c69fb81.55d23.f868@mx.google.com>
Date:   Mon, 02 Aug 2021 09:43:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.55-60-g0f533614709a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 175 runs,
 6 regressions (v5.10.55-60-g0f533614709a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 175 runs, 6 regressions (v5.10.55-60-g0f5336=
14709a)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
fsl-ls1043a-rdb   | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =

hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =

imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.55-60-g0f533614709a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.55-60-g0f533614709a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0f533614709a7082f2e2c3bd68bb91674b5d5d12 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
fsl-ls1043a-rdb   | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6107e9be32802fcb7ab1368b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
60-g0f533614709a/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1043a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
60-g0f533614709a/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1043a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6107e9be32802fcb7ab13=
68c
        new failure (last pass: v5.10.55-59-gb0f0b0da3e3b) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6107eb4d9e8c729930b136ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
60-g0f533614709a/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
60-g0f533614709a/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6107eb4d9e8c729930b13=
6eb
        failing since 32 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6107ea308a36839fc1b1366e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
60-g0f533614709a/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
60-g0f533614709a/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6107ea308a36839fc1b13=
66f
        failing since 1 day (last pass: v5.10.54-2-g41c54732efb5, first fai=
l: v5.10.55-27-ge0b8a9439c81) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/6107f0db385548aa65b13673

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
60-g0f533614709a/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.55-=
60-g0f533614709a/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6107f0db385548aa65b1368b
        failing since 48 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-02T13:19:05.456452  /lava-4306252/1/../bin/lava-test-case<8>[  =
 14.385645] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-08-02T13:19:05.456818     =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6107f0db385548aa65b136a3
        failing since 48 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-02T13:19:04.019162  /lava-4306252/1/../bin/lava-test-case
    2021-08-02T13:19:04.028889  <8>[   12.957961] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6107f0db385548aa65b136a4
        failing since 48 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-02T13:19:03.007174  /lava-4306252/1/../bin/lava-test-case
    2021-08-02T13:19:03.012908  <8>[   11.938393] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
