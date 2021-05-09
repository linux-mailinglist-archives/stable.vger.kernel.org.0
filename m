Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3AA737764F
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 13:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhEILSC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 07:18:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbhEILSB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 07:18:01 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C25EC061573
        for <stable@vger.kernel.org>; Sun,  9 May 2021 04:16:58 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id s20so7759474plr.13
        for <stable@vger.kernel.org>; Sun, 09 May 2021 04:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1SsEWmxVlCG/4jI9CDD7TGOv5e9IGgq3Us5KGAwtwVo=;
        b=SC1O5IdeVOdVHqlrReSAINs0JIqo0d1zlm7BO73/bq6jyRturxE6GT/w1i1UKZS8kM
         KRqld6fIj3kyKxVjphD1A59KDznVHLgm6UJvWzO5DtOJfMnpGjQK0u+1+mfBH839LD1u
         659n6PdHSDA0NY8stHmSGu6Sf+V9uU6C20QXU0u4MKtIZG0syrUjbwkkAIP5AOzdxgjl
         ObgZCevpfeTGlDJdfaLN99IiUXLy4A4KbbHL89vfhRDs1+BIWXW65DbLlRcd6Bsztw7J
         uCwIA94BoxKBPalDFw+vFFHnaM3Z/PYb8Ffzl/HWuV+aN3BwufErf1s8FE2I3gKo9gMi
         JWHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1SsEWmxVlCG/4jI9CDD7TGOv5e9IGgq3Us5KGAwtwVo=;
        b=hpPZ2ilsSrc4HmX037z5D25HL2yqKBgyg6Hdvcs13gZZ9FMGhedaTl6x8iKujJkTbg
         Z4NVSi18GKzlNgGk3wW8IGHrfEpNCAYHxnBh9D8pvCUkkfMePQ0467qp7TpbXGl+t/B5
         3Q7ljW2jEIfXhomTrjbI9v2c7YqyIfAnmTuUqTQ6vVuBSvQUQALabs81C7pMG9q7cT+Z
         t1lcS57cihCaiAmNQHk0kWTUNiYSfNBc7zmUMY1I/v+Mo04CH6Vc1xfiBOPsLJuBkqFT
         kfYRgYy/GPGn6zvjcGHciJzoX6tHxvODpUGJKVbq4+trMl7fWXMAOLI7JSdLvehoJCm6
         wZlQ==
X-Gm-Message-State: AOAM531rMzOoejRouPHXoLXE2uRVrpbgON09jpPoCe1kd1OJ8pLRKD7J
        W6DabfRsA/VhxTHfFy2Fb9S7lRSWp8alIid/
X-Google-Smtp-Source: ABdhPJwtNGA/5ZP5muLJyhIuKwp91nfMPhN/DJi+Vcp/u6M5Y91zOvicXzRynh8kVgfJjpCxnFPaQA==
X-Received: by 2002:a17:902:bf0b:b029:ec:b656:6357 with SMTP id bi11-20020a170902bf0bb02900ecb6566357mr19099732plb.66.1620559017346;
        Sun, 09 May 2021 04:16:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j26sm8681872pfn.47.2021.05.09.04.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 May 2021 04:16:56 -0700 (PDT)
Message-ID: <6097c4a8.1c69fb81.a71bc.aeda@mx.google.com>
Date:   Sun, 09 May 2021 04:16:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.232-76-g08fc80320e2a6
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 120 runs,
 9 regressions (v4.14.232-76-g08fc80320e2a6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 120 runs, 9 regressions (v4.14.232-76-g08f=
c80320e2a6)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
beaglebone-black     | arm   | lab-cip         | gcc-8    | omap2plus_defco=
nfig | 1          =

meson-gxbb-p200      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

panda                | arm   | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.232-76-g08fc80320e2a6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.232-76-g08fc80320e2a6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      08fc80320e2a6d38dd64a933423a41e62cefafc1 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
beaglebone-black     | arm   | lab-cip         | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609791b543de5f24546f54b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-76-g08fc80320e2a6/arm/omap2plus_defconfig/gcc-8/lab-cip/baseline-beagleb=
one-black.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-76-g08fc80320e2a6/arm/omap2plus_defconfig/gcc-8/lab-cip/baseline-beagleb=
one-black.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609791b543de5f24546f5=
4b3
        new failure (last pass: v4.14.232-76-gb4a4f05da324) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxbb-p200      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60979268bcfcbd27a26f5490

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-76-g08fc80320e2a6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-76-g08fc80320e2a6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60979268bcfcbd27a26f5=
491
        failing since 403 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxm-q200       | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/609794314448bbe9b66f5499

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-76-g08fc80320e2a6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-=
q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-76-g08fc80320e2a6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-=
q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609794314448bbe9b66f5=
49a
        failing since 44 days (last pass: v4.14.226-44-gdbfdb55a0970, first=
 fail: v4.14.227) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
panda                | arm   | lab-collabora   | gcc-8    | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609790bf440938b8966f5468

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-76-g08fc80320e2a6/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-76-g08fc80320e2a6/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/609790bf440938b=
8966f546d
        failing since 3 days (last pass: v4.14.232, first fail: v4.14.232-1=
3-g40b0c65b3af6)
        2 lines

    2021-05-09 07:35:24.079000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/95
    2021-05-09 07:35:24.087000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6097906f92d54653436f547c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-76-g08fc80320e2a6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-76-g08fc80320e2a6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6097906f92d54653436f5=
47d
        failing since 175 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6097906b92d54653436f546d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-76-g08fc80320e2a6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-76-g08fc80320e2a6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6097906b92d54653436f5=
46e
        failing since 175 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60979076c8a8afdfa66f5474

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-76-g08fc80320e2a6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-76-g08fc80320e2a6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60979076c8a8afdfa66f5=
475
        failing since 175 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6097904f6b376a049f6f5484

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-76-g08fc80320e2a6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-76-g08fc80320e2a6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6097904f6b376a049f6f5=
485
        failing since 175 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6097b9adf413fc10b66f546b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-76-g08fc80320e2a6/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline=
-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-76-g08fc80320e2a6/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline=
-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6097b9adf413fc10b66f5=
46c
        failing since 175 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
