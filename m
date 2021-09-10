Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C10D40721E
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 21:48:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbhIJTtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 15:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbhIJTtb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Sep 2021 15:49:31 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBB3C061574
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 12:48:19 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id n18so2765497pgm.12
        for <stable@vger.kernel.org>; Fri, 10 Sep 2021 12:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qI9GkE82Vg6VLXkaHLjmNvv372kkBQMVjqqC3bAE8QE=;
        b=rUQMJaa+hdJvn6P4Fx37hNuehZmc9cEGVx+tj3/ON/0jnlKOu/LGtZvRz/rk4nLCdM
         nIC9FbjDWR8B3QNei0Ydzyw+c/hy8C9DHlbVND02Cx8ESObXsVsylfaqFFkJmWMKMPfR
         rSOuhkGpTj5liX0fBwjMDZYfvcPNXU0ZinOij7csXYnb5TuA9auU7RITZl4X1400WrAJ
         SFl0zHBTKLFV7yBmQEG1HtEdaJFrki6efwvf7S6+WPojoPVI9B1z5jVV6ls703X8M0Mn
         psq4bJ9MO6fV0Ozdtpknc2G8y38M0rW1Gun998zABJiZfk0Uo5r9bg/yIY4Ly10wzqAW
         r5sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qI9GkE82Vg6VLXkaHLjmNvv372kkBQMVjqqC3bAE8QE=;
        b=uyfS7SIArVnIRqKTmLS71ONGCexHGJCa6kLbY9bG2htaY+20qjQjVsKvaqNjWA6viy
         Tk7hwoiP2z5+HBr3kFcPCsm32liI4Zc0/vpZaNx/K5iLPg4oiBuSWPRP5xr9/t+46i8+
         HJH3yeDWuLOFOhPnWzsY+y7FDAxZe85ZaFF2R+xznCStzaJdv5a0YA+8aVXIdEur+jG9
         g9zstWDLu6XvazitQderJkbgEvED/ZoZZFqcyyQQJAqPXSBygVjP6zsQyWS5D8sC9YN5
         geVOYDaAphXXj9fEn9u1XH29yHjpia1vphT8qepIjjK4FHAVkIJy2vRJoizR0WnZA6zD
         woFA==
X-Gm-Message-State: AOAM533Y+GJGExGQguq/qaUCA9Z+5adwmZUaH3kQSRuNAQRXrmJmUQsC
        uxvGi/UBBVtqFBjGX+cCsItHyJIJ7ltmgBRC
X-Google-Smtp-Source: ABdhPJxzQlwi3q5aGaAmBrYJOStEN8qGQx2MoFlXghQ5aFXI/3lGMSyrlpf4BncwezUlhuLzKpj7NQ==
X-Received: by 2002:a62:b515:0:b0:438:42ab:2742 with SMTP id y21-20020a62b515000000b0043842ab2742mr227276pfe.77.1631303299127;
        Fri, 10 Sep 2021 12:48:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w192sm5813766pfc.82.2021.09.10.12.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 12:48:18 -0700 (PDT)
Message-ID: <613bb682.1c69fb81.ab370.0f95@mx.google.com>
Date:   Fri, 10 Sep 2021 12:48:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.144-37-g65b75bebdbd4
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 183 runs,
 3 regressions (v5.4.144-37-g65b75bebdbd4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 183 runs, 3 regressions (v5.4.144-37-g65b75be=
bdbd4)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.144-37-g65b75bebdbd4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.144-37-g65b75bebdbd4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      65b75bebdbd4870341d792d406fd083d36d099e3 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/613b9f6bed1f0b58e0d59677

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.144-3=
7-g65b75bebdbd4/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.144-3=
7-g65b75bebdbd4/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613b9f6bed1f0b58e0d5968b
        failing since 87 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-10T18:09:28.962965  /lava-4492825/1/../bin/lava-test-case<8>[  =
 15.124358] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-09-10T18:09:28.963300  =

    2021-09-10T18:09:28.963498  /lava-4492825/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613b9f6bed1f0b58e0d596a3
        failing since 87 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-10T18:09:27.521076  /lava-4492825/1/../bin/lava-test-case
    2021-09-10T18:09:27.537868  <8>[   13.699049] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-09-10T18:09:27.538101  /lava-4492825/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613b9f6bed1f0b58e0d596a4
        failing since 87 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-09-10T18:09:26.500783  /lava-4492825/1/../bin/lava-test-case
    2021-09-10T18:09:26.506933  <8>[   12.679498] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
