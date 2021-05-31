Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548943963B1
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 17:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234258AbhEaPbb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 11:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234712AbhEaP2B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 11:28:01 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98741C061345
        for <stable@vger.kernel.org>; Mon, 31 May 2021 07:19:31 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id u7so5307204plq.4
        for <stable@vger.kernel.org>; Mon, 31 May 2021 07:19:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nJYosoRxVv/tNI4UfWUXFjy5FZGD4lW4Ki8aC1BzBJQ=;
        b=QrYSv+hC2iDHn7uU95xMIyPrng5kHj9kWSUzHCf94kAQuppGAn8z1kxlO1r5lDm8NE
         o8ioqWXNw7nzrSt+NRuOV0kDeS8Z2X+xeDthF/YwkBDyAqg7ktmAljHgwfDMfxzbOOBY
         sEMw8Wq8/ftIh8UNDVechPoQBVqE5hCQTpP2oK4xgqgBgRHpbyi5LDomZPz+mEWAJlao
         9e2dwXlfywvZtnguzv7GglyNLJ82baaSEy/Pil4QU8Efu/vzeQgwoKzgta+EDHJetYfq
         WKMFp5tRTMCmgrizQTw9kKPkoluHjnxBle+pinDuMClXWDUHmor1auNY4fRfyAXpEE6O
         HyIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nJYosoRxVv/tNI4UfWUXFjy5FZGD4lW4Ki8aC1BzBJQ=;
        b=UGOeOTzecJmayuakYzlR1CtbLpID2Ahws5EYp16j1Y72+vmRPd0XETAyUrmXtmUbUq
         kYPHW/eSXu2Vk4joS3I7TNz5E7lRxZ1Is9SV1dD1D5LoNVCR3JsOl94bNfUG72kqgEkD
         YH4Orxijebi0e1hClUVvtIPgQoljviiQCG0rzQJMu/URAaBNV6pfXgoGs9Rpz5S+7c2l
         xS65ijshOqIQzSGjxEYXOLDxIOTNTiE1C76JHjBQQPt1RLgnrZiImu6/gSJDpF8eXAab
         aq0hABJh2DX/Pb+aCE7CbZkb8XlUEnR96gWzmwOBxh/q27XyIkT1LDTXJhWC7ckVFZjl
         eW9A==
X-Gm-Message-State: AOAM533ex/POwK27xis+DY5Y71f9fQarhVuvMcNU0JvRDG+n7h7emMH4
        NHZHiM6H0WhbE6cP+OhfKFBTF19SPCg7IMQd
X-Google-Smtp-Source: ABdhPJyzWBfMAR0BMgADRBdfDUfIFR0u5viU5sfRE40Qbs1fyatiqei5Q4rFsNqGCNTUpA6bmlc1qw==
X-Received: by 2002:a17:90b:3001:: with SMTP id hg1mr7434477pjb.169.1622470771146;
        Mon, 31 May 2021 07:19:31 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t7sm11143743pjr.29.2021.05.31.07.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 07:19:30 -0700 (PDT)
Message-ID: <60b4f072.1c69fb81.7c2f4.34a1@mx.google.com>
Date:   Mon, 31 May 2021 07:19:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.234-80-ge7a184d13d43
X-Kernelci-Branch: queue/4.14
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 99 runs,
 4 regressions (v4.14.234-80-ge7a184d13d43)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 99 runs, 4 regressions (v4.14.234-80-ge7a184=
d13d43)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.234-80-ge7a184d13d43/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.234-80-ge7a184d13d43
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e7a184d13d439aa4f3f3ccb059c7f9cc00ada20d =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b4b78892806621d9b3afac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-80-ge7a184d13d43/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-80-ge7a184d13d43/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b4b78892806621d9b3a=
fad
        failing since 198 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b4b77ebc63e58f10b3afae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-80-ge7a184d13d43/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-80-ge7a184d13d43/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b4b77ebc63e58f10b3a=
faf
        failing since 198 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b4b7a4525f0b8ad3b3afb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-80-ge7a184d13d43/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-80-ge7a184d13d43/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b4b7a4525f0b8ad3b3a=
fb6
        failing since 198 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60b4b730d862549c03b3afa2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-80-ge7a184d13d43/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.234=
-80-ge7a184d13d43/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b4b730d862549c03b3a=
fa3
        failing since 198 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
