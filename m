Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47EFE34B9C2
	for <lists+stable@lfdr.de>; Sat, 27 Mar 2021 23:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbhC0WPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Mar 2021 18:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230500AbhC0WPp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Mar 2021 18:15:45 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4592FC0613B1
        for <stable@vger.kernel.org>; Sat, 27 Mar 2021 15:15:45 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id w10so2620029pgh.5
        for <stable@vger.kernel.org>; Sat, 27 Mar 2021 15:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/By6P25IQM6IsCSoufnYIoQ3OVrskbQoDQbcQuL8wew=;
        b=qP4X5kxIE6EXDszJ5E4N6rc+k2WNDbmV/9jppoMq1ASdUgIE5x1niBESMufUrZnkPD
         puy/M6mWRdVi3J00FDZTs/aj95EMxSOtZzpl/wRhMOKCYBQGo0g7e78hY4zmBGXE7ih2
         ZcvvyiwrC4LIaCcaSKGladADJeY9VXmIBcpP+o65eRpTfV0NZTSWUI1o6HnXKb40hnXY
         Bka+2vBiG7IbhwaTUgDubuZ38k1okmXCH+CZhr63FiXNBO31V1YAze+fUkN5xZA1Wa6n
         zqJsW8ffSkTq3gJHxziYMSFWIUJm8Qp3XDyudX444wNy3TGLuSlz/HdAR7ZFKs9j61DD
         SIRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/By6P25IQM6IsCSoufnYIoQ3OVrskbQoDQbcQuL8wew=;
        b=cb+LXwPktSFs42HVbGeiImhRrelwMkHYVqM8qz1EYLUM/C5rf2ewOhTD4yHVL6fFTO
         AWvCW/mZttOT+Q3Mn/MGnLsEddBWBvU7GHck9xiIx4rjFq6OQA1NKu1YpK97HSu+SM4J
         TYoUtXXdubSS9XsUYD6OMKUO7WAjqPBGG3gXkWC6zNB85q50/kMY4V3mziJQlI+cCcHu
         RzR3SeztkAxbCiR4xTPbvOwUHUcjAoCqREVjrNHBEEFUPPLJ6IREkXKyqnwed3FVAMsO
         19o8fdSTbQvEzSoRkgvDQeUtA96gunqMLbafoaTOwesYp+qbehT78TgQ7JPh9mEO620k
         QLPA==
X-Gm-Message-State: AOAM530EdE8jfrKK9Kfb/DKKsc7BTPhrZm0KmkI6Dk2eUBsLzyFaVDtP
        CMcmH3ll1h5rNeNk9UqjzIGBs3ETjaNB+w==
X-Google-Smtp-Source: ABdhPJwEbci3s3xBFAC3XpAZWKfseW6nzIb/gSGR643MDs0fegiMKtoqJDMVDMD1O2lwhZ0sSpA6Pw==
X-Received: by 2002:a63:5517:: with SMTP id j23mr16424934pgb.209.1616883344558;
        Sat, 27 Mar 2021 15:15:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y8sm13964637pfp.140.2021.03.27.15.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Mar 2021 15:15:44 -0700 (PDT)
Message-ID: <605fae90.1c69fb81.c1957.1d92@mx.google.com>
Date:   Sat, 27 Mar 2021 15:15:44 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.227-29-gaaaf04029b810
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y baseline: 100 runs,
 5 regressions (v4.14.227-29-gaaaf04029b810)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 100 runs, 5 regressions (v4.14.227-29-gaaa=
f04029b810)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.227-29-gaaaf04029b810/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.227-29-gaaaf04029b810
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      aaaf04029b8104334aff982c80c3b5659be1f192 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/605f76fb6d7c33c5e6af02ae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
27-29-gaaaf04029b810/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-=
q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
27-29-gaaaf04029b810/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-=
q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605f76fb6d7c33c5e6af0=
2af
        failing since 2 days (last pass: v4.14.226-44-gdbfdb55a0970, first =
fail: v4.14.227) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
panda                | arm   | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/605f75a59cfaf01508af02cd

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
27-29-gaaaf04029b810/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
27-29-gaaaf04029b810/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/605f75a59cfaf01=
508af02d4
        new failure (last pass: v4.14.227)
        2 lines

    2021-03-27 18:12:50.017000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/605f74c2af7c3b82caaf02c1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
27-29-gaaaf04029b810/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
27-29-gaaaf04029b810/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605f74c2af7c3b82caaf0=
2c2
        failing since 133 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/605f74db57f103a9d6af02ba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
27-29-gaaaf04029b810/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
27-29-gaaaf04029b810/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605f74db57f103a9d6af0=
2bb
        failing since 133 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/605f744dbf7a3a007faf02c3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
27-29-gaaaf04029b810/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
27-29-gaaaf04029b810/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/605f744dbf7a3a007faf0=
2c4
        failing since 133 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
