Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0B3B2CC6FC
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 20:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgLBTu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 14:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgLBTuZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 14:50:25 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEA7C0613CF
        for <stable@vger.kernel.org>; Wed,  2 Dec 2020 11:49:45 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id b10so1921724pfo.4
        for <stable@vger.kernel.org>; Wed, 02 Dec 2020 11:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3e4R07/1d3SeBs36fA4tsvQ++R798z095QVaMd2Go40=;
        b=msxlpkxox5q6dW6+CC7MqfoorPoeMNnNwxV0I8lphMlDbzBphx3pI+F4hLwZ/FUpOH
         v/TEMFZLPcKlVSOQBzcuHQPzclHORhafTAea6PgVKFf25ZD9gXqLV6DDaX5MmgA+uN1w
         YIOLe77mKBpNo/9Y5TKDVu5boUnr1ch87joNO3cQF2LHX3zVYd6Hcl5DIPvEnzUtgni2
         tH5xJHIKunOqXXyh/vc+S44LtrLw7OPjyEnnkTc/cQkp6jNBZGyee1FwdRuoibReW+zr
         nZ+oMeue7vKbMgC5Hl4LC494B8eWEPSWk4TrRBoB1GkbWmHblAqbNyQb1/j5+03WMbLp
         I8yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3e4R07/1d3SeBs36fA4tsvQ++R798z095QVaMd2Go40=;
        b=YojJ7KgULjUs0d2w0LeUYuji/b5aQmKl+tCswZTO10l4hQcLXC0cxc0cAN4ARareiC
         gYkYeFxle5d/R1f0oRUGLh84lZdOsrLqLwIDWCGetkOF/adntVXhfVlUPJ5QQQw77qbk
         ZjUh90h71mi9zocgETr629LVzreWs39ClMFXycNzAe7MCwZ4JtsPpV5AlBkYXX+s3doB
         rOVlrOjp7g6/1N6D9zcqzPpwB//jLyelcOv9qJ9PtPxBK0234Z2t7RXOukaA/aufwiQ4
         XXMHx7bUnuFfcWVBk0isjM6S7g1iUAz2FTofh6yxVgDXZbHoeSmx59bYKV7zpzDPnShx
         LBNw==
X-Gm-Message-State: AOAM5314uZf+ZrS+wxkNwyvfm5bxD82CZMh+IMkjzRl2d8SLGLMOrCND
        ZUVAiaeXxQgpJYh4a5XrTqyAg7y0zBtopA==
X-Google-Smtp-Source: ABdhPJy0ePXWtQ52+cTKjzunevfxJ0ESRPG/kSuqYMI3Ad9keYpuVUmAvEGwOW1r0NYRh64wP7T0IA==
X-Received: by 2002:a05:6a00:1481:b029:197:fc39:f646 with SMTP id v1-20020a056a001481b0290197fc39f646mr4011095pfu.57.1606938584660;
        Wed, 02 Dec 2020 11:49:44 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o2sm535420pgq.63.2020.12.02.11.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 11:49:44 -0800 (PST)
Message-ID: <5fc7efd8.1c69fb81.ae21a.1ace@mx.google.com>
Date:   Wed, 02 Dec 2020 11:49:44 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.161-13-g2523a0a7f663
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 180 runs,
 7 regressions (v4.19.161-13-g2523a0a7f663)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 180 runs, 7 regressions (v4.19.161-13-g2523a=
0a7f663)

Regressions Summary
-------------------

platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
panda                     | arm  | lab-collabora   | gcc-8    | omap2plus_d=
efconfig | 1          =

qemu_arm-versatilepb      | arm  | lab-baylibre    | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb      | arm  | lab-broonie     | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb      | arm  | lab-cip         | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb      | arm  | lab-collabora   | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb      | arm  | lab-linaro-lkft | gcc-8    | versatile_d=
efconfig | 1          =

sun8i-h2-plus-orangepi-r1 | arm  | lab-baylibre    | gcc-8    | multi_v7_de=
fconfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.161-13-g2523a0a7f663/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.161-13-g2523a0a7f663
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2523a0a7f663754e2a57fa1d8edf8ca6ea1d1e32 =



Test Regressions
---------------- =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
panda                     | arm  | lab-collabora   | gcc-8    | omap2plus_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7b74406d66cbe0dc94ccf

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g2523a0a7f663/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g2523a0a7f663/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fc7b74406d66cb=
e0dc94cd4
        failing since 2 days (last pass: v4.19.160-13-g8733751e476a, first =
fail: v4.19.160-50-ge829433bf8e6)
        2 lines =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
qemu_arm-versatilepb      | arm  | lab-baylibre    | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7b6647063069fdac94d06

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g2523a0a7f663/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g2523a0a7f663/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7b6647063069fdac94=
d07
        failing since 18 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
qemu_arm-versatilepb      | arm  | lab-broonie     | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7bccf4a9dcc4c0bc94cba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g2523a0a7f663/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g2523a0a7f663/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7bccf4a9dcc4c0bc94=
cbb
        failing since 18 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
qemu_arm-versatilepb      | arm  | lab-cip         | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7b665b5efc328d1c94cd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g2523a0a7f663/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g2523a0a7f663/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7b665b5efc328d1c94=
cd5
        failing since 18 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
qemu_arm-versatilepb      | arm  | lab-collabora   | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7b9201e46f63a0bc94cbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g2523a0a7f663/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g2523a0a7f663/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7b9201e46f63a0bc94=
cc0
        failing since 18 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
qemu_arm-versatilepb      | arm  | lab-linaro-lkft | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7b7876c9c3060d7c94cc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g2523a0a7f663/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g2523a0a7f663/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7b7876c9c3060d7c94=
cc6
        failing since 18 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                  | arch | lab             | compiler | defconfig  =
         | regressions
--------------------------+------+-----------------+----------+------------=
---------+------------
sun8i-h2-plus-orangepi-r1 | arm  | lab-baylibre    | gcc-8    | multi_v7_de=
fconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc7b69f1137da52cac94d02

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g2523a0a7f663/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8i-=
h2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.161=
-13-g2523a0a7f663/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-sun8i-=
h2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc7b69f1137da52cac94=
d03
        new failure (last pass: v4.19.161-13-g30b360cf1996) =

 =20
