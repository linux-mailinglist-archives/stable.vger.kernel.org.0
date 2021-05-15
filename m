Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1473819EA
	for <lists+stable@lfdr.de>; Sat, 15 May 2021 18:39:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231249AbhEOQkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 May 2021 12:40:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbhEOQkt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 May 2021 12:40:49 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D6BC06174A
        for <stable@vger.kernel.org>; Sat, 15 May 2021 09:39:35 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id h127so1908938pfe.9
        for <stable@vger.kernel.org>; Sat, 15 May 2021 09:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5jwNEFOLdJS1Xi7FbkKH6wgknGToMKALxs7++2xLhr8=;
        b=WUqPBbuNRZxtclXiTuQSmvUHCTQkG0lZizOGmgnKIRRtq44UnPDBU5OErvyDt+4gHz
         xS2HKTppFHD36Bb8MDxRehNTa+mj2pJJN5+9OyWBpQfvpR1IgHrBlKzJug+5f4nB9L/E
         s5L41OFXyGv97wFMrelTGxq/mqERG41C6zJ8Uv5tD5WhWTavYXaEqlYV2bAv95DxR7nQ
         XwefElHzjROoLx1jPBZMG2R92qYwfwk//WNQYPTTsZPE1nrLSWKa2s2+5KvLBOrFuhNn
         fac+etQ7gMZ+hVmKI73fAzqecIoueT5yvOWf36BnSN3Aw9BY01hmoS8ZWepRUbEtBvkm
         Tfsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5jwNEFOLdJS1Xi7FbkKH6wgknGToMKALxs7++2xLhr8=;
        b=FU9jixPNIDu7kLE4VencxxnI52Hh+6rB9d+YEpWRO1rjWvKQ829Ir7R3/maiI4f2mw
         vu6tahucAPa2hZZDDNE7PxxzxgoDfC6eVfrzb21aYsJjwA/kw6+M/q8AJV75lYyUe1f5
         svh8T3ShHXqOtAc/IF1X7TBfKazvjBg/qBieARZGZZZO8rAOItuFhB7q0Ykf/+ADXMbN
         rzlC0Ipgpk/rgkhF01Jvx9VB+WG3p67LaFfuHYQ2609OxR9dwIkq9DZV1/lUighqUO1C
         wen1pJ+glE3U7phjLjeS0UrgEFYuBTDGr7EEVYvuuz2BKp65lTkXAOC/0y23mHo059qB
         qWWA==
X-Gm-Message-State: AOAM5339W4VNd670zTx7W2AXgFGwyo0cYx4PqfafGco+IG8xLGASiKqE
        Q0OUiwJSWGjrD4fSd4/5mr2R/iwZ0HfT4Xen
X-Google-Smtp-Source: ABdhPJy4e8EnB1cmXjvn9m5vp+R1dw2/6U+y7JoAAyGuq6coSliRIPo54JzAymEMBVNNLK1VLgM4eQ==
X-Received: by 2002:a63:490:: with SMTP id 138mr52103963pge.99.1621096774791;
        Sat, 15 May 2021 09:39:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v18sm6633688pff.90.2021.05.15.09.39.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 May 2021 09:39:34 -0700 (PDT)
Message-ID: <609ff946.1c69fb81.4b32.6f20@mx.google.com>
Date:   Sat, 15 May 2021 09:39:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.232-276-ge201e192258a
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 59 runs,
 4 regressions (v4.14.232-276-ge201e192258a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 59 runs, 4 regressions (v4.14.232-276-ge20=
1e192258a)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.232-276-ge201e192258a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.232-276-ge201e192258a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e201e192258a56205c7af9f3b292c35a53889a5e =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/609fc896a9116ca393b3afa7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-276-ge201e192258a/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-=
q200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-276-ge201e192258a/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-=
q200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609fc896a9116ca393b3a=
fa8
        failing since 51 days (last pass: v4.14.226-44-gdbfdb55a0970, first=
 fail: v4.14.227) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609fc4e810d9770ff0b3afa1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-276-ge201e192258a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-276-ge201e192258a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609fc4e810d9770ff0b3a=
fa2
        failing since 181 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609fc4e8262ffeb965b3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-276-ge201e192258a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-276-ge201e192258a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609fc4e8262ffeb965b3a=
f98
        failing since 181 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/609fc4e89bf16aa012b3afb8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-276-ge201e192258a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
32-276-ge201e192258a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609fc4e89bf16aa012b3a=
fb9
        failing since 181 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
