Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF3F2D6B89
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 00:38:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725825AbgLJXF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 18:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731142AbgLJXFK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 18:05:10 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8799CC0613D6
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 15:04:55 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id y8so3591262plp.8
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 15:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=T6Jo6UDyv7VSOqwu8xuMyudh6i0MRnPELzTXRwWMLoU=;
        b=j0ordcU+auOn5C94EoHW3065WWvA/lXu360gP6xAbTeByibfQ+m0ZUNB6F7ADzXze6
         yOlpCN8ueYnJ5cBHh014lnMwGXe/USBFqN3Eys8VVclK1bguiaaHwi0oguto3BGlcs9V
         KOeHxjKOdLDrP7S9C8OEhnRq7CItLxopUaRyUqgHNJIh0vDL/+huOCmifiPOUjpn41Nw
         0PYVNq9WcZhIuofYyPGxfpX2A8LrQmGbl5/Is50yhvwU8c+1NfqGtmJxPS7gVVwmmzu1
         WBhqR3O5f4213P0oZ7U02WYgUWs0YgayF6dDo7sliXyfyGSdguuR9lf7cL8LvcKeNxZd
         9bfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=T6Jo6UDyv7VSOqwu8xuMyudh6i0MRnPELzTXRwWMLoU=;
        b=dUnBspDw6UuHHi/BpNwkeLS+h3dbH3/xYsUvacaPwDLk67cLLP55f63OtoRMIOIcN7
         kuYggGOvsYIlbD8+56u7ZxPBRleGa1fAAditLOsOK311ilADc6r+36Mb6r5xco1yoaUI
         XPIomJKElSvKrZiS9wj5ykS49MOismzChblEBPDKVF9sDRwbdYYBrZHVmSBhA9HDVmyv
         NxWfYFNBbhegLbUywytciFBP7B3487at1IyGWV1+XwWGG2+3xbBmQecb+DaDnu54iUAi
         TcTQD0Maa/FULQMmsys5XH06EWRNqD+OyE6No9bXoqqAOTn+rUp9bOIUPBBrTF1IMR/F
         1vcg==
X-Gm-Message-State: AOAM5334BSXkaP8hpwbok1XUGa0kmX565szO6jVi5uJTik3m0kMCEMK+
        tgFU49nCQE9l3kqXkxTPo6/+MQuS1xWRpA==
X-Google-Smtp-Source: ABdhPJz6AX6fIm0kNyfrAgr87LqvUXAz+sxNaaZXnPTiECV0C+0+ru4QR3gHQQjX4b6Glejjic+Dag==
X-Received: by 2002:a17:902:c104:b029:da:5206:8b9b with SMTP id 4-20020a170902c104b02900da52068b9bmr8170501pli.46.1607641493940;
        Thu, 10 Dec 2020 15:04:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k21sm7356966pfu.77.2020.12.10.15.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 15:04:52 -0800 (PST)
Message-ID: <5fd2a994.1c69fb81.985f2.dc68@mx.google.com>
Date:   Thu, 10 Dec 2020 15:04:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.247-45-gd6c029b43547
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 118 runs,
 9 regressions (v4.9.247-45-gd6c029b43547)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 118 runs, 9 regressions (v4.9.247-45-gd6c02=
9b43547)

Regressions Summary
-------------------

platform                   | arch   | lab             | compiler | defconfi=
g           | regressions
---------------------------+--------+-----------------+----------+---------=
------------+------------
imx27-phytec-phycard-s-rdk | arm    | lab-pengutronix | gcc-8    | multi_v5=
_defconfig  | 1          =

panda                      | arm    | lab-collabora   | gcc-8    | omap2plu=
s_defconfig | 1          =

qemu_arm-versatilepb       | arm    | lab-baylibre    | gcc-8    | versatil=
e_defconfig | 1          =

qemu_arm-versatilepb       | arm    | lab-broonie     | gcc-8    | versatil=
e_defconfig | 1          =

qemu_arm-versatilepb       | arm    | lab-cip         | gcc-8    | versatil=
e_defconfig | 1          =

qemu_arm-versatilepb       | arm    | lab-collabora   | gcc-8    | versatil=
e_defconfig | 1          =

qemu_i386                  | i386   | lab-baylibre    | gcc-8    | i386_def=
config      | 1          =

qemu_x86_64                | x86_64 | lab-baylibre    | gcc-8    | x86_64_d=
efconfig    | 1          =

r8a7795-salvator-x         | arm64  | lab-baylibre    | gcc-8    | defconfi=
g           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.247-45-gd6c029b43547/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.247-45-gd6c029b43547
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d6c029b435470eec6ccf5c2065b0512b75d92419 =



Test Regressions
---------------- =



platform                   | arch   | lab             | compiler | defconfi=
g           | regressions
---------------------------+--------+-----------------+----------+---------=
------------+------------
imx27-phytec-phycard-s-rdk | arm    | lab-pengutronix | gcc-8    | multi_v5=
_defconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd278cd92d11a9e25c94ccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-45-gd6c029b43547/arm/multi_v5_defconfig/gcc-8/lab-pengutronix/baseline-imx=
27-phytec-phycard-s-rdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-45-gd6c029b43547/arm/multi_v5_defconfig/gcc-8/lab-pengutronix/baseline-imx=
27-phytec-phycard-s-rdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd278cd92d11a9e25c94=
cce
        new failure (last pass: v4.9.247-42-gf761790c11ce) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g           | regressions
---------------------------+--------+-----------------+----------+---------=
------------+------------
panda                      | arm    | lab-collabora   | gcc-8    | omap2plu=
s_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd2790c67b6d6dcfac94ccb

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-45-gd6c029b43547/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-45-gd6c029b43547/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fd2790c67b6d6d=
cfac94cd0
        failing since 1 day (last pass: v4.9.247, first fail: v4.9.247-34-g=
5c4e61c1e935)
        2 lines

    2020-12-10 19:37:43.454000+00:00  : emif_lock+0x0/0xfffff24c [emif], .m=
agic: 00000[   20.436309] usbcore: registered new interface driver smsc95xx
    2020-12-10 19:37:43.458000+00:00  000, .owner: <none>/-1, .owner_cpu: 0=
   =

 =



platform                   | arch   | lab             | compiler | defconfi=
g           | regressions
---------------------------+--------+-----------------+----------+---------=
------------+------------
qemu_arm-versatilepb       | arm    | lab-baylibre    | gcc-8    | versatil=
e_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd2750fa86f3ba582c94cd6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-45-gd6c029b43547/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-45-gd6c029b43547/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd2750fa86f3ba582c94=
cd7
        failing since 26 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g           | regressions
---------------------------+--------+-----------------+----------+---------=
------------+------------
qemu_arm-versatilepb       | arm    | lab-broonie     | gcc-8    | versatil=
e_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd276dd69eaa026c9c94ccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-45-gd6c029b43547/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-45-gd6c029b43547/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd276dd69eaa026c9c94=
ccd
        failing since 26 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g           | regressions
---------------------------+--------+-----------------+----------+---------=
------------+------------
qemu_arm-versatilepb       | arm    | lab-cip         | gcc-8    | versatil=
e_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd275100f69c1a5fac94cd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-45-gd6c029b43547/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-45-gd6c029b43547/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd275100f69c1a5fac94=
cd9
        failing since 26 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g           | regressions
---------------------------+--------+-----------------+----------+---------=
------------+------------
qemu_arm-versatilepb       | arm    | lab-collabora   | gcc-8    | versatil=
e_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd274d04c39a793bdc94cd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-45-gd6c029b43547/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-45-gd6c029b43547/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd274d04c39a793bdc94=
cd8
        failing since 26 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-26-g7b603f689c1c) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g           | regressions
---------------------------+--------+-----------------+----------+---------=
------------+------------
qemu_i386                  | i386   | lab-baylibre    | gcc-8    | i386_def=
config      | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd277a81f2ce9fb6dc94cd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-45-gd6c029b43547/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-45-gd6c029b43547/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd277a81f2ce9fb6dc94=
cd6
        new failure (last pass: v4.9.247-42-gf761790c11ce) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g           | regressions
---------------------------+--------+-----------------+----------+---------=
------------+------------
qemu_x86_64                | x86_64 | lab-baylibre    | gcc-8    | x86_64_d=
efconfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd277d796df0e538fc94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-45-gd6c029b43547/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-45-gd6c029b43547/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd277d796df0e538fc94=
cc9
        new failure (last pass: v4.9.247-42-gf761790c11ce) =

 =



platform                   | arch   | lab             | compiler | defconfi=
g           | regressions
---------------------------+--------+-----------------+----------+---------=
------------+------------
r8a7795-salvator-x         | arm64  | lab-baylibre    | gcc-8    | defconfi=
g           | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd277eb96df0e538fc94cd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-45-gd6c029b43547/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.247=
-45-gd6c029b43547/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd277eb96df0e538fc94=
cd8
        failing since 22 days (last pass: v4.9.243-17-g9c24315b745a0, first=
 fail: v4.9.243-79-gd3e70b39d31a) =

 =20
