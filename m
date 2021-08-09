Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D40A3E4FED
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 01:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236260AbhHIXGe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 19:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236248AbhHIXGd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 19:06:33 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB60BC0613D3
        for <stable@vger.kernel.org>; Mon,  9 Aug 2021 16:06:12 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id fa24-20020a17090af0d8b0290178bfa69d97so2494593pjb.0
        for <stable@vger.kernel.org>; Mon, 09 Aug 2021 16:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ofg4K/Ue5w4TI030yJ4VtIiPKSoYdLXtDpP0vlpRqqM=;
        b=Wx3gT8AlH2ppWi5O6r+qjkBqytNOcnQwLmssEFpg7xl0CcsFzZr+OePuGs/GmD3oRB
         5adYCWJAj6z0YNtLA90G6Nl0O8Us1nr1MLNKn9ZSA/wCno+XNYo3siju3Y3rvIQBRQnC
         0b3akU64XHsj3f8l9wsV6i96jq8FtPPHb93XHfFhFzn5+5gQDRR6DHJWJvjlfyy8OL2T
         mXbi/gieSuShXnvKC17rEUVAB5rTg7Pisk0/wEZu0E2yi/CDFOJ5SnvAX5bgaf/OjDOn
         ccDQKuBMd0hGeyc+5gI+IqSgDTysDYo6f3M/0g8szZj0+6FsVghD5AmJuay2+FNWm63I
         s6qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ofg4K/Ue5w4TI030yJ4VtIiPKSoYdLXtDpP0vlpRqqM=;
        b=cfmOqMO7TumLe73DRdfmUhfmtkHJIq0HZgoivDGsAIeD/q7qaC6/5PbsBIqdHQbI5m
         DHTxmv6Q6KoN7yAO/AmR+ADOJkvEPkkNj23IrT+xfqlqhA2ncJABr2SlG5/rhB/GUkFy
         xJ5ztt2HHrbrelLOr9TB56UsxLeX3sEl68cMzglBl5/n8EHBgjEtHVBbz38785hNtOT7
         Ys5kjh+HBXo/I438D+vFXdVvVnuv5uhgrwmzLKEDsOevLIOPXK0L9s9dbWWDMpyMua9Z
         4EKIuQvShvL2X36aW533J9rXXkcZvTaxp8WJtjA6gntSwLENZ+l9ijw5aV1mZ8TVGPpk
         58nA==
X-Gm-Message-State: AOAM531YAYZMPIWnuzBmv0FW6FXHzSxgESxP07CqgXdXuTi0MofeauhI
        9VbpNVWSktWZk1tB7Ts9UxAat1zFz80KZmQR
X-Google-Smtp-Source: ABdhPJxzodXnBFQPhja/OU7YPgPT+v3be9mQFE87iH7CJyszUJhPIYYa9g6KX9IHDF0euzRt3i1IZg==
X-Received: by 2002:a65:62da:: with SMTP id m26mr82099pgv.370.1628550372334;
        Mon, 09 Aug 2021 16:06:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j77sm17892323pfd.64.2021.08.09.16.06.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:06:12 -0700 (PDT)
Message-ID: <6111b4e4.1c69fb81.bbacd.3b1e@mx.google.com>
Date:   Mon, 09 Aug 2021 16:06:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.139-77-g4d78737592e7
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 166 runs,
 5 regressions (v5.4.139-77-g4d78737592e7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 166 runs, 5 regressions (v5.4.139-77-g4d78737=
592e7)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
imx6sx-sdb        | arm  | lab-nxp       | gcc-8    | multi_v7_defconfig | =
1          =

imx6ull-14x14-evk | arm  | lab-nxp       | gcc-8    | multi_v7_defconfig | =
1          =

rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.139-77-g4d78737592e7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.139-77-g4d78737592e7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4d78737592e7e7fd65f5ab10c37fc01358df4bd8 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
imx6sx-sdb        | arm  | lab-nxp       | gcc-8    | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/61118192fb5942d616b13661

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.139-7=
7-g4d78737592e7/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sx-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.139-7=
7-g4d78737592e7/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sx-sdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61118192fb5942d616b13=
662
        new failure (last pass: v5.4.139-33-g5cd216325856) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
imx6ull-14x14-evk | arm  | lab-nxp       | gcc-8    | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/61118373a61428ed04b1368a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.139-7=
7-g4d78737592e7/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ull-14x14=
-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.139-7=
7-g4d78737592e7/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ull-14x14=
-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61118373a61428ed04b13=
68b
        new failure (last pass: v5.4.138-23-gd308e0e9e54e) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/61117ed72e641a2119b13675

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.139-7=
7-g4d78737592e7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.139-7=
7-g4d78737592e7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61117ed72e641a2119b1368d
        failing since 55 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-09T19:15:25.014807  /lava-4337281/1/../bin/lava-test-case
    2021-08-09T19:15:25.015272  <8>[   15.325556] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61117ed72e641a2119b136a5
        failing since 55 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-09T19:15:23.587821  /lava-4337281/1/../bin/lava-test-case
    2021-08-09T19:15:23.592779  <8>[   13.900665] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61117ed72e641a2119b136a6
        failing since 55 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-09T19:15:22.574711  /lava-4337281/1/../bin/lava-test-case<8>[  =
 12.881233] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-08-09T19:15:22.575269     =

 =20
