Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8EFA3AA21A
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 19:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhFPRHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 13:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbhFPRHN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 13:07:13 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6FC8C061574
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 10:05:06 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id s14so2694491pfd.9
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 10:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jttC4kNSDIyRx5BUBKkd+kru0KzOYAr1lpiTvxWfs2Y=;
        b=bhCi6iEs9c9zx1RPwtsfkElrHcGqLmwIp/y54iVutBmiHqHT2fyyRiSkA24uOhivlC
         u55SMWYNbNjRYNAwbS/LrS5hGmUCLoXLds38zkyd8b438mNOOjYQvYba144Db6nYA+ax
         VotIIiTJHdQnhr39pVzI+9z0zmkpm/QY6YGIyE2pLyjSssygzDYsEBN//p7XR8FWMz4V
         AndOeuX7T9Xir8xv4+cqGo3htt3u8+eJyMpavZYHw+LBqkjbSIXfYC4/cn1pcILWtKzO
         OV0Rx48SRMiMYzOkKNdUJAakT9tjR0LfZPoVpjtPmHnFIL26rgDhwQeSKmg0ZXrKYqTg
         2gcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jttC4kNSDIyRx5BUBKkd+kru0KzOYAr1lpiTvxWfs2Y=;
        b=JPwpxay2Hhqmw09ZX8OUwojvWNyXTAm2QWYUtpyMWH2zEGS9p//R5ey9oq4M8ZlxFa
         SOH7dMOCffSNX0Qawn7QsiTJPhF/SeuRoPqurReXrek4Wxl3BMSaAc2P1j9oX2xYe+E4
         m8T10nMOgPaM7yFqu6cLfDLnTSVQlLz9SqTcB6ielTe2yAfjZys9J4p7T47nBs9lirr0
         W3zSu1uCc02aJS1GSOZ6NMc+gOkGTOi3QV11KdEyohVcG18caT7TzU97ZrRmPHEn9E3r
         aIla/o9GJcGiOtD0gkLA7Xaqq++D3IMcQEXgmLcripI681GvsKkmJmL3IajIwq2urARO
         9+mw==
X-Gm-Message-State: AOAM5335b3qTR9JazI/P3ZAiTxjDytNrR3+1JnBWJgKWfm2pzqFwjxnW
        EYodsLMxvZk4BY3BxZ86frE7zvVF0uNOej7h
X-Google-Smtp-Source: ABdhPJxEn/dkvmIGX0jZ454Z6ayK8YapbfmiBmMLaqrhckiOC8QBLO+OmxUF3vyx4G4cGXmEeaeM5g==
X-Received: by 2002:a63:6642:: with SMTP id a63mr554182pgc.241.1623863106214;
        Wed, 16 Jun 2021 10:05:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nv1sm2683734pjb.43.2021.06.16.10.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 10:05:05 -0700 (PDT)
Message-ID: <60ca2f41.1c69fb81.dcde3.7375@mx.google.com>
Date:   Wed, 16 Jun 2021 10:05:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.44
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.10.y baseline: 150 runs, 4 regressions (v5.10.44)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 150 runs, 4 regressions (v5.10.44)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.44/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.44
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      f2b1fc360fa1283b61359f232c6965f4170260f0 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60c9fd1d48b9348f2041328a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.44/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.44/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9fd1d48b9348f20413=
28b
        failing since 18 days (last pass: v5.10.40, first fail: v5.10.41) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60ca2d770afb45adf4413289

  Results:     66 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.44/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.44/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60ca2d770afb45adf44132a6
        new failure (last pass: v5.10.43)

    2021-06-16T16:57:20.129984  /lava-4036786/1/../bin/lava-test-case<8>[  =
 13.862466] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-06-16T16:57:20.130646     =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60ca2d770afb45adf44132a7
        new failure (last pass: v5.10.43)

    2021-06-16T16:57:21.143824  /lava-4036786/1/../bin/lava-test-case
    2021-06-16T16:57:21.161782  <8>[   14.882158] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60ca2d770afb45adf44132bf
        new failure (last pass: v5.10.43)

    2021-06-16T16:57:22.572653  /lava-4036786/1/../bin/lava-test-case
    2021-06-16T16:57:22.589103  <8>[   16.310923] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-06-16T16:57:22.589592  /lava-4036786/1/../bin/lava-test-case   =

 =20
