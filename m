Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 140713AA82A
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 02:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbhFQAhV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Jun 2021 20:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbhFQAhV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Jun 2021 20:37:21 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD4FC061574
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 17:35:14 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id i34so3469258pgl.9
        for <stable@vger.kernel.org>; Wed, 16 Jun 2021 17:35:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZiKw3cjPd9My+ChbOnNnCnPO5x8G75B+LvK+Yh0ZMzY=;
        b=vUzy/vspAqwUB7j3lWmNgBKQi/S39802k1zVDCczxH4QvbTHfsTmce6Y8XOScSCcjF
         i9jVwq/aY5j7Hwdk2DjLwHDCUVcFdoqRLd6mkoPjt3gsyGWK446lT4bepk8FbQZ/QlDn
         73Ot3MnDRgPTX9EzJ/LQp+ZVhKes2Eifokx13DJSXPmg+aPGRTYwAxTyWjmgu71nqTXC
         aAlvoFTHls7Vi5pH24MZWIR/aNyKtS+Oj2PEH8FJlHnQ7JC/qOZpJPfQR2YwqonPqGPL
         ZC034+iTXz0mlAHbAT2Z9l01sz4WQsEPjPLOdwSYyQnHuv35VAWYzzXj8U3euqNK9YyC
         JnmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZiKw3cjPd9My+ChbOnNnCnPO5x8G75B+LvK+Yh0ZMzY=;
        b=SrJ5Nuh81ztFNrqDa18k6UYI8zIujIRURo9jO+n/kqs5Mnl/yH2wdjeHGW+VHAYxF7
         noy5om0mn1l51YjOFpgqeYWhd21Z5VEPIlmicWgF+Ryam7poJYZdfhJNgkTcRra9vybb
         CzLl2a5Mxsem+PF2A8rbwGqAkxhMpGFscQanC1wvSLB1p2d9oWozd2WL+ZNEHsaYBPi1
         UaApFdMFS8YB6ooS91Vf7rz6rUbRIZSEsLbm7n0uKnwRM2Rq+YvQLPIhyGD9f8qfHbHw
         EIMxgcrG3iz0nfGYAyLB4824DXXkFZkBz8KvagujXK5wDscd7wnU0HWivvMPFqvsnJFH
         O11w==
X-Gm-Message-State: AOAM530zEAfBdeSmj9VJf+lJ/nPawnOURfYXFNEy4YV6gycRDM3rT+PQ
        elRckL54XqgPP56Dsj7Zv3r+t5Wx6wtOkThU
X-Google-Smtp-Source: ABdhPJy2XHdI33ImbzvNy1lR6PlarKyvWroE33zGXEfXMvx6Zs2F4t1jTvLHaH/ZownHJfF2nY96yQ==
X-Received: by 2002:a63:171d:: with SMTP id x29mr2278858pgl.173.1623890113617;
        Wed, 16 Jun 2021 17:35:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w21sm3217224pfq.143.2021.06.16.17.35.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 17:35:13 -0700 (PDT)
Message-ID: <60ca98c1.1c69fb81.ff1cc.9af4@mx.google.com>
Date:   Wed, 16 Jun 2021 17:35:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.273-14-gde9cf6b45df7
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 93 runs,
 4 regressions (v4.9.273-14-gde9cf6b45df7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 93 runs, 4 regressions (v4.9.273-14-gde9cf6b4=
5df7)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.273-14-gde9cf6b45df7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.273-14-gde9cf6b45df7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      de9cf6b45df703077366878a5e7ad4f771635e20 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ca64393a88844dee413267

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
4-gde9cf6b45df7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
4-gde9cf6b45df7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ca64393a88844dee413=
268
        failing since 214 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ca79ab11b22e2ab9413276

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
4-gde9cf6b45df7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
4-gde9cf6b45df7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ca79ab11b22e2ab9413=
277
        failing since 214 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ca64cc21eaae90f5413284

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
4-gde9cf6b45df7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
4-gde9cf6b45df7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ca64cc21eaae90f5413=
285
        failing since 214 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ca977fc0b36770b4413283

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
4-gde9cf6b45df7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.273-1=
4-gde9cf6b45df7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ca977fc0b36770b4413=
284
        failing since 214 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
