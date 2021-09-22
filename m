Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF7F34142A7
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 09:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233170AbhIVHde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 03:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbhIVHde (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 03:33:34 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14D9C061574
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 00:32:04 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id v2so1166521plp.8
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 00:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WhRtpiib2JoVvHyAA7EAvqFNqcN5V67xc7oHXeo1798=;
        b=cyylQBrl/joArkwtgzJk94J5X97Se2FuyO7SWvlBl+W1LfMoDeMKS0j5q9jIDiZmFt
         ZReV/g+8tH0VrJhhEXKlZKbyZcgTIUsSDhztuYSIa8+xgrtPWLNHG24ToeFUMYVz9Q1W
         LYVQk+gqg10RJWNtBB5bklAzq2tTTgbF6yJgSufzhqmPCENIWgfZgjYYEjuycUhatkHu
         J3tJcQDhZBtFVm/nVFp/cBB0dtTI8Y4mQoffydRiAcR43fUOpUaXDpULkMA129E0W9H6
         7t9Ibs9aXTiCzGFo6h03Qd81NQGXpLJ0pO+lAIjzZHdOgFY6UrDDcHgofaCMxBUemsRs
         9E8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WhRtpiib2JoVvHyAA7EAvqFNqcN5V67xc7oHXeo1798=;
        b=ktHwV1ZWKPieKk3FETD8ZPKOY2YsmoJBWgngOJlsXQbZgPrDabMcbJvWjUcE2g9u/R
         wLT77attixTxkFJANwX7zVMlg5Rm1+xjKNwxS6D1P9XNronnGmVaQYKnoGfuqH3NzDxN
         LcEUzOGG3gMkaF/s0qkw+bWUPx1H0ZJF8Z2bvywnweaHcAcB0bRMZ4tnU07C9DouxmKd
         +uLAeZw+fFCuAG8x5XdtBcw2bE5FZp0FMok8fbYsyiwETzGkinGCW40fxiUyvoi4s1ie
         NrDnbuBAwaL1f/fvKMVLVdWPH6hYog/sYftc8wezSEyyr+OQLNsGwfbD+vyZsePf1tLc
         QPxQ==
X-Gm-Message-State: AOAM533PLhlKx12qxsMqjOXQISDy7+CnlaSykxpGjZ/u4VEMeafzrgy3
        NT5cC1URHReuzkvyO0487AdcjIPsiZ2Vrb1V
X-Google-Smtp-Source: ABdhPJyVPG8oL4Ybjf2BWtXwVnuhy+Oj7xQHKg0bJcy6KchIYVVh8VA26xRpT4WQaOS0cv+vNaEoKQ==
X-Received: by 2002:a17:90b:1d84:: with SMTP id pf4mr9827503pjb.85.1632295923835;
        Wed, 22 Sep 2021 00:32:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t14sm1545944pga.62.2021.09.22.00.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 00:32:03 -0700 (PDT)
Message-ID: <614adbf3.1c69fb81.a09d3.4f1f@mx.google.com>
Date:   Wed, 22 Sep 2021 00:32:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.206-293-gea49bba6c939
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 96 runs,
 3 regressions (v4.19.206-293-gea49bba6c939)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 96 runs, 3 regressions (v4.19.206-293-gea49b=
ba6c939)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.206-293-gea49bba6c939/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.206-293-gea49bba6c939
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ea49bba6c9398700b58e01b95855a8c645628209 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614aa4d8054e81e54799a301

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-293-gea49bba6c939/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-293-gea49bba6c939/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614aa4d8054e81e54799a=
302
        failing since 312 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614aa6ca1cbc68039699a2df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-293-gea49bba6c939/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-293-gea49bba6c939/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614aa6ca1cbc68039699a=
2e0
        failing since 312 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614aa50719b781742499a2ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-293-gea49bba6c939/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-293-gea49bba6c939/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614aa50719b781742499a=
2ef
        failing since 312 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
