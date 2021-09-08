Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360D8403D38
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 18:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhIHQEH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 12:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbhIHQEF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 12:04:05 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7346FC061757
        for <stable@vger.kernel.org>; Wed,  8 Sep 2021 09:02:57 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id r2so3078615pgl.10
        for <stable@vger.kernel.org>; Wed, 08 Sep 2021 09:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=G+P36Z94aQW+X4s+UQEbVwrldE8KbuCa2wSDZPeft1g=;
        b=efqmXagkV7lb4SXehtXXHy0Z7ZzoIWeyI9lUNppfMpVAv0Ae1fzh4y7kENyLSgIg1H
         i/iYNFG18YPXJutNel/bG+UAVuLrwca6ufBrAUdoUAsh4JR6+AoKpJ3srAxCqXJUH9ET
         UQzt2CjlNjtUawa5THzbKV6AsR5GwuAMDDxmiW5ZfgbXjMPcPT2GXPdge2GOBqQid99l
         NOPphFzy3ih4jCdWU5/cAhMYrTuZ6PgbgsKj0CLsi3+cVr+5qeVs+mrkrMD05s+5Zujf
         DhbmJ5Ps+2rp3gfiNGoJpOEs/RaBOWuRuNfQJPrOM59NbJM0szvXoWKY06Hp6g+W+zwc
         drIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=G+P36Z94aQW+X4s+UQEbVwrldE8KbuCa2wSDZPeft1g=;
        b=GYoSoQ/Lts4sn8RrythoOlyXTomUWo2sptlzYS4LdpoGb6PrhzfLZiB59BDPgqa9uT
         H1r3pHjvXvkWDzf3bvRm4A3FE0KNeeCtxAOzYutXD6yyth44n+kfwcSV6l6sAxA5Oijz
         sxjYB7h/pvVE2TF41RpiLy26N3M+zfGUB5Vnctz7Iwe+/3uUrtmuALeK9Hwq42+OTB51
         NHeV6cYkyHVQXKWjkAPyvshRuLNYSmBt3FsAbbYkD9et/2f1Dc8FyvIy8yFM86uumcQq
         RvErF8Vu2Uurxl8isAR/hTGAnZecDiQcCOqEvKgfaZRpacFe2fd1RASZq9xAf4FIduie
         of9Q==
X-Gm-Message-State: AOAM530879uDLM4+0dpBlN+LbpWdcP9JQWeLeaAe4H9aLRXckppBm0RX
        Hfy4s4LqkvNlG4zv2FJ9KCIzVWBuCoqfh+Ne
X-Google-Smtp-Source: ABdhPJyXmmWGk/eLfr+slZ9Jfy+Q4Ttxbelgaor/wjmUMrapiYAZ6iD/nxaMmNCQaE2q6U5jJWDweg==
X-Received: by 2002:a63:3305:: with SMTP id z5mr4364685pgz.290.1631116976689;
        Wed, 08 Sep 2021 09:02:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id lw14sm2497651pjb.48.2021.09.08.09.02.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 09:02:56 -0700 (PDT)
Message-ID: <6138deb0.1c69fb81.7b60b.6e35@mx.google.com>
Date:   Wed, 08 Sep 2021 09:02:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.144-22-g4b574fc9df17
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 145 runs,
 3 regressions (v5.4.144-22-g4b574fc9df17)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 145 runs, 3 regressions (v5.4.144-22-g4b574fc=
9df17)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.144-22-g4b574fc9df17/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.144-22-g4b574fc9df17
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4b574fc9df170fa42a816b5ae68ffa56ce7063fb =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6138bc08a64c2b156cd59672

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.144-2=
2-g4b574fc9df17/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.144-2=
2-g4b574fc9df17/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6138bc09a64c2b156cd59686
        failing since 85 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-08T13:34:48.923703  /lava-4476030/1/../bin/lava-test-case<8>[  =
 15.043798] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-09-08T13:34:48.924028     =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6138bc09a64c2b156cd5969e
        failing since 85 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-08T13:34:47.493617  /lava-4476030/1/../bin/lava-test-case
    2021-09-08T13:34:47.510840  <8>[   13.619659] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-08T13:34:47.511328  /lava-4476030/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6138bc09a64c2b156cd5969f
        failing since 85 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-08T13:34:46.474119  /lava-4476030/1/../bin/lava-test-case
    2021-09-08T13:34:46.482721  <8>[   12.600002] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
