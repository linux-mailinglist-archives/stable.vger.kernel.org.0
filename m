Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A07A3ADDCA
	for <lists+stable@lfdr.de>; Sun, 20 Jun 2021 10:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbhFTIzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Jun 2021 04:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhFTIzU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Jun 2021 04:55:20 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465EEC061574
        for <stable@vger.kernel.org>; Sun, 20 Jun 2021 01:53:07 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id o88-20020a17090a0a61b029016eeb2adf66so10499449pjo.4
        for <stable@vger.kernel.org>; Sun, 20 Jun 2021 01:53:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Xo35FVg5agtkECEoqU7wTro2biSLjSH2Y15bdyVYBN8=;
        b=vbXEQU4kB+5RHv+8CsclJRIN9Ta1aibJiKkkHT0YP46HKuVT2JFH6niqbzowDKkrR8
         EeTwoxFmVkHv5VnbjhvAdlvGgyJVJCPVwbPucVTFbqCbHj94TBcu5+dFiWvVl8rJQX0j
         ddPhy2WfnXcF6WSHk+bOzX1BzSu3ArpgylpLIXHtq2R6V2ltbP0HjoaUWGrfnc/44wBj
         xmyB7vg1cEU8Q9n4gV2gI4NsbmTanwP7DVNjD0csuP17MlL3vPoQBmgT7VjfU13l0FuT
         C0wcztLb/OgDXdm0/brMFcSCZETc+xCIIWo8Il9s1bgtBRztrCnzw5n7JoPCqqx1cWqi
         3aiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Xo35FVg5agtkECEoqU7wTro2biSLjSH2Y15bdyVYBN8=;
        b=GFOtUWx4Lt5d13cxIG2uoTg9doSzITKBdbIOkNn18Xr1GNy0uWxqPPTeuZuYzlONw/
         wkGtCSURJi9drxnO9Mk51nNszZMUKlDQOFG8L1U4+h+/5njhCSLNzGfxLQasZ9o69W+c
         zruouTN0JlxgNyCBhqUY21iuQioJ4lHs9osTItKkxRPsmTxQYVTCgeUkJd0iJh/I2Qkz
         /Q00b8ZbVUN5Nr7EvnEM8QwE+tqL201FJ8QEV9YoNLC6b0pITQ3cPD+eY3baJcSNVImR
         z4/oZ3z5Y1F1ndv/Xqu8NbD7xzL0nX+MJq9NCi9VMDbOtqr8xEjlaymHO5/aFP6ltHIN
         rv7w==
X-Gm-Message-State: AOAM533PmVyfqXYMSYXKNxh89p0tYVJljozJVxFrTzx/ZhLKq0YQs8Up
        656159bpAiHXXN/gV8mbXSseeXEXoU1GAKSp
X-Google-Smtp-Source: ABdhPJw/m1J+EV3ZyNcVNIuhzOMgiRSG8WP+VgzP0HiaWncKxm6C8Md9lVLpOPs+Efk2Ju/o83Gv7A==
X-Received: by 2002:a17:902:7590:b029:11c:432f:d1ec with SMTP id j16-20020a1709027590b029011c432fd1ecmr12728800pll.59.1624179186513;
        Sun, 20 Jun 2021 01:53:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z15sm14232690pgu.71.2021.06.20.01.53.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Jun 2021 01:53:06 -0700 (PDT)
Message-ID: <60cf01f2.1c69fb81.3613b.735a@mx.google.com>
Date:   Sun, 20 Jun 2021 01:53:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.127-42-g1ee11bded1e2
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 176 runs,
 4 regressions (v5.4.127-42-g1ee11bded1e2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 176 runs, 4 regressions (v5.4.127-42-g1ee11bd=
ed1e2)

Regressions Summary
-------------------

platform           | arch | lab           | compiler | defconfig          |=
 regressions
-------------------+------+---------------+----------+--------------------+=
------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre  | gcc-8    | bcm2835_defconfig  |=
 1          =

rk3288-veyron-jaq  | arm  | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.127-42-g1ee11bded1e2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.127-42-g1ee11bded1e2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1ee11bded1e2e7c4854c1e75a812ab998e4298c3 =



Test Regressions
---------------- =



platform           | arch | lab           | compiler | defconfig          |=
 regressions
-------------------+------+---------------+----------+--------------------+=
------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre  | gcc-8    | bcm2835_defconfig  |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60ceca6894b99cab83413303

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.127-4=
2-g1ee11bded1e2/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.127-4=
2-g1ee11bded1e2/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ceca6894b99cab83413=
304
        new failure (last pass: v5.4.127-6-g1751b91b70c2) =

 =



platform           | arch | lab           | compiler | defconfig          |=
 regressions
-------------------+------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq  | arm  | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60cedeab9755e16f7e413266

  Results:     66 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.127-4=
2-g1ee11bded1e2/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.127-4=
2-g1ee11bded1e2/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60cedeab9755e16f7e413283
        failing since 5 days (last pass: v5.4.125-37-g7cda316475cf, first f=
ail: v5.4.125-84-g411d62eda127)

    2021-06-20T06:22:28.954961  /lava-4063288/1/../bin/lava-test-case<8>[  =
 12.359826] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probe=
d RESULT=3Dfail>
    2021-06-20T06:22:28.955371     =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60cedeab9755e16f7e413284
        failing since 5 days (last pass: v5.4.125-37-g7cda316475cf, first f=
ail: v5.4.125-84-g411d62eda127)

    2021-06-20T06:22:29.968515  /lava-4063288/1/../bin/lava-test-case
    2021-06-20T06:22:29.986549  <8>[   13.379266] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-06-20T06:22:29.987089  /lava-4063288/1/../bin/lava-test-case   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60cedeab9755e16f7e41329c
        failing since 5 days (last pass: v5.4.125-37-g7cda316475cf, first f=
ail: v5.4.125-84-g411d62eda127)

    2021-06-20T06:22:31.410046  /lava-4063288/1/../bin/lava-test-case<8>[  =
 14.803743] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-06-20T06:22:31.410478  =

    2021-06-20T06:22:31.410717  /lava-4063288/1/../bin/lava-test-case   =

 =20
