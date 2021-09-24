Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9AB4179F3
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 19:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344918AbhIXRoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 13:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344856AbhIXRoC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Sep 2021 13:44:02 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C18C061571
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 10:42:28 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id lp9-20020a17090b4a8900b0019ea2b54b61so723195pjb.1
        for <stable@vger.kernel.org>; Fri, 24 Sep 2021 10:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MJL9m+261GoT0BRtdA8VjSggatQMC7cl1J9wcTiJ2vk=;
        b=etf/G6nyBsqsxquU6LmGMHpgabQyTaUBo9cZCdaotEp4C3oJ1IUckbxHK90awJ6di1
         gV5lrHAWB6k3isNk+RIEvxZqdtEFfowpBMveoujRWeP4vi9VCK4oWaSuEXsZ8q+Ctiq7
         ZI/dD2m2UAsBRen5JQolSyA3QpLE5sAZ+zExmuEIOAtE16evLxfQjFX7UTH7h1Sdme4W
         f1uVelfY4RSxHL38GRLotCZyvrGeWPVMGEXAyIGjEOoHEteCuPDbgIZYdEGGYgxiASyR
         SjGJaKqgRWJiuNC25bRbGfhf1syYtyZPy8GFH5fF/8LNZVaeh7y7CeqHVKg0YCs6eT5P
         KjLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MJL9m+261GoT0BRtdA8VjSggatQMC7cl1J9wcTiJ2vk=;
        b=esSekehiuY3WPDIzzF3X2vhb1enWLXCtdarLebDIIumZ06xFGze1kCAyedcm6ZyR82
         h3rRN8F1XoE84Jb20fWwa0Qfdc1FPxMMTozrpss8jTKC2tEEz8R0Fk8+ErF+YUcV/K65
         QmkZ/OQyY6etkiHoT/ebRRKN07PyqKYJflsbt9nQXB923BOdPJUupJghaMB64BfC9VIW
         vC8Sd340QmUN1m7T3reNOApt/CSygfbDH5Uzxa3LaK+nN7WPg6+sSrLhFPEoMbYs6Ee1
         GBLD4bD1Go0ul1UTkQh1G4L9ko5gdu1KhkBRdcqmBPCbyiAFTx1pOcVGm442/Xypm6pg
         waJw==
X-Gm-Message-State: AOAM532LmAOsby1uugSZ4FXSlw2tMs/5hOQXTttfco7/Ub0vQipIQvc/
        lYTEbGpo3tERpbBbb7ehRNrkvTIPKEDWdnmJ
X-Google-Smtp-Source: ABdhPJzsmj12IVn3/Q7C22pj6zv3ujJwHQrAqSJivSy9UWJAZoCIu8Vl0/QO/3xtXn40nG3+FsNATw==
X-Received: by 2002:a17:90a:2:: with SMTP id 2mr3665610pja.77.1632505348192;
        Fri, 24 Sep 2021 10:42:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y5sm9382905pfb.207.2021.09.24.10.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 10:42:27 -0700 (PDT)
Message-ID: <614e0e03.1c69fb81.121e7.dc2a@mx.google.com>
Date:   Fri, 24 Sep 2021 10:42:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.247-26-g5d4977a59e34
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 70 runs,
 3 regressions (v4.14.247-26-g5d4977a59e34)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 70 runs, 3 regressions (v4.14.247-26-g5d4977=
a59e34)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.247-26-g5d4977a59e34/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.247-26-g5d4977a59e34
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5d4977a59e34d6c1fb02b1ce41d0b8e4bff252f4 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/614e06f3a0aa53b72099a2ed

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.247=
-26-g5d4977a59e34/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.247=
-26-g5d4977a59e34/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/614e06f3a0aa53b72099a301
        failing since 101 days (last pass: v4.14.236-20-gdb14655bb4bf, firs=
t fail: v4.14.236-49-gfd4c319f2583)

    2021-09-24T17:12:05.540361  /lava-4579459/1/../bin/lava-test-case
    2021-09-24T17:12:05.546217  [   17.081454] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/614e06f3a0aa53b72099a31a
        failing since 101 days (last pass: v4.14.236-20-gdb14655bb4bf, firs=
t fail: v4.14.236-49-gfd4c319f2583)

    2021-09-24T17:12:03.108141  /lava-4579459/1/../bin/lava-test-case
    2021-09-24T17:12:03.126804  [   14.650089] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-24T17:12:03.127258  /lava-4579459/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/614e06f3a0aa53b72099a31b
        failing since 101 days (last pass: v4.14.236-20-gdb14655bb4bf, firs=
t fail: v4.14.236-49-gfd4c319f2583)

    2021-09-24T17:12:02.089779  /lava-4579459/1/../bin/lava-test-case
    2021-09-24T17:12:02.095591  [   13.631354] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
