Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA543FE379
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 21:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239058AbhIAT6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 15:58:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbhIAT6i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 15:58:38 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F41C061575
        for <stable@vger.kernel.org>; Wed,  1 Sep 2021 12:57:41 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id f11-20020a17090aa78b00b0018e98a7cddaso532039pjq.4
        for <stable@vger.kernel.org>; Wed, 01 Sep 2021 12:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yXR/k+YW1k/k2XLjLk/S9PI7YRJWwS5TiQr7EMxGrhQ=;
        b=Y+T9LUB0SG2T4ceDjqZuRpT2xYkLbdypmYZdNUbm0SlfWJ3D7yPPIZIRXazvOyp9yi
         I/nu6OUZ3AFen3U1RD0An5pxev8udxSaeRDQcCxAvhk6r03p+cHJM9m3lO7r3WE9ibDs
         IGWOEn5bQrAUgqTLXlJXAJRyPYsUL3ON5OlZzy0/7cv0fg3dtfwneGQP2p20ZiQi9fuQ
         IvTLnM79aFW2BnJYYmOChoYPuJeEYofN14Xe6Q71s6WdbvufXY8zSNyoxXSbreEHDA/u
         Jt9LSW0Btk3AtgsGoC98t4lReulHi011ePyVeqqYom5LNJB7wQUpN1optLU3P2GfBy/e
         1i4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yXR/k+YW1k/k2XLjLk/S9PI7YRJWwS5TiQr7EMxGrhQ=;
        b=tBn7NDOUTsMvjwa0CYdY+vEBG9LAO0JQJwWq3hMi1rJv6rUCczZHOi1e4fomIu+q3Q
         BTcZGh+/q08V3ucWtCIE8NDpf2YnSM1kEKcCX57r4JLLe2KBD57K3tZ85QktGkFIlH/3
         92LA9UEPGKhd2K0KEQtEmfFPEE5k7FxDaaHSwMcElwyDm9nthEItDKYw/nbCRNWQUE/z
         L1xO/KsAtWKTnaZTLSZYUtOxJev/HYSw/LSjlszl9oCsZagzq0twMrQrGEqAiTku1fed
         AUjoYkrI6KyW5Yu186wEV4q25n7fB1Jk6OBPbyvXrcNUBapN+Ca3C1nebah3HvcIG6A4
         Usnw==
X-Gm-Message-State: AOAM5325q/AhMDEd0k+J5E+bIBEN5CbYer466W2Sp96fb5fAkpJnky1L
        MACDXzDxzJ4bYYlfdXYMwzD8Jz+p4nPjIhfB+98=
X-Google-Smtp-Source: ABdhPJwdQ1TtO/iMFBN4wqdu+UIXXYJeiVMyMvmNYj11xq+NMR0i5jvukDeh7gNhNa7QqPLr7ZjmKw==
X-Received: by 2002:a17:903:143:b0:138:e2f9:7211 with SMTP id r3-20020a170903014300b00138e2f97211mr1041787plc.30.1630526260826;
        Wed, 01 Sep 2021 12:57:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k8sm303423pjg.23.2021.09.01.12.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 12:57:40 -0700 (PDT)
Message-ID: <612fdb34.1c69fb81.79f51.19a9@mx.google.com>
Date:   Wed, 01 Sep 2021 12:57:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.143-48-g2798aad31c8b
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 192 runs,
 3 regressions (v5.4.143-48-g2798aad31c8b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 192 runs, 3 regressions (v5.4.143-48-g2798aad=
31c8b)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.143-48-g2798aad31c8b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.143-48-g2798aad31c8b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2798aad31c8b389acd5ac099dde2c1ed84831eb2 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/612fb82ffcaa54288ad5968a

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.143-4=
8-g2798aad31c8b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.143-4=
8-g2798aad31c8b/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/612fb82ffcaa54288ad5969e
        failing since 78 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-01T17:28:05.604817  <8>[   13.848575] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-driver-present RESULT=3Dpass>
    2021-09-01T17:28:06.636218  /lava-4429262/1/../bin/lava-test-case<8>[  =
 14.868392] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-09-01T17:28:06.636569  =

    2021-09-01T17:28:06.636768  /lava-4429262/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/612fb82ffcaa54288ad596b6
        failing since 78 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-01T17:28:05.194165  /lava-4429262/1/../bin/lava-test-case
    2021-09-01T17:28:05.199465  <8>[   13.443286] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/612fb82ffcaa54288ad596b7
        failing since 78 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-01T17:28:04.180569  /lava-4429262/1/../bin/lava-test-case<8>[  =
 12.423893] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-09-01T17:28:04.181120     =

 =20
