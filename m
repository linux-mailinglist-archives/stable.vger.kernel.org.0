Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E214259AC
	for <lists+stable@lfdr.de>; Thu,  7 Oct 2021 19:40:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242882AbhJGRms (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 13:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242002AbhJGRmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 13:42:47 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD382C061570
        for <stable@vger.kernel.org>; Thu,  7 Oct 2021 10:40:53 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id w14so4433270pll.2
        for <stable@vger.kernel.org>; Thu, 07 Oct 2021 10:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=brfUFwvp5kkip+Hgg8v++IBcTvN5iCyFYX+5yCfZBUI=;
        b=DSla+qgmTBKXQrOOWdNEywT1qh6oCtpppIVx1nZn0nroV7hmkc3SeyS/IralnSS0aS
         pIkF9WqiColZ9+Iw88MJYQ1ycwPz8hauwoUyHY/9mOT9G42nQxgk9PzKX/EFMvWBi17P
         nAhlTEFZF8sTsi7sd9LY7GzsDh0WTS/V+se8gz5NakCmhJchdO7Jdbtsy5GmE1nzVLFi
         8h8wg3Zb6jhx1gQkrrRCIcz7pTlHZFarcQoNiRJpJdPy2u9URyTiX8RQRJdRfjFC5CHW
         j7SHm8413ABDIwSYxkJL9zMkBVp9Gd7BBSeTZEq/qjMoGPfptfmjMsifzASYSL35IFzM
         OCyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=brfUFwvp5kkip+Hgg8v++IBcTvN5iCyFYX+5yCfZBUI=;
        b=NeN8gec6wtD1IxkgIGLapHpPj7Dem3RiRdHru/YYYOVIdgdQwdqTnf/8BIys3zW04M
         BHtqUtrrr56mF1EppK9zXw5F6ESytEOX8BGDnt2T5QYg6XrtVYQB0LvqPl9oMBCCuRrL
         B5RbE5/g33DbzlKlXOaJN1DlV5AsDf4fjvC+lccKZoh46Byz5qfJWmJk3xN84WklTCPI
         2+yVsejUYt+ekNYq/6nx/TvcmZtwaE18GhXwHY6B5DQph9gSNZw+uegQ7zhlFUTdTJFR
         JrQ8YFyIc01QyT3Zo777IrcdtgQ/jJpowV4/GdzlGWT6M77MQkkHTlNj1iz9oMk5V1pk
         jGwA==
X-Gm-Message-State: AOAM532RwrX9Z8jYi4ETqqz3h2DkG2fRTlEvpgkFJwMQa/r1XLsexsa5
        kIasQHFStU7KUHUkTmg/xN2h4hktJ+fhZjwB
X-Google-Smtp-Source: ABdhPJzcKe1WpTbGXgbJ0f7SgAiiW9uFiw8kGrdKbxva/Uew2yC7sDJaX4VZVlLP04ViX5geM7WJQA==
X-Received: by 2002:a17:902:e80c:b0:13f:1140:8ab2 with SMTP id u12-20020a170902e80c00b0013f11408ab2mr346155plg.27.1633628453072;
        Thu, 07 Oct 2021 10:40:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o1sm92144pjs.52.2021.10.07.10.40.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 10:40:52 -0700 (PDT)
Message-ID: <615f3124.1c69fb81.13f15.0623@mx.google.com>
Date:   Thu, 07 Oct 2021 10:40:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.71
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 152 runs, 5 regressions (v5.10.71)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 152 runs, 5 regressions (v5.10.71)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =

imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.71/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.71
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5cd40b137cba45a5a3d0b9a8554f779a3e0e93b4 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
hip07-d05         | arm64 | lab-collabora | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/615eff66b34aef848999a37d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
1/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
1/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615eff66b34aef848999a=
37e
        failing since 97 days (last pass: v5.10.46-101-ga41d5119dc1e, first=
 fail: v5.10.47) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/615f005ff2257315d499a2ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
1/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
1/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615f005ff2257315d499a=
2eb
        failing since 2 days (last pass: v5.10.70-94-g02a774174b52, first f=
ail: v5.10.70-93-g76aee5dfd7ee) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/615f00c6cc41376d5199a2da

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
1/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.7=
1/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/615f00c6cc41376d5199a2ee
        failing since 114 days (last pass: v5.10.43, first fail: v5.10.43-1=
31-g3f05ff8b3370)

    2021-10-07T14:36:03.383350  /lava-4662856/1/../bin/lava-test-case
    2021-10-07T14:36:03.393096  <8>[   13.300320] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/615f00c7cc41376d5199a306
        failing since 114 days (last pass: v5.10.43, first fail: v5.10.43-1=
31-g3f05ff8b3370)

    2021-10-07T14:36:01.962043  /lava-4662856/1/../bin/lava-test-case
    2021-10-07T14:36:01.967343  <8>[   11.871091] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/615f00c7cc41376d5199a307
        failing since 114 days (last pass: v5.10.43, first fail: v5.10.43-1=
31-g3f05ff8b3370)

    2021-10-07T14:36:00.942262  /lava-4662856/1/../bin/lava-test-case
    2021-10-07T14:36:00.948275  <8>[   10.851262] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
