Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF2EF39C5E9
	for <lists+stable@lfdr.de>; Sat,  5 Jun 2021 06:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhFEEr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Jun 2021 00:47:28 -0400
Received: from mail-pg1-f170.google.com ([209.85.215.170]:45658 "EHLO
        mail-pg1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFEEr2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Jun 2021 00:47:28 -0400
Received: by mail-pg1-f170.google.com with SMTP id q15so9419169pgg.12
        for <stable@vger.kernel.org>; Fri, 04 Jun 2021 21:45:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wae6hNLgXMP0lvzhL26Iiamez9yWulnUXyH/RRV4dyU=;
        b=NrRF17hNqHMsiICDUXV8jaPdcEb/qNDk8J7U3tc5mmRLv43EpB5WxDfgAni9SKKzDj
         mNA/iHoUMchiDI18E9oNVcp//9ElJS0Hmd0eQ7EeY8TGyUUxdwZadIuHojhcBD+R03Yq
         DOLmKJYpiYxBxDSekwOnbHY0Zwje1CK1VaRVcce5vVvO0QXWxmpC4Ct+7benHWIka4WR
         BkmP2vngDiCQWVYOpSyNlrzRalusXYSL7X+nTNl05LJq/blztqHbWRU4DBtrjwOpu/T4
         g4F1gLIeNCHLhvQn14OVHH+G6kDmJekY8AyWBG0dZxaZeJfOkR9NBwOnOB8R+2cA8D6A
         Q8/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wae6hNLgXMP0lvzhL26Iiamez9yWulnUXyH/RRV4dyU=;
        b=o8CMNPvSadgSkjoW2GoS6GkNnsVSizPlGJgTZqh5hdiwMZhDCS4MnYHT1tBY8zzMhe
         DMooo+OiwkksCVRiGO0OyZmzp1vEo8+KcR/2Q0RcZ5Q9UxdjArKydNDZqoDHZ/k7Z3ho
         x/PPpAGPUxTdxEeQO0NTWlKNfs89Rx2Eroncs+0LVW/vfG8mr0ANgroACtcO4tL7Bd2S
         TcdDMEoIyD1vBuAN+JA//z2gsprA6ISM+k8+uMiglCOTuAmX4+uSKmtDX+3YuDVtvs0I
         2zDuQwHq49KCWmboTCHs+9OOWf/GSV0+qJKCn93HIo7t6/7pHKZ5NjbDGkunhVoCXWoP
         0Q7g==
X-Gm-Message-State: AOAM532wxOi3hpF22NR80qFB2P2/V7ndA+tEJ9Vt94KJzkLYdGaZdvha
        bZtKkTXmMPiGNx+jchUlKEz4zLDZdPE/LFfY
X-Google-Smtp-Source: ABdhPJwOfK713Dv3CilQGxjIV3+eKSOkTPp/taTtp0G5OrReG8vBH1f9AHCeFgJ9tI+9vctC/gza+A==
X-Received: by 2002:a62:a508:0:b029:2df:2c0a:d5e9 with SMTP id v8-20020a62a5080000b02902df2c0ad5e9mr5742592pfm.7.1622868267850;
        Fri, 04 Jun 2021 21:44:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y14sm5737100pjr.51.2021.06.04.21.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 21:44:27 -0700 (PDT)
Message-ID: <60bb012b.1c69fb81.5dc65.3928@mx.google.com>
Date:   Fri, 04 Jun 2021 21:44:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.235-1-gf40a5f239352
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 150 runs,
 2 regressions (v4.14.235-1-gf40a5f239352)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 150 runs, 2 regressions (v4.14.235-1-gf40a5f=
239352)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
fsl-ls2088a-rdb | arm64 | lab-nxp      | gcc-8    | defconfig | 1          =

meson-gxm-q200  | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.235-1-gf40a5f239352/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.235-1-gf40a5f239352
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f40a5f2393522ea484a6dc2525e0ce676b9ed7cf =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
fsl-ls2088a-rdb | arm64 | lab-nxp      | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60bac85f5aac9aae140c0e01

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.235=
-1-gf40a5f239352/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.235=
-1-gf40a5f239352/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bac85f5aac9aae140c0=
e02
        new failure (last pass: v4.14.234-84-gd2294bde5706) =

 =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxm-q200  | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60bad20720eb0c595b0c0e11

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.235=
-1-gf40a5f239352/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.235=
-1-gf40a5f239352/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60bad20720eb0c595b0c0=
e12
        failing since 95 days (last pass: v4.14.222-11-g13b8482a0f700, firs=
t fail: v4.14.222-120-gdc8887cba23e) =

 =20
