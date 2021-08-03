Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B64113DF315
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 18:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234781AbhHCQoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 12:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234565AbhHCQoa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 12:44:30 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A7BC061757
        for <stable@vger.kernel.org>; Tue,  3 Aug 2021 09:44:18 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d17so2454653plr.12
        for <stable@vger.kernel.org>; Tue, 03 Aug 2021 09:44:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ahWreSxsbQGn3RUgh9FYaJHQujv3fQ6Fd+Bkr3m9Has=;
        b=K7nH7EixKv6ElXOeIE062p6hquuOOPAV1srS7PZ4Z2oy3Rlx+35KNl7lwB08iEc4ai
         om03a1sx5PdgC3akH7wzeC4rbe/JVmlijsPlEGssMF3dNpiKXHq010LeLMReX91edXNR
         CqE6Ey3af/tLC19+0mDWrgm5kEpjwl4yWgQBG5wxK1e7JPgkqgzTQd8sYA6tNfglGQPZ
         wuze9R9hy4qJN/V9O4Lb/KD8Kl8apBG5FtOYN5EQZIBZHkrboCCJuPmLboNMJbVMm+Tf
         YTWckeQ+I+Q1GuC1NrRwNYIsCq7PP6vXnekQJZGJacy/T1L/VlwZtvvXqJy8rQoRM7sV
         Uqkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ahWreSxsbQGn3RUgh9FYaJHQujv3fQ6Fd+Bkr3m9Has=;
        b=YuozjmI4hgRj/YBOSLXTYlrrAQeF90vunKEtPnZvJgVoxAYNert5KuMpBHtz/4bN2Q
         h4rDIdirH0eezPsLl4fe3uFkol2ibPTknMlxAxDxTP97FBfphI8i6xwvM/9SomH0n5Xc
         UZRjWv2Kx4bQhr3IIXlJflOi3rJPB0ujPK6jaeqsCRAEZpgfHVQKFt0Nqg6ktyviYtln
         W9G7x4rveFlPQB4TL9yupILWzUy57lyllpbKI3+33Y7xoDiYiPyMwv45NLO5/FyiaF0J
         WfQ6ynpfxRiGyiNMIIjMqc4LreN+xJeRv3jWeoHxpvnlelhQwgN82q9tGW9PHPk0nLsK
         ugVg==
X-Gm-Message-State: AOAM532WUxK1rDYr+hVAPPoh6sOkh7xBw7q8U6haAcs86vV+DqW3lMXw
        QvUr6h0WFqEkL4a34aIXyI6HDF7KokuAJCUq
X-Google-Smtp-Source: ABdhPJxle8AeT67ACDofp3bwupjlUos6LJqT61tGQewvTRloyis4ZJHrnP3SO9Tr1qo75qyF802lsQ==
X-Received: by 2002:a62:87c5:0:b029:3b5:f90f:c2eb with SMTP id i188-20020a6287c50000b02903b5f90fc2ebmr16785693pfe.28.1628009057951;
        Tue, 03 Aug 2021 09:44:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e12sm16316178pfc.214.2021.08.03.09.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 09:44:17 -0700 (PDT)
Message-ID: <61097261.1c69fb81.6caa3.df3f@mx.google.com>
Date:   Tue, 03 Aug 2021 09:44:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.241-1-g20a47ca23273
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 150 runs,
 3 regressions (v4.14.241-1-g20a47ca23273)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 150 runs, 3 regressions (v4.14.241-1-g20a47c=
a23273)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.241-1-g20a47ca23273/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.241-1-g20a47ca23273
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      20a47ca23273bbe0c07add55ee601cbae3df38c5 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/610949d3ba7df424e0b1366e

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.241=
-1-g20a47ca23273/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.241=
-1-g20a47ca23273/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/610949d3ba7df424e0b13686
        failing since 49 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-03T13:50:27.406524  /lava-4317694/1/../bin/lava-test-case
    2021-08-03T13:50:27.423784  [   18.278656] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/610949d3ba7df424e0b1369f
        failing since 49 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-03T13:50:23.962837  /lava-4317694/1/../bin/lava-test-case[   14=
.828713] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed R=
ESULT=3Dfail>
    2021-08-03T13:50:23.963327  =

    2021-08-03T13:50:24.975908  /lava-4317694/1/../bin/lava-test-case
    2021-08-03T13:50:24.993035  [   15.847459] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/610949d3ba7df424e0b136a0
        failing since 49 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =

 =20
