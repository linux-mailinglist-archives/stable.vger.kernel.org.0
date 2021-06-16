Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 513E23A9CCD
	for <lists+stable@lfdr.de>; Wed, 16 Jun 2021 15:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbhFPOAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 10:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhFPOAg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 10:00:36 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF88C061574
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 06:58:29 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id v7so2044749pgl.2
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 06:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9Oc9x7MSlyz8NciWhyhlNHM72A0w42W1d/R60tOMtx8=;
        b=Zk1oFoSRZlDz/rB+lMKYT92D2J4/snAoK7XWvyPcwYGq2mQONVJjcGbsHwN/cN+9tz
         QLwD5PSmuY3ncYNAebeZXczvMkghH3EzaF40IIcke8Ul1cJEQUs9OAAcNEG8R/9Yynhr
         K9RC3//0NkvFP0GRMXp1Jo5EBiQJnwbkG104YzmNTARYlczf40UUQxYXUP4nUC2K3O8u
         sJhCJ+gK1aeMFmZCG+LaoK+0gohkZG+pWLRt+Ds94m6JygHLGvmMCylejq+id6o6KY6v
         486EkbHo8g2XHHGg1r9soDB/ikRNbEiWmr6DyWNrIkJ9wrcZle3TdWP2zwMiuMxAbRWe
         6XZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9Oc9x7MSlyz8NciWhyhlNHM72A0w42W1d/R60tOMtx8=;
        b=cZSx2wCiZ4QUV4pQsn49C1KkcO/7Fvmz8i6vLX3G3nwrZ5csaPe/EHAFxSqt3iM/gY
         Fuq3Kk+MAK/gyWQ2vBdZY9uxbuv9tqOKPy0dWqogAypN06+vsBm3THojKKi59HuK8lxB
         xtntTawE1kSugx7+jRH4DV5VxV11OrlzSLL3eDkUJOccmAXfqVevRAc82byXVdN3LpGu
         U5iX8pB/Lb+eAzpMQnIjI4v1lFx2xRVUS1Imt8+N//XksOkxNWZVe4nqUCu4e1GPzw3D
         kD+A93LmB/4c1nKxViaawRFB12959NlDnama7E0DCr8T1z2wiGKSBXzONg3v7aqJAh0O
         Jkdg==
X-Gm-Message-State: AOAM530nN64A1E+PEFiPdf4A/aLqQVQXuZIoONTzeIVZnTjPt+RNkNCd
        AVBDFe8c/7WuROMi2PqnfiDcQqH9jMMxXyBI
X-Google-Smtp-Source: ABdhPJwXVgHagwlzQa8M7+rbseJFpotLt7D5maOG8JmoRQB4rCCcpX4IbOtZDqPGCBturEM4cvTK4Q==
X-Received: by 2002:a63:e309:: with SMTP id f9mr5036404pgh.443.1623851909140;
        Wed, 16 Jun 2021 06:58:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u24sm2550813pfm.200.2021.06.16.06.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 06:58:28 -0700 (PDT)
Message-ID: <60ca0384.1c69fb81.2d151.676a@mx.google.com>
Date:   Wed, 16 Jun 2021 06:58:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.43-130-g7808ce0f4d94
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 168 runs,
 5 regressions (v5.10.43-130-g7808ce0f4d94)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 168 runs, 5 regressions (v5.10.43-130-g7808c=
e0f4d94)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
bcm2837-rpi-3-b   | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =

imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =

rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.43-130-g7808ce0f4d94/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.43-130-g7808ce0f4d94
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7808ce0f4d94b4bb17efb010185dced955ad6689 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
bcm2837-rpi-3-b   | arm64 | lab-baylibre  | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60c9cc08331d8aee98413288

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.43-=
130-g7808ce0f4d94/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.43-=
130-g7808ce0f4d94/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/60c9cc08331d8aee=
9841328b
        new failure (last pass: v5.10.43-129-ga148e2a9c327)
        2 lines

    2021-06-16T10:01:07.693935  / # =

    2021-06-16T10:01:07.704173  =

    2021-06-16T10:01:07.807462  / # #
    2021-06-16T10:01:07.815703  #
    2021-06-16T10:01:09.073818  / # export SHELL=3D/bin/sh
    2021-06-16T10:01:09.084338  export SHELL=3D[   58.210021] hwmon hwmon1:=
 Undervoltage detected!
    2021-06-16T10:01:09.084583  /bin/sh
    2021-06-16T10:01:10.704442  / # . /lava-454233/environment
    2021-06-16T10:01:10.714942  . /lava-454233/environment
    2021-06-16T10:01:13.662485  / # /lava-454233/bin/lava-test-runner /lava=
-454233/0 =

    ... (11 line(s) more)  =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
imx8mp-evk        | arm64 | lab-nxp       | gcc-8    | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/60c9d0e1a6a05b3f06413271

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.43-=
130-g7808ce0f4d94/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.43-=
130-g7808ce0f4d94/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c9d0e1a6a05b3f06413=
272
        failing since 0 day (last pass: v5.10.43-44-g71862092cb77, first fa=
il: v5.10.43-129-ga148e2a9c327) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
rk3288-veyron-jaq | arm   | lab-collabora | gcc-8    | multi_v7_defconfig |=
 3          =


  Details:     https://kernelci.org/test/plan/id/60c9f25bb12c8d9dd74132bd

  Results:     66 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.43-=
130-g7808ce0f4d94/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.43-=
130-g7808ce0f4d94/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60c9f25bb12c8d9dd74132da
        failing since 1 day (last pass: v5.10.43-44-g253317604975, first fa=
il: v5.10.43-130-g87b5f83f722c)

    2021-06-16T12:45:09.151985  /lava-4035079/1/../bin/lava-test-case
    2021-06-16T12:45:09.157769  <8>[   10.804268] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60c9f25bb12c8d9dd74132db
        failing since 1 day (last pass: v5.10.43-44-g253317604975, first fa=
il: v5.10.43-130-g87b5f83f722c)

    2021-06-16T12:45:10.172776  /lava-4035079/1/../bin/lava-test-case
    2021-06-16T12:45:10.189490  <8>[   11.823876] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-06-16T12:45:10.189784  /lava-4035079/1/../bin/lava-test-case   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60c9f25bb12c8d9dd74132f3
        failing since 1 day (last pass: v5.10.43-44-g253317604975, first fa=
il: v5.10.43-130-g87b5f83f722c)

    2021-06-16T12:45:11.599999  /lava-4035079/1/../bin/lava-test-case
    2021-06-16T12:45:11.619612  <8>[   13.251639] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-06-16T12:45:11.620019  /lava-4035079/1/../bin/lava-test-case   =

 =20
