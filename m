Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9328A34F68E
	for <lists+stable@lfdr.de>; Wed, 31 Mar 2021 04:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbhCaCVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 22:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232883AbhCaCUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Mar 2021 22:20:51 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E085BC06175F
        for <stable@vger.kernel.org>; Tue, 30 Mar 2021 19:20:50 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id m11so13440667pfc.11
        for <stable@vger.kernel.org>; Tue, 30 Mar 2021 19:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Rzm/kuPXO9O2I/FmcIHUXIGZSpTIp/atiTUeULJD+pg=;
        b=kq64Y1mumdrEE4524AScEQhFE6PDR3igr6yCYk/6uTk3VV7diAyW+0P8EVuw+nN6yu
         8qnvmYTckSBZZpwAL+yE1aQqQMjQKM/+GtdlzyXaFVDLkwm95gyg2yT1cMpn0QOzXxox
         ern2bIVyrPqmdtexMvKVd2jIWSheqE+TkyHxwzK6c92fqptfCWLWPrJDAMQSm/JFa1za
         aIbnc+5LOtEOOmPTMuNORWb8xzhzLwgkJL85NdOzmDaNFg47F1x77tojHlwzi6bPc4GW
         EXPdiQXYWW+FSdkakiEFvXp05AiS3+Xlvom1ctCzeW+C8oAw1l95w0liGfp8Qz36zIb2
         yyWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Rzm/kuPXO9O2I/FmcIHUXIGZSpTIp/atiTUeULJD+pg=;
        b=uXmgAjk1ECrawBff/3V8My+B9zqlVdkR2BDiZMjHk9hWgSvnGWvY3bHRXT9RGyX5jI
         LumkxMQTzLyJf6P/xiDQy/RPRj/yOLhi4Pu6kWusJ4Js1iLEXUNCe6Vdcy8em5a24my6
         6patbiRxWqwybmnlzVw3jN4axvJ/BqsJGT2XaXD9JX+coJ1LurIPYpp0PO+uTmL3Cw3+
         3lz6iixHVfVZzWiyCrjW/xpMm9ooqu4hh3JRrhYMZ6pzUqyrvke80qMija1CQUzQeB0E
         SyLptvjPM0ECI6hOi7ALm9hS9o2ir2ppbbtbCCKxOn+/zHT8qbYY1kuES7VgVDTLCF9v
         vjuw==
X-Gm-Message-State: AOAM533CMe0Kyh4AjxHUO/+sMItoLPIVvkzmu8wgnR/ly0jDzKpmywJo
        dZHB0x7rhk0STVYWgxkM6RXFyJ34LBGGQRxk
X-Google-Smtp-Source: ABdhPJwwNdEcEQ/fvwG9ZN/jAubYSnHi2eT/mDJDw2hGqrfo3Cd9Y5k9tzsyxSCMbYJbzDIt2Snjuw==
X-Received: by 2002:a62:f207:0:b029:1f6:11a4:1b81 with SMTP id m7-20020a62f2070000b02901f611a41b81mr854614pfh.19.1617157250025;
        Tue, 30 Mar 2021 19:20:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d14sm361695pji.22.2021.03.30.19.20.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 19:20:49 -0700 (PDT)
Message-ID: <6063dc81.1c69fb81.d5468.1bda@mx.google.com>
Date:   Tue, 30 Mar 2021 19:20:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.109
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 154 runs, 6 regressions (v5.4.109)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 154 runs, 6 regressions (v5.4.109)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.109/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.109
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4e85f8a712cddf2ceeaac50a26b239fbbcb7091f =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6063a63fe928b65080dac6f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.109=
/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.109=
/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6063a63fe928b65080dac=
6f4
        failing since 130 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6063a84d2b0adeff3ddac6b1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.109=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.109=
/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6063a84d2b0adeff3ddac=
6b2
        new failure (last pass: v5.4.108-112-g7b78fa4bf15f0) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6063a5f24dc3c9603fdac6c9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.109=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.109=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6063a5f24dc3c9603fdac=
6ca
        failing since 136 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6063a5173c771797d7dac6e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.109=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.109=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6063a5173c771797d7dac=
6e7
        failing since 136 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6063a5295590f2280cdac6c8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.109=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.109=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6063a5295590f2280cdac=
6c9
        failing since 136 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6063a8d96a7a34df39dac6d2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.109=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.109=
/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6063a8d96a7a34df39dac=
6d3
        failing since 136 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
