Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE8F2D44EF
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 15:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732446AbgLIO6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 09:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732445AbgLIO6G (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 09:58:06 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBAD6C0613CF
        for <stable@vger.kernel.org>; Wed,  9 Dec 2020 06:57:26 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id t37so1334804pga.7
        for <stable@vger.kernel.org>; Wed, 09 Dec 2020 06:57:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2yJElfKNxHFet97FUKG2oZPnbXVgH3C3K7zadXX7Aq8=;
        b=fpfeZRKrnWRwSC1EAFx2dYESfQPNuOQm/Emc+kfYYIjoXg/E2uBKWXqqcXfqNhvCTG
         UBsd0nKh2XHvyVXS7+5VTP3anJAWMfv2RiCkdYUUnEJQpJsDRTbPsIVwCmMEw8hmgF4b
         0xXbwOooxC2+pmCJny1GF5cIzALTAlbNpEvb66dLtwn3EW7V0oy8Fz5nAktk7h6JuAHG
         c9t9NTxsToOYz9Gr/jWh0JiNdBPDkgD5mmfv9tlR+w5cGg7xhqCLrtoLlFkERLJ6Bb02
         obkiv+T42rAfacO41Ud4iCaY1ml/MUFaaA1zCmcg6ML5pixRzxJe1nTasO8Zgvs0Guep
         kBYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2yJElfKNxHFet97FUKG2oZPnbXVgH3C3K7zadXX7Aq8=;
        b=o5AOCZfWGzdsKmtPjvpdvOZ2uPk0sj2YrIOegYzrq5UDfzUvVlXznQ+2/URhNrF93m
         /W+y4GfUjhxZHGQV02XzeLmi0P2LiPuWBZ1aU7VZdAPP0U45lEwgAOgO+/sxBJRGdlng
         ZvyyI9JRqvWqLlv5RCWPFUt5f7Nxeit3EMhVNG7D0meR/q3X6wIOLBy/2dY+3kV/HZE0
         ZAvmSub75aI/XEYSyHgHVf/u/5jK7f8d/pCtUWY9ySCkdEAVT5OHe1DTn1UJvv121AOD
         jG0hqIBX6H86cZSzcmY0JmaqvDPyEd5dW4cWRWNHOkMCz+cs6dPTbTPfwJjuSKIw1FsN
         QqBg==
X-Gm-Message-State: AOAM53005x6BWxdj2Ltq3lq/MvKHCiz94PdtDfS3W/bNUF+sX/QrIVeY
        VDQzTlkruvQ4bW8mqel/v5GZNdbx3AH1+A==
X-Google-Smtp-Source: ABdhPJwZcmaruGD/ykEprF7Bf7Y8XVq9FnBApqPSL1B57IU9YmbRHEPcsYTGGvSWCGvJPIBJ/4+oUQ==
X-Received: by 2002:a63:2045:: with SMTP id r5mr2372223pgm.6.1607525846040;
        Wed, 09 Dec 2020 06:57:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f9sm3105100pfa.41.2020.12.09.06.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 06:57:25 -0800 (PST)
Message-ID: <5fd0e5d5.1c69fb81.83fa8.5583@mx.google.com>
Date:   Wed, 09 Dec 2020 06:57:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.162-24-g8ca9f40955fd
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 166 runs,
 5 regressions (v4.19.162-24-g8ca9f40955fd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 166 runs, 5 regressions (v4.19.162-24-g8ca9f=
40955fd)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =

qemu_arm-versatilepb       | arm   | lab-baylibre  | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-broonie   | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-cip       | gcc-8    | versatile_d=
efconfig | 1          =

qemu_arm-versatilepb       | arm   | lab-collabora | gcc-8    | versatile_d=
efconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.162-24-g8ca9f40955fd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.162-24-g8ca9f40955fd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8ca9f40955fd53169d308c50c24a74bb8f8bc9a5 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
meson-gxl-s905x-khadas-vim | arm64 | lab-baylibre  | gcc-8    | defconfig  =
         | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0ab9cde546ce1fdc94cd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-24-g8ca9f40955fd/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-24-g8ca9f40955fd/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s90=
5x-khadas-vim.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0ab9cde546ce1fdc94=
cda
        new failure (last pass: v4.19.162-15-g63b5ba6dad461) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-baylibre  | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0ad5099fd35b70ec94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-24-g8ca9f40955fd/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-24-g8ca9f40955fd/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0ad5099fd35b70ec94=
cc9
        failing since 25 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-broonie   | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0af3bba68683830c94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-24-g8ca9f40955fd/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-24-g8ca9f40955fd/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0af3bba68683830c94=
cba
        failing since 25 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-cip       | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0ad50c0a6c40c23c94cca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-24-g8ca9f40955fd/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-24-g8ca9f40955fd/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0ad50c0a6c40c23c94=
ccb
        failing since 25 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
         | regressions
---------------------------+-------+---------------+----------+------------=
---------+------------
qemu_arm-versatilepb       | arm   | lab-collabora | gcc-8    | versatile_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0ad327b4e3ef767c94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-24-g8ca9f40955fd/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-24-g8ca9f40955fd/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0ad327b4e3ef767c94=
cc3
        failing since 25 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
