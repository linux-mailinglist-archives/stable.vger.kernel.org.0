Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B17407D2E
	for <lists+stable@lfdr.de>; Sun, 12 Sep 2021 14:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235004AbhILMRZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Sep 2021 08:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231194AbhILMRX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Sep 2021 08:17:23 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3AA5C061574
        for <stable@vger.kernel.org>; Sun, 12 Sep 2021 05:16:09 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id oc9so4375457pjb.4
        for <stable@vger.kernel.org>; Sun, 12 Sep 2021 05:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iGT6BEMUgUr4ldH4R4+Rkee4AdKiQ418ec/r5+ORhFM=;
        b=GkkYD7Vvr0jxeN7V0jjeW2rqaLcfEPvcN/RZtQKBwtmEs+/vSXKFUl9W6gQDofzh++
         5XMm6tLHDnceh4qaBhhXbXl+YGiozQYQQdEhqfIf4w/OQ2vQK5JoVI5LKrNcvpX/H5Am
         bzWHsm2nvD+OhK+Hc9N8s0B5qExRJJE2v2El/W3k7tfSmlBOwvYRKE+dfi0RxcuyzGNv
         5OnkPotDUzx2msyaEb7MvXBeE9pB9KgkUOUzHUP1yfeNEfQnPiTnyFcPs5ABPvX10YmO
         CUwGR6rE98Ay+RHvhTBJlFdOQhhF+oCHL83eUYTHmDRkvDqtOiP98UoSF8suEh7f98if
         V5aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iGT6BEMUgUr4ldH4R4+Rkee4AdKiQ418ec/r5+ORhFM=;
        b=Z3ekge/E2ZH+M3rn79tKuEfKJdy6fPo0hFX4gI3XmkxUvrNUB4aMu1M/HAxzkEK0V0
         cMshyGZm/UN0BbRFDxcLWrTvErw9omHCK1Ks6oap43F4dDmZ7lN3eU0srKEC6HS5TvrO
         +bKhX+YgZ8b82hPIXMvfLeyHZ9eWaXHUximVj6ALds4NqwtEb9u5SCcAIx6sd/AwT9vc
         ceWUK9v9q+7quxscosvwSqN6wFlN7ZYdgD4UuqjExk/5Qaoz4wI1L8c9HxsH5If8YiI2
         U8ocSRp7hpJOflN6nRT3Dw99PtzeJdf5g+NAOn0DSX3KVKfCvHNN8LUk+i/b5NUFZTuS
         9jAw==
X-Gm-Message-State: AOAM530DglqaR+NgsO3AlKt2/9bzFTjjo0QsvS69dqyPFiqFe1+6h9pc
        nvL6wjxqMOWCOtt3Irf7s8oj73ySCrrlyD+j
X-Google-Smtp-Source: ABdhPJyOED6TcgHk+4Mrwg3XiHC7EOKt775p2qn6AcX+MSuTpYV4tHlp48qpIUfSlIozefnX7sslRA==
X-Received: by 2002:a17:90a:d307:: with SMTP id p7mr7352361pju.144.1631448969408;
        Sun, 12 Sep 2021 05:16:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b10sm3995162pfl.220.2021.09.12.05.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Sep 2021 05:16:09 -0700 (PDT)
Message-ID: <613def89.1c69fb81.d5514.a415@mx.google.com>
Date:   Sun, 12 Sep 2021 05:16:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.64
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
Subject: stable/linux-5.10.y baseline: 200 runs, 4 regressions (v5.10.64)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 200 runs, 4 regressions (v5.10.64)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.64/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.64
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      cb83afdc0b865d7c8a74d2b2a1f7dd393e1d196d =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-8    | multi_v7_defco=
nfig | 3          =


  Details:     https://kernelci.org/test/plan/id/613dc011d977b6b3d6d5966d

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.64/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.64/a=
rm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/613dc011d977b6b3d6d59681
        failing since 87 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-09-12T08:53:30.148832  /lava-4499884/1/../bin/lava-test-case
    2021-09-12T08:53:30.166156  <8>[   13.300459] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-09-12T08:53:30.166643  /lava-4499884/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/613dc011d977b6b3d6d59699
        failing since 87 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-09-12T08:53:28.724784  /lava-4499884/1/../bin/lava-test-case
    2021-09-12T08:53:28.730451  <8>[   11.876104] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/613dc011d977b6b3d6d5969a
        failing since 87 days (last pass: v5.10.43, first fail: v5.10.44)

    2021-09-12T08:53:27.711105  /lava-4499884/1/../bin/lava-test-case<8>[  =
 10.856707] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-09-12T08:53:27.711594     =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/613dbfd84b1eee6c98d59666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.64/a=
rm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.64/a=
rm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/613dbfd84b1eee6c98d59=
667
        failing since 3 days (last pass: v5.10.62, first fail: v5.10.63) =

 =20
