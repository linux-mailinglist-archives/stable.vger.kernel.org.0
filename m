Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB3EA575093
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 16:16:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbiGNOQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 10:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233712AbiGNOQa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 10:16:30 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C381458840
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 07:16:28 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id l124so1952215pfl.8
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 07:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=y+ROw8hy/vr7zkweyA2TaI8pSPCj9v9LKvAQbIBFGDw=;
        b=ov+WUGkSnyNbRX1M+O+XajSFIXilvhicjTpypbrYY52AyeDVgKUnwpFWzC0ZquXSuc
         P9/XRI7wzWzWKQiIAABNXxm2Ov81aWbgMrn8UEshKTAkFtyXKxmdQzcITvyCN45tTwy5
         AU7ZOvUnvLa8mg6VnJ4olWajFboXv6tv5xIMgHP6jbMqpweNwfVDwZH0eUspRLZkz6h/
         141SGX5jCQUURIlCm8zwiIb6DXJ/CyDaVXS/hf+1GdgQW8mNJC6tK9jRP2vyr+jIHDx0
         1M19md3bU1Sz/2PoLHwM2tPzykEgETiL7kTOXsUbUYkZHfo73jGni81KfttW2fMcXCA5
         GiyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=y+ROw8hy/vr7zkweyA2TaI8pSPCj9v9LKvAQbIBFGDw=;
        b=N8H8tP56T/z1LC/GUfeOb+9dME54QSS84zsH3ET88Rz/iMQd8sLHI4qpc7yaauUh9E
         tUrm9LjjBc1P1uU2ktYWF87nDwzrzoB18Wn+2bMEsjlHxAoCaNxeXj5n99TTCnurO7qM
         MPY1uTEL0l5zrGsPidnf5+a3fxAFwtdjrhjwkRiSiHRE3I28EPHyUSt85kqqOuXGFX/M
         EYVxPmk3JKTbVwf+9cRX94Yai2IrzU23IWHeDavOy0TJoSblcbPD4aogF3pgCOJ4gADI
         5fW5pXXKcDwS4yc4qEDukAsoWHbdf91rvjNVy9R3kUfktzetxoar9fRmaXwU4s56Kpwg
         39+Q==
X-Gm-Message-State: AJIora8Shu+6AUHBWV9USXLWgya+XJhCsQp6SiCDz8VlrhhPWiAM5aMK
        sfLSA/uMLjBbP8XxBU/utc1t/mXsQOziFHVZ1Tw=
X-Google-Smtp-Source: AGRyM1uXsnDK6GiO4T2O2QvmZQ0d4pPMWGJqerZQMuGe9tHn44cvUsCr/FajDYUNRV25id+1PVMBlw==
X-Received: by 2002:aa7:991a:0:b0:52a:c5df:e17f with SMTP id z26-20020aa7991a000000b0052ac5dfe17fmr8753054pff.52.1657808188006;
        Thu, 14 Jul 2022 07:16:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mm18-20020a17090b359200b001efa35356besm3728966pjb.28.2022.07.14.07.16.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 07:16:27 -0700 (PDT)
Message-ID: <62d0253b.1c69fb81.c6976.5e70@mx.google.com>
Date:   Thu, 14 Jul 2022 07:16:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.54-79-g7cd2ee02c205a
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 166 runs,
 7 regressions (v5.15.54-79-g7cd2ee02c205a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 166 runs, 7 regressions (v5.15.54-79-g7cd2ee=
02c205a)

Regressions Summary
-------------------

platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
beagle-xm              | arm    | lab-baylibre | gcc-10   | omap2plus_defco=
nfig          | 1          =

jetson-tk1             | arm    | lab-baylibre | gcc-10   | multi_v7_defcon=
fig           | 1          =

jetson-tk1             | arm    | lab-baylibre | gcc-10   | tegra_defconfig=
              | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defconfi=
g             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defcon..=
.6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defconfi=
g             | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defcon..=
.6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.54-79-g7cd2ee02c205a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.54-79-g7cd2ee02c205a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7cd2ee02c205a83f8bfb0a7b94cb0df792f35191 =



Test Regressions
---------------- =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
beagle-xm              | arm    | lab-baylibre | gcc-10   | omap2plus_defco=
nfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/62cff132de36721d27a39c12

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
79-g7cd2ee02c205a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
79-g7cd2ee02c205a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cff132de36721d27a39=
c13
        failing since 105 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
jetson-tk1             | arm    | lab-baylibre | gcc-10   | multi_v7_defcon=
fig           | 1          =


  Details:     https://kernelci.org/test/plan/id/62cff3c7aaccc0f268a39be1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
79-g7cd2ee02c205a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
79-g7cd2ee02c205a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cff3c7aaccc0f268a39=
be2
        failing since 33 days (last pass: v5.15.45-667-g99a55c4a9ecc0, firs=
t fail: v5.15.45-798-g69fa874c62551) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
jetson-tk1             | arm    | lab-baylibre | gcc-10   | tegra_defconfig=
              | 1          =


  Details:     https://kernelci.org/test/plan/id/62cff1c148917ba631a39be6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
79-g7cd2ee02c205a/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
79-g7cd2ee02c205a/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-t=
k1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cff1c148917ba631a39=
be7
        failing since 9 days (last pass: v5.15.51-43-gad3bd1f3e86e, first f=
ail: v5.15.51-60-g300ca5992dde) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defconfi=
g             | 1          =


  Details:     https://kernelci.org/test/plan/id/62cfeb57cd256b4e82a39bd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
79-g7cd2ee02c205a/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
79-g7cd2ee02c205a/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cfeb57cd256b4e82a39=
bd6
        failing since 1 day (last pass: v5.15.53-229-g4db18200a074, first f=
ail: v5.15.54-78-g9de37b0ed1dc) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defcon..=
.6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62cfeddeaaad897e7ea39c7b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
79-g7cd2ee02c205a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
79-g7cd2ee02c205a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibr=
e/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cfeddeaaad897e7ea39=
c7c
        failing since 1 day (last pass: v5.15.53-229-g4db18200a074, first f=
ail: v5.15.54-78-g9de37b0ed1dc) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defconfi=
g             | 1          =


  Details:     https://kernelci.org/test/plan/id/62cfef73a9deeba178a39bd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
79-g7cd2ee02c205a/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
79-g7cd2ee02c205a/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qemu_=
x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cfef73a9deeba178a39=
bda
        failing since 1 day (last pass: v5.15.53-229-g4db18200a074, first f=
ail: v5.15.54-78-g9de37b0ed1dc) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defcon..=
.6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62cff12aca9ca5fa27a39be5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
79-g7cd2ee02c205a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.54-=
79-g7cd2ee02c205a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie=
/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cff12aca9ca5fa27a39=
be6
        failing since 1 day (last pass: v5.15.53-229-g4db18200a074, first f=
ail: v5.15.54-78-g9de37b0ed1dc) =

 =20
