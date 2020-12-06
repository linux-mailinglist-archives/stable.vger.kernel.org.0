Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2CF32D064B
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 18:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgLFR0y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 12:26:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726318AbgLFR0y (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 12:26:54 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228CAC0613D0
        for <stable@vger.kernel.org>; Sun,  6 Dec 2020 09:26:14 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id 4so5907104plk.5
        for <stable@vger.kernel.org>; Sun, 06 Dec 2020 09:26:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hEn8RRsigM5mRl03+x+z1YSWLaLXCwxtTOZ44me3tJ4=;
        b=MOolRFo35W+lqOVsJzDIyovBQviVvTUeXOpTy5W2MU8HnjjMftH9G/ZMeoHBeTIakN
         7VINZvuSZ9Q19Y6yqAky4L4vvip6WTxBZ0kNGiKun7jCXLHt57CyYNgCJTrfc1Hifwg7
         cA5PCW9C91I1zmbVi8zoeFEwx7OjZvjG0aw3LGmx9Tz8mm6llCakN+WEQ884lOhNWe8H
         8i2VwCME4fu/SStrXkePWgKwmBLEmWnQsI/ivw05fZ5O4zJGWcvsuPOm53yGghRPZJ5n
         88frL1w2Z9ahpCX5wIqJuZ5fCqfnYsa6CY+BOFHgU4n82vQTYhZcTL/n4bP8vcnTteWy
         A4Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hEn8RRsigM5mRl03+x+z1YSWLaLXCwxtTOZ44me3tJ4=;
        b=VbZrgbqPbveU3FV8U9kUU7mCSAvy5Y82VEZls7rqY3npVvZf0QZGe588zdNw46M2s7
         PmVEQXJv96+TEQx5Put9eC33GBmmfUsPm1uZf5hV++F7pKBCURWtMAk4ofvs2rRvU2T1
         CJnrqtoAt0qzoKziMc5GPMOUQx117ihHgIRONNM0/DB6x4vnuHvLs8ArJ8EEl5PcnpV4
         jSIiHya3SnisHgcmrf04VwuxXsY//YhJ8qUX0MmxaTE7C4UK8Qv1W21EwpydQPY7q+mm
         KSG7CnUb7faRB66jjBKmMFTMivo79pjQoSrT+WAVTwE/n3FeD6mjjc2CzNOa6iVs5bO/
         /OMA==
X-Gm-Message-State: AOAM531kQgT+8LMTnoJA+JKFpcNPKYAKkKTuwU6OM1FTyDUC8Wqb1qyZ
        12/+3XM9mnKsGu8b5EDLQjOQC4fICILt9A==
X-Google-Smtp-Source: ABdhPJxsaTk0xYTFGOc5dtCg26x1uPT94HpF/j5Gb3PNmL4qMHJwAKkQ1vCCAUamiRVbxehuHrgKbw==
X-Received: by 2002:a17:90a:f694:: with SMTP id cl20mr13467396pjb.179.1607275573241;
        Sun, 06 Dec 2020 09:26:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z5sm9471395pgv.53.2020.12.06.09.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 09:26:12 -0800 (PST)
Message-ID: <5fcd1434.1c69fb81.fe7e3.61cf@mx.google.com>
Date:   Sun, 06 Dec 2020 09:26:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.161-32-g475f32679140
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 175 runs,
 5 regressions (v4.19.161-32-g475f32679140)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 175 runs, 5 regressions (v4.19.161-32-g475f3=
2679140)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.161-32-g475f32679140/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.161-32-g475f32679140
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      475f32679140832a72e4aa86cba69838968552cc =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fcce27c668899346fc94cd2

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-32-g475f32679140/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-32-g475f32679140/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fcce27c6688993=
46fc94cd7
        failing since 6 days (last pass: v4.19.160-13-g8733751e476a, first =
fail: v4.19.160-50-ge829433bf8e6)
        2 lines =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccdf03ce7a678b8fc94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-32-g475f32679140/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-32-g475f32679140/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccdf03ce7a678b8fc94=
cba
        failing since 22 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccdf0fce7a678b8fc94cd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-32-g475f32679140/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-32-g475f32679140/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccdf0fce7a678b8fc94=
cd1
        failing since 22 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccdf065ed9f24c5cc94cdf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-32-g475f32679140/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-32-g475f32679140/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccdf065ed9f24c5cc94=
ce0
        failing since 22 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fccdeb0e9813fc37bc94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-32-g475f32679140/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-32-g475f32679140/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fccdeb0e9813fc37bc94=
cc9
        failing since 22 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
