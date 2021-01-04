Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A672EA077
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 00:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbhADXKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 18:10:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727322AbhADXKy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 18:10:54 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56BDC061796
        for <stable@vger.kernel.org>; Mon,  4 Jan 2021 15:10:13 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id t22so17308303pfl.3
        for <stable@vger.kernel.org>; Mon, 04 Jan 2021 15:10:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ESvKDFxAJiptIya1VkSS/Z4lRaUxVi+IbTPQQNBk1X0=;
        b=W0XyzMtdSbdp9bJvvpjyaOT5CQomvkTnuHgpQOTlYUR+5GcKJb7dKKiAj4C6kgDjxD
         mwITc339wlK0pz92YqREI+9opIZCegWB+myStOdpzuvjIQFWfWo51AaQcU+vpP+m92xF
         XfWpO33wWWB0h0sF+9KOoOVXf9BFCZYDwlvOavTmJD2NqujvQFqQyaZm0mIvEIkxD70s
         YU0pFKm6A2FpTBnn9PE3m22FXD8zCSVAv8vr/5uFAXlRZ+kQOEr1ZBM4KtUGmcRd+tjM
         Ks4Urbzj2ZA12LcX0FD3nraYjVeAcxAXIl0Rb6HnuF8+lJlaY8PMktLysxB6pEUpmFD6
         6fsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ESvKDFxAJiptIya1VkSS/Z4lRaUxVi+IbTPQQNBk1X0=;
        b=Ks6Cqn3Fc2RKXBVxvYH9OAhRZjBSOCFYY38WUQMPuzlNN2MM+iytQPHnJTVAPRPVLO
         CmZ3aKYC2KyJ0JbZGWJ5tUUyBDSvn76F5BxPcjObEm7G43cZBJy1Qo8vwOBRkSfK++2I
         CMxt5pmjtQg/tJ8bq61l2uTG19Du+p0BwgYqcAFOdN13F5vZlplYa5vljqhUG0jeWOqF
         ZZo3azxnL8huAcLDEdJVPRs33KDNX1+wN3ZKPLCdK+IR/r5NvGAPGQoyTNwP53/zpSib
         7/A+wai4OLSO4K461x1kgQwMUqP5VQE/hwiddZEmJi94S0lPjcHLjHqzY6yvYrtL18vB
         XEsA==
X-Gm-Message-State: AOAM531hp9ko3fsIkkC3mG7H6vqGNGjVfazya4IquFPM9hV1cPBi43Cu
        PZAN+UZC05iwDeE2BRUOeeS/xDfkRK+aTA==
X-Google-Smtp-Source: ABdhPJzjodlJAXYqgQ0wpL7/kpFkJ6fB+lnh8WC8chUICnNfL8VmI9k+no/L+7FRbRCk33U4TrdUSw==
X-Received: by 2002:a63:1142:: with SMTP id 2mr73624322pgr.263.1609801812943;
        Mon, 04 Jan 2021 15:10:12 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d20sm909222pjz.3.2021.01.04.15.10.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 15:10:12 -0800 (PST)
Message-ID: <5ff3a054.1c69fb81.4b028.243e@mx.google.com>
Date:   Mon, 04 Jan 2021 15:10:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.86-48-g01678c93fa9e
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 172 runs,
 8 regressions (v5.4.86-48-g01678c93fa9e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 172 runs, 8 regressions (v5.4.86-48-g01678c=
93fa9e)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
bcm2837-rpi-3-b      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 2          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.86-48-g01678c93fa9e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.86-48-g01678c93fa9e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      01678c93fa9e3da85a53deb1510c25fdcd2e5d6d =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
bcm2837-rpi-3-b      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff36fc305e83fcf2ac94cdd

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.86-=
48-g01678c93fa9e/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.86-=
48-g01678c93fa9e/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5ff36fc305e83fcf=
2ac94ce0
        new failure (last pass: v5.4.85-72-ge4ff6f3aa771)
        3 lines

    2021-01-04 19:40:26.814000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2021-01-04 19:40:26.814000+00:00  (user:khilman) is already connected
    2021-01-04 19:40:42.378000+00:00  =00
    2021-01-04 19:40:42.378000+00:00  =

    2021-01-04 19:40:42.378000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2021-01-04 19:40:42.378000+00:00  =

    2021-01-04 19:40:42.379000+00:00  DRAM:  948 MiB
    2021-01-04 19:40:42.393000+00:00  RPI 3 Model B (0xa02082)
    2021-01-04 19:40:42.480000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2021-01-04 19:40:42.512000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (392 line(s) more)  =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff36b950de7079a1bc94cd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.86-=
48-g01678c93fa9e/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.86-=
48-g01678c93fa9e/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff36b950de7079a1bc94=
cd6
        failing since 45 days (last pass: v5.4.77-152-ga3746663c3479, first=
 fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 2          =


  Details:     https://kernelci.org/test/plan/id/5ff377d3b4c4efe1eac94cf5

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.86-=
48-g01678c93fa9e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.86-=
48-g01678c93fa9e/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5ff377d3b4c4efe1=
eac94cf8
        new failure (last pass: v5.4.85-72-ge4ff6f3aa771)
        1 lines

    2021-01-04 20:16:16.283000+00:00  Connected to meson-gxm-q200 console [=
channel connected] (~$quit to exit)
    2021-01-04 20:16:16.284000+00:00  (user:khilman) is already connected
    2021-01-04 20:16:28.041000+00:00  GXM:BL1:dc8b51:76f1a5;FEAT:ADFC318C:0=
;POC:3;RCY:0;EMMC:0;READ:0;CHK:AA;SD:0;READ:0;0.0;CHK:0;
    2021-01-04 20:16:28.042000+00:00  no sdio debug board detected =

    2021-01-04 20:16:28.043000+00:00  TE: 312970
    2021-01-04 20:16:28.043000+00:00  =

    2021-01-04 20:16:28.043000+00:00  BL2 Built : 11:58:42, May 27 2017. =

    2021-01-04 20:16:28.044000+00:00  gxl gc3c9a84 - xiaobo.gu@droid05
    2021-01-04 20:16:28.044000+00:00  =

    2021-01-04 20:16:28.045000+00:00  set vcck to 1120 mv =

    ... (561 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5ff377d4b4c4efe=
1eac94cfa
        new failure (last pass: v5.4.85-72-ge4ff6f3aa771)
        2 lines

    2021-01-04 20:17:18.635000+00:00  kern  :emerg : Code: f9401bf7 17ffff7=
d a9025bf5 f9001bf7 (d4210000<8>[   16.277091] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2021-01-04 20:17:18.636000+00:00  ) =

    2021-01-04 20:17:18.636000+00:00  + set +x<8>[   16.286357] <LAVA_SIGNA=
L_ENDRUN 0_dmesg 546884_1.5.2.4.1>
    2021-01-04 20:17:18.636000+00:00  =

    2021-01-04 20:17:18.749000+00:00  / # #   =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff36bbbf46552342cc94cda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.86-=
48-g01678c93fa9e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.86-=
48-g01678c93fa9e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff36bbbf46552342cc94=
cdb
        failing since 51 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff36bbef46552342cc94ce0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.86-=
48-g01678c93fa9e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.86-=
48-g01678c93fa9e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff36bbef46552342cc94=
ce1
        failing since 51 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff36bcaf46552342cc94ced

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.86-=
48-g01678c93fa9e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.86-=
48-g01678c93fa9e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff36bcaf46552342cc94=
cee
        failing since 51 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff36b787614768366c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.86-=
48-g01678c93fa9e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.86-=
48-g01678c93fa9e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff36b787614768366c94=
cba
        failing since 51 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =20
