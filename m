Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDC943B0EAB
	for <lists+stable@lfdr.de>; Tue, 22 Jun 2021 22:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhFVU03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Jun 2021 16:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbhFVU02 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Jun 2021 16:26:28 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D5CC061574
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 13:24:11 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id u18so449074pfk.11
        for <stable@vger.kernel.org>; Tue, 22 Jun 2021 13:24:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ebWDTLWwgns+/cQBYQ8Y9KswLLY827otUcmSO7BLbkg=;
        b=1Z8mbOcRqe/yGbBqMqMLG/rd7zQvI1Fq2/nuziqS75W8KrLNdIS+J8YqRP98v2kGV3
         UAM6sttUzKjbezGMA91kZ4n1lEVTNOL+Hl+foKxeCz8ifq3l+wqhZhC7tN7KhkVKiwn/
         4O4XEHbvpzr/FomuDhrx+HFBhCctN/xDyah4Eja0nvr4+7uRGC/hNfyB48vJQa/rsSJC
         tgzwvHrTuYW3xnYHM4TIkB18tg74YQ1E9ZhUgXGHL+qAppjrldpCsf2QOMZp3wnI1K+f
         xXA2QMZwnlxMP6MEID2ti/A7mnRFr1qy1UVaA6W8POoBgrKfrFuRH1x0OStXLweQKTAj
         8zLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ebWDTLWwgns+/cQBYQ8Y9KswLLY827otUcmSO7BLbkg=;
        b=o+CaUVYKsN4V9aGc4doVDC77ABovz1Hz8h+plsyaII6uAbAoB7lygeY9518Xmckp42
         7HaPX98zYp2P6jrqWKcsSiH9PLBUTEUDX32x7CNC81FVIOKqqpfYrBHJle/tKGvWi7Nr
         uwwkZ2AdtmQ8Z0PLLcwk7ZHMQFOivpklB8gIrkfebCG6wqG6XV3606pb37cEoKQxN2M1
         n+dUOum5R1ApqMI4s9fe0pS+vSL9mKemrJetqOD9ioXAUZEVAcEvkYp7dCicOLC6CXbY
         E53553A8ngURrgQp4l2iTisMewNAGBnqlRALWR9P3xkCKid5wtK09dlc2o08BZEhROrl
         EiMQ==
X-Gm-Message-State: AOAM5303mkEcvdxGWGBr+ymobr8Go1Gg4M4XnfjZj7ONngKzshoGg24f
        o1O/7E8v/N8+H964HMi0zDAfVCCGSOt4Pw==
X-Google-Smtp-Source: ABdhPJw9l6VR4+RJyEL4kskoZWQRHM8br//kHy8LD4Zcpg9H4gqI5eyPmkrAJPR76xm7wqt+DuVUOA==
X-Received: by 2002:a63:e407:: with SMTP id a7mr422966pgi.220.1624393451206;
        Tue, 22 Jun 2021 13:24:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v9sm20025731pgq.54.2021.06.22.13.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jun 2021 13:24:10 -0700 (PDT)
Message-ID: <60d246ea.1c69fb81.267d7.694d@mx.google.com>
Date:   Tue, 22 Jun 2021 13:24:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.237-61-gca52d730561f
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 110 runs,
 3 regressions (v4.14.237-61-gca52d730561f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 110 runs, 3 regressions (v4.14.237-61-gca52d=
730561f)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.237-61-gca52d730561f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.237-61-gca52d730561f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ca52d730561f75470c408a8f8bff5a51c056a229 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/60d23097ad39e7210b413285

  Results:     62 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-61-gca52d730561f/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.237=
-61-gca52d730561f/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60d23097ad39e7210b4132a1
        failing since 7 days (last pass: v4.14.236-20-gdb14655bb4bf, first =
fail: v4.14.236-49-gfd4c319f2583) =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60d23097ad39e7210b4132a2
        failing since 7 days (last pass: v4.14.236-20-gdb14655bb4bf, first =
fail: v4.14.236-49-gfd4c319f2583)

    2021-06-22T18:48:48.041055  /lava-4074206/1/../bin/lava-test-case[   13=
.696804] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed R=
ESULT=3Dfail>
    2021-06-22T18:48:48.041299  =

    2021-06-22T18:48:49.053870  /lava-4074206/1/../bin/lava-test-case
    2021-06-22T18:48:49.071796  [   14.715537] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60d23097ad39e7210b4132bb
        failing since 7 days (last pass: v4.14.236-20-gdb14655bb4bf, first =
fail: v4.14.236-49-gfd4c319f2583)

    2021-06-22T18:48:51.486057  /lava-4074206/1/../bin/lava-test-case
    2021-06-22T18:48:51.502226  [   17.146683] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-06-22T18:48:51.502640  /lava-4074206/1/../bin/lava-test-case   =

 =20
