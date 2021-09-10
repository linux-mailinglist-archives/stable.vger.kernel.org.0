Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1FFF40717B
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 20:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232193AbhIJSvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 14:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbhIJSvf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 14:51:35 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05C66C061574
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 11:50:24 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id v123so2651120pfb.11
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 11:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tPuSHr3h6hUM4qoK44/eUb75SdW9FZtuCeYLk12v3uU=;
        b=0RNMTmLJHLRy37odUjPrNAE02v1QYeWcLSHOa+clccrK4iTonmd8fshfErEhk8ACRy
         Czix3Tnwh7n8/grVJ7szUZ00xajkvPMRa3h22CxT42GxdbT0C5uzZayjAYL0HKw4tY3b
         NPkKrVlPOabxhs2/GMdV+qk0vjSHRHuR/rUyHtLO2+5Gw7usU330hobVF1GpEW/SPtJM
         NlVuLq0Iq3fadFQ3dCQbtcZJ3Q3g6QtQtFwCVnve6HZHAmPJ0zGm3b4KhzYqG4d4EA2d
         D3BFvwf9UkOdNdVGVklxCuHP8u7sUTo/hnmyV1Uxdn3cU4dasRSz/G2DQhmSlPR43L6Z
         XTzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tPuSHr3h6hUM4qoK44/eUb75SdW9FZtuCeYLk12v3uU=;
        b=rLnUHGt9lecAossmCg6fkPUSSmfnsFcIJI6C/8KE8H7ZklV0opW2g7dCBwOM8JXIfI
         x/rNwB+LpKuTbj/UcCL6OAkOgtBJs3bDGPiDu899vDCe4h7B/vgtIdPZ8V95bc6xNmfB
         fHRwQMLRoctwLb/mFwg+thfRa79691zt4GyRtBNUwl6kLctDthOCw7tZCL8hhU+Dr1zG
         UaRCo5NdqcKqYvk3aOC0gr4RCvuCndsq1Gvor+43YxZZOk7/534GZHenCtbqTTpSh+Z4
         JfYgad7FrAkyiDWPOpdDlMAvjvPwF2Sy5Vs3S7mAIRhAyC7EF+eKpL1REYIabDkHz5hz
         eBgg==
X-Gm-Message-State: AOAM5319/QrVhiBHMTLwPQQFVBUwl4P24qRf+HysxBumBQQ7fTDKoBPb
        Vi54q6vW3GCjAh7187LNUUBUnoMIsgstU3R9
X-Google-Smtp-Source: ABdhPJx43HMfVUG+80aWOdUG9/INDsDobR2dYc48QYAVsoMvkMf4SsKJD36C2QxgT0jvJl7kiF3kuw==
X-Received: by 2002:a05:6a00:16ca:b0:413:d3f7:646f with SMTP id l10-20020a056a0016ca00b00413d3f7646fmr9307016pfc.7.1631299823338;
        Fri, 10 Sep 2021 11:50:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x19sm6062400pgk.37.2021.09.10.11.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 11:50:23 -0700 (PDT)
Message-ID: <613ba8ef.1c69fb81.c5a9e.16a7@mx.google.com>
Date:   Fri, 10 Sep 2021 11:50:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.63-27-g750f802d2758
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 178 runs,
 6 regressions (v5.10.63-27-g750f802d2758)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 178 runs, 6 regressions (v5.10.63-27-g750f=
802d2758)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =

imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig     =
     | 1          =

rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.63-27-g750f802d2758/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.63-27-g750f802d2758
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      750f802d275892bf81c140338d6820d725399edc =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/613b7766b4f64ca227d596aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
3-27-g750f802d2758/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
3-27-g750f802d2758/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b7766b4f64ca227d59=
6ab
        failing since 70 days (last pass: v5.10.46-101-ga41d5119dc1e, first=
 fail: v5.10.47) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/613b78147a0ed157cdd59665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
3-27-g750f802d2758/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
3-27-g750f802d2758/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b78147a0ed157cdd59=
666
        new failure (last pass: v5.10.62-30-g49a2bcaf11be) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/613b918ff7ce09fef4d596db

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
3-27-g750f802d2758/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
3-27-g750f802d2758/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613b918ff7ce09fef4d596ef
        failing since 87 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-09-10T17:10:27.597900  /lava-4492423/1/../bin/lava-test-case
    2021-09-10T17:10:27.607558  <8>[   13.629795] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613b918ff7ce09fef4d59707
        failing since 87 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-09-10T17:10:26.181862  /lava-4492423/1/../bin/lava-test-case
    2021-09-10T17:10:26.200016  <8>[   12.206081] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-10T17:10:26.200545  /lava-4492423/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613b918ff7ce09fef4d59708
        failing since 87 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-09-10T17:10:25.168612  /lava-4492423/1/../bin/lava-test-case<8>[  =
 11.186769] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-09-10T17:10:25.169107     =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/613b77793f8e748264d59678

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
3-27-g750f802d2758/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
3-27-g750f802d2758/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613b77793f8e748264d59=
679
        failing since 3 days (last pass: v5.10.62, first fail: v5.10.62-30-=
g49a2bcaf11be) =

 =20
