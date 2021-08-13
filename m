Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E993EB358
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 11:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239223AbhHMJbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 05:31:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238980AbhHMJbm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Aug 2021 05:31:42 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04BE5C0617AD
        for <stable@vger.kernel.org>; Fri, 13 Aug 2021 02:31:15 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id n12so10472386plf.4
        for <stable@vger.kernel.org>; Fri, 13 Aug 2021 02:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=oVuSXez/GL6greWeJzQzt7g98qJPWiz9yMg7wPd9Aok=;
        b=zss6mEcHdV4GHpNOEHGXM95U1/B8PODF/56l3Rc2rvkh+uyEMEBB51xdMPyyyofV+n
         sWZH//kZBgE4OxfDMPDl7NTi9dXPWp06IuXXIMBiNNT7cf6sj9W4HWCs801hhO0MMQgi
         5iWr7hXN47UQk3QgtVPqlzW8dHWsr+jLw2ejkgAt6n/fZcDZe/qLxpnPPCPOj1EbT/ec
         kCt4tqv+NB01gasVbmg/lqTZfFhUkRbDVqzHGSEYGRCj/XAYYdhsETquXKXBnaMKIcUo
         DVWM8Fr6Biy6TiD+VDm6mM3HE7CNujNNC7YnRFNKTIg4Z9rFh/gDUqC4bOCGL44fZGuS
         JESQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=oVuSXez/GL6greWeJzQzt7g98qJPWiz9yMg7wPd9Aok=;
        b=CuJ+qjCALFQdNNEy4m6aWX+RF280oVtG/eKGWIgZOYMTC5xIKmBYgv+OfrSqu+5Xjm
         QBbJ8rrCoY2w7IkUESUa3/AxNWjj3MwcG/D0+dd+vK45zGWczlUGOgTQ+8U/mBezxhH6
         DZZOC295VhJS6p8n5g7f0mnG7KDPtDP1L9BWGujCdN/pdOvJ5XAo32g484z/caDW5/LU
         KM0CrSVuEWQ9Czz5N8WgtLxPM3uzOqSGCdzH7zq0/inbe19VkPGYIv7QjGde+huoElYG
         kJRwjqzV9dGvzAF93TTPo94FGtlhvrFIyxvKVKu7f4pSKtVH3QHYzvScOW1NueiYk2Fo
         bxTA==
X-Gm-Message-State: AOAM530A5yrJDWJ9we+1ZT+of+tlpHgZHhSEH1ulqjOPMgDqrFaFZnQO
        yBNfZ3eMyDXY0ckhDU5OwFXk6l6MwfXtO1sA
X-Google-Smtp-Source: ABdhPJzqW9ji7KhfQOTonjG/kZ5YHhdau24yFbxW4RYkCYU96bbACJmKMQDoOcWTb1f9bJ6w+tWw/g==
X-Received: by 2002:a05:6a00:1904:b029:3b9:e4ea:1f22 with SMTP id y4-20020a056a001904b02903b9e4ea1f22mr1635639pfi.79.1628847075405;
        Fri, 13 Aug 2021 02:31:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c17sm1335845pjq.16.2021.08.13.02.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Aug 2021 02:31:15 -0700 (PDT)
Message-ID: <61163be3.1c69fb81.fdf81.307f@mx.google.com>
Date:   Fri, 13 Aug 2021 02:31:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.10.58
X-Kernelci-Report-Type: test
Subject: stable/linux-5.10.y baseline: 180 runs, 6 regressions (v5.10.58)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 180 runs, 6 regressions (v5.10.58)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.58/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.58
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      132a8267adabd645476b542b3b132c1b91988fe8 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61160be2f659fa69d0b13765

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.58/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.58/a=
rm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61160be2f659fa69d0b13=
766
        failing since 36 days (last pass: v5.10.46, first fail: v5.10.48) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61160d11e430bc9731b13677

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.58/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.58/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61160d11e430bc9731b13=
678
        failing since 8 days (last pass: v5.10.54, first fail: v5.10.56) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/6116035fea308e234eb13690

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.58/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.58/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6116035fea308e234eb136a6
        failing since 57 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-08-13T05:29:50.811986  /lava-4356911/1/../bin/lava-test-case
    2021-08-13T05:29:50.829267  <8>[   13.487724] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-13T05:29:50.829494  /lava-4356911/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6116035fea308e234eb136be
        failing since 57 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-08-13T05:29:49.385907  /lava-4356911/1/../bin/lava-test-case
    2021-08-13T05:29:49.403204  <8>[   12.060531] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-13T05:29:49.403451  /lava-4356911/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6116035fea308e234eb136bf
        failing since 57 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-08-13T05:29:48.365341  /lava-4356911/1/../bin/lava-test-case
    2021-08-13T05:29:48.371009  <8>[   11.040780] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61160c09869ac55cdeb13665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.58/a=
rm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.58/a=
rm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61160c09869ac55cdeb13=
666
        new failure (last pass: v5.10.56) =

 =20
