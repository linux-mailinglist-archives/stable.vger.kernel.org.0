Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3CE2F942F
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 18:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728455AbhAQRg4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 12:36:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728394AbhAQRgz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 12:36:55 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F53CC061573
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 09:36:15 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id h10so8798870pfo.9
        for <stable@vger.kernel.org>; Sun, 17 Jan 2021 09:36:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=S8tcwe6EULUtubAnXeFaIKOkepRGgpUEjIT29qkRdhs=;
        b=AdXQfXToW+aT9Pr71ymCqsrJwUHmsudpNutCo4jMo3TLEM2Xkk9RMBfWX6l89MqkOY
         6GnYBZbsUzI/OnYuJjVKvBLUoOq7y9eRloH0ES8xiLNeZe/76eB/3StIe+M4jXsTdAPv
         Vm+8GXICipDjYxeFZsfsZEOXqUy/TF4GNBELWlYbMriPXPLsUhDbyA6EmGNVxSKvlMDe
         JDnubv/YhH+SZIs96OK4YS962ZhXXTstoPLqd7GQ/92ty4pRRdNKaqMXBsKhBFTYzYDH
         nXXPUumLOgRg3hHhXWUkcunHYFKaR/UG4eSueBzaDJRDbwQFihedmAvCUD5pD7FRJ8qZ
         I5gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=S8tcwe6EULUtubAnXeFaIKOkepRGgpUEjIT29qkRdhs=;
        b=hexhQF9VnD2S1eYgFqE4pvWEuMoL00AsD3y6p2LZfcx+klKpL/7IrspZzVlvDstrJf
         MsZS23CdN8Tg4hCiWwXzQ6W1Qcvm5Nwd/PK9UAMPf2MdgA9bgdWJHH76b9XIQFQPfrN5
         YSwah2Q4q+q9R18eN7DWTlc+y5IGVuwuP3FnqWPHIhK9uYM1vwaNxHrw3x4uKgQwoRuA
         fhKy7gC5TbeMrRXM+7O4Hz61A5NsJS0dW9KJhMRxt7uy7tABnkKW+JOISasgWYbaqAHq
         KrUIuY56SFNjiebsQlKveJKhyyWWIiBs3EOJn1b7eHwwfoQU+neN0vfmXMJKiMoNjT3k
         1rbA==
X-Gm-Message-State: AOAM531uHCzo4v+UY6IYltSUv7CEjFhlPU+/Gl3rFnm6zLZZrdIv/Neu
        O5PibcU27yS+tc1ylmkCI4AamcIN53PweQ==
X-Google-Smtp-Source: ABdhPJyyx9ZD2fnxLXxsE3obUt3P4m3khc16THhekXxLY6KWQjJNyRP4zrBuJDXMn5XhtwNEFLfaBQ==
X-Received: by 2002:a65:47c7:: with SMTP id f7mr22144892pgs.305.1610904974874;
        Sun, 17 Jan 2021 09:36:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a204sm52865pfa.49.2021.01.17.09.36.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jan 2021 09:36:14 -0800 (PST)
Message-ID: <6004758e.1c69fb81.3c455.0210@mx.google.com>
Date:   Sun, 17 Jan 2021 09:36:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v4.14.216
X-Kernelci-Report-Type: test
Subject: stable/linux-4.14.y baseline: 157 runs, 8 regressions (v4.14.216)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 157 runs, 8 regressions (v4.14.216)

Regressions Summary
-------------------

platform                | arch  | lab             | compiler | defconfig   =
        | regressions
------------------------+-------+-----------------+----------+-------------=
--------+------------
meson-gxbb-p200         | arm64 | lab-baylibre    | gcc-8    | defconfig   =
        | 1          =

panda                   | arm   | lab-collabora   | gcc-8    | omap2plus_de=
fconfig | 1          =

qemu_arm-versatilepb    | arm   | lab-baylibre    | gcc-8    | versatile_de=
fconfig | 1          =

qemu_arm-versatilepb    | arm   | lab-broonie     | gcc-8    | versatile_de=
fconfig | 1          =

qemu_arm-versatilepb    | arm   | lab-cip         | gcc-8    | versatile_de=
fconfig | 1          =

qemu_arm-versatilepb    | arm   | lab-collabora   | gcc-8    | versatile_de=
fconfig | 1          =

qemu_arm-versatilepb    | arm   | lab-linaro-lkft | gcc-8    | versatile_de=
fconfig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe      | gcc-8    | defconfig   =
        | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.216/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.216
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      2762b48e9611529239da2e68cba908dbbec9805f =



Test Regressions
---------------- =



platform                | arch  | lab             | compiler | defconfig   =
        | regressions
------------------------+-------+-----------------+----------+-------------=
--------+------------
meson-gxbb-p200         | arm64 | lab-baylibre    | gcc-8    | defconfig   =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/6004449ea7477893cac94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.216/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.216/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004449ea7477893cac94=
cba
        failing since 289 days (last pass: v4.14.172, first fail: v4.14.175=
) =

 =



platform                | arch  | lab             | compiler | defconfig   =
        | regressions
------------------------+-------+-----------------+----------+-------------=
--------+------------
panda                   | arm   | lab-collabora   | gcc-8    | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60044393c361c295c2c94cb9

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.216/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.216/=
arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60044393c361c29=
5c2c94cbe
        new failure (last pass: v4.14.215)
        2 lines

    2021-01-17 14:02:55.602000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-01-17 14:02:55.618000+00:00  [   20.539459] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =



platform                | arch  | lab             | compiler | defconfig   =
        | regressions
------------------------+-------+-----------------+----------+-------------=
--------+------------
qemu_arm-versatilepb    | arm   | lab-baylibre    | gcc-8    | versatile_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60044191bdf93d2d0bc94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.216/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.216/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60044191bdf93d2d0bc94=
cc4
        failing since 59 days (last pass: v4.14.206, first fail: v4.14.207) =

 =



platform                | arch  | lab             | compiler | defconfig   =
        | regressions
------------------------+-------+-----------------+----------+-------------=
--------+------------
qemu_arm-versatilepb    | arm   | lab-broonie     | gcc-8    | versatile_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6004419dbdf93d2d0bc94ce4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.216/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.216/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004419dbdf93d2d0bc94=
ce5
        failing since 59 days (last pass: v4.14.206, first fail: v4.14.207) =

 =



platform                | arch  | lab             | compiler | defconfig   =
        | regressions
------------------------+-------+-----------------+----------+-------------=
--------+------------
qemu_arm-versatilepb    | arm   | lab-cip         | gcc-8    | versatile_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/600441d0da597b0d54c94cbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.216/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.216/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600441d0da597b0d54c94=
cbf
        failing since 59 days (last pass: v4.14.206, first fail: v4.14.207) =

 =



platform                | arch  | lab             | compiler | defconfig   =
        | regressions
------------------------+-------+-----------------+----------+-------------=
--------+------------
qemu_arm-versatilepb    | arm   | lab-collabora   | gcc-8    | versatile_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6004450c945cac5dbbc94cf9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.216/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.216/=
arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004450c945cac5dbbc94=
cfa
        failing since 59 days (last pass: v4.14.206, first fail: v4.14.207) =

 =



platform                | arch  | lab             | compiler | defconfig   =
        | regressions
------------------------+-------+-----------------+----------+-------------=
--------+------------
qemu_arm-versatilepb    | arm   | lab-linaro-lkft | gcc-8    | versatile_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6004411faf34b01a80c94ce5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.216/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.216/=
arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6004411faf34b01a80c94=
ce6
        failing since 59 days (last pass: v4.14.206, first fail: v4.14.207) =

 =



platform                | arch  | lab             | compiler | defconfig   =
        | regressions
------------------------+-------+-----------------+----------+-------------=
--------+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe      | gcc-8    | defconfig   =
        | 1          =


  Details:     https://kernelci.org/test/plan/id/600444824afdd7b0efc94cd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.216/=
arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.216/=
arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600444824afdd7b0efc94=
cd6
        new failure (last pass: v4.14.215) =

 =20
