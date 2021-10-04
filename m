Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E01E4205F1
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 08:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbhJDGps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 02:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232131AbhJDGps (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Oct 2021 02:45:48 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A604FC061745
        for <stable@vger.kernel.org>; Sun,  3 Oct 2021 23:43:59 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id 187so9224583pfc.10
        for <stable@vger.kernel.org>; Sun, 03 Oct 2021 23:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IcXL517oc239P6P/T3ME3cUz+lHVLT+7bx+mXxHOmJI=;
        b=z/SdRgawFws/TrFCgZbbJEyoqJc1BT9dHOrKQdePS6AjVZHQ2eYWC5YZtPY7M/9uy3
         ExmZ7wOHB8QSlO2CNmdYDzTvfxbZbbL4kBHUddP3EHCcRIxCF3Tj6xSpXVktMzXcsGkk
         Q6jqIfXUk4Z2uQkPeIiksk4NM7EQr3tq/UFru89bXxWhApkPhPrVe1cNTyboIWhh/REx
         g3SmUEvQEZah8P8gVR+HFYDzMzlW5p9jA6idh+ZwVeZBSAuC+o4sFE6Ce71V5GSArXzE
         bNFhWb0NYK0use56KHTExxJetyNheL9WThF1J+ryJ1ssqTkvxsQEotLW3edEMY364JkQ
         1rUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IcXL517oc239P6P/T3ME3cUz+lHVLT+7bx+mXxHOmJI=;
        b=CnV5loCffg1ggwqF8IZjvE8mxExvA33O9aOESxkb9XuJQRgZk9/SvI+y8ct/evRs+G
         xLqoYnOYLBC5UrXqiHyCNe/gFYLEArtnNrgah+RakD5JBHJRzW9h276q/HJakPOFjl95
         WxL+ZPpGvY/4Scs62Vq877WWZa3vgJvu+wVWhagBHbFTrPabRv3GQJtnXLsHzQMsA+rY
         EzXDjz8val1D9FwsExWXKSSTC3uiuF7phuNWNe8uQZ3OG9OCha7T2lMb02pHUPKv33vz
         4kvHW+HEE+/mbxQQpKw112U74tzI996bXrjtbXF1brVePkz92Qgc1ry1BEyrUUqw0Frs
         DHDQ==
X-Gm-Message-State: AOAM532YjBznT2tuD8j+jwCvy8h/IOldZ8kMxgjtlLJh4ZqtfGVVDTG/
        5aPHGtn+FkjVPWD4fMlaWklDktjsxrwjk7oE
X-Google-Smtp-Source: ABdhPJxO+Et0j3b8cvpRK+7Boi+E+v1c3RVAZaZxKG8DlTmBB1MUIJvH1o+QPEsVQbrv82zsHrFSiQ==
X-Received: by 2002:a05:6a00:2389:b0:44c:434:6c5d with SMTP id f9-20020a056a00238900b0044c04346c5dmr20070639pfc.29.1633329839073;
        Sun, 03 Oct 2021 23:43:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a5sm2825160pff.219.2021.10.03.23.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Oct 2021 23:43:58 -0700 (PDT)
Message-ID: <615aa2ae.1c69fb81.2fb14.7911@mx.google.com>
Date:   Sun, 03 Oct 2021 23:43:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.70-24-g9336e9d0c3ad
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 204 runs,
 5 regressions (v5.10.70-24-g9336e9d0c3ad)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 204 runs, 5 regressions (v5.10.70-24-g9336e9=
d0c3ad)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.70-24-g9336e9d0c3ad/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.70-24-g9336e9d0c3ad
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9336e9d0c3ad587f7810d2bdf26653f6d947b12f =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/615a6e1a2e5fac802d99a2ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.70-=
24-g9336e9d0c3ad/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.70-=
24-g9336e9d0c3ad/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615a6e1a2e5fac802d99a=
2ef
        failing since 94 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/615a7391ce72e8939c99a2da

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.70-=
24-g9336e9d0c3ad/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.70-=
24-g9336e9d0c3ad/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/615a7391ce72e8939c99a30c
        failing since 110 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-10-04T03:22:51.982996  /lava-4637413/1/../bin/lava-test-case
    2021-10-04T03:22:52.000842  <8>[   13.941431] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-10-04T03:22:52.001175  /lava-4637413/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/615a7391ce72e8939c99a310
        failing since 110 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-10-04T03:22:50.557202  /lava-4637413/1/../bin/lava-test-case
    2021-10-04T03:22:50.574368  <8>[   12.515295] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-10-04T03:22:50.574716  /lava-4637413/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/615a7391ce72e8939c99a311
        failing since 110 days (last pass: v5.10.43-44-g253317604975, first=
 fail: v5.10.43-130-g87b5f83f722c)

    2021-10-04T03:22:49.538677  /lava-4637413/1/../bin/lava-test-case
    2021-10-04T03:22:49.543951  <8>[   11.496046] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/615a6de1713563508899a2e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.70-=
24-g9336e9d0c3ad/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.70-=
24-g9336e9d0c3ad/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615a6de1713563508899a=
2e6
        failing since 20 days (last pass: v5.10.63-26-gfb6b5e198aab, first =
fail: v5.10.64-214-g93e17c2075d7) =

 =20
