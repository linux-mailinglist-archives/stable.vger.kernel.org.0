Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D823E5171
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 05:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236653AbhHJDXW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 23:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232741AbhHJDXW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 23:23:22 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F6EC0613D3
        for <stable@vger.kernel.org>; Mon,  9 Aug 2021 20:23:01 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id l11so7447232plk.6
        for <stable@vger.kernel.org>; Mon, 09 Aug 2021 20:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BWtD4MCl+FdeywGu2or6DFP0aa0Ev79/JLSYM6mOvCg=;
        b=NYpdzvNQisGyHCeKiffCPt5ribjjin7WL0jNpI+2BE2KOv+VVd+UUjO9ksbLPthdLf
         FAhdkHUt3JbBnT3ZDnab4aTSu05kSWpkOdAql/RgGZ+9K6GIzRFSOuoHL4E4RQnizseW
         Hm3tSAblB43RudsbOJeyzwSYQi7ojsUcfD+2y6MaykXwCfDjnWXxnByzcfaeZONsidJu
         +H+V2rWvWy8q/tnGN4cr8MOeLrJOweWirmDuz5w1/+V8lHoNL0X39KN2cRo7n+nA6eNq
         99g5pDCTi1mZ3uxWQAY21gSZ/N+9Nl2k8Jp3Taxh81QMkaeLNDUaSNl4R8f955+HLUXH
         QC7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BWtD4MCl+FdeywGu2or6DFP0aa0Ev79/JLSYM6mOvCg=;
        b=uC3jyzYyiCYLcvmRlGGN7UR9UQZFrocb3kjWD+xzv5E/P9f/qelQ7Z0abAuofrvwGI
         SSKzk4nYklux25WcE2RDicndsOg1gtt3Efy/MnoDI20oQDbmblm4swHrg/oFsDP3EJL5
         Z/1vfFaHPhvFY6c6SmmRkNXqjiwOB+ASpvaNvqqSGQWafWIeynbq3QoVtyLcg1LnTP34
         CwBwih0+GtFNYysUMg0JKYd6425dQuCHbDmPVObXGeU12ukiIONFPvFAy26E6p68Iuuw
         D5JjREcY9KSktLddiieKqssuhDSB/hA+7i4Vgkq8CaFsR0yOaDd/FU8gsoMvfxbCL5BY
         1zPg==
X-Gm-Message-State: AOAM533GNbWiPrxEliFtHBFlp9AdEOntKQD7ySfVpcObyhlI28if0nG5
        cRjkDYor50j9cWe6UjzpucdrqkX6hPM2inQ+
X-Google-Smtp-Source: ABdhPJwNpYpc6E8/duCUCz2bRiDF839NCBR38y94zEoEtgNyYOo323xPpy+etVCAJ0Q0iObxSfEQMw==
X-Received: by 2002:a17:902:aa82:b029:12c:6463:4880 with SMTP id d2-20020a170902aa82b029012c64634880mr23424003plr.65.1628565780322;
        Mon, 09 Aug 2021 20:23:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u13sm22012028pfn.94.2021.08.09.20.22.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 20:22:59 -0700 (PDT)
Message-ID: <6111f113.1c69fb81.80cbc.1969@mx.google.com>
Date:   Mon, 09 Aug 2021 20:22:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.139-77-g5403804dc9c6
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 171 runs,
 4 regressions (v5.4.139-77-g5403804dc9c6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 171 runs, 4 regressions (v5.4.139-77-g5403804=
dc9c6)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
imx6ull-14x14-evk | arm  | lab-nxp       | gcc-8    | imx_v6_v7_defconfig |=
 1          =

rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig  |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.139-77-g5403804dc9c6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.139-77-g5403804dc9c6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5403804dc9c6ce71f5b87adba66b10a2b5f83ce4 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
imx6ull-14x14-evk | arm  | lab-nxp       | gcc-8    | imx_v6_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6111ba0e7386db2466b13662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.139-7=
7-g5403804dc9c6/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ull-14x1=
4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.139-7=
7-g5403804dc9c6/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6ull-14x1=
4-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6111ba0e7386db2466b13=
663
        new failure (last pass: v5.4.139-77-g4d78737592e7) =

 =



platform          | arch | lab           | compiler | defconfig           |=
 regressions
------------------+------+---------------+----------+---------------------+=
------------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig  |=
 3          =


  Details:     https://kernelci.org/test/plan/id/6111bd453980196baeb13691

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.139-7=
7-g5403804dc9c6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.139-7=
7-g5403804dc9c6/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6111bd453980196baeb136a8
        failing since 55 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-09T23:41:30.464659  /lava-4339033/1/../bin/lava-test-case<8>[  =
 15.944863] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-08-09T23:41:30.464997  =

    2021-08-09T23:41:30.465193  /lava-4339033/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6111bd453980196baeb136c0
        failing since 55 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-09T23:41:29.022316  /lava-4339033/1/../bin/lava-test-case
    2021-08-09T23:41:29.040581  <8>[   14.520386] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-09T23:41:29.041226  /lava-4339033/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6111bd453980196baeb136c1
        failing since 55 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-09T23:41:28.002033  /lava-4339033/1/../bin/lava-test-case
    2021-08-09T23:41:28.008316  <8>[   13.500767] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
