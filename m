Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A5836B2A7
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 14:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbhDZMBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 08:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbhDZMBJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 08:01:09 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C89CC061574
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 05:00:26 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id t13so2798963pji.4
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 05:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8FZw7tSK0z8aom+EHfOJg0c/+J7y4PwHUzc+gMzqteU=;
        b=UtOp4qLap+lLAAxrMw+whgCyft47Jux+R7UpXrxCGoHWf8fTg7XAJy+aaFsSNtsogA
         g5hpad6KDlX8ACGJtWTCkLjirkGnrOxfyEfmPncTKAWURoO4OEq1dYrzfh12FCFV3tZh
         0Gup+0NYUqyFDLEJCLxJIeYLHupFuy051mHhpSWK062yXKsJ7d8LLSw9YsNg7fkCpUVo
         m4h2ff0Uh1zUDRlgwqHZE6bVHEPV1zZhDQDjH4sJq8hYfn8CAHMfnKsaGO+QWwW5Dun9
         r2+Z64MB3CUzYRmFH/lSy+VLhW2J+WH9nqyZczmuPSus2d10EFznBcPaHyEleays74QA
         +f4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8FZw7tSK0z8aom+EHfOJg0c/+J7y4PwHUzc+gMzqteU=;
        b=TY/L/21Mf7SeEF0Ga3Oms+yXlMKMMdszsz2D5h7htsT2GKA2rYY7f2aD9HN8vI3K8C
         LOYANzhKH9+J1uJC2kRMLEQbRimZjhvyhAV5ODoEVcqxr6cYQYE52P4fbZyB+IZCg3S+
         7XpVMYQ/BW16mPNOieVyxocinfQ+6fD2sKDB/MrPZmn5/utyAdo47sPi/tVJ3As1tBz7
         uqH80C/SetWiuOx2XhezMeZtx7irHptH6UCl4Ww2332qbCS/KmuYAciC6ycebjiq2JSg
         rv2MxSfwMOISurerihNKJv2ieSRGUhcPiAIB6NJxXtPhnufuZ/jdMMVEiPLqOE9FqruC
         5XhQ==
X-Gm-Message-State: AOAM533jWnN+aVX0/5eNiFZHC+JGlcAOTv2ryRtoi6GKMATiKYnwEmGy
        9tSJaWQktdebK6x0nnbdlw6AiCvNelyFVdyj
X-Google-Smtp-Source: ABdhPJzt+4Qr5xLPrW1A4iqGaPALSopQsjtCLi4TdjJP56fl1eXatZTZI7U0PEKUVhOkxbLwC0RGsQ==
X-Received: by 2002:a17:902:e849:b029:ec:f228:3163 with SMTP id t9-20020a170902e849b02900ecf2283163mr12220699plg.36.1619438425006;
        Mon, 26 Apr 2021 05:00:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n85sm11734564pfd.170.2021.04.26.05.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 05:00:24 -0700 (PDT)
Message-ID: <6086ab58.1c69fb81.3b558.2667@mx.google.com>
Date:   Mon, 26 Apr 2021 05:00:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.267-37-g2f0e7f478f929
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 100 runs,
 4 regressions (v4.9.267-37-g2f0e7f478f929)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 100 runs, 4 regressions (v4.9.267-37-g2f0e7f4=
78f929)

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
el/v4.9.267-37-g2f0e7f478f929/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.267-37-g2f0e7f478f929
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2f0e7f478f929a413368e821c6680ca3163d614d =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6086769969aa83c8fa9b77a8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
7-g2f0e7f478f929/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
7-g2f0e7f478f929/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6086769969aa83c8fa9b7=
7a9
        failing since 163 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/608676a9d9072cf56b9b77d2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
7-g2f0e7f478f929/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
7-g2f0e7f478f929/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608676a9d9072cf56b9b7=
7d3
        failing since 163 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/608676b11f873111619b77c1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
7-g2f0e7f478f929/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
7-g2f0e7f478f929/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608676b11f873111619b7=
7c2
        failing since 163 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60868d582694b8e7b59b779f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
7-g2f0e7f478f929/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-3=
7-g2f0e7f478f929/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60868d582694b8e7b59b7=
7a0
        failing since 163 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
