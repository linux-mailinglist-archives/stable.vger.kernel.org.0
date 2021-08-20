Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1173F3F24C0
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 04:26:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbhHTC0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 22:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbhHTC0n (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 22:26:43 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21A0C061575
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 19:26:05 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id w6so5097097plg.9
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 19:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=chc7fGd1jmxHgvmwXIO2pummINF8XeRXR9eP/A2u9wM=;
        b=ljUJjacsKQnP/RVh9Vhn6eA/X7tCQjZ38CV1NbDs9k4o9dkW5XiUiqv0Ey8xl2HSvX
         ZF3+t5R4yhM9dQxhodjr9wyvRKEBNunTbuUhEHAv+gws814BMplig0dp76fCcJ1NXMoN
         beBx4TMVd4ESh2v6T3JafpHdsm4BptEyaphiKz/e4EMlBeIGLpZYb/cHZ8qG6HnbwFiD
         FPAXkVbDgLCwo8mxuehCaHhpZ4F86Yf2WMAVEClvKZwbobFAayT3dQLNvRXBZIIF1djr
         wU5wcjJn8AhPBfJO5LmODXr3Ult9TL4XxDhusa0mouzdwDtRnJ5oKe86ubmsO5g8ZHx/
         RrDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=chc7fGd1jmxHgvmwXIO2pummINF8XeRXR9eP/A2u9wM=;
        b=lM+50Is2SOyKhoiFQRVHtZzXYPtCZhqGYKOMFYV6opQ1R5bBXLQHAVW4azYDfQIZg5
         9EJxKQN/mDJTB+F42srg2HUs4pbqg3anQidQcdCD4CUnNYVMbi+bg9ljzK9jyHygsoAK
         HpXAMzjFhnDLqlo/pf5A0+yIUwOBv+jg9PfU8rFSjkKFdsQWpu8zMxe+6/aWfvDt5bjk
         wuR3WyZyOcKhP2Ff5duXI/8QpuW+u35ruiTiBiv2Zwg+lmE/GP85DKSr3mIdebHjcDhK
         iL9omIFJl3DK0c/EQgtMSplaoucakaLK6yxbKR6n1UUSyGzU2DYl8jWKh6g7dHWz3Fxb
         VsJg==
X-Gm-Message-State: AOAM531FfBi29lOGBp91hWuVw4IJSKzduo00C4ACEYgJuBr28GFdLbmu
        RqOZpgOC98A6Dos0GvEqb90IS4ZrMCgADZDi
X-Google-Smtp-Source: ABdhPJyumiSoNF/7oesub/RT8Rt7wn4BZ8jCf7XSmzJTXlPIhOxOYgo2zuJyo0qrZyyTcHHRuu06sQ==
X-Received: by 2002:a17:902:9a04:b029:12b:8d54:7c2 with SMTP id v4-20020a1709029a04b029012b8d5407c2mr14823639plp.62.1629426365267;
        Thu, 19 Aug 2021 19:26:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s22sm4678598pfu.52.2021.08.19.19.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 19:26:05 -0700 (PDT)
Message-ID: <611f12bd.1c69fb81.7fa00.060e@mx.google.com>
Date:   Thu, 19 Aug 2021 19:26:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.60-33-g1da01150ea2b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 189 runs,
 6 regressions (v5.10.60-33-g1da01150ea2b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 189 runs, 6 regressions (v5.10.60-33-g1da011=
50ea2b)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
hip07-d05                | arm64 | lab-collabora | gcc-8    | defconfig    =
      | 1          =

imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 1          =

rk3288-veyron-jaq        | arm   | lab-collabora | gcc-8    | multi_v7_defc=
onfig | 3          =

sun50i-a64-bananapi-m64  | arm64 | lab-clabbe    | gcc-8    | defconfig    =
      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.60-33-g1da01150ea2b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.60-33-g1da01150ea2b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1da01150ea2b38df9665fa899437f8eaee8a893a =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
hip07-d05                | arm64 | lab-collabora | gcc-8    | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/611eeb6a9504bfde9db1366a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
33-g1da01150ea2b/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
33-g1da01150ea2b/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611eeb6a9504bfde9db13=
66b
        failing since 49 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/611ee163f6edf3584bb13665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
33-g1da01150ea2b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-v=
ar-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
33-g1da01150ea2b/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-v=
ar-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611ee163f6edf3584bb13=
666
        new failure (last pass: v5.10.60-34-gaa41030a741e) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
rk3288-veyron-jaq        | arm   | lab-collabora | gcc-8    | multi_v7_defc=
onfig | 3          =


  Details:     https://kernelci.org/test/plan/id/611ee2fc1ed9ce5ec6b1366f

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
33-g1da01150ea2b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
33-g1da01150ea2b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611ee2fc1ed9ce5ec6b13687
        failing since 65 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-19T23:02:08.609558  /lava-4389207/1/../bin/lava-test-case
    2021-08-19T23:02:08.609875  <8>[   13.364307] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611ee2fc1ed9ce5ec6b1369f
        failing since 65 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-19T23:02:07.180668  /lava-4389207/1/../bin/lava-test-case
    2021-08-19T23:02:07.197485  <8>[   11.936962] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611ee2fc1ed9ce5ec6b136a0
        failing since 65 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-19T23:02:06.166615  /lava-4389207/1/../bin/lava-test-case<8>[  =
 10.917409] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-08-19T23:02:06.166932     =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
sun50i-a64-bananapi-m64  | arm64 | lab-clabbe    | gcc-8    | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/611ee2f1f8cd746e4eb136a1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
33-g1da01150ea2b/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
33-g1da01150ea2b/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611ee2f1f8cd746e4eb13=
6a2
        failing since 3 days (last pass: v5.10.59-96-ge4ba0182192d, first f=
ail: v5.10.59-96-g07687e3e26bf) =

 =20
