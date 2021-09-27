Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2034C41931E
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 13:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhI0LcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 07:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234077AbhI0LcA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Sep 2021 07:32:00 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407F7C061575
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 04:30:23 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id g184so17527230pgc.6
        for <stable@vger.kernel.org>; Mon, 27 Sep 2021 04:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PuUl8XAgB1hg0HUVnjUkbIBWL2h9T1Pmpywe1t2lZhc=;
        b=bxoDLufg3oj5bG+soWw0L2PxK+hY3xZEcEaviwk9vZVrhpZ2wgP7Wa6LQoG/4QTD/W
         WEXJkkJPZkEFpnSgupGBWlHBWPpImFUuXcif8RymghVFVUZymmGq/EcoU3wQJVu13o0V
         /Av11Xe1uCucBdpFYmmn6SChOjE3/C42NylvxqyfGqX5ne3OpYTUtwJhdnt2i6GpnsZy
         158lEDNzchNk2FpSdrMWnPJOsYFDeVMYcQbN4Y5NC5kqZ0rxUY0+e0h4x0R0j3IxpnZY
         aCMjq5APs6vgRk6KjwS9ya+6nrm/bJ7APnaMcjx/WT9XP4dWHuZhp7qKnp+RHgAq3b2K
         eptQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PuUl8XAgB1hg0HUVnjUkbIBWL2h9T1Pmpywe1t2lZhc=;
        b=SLoZnA6AE0NYWn3YNd6kxUjBWUxQVACM2tVsrazwbtoXh+ijf3Hqbc7Uxv/HiXodaR
         DN5JErF6iRLwqLdHfxGAAC1ys1/mFgfy2tNX5wuvhMzTEMVOMhaQJaFWjTHT2109iC5l
         Oj6FvmmnHAzieVMa+rZjVeBsMzFxcIYQgdLRmzL1KL84PjK2O2WWlzmDYeSUrtcRZrkX
         XFoH2MXUMJ0WXlXiDralfOezmPNMuwrUwG3tNc1tp2qQDrOJqfjQlKsRZfeLYn39PVc9
         P5TiCoQwED1Sjulpa5E1t8NdFSnB+WqZwZdsf6k29YDUSOJN8duIR+hLYHwrCmuo2z9t
         IUXg==
X-Gm-Message-State: AOAM532RIw2YH2F4QY2grI4qIFW/fL0kh1fAeVivSud1/wxJpoQ8OGgb
        uNUQKS7buDlD8mqiVIRL9Bn3Ta7vwYJ+jmLb
X-Google-Smtp-Source: ABdhPJx5zVkj+6wNUXCLNakRFvSXKLHmjMYqoj759KMf4Cgnqxo7No3dF/O+S8V6IO3MGF6r4QKsFw==
X-Received: by 2002:a63:1f24:: with SMTP id f36mr16160401pgf.6.1632742222473;
        Mon, 27 Sep 2021 04:30:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d24sm14807534pgv.52.2021.09.27.04.30.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 04:30:22 -0700 (PDT)
Message-ID: <6151ab4e.1c69fb81.55768.42a3@mx.google.com>
Date:   Mon, 27 Sep 2021 04:30:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.148-113-g174912e10dbb
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 150 runs,
 3 regressions (v5.4.148-113-g174912e10dbb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 150 runs, 3 regressions (v5.4.148-113-g174912=
e10dbb)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.148-113-g174912e10dbb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.148-113-g174912e10dbb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      174912e10dbb3bba7108ac4aaee5a08f855c49a2 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/61517a3dfbf5d5120b99a34f

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.148-1=
13-g174912e10dbb/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.148-1=
13-g174912e10dbb/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/61517a3dfbf5d5120b99a363
        failing since 104 days (last pass: v5.4.125-37-g7cda316475cf, first=
 fail: v5.4.125-84-g411d62eda127)

    2021-09-27T08:00:46.119497  /lava-4588699/1/../bin/lava-test-case
    2021-09-27T08:00:46.135533  <8>[   14.966369] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-27T08:00:46.136013  /lava-4588699/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/61517a3dfbf5d5120b99a37b
        failing since 104 days (last pass: v5.4.125-37-g7cda316475cf, first=
 fail: v5.4.125-84-g411d62eda127)

    2021-09-27T08:00:44.693362  /lava-4588699/1/../bin/lava-test-case
    2021-09-27T08:00:44.711655  <8>[   13.540976] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-27T08:00:44.712134  /lava-4588699/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/61517a3dfbf5d5120b99a37c
        failing since 104 days (last pass: v5.4.125-37-g7cda316475cf, first=
 fail: v5.4.125-84-g411d62eda127)

    2021-09-27T08:00:43.679977  /lava-4588699/1/../bin/lava-test-case<8>[  =
 12.521557] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-09-27T08:00:43.680567     =

 =20
