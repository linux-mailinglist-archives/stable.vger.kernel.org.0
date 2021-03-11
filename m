Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B81336AAD
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 04:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbhCKD2F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 22:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbhCKD1p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 22:27:45 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9867C061574
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 19:27:45 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id o10so12775466pgg.4
        for <stable@vger.kernel.org>; Wed, 10 Mar 2021 19:27:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lCOcU4p8wO29QyFzvpWIVSPqqBclwW9JLwrhYdEOI54=;
        b=O/jdS5Gk/WND+0bCD/va2hEAxfRwZq+4TDiVJSrcUpZj02LEKvEQFOUG1sKg7cug68
         q/yNYaCbiUdeGKfGwKZ+tkkBl4Zi7EeCIaKC7LStjcRlGSxkgArqAC4QIMNnO+uxAWns
         IQQFlkTrHHG56wN3mPC5bNkPEaPIUSbTo3fvrKfQ5oq0Gg2d91qmb3NOgpVAfiMccMen
         vX0OkBivGVk+RxTa/QTP1dezEgD/8hsF1Rc5blukizTa+xwMwRuGiBgxP6WFuvxvBAQJ
         aWdBMPe0eh7g01qdMFw+Nh11/sQSZkAMKiUFw6/upaVz0wqmx2rb7mlN3sjCaW2Gf4W9
         lPXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lCOcU4p8wO29QyFzvpWIVSPqqBclwW9JLwrhYdEOI54=;
        b=bNeBppcElRQvk1dudqxSDXC/iDlt2uOVJfTM2+xSNvDN7nC1uABhDqyzTJdXfh4HTA
         /uHLJdASTZqcxoEUQjhFLTkGSB1k0Z31hmYapXRCeEm6+aUf6sL8lWCu8hg9DsTx7HjK
         F8t4DBM+CofDMBxgCfKd7EhQQd2ySLxlg0iWaI2BC5uc8/Qr6lllH1+snONvLMYHsAd2
         gb2D31mAIrRK3CS61rBHsGN/WnY2pQprEBIUSuk0uOtQ8DMCQuPrdm+Nm8VpizBbS2G3
         7oVBlVxNB4oFB+EsYkaFgAvROzVByTV9kX1G+twIMF8JoxMYiVjn40mJPS8E8ZZyC0tk
         z+Hw==
X-Gm-Message-State: AOAM532EqZxNJ9iCKkd2OKH5VDrHWXolfDvFrwZcEf4GrPYyWcQd+Bap
        quyOJUH0cvuHqAR1SwWHm2FETYCDhsoySW0e
X-Google-Smtp-Source: ABdhPJzDZcgSzdW6fMXA6cbj90aqJDH26WcA9TdipEUeIkSkNboLAbwx0lJgNuaezvgt4h0e+Q5QIQ==
X-Received: by 2002:a05:6a00:16c7:b029:1b6:68a6:985a with SMTP id l7-20020a056a0016c7b02901b668a6985amr5932537pfc.44.1615433265015;
        Wed, 10 Mar 2021 19:27:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s19sm806391pfh.168.2021.03.10.19.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 19:27:44 -0800 (PST)
Message-ID: <60498e30.1c69fb81.595e7.362c@mx.google.com>
Date:   Wed, 10 Mar 2021 19:27:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.179-39-ga47c6709d29ef
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 104 runs,
 5 regressions (v4.19.179-39-ga47c6709d29ef)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 104 runs, 5 regressions (v4.19.179-39-ga47c6=
709d29ef)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.179-39-ga47c6709d29ef/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.179-39-ga47c6709d29ef
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a47c6709d29efb54d19656c7e6ba6206277cb326 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60495be23761ef148aaddd97

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-39-ga47c6709d29ef/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-39-ga47c6709d29ef/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60495be23761ef1=
48aaddd9c
        failing since 0 day (last pass: v4.19.179-21-gc964fee72067, first f=
ail: v4.19.179-39-g8b229a67729c8)
        2 lines

    2021-03-10 23:53:00.447000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6049596b13edab393daddcce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-39-ga47c6709d29ef/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-39-ga47c6709d29ef/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6049596b13edab393dadd=
ccf
        failing since 117 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60495964ba032ebdadaddd06

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-39-ga47c6709d29ef/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-39-ga47c6709d29ef/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60495964ba032ebdadadd=
d07
        failing since 117 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60495912d469a53716addcce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-39-ga47c6709d29ef/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-39-ga47c6709d29ef/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60495912d469a53716add=
ccf
        failing since 117 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/604959243d435dd76caddcdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-39-ga47c6709d29ef/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.179=
-39-ga47c6709d29ef/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604959243d435dd76cadd=
cdd
        failing since 117 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
