Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6112401CE4
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 16:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243120AbhIFOUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Sep 2021 10:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243107AbhIFOUn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Sep 2021 10:20:43 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DEAC061575
        for <stable@vger.kernel.org>; Mon,  6 Sep 2021 07:19:38 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id e7so6963693pgk.2
        for <stable@vger.kernel.org>; Mon, 06 Sep 2021 07:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rhxhHFP7JdlSa7EmPlnLqymqbuTBl10kzAX++pIVifw=;
        b=GHFkd98mY90kbR2hwqv8SuuICb0sfwZlATxrPuVTRXhDkptrGTeGoMg0MydKHGhPw5
         pUgux1IPDFWJLRCeeSYYUtt9gkYslY2SFIRfvdyekXSLdLv2hPmcCJxBLJVteMJkZjay
         2I7Q4jwoOhwBDSJP2u5dq+DuXpUPIx8XdiOObWfbn0V///96vZeualYiUrL5txTC9dG3
         NiwGIMj01QIhtH6AjbzY8eMfpLFF6pPDLxL78Uv+dAWZcgZnfvhctZssJvPi4xEdj0hs
         SWYC3rvvCeNtbzNUpwb3PLCvSRKJvR3Kg1Td1bFSh3If+ince9423pU6nHHe33P6Lojt
         cINA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rhxhHFP7JdlSa7EmPlnLqymqbuTBl10kzAX++pIVifw=;
        b=qPtjQaUEMOYGqvAgKQZAlfIznm0xQleoINMeULH7BuXrhACq4Ca3kyHoughspQKUgx
         4ZSDza5sAJzjQDU7l1vUEiOH+OUocYPTORQME5VhA3ow5iOzqhLkBYa4QoLtJpTILjtM
         GaUImsF7sVoHfJHSIM8aWVFg1nF719QN3vLCGRvaz7Q4xMJWdUoG2UcuaeBwdpWhqp4b
         5vAe1lnU1fVOpThMX28MpL8GZhqawFQ1cI/T9/cAMeCs4RIBiUsc8elKhpsykOCTpOdk
         mkghVqaxeNBclGGujQM/w1AllnMkRdsP9kQOJU9ErDPhtfP833JJ5n60avSXW21dj1j4
         Q1Yw==
X-Gm-Message-State: AOAM530u+ofmpHTEbSfAXx3mDRNxHyyMmceWIGKrG/EY733ArDp3BM9N
        kCeOEiE7slsLMl01ie7vS0UozmiySpQWPuDY
X-Google-Smtp-Source: ABdhPJwvWtbh68asNyjzREDK7Pr1zn/eko8NYhBlLDo+pk+cQxeT2CRnSCpK5GNMjvN0KVwo3lbmEQ==
X-Received: by 2002:a65:6643:: with SMTP id z3mr12719309pgv.16.1630937978128;
        Mon, 06 Sep 2021 07:19:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s200sm7961794pfs.89.2021.09.06.07.19.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 07:19:37 -0700 (PDT)
Message-ID: <61362379.1c69fb81.bc722.601c@mx.google.com>
Date:   Mon, 06 Sep 2021 07:19:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.62-29-gb20c77b1bdff
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 197 runs,
 6 regressions (v5.10.62-29-gb20c77b1bdff)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 197 runs, 6 regressions (v5.10.62-29-gb20c77=
b1bdff)

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
nel/v5.10.62-29-gb20c77b1bdff/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.62-29-gb20c77b1bdff
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b20c77b1bdffa918c3091ec740bad2536129cdc6 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6135f119d970d92d93d59720

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
29-gb20c77b1bdff/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
29-gb20c77b1bdff/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6135f119d970d92d93d59=
721
        failing since 66 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6135f0a0281d62f57dd59685

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
29-gb20c77b1bdff/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
29-gb20c77b1bdff/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6135f0a0281d62f57dd59=
686
        failing since 1 day (last pass: v5.10.62-8-g7b314af003ef, first fai=
l: v5.10.62-9-ge3bb5116f2af) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/6135f857bed19cd1f8d59687

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
29-gb20c77b1bdff/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
29-gb20c77b1bdff/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6135f857bed19cd1f8d5969b
        failing since 83 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-06T11:15:16.144574  /lava-4457288/1/../bin/lava-test-case
    2021-09-06T11:15:16.162529  <8>[   13.795801] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6135f857bed19cd1f8d596b3
        failing since 83 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-06T11:15:14.720294  /lava-4457288/1/../bin/lava-test-case
    2021-09-06T11:15:14.737511  <8>[   12.371323] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6135f857bed19cd1f8d596b4
        failing since 83 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-09-06T11:15:13.699523  /lava-4457288/1/../bin/lava-test-case
    2021-09-06T11:15:13.705046  <8>[   11.351892] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6135ef9ac4c386de50d59689

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
29-gb20c77b1bdff/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.62-=
29-gb20c77b1bdff/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6135ef9ac4c386de50d59=
68a
        failing since 1 day (last pass: v5.10.62-8-g7b314af003ef, first fai=
l: v5.10.62-9-ge3bb5116f2af) =

 =20
