Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B525406B5E
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:26:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbhIJM1u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:27:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232876AbhIJM1t (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 08:27:49 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC35BC061574
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 05:26:38 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id e7so1664003pgk.2
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 05:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KqXjH7gwFMCzi27JPq3rouIfmkcVQKFDO6BwLLwRKr4=;
        b=mh1w6UAHAIe3RbULAEBPqWjbildzXECtEbL8YQOWAbch0HYAywX7F/+F9I684740jF
         /+5lCOY/50/D+5KGU9mpk+wMhbzL+qARrLe8Zfh+RHsOip6YdoxP6CyfvTToxzONwPQK
         3HZTt/gdn7VC0F37j8iVzcYho5+AvFfn/zbauV3+ont2hWM5la9rml5cqhqp51CqXHT0
         amEg1iXLciLxG3fgK5iuLdsNklT9No5zhHy0iyzpgZ5BznoY4teJZM5rETQb/iswn42c
         5Py8lO6DIuzBlerti2WFE6Xp7H9lIg2+9aILmK3IrtHtbtGKx1QcEGB3GxBECOR373DY
         V+zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KqXjH7gwFMCzi27JPq3rouIfmkcVQKFDO6BwLLwRKr4=;
        b=y4h2sKuNxIcI/CvOFj0TT/CaLS/6pH9G9FAl/GDF6AGQiTCaYQmpm1+aAMUZoD48QI
         vyuqx3jCqpjRfFuvsfSwqdVaAc6Ts54mihbOJ65sSC7bQRJj9ei6zKVJa8vwp0CRFYLm
         izMhzgekbpBc6itt1n4HwvnC7OXvlLdYdyaTz5BpdvvKGrj7Hi+S6NBzLcPxFfKdbq+P
         00uU3SHcbMW6pvgqFWV27CunDQUMGtva+yBNYXpleiAYG0LWE92iSPTSw0TWjT4wgZ7n
         OTVCt97oajUthNlzZBdgxFkwQDdJgokQRxXbfS9R5QPpMcpP3oGv8Kf9JmuZbG1lWeUJ
         u1aw==
X-Gm-Message-State: AOAM531BCEBEltFV32kuCngidCtQAlufIGC1CQL71SDKbA/mQUfaD6k3
        bg27Yn1sZXLdcCEuONw37mxmCVusEJFZZwCb
X-Google-Smtp-Source: ABdhPJwOYm9qol5SSNEkGREzhaBeYjV9a9fZDIyK/8jZGg5YRwXj+E7B2qR0sFlrRt7vUCMNmSI4SQ==
X-Received: by 2002:a63:d40a:: with SMTP id a10mr7108184pgh.7.1631276798173;
        Fri, 10 Sep 2021 05:26:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q12sm4891099pfj.153.2021.09.10.05.26.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 05:26:37 -0700 (PDT)
Message-ID: <613b4efd.1c69fb81.72e07.e7d0@mx.google.com>
Date:   Fri, 10 Sep 2021 05:26:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.144-30-g3489ab1559d9
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 134 runs,
 3 regressions (v5.4.144-30-g3489ab1559d9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 134 runs, 3 regressions (v5.4.144-30-g3489ab1=
559d9)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.144-30-g3489ab1559d9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.144-30-g3489ab1559d9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3489ab1559d9a467a893b1772fd22c0f89f0ff9e =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/613b184a98eeadb1c9d5969d

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.144-3=
0-g3489ab1559d9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.144-3=
0-g3489ab1559d9/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613b184a98eeadb1c9d596b1
        failing since 87 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-10T08:32:55.434799  /lava-4489239/1/../bin/lava-test-case
    2021-09-10T08:32:55.451877  <8>[   14.554840] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-10T08:32:55.452253  /lava-4489239/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613b184a98eeadb1c9d596c9
        failing since 87 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-10T08:32:54.010237  /lava-4489239/1/../bin/lava-test-case
    2021-09-10T08:32:54.027106  <8>[   13.129729] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-10T08:32:54.027473  /lava-4489239/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613b184a98eeadb1c9d596ca
        failing since 87 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-10T08:32:52.995848  /lava-4489239/1/../bin/lava-test-case<8>[  =
 12.110353] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-09-10T08:32:52.996185     =

 =20
