Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2072EE925
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 23:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728598AbhAGWrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 17:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728562AbhAGWrP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 17:47:15 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E234C0612F6
        for <stable@vger.kernel.org>; Thu,  7 Jan 2021 14:46:35 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id n7so6330534pgg.2
        for <stable@vger.kernel.org>; Thu, 07 Jan 2021 14:46:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=d61q0Rza861XlGKFrDpwiXUA37BWd7bSB9gGadB4V58=;
        b=MWYPFZ4lRlohDM9QltINguMC1rC9OUueEqI02bRgksrrRlWK4GWzIQ4UOWf3oMif20
         lqKoN71R8N+RV0HeGwWWeIChIk+DMXYLy1FsLjMrkiJ0FqWwZm9Z7pEGSyhazWkhfJVS
         Bts7mJAbfjGu0IsQsg2CR0/bRmoboi9m/gdxwOa+fjrE89Gpi5BReOxyEf3pVIBevatq
         UPkZiIvWlzFJUSVatsgVO37iQwCgztwr4JUkmPTU0X6fs4AJ3cA90FEV+RGbyIUI40sE
         Rj6RvGW/IWzLLO+Pbnq087Fm00FO3j1fe1eqMIm9bGuxaZeTjSc/WJ4B+0RjT9Vd0D2r
         WkZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=d61q0Rza861XlGKFrDpwiXUA37BWd7bSB9gGadB4V58=;
        b=SbIS3Qzuj+X5l7th6Z7s6fK87cWPg8BX53jYwpstD/hfjkaA1+k9vpEDhCH5auTCKG
         f8dNCF0LnEur3k8vM6RinvMYFIbvfKH+dd6i/bKP2/PgMwlbm1CKWRnmtvZHmYY4Xe6+
         AH5KHHLa8DKDMBgMGQGBhbsLPXLlbeQJzwGH4f08QtkH89sWqwcjLtpsQF+oXYATHGgH
         JGSgltc2LWVOixhSY9MDqkE/Zx1YFaOH9D7qOMvprSmJ+NDlv6S3fvE0gjIJOc7i/SrA
         UbTo4jWBDjCMV8iyM4LQS2/kNLRsnixdz6WTXsZ812YorwfWaonaCNQt/Z6jH01h9VGW
         5nhw==
X-Gm-Message-State: AOAM531LMF7oRUsDfjLz4iIvzSh6NXCutA+W8wYO+pC0RmcqDv4P9T3v
        rkgv6UYkn/8QPN0yIT7SOVkB8REF7Wco6w==
X-Google-Smtp-Source: ABdhPJzeqK6pILRAaKt5rwPe6d++a2ZMqecTvIHZb2qLikmMIRjcLG1/M8UzLwXPZmatdlcvlE7wXA==
X-Received: by 2002:a62:184e:0:b029:19e:c636:17f9 with SMTP id 75-20020a62184e0000b029019ec63617f9mr863806pfy.23.1610059594677;
        Thu, 07 Jan 2021 14:46:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q23sm7687517pgm.89.2021.01.07.14.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 14:46:34 -0800 (PST)
Message-ID: <5ff78f4a.1c69fb81.6e461.2a21@mx.google.com>
Date:   Thu, 07 Jan 2021 14:46:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.165-9-g0f2782448d9a
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 153 runs,
 4 regressions (v4.19.165-9-g0f2782448d9a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 153 runs, 4 regressions (v4.19.165-9-g0f27=
82448d9a)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.165-9-g0f2782448d9a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.165-9-g0f2782448d9a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0f2782448d9a6522601ffabef0f3304a50d99857 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff7577953c126f04cc94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
65-9-g0f2782448d9a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
65-9-g0f2782448d9a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff7577953c126f04cc94=
ccf
        failing since 50 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff75773413835c9b9c94cbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
65-9-g0f2782448d9a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
65-9-g0f2782448d9a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff75773413835c9b9c94=
cbf
        failing since 50 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff75770413835c9b9c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
65-9-g0f2782448d9a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
65-9-g0f2782448d9a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff75770413835c9b9c94=
cba
        failing since 50 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff7572a746c3b0b33c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
65-9-g0f2782448d9a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
65-9-g0f2782448d9a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff7572a746c3b0b33c94=
cba
        failing since 50 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =20
