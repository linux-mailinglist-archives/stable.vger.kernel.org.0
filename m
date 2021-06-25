Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A339B3B4674
	for <lists+stable@lfdr.de>; Fri, 25 Jun 2021 17:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhFYPUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Jun 2021 11:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhFYPUw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Jun 2021 11:20:52 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A87C061574
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 08:18:31 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id g21so6594691pfc.11
        for <stable@vger.kernel.org>; Fri, 25 Jun 2021 08:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=816v77VcPKJosLfTKCd6I4pMiKY606zdKKtbe9+8QzM=;
        b=V/Pt3MGdsJNMFHhdCin9jMUgk+wnlO8jHOKzaTdUsTPq+liorrhjNOYT1DY3JCyYqg
         mTQAIHdROEYaePfK1Rlk4ItYb/DpKDE2c3saBwn64ddd4kpNK3MovHGXPQDibpSn6dRL
         GqWDL7q0VdI5YA7xfEY8QBJLDVMD08z2VG0rRsmtQKMs+GAhj4AnbtUHw6HZj88dJ3NN
         1wNQnStT26qXCFs/oOWGJZbYLM1ySMkjvZMfrONuQVUdjpzkkqLpw69O2BaoZKz8qpOn
         6oUvSqh0otkgRz9HAUEzQ4yq9lzDX9Yw/L2DgOfAzF+FRl9g2tB1Ub0xlVGhAP64BE9i
         9waQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=816v77VcPKJosLfTKCd6I4pMiKY606zdKKtbe9+8QzM=;
        b=t5ypMln2oD7CRdlajRXOk4hKWDLiNTiOX/mbmRO/kgGlM4rjTdzObzsUMXytjGA870
         rqxEAao0K9+zMl44/e+cVYvttjACmW/qw1EJJaYUjLG4m/mF9/CWy49qqpg6xCYSfN8y
         JxNDyARSqxQjBWod825DOeLcPeAy/s0g+Qx40E9WAs0KkmgCKeKn8XG7rOLNSlOlQCO7
         KAsGtAGGZLehA8kMB6eBcSJoNYVA1l7ze8DOCC+N/YNkY5stYlh6f7YFq9Giqo5ey2Pw
         6B5emIQ87lTX9Cn6bTLMA2NkPLQr0PrBQmFPwED5KYg18LpAxprp9KGIl8alwNvsrMvj
         JGbw==
X-Gm-Message-State: AOAM530WjkzBm/d0/rOKTcaO6wyBaL/fM69Q5y/ziQpl2O5pf36I00A2
        TQP26TnTWf+vDouoyd88eroWHGST7kVGNeRM
X-Google-Smtp-Source: ABdhPJxBIHl5lgYHEpSiW98/16kOvAsTctUT/WcHYQMFrsYetR4NMPC84hevWwNqrh/+6HYC7CDPBQ==
X-Received: by 2002:a65:614d:: with SMTP id o13mr10066480pgv.351.1624634310738;
        Fri, 25 Jun 2021 08:18:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o72sm7153003pfg.102.2021.06.25.08.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 08:18:30 -0700 (PDT)
Message-ID: <60d5f3c6.1c69fb81.f4cd2.2aa2@mx.google.com>
Date:   Fri, 25 Jun 2021 08:18:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.46-12-g1088098ede9e
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 163 runs,
 3 regressions (v5.10.46-12-g1088098ede9e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 163 runs, 3 regressions (v5.10.46-12-g108809=
8ede9e)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.46-12-g1088098ede9e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.46-12-g1088098ede9e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1088098ede9e98b1ea19791047e5e8f220fe1287 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/60d5d39fa93f361230413274

  Results:     66 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.46-=
12-g1088098ede9e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.46-=
12-g1088098ede9e/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60d5d39fa93f361230413291
        failing since 10 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-06-25T13:01:10.369045  /lava-4094063/1/../bin/lava-test-case
    2021-06-25T13:01:10.374819  <8>[   11.234995] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60d5d39fa93f361230413292
        failing since 10 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-06-25T13:01:11.389233  /lava-4094063/1/../bin/lava-test-case
    2021-06-25T13:01:11.407345  <8>[   12.255127] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-06-25T13:01:11.408009  /lava-4094063/1/../bin/lava-test-case   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60d5d39fa93f3612304132aa
        failing since 10 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-06-25T13:01:12.812086  /lava-4094063/1/../bin/lava-test-case
    2021-06-25T13:01:12.828633  <8>[   13.678154] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =

 =20
