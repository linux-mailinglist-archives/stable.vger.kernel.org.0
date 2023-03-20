Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB74C6C256C
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 00:06:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjCTXGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 19:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbjCTXGl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 19:06:41 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2EA837F3D
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 16:06:21 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id w4so6074269plg.9
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 16:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679353581;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=n3OANjnbAcfMU2TYDl/Z9cEXdjdE6JTDUfC01OlirNs=;
        b=5h9m4jNJcsxF5tA7nxwizUt8Y2bwuTNE1167yTxjxZVUjLf9JS1XCysnSwEImdyL4D
         H76IIdN7me9AeBj6mXbakUcG84inxEyvANxIy6IXkGJvBaT26rAxPXpUl5nLHgc+34YZ
         1MM4nNyXba/pFp9guQL0djsg2sOrtTVvzo3HGDdobiQphb9S+XuWPR5dZ4CAhbGf9Jk7
         hgaKGXOPmQhh6+D5Qq+YjDco/i5XFTLJ4P0AjjzdsBvNybg2V6ovon8m+/lN/Mo0A1tt
         B6QX09J7bdzjAMUGDqqF++QKr6KX1wIO77T03sr+nU4154m8ywMG/SVFS6eAB5tOY5fj
         TIJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679353581;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n3OANjnbAcfMU2TYDl/Z9cEXdjdE6JTDUfC01OlirNs=;
        b=BAGJtdLM2MTQYh8i8qKpUFTtkei1Ghxzykt0iVr6yvyOg1rX49SsGGhHHtbgdqnRnY
         F/u8Y/aTlJXFzOD+Hf/jNwiaYWwYvKj31pGfaWZZBEkHDhPUekMrmFB5UjeJfKW1c3yg
         wJ9y71QNwb3iOcVoLyuvf56gScS4QL8s3tjpHVu/d5MMhIOJzD5PmjHexbYKir+CgegB
         x2whJUcXbT8HcBu3V86ZbR7+M569SuX43EmzvN58rMR7N9u2KA81Ut3C/Em71rkww9G1
         8KIpos0ODpidRR+iVJLmGxViFRkH3vcs7fgTb+UkkmO5Yr9yTHLIxomhD3sEMX2RcZum
         jPRw==
X-Gm-Message-State: AO0yUKW884qyg4ohlLpZ5lA6dGAxcDmWJs6guWUY6wmAqcIxfiSJmio0
        waMsseIErCTv2V4yqrEV7ZVfC9JLIdeDQZIpG346wA==
X-Google-Smtp-Source: AK7set9qEyx+Q9fFvMkbI94E2DsWFiVXJARJ1XwDp5W/owzAdyzTKFZ2pL0d5yrJJk6x0D0o7LQumA==
X-Received: by 2002:a17:90b:1e0f:b0:23f:d7ea:6212 with SMTP id pg15-20020a17090b1e0f00b0023fd7ea6212mr189960pjb.38.1679353581013;
        Mon, 20 Mar 2023 16:06:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v10-20020a17090abb8a00b00234115a2221sm6553069pjr.39.2023.03.20.16.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 16:06:20 -0700 (PDT)
Message-ID: <6418e6ec.170a0220.40f10.b1d4@mx.google.com>
Date:   Mon, 20 Mar 2023 16:06:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.103-116-g3b6c0e954f41
Subject: stable-rc/queue/5.15 baseline: 155 runs,
 3 regressions (v5.15.103-116-g3b6c0e954f41)
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

stable-rc/queue/5.15 baseline: 155 runs, 3 regressions (v5.15.103-116-g3b6c=
0e954f41)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig          |=
 regressions
-------------------+-------+--------------+----------+--------------------+=
------------
cubietruck         | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig |=
 1          =

kontron-pitx-imx8m | arm64 | lab-kontron  | gcc-10   | defconfig          |=
 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.103-116-g3b6c0e954f41/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.103-116-g3b6c0e954f41
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3b6c0e954f41522d1738c062ba0def9fc01f8b2b =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig          |=
 regressions
-------------------+-------+--------------+----------+--------------------+=
------------
cubietruck         | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6418b1c9778af43bb68c8637

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.103=
-116-g3b6c0e954f41/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.103=
-116-g3b6c0e954f41/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6418b1c9778af43bb68c8640
        failing since 62 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-03-20T19:19:15.276577  <8>[   10.071191] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3430141_1.5.2.4.1>
    2023-03-20T19:19:15.386903  / # #
    2023-03-20T19:19:15.490683  export SHELL=3D/bin/sh
    2023-03-20T19:19:15.491668  #
    2023-03-20T19:19:15.593855  / # export SHELL=3D/bin/sh. /lava-3430141/e=
nvironment
    2023-03-20T19:19:15.594920  =

    2023-03-20T19:19:15.697269  / # . /lava-3430141/environment/lava-343014=
1/bin/lava-test-runner /lava-3430141/1
    2023-03-20T19:19:15.699220  =

    2023-03-20T19:19:15.704286  / # /lava-3430141/bin/lava-test-runner /lav=
a-3430141/1
    2023-03-20T19:19:15.790087  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform           | arch  | lab          | compiler | defconfig          |=
 regressions
-------------------+-------+--------------+----------+--------------------+=
------------
kontron-pitx-imx8m | arm64 | lab-kontron  | gcc-10   | defconfig          |=
 2          =


  Details:     https://kernelci.org/test/plan/id/6418ae3b851ca9e4d28c866d

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.103=
-116-g3b6c0e954f41/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx=
-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.103=
-116-g3b6c0e954f41/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx=
-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6418ae3b851ca9e4d28c8674
        new failure (last pass: v5.15.102-136-gf9d511e739be6)

    2023-03-20T19:04:20.915176  / # #
    2023-03-20T19:04:21.016836  export SHELL=3D/bin/sh
    2023-03-20T19:04:21.017181  #
    2023-03-20T19:04:21.118073  / # export SHELL=3D/bin/sh. /lava-299464/en=
vironment
    2023-03-20T19:04:21.118296  =

    2023-03-20T19:04:21.219290  / # . /lava-299464/environment/lava-299464/=
bin/lava-test-runner /lava-299464/1
    2023-03-20T19:04:21.219690  =

    2023-03-20T19:04:21.228676  / # /lava-299464/bin/lava-test-runner /lava=
-299464/1
    2023-03-20T19:04:21.284614  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-20T19:04:21.284819  + cd /l<8>[   12.132794] <LAVA_SIGNAL_START=
RUN 1_bootrr 299464_1.5.2.4.5> =

    ... (10 line(s) more)  =


  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/641=
8ae3b851ca9e4d28c8684
        new failure (last pass: v5.15.102-136-gf9d511e739be6)

    2023-03-20T19:04:23.604647  /lava-299464/1/../bin/lava-test-case
    2023-03-20T19:04:23.605044  <8>[   14.547016] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2023-03-20T19:04:23.605175  /lava-299464/1/../bin/lava-test-case   =

 =20
