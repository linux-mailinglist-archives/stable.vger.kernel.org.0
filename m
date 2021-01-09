Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED752F0353
	for <lists+stable@lfdr.de>; Sat,  9 Jan 2021 21:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbhAIUIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jan 2021 15:08:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbhAIUIJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jan 2021 15:08:09 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CA5C061786
        for <stable@vger.kernel.org>; Sat,  9 Jan 2021 12:07:28 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id c79so8476111pfc.2
        for <stable@vger.kernel.org>; Sat, 09 Jan 2021 12:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=f8BayyvJi3vBDzbxFmm9q7F7bMMEUnMmlVrmCt8CqJU=;
        b=AR4/IRhti+CHUYthXto993APy7eZiCFwKZlQfeNGT1jLTJYbwr922ZLTuu6MJHnCfr
         w3FnVJ+HLzzl1Hj3aK58mXeKH7x9a/s+SV+RUCSnpXiOq4rR/XBZ2YBHafsX2IKWZS28
         apTMhWA79SvITiCVLVszTHWnGK7LkiSd8Cf0Gft6Nfb5WCX2zlx8G0vKi9xBmFxjY4us
         0F3XrPS6NjNnIMQtiaM805+oohrEe0JgHsccXkd4ttLfTVvfKjUcRT8OF4K8E/REwIRV
         ROOE5q04x+42xc8iUvYHQV93hYcZ3TfsLWG3etrbkVPLX1qmjH0zWenvhGrNsliAtWCq
         18Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=f8BayyvJi3vBDzbxFmm9q7F7bMMEUnMmlVrmCt8CqJU=;
        b=WqIjSyV4jf0jw8S9IDQ6us6KIutcswcSXeaSK1PiFQYBuWAFcPVdgmbLeiWJsguZuq
         49rfa5Zk0ffymvZCamSjIDjVi8M/gsSYSbRxF+aWhrfNVLya7hzaXsrdxabI3m0MNm4e
         MRFBw+LfLE7Jv1x1IYsmOEiGEVA3B+6JIBM2j4w6lovLjC2FpJS0AvxlvT5LtN1wR5Tp
         VWwN19mbIOjXV2a4b15PIvRw/C9t5EwOKlSgz6xZStEKUBjJnjnXiER07RAXrCDxtGhR
         mAdoRS7sAdt3xphkz4j78nopUWZikdAqEZxL33GtKqGdXOa+AJ0ayfiaUfptQey7gE4S
         s9TA==
X-Gm-Message-State: AOAM5307T87Cj1wGN+eYJXXRi2aqn8TV2ZFOL7Vg14p9nhGUfqr65tN9
        ayS74dpNfIoql8uaGoOrGQSjm5o9YCBghQ==
X-Google-Smtp-Source: ABdhPJyUVprgVMWhuwL5o8bjt9ICKrA5soRTtioYlxtd8XN1wP+viKkT2w2zk7w/3wttzP+uzoSBEg==
X-Received: by 2002:aa7:8b51:0:b029:1ae:687f:d39b with SMTP id i17-20020aa78b510000b02901ae687fd39bmr9790144pfd.50.1610222848174;
        Sat, 09 Jan 2021 12:07:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cl23sm11932539pjb.23.2021.01.09.12.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jan 2021 12:07:27 -0800 (PST)
Message-ID: <5ffa0cff.1c69fb81.8649a.a76b@mx.google.com>
Date:   Sat, 09 Jan 2021 12:07:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.166-7-gc896c168805bb
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 156 runs,
 4 regressions (v4.19.166-7-gc896c168805bb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 156 runs, 4 regressions (v4.19.166-7-gc896c1=
68805bb)

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
nel/v4.19.166-7-gc896c168805bb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.166-7-gc896c168805bb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c896c168805bb7a828de11c881b285d598d06df0 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9d93dc922493c85c94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-7-gc896c168805bb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-7-gc896c168805bb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9d93dc922493c85c94=
ccf
        failing since 56 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9d941c922493c85c94ce4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-7-gc896c168805bb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-7-gc896c168805bb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9d941c922493c85c94=
ce5
        failing since 56 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9d93694a3b1ec11c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-7-gc896c168805bb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-7-gc896c168805bb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9d93694a3b1ec11c94=
cba
        failing since 56 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff9d8eccb96094c31c94cef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-7-gc896c168805bb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.166=
-7-gc896c168805bb/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff9d8eccb96094c31c94=
cf0
        failing since 56 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
