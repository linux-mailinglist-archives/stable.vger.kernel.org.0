Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD543DB0CF
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 03:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbhG3BuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 21:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234112AbhG3BuU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 21:50:20 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36BCAC061765
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 18:50:16 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso12195124pjo.1
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 18:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HombyV9v0a2DXbt+SbylNEh2q0835cxZfPSBy0JTgX8=;
        b=s+Jwxo/bwhGfPMx9dOhqeqdnsKS0DaU0M0Ug5uBpTnp1kyMFmiFHiAPtapNvEPmG6+
         937DVEesrt8mWcprHUy8b9OSFuV7LBfysmAqV+IP37GT3RViSweipbiOskNnkF1l/Bkl
         2B5yjMf976S4gzQJWqcdEH6ekTb1C8jCcpxEnNTq+X//L27FmkJmI25t18LdezpivTmg
         gsKimnIBYehqg7d6NIRnyb6+pZaGc2d1yrdIJSfgxMFlv0vAwPEvyzKFMXKmm8Bei2w/
         XoGO2e3IH72NZbqhUzhYBwvNhfoWUb0PZ2tx0thG6lhJE8/t5qXSYKSNoyiP/aCVPlP+
         Q7kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HombyV9v0a2DXbt+SbylNEh2q0835cxZfPSBy0JTgX8=;
        b=ab/NPdowvXF515hG9CIHMgDtKea4EIGLbJjAhpOeLbF3BeTfmdCjlXAfzbJDXeX3GL
         UvmHr3rqwgNI7tiG9jORWPZjiRWQc1qTXGTbCHIGGw/Tr3/l5JjNN1yfqz7x8Vk9lQh+
         MUw124QfxV5k7LXMUyPUFM1pUNv6i8soZLXbnSMfjc4zYCfpUORaOea6GuLo8w2XTQyQ
         G5rkDgfich3YEbtboG/qn0HpHmlWvcfXEh7RkchfxV1HDhuJhS8xbC8Z3WeFqwtBf5cY
         CYlz6JX9FGzpRyF1+6TQQ2h5nEUAIz1HOASj/BSxpm5P3Rx+4cuUqDgY9+94H+0Cyla1
         g7Lg==
X-Gm-Message-State: AOAM530tQ0gg1PAoI4eEozA+dRM/+CMa8dN0ifAg2dcvB2Jg1cd94qWS
        7TCxeNf3Aa3swyQznnoLF+OllVYIU3dvniQW
X-Google-Smtp-Source: ABdhPJxl0tY1myQmijtUzAHwQPxqUxZ2fNYvwYyGx+MnV4Tcw7tK7zPKkyU5luxeYIT6RhzFtsXM3Q==
X-Received: by 2002:a63:5706:: with SMTP id l6mr44155pgb.217.1627609815542;
        Thu, 29 Jul 2021 18:50:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o3sm147720pjr.49.2021.07.29.18.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 18:50:15 -0700 (PDT)
Message-ID: <61035ad7.1c69fb81.ea153.09e0@mx.google.com>
Date:   Thu, 29 Jul 2021 18:50:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.277-13-gf890c3a34d9b
Subject: stable-rc/linux-4.9.y baseline: 97 runs,
 4 regressions (v4.9.277-13-gf890c3a34d9b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 97 runs, 4 regressions (v4.9.277-13-gf890c3=
a34d9b)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.277-13-gf890c3a34d9b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.277-13-gf890c3a34d9b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f890c3a34d9b707475ea33b9a10f8d21d01998db =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/610324660aca8ad1e8501900

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.277=
-13-gf890c3a34d9b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.277=
-13-gf890c3a34d9b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610324660aca8ad1e8501=
901
        failing since 257 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6103244d0aca8ad1e85018cc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.277=
-13-gf890c3a34d9b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.277=
-13-gf890c3a34d9b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6103244d0aca8ad1e8501=
8cd
        failing since 257 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/61032452a3dbc7a3575018d2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.277=
-13-gf890c3a34d9b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.277=
-13-gf890c3a34d9b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61032452a3dbc7a357501=
8d3
        failing since 257 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
r8a7795-salvator-x   | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6103244a0aca8ad1e85018c4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.277=
-13-gf890c3a34d9b/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.277=
-13-gf890c3a34d9b/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6103244a0aca8ad1e8501=
8c5
        failing since 253 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
