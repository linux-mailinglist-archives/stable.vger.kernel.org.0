Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9C340403E
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 22:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237766AbhIHUqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 16:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbhIHUqL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 16:46:11 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC99C061575
        for <stable@vger.kernel.org>; Wed,  8 Sep 2021 13:44:58 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id y17so2993770pfl.13
        for <stable@vger.kernel.org>; Wed, 08 Sep 2021 13:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=q/MEmG+HGhGAUL+yESIj60Lpb6Cc0mQlU+KSJ9O8Rj0=;
        b=FOAfq2CohO4ZBVG3CVHFQuIuKZo0Iq/F4AkRG8GSe4LDWRPulrI4OV1m93QkRnRnbm
         d4CU4Ar77bUwQjOTlzh1+Dy2r4+524eLKAIweEbumOWri/t48l092hcNiWuE7fRSuZl+
         CJlciHd23wVNXctYRrg2ndE4Zc8XI5DRStE7heueJduKtBPyRq2p2bcZJHAZJItvJ1PY
         wC4/qp6CRRNYGjKOYp5JMAC3exbm1JYjzR0F6VXGDlw/lsUxepDX4FNr/ZqNmHBEf4s2
         qWRaZX/oYgjh+g2EmUhHtupUJ/nOCQ168EEnK90QGWi7ognbVNV/lwGN42HFeK7JsLNO
         bROA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=q/MEmG+HGhGAUL+yESIj60Lpb6Cc0mQlU+KSJ9O8Rj0=;
        b=HXCFYsAeNqWWD5/767l6715lodsSFM1ML3vt3RD10+TzRtU5dQoff4HZUntSBLWFcz
         Ojjfbtj0B5Fijp/DEGdbSz3VUMq4lRn9QSNG3fcpkGmm/9AIwFX76vuy10QZdq65Oa4Z
         gfLgAZ/Bti5ztRxOguG0PMFfW5JhnpzJTG1wQ5LHnxoK3J5yj4Ffvp+DgAoXC632r/Jd
         ssY3AtMx77PtYlbLvdVKfLy0SJs3+4lv3Dxj9Mc2ZhEGSlw1Z+lgbQkIQNBTO71/flYF
         mkKE+ZJzoRu7MGC0GZadJbfoB0qWJ03xBryD9tac9cyMZrZ0LblfiX5+Qfxw8lD5xWql
         NAww==
X-Gm-Message-State: AOAM530e42lq4tX0a8HzXfAVGY0a8IEluLf+CogJTLCI2FTDGJWA3979
        dxqkj7XGPmCwG53csDtVa3eSXLOKTDJdO5F2
X-Google-Smtp-Source: ABdhPJzjCCU7URNYNAcL4ibQbwCNNy+W9wGB8N8froSneWBB4ci51ZET2IvIPxFtvLuitZYiNPbrPw==
X-Received: by 2002:aa7:95ba:0:b0:412:44ab:7512 with SMTP id a26-20020aa795ba000000b0041244ab7512mr2608pfk.86.1631133897434;
        Wed, 08 Sep 2021 13:44:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 3sm91954pfp.112.2021.09.08.13.44.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 13:44:57 -0700 (PDT)
Message-ID: <613920c9.1c69fb81.b1fae.072d@mx.google.com>
Date:   Wed, 08 Sep 2021 13:44:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.282-31-g29e291ce95f6
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 140 runs,
 6 regressions (v4.9.282-31-g29e291ce95f6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 140 runs, 6 regressions (v4.9.282-31-g29e291c=
e95f6)

Regressions Summary
-------------------

platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
d2500cc              | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig=
    | 1          =

qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =

qemu_x86_64-uefi     | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.282-31-g29e291ce95f6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.282-31-g29e291ce95f6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      29e291ce95f608fc017b9c506d765648d7898489 =



Test Regressions
---------------- =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
d2500cc              | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:     https://kernelci.org/test/plan/id/6138eab71e25ee297fd5968f

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
1-g29e291ce95f6/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
1-g29e291ce95f6/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6138eab71e25ee2=
97fd59697
        new failure (last pass: v4.9.282-31-g5893d5a47be1)
        1 lines

    2021-09-08T16:54:08.881920  kern  :emerg : do_IRQ: 0.236 No irq handler=
 for vector
    2021-09-08T16:54:08.893389  [   11.963889] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2021-09-08T16:54:08.893763  + set +x   =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6138ec33a6091ea8dbd59697

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
1-g29e291ce95f6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
1-g29e291ce95f6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138ec33a6091ea8dbd59=
698
        failing since 298 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6138f8a70183ad4da6d59699

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
1-g29e291ce95f6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
1-g29e291ce95f6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138f8a70183ad4da6d59=
69a
        failing since 298 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6138eec014fe80719ed5967e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
1-g29e291ce95f6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
1-g29e291ce95f6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138eec014fe80719ed59=
67f
        failing since 298 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6138f10900f255372fd5968f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
1-g29e291ce95f6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
1-g29e291ce95f6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138f10900f255372fd59=
690
        failing since 298 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_x86_64-uefi     | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:     https://kernelci.org/test/plan/id/6138f7169b54d83e48d59678

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
1-g29e291ce95f6/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86=
_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-3=
1-g29e291ce95f6/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x86=
_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6138f7169b54d83e48d59=
679
        new failure (last pass: v4.9.282-31-g5893d5a47be1) =

 =20
