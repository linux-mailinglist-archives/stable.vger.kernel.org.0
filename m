Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 578D6400752
	for <lists+stable@lfdr.de>; Fri,  3 Sep 2021 23:13:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235876AbhICVOK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 17:14:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232927AbhICVOJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Sep 2021 17:14:09 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B167C061575
        for <stable@vger.kernel.org>; Fri,  3 Sep 2021 14:13:09 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id n4so275786plh.9
        for <stable@vger.kernel.org>; Fri, 03 Sep 2021 14:13:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wo+kgz6cee6QE39Xicu4m4r0tvXpCgW0scTALvp0NIA=;
        b=XjJsk/T0qhZlLFAVbuLW3c9aJ/Gg58/f8q6JaXHuelaOpBcI8rAwKWBdMt0iMwlQd7
         3H2yxEYAUHmGdwym7UosVbFKuZxlpCdG4rGzM7w0Yqixp6598iLrbhcxDeTz4bgCptda
         NlfUPVqkooBQiQf9UZ3xQk7Jmqu9aVOyz8/L2KuuuFSbeWsqN2O6BPCADlIX5ZK+4Yyy
         QNqEGLeoVQD6F5WZgOR+m1RRlVhDKb2Pqzp8akyk4seO5miAjPoYwB8+8wVAoi4Blopw
         QNPQ+arpD285wcR4MSpKCyGaiXOLKL/kFAHgIZTRf2dxET8jF395Lrzd0IWy4nH3/RBR
         2NTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wo+kgz6cee6QE39Xicu4m4r0tvXpCgW0scTALvp0NIA=;
        b=b1KInxEncnzhjZhMt+98IXhf9G5NOVItd/CL+xFrGLdAjgZQsIzSegsmy0tV88t1ki
         5mGNHhF/nol7l9cbE4JEMiC5PSUVvcvnRckH4qtt+9vLJmCaZF6g9Mg2ezbOwca1400i
         cczJxXox18fg8j+bzukhUnhXUzxvblNQtfDyzauYvSaeqQUYM6FBjvr1FMoTEuPedqCu
         qBvpjwqEtCwWgToGahyeSF4xpuQjtrTsEdyR10AauWYTZP/Gcx3WA3bXEG0z0yi/7wdT
         BX82MWVaKDLdzWP5eoB1COYTxBU/kOR0ZkL1ul/YtZbBat3PKqIzPiiYqnfsO+17ujWr
         87Qg==
X-Gm-Message-State: AOAM531Nbnt/Ed5+Ug203Ye1SLiyZPhHnQ2oVIsM6XCMscRzHgZZq+vm
        p/w5kbFSamvkgvYZpSGzxpeg22M7cmc0MWzd
X-Google-Smtp-Source: ABdhPJySNTMT1j9/ZKy6uYxL8brB3R/J59abjlIq/UOPohF1ene+7hZkTqyFCGmcdtV4/8ZpnSwM2A==
X-Received: by 2002:a17:902:bf43:b0:13a:ae0:9dee with SMTP id u3-20020a170902bf4300b0013a0ae09deemr531548pls.62.1630703588631;
        Fri, 03 Sep 2021 14:13:08 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o1sm188549pjk.1.2021.09.03.14.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Sep 2021 14:13:08 -0700 (PDT)
Message-ID: <61328fe4.1c69fb81.df8fc.1056@mx.google.com>
Date:   Fri, 03 Sep 2021 14:13:08 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.144-5-gaf4d70cbbe11
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 170 runs,
 3 regressions (v5.4.144-5-gaf4d70cbbe11)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 170 runs, 3 regressions (v5.4.144-5-gaf4d70cb=
be11)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.144-5-gaf4d70cbbe11/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.144-5-gaf4d70cbbe11
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      af4d70cbbe11f5332aa2e57c83bcdd1007cf9f86 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/61326dae0f08417900d59680

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.144-5=
-gaf4d70cbbe11/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-v=
eyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.144-5=
-gaf4d70cbbe11/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-v=
eyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61326dae0f08417900d59694
        failing since 80 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-03T18:46:52.608084  /lava-4445585/1/../bin/lava-test-case
    2021-09-03T18:46:52.625106  <8>[   15.270303] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-03T18:46:52.625560  /lava-4445585/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61326daf0f08417900d596ac
        failing since 80 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-03T18:46:51.200493  /lava-4445585/1/../bin/lava-test-case<8>[  =
 13.845579] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-09-03T18:46:51.201274  =

    2021-09-03T18:46:51.201756  /lava-4445585/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61326daf0f08417900d596ad
        failing since 80 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-03T18:46:50.163166  /lava-4445585/1/../bin/lava-test-case
    2021-09-03T18:46:50.168729  <8>[   12.825924] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
