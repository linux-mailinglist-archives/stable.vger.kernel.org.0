Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D632C2CE587
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 03:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgLDCHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 21:07:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725885AbgLDCHI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Dec 2020 21:07:08 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2471C061A4F
        for <stable@vger.kernel.org>; Thu,  3 Dec 2020 18:06:27 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id x24so2640001pfn.6
        for <stable@vger.kernel.org>; Thu, 03 Dec 2020 18:06:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4MzbvzJXhmjenKE4aQTsQvmqqCM5v695bJKgG8VYGqY=;
        b=HI3xJtq8rh+pyKAPJgz3ULBNUmYi52OtqNQu/QQfa3gFi67+KgZ5FZsLri5As0Ao2F
         8x5OATMseDwXqPVsWAHf4H2b3kXmY86zeIdzqbIAcwF+IlM4jmZ0BFWF2MWbeKhEMF4U
         P3dxO6Co1Gehk2lIUkfCkhdxznevbJV51C3P8H935JpEI6kjerj8qpt6tuf9zUjiWLFu
         3rxCZcPmWmR2LUEb8YqRsCts7JwFbe7AmWN5stB7Zl+T/yurlqsdr01EOP03BWxMx5JD
         hAfBGd5yAYHlSWK9QXQtOoFVPefpbFRG+hhP7pzV0hoFdMudbBEK7C09Ubq9mzz5Za4y
         WpBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4MzbvzJXhmjenKE4aQTsQvmqqCM5v695bJKgG8VYGqY=;
        b=JmKBU32IHf7a6/I2c0qd6qnxq+n4/bmS840hbAein25Inq5W6kya7sO31Gftyb53W/
         ZlCoQEsFTw+ivkpldG9qaZkBQ7cDgKjmxFw4khKiUCrFlMuqMRX4tvpwu717XT6mpFL5
         Ye4fkeWB4Xtpr0a1S32YFTu2eR9AESypLI6ZMKGCa8yWTUblYphWWk3NlEHbKr/cVfu9
         f6F+f5WAnQa1M/1G+qMtt7/fAfgTPCfxaKm3RoxhRCTgNVBs3FvfEgH9qeYmTdgP+G3W
         VlGFrbRdeoDNLTfJXgJHuh8+hWRGPdBqMX96dflNRSnKfjFD9w0Ur6aVYr5Y2UuVtwkj
         S1Rw==
X-Gm-Message-State: AOAM531/4LVcb+rfxJylBnTZy8C12EkgmFpsdyPNrlfZcT/znbWN2Zrm
        FaqN4KVyibhsYDQMVKLaWU9teL9yIISYww==
X-Google-Smtp-Source: ABdhPJwU2wa4zi2IkmdXbXD/X3RDZPwibzAh74pRmUKYkLnPz/eCzHIWqrj4v2m8tA5NvRr5iA7cyw==
X-Received: by 2002:aa7:8f3c:0:b029:197:d067:4e53 with SMTP id y28-20020aa78f3c0000b0290197d0674e53mr1638793pfr.24.1607047586659;
        Thu, 03 Dec 2020 18:06:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ck20sm523916pjb.20.2020.12.03.18.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 18:06:26 -0800 (PST)
Message-ID: <5fc999a2.1c69fb81.48dc8.2761@mx.google.com>
Date:   Thu, 03 Dec 2020 18:06:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.247-4-g0d2b3115de6c
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 143 runs,
 9 regressions (v4.9.247-4-g0d2b3115de6c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 143 runs, 9 regressions (v4.9.247-4-g0d2b3115=
de6c)

Regressions Summary
-------------------

platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
at91-sama5d4_xplained | arm    | lab-baylibre    | gcc-8    | sama5_defconf=
ig     | 1          =

panda                 | arm    | lab-collabora   | gcc-8    | omap2plus_def=
config | 1          =

qemu_arm-versatilepb  | arm    | lab-baylibre    | gcc-8    | versatile_def=
config | 1          =

qemu_arm-versatilepb  | arm    | lab-broonie     | gcc-8    | versatile_def=
config | 1          =

qemu_arm-versatilepb  | arm    | lab-cip         | gcc-8    | versatile_def=
config | 1          =

qemu_arm-versatilepb  | arm    | lab-collabora   | gcc-8    | versatile_def=
config | 1          =

qemu_arm-versatilepb  | arm    | lab-linaro-lkft | gcc-8    | versatile_def=
config | 1          =

qemu_x86_64-uefi      | x86_64 | lab-baylibre    | gcc-8    | x86_64_defcon=
fig    | 1          =

r8a7795-salvator-x    | arm64  | lab-baylibre    | gcc-8    | defconfig    =
       | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.247-4-g0d2b3115de6c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.247-4-g0d2b3115de6c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0d2b3115de6c4dcb7b9ece47a9bed2a2eeed6bbe =



Test Regressions
---------------- =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
at91-sama5d4_xplained | arm    | lab-baylibre    | gcc-8    | sama5_defconf=
ig     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc966e3c4c07cc7a9c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g0d2b3115de6c/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g0d2b3115de6c/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc966e3c4c07cc7a9c94=
cba
        failing since 35 days (last pass: v4.9.240-139-gd719c4ad8056, first=
 fail: v4.9.240-139-g65bd9a74252c) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
panda                 | arm    | lab-collabora   | gcc-8    | omap2plus_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc9677a0479e1aebbc94cdc

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g0d2b3115de6c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g0d2b3115de6c/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fc9677a0479e1a=
ebbc94ce1
        new failure (last pass: v4.9.246-41-g942c26d92acab)
        2 lines =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_arm-versatilepb  | arm    | lab-baylibre    | gcc-8    | versatile_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc966ef9a4bf85805c94cd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g0d2b3115de6c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g0d2b3115de6c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc966ef9a4bf85805c94=
cd6
        failing since 19 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_arm-versatilepb  | arm    | lab-broonie     | gcc-8    | versatile_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc96934ce91926465c94cd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g0d2b3115de6c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g0d2b3115de6c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc96934ce91926465c94=
cda
        failing since 19 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_arm-versatilepb  | arm    | lab-cip         | gcc-8    | versatile_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc966f89a4bf85805c94cda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g0d2b3115de6c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g0d2b3115de6c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc966f89a4bf85805c94=
cdb
        failing since 19 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_arm-versatilepb  | arm    | lab-collabora   | gcc-8    | versatile_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc966a5217b897074c94cbd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g0d2b3115de6c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g0d2b3115de6c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc966a5217b897074c94=
cbe
        failing since 19 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_arm-versatilepb  | arm    | lab-linaro-lkft | gcc-8    | versatile_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc97221a085db6957c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g0d2b3115de6c/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g0d2b3115de6c/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc97221a085db6957c94=
cba
        failing since 19 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_x86_64-uefi      | x86_64 | lab-baylibre    | gcc-8    | x86_64_defcon=
fig    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc967646d6b050a93c94ceb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g0d2b3115de6c/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86=
_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g0d2b3115de6c/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86=
_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc967646d6b050a93c94=
cec
        new failure (last pass: v4.9.247-4-g64929b2209010) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
r8a7795-salvator-x    | arm64  | lab-baylibre    | gcc-8    | defconfig    =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/5fc965e7389c6f2e4cc94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g0d2b3115de6c/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator=
-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.247-4=
-g0d2b3115de6c/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvator=
-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fc965e7389c6f2e4cc94=
cc4
        failing since 15 days (last pass: v4.9.243-24-ga8ede488cf7a, first =
fail: v4.9.243-77-g36ec779d6aa89) =

 =20
