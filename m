Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9233A424857
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 22:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhJFU4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 16:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbhJFU4h (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Oct 2021 16:56:37 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF42EC061746
        for <stable@vger.kernel.org>; Wed,  6 Oct 2021 13:54:44 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id s11so3553357pgr.11
        for <stable@vger.kernel.org>; Wed, 06 Oct 2021 13:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TcV1mU99vtuSUulrDt/6NA1NuEzVh1CUhSgSLj+8bDo=;
        b=fKNR2RxXta9DGUfCJPdTnYp/vGxgGltRzgFCWHbYWkCN9+/6BA7WQCjtZICyli+pHg
         TiadasmLWdpRcCfEJ2OSnQbwlfKCrnOGMcuhWdyW9yTQ/xVuDw71r8RcODMCfJTqqkbl
         E9vx/LpqFt43tdZaajcItgBYQ6tnLDb8KEF+HThrpYjXSYBIcXGb5yoEeKnaIWmmiNRA
         3fYw8Hk5s5LVw+cxOTbXJkp0bfWrjtz1kLHAC40ospnsA3mX83pvpcJmzHRbnad7+6uT
         YkhHM+iQjZPSne1WHaC5zADWFDAelQsBMBbb/XUOGXF0355e35Ot1RGZROX4BJ7KTx64
         XrJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TcV1mU99vtuSUulrDt/6NA1NuEzVh1CUhSgSLj+8bDo=;
        b=pt+ejxIH873y8XERENDcBVsbi0rOkx+ANIjhkRFHb4Lw7933EN7+cN5GkrmiDAj/BX
         QJO8Fr2+imkHrGSjis2IRb3Fhv/k2sQviGYAFz5sByPhfvGZog30AepzPQo9EV/ggk1R
         8B7l1teboGU/Lezep1f9KWwSxpMOkpAHyLlq4nNjS2RuZpWJCmlkc8qWUiNjKaRQmkYY
         99CQpbjYWcrmcCs5LO3kYiDEf68LUBSPQLT0D4irjVmyAjx0td7uIxW1lGlGdp1tY+bZ
         Q1F00PlxJ6+cHQpO0fKXsLLrLUBe7nxi97EfUvDnYHfsjoptLBLtP6wND4hvSdt1b6o5
         IKgA==
X-Gm-Message-State: AOAM531S6DQTMtB2yQCqZiPJynlfr5rr+50qcEb3oQFivupAShfao4vD
        XrjqfyLR/eqMTVVa0ePdFKMCfQBVZziO8Kwq
X-Google-Smtp-Source: ABdhPJx+8EdWom5FWhSjFZWsdMX3YxR2Nb0EUHGSQLmC5PWn7gLVd+n9IflnmZ78V6q4ZvpqIb3gHw==
X-Received: by 2002:aa7:9614:0:b0:43d:ea99:2a2a with SMTP id q20-20020aa79614000000b0043dea992a2amr501160pfg.48.1633553683801;
        Wed, 06 Oct 2021 13:54:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c18sm20744261pge.69.2021.10.06.13.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 13:54:43 -0700 (PDT)
Message-ID: <615e0d13.1c69fb81.86e44.dbcc@mx.google.com>
Date:   Wed, 06 Oct 2021 13:54:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.249
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y baseline: 120 runs, 8 regressions (v4.14.249)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 120 runs, 8 regressions (v4.14.249)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =

rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.249/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.249
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      756db2ba8bde4ead58ceb54e9cbc71f526f9a98f =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/615ddcb4827f0434b599a35a

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.249/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.249/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/615ddcb4827f043=
4b599a360
        new failure (last pass: v4.14.248)
        2 lines

    2021-10-06T17:28:00.524352  [   20.437164] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-06T17:28:00.565422  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/102
    2021-10-06T17:28:00.574567  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/615dda73e3689ee12099a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.249/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.249/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615dda73e3689ee12099a=
2db
        failing since 321 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/615ddb16f865a7892e99a32a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.249/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.249/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615ddb16f865a7892e99a=
32b
        failing since 321 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/615dda994ceb87426499a34b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.249/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.249/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615dda994ceb87426499a=
34c
        failing since 321 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/615dda2d38d684346d99a2e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.249/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.249/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615dda2d38d684346d99a=
2e7
        failing since 321 days (last pass: v4.14.206, first fail: v4.14.207=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
rk3288-veyron-jaq    | arm  | lab-collabora   | gcc-8    | multi_v7_defconf=
ig  | 3          =


  Details:     https://kernelci.org/test/plan/id/615df4d8710c5e48b199a316

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.249/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.249/=
arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/615df4d8710c5e48b199a32a
        failing since 112 days (last pass: v4.14.236, first fail: v4.14.237)

    2021-10-06T19:11:03.812312  /lava-4657334/1/../bin/lava-test-case
    2021-10-06T19:11:03.828866  [   17.020722] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-10-06T19:11:03.829353  /lava-4657334/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/615df4d8710c5e48b199a343
        failing since 112 days (last pass: v4.14.236, first fail: v4.14.237)

    2021-10-06T19:11:01.379869  /lava-4657334/1/../bin/lava-test-case
    2021-10-06T19:11:01.385062  [   14.589019] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/615df4d8710c5e48b199a344
        failing since 112 days (last pass: v4.14.236, first fail: v4.14.237)

    2021-10-06T19:11:00.360829  /lava-4657334/1/../bin/lava-test-case
    2021-10-06T19:11:00.366126  [   13.570047] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
