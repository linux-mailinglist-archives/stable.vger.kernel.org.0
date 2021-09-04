Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BDD3400B83
	for <lists+stable@lfdr.de>; Sat,  4 Sep 2021 15:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234241AbhIDNhN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Sep 2021 09:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbhIDNhM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Sep 2021 09:37:12 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D785C061575
        for <stable@vger.kernel.org>; Sat,  4 Sep 2021 06:36:11 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id k17so1243181pls.0
        for <stable@vger.kernel.org>; Sat, 04 Sep 2021 06:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xiHJOr1HUW/AN1JINoC2B8pYbXeC9V1Kel9eMrf6Gy0=;
        b=KVGD3HY963kWwntBa7VoMa+6l2jSgRZM3I6fNCku5N9B8aYRWrdbyN1Q0YPIuyOV6X
         5bIULgU6wI9GssdH88brOumKo1FdfMJr2N1qcUTCBjmOkaySQv9y9oqL2yd0TiVXF7mN
         C7vPww11ftXs2kQOeAqjWxdDe5ru9xEBFNI138d5VDzwoR3gMolPUOANJAENOGn3iTpL
         nEo0umnyp4Ye2qfPPzfa1aMt0KZYgAsN0+CJ6lOaMhKKSahx/yvvf2+JOHmdygzOUVIc
         IBxSLY638eZrsRJkew8gY8LDeOHdSm8A4hi/bMmcgiu/Zt6qNHdrUFJI/8sy1VkzoGYo
         Sgxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xiHJOr1HUW/AN1JINoC2B8pYbXeC9V1Kel9eMrf6Gy0=;
        b=WAY/UZhLK8Yuu9bNYmd5EYI6DJMJj9fmf3D9pjKQeBJy6uIS2LMQUZj9FB6hh9XHIE
         OvOcAD/eDpLumD0UPo59U6VhJT6XqsLdIfgYA7MmLnNszJlyMRyUuxgUbQy2hyXRMpDq
         fm+dG3JAu/cns/4LZFmwNgWlAYwJlIj+ZG0D1AKmjmSJEzIsgv52pxawYCmqhlfxp5Hy
         K6jNl6SHGVDur13jf3D6qnsgJJr3TkFwOniroFEThMYkz0tk63mTpnDHlwFEC5FzvkDO
         WywSntjAfg+tsf8uC1QMajHYrWuhcF1WiTTnHEGt6xlPH9jkzCq+D+4VyBalOlwXuV+I
         H3Ew==
X-Gm-Message-State: AOAM532HthalSKfef9bE+TDMiv9bmYaRCtveIt05E6XF6iYzVEOxnaOd
        P4R5jYpd/KD9H7PHptR1H93qFoLY3RfHfRXN
X-Google-Smtp-Source: ABdhPJwKJWMrO2TQISvUCr5c7NBJB7eRGvIXIaGvaCIKrr68hPS6x2CC5evNQ4GG7KZWhjOylVeNGA==
X-Received: by 2002:a17:90b:4d09:: with SMTP id mw9mr2869315pjb.71.1630762570808;
        Sat, 04 Sep 2021 06:36:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u24sm2686816pfm.27.2021.09.04.06.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Sep 2021 06:36:10 -0700 (PDT)
Message-ID: <6133764a.1c69fb81.d7cee.76e6@mx.google.com>
Date:   Sat, 04 Sep 2021 06:36:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.144-6-g49d153c950b3
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 190 runs,
 3 regressions (v5.4.144-6-g49d153c950b3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 190 runs, 3 regressions (v5.4.144-6-g49d153c9=
50b3)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.144-6-g49d153c950b3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.144-6-g49d153c950b3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      49d153c950b3d834626fa3087b60c3e8b4cf7970 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6133425b2914b72fced59684

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.144-6=
-g49d153c950b3/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-v=
eyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.144-6=
-g49d153c950b3/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-v=
eyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6133425b2914b72fced59698
        failing since 81 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-04T09:54:16.683554  /lava-4448990/1/../bin/lava-test-case<8>[  =
 14.973666] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-09-04T09:54:16.684061  =

    2021-09-04T09:54:16.684379  /lava-4448990/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6133425b2914b72fced596b0
        failing since 81 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-04T09:54:15.234947  /lava-4448990/1/../bin/lava-test-case
    2021-09-04T09:54:15.244817  <8>[   13.549236] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6133425b2914b72fced596b1
        failing since 81 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-04T09:54:14.230018  /lava-4448990/1/../bin/lava-test-case<8>[  =
 12.529723] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-09-04T09:54:14.230409     =

 =20
