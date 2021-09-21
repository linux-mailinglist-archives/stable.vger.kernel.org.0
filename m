Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8802B413550
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 16:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbhIUOaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 10:30:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233601AbhIUOaJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 10:30:09 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8775CC061574
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 07:28:41 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id k17so5288800pff.8
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 07:28:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=s5VJU9uJCWfPnKAhZaQ3OV5FUN/AL9WNy7bNSFP43xE=;
        b=7/q5MjuFKDpFsTSRa16YWAxzXb6tg2em4Rf6A3LyGPvfva44YmHtaIvf+RG5mXAn6P
         9az0I4S9HbtvIaVK2ucObWYjEySyYEFjWr/RyWqiT+J8qZm/pZ1BUYEbxG73AepQ4yin
         kvxMQAtp7V+L/La1KASVn4dje+h1UjWrgflkljAbajwRYUjDx+yJh7+skSltRDS6b/fO
         thupxmz53R1RJyQUUngJTTahO0RGH3hGeIZTkHwdQdH4Q2puq8sRWG8YuGGh+pbs3mzh
         JfxA45P4MkNTNT6nhvfNkQBujuQ4PvKEn7AlYQpZcrkG/EcegkW0Ox3G2+Nt/+Blueaf
         drlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=s5VJU9uJCWfPnKAhZaQ3OV5FUN/AL9WNy7bNSFP43xE=;
        b=e6BUfX4/FeoGM3+DNwJG6L9OLT7JL0wGXvo9pndph7sXSnMsHL8MUOKCnK2VRwnZD1
         dbC78MwRKruaEMVk0mqG6Bt01ozfQnNavXlFidGXL7poZhEAWhSSaMiWNnZXkbbNAnNR
         GEZ4ir3tgu6G+Ooc4h1yDqvlLu9cwwBscK7ISwBcVoCvBj85vX8KGJIvwh7inbbUNElZ
         7uSLjJBpPaYpSuO4IdEcXalSMUxVmwP9fV+W0uspqIOG4MXSUjxDTRwLh38yYBgFy0y0
         j0LbybnG3orec3IfS2bNYgMgCtULmccUL20Jbgk+TrVuRijKD+cTiu/RekqvKvzTix2J
         mWBw==
X-Gm-Message-State: AOAM533b2QYlqs7YL+R4FQH54Zt/CHfMyVKCwzqkkb0WNCU5bEOvNV8b
        xKuZtafDLMr8/PV6faIon6TE+5UU7y5M7/Fj
X-Google-Smtp-Source: ABdhPJw4qcmf0wvPClHW/5IN8eiz2DQ7WefJ6BGFxm/2a0MtSnhKFprPXfQlT6r7S7N1EwAw+ZJF2Q==
X-Received: by 2002:a65:5b86:: with SMTP id i6mr29123249pgr.62.1632234520737;
        Tue, 21 Sep 2021 07:28:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c11sm18320384pfm.55.2021.09.21.07.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 07:28:40 -0700 (PDT)
Message-ID: <6149ec18.1c69fb81.5ea2.39c0@mx.google.com>
Date:   Tue, 21 Sep 2021 07:28:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.246-217-gad16d239c36c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 130 runs,
 4 regressions (v4.14.246-217-gad16d239c36c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 130 runs, 4 regressions (v4.14.246-217-gad16=
d239c36c)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.246-217-gad16d239c36c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.246-217-gad16d239c36c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ad16d239c36cd7317b8b22cf2e9a57338448ca52 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
meson-gxm-q200    | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6149bf0a39ea706bf199a2e8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-217-gad16d239c36c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-217-gad16d239c36c/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6149bf0a39ea706bf199a=
2e9
        failing since 204 days (last pass: v4.14.222-11-g13b8482a0f700, fir=
st fail: v4.14.222-120-gdc8887cba23e) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/6149d79ba424eb593599a313

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-217-gad16d239c36c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-217-gad16d239c36c/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk32=
88-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6149d79ba424eb593599a327
        failing since 98 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-21T13:01:01.902816  /lava-4549892/1/../bin/lava-test-case
    2021-09-21T13:01:01.908662  [   17.021012] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6149d79ba424eb593599a33d
        failing since 98 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-21T13:00:59.472291  /lava-4549892/1/../bin/lava-test-case
    2021-09-21T13:00:59.488927  [   14.590009] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6149d79ba424eb593599a33e
        failing since 98 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-21T13:00:58.452921  /lava-4549892/1/../bin/lava-test-case
    2021-09-21T13:00:58.458590  [   13.571135] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
