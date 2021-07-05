Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 331CD3BBE31
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 16:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbhGEO1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 10:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231355AbhGEO1O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 10:27:14 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD59DC061574
        for <stable@vger.kernel.org>; Mon,  5 Jul 2021 07:24:37 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id b5-20020a17090a9905b029016fc06f6c5bso55244pjp.5
        for <stable@vger.kernel.org>; Mon, 05 Jul 2021 07:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IQAPz3fu/OEOwZ6oYMbF2x7SIf+kG3BbOtPPpEmo2TY=;
        b=ZamWGSpcA4iWU3x/Ep0Z4enNuNf084UCXsRfG3F+zd/RjWso7gvmcqj+NPyugaHZJd
         Kf3PNbmnjHw2sxTRw7VFeosLuYO/R1R4p5Ewk18O1X9b9x6eWjq+iEBo2a36dOroXSmV
         D7YEseOKgX9BO8WPf0LG2f4BVZ+HXVpo3fkyRGPRDIrlW21VhPIH8fUniT2kWdzac+20
         cMrqCvIPDeE5vKZPGVxly/uRwAbigegUePV1c4W9WXTVw/KaO895Ru7sn3VCsieD0USA
         a7/6++1uk1VdANGX+8gNzrFkgo4YK4r2dwdqw0SUl995GkicbRnOlXfW8ketRseQYg/+
         m//w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IQAPz3fu/OEOwZ6oYMbF2x7SIf+kG3BbOtPPpEmo2TY=;
        b=QKis6Ls1D7LE5Vo/ZwTE+jDKSFwctFAu/eKGUYRyhy0jNTc+7rLsqpWLlHOxitmWco
         dIMWfBUNrbboxsnZK0EGNOn7WGDPNT2WY0efLIM5m2oU44aYIRjbP5OvvqYpPY4ZL4+3
         blPWbhoDbu7FOEzjA7haEYJ6LygBd5S19redFNJ5jIblUk4awWMD2Y9MgS9y8J7pfxgt
         pRhhpeGLrC24WsKQFGZr17F+VURXnRtoQsgzfSa5BiY/obDdfwaQl+R6I25IcP9Ur5zK
         39IO3A8Gi2+AQPO7aVV9S3H3mnK7X1U4O25fdpnIShHpg8doga3YOAaSr0OGJz5UIjr6
         mDOg==
X-Gm-Message-State: AOAM533NLjI4WU75bbMcPo5N3bcQJQiSgZ8cVt6NCy7kAqVb7h41MmlU
        8tLawvlnKqM5GAccXhgEQfX5HdkuKLMzHfhF
X-Google-Smtp-Source: ABdhPJyHTgsDfJQG5rJ5O+EJxjiuhl+oeIxlZjFFM4sxxWyAZYvD3vrFsAi8eRizxQnbro3rkyCh5g==
X-Received: by 2002:a17:90a:f2d6:: with SMTP id gt22mr8920913pjb.85.1625495077295;
        Mon, 05 Jul 2021 07:24:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j6sm14630070pgq.0.2021.07.05.07.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 07:24:37 -0700 (PDT)
Message-ID: <60e31625.1c69fb81.e767c.bfbf@mx.google.com>
Date:   Mon, 05 Jul 2021 07:24:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.129-5-g15ba6dc71e8f4
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 177 runs,
 3 regressions (v5.4.129-5-g15ba6dc71e8f4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 177 runs, 3 regressions (v5.4.129-5-g15ba6dc7=
1e8f4)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.129-5-g15ba6dc71e8f4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.129-5-g15ba6dc71e8f4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      15ba6dc71e8f49472d86a147c1a90f2409438375 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/60e2f35c7265469bfb11799e

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.129-5=
-g15ba6dc71e8f4/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.129-5=
-g15ba6dc71e8f4/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60e2f35c7265469bfb1179b6
        failing since 20 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-05T11:56:07.541501  /lava-4141104/1/../bin/lava-test-case<8>[  =
 14.642859] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-07-05T11:56:07.541820     =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60e2f35c7265469bfb1179cd
        failing since 20 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-05T11:56:06.128255  /lava-4141104/1/../bin/lava-test-case<8>[  =
 13.218858] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-07-05T11:56:06.128871  =

    2021-07-05T11:56:06.129275  /lava-4141104/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60e2f35c7265469bfb1179ce
        failing since 20 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-07-05T11:56:05.092081  /lava-4141104/1/../bin/lava-test-case
    2021-07-05T11:56:05.097610  <8>[   12.199277] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
