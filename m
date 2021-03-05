Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F069132E63B
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 11:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhCEKX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 05:23:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbhCEKXf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 05:23:35 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB05EC061574
        for <stable@vger.kernel.org>; Fri,  5 Mar 2021 02:23:35 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id m6so1855127pfk.1
        for <stable@vger.kernel.org>; Fri, 05 Mar 2021 02:23:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0ICnzrK5yHVTghSWE2MeENiFCyypLDrUiRjom4H/Ngk=;
        b=TJ8B3AInTUFbcaj4GcwOYNUdGU/hYvPcdqChfdLui0A8FyFoVqHrI4aGhi8re9YBD5
         4ug1G9h1m3pfo7UWUxEbbZmOBRmtCz2IBqw01WwZQYrBM8/E5azmDTde9GUakzhqKmtP
         uEpcDk+Ki+pC6/75ljUiTwDbUowJ+BZf45i1ALKTlpIWp5DNx6NV1nN3tX8WXeqPCYWb
         maCJBbqeS/gBPS0dnBnj+IJ+fYYxP+DU5vg7wRlnvUcQLR3ATYNiUnxlB132U3w/RC4q
         DitgjakRu2EY/EGVbZ2jovO3yDs6CRxabGZyDs2dX6D0kqfDjYHHEgnYJKFwC3BbtqTv
         7z/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0ICnzrK5yHVTghSWE2MeENiFCyypLDrUiRjom4H/Ngk=;
        b=bdtCVq3fA9119O4+9p5VVav4dTEhfCZrJ+8Hh/fIc9fVMJMxwF/ZrCOkSWSrFuRYFO
         onSj7wvBnQL0KgdaTrXvqubhwVgvWv8u+jeMnu0ulj/lY/KaAq7dKEI5NfouggWhTBO8
         IjKomtj0xhGgRixNQV/NwBamxuEMllxedc6Y4rl0muAfSWCnscflLgygMEkB84+iaJoo
         iw2C0xP3U9/5QEM3xMCpRMkP5ItAoyMhJJDm5zRJB+qFENsTg9sPlngCOe7VeVcFPNiS
         iLBr6KfKrHfMVmvNrC9ULBI0dnfKX/CGuLVhrvDDWHblHQpCboabCFY2X9RXb8C2JVNg
         L2sg==
X-Gm-Message-State: AOAM530b/d5LwrGb7Z6wXmdyogiNYXdPg37OdkCRbwzfYQjjYmDYXq8P
        iSZUrmCyx3OvOBssa0Wq3locD2v4ZnTbcVmM
X-Google-Smtp-Source: ABdhPJzUnWGovz8EAAd+xjvlmin0RsW9bzD/82QKYFPCuEGsuky5kjzoHu7hIX/ffgS5Sone6Qu+1g==
X-Received: by 2002:a65:6208:: with SMTP id d8mr7729536pgv.365.1614939814555;
        Fri, 05 Mar 2021 02:23:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c4sm2262346pfo.2.2021.03.05.02.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 02:23:34 -0800 (PST)
Message-ID: <604206a6.1c69fb81.bbdb5.6572@mx.google.com>
Date:   Fri, 05 Mar 2021 02:23:34 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.259-32-gecb4251a2012a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 93 runs,
 5 regressions (v4.9.259-32-gecb4251a2012a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 93 runs, 5 regressions (v4.9.259-32-gecb4251a=
2012a)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.259-32-gecb4251a2012a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.259-32-gecb4251a2012a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ecb4251a2012a6d0f5b0b8b05290f08fb6bc0cbc =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
panda                | arm  | lab-collabora   | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041d3f9a715a49878addce8

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-3=
2-gecb4251a2012a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-3=
2-gecb4251a2012a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6041d3f9a715a49=
878addced
        failing since 0 day (last pass: v4.9.259-22-gef981795155f, first fa=
il: v4.9.259-22-g60dc3d39f4a2)
        2 lines

    2021-03-05 06:47:17.699000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/129
    2021-03-05 06:47:17.708000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041f8ec2032be0994addcd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-3=
2-gecb4251a2012a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-3=
2-gecb4251a2012a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041f8ec2032be0994add=
cd2
        failing since 111 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041e34043434836efaddcb4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-3=
2-gecb4251a2012a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-3=
2-gecb4251a2012a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041e34043434836efadd=
cb5
        failing since 111 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041d07a819080b3c9addd4a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-3=
2-gecb4251a2012a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-3=
2-gecb4251a2012a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041d07a819080b3c9add=
d4b
        failing since 111 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6041db5ce582ffbb2faddcba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-3=
2-gecb4251a2012a/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.259-3=
2-gecb4251a2012a/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6041db5ce582ffbb2fadd=
cbb
        failing since 111 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
