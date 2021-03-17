Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5E3733FA8F
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 22:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231701AbhCQVmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 17:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbhCQVm2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 17:42:28 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8803EC06174A
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 14:42:28 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id h20so227616plr.4
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 14:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gzeM5RaiUgJ8/vsuimKpSlR2gN9pJXMsy5iMxfjhpQk=;
        b=XGH4XDw3outQiKEMyQN0P81eDSKoeNkRcifX5ZUIaJ1Xxiiu69LK1wU3usxi0wKm+7
         eKQJt06lHDUGO+XvHktPxRXEP1u/e3T6mOBbtVx1pJoOJki22kcRjeVM5NdK5iJT/l66
         hRqUJGBikZcJo4ptwWJ2OuQj+lwfPnq2jluUVbCCqOPHaXfv69JDnfmTEyj9mbPKq20G
         lY6S/i3ZFxD3OlSos7z2EWcLKCEQwqkJ+00s4Ct9FdywK4pVymVQOTkGRUdzZTWjrOAG
         nyqRJ+Nmo59M9kVH6980KWDJlv2V3oHZIMdRzttyrikMFJ4HQtKD6PU5GG7mll6HG7MD
         Y5ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gzeM5RaiUgJ8/vsuimKpSlR2gN9pJXMsy5iMxfjhpQk=;
        b=Tby4Atb1UrrN+PwJIFP5Fsf2AtAegZsfQqhTrmyRdFLKTBBCTgtbuCwyRSpjLEKA6k
         kMoeOpweVzjYZ0EV5owaxjdMuc+sLWGguu1OMu8zLuqZqFVOkakAb+zYCQavurTGqq5y
         /McWkgaEpXIyPTTlA1PTdXhJ6FSsJi1FkaMvYjmOQlOAGORBMzn4DNZM8n4Mx1z5EYGh
         eB2HsSsT95hSeyr5+Z4hiadrJlzh39mnzmA5TH7sXdvq2iORj+evFLO0JZahkyBZRlJ1
         u+/BEM+3Q2cxxtEp4TgDw/Mt2Uo6nU3d30mONOLW89cdw1STi9Aik1EN4kjsLP6Idzeo
         U0RA==
X-Gm-Message-State: AOAM530VkGIrjW2ZxRhzCkdGwOsU9ZFTqqIPCQ4tafydo3ZuYJPZEuXt
        oEofjT26wybb144FcZ9QMKnUmwGAJ9uufA==
X-Google-Smtp-Source: ABdhPJyfPnSdzEusXRRKoGQjpwEJKHyiGRCPHqwFuEAHCecO/36EF3MElrzDJtxWZyYXoPRchzbmHg==
X-Received: by 2002:a17:902:c1c4:b029:e6:7bc9:71fd with SMTP id c4-20020a170902c1c4b02900e67bc971fdmr6223913plc.5.1616017347911;
        Wed, 17 Mar 2021 14:42:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a15sm80619pju.34.2021.03.17.14.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 14:42:27 -0700 (PDT)
Message-ID: <605277c3.1c69fb81.45aa0.057f@mx.google.com>
Date:   Wed, 17 Mar 2021 14:42:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.106
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 118 runs, 4 regressions (v5.4.106)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 118 runs, 4 regressions (v5.4.106)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.106/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.106
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      0437de26e28dd844f51fde7a749a82cb2d3694ad =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6052435495185925d0addcdf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.106/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.106/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6052435495185925d0add=
ce0
        failing since 118 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60525277ba806ad1b2addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.106/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.106/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60525277ba806ad1b2add=
cb2
        failing since 118 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/605242dbda996cd217addd2a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.106/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.106/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605242dbda996cd217add=
d2b
        failing since 118 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/605242ef4625fa0e18addcc7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.106/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.106/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605242ef4625fa0e18add=
cc8
        failing since 118 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20
