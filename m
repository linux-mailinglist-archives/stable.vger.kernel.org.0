Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817F83E501B
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 01:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbhHIXri (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 19:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237065AbhHIXrh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 19:47:37 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D21F4C0613D3
        for <stable@vger.kernel.org>; Mon,  9 Aug 2021 16:47:16 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id u13-20020a17090abb0db0290177e1d9b3f7so1598063pjr.1
        for <stable@vger.kernel.org>; Mon, 09 Aug 2021 16:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YN4nVR4uDlFoo8ECrr5IFbgjCNNd5mR5UOnkF2jD0HM=;
        b=F9IoPu4kDlEqtgK/UnRGNGZXIZjNlYq55owhNUGdxZ0QlUdxfyrSHOUGVQVwXOUOZT
         hArB20YdX3TKuJw2wIHOe1cmSoWm+5mPZEwEu+pcojiLzB18ZnEgv8Lxa9e512kp6dlj
         4DlVXHYumggct03tvmlKxoC5rg5NT7CIxr1QKM1Sn2tvWaFOIYEtUgJo5DWEnY4FC+xv
         yeTcBGLwSX5taqi+iNg13GtGLzFtljsWag5utCa/MKpICsUzmiHLYYrSq2FkFFZNarp0
         08L7MAa0xEjioWv+42is8+IUeP/G2VxjsfP4b3caW8jsDq8p24BGmLGM5PVUIviRjYcL
         /Xcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YN4nVR4uDlFoo8ECrr5IFbgjCNNd5mR5UOnkF2jD0HM=;
        b=j90ZnX6v2M/rmtEhzHgu4XW0bz50yEjqTi6aIQvrsgvTotd47Dr7sfkMBypxANDDeU
         pj+OcJpLs42kBlppyhmVgE7Z8+ztI6Kv730FuN1XjX8Lmhs22n9bhiOBRl+pgaRrAyr5
         TxsMzWE1e98rlM/TeXFmy/HFTtqTHfqoJ4GA09bS/V4PKFTkVCdTEVNEh7OZkzX1bozT
         4TStnwcafC0u2cpgYEK5i+bfZng2EHU4Sjx+sU7SHW9It1IQ12GIRAg/iAb5Q+OIRLts
         it2DXXm+lwkXqEOIARdt9UrVx4yQZLebi1ba8Glr2sYGqghRX0wuu2VrsutolQSbmuZK
         GS2A==
X-Gm-Message-State: AOAM532QfeTfpROLIau7sSDuLGe4R/NEwP5pT787F/5V3ggEHa3+IfXD
        MPT8L097ZBik124HU1/TX4NTnrDhQDP5BxMN
X-Google-Smtp-Source: ABdhPJxr/PUhN4FplAbyfVv0w4ML6fFjnNhcgJy4OElPsGDxHjUO3X4YKBdO/mmB81YpnLKLD1Ui4Q==
X-Received: by 2002:a63:e23:: with SMTP id d35mr283473pgl.189.1628552836178;
        Mon, 09 Aug 2021 16:47:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j16sm22693525pfi.165.2021.08.09.16.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 16:47:15 -0700 (PDT)
Message-ID: <6111be83.1c69fb81.18560.1f5b@mx.google.com>
Date:   Mon, 09 Aug 2021 16:47:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.57-125-gb8eec9975ba1
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 163 runs,
 7 regressions (v5.10.57-125-gb8eec9975ba1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 163 runs, 7 regressions (v5.10.57-125-gb8eec=
9975ba1)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
      | regressions
------------------------+-------+---------------+----------+---------------=
------+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
      | 1          =

imx7d-sdb               | arm   | lab-nxp       | gcc-8    | imx_v6_v7_defc=
onfig | 1          =

imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig     =
      | 1          =

rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig  | 3          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.57-125-gb8eec9975ba1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.57-125-gb8eec9975ba1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b8eec9975ba1fb2f757819ccfc96b52b8adaaba4 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
      | regressions
------------------------+-------+---------------+----------+---------------=
------+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/61118c2461d13190d9b13662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
125-gb8eec9975ba1/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
125-gb8eec9975ba1/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61118c2461d13190d9b13=
663
        failing since 39 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                | arch  | lab           | compiler | defconfig     =
      | regressions
------------------------+-------+---------------+----------+---------------=
------+------------
imx7d-sdb               | arm   | lab-nxp       | gcc-8    | imx_v6_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/611186baed55967d15b13663

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
125-gb8eec9975ba1/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
125-gb8eec9975ba1/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611186baed55967d15b13=
664
        new failure (last pass: v5.10.57-49-g039efb5682ed) =

 =



platform                | arch  | lab           | compiler | defconfig     =
      | regressions
------------------------+-------+---------------+----------+---------------=
------+------------
imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/61118be21f05bc799fb1369b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
125-gb8eec9975ba1/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
125-gb8eec9975ba1/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61118be21f05bc799fb13=
69c
        new failure (last pass: v5.10.57-49-g039efb5682ed) =

 =



platform                | arch  | lab           | compiler | defconfig     =
      | regressions
------------------------+-------+---------------+----------+---------------=
------+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig  | 3          =


  Details:     https://kernelci.org/test/plan/id/61118854790f4200edb13688

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
125-gb8eec9975ba1/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
125-gb8eec9975ba1/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61118854790f4200edb136a0
        failing since 55 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-09T19:55:38.298691  /lava-4337455/1/../bin/lava-test-case
    2021-08-09T19:55:38.315793  <8>[   14.266648] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-09T19:55:38.316120  /lava-4337455/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61118854790f4200edb136b8
        failing since 55 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-09T19:55:36.871456  /lava-4337455/1/../bin/lava-test-case
    2021-08-09T19:55:36.890020  <8>[   12.840201] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-09T19:55:36.890350  /lava-4337455/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61118854790f4200edb136b9
        failing since 55 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-09T19:55:35.853082  /lava-4337455/1/../bin/lava-test-case
    2021-08-09T19:55:35.858434  <8>[   11.820787] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
      | regressions
------------------------+-------+---------------+----------+---------------=
------+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/61118ad07b00ffc630b1368c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
125-gb8eec9975ba1/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.57-=
125-gb8eec9975ba1/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61118ad07b00ffc630b13=
68d
        failing since 0 day (last pass: v5.10.56-30-gd7270c12d72c, first fa=
il: v5.10.57-49-g039efb5682ed) =

 =20
