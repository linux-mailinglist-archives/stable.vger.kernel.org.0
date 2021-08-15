Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F254B3ECBAF
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 00:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbhHOWcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Aug 2021 18:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbhHOWcn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 15 Aug 2021 18:32:43 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C281EC061764
        for <stable@vger.kernel.org>; Sun, 15 Aug 2021 15:32:12 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id fa24-20020a17090af0d8b0290178bfa69d97so24543608pjb.0
        for <stable@vger.kernel.org>; Sun, 15 Aug 2021 15:32:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fbpYRcgPpJkntidnZgUPOqq95xnAsyIjea5TB1CnzpE=;
        b=P+SVz0p/vtmt9W8/M64M6WvnIuABtZPL9e+BGOd3V6Qgkt8tuaA1Sa79h6/hXiic5E
         Vo+RjHiUWqj1Kmc8HL9FDUTipyWtljC7mT00QYoD5Hckw33nTuWVTOWC0t2E+BMR/j9+
         cTXvmvwR5DByzw+QWYOwurhfAIl6iBcjjF5RZ3RqPeDoNEj14WUBUblqUPAjnNbzMzjy
         fOCC8Ny2LPWWNHLsGCGzNziv6gtXpdgW9c1wQ69Qnt56z2pFDZU8YE6v+e3yykp9EvLa
         h+yKXu9KwurFxSd+qQbcG5MOjZLRXDc7Cu3BbWbeKc3c5pfCTFynWlYM+jtva6BYAO5W
         AvTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fbpYRcgPpJkntidnZgUPOqq95xnAsyIjea5TB1CnzpE=;
        b=Ih6qTOYAPemsHsraSaqW/QAqB7ek55l0+pZBQz+rASgaxtzdL5oZttkS+a6vTZlvDL
         +ufX+dWHc0vlqMOlG3nBJ9wYmd+ikStmBy4LwRZSwki/0ZDCMwVtoJGXuNEpZK59amcY
         mo5kO98j6pQyRcJo2Rj2dBAWQdrVujsteGo0PYqIQLIjxgbDW+KxzYYAevb2OtUFmNhB
         K5eIB/3TilWhqg+PKHpF8B9RxOSyN1vtkLjDnqcXPcGCisP33wUQA3lz8TcojHfn0VyA
         2YyF6wlB4mxQY9PYBlQdVh5D+VIEWovSyteiaWUrCAALw2dYPAwDdgalYeQSLg5aM8jZ
         ua7w==
X-Gm-Message-State: AOAM532lctvac77bTLIPo1/wivCuCzNK/M2n+PQlizsC9Al9c57MXFuK
        S5PYDDLuEaYBSTS5BqPaFm1EWikuXxDdHMFG
X-Google-Smtp-Source: ABdhPJxauDT9OelfiexCCzTByv/TX/BWmgCZKtswDAUi2zYd26jEuST7kWVVopKwJx3/BDodnDsTJA==
X-Received: by 2002:a17:90a:2f44:: with SMTP id s62mr13603124pjd.222.1629066731911;
        Sun, 15 Aug 2021 15:32:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t40sm2723858pfg.6.2021.08.15.15.32.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Aug 2021 15:32:11 -0700 (PDT)
Message-ID: <611995eb.1c69fb81.efd8f.80a1@mx.google.com>
Date:   Sun, 15 Aug 2021 15:32:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.57-221-g59fda4eb754b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 189 runs,
 8 regressions (v5.10.57-221-g59fda4eb754b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 189 runs, 8 regressions (v5.10.57-221-g59fda=
4eb754b)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
fsl-ls1043a-rdb         | arm64 | lab-nxp       | gcc-8    | defconfig     =
     | 1          =

hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =

imx7d-sdb               | arm   | lab-nxp       | gcc-8    | multi_v7_defco=
nfig | 1          =

imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig     =
     | 1          =

rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.57-221-g59fda4eb754b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.57-221-g59fda4eb754b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      59fda4eb754b6407d95bc84156ed50d3fc3143f3 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
fsl-ls1043a-rdb         | arm64 | lab-nxp       | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6119671e1a5316bfd7b1366c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
221-g59fda4eb754b/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1043a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
221-g59fda4eb754b/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls1043a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6119671e1a5316bfd7b13=
66d
        new failure (last pass: v5.10.57-154-g5f0bac13c2e0) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6119660f7d9e5afce1b13662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
221-g59fda4eb754b/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
221-g59fda4eb754b/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6119660f7d9e5afce1b13=
663
        failing since 45 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
imx7d-sdb               | arm   | lab-nxp       | gcc-8    | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61196489a8b7d7e557b136e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
221-g59fda4eb754b/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
221-g59fda4eb754b/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61196489a8b7d7e557b13=
6e7
        new failure (last pass: v5.10.57-154-g5f0bac13c2e0) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/611966911f00d4f855b13665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
221-g59fda4eb754b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
221-g59fda4eb754b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611966911f00d4f855b13=
666
        failing since 5 days (last pass: v5.10.57-49-g039efb5682ed, first f=
ail: v5.10.57-125-gb8eec9975ba1) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/611964af288ac02f29b13661

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
221-g59fda4eb754b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
221-g59fda4eb754b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611964af288ac02f29b13679
        failing since 61 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-15T19:01:59.678951  /lava-4368110/1/../bin/lava-test-case<8>[  =
 13.917281] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-08-15T19:01:59.679512  =

    2021-08-15T19:01:59.679931  /lava-4368110/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611964af288ac02f29b13691
        failing since 61 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-15T19:01:58.255611  /lava-4368110/1/../bin/lava-test-case<8>[  =
 12.493786] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-08-15T19:01:58.256065  =

    2021-08-15T19:01:58.256379  /lava-4368110/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611964af288ac02f29b136a8
        failing since 61 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-15T19:01:57.219695  /lava-4368110/1/../bin/lava-test-case
    2021-08-15T19:01:57.224928  <8>[   11.474430] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/611965f22db62939e4b1367c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
221-g59fda4eb754b/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
221-g59fda4eb754b/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611965f22db62939e4b13=
67d
        new failure (last pass: v5.10.57-154-g5f0bac13c2e0) =

 =20
