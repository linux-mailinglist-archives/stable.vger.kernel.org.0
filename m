Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1DE2D43C0
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 15:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbgLIOBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 09:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727981AbgLIOBH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 09:01:07 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C2FAC0613CF
        for <stable@vger.kernel.org>; Wed,  9 Dec 2020 06:00:27 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id q22so1061784pfk.12
        for <stable@vger.kernel.org>; Wed, 09 Dec 2020 06:00:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KJh2zD7C7R2t/m698TDUjRJA9UydmQHl99go5jziyJ4=;
        b=oH23oUaS3414ERDWLi5cAUtaGWjJar0AObG51i/eeC/qkxL05ihC3Rq7UUxcEBOkvu
         1Jh9PNS2QX1oaAunwmodNvhm0phGwXnmZ+2yhgRkp0ZF6nWd8RgchcXfuuie5ASCL99o
         SFMhVgGH61uzlrPFSySjkjaWrvf8hBwkoShzUhRTN4sDioa0tUho7DC3gj82R7sZ659s
         wnrXVOLUTYmdNzl1XDSqdEOPJO2Z4xCkmwp5lZPW0U1zWQbiuE0c+8Wj8NDwvFYIZ/yw
         TUCYpoaI6Y7WpSNgyFt0JBq8HLWCXSN3PEVjQoExPyY6+ViR5jfPBrxkb02nwEY4L505
         nIAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KJh2zD7C7R2t/m698TDUjRJA9UydmQHl99go5jziyJ4=;
        b=lBy+BX5fnWJVHrrh0bKF4RVZhiekHXBoKyylbvb8P0Xo/NascabTDQgflAObrN7C84
         CpJKTA165PNIdH1QPqq/kUFovuHTpA5TCDLxOd/LPV8arAnTmPggYtXODLEZckeV9hwF
         jTGxYIsopPfUElMIZR05NoXwg9hEiNhdqokI7EetJR3SdM6c2Qedk+4Za2ST3AYqY+Tb
         d95Om4m/uNW/sCWAaLPp+5P+jahMrWP8QFGWv6SUdYC6gE3HaifewNJ6LAFPgwLor1tQ
         vZJsp8F4htqkxE2PWW9ChDqI+Z9IqnR0y9YLWirn1Tx2YX+914q3ddKqbif60tZWFU5/
         gURA==
X-Gm-Message-State: AOAM5320qwSBzq60V4gGYm7e9SBYuwF77O7h2rJTKTq7NbCTTarnTtRc
        cUCy5kcJL60nA9xkNwifc7oxktMNbClVbw==
X-Google-Smtp-Source: ABdhPJxUwe0F6OHEYGq9qQ7qIusDvvva6upN7cpw+vELHZNa0C0CrJAM78wz2tBxUfKcR46uLxoWZw==
X-Received: by 2002:a63:eb4b:: with SMTP id b11mr2086503pgk.351.1607522426124;
        Wed, 09 Dec 2020 06:00:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jz7sm2295830pjb.14.2020.12.09.06.00.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 06:00:25 -0800 (PST)
Message-ID: <5fd0d879.1c69fb81.820b2.427d@mx.google.com>
Date:   Wed, 09 Dec 2020 06:00:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.82-35-gee2505e9b00e
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 152 runs,
 8 regressions (v5.4.82-35-gee2505e9b00e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 152 runs, 8 regressions (v5.4.82-35-gee2505e9=
b00e)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig   =
        | regressions
---------------------------+-------+--------------+----------+-------------=
--------+------------
at91-sama5d4_xplained      | arm   | lab-baylibre | gcc-8    | sama5_defcon=
fig     | 1          =

hifive-unleashed-a00       | riscv | lab-baylibre | gcc-8    | defconfig   =
        | 1          =

meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre | gcc-8    | defconfig   =
        | 1          =

meson-gxm-q200             | arm64 | lab-baylibre | gcc-8    | defconfig   =
        | 2          =

qemu_arm-versatilepb       | arm   | lab-baylibre | gcc-8    | versatile_de=
fconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-broonie  | gcc-8    | versatile_de=
fconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-cip      | gcc-8    | versatile_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.82-35-gee2505e9b00e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.82-35-gee2505e9b00e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ee2505e9b00e15869a0e227ecf5485ae0a7ea8d5 =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig   =
        | regressions
---------------------------+-------+--------------+----------+-------------=
--------+------------
at91-sama5d4_xplained      | arm   | lab-baylibre | gcc-8    | sama5_defcon=
fig     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0a78d31523142f6c94cec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-35=
-gee2505e9b00e/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-35=
-gee2505e9b00e/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4=
_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0a78d31523142f6c94=
ced
        failing since 41 days (last pass: v5.4.72-409-gbbe9df5e07cf, first =
fail: v5.4.72-409-ga6e47f533653) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
        | regressions
---------------------------+-------+--------------+----------+-------------=
--------+------------
hifive-unleashed-a00       | riscv | lab-baylibre | gcc-8    | defconfig   =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0a567e2b042c786c94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-35=
-gee2505e9b00e/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-35=
-gee2505e9b00e/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0a567e2b042c786c94=
ccf
        failing since 19 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
        | regressions
---------------------------+-------+--------------+----------+-------------=
--------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre | gcc-8    | defconfig   =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0a603745c9c7ef4c94cc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-35=
-gee2505e9b00e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905x-=
khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-35=
-gee2505e9b00e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905x-=
khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0a603745c9c7ef4c94=
cca
        failing since 0 day (last pass: v5.4.81-43-g0081b4ede752, first fai=
l: v5.4.82-32-g02b97e6d7294) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
        | regressions
---------------------------+-------+--------------+----------+-------------=
--------+------------
meson-gxm-q200             | arm64 | lab-baylibre | gcc-8    | defconfig   =
        | 2          =


  Details:     https://kernelci.org/test/plan/id/5fd0a6283c17f0235ac94cd1

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-35=
-gee2505e9b00e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-35=
-gee2505e9b00e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/5fd0a6283c17f02=
35ac94cd5
        new failure (last pass: v5.4.82-32-g02b97e6d7294)
        11 lines

    2020-12-09 10:25:37.933000+00:00  kern  :alert : Mem abort info:
    2020-12-09 10:25:37.933000+00:00  kern  :alert :   ESR =3D 0x96000006
    2020-12-09 10:25:37.974000+00:00  kern  :alert :   EC =3D 0x25: DABT (c=
urrent EL), IL =3D 32 bits
    2020-12-09 10:25:37.975000+00:00  kern  :alert :   SET =3D 0, FnV =3D 0
    2020-12-09 10:25:37.975000+00:00  kern  :alert :   EA =3D 0, S1PTW =3D 0
    2020-12-09 10:25:37.975000+00:00  kern  :alert : Data abort info:
    2020-12-09 10:25:37.975000+00:00  kern  :alert :   ISV =3D 0, ISS =3D 0=
x00000006
    2020-12-09 10:25:37.975000+00:00  kern  :alert :   CM =3D 0, WnR =3D 0
    2020-12-09 10:25:37.975000+00:00  kern  :alert : user pgtable: 4k pages=
, 48-bit VAs, pgdp=3D000000006866b000
    2020-12-09 10:25:37.976000+00:00  kern  :alert : [000000000e847f70] pgd=
=3D0000000068663003, pud=3D0000000068664003, pmd=3D0000000000000000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fd0a6283c17f02=
35ac94cd6
        new failure (last pass: v5.4.82-32-g02b97e6d7294)
        2 lines

    2020-12-09 10:25:38.012000+00:00  kern  :emerg : Code: a94153f3 f94013f=
5 a8c37bfd d65f03c0 (f94006a0)    =

 =



platform                   | arch  | lab          | compiler | defconfig   =
        | regressions
---------------------------+-------+--------------+----------+-------------=
--------+------------
qemu_arm-versatilepb       | arm   | lab-baylibre | gcc-8    | versatile_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0a62bce9cec3045c94cc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-35=
-gee2505e9b00e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-35=
-gee2505e9b00e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0a62bce9cec3045c94=
cc7
        failing since 25 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
        | regressions
---------------------------+-------+--------------+----------+-------------=
--------+------------
qemu_arm-versatilepb       | arm   | lab-broonie  | gcc-8    | versatile_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0a946438b1d00e1c94cca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-35=
-gee2505e9b00e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-35=
-gee2505e9b00e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0a946438b1d00e1c94=
ccb
        failing since 25 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform                   | arch  | lab          | compiler | defconfig   =
        | regressions
---------------------------+-------+--------------+----------+-------------=
--------+------------
qemu_arm-versatilepb       | arm   | lab-cip      | gcc-8    | versatile_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0a5ed4f2a291755c94ce5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-35=
-gee2505e9b00e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-35=
-gee2505e9b00e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0a5ed4f2a291755c94=
ce6
        failing since 25 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
