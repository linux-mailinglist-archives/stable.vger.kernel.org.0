Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 978F12BC8CA
	for <lists+stable@lfdr.de>; Sun, 22 Nov 2020 20:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbgKVTiI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Nov 2020 14:38:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbgKVTiI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Nov 2020 14:38:08 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34CFC0613CF
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 11:38:07 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id p6so5374795plr.7
        for <stable@vger.kernel.org>; Sun, 22 Nov 2020 11:38:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BQtjV9REbLE5OpIXziP4RO2DW0dGQ+DQbQYcUZYXK54=;
        b=IZBFjWEOtpuue914gSvbThsu7D0OLunIJ/eN/8soGl1wJjQ1WG0wYnldJflMtOmXH3
         NSOFTvqAsNEMQyQlFdBPbL5PWRJzL0OOYQU/ak91XKQ3RM9YWTq22yNN+AQoE00/VcBK
         oIslvgAU42+LqxihBaZEqFwswW5Cg+oayQqfCcrjsJ/kNiTwBkwqjkn9eUxOkxc7kwfI
         fQVbTgSgznz5j4wu1StgvWvpaFKo07HuuKEZ3rEWfnAkHUcfyELmFcbcw7XLQjHu+0XH
         ckdnRLlBieKiSUQSOrI4yr0gvIL5YVbzGg/g7Fnn1Rp4mjh+03hifZ89FH45uzKg/B2A
         aSWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BQtjV9REbLE5OpIXziP4RO2DW0dGQ+DQbQYcUZYXK54=;
        b=Zn6ErtMS7pWfg9r+gviCJjHG7wY17aOiFjbTJyYVNbKJkpUacQ9FH+u+/UwYtEZg+d
         wkQelXNtbdGSdpcVpbQnbyA5xxLjB2FBE+OdcOQGPmYtg1HMvMwBVj71tPdha+q+0fS4
         vA7eN289+DBbcN7ZI2mlibLmo7qmbwYV5L5B6f9Q3c09M2OXL3UxYh6ucF8Lfjsp1zQM
         fzRy1FsA+oeXt3YEeluYpTLa6//Fqp3UKZls6M4m84UDTW93FeVyTAG7MHioRDRxW5k0
         ZC8Skvpu5obwJu6Vhc1soT2fBmi/8e1N7q3+mvWLMcUEjIuwAZd45CMgrwe4OLyDCYse
         tPFA==
X-Gm-Message-State: AOAM532iadF7de+mcsEz50EVb3ZabPChEyhi/yHoCbD3eJ1oahSfZljd
        p888TuwT+Jk3jiZpZtGswvDNyeln2Xy9AQ==
X-Google-Smtp-Source: ABdhPJyxIpWw21WG+4NsQDpxrQ5CKN7vCve+LrVo6BgLdLDVfto/bacNo6Phr2GTLiFr0mfYiyl8MA==
X-Received: by 2002:a17:902:744a:b029:d6:8b8c:622d with SMTP id e10-20020a170902744ab02900d68b8c622dmr21655967plt.67.1606073884778;
        Sun, 22 Nov 2020 11:38:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d2sm11216131pji.7.2020.11.22.11.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2020 11:38:03 -0800 (PST)
Message-ID: <5fbabe1b.1c69fb81.5ac3d.79dd@mx.google.com>
Date:   Sun, 22 Nov 2020 11:38:03 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.245
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 106 runs, 12 regressions (v4.4.245)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 106 runs, 12 regressions (v4.4.245)

Regressions Summary
-------------------

platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
beagle-xm           | arm    | lab-baylibre  | gcc-8    | omap2plus_defconf=
ig | 2          =

qemu_arm-virt-gicv2 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_i386           | i386   | lab-baylibre  | gcc-8    | i386_defconfig   =
   | 1          =

qemu_x86_64-uefi    | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.245/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.245
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      899c58731b77ce6bbf991286b016be278a23a2da =



Test Regressions
---------------- =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
beagle-xm           | arm    | lab-baylibre  | gcc-8    | omap2plus_defconf=
ig | 2          =


  Details:     https://kernelci.org/test/plan/id/5fba8b73a8ff6843f4d8d91d

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.245=
/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.245=
/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fba8b73a8ff6843=
f4d8d920
        new failure (last pass: v4.4.244)
        1 lines

    2020-11-22 16:00:05.100000+00:00  Connected to omap3-beagle-xm console =
[channel connected] (~$quit to exit)
    2020-11-22 16:00:05.100000+00:00  (user:) is already connected
    2020-11-22 16:00:05.101000+00:00  (user:) is already connected
    2020-11-22 16:00:05.101000+00:00  (user:khilman) is already connected
    2020-11-22 16:00:05.101000+00:00  (user:) is already connected
    2020-11-22 16:00:05.101000+00:00  (user:) is already connected
    2020-11-22 16:00:05.101000+00:00  (user:) is already connected
    2020-11-22 16:00:05.102000+00:00  (user:) is already connected
    2020-11-22 16:00:05.102000+00:00  (user:) is already connected
    2020-11-22 16:00:05.102000+00:00  (user:) is already connected =

    ... (470 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fba8b73a8ff684=
3f4d8d922
        new failure (last pass: v4.4.244)
        28 lines

    2020-11-22 16:01:50.512000+00:00  kern  :emerg : Stack: (0xcb94bd10 to =
0xcb94c000)
    2020-11-22 16:01:50.519000+00:00  kern  :emerg : bd00:                 =
                    bf02b8fc bf010b84 cba45410 bf02b988
    2020-11-22 16:01:50.527000+00:00  kern  :emerg : bd20: cba45410 bf2600a=
8 00000002 cb90f010 cba45410 bf28db54 cbcfc030 cbcfc030
    2020-11-22 16:01:50.536000+00:00  kern  :emerg : bd40: 00000000 0000000=
0 ce226930 c01fb390 ce226930 ce226930 c085969c 00000001
    2020-11-22 16:01:50.544000+00:00  kern  :emerg : bd60: ce226930 cbcfc03=
0 cbcfc0f0 00000000 ce226930 c085969c 00000001 c09632c0
    2020-11-22 16:01:50.552000+00:00  kern  :emerg : bd80: ffffffed bf291ff=
4 fffffdfb 00000026 00000001 c00ce2b4 bf292188 c040722c
    2020-11-22 16:01:50.560000+00:00  kern  :emerg : bda0: c09632c0 c120ea3=
0 bf291ff4 00000000 00000026 c0405700 c09632c0 c09632f4
    2020-11-22 16:01:50.568000+00:00  kern  :emerg : bdc0: bf291ff4 0000000=
0 00000000 c04058a8 00000000 bf291ff4 c040581c c0403bcc
    2020-11-22 16:01:50.576000+00:00  kern  :emerg : bde0: ce0c38a4 ce22091=
0 bf291ff4 cbb940c0 c09ddb68 c0404d18 bf290b6c c0960460
    2020-11-22 16:01:50.585000+00:00  kern  :emerg : be00: cbcf2680 bf291ff=
4 c0960460 cbcf2680 bf295000 c04062e0 c0960460 c0960460 =

    ... (16 line(s) more)  =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba8caadc817ec63cd8d911

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.245=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.245=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba8caadc817ec63cd8d=
912
        failing since 8 days (last pass: v4.4.243-14-gcb8e837cb602, first f=
ail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba8c2724b62b01cad8d955

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.245=
/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.245=
/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba8c2724b62b01cad8d=
956
        failing since 8 days (last pass: v4.4.243-14-gcb8e837cb602, first f=
ail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba8c1a24b62b01cad8d916

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.245=
/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.245=
/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba8c1a24b62b01cad8d=
917
        failing since 8 days (last pass: v4.4.243-14-gcb8e837cb602, first f=
ail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba8c0e9ddda1e70bd8d920

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.245=
/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.245=
/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-virt-gicv2.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba8c0e9ddda1e70bd8d=
921
        failing since 8 days (last pass: v4.4.243-14-gcb8e837cb602, first f=
ail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba8c86f5a14a8545d8d929

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.245=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.245=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba8c86f5a14a8545d8d=
92a
        failing since 8 days (last pass: v4.4.243-14-gcb8e837cb602, first f=
ail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba8c2624b62b01cad8d952

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.245=
/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.245=
/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba8c2624b62b01cad8d=
953
        failing since 8 days (last pass: v4.4.243-14-gcb8e837cb602, first f=
ail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba8cc552ca43563dd8d908

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.245=
/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.245=
/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba8cc552ca43563dd8d=
909
        failing since 8 days (last pass: v4.4.243-14-gcb8e837cb602, first f=
ail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba8cc1440b4be392d8d901

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.245=
/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.245=
/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-virt-gicv3.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba8cc1440b4be392d8d=
902
        failing since 8 days (last pass: v4.4.243-14-gcb8e837cb602, first f=
ail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_i386           | i386   | lab-baylibre  | gcc-8    | i386_defconfig   =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba89a18e63fea0c4d8d919

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.245=
/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.245=
/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba89a18e63fea0c4d8d=
91a
        new failure (last pass: v4.4.244) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_x86_64-uefi    | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fba8b2b1a6959a0edd8d92c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.245=
/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.245=
/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fba8b2b1a6959a0edd8d=
92d
        new failure (last pass: v4.4.244-16-g11095ab90e22a) =

 =20
