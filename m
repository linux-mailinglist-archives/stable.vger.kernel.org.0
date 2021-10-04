Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE732421964
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 23:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236539AbhJDVlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 17:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235167AbhJDVlu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 17:41:50 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39BFC061745
        for <stable@vger.kernel.org>; Mon,  4 Oct 2021 14:40:00 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id g184so17854491pgc.6
        for <stable@vger.kernel.org>; Mon, 04 Oct 2021 14:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=mLF5uBLKhVZOvSaRylWf/MeIqCdDm5efoEa08QGTh70=;
        b=pZeeHeUnnvTM5ak3O7PH+UOTpjR8aslvBWYEQnCSh8KON5AE10EeCHZJ+smlM+Yk5X
         eC19xsiwRvTLdgb+rFgmv1iM6Ya0GWWoqUQ9zfxKZiqSPv2Lx9sD3AMAU0/f3iavzH2C
         EzVgmz3db8YtqqkPIlJf6D478PzPSsyj5PYejZOHPyCQ4eh7sJq375PJqUSIf3PIMSw8
         dltsfsuGRoNgn2keOUOaMmvoedrJPXZuxBIUuiuQYWCN5aMxb/cXoOPQdN+TyGxz/d7/
         0XDlzur+VypmBdqHDhQDdVEznj2e+VlkjY4eb1L/+XnOHmv1Q+kT3ugQoj1l46OJpajU
         dIag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=mLF5uBLKhVZOvSaRylWf/MeIqCdDm5efoEa08QGTh70=;
        b=SzPeJJ+JfFhYnplG95n08zsPgaQ1mss3n9VDdHrqzPcsdd4vDN19CAiPMzifN3N9B2
         bq1mvTZrDN2G/33MDH6/Lg5ZFIfdGpyi8FednV+G/KlJviywgvWBanow8coJX//nCgbd
         0DJI2V/jUHqVa7rzR97Q1/VZ3WHILcDrPeiiTjvsLOSFq2x5S7TyYrjJVuwxswysvQ7d
         F4nCGGVcg7IIYY3KtEzx4gKsWJKmX/+vqkVSJMhHDmtCzKrqxJBrDp8LBsp/OCVr/n4F
         /JXGKzYy3nRbjscoEKKKPhtj93dH8Nlanssxn0GfQfXFpT+577C25BAE++kGqelknfCu
         folg==
X-Gm-Message-State: AOAM530hudMpFk+ck/nL5WCnbfhhryT3Cvv8bLszExVvRm6UO082xfNt
        C4khXRwWW/P+BspmFpsUwIfV3KpGU+o6F8SC
X-Google-Smtp-Source: ABdhPJyThF9Jq72j8r2+ge3rzcNk02RY1w5x9KSapK7sEyXmWVvw8ufh4TDUf+tcFIIN9vh3doywJw==
X-Received: by 2002:a63:4717:: with SMTP id u23mr12579060pga.359.1633383600072;
        Mon, 04 Oct 2021 14:40:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d15sm16276962pjw.4.2021.10.04.14.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 14:39:59 -0700 (PDT)
Message-ID: <615b74af.1c69fb81.61a42.f252@mx.google.com>
Date:   Mon, 04 Oct 2021 14:39:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.70-94-g02a774174b52
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 151 runs,
 5 regressions (v5.10.70-94-g02a774174b52)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 151 runs, 5 regressions (v5.10.70-94-g02a7=
74174b52)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.70-94-g02a774174b52/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.70-94-g02a774174b52
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      02a774174b52105372646c2f959d34ab45c726b2 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/615b408af5ae91c2d899a328

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
0-94-g02a774174b52/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
0-94-g02a774174b52/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b408af5ae91c2d899a=
329
        failing since 95 days (last pass: v5.10.46-101-ga41d5119dc1e, first=
 fail: v5.10.47) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/615b5f1e6f693dcfae99a311

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
0-94-g02a774174b52/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
0-94-g02a774174b52/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/615b5f1f6f693dcfae99a325
        failing since 111 days (last pass: v5.10.43, first fail: v5.10.43-1=
31-g3f05ff8b3370)

    2021-10-04T20:07:40.038666  /lava-4643081/1/../bin/lava-test-case
    2021-10-04T20:07:40.055761  <8>[   13.393852] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-10-04T20:07:40.056095  /lava-4643081/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/615b5f1f6f693dcfae99a33d
        failing since 111 days (last pass: v5.10.43, first fail: v5.10.43-1=
31-g3f05ff8b3370)

    2021-10-04T20:07:38.610770  /lava-4643081/1/../bin/lava-test-case
    2021-10-04T20:07:38.616006  <8>[   11.966424] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/615b5f1f6f693dcfae99a33e
        failing since 111 days (last pass: v5.10.43, first fail: v5.10.43-1=
31-g3f05ff8b3370)

    2021-10-04T20:07:37.591817  /lava-4643081/1/../bin/lava-test-case
    2021-10-04T20:07:37.597118  <8>[   10.946870] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/615b3e8e53091e8cb199a305

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
0-94-g02a774174b52/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
0-94-g02a774174b52/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615b3e8e53091e8cb199a=
306
        failing since 0 day (last pass: v5.10.65-55-g84286fd568e7, first fa=
il: v5.10.70-25-g94756d80f44e) =

 =20
