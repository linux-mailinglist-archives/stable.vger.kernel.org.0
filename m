Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB292B8910
	for <lists+stable@lfdr.de>; Thu, 19 Nov 2020 01:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbgKSAb4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 19:31:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgKSAbz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 19:31:55 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8213FC0613D4
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 16:31:54 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id a18so2747500pfl.3
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 16:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3whzYoIpdagMXG8rQrN4NMa3bM096uSdHWxdVeIZvkk=;
        b=GJsS/17hGff/N0x8zfDXXfo3bWsNRwxaXxvVg6fa7E1U3gjLOWwfEa+9zKXSf9jQuZ
         YQHeOHbRcaSlnjJV5IHptvHRj4HoDm+ZPvLL83WW8+MLAkNrFphP5qfYcgzdMID59ZEA
         Nd7ZBhkZHZZVwnzF+u3g5hy0cu5XMJSLMeTA0zPMHdoBoK2k0vre33CEq12Ji7RoRTki
         ZW68US8kdzQwTI9nx9W83txQHLCHhCoM+/VaxK36Ztn6m2R4IGrvqr+PcnbQ+AmmWnjW
         /ZlGFGn1rm9WtLaTbjpsDoHPLGEyZm+4TNFF5oEIUEwrdamjYQiU3UJUSZs3CFlkBf0z
         QL1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3whzYoIpdagMXG8rQrN4NMa3bM096uSdHWxdVeIZvkk=;
        b=jip/PEgZHzKIb3LFOSHwPrtwhJyO1TUuH68IX+euw0z0HMvRY35EeAzHqm9OE/x8sl
         8l4fU61kCXrfvQ3eDH9qshNDK0lZTvTWqXeCDqudJTT6xL2v5GY7rwl+zupWwZ9g4VsN
         lRD2MMaF8hvevck45LHYKcBzj9NUGiuTHzDUbSMVwXd0K+T1qFgYuXnQTZ+BNYHlF+MW
         tO+csJ9RDXXc4BiJ3rs1WBCG2DciLKUerHEJwF4xNEOqRMzwchWfW/DG59Tm34KO/Skp
         4yLx+d4sS/nahrknV8cOGHn6bBSH2MZUzfCK0Vu147EdkYiwn8jgegdtJWV1opr2XxPC
         6ZUA==
X-Gm-Message-State: AOAM531fiJ7xI2uxZ8xWqVHS3gq3tcR55yeAt8AjJLL7fO5AfbdKJ46G
        yiQCVjdsYU2Rjp49cMrSRphILZ+r/3mq1g==
X-Google-Smtp-Source: ABdhPJxc2WVzgRLwpz7WV0aV7aDpGUDaPUEiX3lXO2sMWmuPr4MYVYmXPeQmcnluKuH2OBEVp7aMeg==
X-Received: by 2002:a17:90a:fa8c:: with SMTP id cu12mr1546958pjb.127.1605745913321;
        Wed, 18 Nov 2020 16:31:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z13sm26548100pff.167.2020.11.18.16.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 16:31:52 -0800 (PST)
Message-ID: <5fb5bcf8.1c69fb81.59060.9750@mx.google.com>
Date:   Wed, 18 Nov 2020 16:31:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.77-150-g9dee6749186ef
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 203 runs,
 12 regressions (v5.4.77-150-g9dee6749186ef)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 203 runs, 12 regressions (v5.4.77-150-g9dee67=
49186ef)

Regressions Summary
-------------------

platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
at91-sama5d4_xplained | arm    | lab-baylibre    | gcc-8    | sama5_defconf=
ig     | 1          =

bcm2837-rpi-3-b       | arm64  | lab-baylibre    | gcc-8    | defconfig    =
       | 1          =

hifive-unleashed-a00  | riscv  | lab-baylibre    | gcc-8    | defconfig    =
       | 1          =

meson-gxbb-p200       | arm64  | lab-baylibre    | gcc-8    | defconfig    =
       | 1          =

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

rk3288-rock2-square   | arm    | lab-collabora   | gcc-8    | multi_v7_defc=
onfig  | 1          =

stm32mp157c-dk2       | arm    | lab-baylibre    | gcc-8    | multi_v7_defc=
onfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.77-150-g9dee6749186ef/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.77-150-g9dee6749186ef
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9dee6749186ef41d139c0d5ba7fcda76775b2630 =



Test Regressions
---------------- =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
at91-sama5d4_xplained | arm    | lab-baylibre    | gcc-8    | sama5_defconf=
ig     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb588746631ddf33ad8d985

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-g9dee6749186ef/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-g9dee6749186ef/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb588746631ddf33ad8d=
986
        failing since 20 days (last pass: v5.4.72-409-gbbe9df5e07cf, first =
fail: v5.4.72-409-ga6e47f533653) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
bcm2837-rpi-3-b       | arm64  | lab-baylibre    | gcc-8    | defconfig    =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb5871f24017f8760d8d91c

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-g9dee6749186ef/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-g9dee6749186ef/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fb5871f24017f87=
60d8d91f
        new failure (last pass: v5.4.77-150-g112ca98b2ab2)
        2 lines

    2020-11-18 20:39:57.494000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-18 20:39:57.494000+00:00  (user:khilman) is already connected
    2020-11-18 20:40:12.829000+00:00  =00
    2020-11-18 20:40:12.830000+00:00  =

    2020-11-18 20:40:12.830000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-18 20:40:12.830000+00:00  =

    2020-11-18 20:40:12.830000+00:00  DRAM:  948 MiB
    2020-11-18 20:40:12.846000+00:00  RPI 3 Model B (0xa02082)
    2020-11-18 20:40:12.932000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-18 20:40:12.964000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (380 line(s) more)  =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
hifive-unleashed-a00  | riscv  | lab-baylibre    | gcc-8    | defconfig    =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb587659905b72312d8d913

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-g9dee6749186ef/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-g9dee6749186ef/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb587659905b72312d8d=
914
        failing since 5 days (last pass: v5.4.77-44-gce6b18c3a8969, first f=
ail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
meson-gxbb-p200       | arm64  | lab-baylibre    | gcc-8    | defconfig    =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb587a96ec8518c8dd8d92b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-g9dee6749186ef/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p20=
0.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-g9dee6749186ef/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p20=
0.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb587a96ec8518c8dd8d=
92c
        new failure (last pass: v5.4.77-150-g112ca98b2ab2) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_arm-versatilepb  | arm    | lab-baylibre    | gcc-8    | versatile_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb5884a4bf780d19dd8d911

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-g9dee6749186ef/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-g9dee6749186ef/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb5884a4bf780d19dd8d=
912
        failing since 5 days (last pass: v5.4.77-44-gce6b18c3a8969, first f=
ail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_arm-versatilepb  | arm    | lab-broonie     | gcc-8    | versatile_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb58839d8d55d177cd8d917

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-g9dee6749186ef/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-g9dee6749186ef/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb58839d8d55d177cd8d=
918
        failing since 5 days (last pass: v5.4.77-44-gce6b18c3a8969, first f=
ail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_arm-versatilepb  | arm    | lab-cip         | gcc-8    | versatile_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb58bdc7bf6bbf989d8d907

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-g9dee6749186ef/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-g9dee6749186ef/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb58bdc7bf6bbf989d8d=
908
        failing since 5 days (last pass: v5.4.77-44-gce6b18c3a8969, first f=
ail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_arm-versatilepb  | arm    | lab-collabora   | gcc-8    | versatile_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb58b83ff4ce8c5a2d8d924

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-g9dee6749186ef/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-g9dee6749186ef/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb58b83ff4ce8c5a2d8d=
925
        failing since 5 days (last pass: v5.4.77-44-gce6b18c3a8969, first f=
ail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_arm-versatilepb  | arm    | lab-linaro-lkft | gcc-8    | versatile_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb587f38ab580009bd8d909

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-g9dee6749186ef/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-g9dee6749186ef/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb587f38ab580009bd8d=
90a
        failing since 5 days (last pass: v5.4.77-44-gce6b18c3a8969, first f=
ail: v5.4.77-45-gfd610189f77e1) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
qemu_x86_64-uefi      | x86_64 | lab-baylibre    | gcc-8    | x86_64_defcon=
fig    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb5893ded5871b967d8d962

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-g9dee6749186ef/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-g9dee6749186ef/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb5893ded5871b967d8d=
963
        new failure (last pass: v5.4.77-150-g112ca98b2ab2) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
rk3288-rock2-square   | arm    | lab-collabora   | gcc-8    | multi_v7_defc=
onfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb589814746ba305dd8d922

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-g9dee6749186ef/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-rock2-square.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-g9dee6749186ef/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-rock2-square.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb589814746ba305dd8d=
923
        new failure (last pass: v5.4.77-150-gf13a1c15d0a0) =

 =



platform              | arch   | lab             | compiler | defconfig    =
       | regressions
----------------------+--------+-----------------+----------+--------------=
-------+------------
stm32mp157c-dk2       | arm    | lab-baylibre    | gcc-8    | multi_v7_defc=
onfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb58a769c564f4c59d8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-g9dee6749186ef/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp=
157c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-15=
0-g9dee6749186ef/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp=
157c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb58a769c564f4c59d8d=
8fe
        failing since 23 days (last pass: v5.4.72-54-gc97bc0eb3ef2, first f=
ail: v5.4.72-402-g22eb6f319bc6) =

 =20
