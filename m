Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95BC53DF418
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 19:51:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238396AbhHCRvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 13:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238316AbhHCRvU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 13:51:20 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ECFEC06175F
        for <stable@vger.kernel.org>; Tue,  3 Aug 2021 10:51:08 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id nh14so18903509pjb.2
        for <stable@vger.kernel.org>; Tue, 03 Aug 2021 10:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=t0dS792FKIZgoNCbH3DPbnI8hL4zCqEhuI4WBzavYW8=;
        b=ytg1P4sBz+qR2+xj6+AtMGijBdTjB7DAneN3tslo7SnPpI42U0fAyG8Ppe/G8wTTEp
         KI9IM61RgT7NE11VGzaypPx1yVsHHiwU8uvmwNQry9CehgZ9DqvGnt2kj2E9BDDXxvhr
         C1hcnS5NAmR9yCJd1GMYNELz489LoCClJQR+ygm62aiZXUh9OFF12yV1NChRbLpOHMFL
         bileUKdpfOI/otLubxtySmWwkDFrGwz5gVL6BoMyggMd0O18y69gcGWAGttva/yAJPaV
         /EohjNMidJduFLpBGHSRwgZoEJhDHcJY9b1WtVVs8KoGprXXH3RfGKB8oN1zDbtnUPjT
         95hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=t0dS792FKIZgoNCbH3DPbnI8hL4zCqEhuI4WBzavYW8=;
        b=HbqRf2wrbeULFT/nt6aXza5sTvDz8IYIvDMkHRdH+5Qaw1jUp39Y4+HqWl6o5WJDJq
         YB4Pq9rixsw1/GXtQ46rdS1DYBZ+OsciGNjLLZ7hcjysIj2Oru+raBP5ge1G7+fNqhmy
         /5Cyss3LdBVGo6/G8UmDszfPSTzerokGtRLFt80770r1QP3JikkqhhsUBfwRBiSaakAd
         nY/6Ilcaad3lYXqWf7no4VtyLsUqA9V6IanTc0uegBpmy9l80/fmMcIoML0tJoIjkO56
         VlN0pfYP2O530nu9fpplgk2dzajDXDgUey8cVp70gGILoHpb8Xu38xtSgl1JFmgbtT4o
         2gkQ==
X-Gm-Message-State: AOAM533Jbe+Hm3H/+e5hGUPOaW1SetI1GoAFLNaaZX8r6J3Flf4pTRaK
        xjLB11nZ4hsh5s4lEzsOdrPfDEQ/OIlrWdl/
X-Google-Smtp-Source: ABdhPJwnJVBpx8Yg9Z3EzoJsTOTw4lmI9HE3YPIU3ujqWlJ6LY6CfJNAedxjwI+GAXlxr4peYfDOvg==
X-Received: by 2002:a65:6107:: with SMTP id z7mr471963pgu.43.1628013067450;
        Tue, 03 Aug 2021 10:51:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k3sm16581965pfc.16.2021.08.03.10.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 10:51:07 -0700 (PDT)
Message-ID: <6109820b.1c69fb81.b0f9b.0208@mx.google.com>
Date:   Tue, 03 Aug 2021 10:51:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.137-4-g2645f0d8ddfb
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 187 runs,
 3 regressions (v5.4.137-4-g2645f0d8ddfb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 187 runs, 3 regressions (v5.4.137-4-g2645f0d8=
ddfb)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.137-4-g2645f0d8ddfb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.137-4-g2645f0d8ddfb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2645f0d8ddfb64be3876d60794747bf45b13ed56 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/610955064ebdf7e619b136d5

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.137-4=
-g2645f0d8ddfb/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-v=
eyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.137-4=
-g2645f0d8ddfb/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-v=
eyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/610955064ebdf7e619b136ed
        failing since 49 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-03T14:38:45.274318  /lava-4317958/1/../bin/lava-test-case
    2021-08-03T14:38:45.291352  <8>[   15.272102] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/610955064ebdf7e619b13702
        failing since 49 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-03T14:38:43.866780  /lava-4317958/1/../bin/lava-test-case<8>[  =
 13.846882] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-08-03T14:38:43.867380  =

    2021-08-03T14:38:43.867763  /lava-4317958/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/610955064ebdf7e619b13703
        failing since 49 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-03T14:38:42.829390  /lava-4317958/1/../bin/lava-test-case
    2021-08-03T14:38:42.834757  <8>[   12.827280] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
