Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B978B429759
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 21:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234489AbhJKTNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 15:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234497AbhJKTNT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 15:13:19 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1FD1C061745
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 12:11:18 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id g184so11665540pgc.6
        for <stable@vger.kernel.org>; Mon, 11 Oct 2021 12:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kAUaw68YCgoPTRKTXuJsr6GGZV9PmLHUrCp00Dw/8As=;
        b=mpyfiizfnFYrkgw8hRd5LLkXJB++5wR4m6zTGDGJTpOZZEl4vVu0ME8so8kDWr8daK
         pFAuYYJ2kURyU7QYrPLGxzCw1nqVENx71E4etp0+XWG8ROYc4RVVD4VtsbQYM1QDIXgq
         5xDvWuHwQnnTZDk8SDQtxtXWtfuvJOhQ49FPOuRD3IOg+qwiqmUwcQpHnQql8Q+SUkCe
         hxsYqAgl4U3SfMcu8YSxUxs5FCXGJxV+wthIt4sM6A1aSLofaXEqPDdjRVscqLFEGN4F
         yHO2dge75/ZMFdvSc5/g3n4D8jbm6MJ1CPdDyxQtDH/zsjdedCNMniW5/wdkCxsg9PTJ
         H4qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kAUaw68YCgoPTRKTXuJsr6GGZV9PmLHUrCp00Dw/8As=;
        b=u44/BO+ixI2ojTzp37QdlA52j4IFnKq2J2TJYY2McyDBrbiXS3/+k5JvHIcujxp0gC
         VR1A9C1Ut7fM23AwcyylF1lJDu8wfKGzNhHeCeWyTo2Djn6h4VdzM/kyLX+DlREE60UD
         qpow28m5QVkZMxvXDBxT5sCi7Q+aQMmv+NGCMoZW5bGXRfT2usPzgkx6G+Top3adrtI9
         3aRRWqzoPQ9AWQlltkoJfr29DhcEZeKdGeBoPT3CKDTfdY6SbWrV0ZieJDr3dqs0WK2o
         cp18L6gF8XCDy7/3XJIET4N8k05cE/jRidGgEA3VfP4cTGfJI3evM3eIdEUavQis7mfj
         ZKlQ==
X-Gm-Message-State: AOAM530Qne5BZRV4NoNqbghUnITl/yYVVWO2pMl06XUOE8aa7MXm6U2e
        OyCzQftkuYZCxyx/fYBwMTjSBKN8ucnV/xWu
X-Google-Smtp-Source: ABdhPJzVVQHVPlhkveYirpL/7082/bCp4OjG6KKGN12MSsjk3R2AM2NdMXbYDXhomnRda+DW8jAvgw==
X-Received: by 2002:a62:6541:0:b0:44c:2988:7d9d with SMTP id z62-20020a626541000000b0044c29887d9dmr27291242pfb.50.1633979477896;
        Mon, 11 Oct 2021 12:11:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x193sm9199220pfd.57.2021.10.11.12.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Oct 2021 12:11:17 -0700 (PDT)
Message-ID: <61648c55.1c69fb81.d9e84.8bf0@mx.google.com>
Date:   Mon, 11 Oct 2021 12:11:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.286-20-gda89cbf2eaf9
Subject: stable-rc/linux-4.9.y baseline: 94 runs,
 5 regressions (v4.9.286-20-gda89cbf2eaf9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 94 runs, 5 regressions (v4.9.286-20-gda89cb=
f2eaf9)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.286-20-gda89cbf2eaf9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.286-20-gda89cbf2eaf9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      da89cbf2eaf957052ed0584cc3c2d9c66f0633e9 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/616451ce26c6af2e1290dca1

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-20-gda89cbf2eaf9/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-20-gda89cbf2eaf9/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/616451ce26c6af2=
e1290dca4
        new failure (last pass: v4.9.286)
        2 lines

    2021-10-11T15:01:15.295690  [   20.747863] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-11T15:01:15.347362  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/125
    2021-10-11T15:01:15.356093  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61644fdb80ee7d62e790dca7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-20-gda89cbf2eaf9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-20-gda89cbf2eaf9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61644fdb80ee7d62e790d=
ca8
        failing since 330 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6164503025be90c37390dcb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-20-gda89cbf2eaf9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-20-gda89cbf2eaf9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6164503025be90c37390d=
cb6
        failing since 330 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61644fce80ee7d62e790dca4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-20-gda89cbf2eaf9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-20-gda89cbf2eaf9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61644fce80ee7d62e790d=
ca5
        failing since 330 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61644fc525be90c37390dc95

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-20-gda89cbf2eaf9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-20-gda89cbf2eaf9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61644fc525be90c37390d=
c96
        failing since 330 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =20
