Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B60453F5B2E
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 11:39:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235785AbhHXJkf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 05:40:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235566AbhHXJke (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 05:40:34 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9608C061757
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 02:39:50 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id y23so19230356pgi.7
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 02:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ucgIqn/7W8JsJl0uaHVh2mHT1bVutyd529H3njhked8=;
        b=G4YJDFKSLH5GfUWHLz1Y2bKIcjPag3PLuKSAMA27LYdfGvzEQJ8cFk5duuzpHo4LoH
         fnCJzfzRJNxC+PMltqDYpRIxxCU0nnBcqw5lgp63hnek/cT+pBc6ruXVHbGNEHDfl7u1
         W0J6b9/RY4YfJo2qIOrHBpYykzOyEiGlb4nAhHld9l/VMxs92B0RGOWub4BXVLS9ugZX
         65JZ7DZHIOT0sgKBVlPhxHEU/v2MP/vq4ZQ16n/cY1ZL3nTRTdw+N31TFL+K8XCltdZM
         wO30jPUg9oN47vxxFoVcRvyrtsibcQxgLOm2ffOVb689zKZUrTpOK/n2M9vwXlPzC66E
         pOoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ucgIqn/7W8JsJl0uaHVh2mHT1bVutyd529H3njhked8=;
        b=loBJYMlTMjnIh8DEGyo8NNGZL+KJtQdFgDE3ObdRvUFq7RXY6CIq1bao7fvB/Giy2L
         FZ0Y3XjSwJ2FUpvQKGqEb2zCqkVLgu1FgCzrtFemPAa/2PQTGqZgEBAOQ937ZX2Djup/
         I+UG3PFdtCzctL7+AXB7VwonKb0PXPS7rs4qbuRKclvibyG27mrR1pV6JPWe9/+/ME2s
         gaD0zDqJwy3ms+11v/zbDBTvsprEEGNlg5gxVCew2kEF0NaOPZTn//ggk4p5WhaBu5Fk
         pl74kOnzgQRcMVQBoV/tiAg3MXHVtLpbQh9UjwP/+EpvvWe85N+zcePVUzbd/akmVWhA
         aEbQ==
X-Gm-Message-State: AOAM53289gH9dHJwZ19bfS5Ab2IylILxG1n054jYtDZYLkjpIx3AF4BB
        6ujPyZp9XMqrQxn2ViS59v/GGLahTDuiTPa6
X-Google-Smtp-Source: ABdhPJw18eWLdnG3x33UYOG71uWufFWvc2fiEwlY1CC0gmNpHziidpDULSB1X7ZeIHCTFORMOzUzFw==
X-Received: by 2002:aa7:8f11:0:b0:3eb:47a6:551c with SMTP id x17-20020aa78f11000000b003eb47a6551cmr5628654pfr.41.1629797990138;
        Tue, 24 Aug 2021 02:39:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id pj14sm1731457pjb.35.2021.08.24.02.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 02:39:49 -0700 (PDT)
Message-ID: <6124be65.1c69fb81.87583.4af0@mx.google.com>
Date:   Tue, 24 Aug 2021 02:39:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.142-59-g66a4d33479a3
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 174 runs,
 3 regressions (v5.4.142-59-g66a4d33479a3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 174 runs, 3 regressions (v5.4.142-59-g66a4d33=
479a3)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.142-59-g66a4d33479a3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.142-59-g66a4d33479a3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      66a4d33479a32a6ac52f0360489a7c0c59988fd0 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/61248bb2db5ba1181f8e2ca8

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.142-5=
9-g66a4d33479a3/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.142-5=
9-g66a4d33479a3/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61248bb2db5ba1181f8e2cbc
        failing since 70 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-24T06:03:15.364958  /lava-4404662/1/../bin/lava-test-case
    2021-08-24T06:03:15.380621  <8>[   15.644677] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61248bb3db5ba1181f8e2cd4
        failing since 70 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-24T06:03:13.957430  /lava-4404662/1/../bin/lava-test-case<8>[  =
 14.220003] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-08-24T06:03:13.957778  =

    2021-08-24T06:03:13.957973  /lava-4404662/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61248bb3db5ba1181f8e2cd5
        failing since 70 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-24T06:03:12.920104  /lava-4404662/1/../bin/lava-test-case
    2021-08-24T06:03:12.925688  <8>[   13.200473] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
