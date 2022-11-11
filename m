Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1650062525A
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 05:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiKKEWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 23:22:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231985AbiKKEWD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 23:22:03 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6402EF16
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 20:22:01 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id k15so3923510pfg.2
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 20:22:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=pV/G90Pexg246kSIDbtV6RWImPZ5W26B5/7ERIxStVY=;
        b=6vvqE8dvHcnUEQTXBi5eysNStJW8Cft7cPY9pNn83DbAbve8g3VdKQsB3VBvFZH5wN
         roWR2vVPtcLNh9nC9WzLhXpPsCpPCaYQU1n+WTCZYuMiwIG2nS5Eb+xvf9WYqxYjmvDI
         zd4qQ+6xaahBSgmuEcbj2D4SEV+p6zmi3H0nmBlDSJuG4HXC8soeP9QbRgnQkDU2zsKf
         08FWjFkkQWWedPh4bfiWrudGibd1ehxNzRDuPrGIqeyYsQ50HdUgsEu3e3ENp52W8aZc
         MwSjHxCMdoxF7BuvSVSGYKdoqEYhRVHXraqB72aAU4UNgQNLV/9Z50nEmdQylTVvGCJe
         Mo0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pV/G90Pexg246kSIDbtV6RWImPZ5W26B5/7ERIxStVY=;
        b=esIfZ7ZWn0WL505poG/Es2mlGFSRJyt2WAkj6TXgb4JKzwg8YbfsFWxleo1mQEiHxS
         Udf/6YCwSapJqkfuS8d0oBsuxUbZ4YaCyNqX/sNZW982YNovH6T9fXQCYULc+6Og0qdD
         XldiLU3C/p2XTKsxHbcoC9vOaqUUUZefYxub8oyColYYIfoF8DpYcNEnECIoytSUrR6u
         YZgD8v7puqmUEryyV7cjJ7DXYY8WKibnlGLCSb5SeS2fqv0Mbafv797+mBmwlrQTxQn4
         5+2rrU4U7e3WfIMSBr1GsjdIGncWsmCVNpTSG8j3KIYClpfrxKR+aOxFKs1G3uJXujZ9
         nz8g==
X-Gm-Message-State: ANoB5pmFCxPo9vXjyIqWoIddqfL5BBcgG4FACVsn/w8xCEOGAahzb2kr
        6YLZEw5SOWPlxBIRnSkZJVMubRPFVwnS/WDdpJE=
X-Google-Smtp-Source: AA0mqf6upsSoXiNl8/+d9ogV3rOahw5+cPKRnu7+0T3FCHGR1cwGC/kNNz39fHzlNNCHDOig52a2Hw==
X-Received: by 2002:a63:942:0:b0:43c:b43f:5228 with SMTP id 63-20020a630942000000b0043cb43f5228mr118782pgj.58.1668140520994;
        Thu, 10 Nov 2022 20:22:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y14-20020a17090a1f4e00b002135fdfa995sm3859679pjy.25.2022.11.10.20.22.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 20:22:00 -0800 (PST)
Message-ID: <636dcde8.170a0220.38638.6e5d@mx.google.com>
Date:   Thu, 10 Nov 2022 20:22:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.78
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.15.y baseline: 146 runs, 4 regressions (v5.15.78)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.15.y baseline: 146 runs, 4 regressions (v5.15.78)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
          | regressions
-------------------+-------+-----------------+----------+------------------=
----------+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defconf=
ig        | 1          =

imx7ulp-evk        | arm   | lab-nxp         | gcc-10   | imx_v6_v7_defconf=
ig        | 1          =

imx7ulp-evk        | arm   | lab-nxp         | gcc-10   | multi_v7_defconfi=
g         | 1          =

rk3399-gru-kevin   | arm64 | lab-collabora   | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.78/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.78
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      509a32764e1a5692935c4f26ed96fbe94c480186 =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
          | regressions
-------------------+-------+-----------------+----------+------------------=
----------+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defconf=
ig        | 1          =


  Details:     https://kernelci.org/test/plan/id/636dba9a1e2026f7fce7db78

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.78/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.78/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6ul-pico-hobbit.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636dba9a1e2026f7fce7d=
b79
        new failure (last pass: v5.15.67) =

 =



platform           | arch  | lab             | compiler | defconfig        =
          | regressions
-------------------+-------+-----------------+----------+------------------=
----------+------------
imx7ulp-evk        | arm   | lab-nxp         | gcc-10   | imx_v6_v7_defconf=
ig        | 1          =


  Details:     https://kernelci.org/test/plan/id/636d99dededd78212be7dbc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.78/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.78/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636d99dededd78212be7d=
bc4
        failing since 43 days (last pass: v5.15.67, first fail: v5.15.71) =

 =



platform           | arch  | lab             | compiler | defconfig        =
          | regressions
-------------------+-------+-----------------+----------+------------------=
----------+------------
imx7ulp-evk        | arm   | lab-nxp         | gcc-10   | multi_v7_defconfi=
g         | 1          =


  Details:     https://kernelci.org/test/plan/id/636d9b4235e7c750b4e7db82

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.78/a=
rm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.78/a=
rm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/636d9b4235e7c750b4e7d=
b83
        failing since 36 days (last pass: v5.15.70, first fail: v5.15.72) =

 =



platform           | arch  | lab             | compiler | defconfig        =
          | regressions
-------------------+-------+-----------------+----------+------------------=
----------+------------
rk3399-gru-kevin   | arm64 | lab-collabora   | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/636d9d9814394cac89e7db5c

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.78/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.78/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221024.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/636d9d9814394cac89e7db7e
        failing since 247 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-11-11T00:55:45.043311  <8>[   32.810896] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-11-11T00:55:46.071613  /lava-7939631/1/../bin/lava-test-case
    2022-11-11T00:55:46.083005  <8>[   33.850938] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
