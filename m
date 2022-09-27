Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF86F5EC5A2
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 16:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbiI0OMw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 10:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbiI0OMu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 10:12:50 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85181BA398
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 07:12:49 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id q15-20020a17090a304f00b002002ac83485so10241339pjl.0
        for <stable@vger.kernel.org>; Tue, 27 Sep 2022 07:12:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=KH/SJvBhob2KGs8mRkI0IcYBvFn/5wHMzpO5Icip9pU=;
        b=yRf1Kvq1vCt9ohcuCCoR7fCJHxZvaX8tV8Nbjvg7iS4vS9gT8Ouoi6/+qjgzgmB10c
         e+POcdBrzBrj5BC5HSGX6+24cyYlz1hFbrT+u4ZAni19EQCdkYmgb64tUG4EBTz7ACW2
         gyxNubBlH/ehqHW73DKooctVLxrSLp+Qyhe18z5v9Xf1JgRAe6FZMa13obc2u44tLjp7
         bk9ncZLnAIHyI+DtP5EviskL3/VgO3DY8ItryXPrPmSHMb5qKLyTYsEVY4aQzjE+QBAh
         TMLLw5Nl49P0ra6jhQUt2gsmGTijAsPg+0q68ayt4A9Uqn0D62XecDDsTC2LIuwsfEQM
         w1sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=KH/SJvBhob2KGs8mRkI0IcYBvFn/5wHMzpO5Icip9pU=;
        b=BswdlVFpNwMAUZsUbPWmYWBuvbo0jsDoluolqCvQsiD2YdStQ1mjTDaMoXXwBMyz6h
         tnfrZs7ass8WFdSbI+tTXixH2ekbMt5TixdYcSMA2tb3Cj+Q4TLf8TrslKpEFY9tB/b4
         Qkyd4lCZazHI08sBgGVHYRVxcqTaU+0JcuEm/SMy/j2Fpvzr7ZIcxz3/ObEvqKTsFcj1
         ZDSuV5H5+anl96Fxe1eSeyMimlQoEy3CBEkvf/y1hYypNCnryanxcmrKn/8G5k8Wth7K
         d7bYr5Z7ilYBvOIj0hlpS+lD5h0YrmYMLgdJMd8JxnArplAjA1GznJ70AvlULZWru+lT
         Hr8g==
X-Gm-Message-State: ACrzQf0u9HWD1JK86qYcZuXW3DSlYUVWePBbAYjiMRC41tk408GzE8mc
        8Vam+9kDAoNqLSwRIgTvUNeol2fI9bXqK8zT
X-Google-Smtp-Source: AMsMyM5KffHM/fSA59NvJFkb8m7hy1pmHSTLsVX0G6OOwSB5p7kEoLVZu3IpNabPt+86mmM1k7x46g==
X-Received: by 2002:a17:90b:128b:b0:203:73b7:2f33 with SMTP id fw11-20020a17090b128b00b0020373b72f33mr4827370pjb.106.1664287969050;
        Tue, 27 Sep 2022 07:12:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i3-20020a17090332c300b00176c37f513dsm1532757plr.130.2022.09.27.07.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 07:12:48 -0700 (PDT)
Message-ID: <633304e0.170a0220.92f9a.25a0@mx.google.com>
Date:   Tue, 27 Sep 2022 07:12:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.70-142-gf38e88261ee1
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 146 runs,
 2 regressions (v5.15.70-142-gf38e88261ee1)
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

stable-rc/queue/5.15 baseline: 146 runs, 2 regressions (v5.15.70-142-gf38e8=
8261ee1)

Regressions Summary
-------------------

platform           | arch  | lab         | compiler | defconfig           |=
 regressions
-------------------+-------+-------------+----------+---------------------+=
------------
imx7ulp-evk        | arm   | lab-nxp     | gcc-10   | imx_v6_v7_defconfig |=
 1          =

kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig           |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.70-142-gf38e88261ee1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.70-142-gf38e88261ee1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f38e88261ee112924d0540ccb38063cfba5cc157 =



Test Regressions
---------------- =



platform           | arch  | lab         | compiler | defconfig           |=
 regressions
-------------------+-------+-------------+----------+---------------------+=
------------
imx7ulp-evk        | arm   | lab-nxp     | gcc-10   | imx_v6_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6332d7465eb2cef384ec4eaf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
142-gf38e88261ee1/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
142-gf38e88261ee1/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6332d7465eb2cef384ec4=
eb0
        failing since 1 day (last pass: v5.15.70-117-g5ae36aa8ead6e, first =
fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform           | arch  | lab         | compiler | defconfig           |=
 regressions
-------------------+-------+-------------+----------+---------------------+=
------------
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig           |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6332d3b289d4d496e0ec4eab

  Results:     51 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
142-gf38e88261ee1/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-=
imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.70-=
142-gf38e88261ee1/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-=
imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/633=
2d3b289d4d496e0ec4ec2
        new failure (last pass: v5.15.70-142-gf9f566b0cbd5)

    2022-09-27T10:42:39.465322  /lava-174379/1/../bin/lava-test-case
    2022-09-27T10:42:39.466010  <8>[   14.553839] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2022-09-27T10:42:39.466328  /lava-174379/1/../bin/lava-test-case
    2022-09-27T10:42:39.466583  <8>[   14.573428] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy-driver-present RESULT=3Dpass>
    2022-09-27T10:42:39.466834  /lava-174379/1/../bin/lava-test-case
    2022-09-27T10:42:39.467080  <8>[   14.594498] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy0-probed RESULT=3Dpass>
    2022-09-27T10:42:39.467324  /lava-174379/1/../bin/lava-test-case   =

 =20
