Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D4F42CE7B
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 00:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbhJMWjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 18:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhJMWjJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 18:39:09 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8D7C061570
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 15:37:05 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id ls18-20020a17090b351200b001a00250584aso5517321pjb.4
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 15:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8dij6+HSocJJ/wFZoOTKDWWC7FhqQs1N2rUHFF4/1QI=;
        b=27tdHQgWqbtV02WLwPtLr8o1NAvdTlN4MiTs02bz8dgFgoJO5rplQWH8qyjeBCgTw+
         /IVgigdKgixQzF9+7CpCyqHqnKRuTvxiQMHIorCL0Z/BSXQkhBEm+68oDrwjEqI9G8QT
         Ygjk6xtHI22qub7FHo/0lMYun3L+qlccycMvfoitE2Nm2r7NsmACTAnmvPBbPVFv6zqY
         yx/TegmRS00eiQlrT9Hp6in7p0E0LEYARyL9yLLES9oF5zdjWoePNPiVrT85G85JfAie
         WPwrs0xdwkrbC1qkRNWTKyUeCrMXfIr2qHrhqIM6OpDaEKG5zWF7+IRM5kEAA6bWup7G
         gt2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8dij6+HSocJJ/wFZoOTKDWWC7FhqQs1N2rUHFF4/1QI=;
        b=gy8WSwDeEqvgPdBFUJVnWCnGQie0COo/pKWN2oc1hmuOIl/JffLCPfweeTR45agGEY
         uE3FXy7SBOybZGxx1+ZcQgUJVy1pw3NbsILDF17BA16fIowXUWj4+xu6QF2ArHgWx/Mf
         KG54wb8rLYbBq6PZiEgwPB32u+BKegs3Ix6g1UWSamoBZeIJIKC24AwY2MBTPLLNGT3R
         r5B0tXLyvaIzGG6HO0yS3VkxCQ1sk3+EKf7VKsyH0bcVZQaIiim+SQLrmZFyv9foU1dU
         GRPAFzGvQi24NBV4BSuQ/scyOKLhs64P6GGb7ilSw8rR0wzz11Ia5dM7BdF9FXoUll/D
         uSkQ==
X-Gm-Message-State: AOAM530iCziEuGWMA6ceMLaN0x10xIuCF1Gdn5uXOKghWZkNZYDUNjqf
        05QphB/PJTn93Y2mJoj5SWuNbdrsX5k37r0cIFw=
X-Google-Smtp-Source: ABdhPJx8VDI0UWEh4JOgmrXBwbxg2Ei3yTRLtejmcRM++5sKuScjVAUMdsPV0Hr5XgLGbmpPM9F0WQ==
X-Received: by 2002:a17:903:234f:b0:13e:e6e1:c132 with SMTP id c15-20020a170903234f00b0013ee6e1c132mr1715539plh.57.1634164625079;
        Wed, 13 Oct 2021 15:37:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b16sm478281pfm.58.2021.10.13.15.37.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 15:37:04 -0700 (PDT)
Message-ID: <61675f90.1c69fb81.50159.22bd@mx.google.com>
Date:   Wed, 13 Oct 2021 15:37:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.286-26-g668b3a30a1d5
Subject: stable-rc/linux-4.9.y baseline: 57 runs,
 3 regressions (v4.9.286-26-g668b3a30a1d5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 57 runs, 3 regressions (v4.9.286-26-g668b3a=
30a1d5)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.286-26-g668b3a30a1d5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.286-26-g668b3a30a1d5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      668b3a30a1d5bdd1f8038fb0302d47919b8be04b =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61672018ee59c46bc708face

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-26-g668b3a30a1d5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-26-g668b3a30a1d5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61672018ee59c46bc708f=
acf
        failing since 333 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6167200bee59c46bc708faaf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-26-g668b3a30a1d5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-26-g668b3a30a1d5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6167200bee59c46bc708f=
ab0
        failing since 333 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61672010dd9d8c006f08fab1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-26-g668b3a30a1d5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-26-g668b3a30a1d5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61672010dd9d8c006f08f=
ab2
        failing since 333 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =20
