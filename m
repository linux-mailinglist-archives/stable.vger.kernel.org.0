Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA2B2ECA32
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 06:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725812AbhAGFgQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 00:36:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbhAGFgP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 00:36:15 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53248C0612F0
        for <stable@vger.kernel.org>; Wed,  6 Jan 2021 21:35:35 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id i5so4100982pgo.1
        for <stable@vger.kernel.org>; Wed, 06 Jan 2021 21:35:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2PAddu2k1jMyZWVduFdjmJ6KKJHdUynrrbUu4hgm5hY=;
        b=sxcQjXIjJ7uhJmZ2CeIluy031DFCk+baLnKAeRyd9MH+XQcl8WUm9nSAt2UEVxGuH6
         wl5d0Ykh5ZfGy/RHIBXOUNpjSR3hRh/ksUP3pE6YD5CAbRNNT+oj9vbJiH91qnMzXlLO
         AIMKvO1rGMaXksd2H8pwMXHNeDkw/0bfN9quhBETW4hXq0Fsg0CEuTCTQJdJvcd5cftB
         GGMWRTu2z/bfNfUwkFFdSeay1801810cS4wdUtdxZfTYwBM7TEF2PPMZeC9ugfQmo207
         MiCTPkm7Pbz199nqBJFQ+0FA+svNPGvGPo0Ry9yXhmXeJc5PtUeiRI467KjtvBWHUkov
         1ouA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2PAddu2k1jMyZWVduFdjmJ6KKJHdUynrrbUu4hgm5hY=;
        b=hSniQfNIq6dSTEkGrbDOq1zXBhJPNMHLiZKYF3kr9mcodSxAhNf33SirogPra/DTPM
         1bHfwxmZKIX3HgjVJS23eRnNhJ5HjCyNyKcgU7+XYcdpBmpup7fUEpdsS53UmqCgGUh1
         HEpGMkt4ZZ9EjdyyfMPhz2P3DikGacWLR6UcQWnU1Q78veG97N69AigQVdDpUmNpgcnZ
         QpJDxQ198PuLyhllv+0od2zCMe5WOmxxIx7+NJ5L5ckHf7R0nSsA4rKEzDFZsR749TxE
         9AbdeUN48WAANyg/iu2FpLPZbsga24ESuEwf/LX0tjB3/10IbRcrkOjcVGSsWYiGp1Sa
         IUAQ==
X-Gm-Message-State: AOAM532XNI/9nyy8GVq8baSD8LjuyK1AGRmTJswvyMOT98o4DpOL/poB
        o4Cvovq179m9NQoXRXmbxKRHQ6/oEFpqKA==
X-Google-Smtp-Source: ABdhPJyW4tYuLuObzQktUjwZojUI/bfWt0pS2hzIHVyQF+AdKpEp9aDBCvpywARp873cctBvAUsPqg==
X-Received: by 2002:a63:3714:: with SMTP id e20mr171753pga.410.1609997734361;
        Wed, 06 Jan 2021 21:35:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p21sm4204169pfn.15.2021.01.06.21.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 21:35:33 -0800 (PST)
Message-ID: <5ff69da5.1c69fb81.683ca.aff3@mx.google.com>
Date:   Wed, 06 Jan 2021 21:35:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.165-7-g6cf7f7d976ba5
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 169 runs,
 7 regressions (v4.19.165-7-g6cf7f7d976ba5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 169 runs, 7 regressions (v4.19.165-7-g6cf7f7=
d976ba5)

Regressions Summary
-------------------

platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =

panda                      | arm   | lab-collabora   | gcc-8    | omap2plus=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-baylibre    | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-broonie     | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-cip         | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-collabora   | gcc-8    | versatile=
_defconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-linaro-lkft | gcc-8    | versatile=
_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.165-7-g6cf7f7d976ba5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.165-7-g6cf7f7d976ba5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6cf7f7d976ba5c969bb7fb5e958279168ebce5b7 =



Test Regressions
---------------- =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre    | gcc-8    | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff669360dc25b5db7c94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.165=
-7-g6cf7f7d976ba5/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.165=
-7-g6cf7f7d976ba5/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff669360dc25b5db7c94=
ccf
        new failure (last pass: v4.19.164-29-g4c0bb8a87fa6b) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
panda                      | arm   | lab-collabora   | gcc-8    | omap2plus=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff6687e78bb73454ac94cb9

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.165=
-7-g6cf7f7d976ba5/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.165=
-7-g6cf7f7d976ba5/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5ff6687e78bb734=
54ac94cbe
        new failure (last pass: v4.19.164-29-g4c0bb8a87fa6b)
        2 lines

    2021-01-07 01:48:41.123000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-baylibre    | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff6675d5997b85d7ec94d2a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.165=
-7-g6cf7f7d976ba5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.165=
-7-g6cf7f7d976ba5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff6675d5997b85d7ec94=
d2b
        failing since 54 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-broonie     | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff6674c5997b85d7ec94ceb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.165=
-7-g6cf7f7d976ba5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.165=
-7-g6cf7f7d976ba5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff6674c5997b85d7ec94=
cec
        failing since 54 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-cip         | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff6673ff5200fd33fc94cca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.165=
-7-g6cf7f7d976ba5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.165=
-7-g6cf7f7d976ba5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff6673ff5200fd33fc94=
ccb
        failing since 54 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-collabora   | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff666f9154b10f91bc94cc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.165=
-7-g6cf7f7d976ba5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.165=
-7-g6cf7f7d976ba5/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff666f9154b10f91bc94=
cc2
        failing since 54 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                   | arch  | lab             | compiler | defconfig=
           | regressions
---------------------------+-------+-----------------+----------+----------=
-----------+------------
qemu_arm-versatilepb       | arm   | lab-linaro-lkft | gcc-8    | versatile=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff668b0a540309893c94cba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.165=
-7-g6cf7f7d976ba5/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.165=
-7-g6cf7f7d976ba5/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff668b0a540309893c94=
cbb
        failing since 54 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
