Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8BFF3C698D
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 06:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbhGMFBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 01:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbhGMFBD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Jul 2021 01:01:03 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A08C0613DD
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 21:58:14 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id w15so20534560pgk.13
        for <stable@vger.kernel.org>; Mon, 12 Jul 2021 21:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pFlJ0Cp+Q2cvPxYJQCUh5U0OZaa8LxCA1V3tctpsOrk=;
        b=hgq10UVo33y/qGjKk0b51SfNxPuHD1f37QSxPzyN9NWSDAgaynJU4qCIpv2BSedYNE
         ou6+CY1iym+4T0iQMi0/YklT47f9HFUD8y6FvfnTXp1OYIaKri9nDawUXGqYM9+yTzcU
         LDBAWSZI2AX50oWaoImSWG0W3KF/zk5lMYSTqVnhoWt3fBq1Kj1Mg2zYnHdD4BecyBo9
         e0ibJd0g/+zTj6BDH9NqCuTf24/EVaL0JwmDceUuhWUpqhL44MsV1MsLfiMlDj69rQTV
         7CNpsXzbfTRCM3nJRdAPB7mJ4InS5eD5/tjuk6Cj2+UgQdNkJQoGHXbNE6V+hGskBgNV
         8DoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pFlJ0Cp+Q2cvPxYJQCUh5U0OZaa8LxCA1V3tctpsOrk=;
        b=RZL89+/8MkJfqs+pQeDarlTHWU+cxHYnnxW81xg76ceO6QGVYEtxQ+IPIXNtDOof+K
         ByxFWorHQKTf+g4AJw4paRsVvVhqGPpEWisbCYs+WAhGtkApoSN3IOaWfmDannEbD++T
         QHd/gJNPha/fPbgyMo+/ke2IhtQ+Vf7xqaqYdFRlFeRaHs4TQrkC/kR+NIxD9Zp8Sd07
         YRsX1Uli6vMvWxBSjmGLr8TN1tq48fm5Ee4POtGMjJ4G84JoRXEYx7/GlE9OFU9Iy8sO
         ld9Wl6GULQH1U4ER7Qgf6v9KAeiCiCHbe13mCVzGrEllfVRe/xCRCXzJAIj0SsurR9LF
         Gyxg==
X-Gm-Message-State: AOAM533qfXcRLBvTekqVdyqL6S9m1Sa7/4tNuumStaRdSGk1Hia5k/8d
        F5pT6npPIwEdXgrek5ZO+dbQNp54uKXocjFV
X-Google-Smtp-Source: ABdhPJx11E0+A/JeRZdTFMMycE+C/ACVgs91AA7UPYHy+ppcUCHjEM1UQZRG7OmdDJaf2NE7EpXzHg==
X-Received: by 2002:a63:582:: with SMTP id 124mr2519242pgf.299.1626152293636;
        Mon, 12 Jul 2021 21:58:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z15sm19631304pgu.71.2021.07.12.21.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 21:58:13 -0700 (PDT)
Message-ID: <60ed1d65.1c69fb81.1cad6.c87a@mx.google.com>
Date:   Mon, 12 Jul 2021 21:58:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.131-349-g6063b14ea179
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 189 runs,
 4 regressions (v5.4.131-349-g6063b14ea179)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 189 runs, 4 regressions (v5.4.131-349-g6063b1=
4ea179)

Regressions Summary
-------------------

platform          | arch   | lab           | compiler | defconfig          =
| regressions
------------------+--------+---------------+----------+--------------------=
+------------
d2500cc           | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig   =
| 1          =

rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.131-349-g6063b14ea179/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.131-349-g6063b14ea179
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6063b14ea1792d78a25e5236a15b3d853e43b24e =



Test Regressions
---------------- =



platform          | arch   | lab           | compiler | defconfig          =
| regressions
------------------+--------+---------------+----------+--------------------=
+------------
d2500cc           | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig   =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60eceaadbf0a3e602e11796b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.131-3=
49-g6063b14ea179/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.131-3=
49-g6063b14ea179/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eceaadbf0a3e602e117=
96c
        failing since 1 day (last pass: v5.4.130-4-g2151dbfa7bb2, first fai=
l: v5.4.131-344-g7da707277666) =

 =



platform          | arch   | lab           | compiler | defconfig          =
| regressions
------------------+--------+---------------+----------+--------------------=
+------------
rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:     https://kernelci.org/test/plan/id/60ed13013c33cd32a9117970

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.131-3=
49-g6063b14ea179/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.131-3=
49-g6063b14ea179/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ed13013c33cd32a9117988
        failing since 28 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-13T04:13:38.276708  /lava-4188147/1/../bin/lava-test-case
    2021-07-13T04:13:38.294083  <8>[   15.660408] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-07-13T04:13:38.294349  /lava-4188147/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ed13013c33cd32a911799e
        failing since 28 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-13T04:13:36.851976  /lava-4188147/1/../bin/lava-test-case
    2021-07-13T04:13:36.870061  <8>[   14.235189] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-07-13T04:13:36.870332  /lava-4188147/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ed13013c33cd32a911799f
        failing since 28 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-13T04:13:35.838818  /lava-4188147/1/../bin/lava-test-case<8>[  =
 13.215931] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-07-13T04:13:35.839135     =

 =20
