Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B8E3E0C6A
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 04:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhHECYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 22:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbhHECYv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 22:24:51 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EB56C061765
        for <stable@vger.kernel.org>; Wed,  4 Aug 2021 19:24:38 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id l19so5913754pjz.0
        for <stable@vger.kernel.org>; Wed, 04 Aug 2021 19:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HDH8FNbaHi3gkazozUmHiS6Et9pdkD6DfJngYThufYU=;
        b=zA6hMNewaYyG2uZUKn+T4BPYs0QvJ29tRQxBcwU1Vm+eAcw4zR8/0NBh4tchgiG+1i
         3NRDyjkdtSDUmsBCUm1/a3gYA3KDz+5bo2BnioVMfzwLkldaEyEJwofnB8OiHk0xrAZJ
         Bc+N8WKNIMB/KM6fIJHtMdWCsS7hV+Euwcthy58ir0lSAsLG7hPSZZ1ivRp32To5UhWB
         wlk1SufCwzT/69QfMjBHQUfygAtuTyzm87HVk6K08ORohNivskydp8n/cN4IYhiVBLOn
         ppA17Vv8YLwzgYljHY+m2JzLsncY/tDCnB1nA93Fn4xN/KzCxWgRIa2HAcF2o4br8lIn
         MlIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HDH8FNbaHi3gkazozUmHiS6Et9pdkD6DfJngYThufYU=;
        b=kw8Fz15baaRNhnk0ldJDeJFKqZpZSdQIunCzGvNleJp+Ied4JxJh3aOsEnqpILdQDe
         Ef6ZuBIzYt95g0I/VPzcou0oQG6jMcWDPAMuDUrYqzbVZH2qL+HG01pb/Ki5P7jwTUhp
         qVHXM0RT/Dq+JvAgzXNrWftfASEulMIt0of+jLVfcWHPBXkcwD7uoNdgt2yU5vR0I3Ri
         MnsksDDSLyXZzErds8uwvw0zYh/G/RkQjiu4yFGTARdpfLwSnQljxkCDm/H5pEwyE3wK
         tckURSz6SYHrJ+s4xJ9ls06iJbMt/qfuT9I6OTuJQ1hwCL7NYmKJ/FbohRyzggVoq+JD
         Y43Q==
X-Gm-Message-State: AOAM530jYQESZOwtKIXGX6FFqZ8DShBe32MrZn0vkZbj6kN4x4Er/sw2
        TKFphDF2OmQ7bl2U4w60MmFpDsmJLACMDken
X-Google-Smtp-Source: ABdhPJwejJFzmeHJpSfml8z2UG5p7kqZGRwiqaEa/VtCfB6RD84MpPn7URPeDTz9x/5Crv56ZGMOWg==
X-Received: by 2002:a17:90a:cf94:: with SMTP id i20mr12329513pju.219.1628130277103;
        Wed, 04 Aug 2021 19:24:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b26sm4437162pfo.47.2021.08.04.19.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 19:24:36 -0700 (PDT)
Message-ID: <610b4be4.1c69fb81.64874.e3a1@mx.google.com>
Date:   Wed, 04 Aug 2021 19:24:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.201-1-g314e79887f40
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 95 runs,
 4 regressions (v4.19.201-1-g314e79887f40)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 95 runs, 4 regressions (v4.19.201-1-g314e798=
87f40)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
imx6sx-sdb           | arm  | lab-nxp      | gcc-8    | imx_v6_v7_defconfig=
 | 1          =

imx7d-sdb            | arm  | lab-nxp      | gcc-8    | imx_v6_v7_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.201-1-g314e79887f40/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.201-1-g314e79887f40
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      314e79887f4072ea682466679b2b0d3a52f24de8 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
imx6sx-sdb           | arm  | lab-nxp      | gcc-8    | imx_v6_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/610b33ec6270cc1da0b13688

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-1-g314e79887f40/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sx-sdb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-1-g314e79887f40/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx6sx-sdb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b33ec6270cc1da0b13=
689
        new failure (last pass: v4.19.200-1-ga4076ed4f9f4) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
imx7d-sdb            | arm  | lab-nxp      | gcc-8    | imx_v6_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/610b16111b1e3180d9b13670

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-1-g314e79887f40/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-1-g314e79887f40/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b16111b1e3180d9b13=
671
        new failure (last pass: v4.19.200-1-ga4076ed4f9f4) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/610b20c1cea205e37eb13675

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-1-g314e79887f40/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-1-g314e79887f40/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b20c1cea205e37eb13=
676
        failing since 264 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/610b147d3acfd76edfb13665

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-1-g314e79887f40/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.201=
-1-g314e79887f40/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b147d3acfd76edfb13=
666
        failing since 264 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
