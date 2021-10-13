Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12A242CF03
	for <lists+stable@lfdr.de>; Thu, 14 Oct 2021 01:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhJMXPV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 19:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbhJMXPU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 19:15:20 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1B9EC061570
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 16:13:16 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id m14so3812434pfc.9
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 16:13:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Ft+KbJfZkP4GhqvvGVG6ZuQeLtxJSqRGzWPDEF93Rto=;
        b=jAFmoda+/R7QpCAP6P3PbTiRumUMTDNg+gPoHYjk/Qa81X7ex+Cgf/LlgJtnD3PQAL
         U78SVQWPJlzqehcUIITqWnzQEMbN7nrA2nhUJjILQEKtHS5RIsuF3/FNOmbVxY/WaYpK
         bWBbiBn9Bp3ujkFITNNPTJYd138AMEE4eKKOtKiwQylM9rFPWg/Y78T2jMBqojyS4zJr
         aTg5dUFsYytcTBfgQRkMq/9KTy/EhBeYdFEuP1ENsz4c1ugWexl86CNbdruam057ynFZ
         iTVsrByfOXyttbHxPdh5iZYR7D+wAQ+QEfcV413P40MBXy5zT0Elp/b7mjjQK+c+ErfE
         sohw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Ft+KbJfZkP4GhqvvGVG6ZuQeLtxJSqRGzWPDEF93Rto=;
        b=jCn0oCteY3/7Hbj0Yw1YRl6ZCaOzSMGlUPiKtXvoV9pd+qNGLyredH8mb3syE8Lrv8
         MyrgDuOCB2lyZjasZAQbeJb5Maz8vMfBM68aDPi9g7+Lw08Xmad4Ro4Wd4qCRgGCZPFR
         zs/gilZ9g9/0neVYO/kH95YluseZSkPqI3LVO5sp8nqFN1neSFUvcvgchHjHDqQWuCU6
         FLmIslNJGm+3/V/eXVe7FT/0rOzu71imdR88r7/HPF8hQOtPqAWCO0rQCZUUdOnxxoK8
         C3gm1OTE2pQXxBCXMZ2PnJf3momhaXkoPgTgqYC9UFZ8nTUd1C5suYmm0enQOGk/QlcU
         fdrg==
X-Gm-Message-State: AOAM533StQOeKj9/JRVDMdNci8g5uhwNGdhnMkS/sibTJZC2JvW+9nVw
        JTPKn42DuiR653cwKJkoLAzWM9F0/njniy/4EvI=
X-Google-Smtp-Source: ABdhPJxqJHYdRhgWjV/PMDNNUuTBJIsUXEUJnaPjwwLBDtCweudbBO7q7LINhKLE+lsx+LBzye8nHg==
X-Received: by 2002:aa7:943a:0:b0:44b:e771:c7d1 with SMTP id y26-20020aa7943a000000b0044be771c7d1mr2183543pfo.42.1634166796079;
        Wed, 13 Oct 2021 16:13:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 130sm490152pfz.77.2021.10.13.16.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 16:13:15 -0700 (PDT)
Message-ID: <6167680b.1c69fb81.3b316.22d7@mx.google.com>
Date:   Wed, 13 Oct 2021 16:13:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.211-13-g9a68777ad65a
Subject: stable-rc/linux-4.19.y baseline: 89 runs,
 3 regressions (v4.19.211-13-g9a68777ad65a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 89 runs, 3 regressions (v4.19.211-13-g9a68=
777ad65a)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.211-13-g9a68777ad65a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.211-13-g9a68777ad65a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9a68777ad65aeb678c59ce30efe7f376b0f4b084 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61672ef6b1f2cd9d7e08faa6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
11-13-g9a68777ad65a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
11-13-g9a68777ad65a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61672ef6b1f2cd9d7e08f=
aa7
        failing since 329 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61672f86048d83a0b108fab1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
11-13-g9a68777ad65a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
11-13-g9a68777ad65a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61672f86048d83a0b108f=
ab2
        failing since 329 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61672f3f093d9c439a08faac

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
11-13-g9a68777ad65a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
11-13-g9a68777ad65a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61672f3f093d9c439a08f=
aad
        failing since 329 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
