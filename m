Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF783F13E8
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 08:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231766AbhHSG65 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 02:58:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbhHSG64 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 02:58:56 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5677C061575
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 23:58:20 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id mq2-20020a17090b3802b0290178911d298bso4113929pjb.1
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 23:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ax/6ybQiX8tcTMx7gJLllvcCnpuCwk4+97LaMeBpJQQ=;
        b=kprajZchB2mB8enKezFqU1X9YjgQ5fYe/onTBI3WngVuwVNz0Etm0d/d7EEKgo9iyg
         /+k5HujGML/FecIvBBILTok9UKDaiyKapEoJIsOzkouFxBnwd2ldLZAwqhKjvdO8hIIN
         M6ScrdL2ywETCl4rf4Z/5lzFazWzHN0Yag2XokEM8JCCGxqb/mnmetegp1PZczdhZgUe
         JBQ9fq8DntUIV6OvsLInQC2NePG6dsCj5ZIUMjDJANzfweAT+9VqsoHRQSB96mzw4vVf
         GL/H3PDUIO959euaawjGjlnQqOr5ZN86L1Hfa9jmbmG9CDuR1UW/4zvstrflz/gHe8vs
         KoCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ax/6ybQiX8tcTMx7gJLllvcCnpuCwk4+97LaMeBpJQQ=;
        b=KysqhPsJnzTv1hd2wwALg4sGhsB1+9EtQ5RFUCp+uBkFVKH8o3Fa4Sish61BXS3VE7
         YKRp2YMHOqqzQeL94AxmY0YsBTir9jps6MOizke2YMM43wqnYRxP3Ix8StmSErG8jvHV
         la5gUiVidXfVBzhyKNRzfgA8DnzJB080+MRMNN/7YwEzh02mHRXFe71IfRE/Tx0CcOHr
         pKO2Vy8T0HFGEUZD8D0p/8tuEiNkId+8btAgF9kSqm5GPKs3SHGBTOLy2XgIlls/ef04
         ajUsPwRmKYxyqw0AZj6aM3tQBKLL0TgfTFE7cJSE37ikOzRMOQNHMTvXA2gl4nUzF6dc
         xyxw==
X-Gm-Message-State: AOAM53347taBcNR9g2v3iM2WhycRl4ZnK1h5nHQtkptqVP91BIapSQ7w
        tLfkh8XL3IGFOeDnFv8uA4mNljMM5qTRZnTS
X-Google-Smtp-Source: ABdhPJxgLNZhsbRruXvHeiCRmEP+6CJTguo4tVymz9623saCt//4ZoLuuhC+nHsYsDFG8zvAVJTFhQ==
X-Received: by 2002:a17:902:ec8c:b0:12f:6548:4b45 with SMTP id x12-20020a170902ec8c00b0012f65484b45mr5055047plg.73.1629356300338;
        Wed, 18 Aug 2021 23:58:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 2sm2102719pfe.37.2021.08.18.23.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 23:58:20 -0700 (PDT)
Message-ID: <611e010c.1c69fb81.51de1.7c29@mx.google.com>
Date:   Wed, 18 Aug 2021 23:58:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.60-16-gf85f5640f8cf
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 159 runs,
 6 regressions (v5.10.60-16-gf85f5640f8cf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 159 runs, 6 regressions (v5.10.60-16-gf85f56=
40f8cf)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.60-16-gf85f5640f8cf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.60-16-gf85f5640f8cf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f85f5640f8cfe609a6312278bea6fd823942633e =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/611dd52791920ad79eb136da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
16-gf85f5640f8cf/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
16-gf85f5640f8cf/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611dd52791920ad79eb13=
6db
        failing since 48 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/611dcd9a04c30638b7b1367e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
16-gf85f5640f8cf/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
16-gf85f5640f8cf/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611dcd9a04c30638b7b13=
67f
        new failure (last pass: v5.10.60-6-gd64177941ad6) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/611dda25a695186f91b13661

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
16-gf85f5640f8cf/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
16-gf85f5640f8cf/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611dda25a695186f91b13679
        failing since 64 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-19T04:12:03.266192  /lava-4383081/1/../bin/lava-test-case
    2021-08-19T04:12:03.274981  <8>[   13.298372] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611dda25a695186f91b13691
        failing since 64 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-19T04:12:01.846200  /lava-4383081/1/../bin/lava-test-case
    2021-08-19T04:12:01.863884  <8>[   11.871445] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611dda25a695186f91b13692
        failing since 64 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-08-19T04:12:00.825908  /lava-4383081/1/../bin/lava-test-case
    2021-08-19T04:12:00.832079  <8>[   10.851647] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/611dcd16361a4a42ddb136cb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
16-gf85f5640f8cf/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.60-=
16-gf85f5640f8cf/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/611dcd16361a4a42ddb13=
6cc
        failing since 2 days (last pass: v5.10.59-96-ge4ba0182192d, first f=
ail: v5.10.59-96-g07687e3e26bf) =

 =20
