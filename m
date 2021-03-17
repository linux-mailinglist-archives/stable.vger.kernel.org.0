Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3F8133FADF
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 23:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbhCQWRH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Mar 2021 18:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbhCQWQw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Mar 2021 18:16:52 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E64C06174A
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 15:16:52 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id ay2so263320plb.3
        for <stable@vger.kernel.org>; Wed, 17 Mar 2021 15:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=nSXePImyg/EXQkHag5DlrXeq3pYzwXwnG1dQNOLLyus=;
        b=hc1SLewfK86SstTGc2OBcksfy3yeWN6j053TyLfoAp+QH3y7i+498TItnQAGDicjnj
         JZV7htBlDpyiNNW0OQd1zPCbm0Oqlaxe+dtOuPPx+ZT1iPMGx0F6ZN16wW5l5rD4sBuQ
         xE0XfKtMzQBcq6fGh0sOfa1Ayf6CD9bJTJVhZQ1OxsSbxwl2x1/26+8LkBFv+WISrdST
         FFDqq9hRdfmdblglayPDLNaPNQJBX1yzgtLmaOVTG96msXJ2xjQ+GsvB2RtylAXMOJ63
         7aLcbpGSAe7c3GaaTgG/j1hCu6BSMKhQFqo4ysxpV848LRECxOaye5OxpSvL1rxYprX0
         OAdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=nSXePImyg/EXQkHag5DlrXeq3pYzwXwnG1dQNOLLyus=;
        b=ZqwMVGKefadC8OzooobYF2HnGT2aDQ5PdAeaZSjLNWPntnYi0nTyl5rr3ooZMSIYtb
         GCD6jm5N4TZkVndV/Dq59ETcT4efKlQTwZaFGfxGK68NtiV77ZgwbGirWiil1EGo1AGD
         fH/IDWXzlC9G31UefWH8R5aILbQYZa7gPpeq7q/cytKdRytPlucAHj5Qmt3c5asW++5U
         RJmsktIZn4bj7B1RWhbhVuWHkJwVmcn2wdbdUTBaxJsnvLvGluIzfpNniw8tsnbpOOf2
         FQGwB2Qn8CyzjljzGEflxvwxzDPDG16n9M4DwVkTL402DAy/CahBqSc4NIx6vslkHEDB
         MITA==
X-Gm-Message-State: AOAM531UUs5JTBwn2ecAuO/Fzhw/6Sfg5mKzue6ND6gsSrP3bVndsHwE
        SKCDegZ6x816SY9XgtxT0QN4sUHNuXqrQQ==
X-Google-Smtp-Source: ABdhPJyyLF5Yj67uMfFrC6O6YrB6XS55ZrrkP50PBdX7RsWDgtSUxiTsi2w/k+dD9KDlfM9t3KwUmQ==
X-Received: by 2002:a17:902:bd06:b029:e6:54ad:519a with SMTP id p6-20020a170902bd06b02900e654ad519amr6451351pls.52.1616019411951;
        Wed, 17 Mar 2021 15:16:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a21sm99485pfh.31.2021.03.17.15.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 15:16:51 -0700 (PDT)
Message-ID: <60527fd3.1c69fb81.a4c6b.0687@mx.google.com>
Date:   Wed, 17 Mar 2021 15:16:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.181
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y baseline: 109 runs, 5 regressions (v4.19.181)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 109 runs, 5 regressions (v4.19.181)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.181/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.181
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      ac3af4beac439ebccd17746c9f2fd227e88107aa =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60524a76a6457125bbaddcc2

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.181/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.181/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60524a76a645712=
5bbaddcc7
        failing since 13 days (last pass: v4.19.177, first fail: v4.19.178)
        2 lines

    2021-03-17 18:29:05.750000+00:00  <6>[   22.684295] usbcore: registered=
 new interface driver smsc95xx
    2021-03-17 18:29:05.780000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/105
    2021-03-17 18:29:05.789000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-03-17 18:29:05.816000+00:00  <8>[   22.742034] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/605247fb7c429544bbaddce1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.181/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.181/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605247fb7c429544bbadd=
ce2
        failing since 118 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60525970991b65c434addcef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.181/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.181/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60525970991b65c434add=
cf0
        failing since 118 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/605247af1a459fc27eaddd0b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.181/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.181/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605247af1a459fc27eadd=
d0c
        failing since 118 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/605247b4f34f604f2caddd1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.181/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.181/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605247b4f34f604f2cadd=
d1d
        failing since 118 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =20
