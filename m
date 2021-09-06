Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCEB4020CD
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 22:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhIFU7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 16:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbhIFU7h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 16:59:37 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1606EC061575
        for <stable@vger.kernel.org>; Mon,  6 Sep 2021 13:58:32 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id n18so7819429pgm.12
        for <stable@vger.kernel.org>; Mon, 06 Sep 2021 13:58:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Z9tpPgBNssl7Ty1OiWoJzoO4GgkXESirnWbb/xLJXeU=;
        b=a3+AeOldIAhdrbSb3j7KDvso6p5lH5IdbicoJnCi2hCbNag62SDTM0iBbr5cK/D3Yk
         t4xu3bwZvKqSCyoKwNnsiw61fPofbYLEUQ+CqWf+SfMCAe6DUoZOPbDdkl3XneuIwxWv
         Y1a3BJ9dzLwPwLc2HjpCppDl3gRLrhZoZ4sG3QQvet2mETqkQcTp3/vjfKRP08c/sHd4
         9pL/4JW6fTvf9fcXs2aX4Ik9u6E2XDM+zgYp/rYyKkR/LgrSMLb1W4nvYbtl3d0W98Vo
         Htf9CkacKj2fX+RrpQCFeEz1hdSBRyvwDy8W7oy9Qx3AMAVuj8jrZG+9mRT7oakO899U
         L6pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Z9tpPgBNssl7Ty1OiWoJzoO4GgkXESirnWbb/xLJXeU=;
        b=qFHXOW1vL7MCOGcNM9Wa+aKnLHj6qtVOO0FDHEMqIUucUXeped04135Crs2tTF1img
         Lc4FIM29Tp0K6fWYHN/nFacCJDVDGrTww922W2KQvTo4jSoWpkuVv8+FEPqpRIsgAlDO
         FikSrRpmpfqD7IMc6HQCGHO7JZxEU9CFatfkR/Txn1s99zIFIASig+JIp+60cgqs6Nzj
         rzSCgc+TsLCeVAcE7mA+JekX8BTxR39Vwb1AYa+KmivtZ09FBCnXC9RKVmFXrr/9mfPb
         1aBrU3r9LAJxQ3I120ipbkBwv0JooHFoEpFtUdK3Kmn1+cU/N/q1EpFPH7DvWTRZmhow
         cfpQ==
X-Gm-Message-State: AOAM533WKx7Y+f2A1jOM5r+8UKPjl51fxlgyahOOK0C5gSxOWuLgw8/t
        5Vm80oYr1kQQzW9VI3xWmnkDMgkVb5/puYK+
X-Google-Smtp-Source: ABdhPJxgDFvBSBl5NE/0uCkVeuNfNU9rUwkcb1QsJwb5zIq0Z1YJiL+KE1nmMmq95KZng0AQ/+09/w==
X-Received: by 2002:a63:1c1e:: with SMTP id c30mr14021214pgc.352.1630961911325;
        Mon, 06 Sep 2021 13:58:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 15sm8416154pfu.192.2021.09.06.13.58.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 13:58:31 -0700 (PDT)
Message-ID: <613680f7.1c69fb81.85894.79c0@mx.google.com>
Date:   Mon, 06 Sep 2021 13:58:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.62-30-g49a2bcaf11be
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 194 runs,
 5 regressions (v5.10.62-30-g49a2bcaf11be)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 194 runs, 5 regressions (v5.10.62-30-g49a2=
bcaf11be)

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
nel/v5.10.62-30-g49a2bcaf11be/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.62-30-g49a2bcaf11be
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      49a2bcaf11be252cfbbd47ef9d1c3861b0a3ea95 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61364f86306890e7f9d59665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
2-30-g49a2bcaf11be/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
2-30-g49a2bcaf11be/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61364f86306890e7f9d59=
666
        failing since 67 days (last pass: v5.10.46-101-ga41d5119dc1e, first=
 fail: v5.10.47) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/6136607b414532c3fad596aa

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
2-30-g49a2bcaf11be/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
2-30-g49a2bcaf11be/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6136607b414532c3fad596be
        failing since 83 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-09-06T18:39:37.184904  /lava-4460043/1/../bin/lava-test-case
    2021-09-06T18:39:37.202292  <8>[   14.039764] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-06T18:39:37.202806  /lava-4460043/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6136607b414532c3fad596d6
        failing since 83 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-09-06T18:39:35.759119  /lava-4460043/1/../bin/lava-test-case
    2021-09-06T18:39:35.776565  <8>[   12.613687] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-06T18:39:35.776869  /lava-4460043/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6136607b414532c3fad596d7
        failing since 83 days (last pass: v5.10.43, first fail: v5.10.43-13=
1-g3f05ff8b3370)

    2021-09-06T18:39:34.739093  /lava-4460043/1/../bin/lava-test-case
    2021-09-06T18:39:34.744554  <8>[   11.594465] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61364a935be3320bc7d59681

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
2-30-g49a2bcaf11be/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
2-30-g49a2bcaf11be/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-ban=
anapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61364a935be3320bc7d59=
682
        new failure (last pass: v5.10.62) =

 =20
