Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A02838BAD8
	for <lists+stable@lfdr.de>; Fri, 21 May 2021 02:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235064AbhEUAiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 20:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232540AbhEUAiM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 20:38:12 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18346C061574
        for <stable@vger.kernel.org>; Thu, 20 May 2021 17:36:50 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id b7so5896173plg.0
        for <stable@vger.kernel.org>; Thu, 20 May 2021 17:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0uegkAfzccfYbsDHzICVoZO91Z3Zkgrrs+QAuvgVM84=;
        b=N2QATxvJimfQUjZTWqsMmsBv2TTdkgwUO45km5lOB9BuO9z98n9yHChLzB2xLbMgJf
         Kvtf0UvRxaRlKt6qX6t6KCLuMxmxXvZQiuDILUTG0BP8WXME0tI8Ra/oHJTAu4agExRg
         1HNFKLX2MyA45BvLhaY2/cxs6TNA4JcOWYPZOWbzb4WwFvWsTW2weEkg02O88wXFeR1N
         vICtTfqRNoamGEboHb0YKBNhmAgB4dnxDY9IoRzjYWjc0n92uphz8xsnIUR9P5WElOkt
         pjaew1Jh/YKaebzxDhdL8+nMTSdfDMxbLVEMlwd+I/hMzUJRv0ptcl51Ace7cY9RMnQ7
         irrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0uegkAfzccfYbsDHzICVoZO91Z3Zkgrrs+QAuvgVM84=;
        b=nbI4fFya/SggdOfq5Rw59P/cyDIrRrrRfyQnMCPL29YITruUypR3jUs/1vrP7bAm5x
         +Ops6My9pDnkgwJgaQ8akurzRD6eW0Gh/FCxora79szn71GKYo89sYLnesGrpzmX7sue
         46qjKU8jaXLgjwOkAw8BTlfOksDiNZKsEybZfQ0/BAq+0OiKX3wMz9vwTjJb6k6yNVZD
         a1eV4Ex1I4I/YHx6I3IVDz+e3ZN39d63QQpxGyGI9RtvNtCiGNF9pY18JXBSsXEAUuZV
         sgGsdRJUuOfI64KJOTLZDzqo55gv8TVojB4G3vD/q2S+ffc9irs/nGsjiZRyUcMShwtk
         DN4Q==
X-Gm-Message-State: AOAM5309Y97pZFXweYkGkFHiOVus2veBia0aUQ8z5ev5sSKr57RIgd1X
        TL4VtbDE4wA1G0nPsb6/T39fvQ565dO8nLqj
X-Google-Smtp-Source: ABdhPJyr6IPxuzN6msHBRPxMOqNXD7tEn8sAR7xv7lGJolorKwy/OmGKwb/kLoT2z17HyI4LY288eg==
X-Received: by 2002:a17:902:6501:b029:ef:8518:a25a with SMTP id b1-20020a1709026501b02900ef8518a25amr9086294plk.64.1621557409137;
        Thu, 20 May 2021 17:36:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o24sm2883441pgl.55.2021.05.20.17.36.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 17:36:48 -0700 (PDT)
Message-ID: <60a700a0.1c69fb81.b6d82.ad2d@mx.google.com>
Date:   Thu, 20 May 2021 17:36:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.190-424-g96c8f7310a5e
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 128 runs,
 5 regressions (v4.19.190-424-g96c8f7310a5e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 128 runs, 5 regressions (v4.19.190-424-g96c8=
f7310a5e)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.190-424-g96c8f7310a5e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.190-424-g96c8f7310a5e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      96c8f7310a5eb8ad2027bef92c186bf03111400a =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
panda                | arm  | lab-collabora | gcc-8    | omap2plus_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a6cfda0c2e79be77b3afc9

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-424-g96c8f7310a5e/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-424-g96c8f7310a5e/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60a6cfda0c2e79b=
e77b3afd0
        new failure (last pass: v4.19.190-424-gbb62732c6c52)
        2 lines

    2021-05-20 21:08:37.833000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/110
    2021-05-20 21:08:37.841000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-05-20 21:08:37.858000+00:00  <8>[   22.853088] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a6cc632eb7a9fa86b3afb4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-424-g96c8f7310a5e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-424-g96c8f7310a5e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a6cc632eb7a9fa86b3a=
fb5
        failing since 188 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a6cc642eb7a9fa86b3afb7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-424-g96c8f7310a5e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-424-g96c8f7310a5e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a6cc642eb7a9fa86b3a=
fb8
        failing since 188 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a6cc5b2eb7a9fa86b3afa5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-424-g96c8f7310a5e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-424-g96c8f7310a5e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a6cc5b2eb7a9fa86b3a=
fa6
        failing since 188 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a6cc13c3ebe9aab0b3afac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-424-g96c8f7310a5e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.190=
-424-g96c8f7310a5e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a6cc13c3ebe9aab0b3a=
fad
        failing since 188 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
