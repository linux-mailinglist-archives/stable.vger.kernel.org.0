Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A97E240400E
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 22:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349654AbhIHUBj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 16:01:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343558AbhIHUBh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 16:01:37 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B5AC061575
        for <stable@vger.kernel.org>; Wed,  8 Sep 2021 13:00:29 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id n18so3743785pgm.12
        for <stable@vger.kernel.org>; Wed, 08 Sep 2021 13:00:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gI8BNZJHbcnq2HUKj1asm1wIOwiEIy1pTw3Fq2NjtI8=;
        b=mdBB8ZK+OdggUxZZ+eOeL37WKA4AFdNHSwJc+KcOplW1xAaqUW4rU5gpkN8N1GkUmP
         QZ5YWj9UX1DQShrg94ty5yWQEHaE94QCKta3Rx5ISvT9ez3tl3T1p25TqqNSOt11GjxR
         FHpfDemyPjFRT+axHaOP6sJmabCHNzCV3jI2vw2OgsTykXldomeheWLsz4ahvtmYZCP/
         OH7zGQjzD+YvvXC3M4QSY82Ilebz+O+dINzGN2wVUTGUSmDhVuCenCgIeEfB/e0j9cSv
         3DeTMjwvoTYkyJx+uABrgLql1co6UtzPbHBBq0B1exgLjjq045auk/khnVH1txbh6SKU
         GbbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gI8BNZJHbcnq2HUKj1asm1wIOwiEIy1pTw3Fq2NjtI8=;
        b=eMzQgUgDsWRLV17yjCQZxIF2+Ol17n6YCAUP45S3O+fL9mFxVyUHqguLqiCUHwq5LR
         HJf8xp7e7aYJAimFR6Bo4sNySf/mwv3ehlpnLPDAIsmZCC0Yfqd9QhD9QMkqybOVqtmi
         4LlePmyIC91YGQFq43BMBl1pOLqe1xUsZ9FGYyoup1Y+9m0BMFMz1nS07tMpl5Nr9Qzp
         Gk+dHH1wrQSGCzKUC/x/pwbhSfZR0YmqXAThY95LmQNge4P5mVA8VSR9SqhkXRUsuNEP
         oDl94Uf1doo4nfjHkMUhRdARiQAarKB71lMdNklIlowQsIeWZHdxL7eEsD11Fr5Ua2tw
         bNCw==
X-Gm-Message-State: AOAM530IklwNHfu6fI6xbbtqlEYYkN9R061aMcYH/AAa+yZOfeNeN99k
        /Ajx0GHo3R2YjXG8eQXPut/8YI6egw6KnuTo
X-Google-Smtp-Source: ABdhPJyDJ0qXfUeMhnoUMpH6xYA/L00dKABPZ/BciYd8/0rsJUYBZPe+JpIRCBWDnlvbpG8QZB6bUA==
X-Received: by 2002:a05:6a00:d4f:b0:407:8c1c:76c2 with SMTP id n15-20020a056a000d4f00b004078c1c76c2mr5346077pfv.31.1631131228330;
        Wed, 08 Sep 2021 13:00:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x9sm2965068pjf.52.2021.09.08.13.00.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 13:00:28 -0700 (PDT)
Message-ID: <6139165c.1c69fb81.1fe05.8d20@mx.google.com>
Date:   Wed, 08 Sep 2021 13:00:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.144-29-g1dfceaaf9acf
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 197 runs,
 3 regressions (v5.4.144-29-g1dfceaaf9acf)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 197 runs, 3 regressions (v5.4.144-29-g1dfceaa=
f9acf)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.144-29-g1dfceaaf9acf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.144-29-g1dfceaaf9acf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1dfceaaf9acf69797f44ac9a998589cf23a6aa66 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/613906d702d1b6ab10d59665

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.144-2=
9-g1dfceaaf9acf/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.144-2=
9-g1dfceaaf9acf/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613906d702d1b6ab10d59679
        failing since 85 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-08T18:54:01.890176  /lava-4478011/1/../bin/lava-test-case<8>[  =
 15.343769] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-09-08T18:54:01.890855     =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613906d702d1b6ab10d59691
        failing since 85 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-08T18:54:00.459668  /lava-4478011/1/../bin/lava-test-case
    2021-09-08T18:54:00.477439  <8>[   13.918771] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-08T18:54:00.478035  /lava-4478011/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613906d702d1b6ab10d59692
        failing since 85 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-08T18:53:59.445751  /lava-4478011/1/../bin/lava-test-case<8>[  =
 12.899290] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-09-08T18:53:59.446100     =

 =20
