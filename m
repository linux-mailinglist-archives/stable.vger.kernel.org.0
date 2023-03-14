Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8251D6B8903
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 04:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjCNDhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 23:37:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjCNDhS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 23:37:18 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D1E64855
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 20:37:16 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id i3so15219953plg.6
        for <stable@vger.kernel.org>; Mon, 13 Mar 2023 20:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678765036;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=1nQclPPHB9RnGd/3nSeCEXLyfPtHt3kvyDyfgMyhpRg=;
        b=ztgLEvyAiOzwFaxaRYFWEStmjWfuQ3Z18gV79pdblRBvBWa7FYw6cfR755SYHJ2Kom
         6333O+sWNDZIWtJATJTGSQyGqhHLeJqx2Oml0Zxtu6tkYuwYHdH7f7vIjG/qdOHBiVZC
         FMOOEnfR+h2L8SkHfOHSMd1oOd/0zkeEZj4mPJ3JYR0kzNQbx6Gfbd4L2WqHiSuW2pIG
         N7UkIQc4TJEPn9+JWqTC34q2OjSmPDtRS5f0rjSmHMrqhZDDSLwjjNvD7RIsknjnMoID
         xmSNElJWHUawzi2msXiU+R4sVokOxEceho9YBJ2u1jD8rYhdAMhBqcEclWEB4nFlaYg3
         fpSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678765036;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1nQclPPHB9RnGd/3nSeCEXLyfPtHt3kvyDyfgMyhpRg=;
        b=yn0hHJl+ywS768n5RhjtKeTJutmxU1LVi+JJ8c+s3Mn9YxGlfVB5dLVozp3SOLzyM+
         ygncu8G079M0m1RYm5T3RtSdKq8KHRNse4l4YNTD9zm0m8ve2FBeOYqhbpu+JpWFVpMz
         StMn/PxCNIhpi/NNYkQmf8l94OEJoRd/XBDCWRyFhy+72v9OUJPBRsC1pJaEGuOVMEjb
         /NQtBQwxwfyGyqLPGnJXD9JH6hlMkWwl/JKZt+pY1imHKkHiwid7AXepcyH1mVhD7kG1
         eEUu/au9IO2mnzrRWzy7hzP23FfS9PKHH/zbUqks+x9idRniRyAorIlEYBXeL/dACFcX
         LmUw==
X-Gm-Message-State: AO0yUKVm/G0bH9ilHqH1caBFvtwG0MSJ6AhtcjbupX/Ntd/TnUFBEHtO
        92VMzXaYLQsI79GQsvFgbwFZl09bTgMCC0KenaM9W9Qo
X-Google-Smtp-Source: AK7set/IM/LUdTHi/G2l8G/Ddx4HW2F9uu5MX9QwjsJ7xuY6AKAd33dnZlRtcTeAFkFjRVh6zqbHxw==
X-Received: by 2002:a17:902:d4cd:b0:19a:70f9:affb with SMTP id o13-20020a170902d4cd00b0019a70f9affbmr43698430plg.2.1678765036188;
        Mon, 13 Mar 2023 20:37:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id kc6-20020a17090333c600b001943d58268csm584603plb.55.2023.03.13.20.37.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 20:37:15 -0700 (PDT)
Message-ID: <640febeb.170a0220.37941.2515@mx.google.com>
Date:   Mon, 13 Mar 2023 20:37:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v6.1.19
X-Kernelci-Report-Type: test
Subject: stable/linux-6.1.y baseline: 186 runs, 2 regressions (v6.1.19)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-6.1.y baseline: 186 runs, 2 regressions (v6.1.19)

Regressions Summary
-------------------

platform           | arch  | lab         | compiler | defconfig | regressio=
ns
-------------------+-------+-------------+----------+-----------+----------=
--
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig | 2        =
  =


  Details:  https://kernelci.org/test/job/stable/branch/linux-6.1.y/kernel/=
v6.1.19/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-6.1.y
  Describe: v6.1.19
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      6449a0ba6843fe70523eeb7855984054f36f6d24 =



Test Regressions
---------------- =



platform           | arch  | lab         | compiler | defconfig | regressio=
ns
-------------------+-------+-------------+----------+-----------+----------=
--
kontron-pitx-imx8m | arm64 | lab-kontron | gcc-10   | defconfig | 2        =
  =


  Details:     https://kernelci.org/test/plan/id/640fb961bc6387ab418c8646

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.19/arm=
64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.19/arm=
64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640fb961bc6387ab418c864d
        new failure (last pass: v6.1.18)

    2023-03-14T00:01:14.849131  / # #
    2023-03-14T00:01:14.951200  export SHELL=3D/bin/sh
    2023-03-14T00:01:14.951682  #
    2023-03-14T00:01:15.053146  / # export SHELL=3D/bin/sh. /lava-294116/en=
vironment
    2023-03-14T00:01:15.053584  =

    2023-03-14T00:01:15.155085  / # . /lava-294116/environment/lava-294116/=
bin/lava-test-runner /lava-294116/1
    2023-03-14T00:01:15.155807  =

    2023-03-14T00:01:15.160850  / # /lava-294116/bin/lava-test-runner /lava=
-294116/1
    2023-03-14T00:01:15.224724  + export 'TESTRUN_ID=3D1_bootrr'
    2023-03-14T00:01:15.225025  + cd /l<8>[   14.482980] <LAVA_SIGNAL_START=
RUN 1_bootrr 294116_1.5.2.4.5> =

    ... (10 line(s) more)  =


  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/640=
fb961bc6387ab418c865d
        new failure (last pass: v6.1.18)

    2023-03-14T00:01:17.572863  /lava-294116/1/../bin/lava-test-case
    2023-03-14T00:01:17.573232  <8>[   16.925249] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>   =

 =20
