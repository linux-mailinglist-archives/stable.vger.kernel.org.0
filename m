Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34610407D8F
	for <lists+stable@lfdr.de>; Sun, 12 Sep 2021 15:19:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235483AbhILNVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Sep 2021 09:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235488AbhILNVG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Sep 2021 09:21:06 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC005C06175F
        for <stable@vger.kernel.org>; Sun, 12 Sep 2021 06:19:51 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id k23so4468132pji.0
        for <stable@vger.kernel.org>; Sun, 12 Sep 2021 06:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ieYvePUoed2dsnVMhtBnlF/gHcVEInvbjhK84g2Buhs=;
        b=gaDvcRpUdMM1DTxty5Y6h3+eeYCW2NSXnvQ1RUgz3IG5V4xJlwivcdJLCTqoQacagw
         89D4UJlxIXoBKSziyr79IN901OcDnYT/yZW25T9oYFA9joOQw/1TKyAek79eNPTeyoGE
         KD+pexuW80WFWhaK+aF1vtQpHbxOpN+UqOz5nMyvdLL6wRNYuYuX/9UJD1qCaQR8NEYg
         P2213NLaLfbRZYhvkxcDrmgqe1aoYmTlwn/Wau3IevKcOxQwMawFBLSo1WIHLi+Fl/gr
         vKfMlxH72o/Qs/rtp6tv/vaamqVMFzWpOD8/DaWg2xGtHnLRe917tvebrg7wYoa+z1K+
         Ftbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ieYvePUoed2dsnVMhtBnlF/gHcVEInvbjhK84g2Buhs=;
        b=WTh0kukLbLq/xGuKBod6zRA6pjVzMVgsZcN2T3DFcEXrfSEkmtoL3wNoExw+Hh/BDF
         AH6izqT9Ab0A9e8143DyvfIwm+XVfOeORdNvDHRdGhoI9QUAs1/k2H1B9SF05YL5TEBL
         +cY+gtLUO6UGt92F7kWb66WWJI7aLSoX+u+uDULqGngEo7CmLXRYZHhj1qMrCzTJz0k0
         pCrJK2bCaXBPmtXUIuv7gn0qhU8LP+GJVK0fr4W1rNNJJOCak/wEbz3ijHoTfynfKiVx
         nsS4eJn6NljoIAOIiOPOfYLxLC9ySyUKomX/7YYJBihrVbFpKA6GwfEAwM8r2oFWC1MD
         BkYA==
X-Gm-Message-State: AOAM5306vIE1lPKmoMLhCb5H2ci2Ek4UnsB1cr3q3BE0hYQ6xkrzaxk1
        jZemS41JQKr0H6Ww6J6xTTePNpEdpxUIuM4W
X-Google-Smtp-Source: ABdhPJyqqcuB+Adjw8smaOWP3h0cy7juSln8/w9TL0jB+eOHYFZAee80aUt3frF0YeKtdm/c3rtLBw==
X-Received: by 2002:a17:90a:e41:: with SMTP id p1mr7719894pja.137.1631452791143;
        Sun, 12 Sep 2021 06:19:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k3sm3868398pjs.11.2021.09.12.06.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Sep 2021 06:19:50 -0700 (PDT)
Message-ID: <613dfe76.1c69fb81.c8689.a130@mx.google.com>
Date:   Sun, 12 Sep 2021 06:19:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.246-28-g798a88ed9b8d
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 158 runs,
 3 regressions (v4.14.246-28-g798a88ed9b8d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 158 runs, 3 regressions (v4.14.246-28-g798a8=
8ed9b8d)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.246-28-g798a88ed9b8d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.246-28-g798a88ed9b8d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      798a88ed9b8d73285c5e94d324ab638330aa6914 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/613de130136f73b1d8d5969d

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-28-g798a88ed9b8d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.246=
-28-g798a88ed9b8d/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613de130136f73b1d8d596b1
        failing since 89 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-12T11:14:44.750180  /lava-4500960/1/../bin/lava-test-case
    2021-09-12T11:14:44.766948  [   16.653667] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-12T11:14:44.767333  /lava-4500960/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613de130136f73b1d8d596c9
        failing since 89 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-12T11:14:42.320859  /lava-4500960/1/../bin/lava-test-case[   14=
.223112] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probed R=
ESULT=3Dfail>
    2021-09-12T11:14:42.321388     =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613de130136f73b1d8d596ca
        failing since 89 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-09-12T11:14:41.299649  /lava-4500960/1/../bin/lava-test-case
    2021-09-12T11:14:41.305916  [   13.204158] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
