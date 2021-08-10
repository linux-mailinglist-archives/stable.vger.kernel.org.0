Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE783E50A2
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 03:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236375AbhHJBcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 21:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbhHJBcF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Aug 2021 21:32:05 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA48C0613D3
        for <stable@vger.kernel.org>; Mon,  9 Aug 2021 18:31:43 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 28-20020a17090a031cb0290178dcd8a4d1so539427pje.0
        for <stable@vger.kernel.org>; Mon, 09 Aug 2021 18:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WYDG32egTw+zjnhqC3mu2NRyjYh6JIiTCJDWbJf5yUY=;
        b=v3YXrfCU0ExdszPYDaHI4sjtizfTTfkDfIHc8WkPPKQzAOx6LWOBIro+VkMEb+yIgJ
         nzyy3kPBnqpBgFzg8MqW6N2IWY7yLnMdlCbtGwunYWnTcFhU0dm8DQpPMdoW/Roy06qd
         m8Bktti98rXIhsYOrfykA9Yxy62up+CYm5kEjZ5V9/GjhyeecJyGjBcxImnhdvxOtt3k
         RAJcAQPW1Xw5SKVOWldufLhEo/IiZqx9oM/PAm7iPFs0pkGjyxlcz3a0UUprIv/T8p8S
         coQhqYW2cotuTV/fsUk1wHbF/6b+YQAAONuhM6+A7F5KOYkxOHxIZ/hZg0vQCQPNx2jt
         cM9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WYDG32egTw+zjnhqC3mu2NRyjYh6JIiTCJDWbJf5yUY=;
        b=I/kFuzDyr9+aRltlp9+Qn6CJyjjAN+foNZkT4hzp3s8bkkERwOfLBjX8hdvtmzpQt0
         VkcA3MrmIQg9l18q97MEbEt2i0RH6e3rfc1wmmszoF0ozhf1WOEraix20mKdDYz3rZ6V
         +6Z8pz2Q1XHrFfH2H5MJk/HJjATYLzrYm4IfKPo8NZg8rTswWBqkCc9DJSqKGSLaRk0L
         s4WTvnypBoh57JIM9BM2V9Qjfsv5ro9n6ZTV8u/fc9KF/lCGQWPIFRwy6JSadJGeJh7t
         qQ11RznU7ejIBB3PO8Z4C3HPkNZeGjie2xfe/O6tLzmLsDevHIJtIXYy31jfp/9bcBFS
         D82g==
X-Gm-Message-State: AOAM5338IsS6hjknw4bnaYim8hgcmLzZS09cuyPQCt7qY4Hs3V1kfoYv
        lSIuvOjtRZOg6opsuVeKk0mIqr2eQpHAggph
X-Google-Smtp-Source: ABdhPJxFUl/4eDOLvPIKwg8AmDeM+YHElHw7NN5LAaxh56Ef1yBM2IMehX2SmFx6PbKO9UlLkcPlYA==
X-Received: by 2002:a63:da14:: with SMTP id c20mr221382pgh.155.1628559103103;
        Mon, 09 Aug 2021 18:31:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 1sm9241573pgm.69.2021.08.09.18.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 18:31:42 -0700 (PDT)
Message-ID: <6111d6fe.1c69fb81.1e37f.baad@mx.google.com>
Date:   Mon, 09 Aug 2021 18:31:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.243-33-gae655cd5fc62
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 142 runs,
 5 regressions (v4.14.243-33-gae655cd5fc62)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 142 runs, 5 regressions (v4.14.243-33-gae655=
cd5fc62)

Regressions Summary
-------------------

platform          | arch   | lab           | compiler | defconfig          =
| regressions
------------------+--------+---------------+----------+--------------------=
+------------
jetson-tk1        | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =

qemu_x86_64-uefi  | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig   =
| 1          =

rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.243-33-gae655cd5fc62/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.243-33-gae655cd5fc62
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ae655cd5fc626a8de86bc111fbd3c8b7f81fe4aa =



Test Regressions
---------------- =



platform          | arch   | lab           | compiler | defconfig          =
| regressions
------------------+--------+---------------+----------+--------------------=
+------------
jetson-tk1        | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/61119c83bd308e2d20b136c5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.243=
-33-gae655cd5fc62/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.243=
-33-gae655cd5fc62/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61119c83bd308e2d20b13=
6c6
        new failure (last pass: v4.14.243-12-g37f0bfac0295) =

 =



platform          | arch   | lab           | compiler | defconfig          =
| regressions
------------------+--------+---------------+----------+--------------------=
+------------
qemu_x86_64-uefi  | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig   =
| 1          =


  Details:     https://kernelci.org/test/plan/id/61119db951a176440bb13686

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.243=
-33-gae655cd5fc62/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.243=
-33-gae655cd5fc62/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61119db951a176440bb13=
687
        new failure (last pass: v4.14.243-12-g37f0bfac0295) =

 =



platform          | arch   | lab           | compiler | defconfig          =
| regressions
------------------+--------+---------------+----------+--------------------=
+------------
rk3288-veyron-jaq | arm    | lab-collabora | gcc-8    | multi_v7_defconfig =
| 3          =


  Details:     https://kernelci.org/test/plan/id/6111a08f03aa5b52bfb13683

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.243=
-33-gae655cd5fc62/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.243=
-33-gae655cd5fc62/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6111a09003aa5b52bfb1369b
        failing since 55 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-09T21:39:08.589402  /lava-4338023/1/../bin/lava-test-case
    2021-08-09T21:39:08.599953  [   16.548952] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6111a09003aa5b52bfb136b2
        failing since 55 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6111a09003aa5b52bfb136b3
        failing since 55 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-09T21:39:05.148102  /lava-4338023/1/../bin/lava-test-case
    2021-08-09T21:39:05.152924  [   13.099803] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
