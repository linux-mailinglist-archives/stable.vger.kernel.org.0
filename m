Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0553EDCB4
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 20:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhHPSAj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 14:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhHPSAi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 14:00:38 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D2EC061764
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 11:00:06 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id oa17so27828638pjb.1
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 11:00:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IHfwyqkGABj/zXMAL0hVrb6HTA5+XZ2J+VG8cs3Fun0=;
        b=SrbCBG3zCM9WDeAhICzKEH4zMsdgX0MKXlxCj0ly1TWb0fSdcAAPsBgMwo3bj9m59z
         UkuvnYZJnJ2JuJ0FTZxmb72Pzcv9xr47gN1vGN51xZQLmwhhLQrUCvFr4bgXPFizwQdZ
         JMfEwHNbLBt+7tbQNo3ZULMSa0DyRjHUq5f6fFJkdEjftCtN+eVBwbM5H/UTt+KjkSvd
         H3tTHydjgojcSMKJwPXeOCllhqChzsJdRbDbYkSXr9o00P8dGsscWrDEy5rf7Q0QnswG
         wa4vOcnAqzlgAcqEYEtWytuCw/570wnh9DAea/w7Tl7H/4nCRqwIjBfjnMBvVFb5LB6b
         4QqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IHfwyqkGABj/zXMAL0hVrb6HTA5+XZ2J+VG8cs3Fun0=;
        b=NZDxIXH3w0zYgutfhqg8WaOa1Ag4B6FDv0ew1LFqOAAB61pZrlMG43dIoxoa1vEXk9
         UMWIClFF8DSb+M68WTfGKTCFgPZ8QEG+PVDzkPYUKlUOhE6qhRqHr9L/svSPmEF0BBBZ
         gkjnlJZpMOjKP5LjqRHmI4gN2U0B2ICkMxjQih/I0ePyOM/qzWbzLJZtWBSX62aaWoBw
         +oZKbkz9F1xsGwuxR5A9VMvBvRpH/48RuUDxSrIXK5Jhw6L0x4uwj+i+Mvb517vQ6T2h
         6XHL9ImZni6btfbOtaWKDOpmKsH4bE6UZEkn+RsLbrVNbCJk1iGk2TB6tjU1MO9fFDFz
         USLA==
X-Gm-Message-State: AOAM533xA3DCkEwNAYCKp9zalLLNtzO+XL/3W2zgwBBw6n1O3fmCIA0A
        O8MfjEKL6WEBlj/0zpZ9VcSNyXy1MJb54qOb
X-Google-Smtp-Source: ABdhPJzAKKIgzdJ3c7ijm1HLofrsbsDf/+kfTWaCPQrXThqQzFkBcfNUfxGTVq2qYLPcFL5RQvuSOw==
X-Received: by 2002:a17:90b:f83:: with SMTP id ft3mr322338pjb.173.1629136806291;
        Mon, 16 Aug 2021 11:00:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p24sm42561pff.161.2021.08.16.11.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 11:00:05 -0700 (PDT)
Message-ID: <611aa7a5.1c69fb81.c6288.035c@mx.google.com>
Date:   Mon, 16 Aug 2021 11:00:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.59-96-g07687e3e26bf
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 157 runs,
 5 regressions (v5.10.59-96-g07687e3e26bf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 157 runs, 5 regressions (v5.10.59-96-g07687e=
3e26bf)

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
nel/v5.10.59-96-g07687e3e26bf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.59-96-g07687e3e26bf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      07687e3e26bf1bf56563872985d05bf7850b190a =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/611a780ce4525ff2efb13661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.59-=
96-g07687e3e26bf/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.59-=
96-g07687e3e26bf/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611a780ce4525ff2efb13=
662
        failing since 46 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/611a7b82bc39995b9bb13682

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.59-=
96-g07687e3e26bf/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.59-=
96-g07687e3e26bf/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611a7b82bc39995b9bb13698
        failing since 62 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-16T14:51:39.412098  /lava-4370815/1/../bin/lava-test-case
    2021-08-16T14:51:39.429797  <8>[   13.366843] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-16T14:51:39.430036  /lava-4370815/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611a7b82bc39995b9bb136b0
        failing since 62 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-16T14:51:37.985936  /lava-4370815/1/../bin/lava-test-case
    2021-08-16T14:51:38.003602  <8>[   11.940502] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-16T14:51:38.004083  /lava-4370815/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611a7b82bc39995b9bb136b2
        failing since 62 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-16T14:51:36.966131  /lava-4370815/1/../bin/lava-test-case
    2021-08-16T14:51:36.971659  <8>[   10.920793] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/611a76699a421073b2b13687

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.59-=
96-g07687e3e26bf/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.59-=
96-g07687e3e26bf/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611a76699a421073b2b13=
688
        new failure (last pass: v5.10.59-96-ge4ba0182192d) =

 =20
