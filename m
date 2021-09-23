Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A30416164
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 16:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241681AbhIWOta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Sep 2021 10:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241661AbhIWOt3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Sep 2021 10:49:29 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E22CC061574
        for <stable@vger.kernel.org>; Thu, 23 Sep 2021 07:47:58 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 145so5920198pfz.11
        for <stable@vger.kernel.org>; Thu, 23 Sep 2021 07:47:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IoogQbj0yNE51RL6Lb0O1GUu8KwRvUPUYSB61sS98Fw=;
        b=mT4uUCfva06MwGXcpeA5pjkPvBHpgVzGrbOBS5Dm623I1pkJXXGr5LZ/F4NKAlCSxx
         pOJvE0rTAfUtJln00zE3Qu2yK6USPkaHNYD+Xmg0yU3ZHLCNdWL+XJJT3lRaSYtgmc8M
         zc7acHwOR3qdlF0PpnE06NsIHudQqKboABVr1oQsqmfdESxH4ZX6evy0F0s8QGf4rwVJ
         sEubPDzxpaRrfzGvpbfSFYVy2qBtvarUQ7WOySN1A5cX1R8t/jDi6mp7VWmTxzT/C/mA
         r0BqX0fS61Sh5bse+5v9EI4/0ed0L5byLxOfp/pSG7oX+nZHJv8ZYZgcvYODtNP2q+Dm
         u8lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IoogQbj0yNE51RL6Lb0O1GUu8KwRvUPUYSB61sS98Fw=;
        b=AjYVterUFBcv/DPjiWWkibr87VKGkrqQef2CebKP6Z2qNmDTZDoNRdgJwe48+/RXNX
         fCbdXs2mQ4Ifo7CEqsCqntzx44mhHu8zFO8C2vnVqHyluRkCXyRxKSOIZU3Qu0kTfQpc
         XBE2CsSmxl1alO+Q2uZuwEg41dD9wf2VAjKLIkMvwRZIUGp2/cYmO3pUsUjAjr2+t+X7
         k/AvPu4lEovaZBRM2vdzYvQb6z6DaWIW3bG2+nUBsLhZmwSSSa4XBgo36tC2Qrw7T5DK
         8/HLlQp770D0xOo24O4GcbZv+4jkrfsz9hiAynuE88IPhnzzrEMTAXjse1XDUNLkwWQk
         Z97g==
X-Gm-Message-State: AOAM533NEVbDJGNikjeBEx8esuYPDhcEeQ7HaA87ZnCj6dKLHFXnYP2W
        +GEyO2dj3DVZv721jeOMdeGGD7HV5aNB81Is
X-Google-Smtp-Source: ABdhPJyr0w2P5346aSTxQTJygeowaItg62HfOZPjGG69Fw1goEEtZbqaKRnXliNx8xhDuJS3q7noEQ==
X-Received: by 2002:a65:6389:: with SMTP id h9mr4573176pgv.83.1632408477401;
        Thu, 23 Sep 2021 07:47:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b13sm5384050pfp.82.2021.09.23.07.47.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 07:47:57 -0700 (PDT)
Message-ID: <614c939d.1c69fb81.6d72c.f4bf@mx.google.com>
Date:   Thu, 23 Sep 2021 07:47:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.207-5-gded7d54eb0eb
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 150 runs,
 4 regressions (v4.19.207-5-gded7d54eb0eb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 150 runs, 4 regressions (v4.19.207-5-gded7d5=
4eb0eb)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.207-5-gded7d54eb0eb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.207-5-gded7d54eb0eb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ded7d54eb0ebb8d9cf572c76906240fb59634a08 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614c5f37fd8001993f99a2de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-5-gded7d54eb0eb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-5-gded7d54eb0eb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c5f37fd8001993f99a=
2df
        failing since 313 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614c8f5aa7115de45899a33f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-5-gded7d54eb0eb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-5-gded7d54eb0eb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c8f5aa7115de45899a=
340
        failing since 313 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614c5f4c6a4daf23b699a30b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-5-gded7d54eb0eb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-5-gded7d54eb0eb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c5f4c6a4daf23b699a=
30c
        failing since 313 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614c6a812f4baa842499a2fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-5-gded7d54eb0eb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.207=
-5-gded7d54eb0eb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c6a812f4baa842499a=
2ff
        failing since 313 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
