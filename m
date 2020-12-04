Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9672CE66F
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 04:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727156AbgLDDXS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 22:23:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbgLDDXS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 22:23:18 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48728C061A4F
        for <stable@vger.kernel.org>; Thu,  3 Dec 2020 19:22:38 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id t8so2740753pfg.8
        for <stable@vger.kernel.org>; Thu, 03 Dec 2020 19:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AtihHdPmuhTVxWG1GRmWp6vSZIwQ7ifE/C2b78ecVvQ=;
        b=Oyx3RR13LnMw13Fa81thadIbURZI9jvxmtsqgYQD0oodPWSWOHvZsmCkXVUAmmR6Np
         +jJ1vGJkrUojbH9VkR6ERQw+1yagkBGcjn58LDgR/b78FW8SQpK3QaDHKri4MGHONCr7
         v1HHrQh7NtomHI9/hrIuMrM7JsjJ2ATQHdEKIem9N3XoYdpxFcHxqzBI9JY4H6ngIMrg
         IzO5WT2InhYa0/hUDC1++ay98Nwl6BSk2f2CIqsUQXYg9qVzRBTnxoJmjcz0utIzsWt9
         FQ1MFaYksfPVWIqBMLGA4IO6ZwZu4DCrSUJIGSLmd4uycbw0SE9fUXCVTZYtP2j5FP8H
         wtiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AtihHdPmuhTVxWG1GRmWp6vSZIwQ7ifE/C2b78ecVvQ=;
        b=sVUu5rRQGO44uzoQIX9C809ppKXOYvquWHLO+Butp5Yn1ULlnzJ8p+cPvAVKf7HwbR
         P17FdQPmk+/ppikupt2XBktlnOOmbmAEl1hORA0G9jC6Aew+VxZBkU3wKzjeo+ESsw3Q
         Sc1NbNoZUF2qp+1uGtHse1cVLlD3/A7FkXau7XlLC7w6OZVLBfwgJwcROL0lgzrRcosi
         dpgVk/CvgD+9CdqqH+maRh5cILyBYeolr7uR60bmWQJ4muqBKE8uBK/fPQr8/qLW0dv6
         C+4rPaH8B0DkmaYk6KF0f6GuiFVtuQBpjqrutCiTMmSLAFzVFjbMU4P9r+Gno8084Pjm
         MlYg==
X-Gm-Message-State: AOAM531GpqeTEv8Qb/7DBsHguRaITioVT/baTFhY2BzxZees1/8I3fnp
        lf/6ASitqEjjWMUFgXPoXok0gcW4mxkZVA==
X-Google-Smtp-Source: ABdhPJxz0aym3BCLEP9m86QLYtj5hSNuB8pxqlymoDlEy9Y3HxhHKTq3WmAvFHNtIXy7aOA8sJtksQ==
X-Received: by 2002:a62:bd06:0:b029:19d:b6f3:9871 with SMTP id a6-20020a62bd060000b029019db6f39871mr1886825pff.70.1607052157339;
        Thu, 03 Dec 2020 19:22:37 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 5sm3163047pfx.63.2020.12.03.19.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 19:22:36 -0800 (PST)
Message-ID: <5fc9ab7c.1c69fb81.fe9ee.8333@mx.google.com>
Date:   Thu, 03 Dec 2020 19:22:36 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.161-13-g090ec202335e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 189 runs,
 9 regressions (v4.19.161-13-g090ec202335e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 189 runs, 9 regressions (v4.19.161-13-g090ec=
202335e)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
       | regressions
---------------------+-------+-----------------+----------+----------------=
-------+------------
da850-lcdk           | arm   | lab-baylibre    | gcc-8    | davinci_all_def=
config | 2          =

hip07-d05            | arm64 | lab-collabora   | gcc-8    | defconfig      =
       | 1          =

panda                | arm   | lab-collabora   | gcc-8    | omap2plus_defco=
nfig   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig   | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig   | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig   | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig   | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.161-13-g090ec202335e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.161-13-g090ec202335e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      090ec202335eaccf0659c74f03bb3d3c3dd8ffa4 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
       | regressions
---------------------+-------+-----------------+----------+----------------=
-------+------------
da850-lcdk           | arm   | lab-baylibre    | gcc-8    | davinci_all_def=
config | 2          =


  Details:     https://kernelci.org/test/plan/id/5fc977b09b5fa42a2cc94ce0

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: davinci_all_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g090ec202335e/arm/davinci_all_defconfig/gcc-8/lab-baylibre/baseline-da8=
50-lcdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g090ec202335e/arm/davinci_all_defconfig/gcc-8/lab-baylibre/baseline-da8=
50-lcdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/5fc977b09b5fa42=
a2cc94ce4
        new failure (last pass: v4.19.161-13-g08c271310ea3)
        3 lines

    2020-12-03 23:41:30.137000+00:00  kern  :alert : page dumped because: n=
onzero mapcount   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fc977b09b5fa42=
a2cc94ce5
        new failure (last pass: v4.19.161-13-g08c271310ea3)
        2 lines

    2020-12-03 23:41:30.329000+00:00  kern  :emerg : flags: 0x0()   =

 =



platform             | arch  | lab             | compiler | defconfig      =
       | regressions
---------------------+-------+-----------------+----------+----------------=
-------+------------
hip07-d05            | arm64 | lab-collabora   | gcc-8    | defconfig      =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc97739ca506fff8fc94cc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g090ec202335e/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g090ec202335e/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc97739ca506fff8fc94=
cc2
        new failure (last pass: v4.19.161-13-g08c271310ea3) =

 =



platform             | arch  | lab             | compiler | defconfig      =
       | regressions
---------------------+-------+-----------------+----------+----------------=
-------+------------
panda                | arm   | lab-collabora   | gcc-8    | omap2plus_defco=
nfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc9797f3692b61552c94cb9

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g090ec202335e/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g090ec202335e/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fc9797f3692b61=
552c94cbe
        failing since 3 days (last pass: v4.19.160-13-g8733751e476a, first =
fail: v4.19.160-50-ge829433bf8e6)
        2 lines

    2020-12-03 23:49:14.395000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/109
    2020-12-03 23:49:14.405000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch  | lab             | compiler | defconfig      =
       | regressions
---------------------+-------+-----------------+----------+----------------=
-------+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc977f4684d019e8cc94cda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g090ec202335e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g090ec202335e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc977f4684d019e8cc94=
cdb
        failing since 20 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab             | compiler | defconfig      =
       | regressions
---------------------+-------+-----------------+----------+----------------=
-------+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc977e87aec944e6bc94cda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g090ec202335e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g090ec202335e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc977e87aec944e6bc94=
cdb
        failing since 20 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab             | compiler | defconfig      =
       | regressions
---------------------+-------+-----------------+----------+----------------=
-------+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc977e2684d019e8cc94cc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g090ec202335e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g090ec202335e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc977e2684d019e8cc94=
cc6
        failing since 20 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab             | compiler | defconfig      =
       | regressions
---------------------+-------+-----------------+----------+----------------=
-------+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc9778856821c2d62c94ccf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g090ec202335e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g090ec202335e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc9778856821c2d62c94=
cd0
        failing since 20 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab             | compiler | defconfig      =
       | regressions
---------------------+-------+-----------------+----------+----------------=
-------+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc97796ac887adbc8c94cdf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g090ec202335e/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g090ec202335e/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc97796ac887adbc8c94=
ce0
        failing since 20 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
