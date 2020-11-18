Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 198A72B7CA6
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 12:29:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726340AbgKRL2S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 06:28:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgKRL2S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 06:28:18 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0AC5C0613D4
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 03:28:16 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id 18so808043pli.13
        for <stable@vger.kernel.org>; Wed, 18 Nov 2020 03:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=c6Iw+Ph/xWFtWcpaRo4Q7hNHmBkxyvYN0XNZns2gHXk=;
        b=EVYEGkkThK4sloovIZH5XC2Ku1CykHO9wVChtRLXSI1GpBKPvSlgbBHzZbUU2j0uwm
         6TnJ4OCOOnP+p6cGUeziYL7rk8hKoPSREYmlSpAperDI0l/9jcBkRBXlLYG9WMiiSQo1
         4R6YgJBeV1UBqUZ5nblKKyOCOmeYMa8jiAZOeV5Rovtq9bpTb9R0L/Ttd2AtcHzxj2at
         0+37Kcu/iyOPo34Yuc1Q7ODiRW+sAMEE4DzUK8ZfKgoveQIO2Kr6j29C6eyIJ3ih8mQl
         +I0HFNPAkrCLE2IZq8NxvGNCSDTNmNMgC1VBmTTEf9bCfdT/Px0SNjap9PR/fXcCihP3
         UPMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=c6Iw+Ph/xWFtWcpaRo4Q7hNHmBkxyvYN0XNZns2gHXk=;
        b=R9U2YgqnPJjxNZ0AVs9HC7R5DPd9rQEqgqUAyvgeLggAfXNBWGc+sZzeKvl817xciC
         4sxOUc1bPYPLW7Kid0k0KWWTAR87wejgWiUS+qTy9JywDgkAQJTHJsI1txsd8hvsgW2q
         IDy5gyi34A563/JHo7nm2RUJba+Y/lChTKXPiAreYrd4KwqKkmEAgsrW+lQU0Jm/KiL1
         6QvPfG9UkXZLC2Msjezs/FG+stlB9UOeR8283yrsh9Vghl3OX5bCak1fosWQRzmEr17H
         VzJgnRV3axaq4Y5qXNOM1jxv0YmHhV0qeOrgNLYolWH2IIZ+btKs7wkZZMsXfRckus8a
         K4EA==
X-Gm-Message-State: AOAM530zMOnLHTXeBQpLuEULeLjSpy/JyxkOyX3Yh7lnDSV6Ut4b8foG
        +XwLu2vyzEJeYnX30BSRym7NeUEru28n2g==
X-Google-Smtp-Source: ABdhPJy7eH8+NZE6DQX1WZIg22pQ6y7I+PMoag9wlBCksl47evTW77VM/uAirSzGynrepHb4/+UGkg==
X-Received: by 2002:a17:90a:87:: with SMTP id a7mr3479743pja.95.1605698895839;
        Wed, 18 Nov 2020 03:28:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d188sm24661421pfd.86.2020.11.18.03.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 03:28:15 -0800 (PST)
Message-ID: <5fb5054f.1c69fb81.5131e.5482@mx.google.com>
Date:   Wed, 18 Nov 2020 03:28:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.77-152-ga3746663c3479
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 198 runs,
 10 regressions (v5.4.77-152-ga3746663c3479)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 198 runs, 10 regressions (v5.4.77-152-ga374=
6663c3479)

Regressions Summary
-------------------

platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
at91-sama5d4_xplained | arm   | lab-baylibre    | gcc-8    | sama5_defconfi=
g     | 1          =

bcm2837-rpi-3-b       | arm64 | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =

bcm2837-rpi-3-b-32    | arm   | lab-baylibre    | gcc-8    | bcm2835_defcon=
fig   | 1          =

meson-gxm-q200        | arm64 | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =

qemu_arm-versatilepb  | arm   | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =

qemu_arm-versatilepb  | arm   | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =

stm32mp157c-dk2       | arm   | lab-baylibre    | gcc-8    | multi_v7_defco=
nfig  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.77-152-ga3746663c3479/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.77-152-ga3746663c3479
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a3746663c34792114dfa71148be3dcc3f3f089ea =



Test Regressions
---------------- =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
at91-sama5d4_xplained | arm   | lab-baylibre    | gcc-8    | sama5_defconfi=
g     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4d226a97a6cdc5cd8d8fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
152-ga3746663c3479/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sam=
a5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
152-ga3746663c3479/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sam=
a5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4d226a97a6cdc5cd8d=
8fe
        failing since 220 days (last pass: v5.4.30-54-g6f04e8ca5355, first =
fail: v5.4.30-81-gf163418797b9) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
bcm2837-rpi-3-b       | arm64 | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4cf2a15cef1bccbd8d936

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
152-ga3746663c3479/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-=
3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
152-ga3746663c3479/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-=
3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fb4cf2a15cef1bc=
cbd8d939
        new failure (last pass: v5.4.77-44-g28fe0e171c204)
        3 lines

    2020-11-18 07:34:25.281000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-18 07:34:25.281000+00:00  (user:khilman) is already connected
    2020-11-18 07:34:43.457000+00:00  =00
    2020-11-18 07:34:43.457000+00:00  =

    2020-11-18 07:34:43.473000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-18 07:34:43.473000+00:00  =

    2020-11-18 07:34:43.473000+00:00  DRAM:  948 MiB
    2020-11-18 07:34:43.489000+00:00  RPI 3 Model B (0xa02082)
    2020-11-18 07:34:43.580000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-18 07:34:43.612000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (386 line(s) more)  =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
bcm2837-rpi-3-b-32    | arm   | lab-baylibre    | gcc-8    | bcm2835_defcon=
fig   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4d213b65d5bc9e8d8d92a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
152-ga3746663c3479/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
152-ga3746663c3479/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4d213b65d5bc9e8d8d=
92b
        new failure (last pass: v5.4.77-44-g28fe0e171c204) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
meson-gxm-q200        | arm64 | lab-baylibre    | gcc-8    | defconfig     =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4d0639c6a72e479d8d90b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
152-ga3746663c3479/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
152-ga3746663c3479/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4d0639c6a72e479d8d=
90c
        new failure (last pass: v5.4.77-44-g28fe0e171c204) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-baylibre    | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4d2c9499325c067d8d915

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
152-ga3746663c3479/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
152-ga3746663c3479/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4d2c9499325c067d8d=
916
        failing since 3 days (last pass: v5.4.77-44-g28fe0e171c204, first f=
ail: v5.4.77-46-ga3e34830d912) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-broonie     | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4d2ca5ddc1d33efd8d90c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
152-ga3746663c3479/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
152-ga3746663c3479/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4d2ca5ddc1d33efd8d=
90d
        failing since 3 days (last pass: v5.4.77-44-g28fe0e171c204, first f=
ail: v5.4.77-46-ga3e34830d912) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-cip         | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4d2c27b8191665ad8d933

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
152-ga3746663c3479/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
152-ga3746663c3479/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4d2c27b8191665ad8d=
934
        failing since 3 days (last pass: v5.4.77-44-g28fe0e171c204, first f=
ail: v5.4.77-46-ga3e34830d912) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-collabora   | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4e1bf079d75eac9d8d921

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
152-ga3746663c3479/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
152-ga3746663c3479/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4e1bf079d75eac9d8d=
922
        failing since 3 days (last pass: v5.4.77-44-g28fe0e171c204, first f=
ail: v5.4.77-46-ga3e34830d912) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
qemu_arm-versatilepb  | arm   | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4e09d019bb1565dd8d913

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
152-ga3746663c3479/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
152-ga3746663c3479/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4e09d019bb1565dd8d=
914
        failing since 3 days (last pass: v5.4.77-44-g28fe0e171c204, first f=
ail: v5.4.77-46-ga3e34830d912) =

 =



platform              | arch  | lab             | compiler | defconfig     =
      | regressions
----------------------+-------+-----------------+----------+---------------=
------+------------
stm32mp157c-dk2       | arm   | lab-baylibre    | gcc-8    | multi_v7_defco=
nfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb4d50949b874af0ad8d919

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
152-ga3746663c3479/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32=
mp157c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.77-=
152-ga3746663c3479/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32=
mp157c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb4d50949b874af0ad8d=
91a
        failing since 21 days (last pass: v5.4.72-55-g7fa6d77807db, first f=
ail: v5.4.72-409-gab6643bad070) =

 =20
