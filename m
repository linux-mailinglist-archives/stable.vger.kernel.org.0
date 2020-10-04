Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E47D62827FF
	for <lists+stable@lfdr.de>; Sun,  4 Oct 2020 03:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgJDBoo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Oct 2020 21:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbgJDBoo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Oct 2020 21:44:44 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A25C0613D0
        for <stable@vger.kernel.org>; Sat,  3 Oct 2020 18:44:42 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id 144so4154242pfb.4
        for <stable@vger.kernel.org>; Sat, 03 Oct 2020 18:44:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AW5ZbAvgaVwa+s2YsHb/diEaSytAPnhG7SJ9a3N31Lk=;
        b=CeHjC6YrS26rVDd0RdAFh2sPRkfIwIaVExwNzEc6HvLf3tOnVVV1ALLR7bfh3AwPqa
         X4jiPzw4THqJ6+JMiVFYXUZVxpi42bvIqdPV2FDrJ3kFC2rbxYbMVwE2nwNesHEdLkIB
         Phk5/2EoO2S3cRvN1X4iZRbMBXX1thhiHioWpYlZUv3mQN9UOkd1NsPxVz0oByv+A+Ff
         3A1eVcgyTWjVBaUjsNlKqW1X8D/05gtZTJ0h1imByHk6L7FwOZgXi8wNcr2g5y82wPAF
         /GkhohM2gp95hDDkX669f2qc78d7WYAcH+Xw8t34roptnNCcfQVBvmDTRGq8ofOOyLQn
         AkwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AW5ZbAvgaVwa+s2YsHb/diEaSytAPnhG7SJ9a3N31Lk=;
        b=Mat/muTbcK5OYIrLrim6OZ/qNs75Nq9bvBF9ZwijtWsAEAcfwQPTOSF4tpEqMylVkU
         JiaMOepqw02iF1qILRlam8iYaHgjcGJOr4tqPT9/23Ydjix3byGtX0Qa0B8OGnmMOJzx
         op++rI/DkvhZmaGrxVBEm4hhJiZDcj4+Popt2tFVBOhIaYR5gFbScLknrxkqo6NoGzp2
         C8FVe3Y3mV//+DvyE81XY07ig+9PHh6qt/L26+O7DQtCnU0MZkyKhKZsXwubdxFb8Ryt
         jRg3iivwVckxJPQXT82KQgOaKTKRqUy4m7Giq6AIlLoPIgn4xhxXmSSjbbTSgUh0xjKx
         XMag==
X-Gm-Message-State: AOAM531zY+VAknCf364rpX8639xzoqhRtfsMkO4CMg1svGrH1JmD/ryc
        YNACADPIaQvVApXZaGZFm7TZeorrqmEK7g==
X-Google-Smtp-Source: ABdhPJyKsRWMqKfLHhB53eFz+ZsqN2JM2ZNlXO86zOJb0R2ii/O9rNzC3Tb06/QutDnmPRnAGqqFmw==
X-Received: by 2002:a62:5586:0:b029:13e:d13d:a12c with SMTP id j128-20020a6255860000b029013ed13da12cmr10166526pfb.20.1601775881539;
        Sat, 03 Oct 2020 18:44:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k14sm1371525pfu.163.2020.10.03.18.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2020 18:44:40 -0700 (PDT)
Message-ID: <5f792908.1c69fb81.bf375.33e9@mx.google.com>
Date:   Sat, 03 Oct 2020 18:44:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.69-5-gea934a0f6793
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 92 runs,
 3 regressions (v5.4.69-5-gea934a0f6793)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 92 runs, 3 regressions (v5.4.69-5-gea934a0f67=
93)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.69-5-gea934a0f6793/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.69-5-gea934a0f6793
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ea934a0f6793c0a7a3722d04ebf93fc51660a663 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig | results
-----------------+-------+---------------+----------+-----------+--------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-8    | defconfig | 85/90  =


  Details:     https://kernelci.org/test/plan/id/5f78f1364e5c8261f24ff408

  Results:     85 PASS, 5 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-5-=
gea934a0f6793/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevin=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.69-5-=
gea934a0f6793/arm64/defconfig/gcc-8/lab-collabora/baseline-rk3399-gru-kevin=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.bootrr.cros-ec-sensors-accel0-probed: https://kernelci.org/tes=
t/case/id/5f78f1364e5c8261f24ff41c
      failing since 4 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853) * baseline.bootrr.cros-ec-sensors-accel1-prob=
ed: https://kernelci.org/test/case/id/5f78f1364e5c8261f24ff41d
      failing since 4 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)

    2020-10-03 21:46:21.873000  /lava-2686471/1/../bin/lava-test-case
    2020-10-03 21:46:21.882000  <8>[   23.112721] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-accel1-probed RESULT=3Dfail>
     * baseline.bootrr.cros-ec-sensors-gyro0-probed: https://kernelci.org/t=
est/case/id/5f78f1364e5c8261f24ff41e
      failing since 4 days (last pass: v5.4.68-384-g856fa448539c, first fai=
l: v5.4.68-388-gcf92ab7a7853)

    2020-10-03 21:46:22.904000  <8>[   24.134793] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-sensors-gyro0-probed RESULT=3Dfail>
      =20
