Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1F1354BD0
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 06:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242471AbhDFEwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 00:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242465AbhDFEwp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 00:52:45 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05444C061574
        for <stable@vger.kernel.org>; Mon,  5 Apr 2021 21:52:38 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id ay2so6811947plb.3
        for <stable@vger.kernel.org>; Mon, 05 Apr 2021 21:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=F1KM8keaXSAO1eGaeAxjWJRNIc39NTSSMsnC1HecgDo=;
        b=c8VzdblmAhUVY2pUFwoj6WpWu+wcZe5EoNXroGXIIYEYTYKYaO7Pn1iSh9uE/sevxn
         I3OWLzGKliviWTdhcmhB2196Zg1MIyWjKy+hEob/jDy8jz5sd0AniMpPojIqwIuFcYrS
         WDhQeKZMxiMNQ/KPPeM4qTf5oM/ic5mUuXaFQcn+99dPd7wFJO1n1MG0mS0tSsQcoyYa
         QeEd40UyinlkI5O3QLuX69MDGjvHfhhibRIbyw1Ee2igQvs+sOOcgnvp4rCsQ/+LD3Ih
         O/h8Pl/h2yo9RJP7Q3IxR3OiXrEhTcW+KQI9LeymnZBnFRxa7PNm8AR6+Al1M9JFbQ/n
         K8iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=F1KM8keaXSAO1eGaeAxjWJRNIc39NTSSMsnC1HecgDo=;
        b=nSPxltYh2DEUrJxapEfKHrFw0PUMcg+TF7Wwx7LVkUbEVnW/SO9eVlwPCT7SkZ7Xyf
         sEWyprxBQyoi2S2CJip42R6Vtd7wBU7RR08vYC2HO9gucZFivzT51V2zvsMydJtp/e4H
         qzNfoa+/avyzT5bKdBxtKniuV53dJncvkQcHUuA1nmw+/2mS838EdenMPKXWPcjUEawT
         0yFwusBTXOoWK44FSnyhGxWdlVZxuolwqFe+yxsj1gCqUG1rHdqzCBqgZhQpqbz4VAL0
         xPA0yvX5fX9NY+HdWLbXWFKBuZ3MSph1/dS82Wf0vJFPSy+kPjMxS/R+TJMKKQaEYYpp
         aoHQ==
X-Gm-Message-State: AOAM532eFjihYfDVxseograQEH/dKR2OS//VyGjLcHZZaPej7uRck56q
        V3FVp33tb07XDGXeLYUAi9djFmehzlLdzg==
X-Google-Smtp-Source: ABdhPJwa91iBl0D+2F4baVyTQkKcJ/nucNSSYF3rvHqbFmvxHiSaAIlMWYKXIwd56OnqiwlOB2u0aQ==
X-Received: by 2002:a17:90b:691:: with SMTP id m17mr2516874pjz.26.1617684757223;
        Mon, 05 Apr 2021 21:52:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c11sm16799166pgk.83.2021.04.05.21.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 21:52:36 -0700 (PDT)
Message-ID: <606be914.1c69fb81.1a48f.b6bb@mx.google.com>
Date:   Mon, 05 Apr 2021 21:52:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.264-28-gdc11e03076dc0
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 84 runs,
 10 regressions (v4.4.264-28-gdc11e03076dc0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 84 runs, 10 regressions (v4.4.264-28-gdc11e03=
076dc0)

Regressions Summary
-------------------

platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
dove-cubox          | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =

qemu_i386-uefi      | i386 | lab-broonie     | gcc-8    | i386_defconfig   =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.264-28-gdc11e03076dc0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.264-28-gdc11e03076dc0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dc11e03076dc06b35d73306e4c21dff6005510c4 =



Test Regressions
---------------- =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
dove-cubox          | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/606baff9537d086f1cdac6c3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.264-2=
8-gdc11e03076dc0/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove=
-cubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.264-2=
8-gdc11e03076dc0/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove=
-cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606baff9537d086f1cdac=
6c4
        new failure (last pass: v4.4.264-20-gd676fabf20df3) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/606bb46a090f23f327dac6c1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.264-2=
8-gdc11e03076dc0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.264-2=
8-gdc11e03076dc0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606bb46a090f23f327dac=
6c2
        failing since 143 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/606bb3a35a491297a7dac6ba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.264-2=
8-gdc11e03076dc0/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.264-2=
8-gdc11e03076dc0/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606bb3a35a491297a7dac=
6bb
        failing since 143 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/606bb5b9875dbab0f4dac6ca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.264-2=
8-gdc11e03076dc0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.264-2=
8-gdc11e03076dc0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606bb5b9875dbab0f4dac=
6cb
        failing since 143 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv2 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/606bb2f7a5f55650a0dac6be

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.264-2=
8-gdc11e03076dc0/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.264-2=
8-gdc11e03076dc0/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606bb2f7a5f55650a0dac=
6bf
        failing since 143 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre    | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/606bb3dedc1f8b627adac6da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.264-2=
8-gdc11e03076dc0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.264-2=
8-gdc11e03076dc0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606bb3dedc1f8b627adac=
6db
        failing since 143 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-broonie     | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/606bb3674bd3190b4cdac6d1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.264-2=
8-gdc11e03076dc0/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.264-2=
8-gdc11e03076dc0/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606bb3674bd3190b4cdac=
6d2
        failing since 143 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora   | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/606bb54a380dea876bdac6c6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.264-2=
8-gdc11e03076dc0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.264-2=
8-gdc11e03076dc0/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606bb54a380dea876bdac=
6c7
        failing since 143 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_arm-virt-gicv3 | arm  | lab-linaro-lkft | gcc-8    | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/606bb2f6f0a6b2d4c0dac6ce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.264-2=
8-gdc11e03076dc0/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.264-2=
8-gdc11e03076dc0/arm/multi_v7_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606bb2f6f0a6b2d4c0dac=
6cf
        failing since 143 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab             | compiler | defconfig        =
  | regressions
--------------------+------+-----------------+----------+------------------=
--+------------
qemu_i386-uefi      | i386 | lab-broonie     | gcc-8    | i386_defconfig   =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/606bb0d5b2915f02f1dac6c6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.264-2=
8-gdc11e03076dc0/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-u=
efi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.264-2=
8-gdc11e03076dc0/i386/i386_defconfig/gcc-8/lab-broonie/baseline-qemu_i386-u=
efi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606bb0d5b2915f02f1dac=
6c7
        new failure (last pass: v4.4.264-20-gd676fabf20df3) =

 =20
