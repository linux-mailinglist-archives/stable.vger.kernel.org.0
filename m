Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35DD22DA830
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 07:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgLOGry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 01:47:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbgLOGry (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Dec 2020 01:47:54 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E27EAC06179C
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 22:47:13 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id k65so4286068pgk.0
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 22:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1ho8azHHxWLbhFt2sUBBSusPzs+nOowNI4vDUnUXjWs=;
        b=G1yh3RoOSOhZsY40h9D3Y5gdpHTgTsim825AOPjW1QRgv6Uxq9yHWbxcf/ZKuRVAXR
         6kVi2xOITOGkG05oaZGGS+VNCDXkmhbuYWhGl6LAWKxCmt+8/QpyPTGl1lgg9XFMH4mZ
         zfVR3KuodBG/lav6Ne8dUDkSxN0EnWi50lpRh2eYXuOKsM9+AMBC3mB1/YOXf3oif081
         p8b8eL5JYxfIrAcgbqPCuwFnr+vNzSk6JUjeSshGfqP0lFPQ0AtLAIUefBuBhveABC22
         Nv5fwiP+0Ba5pKxpKU5FeTvYeqR45zoMDYNqCueVgYeQ3QOwOVaGMF6DhcbJjZxdUapt
         WH7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1ho8azHHxWLbhFt2sUBBSusPzs+nOowNI4vDUnUXjWs=;
        b=Jd0PaFxPOF7nv4mX4x3gTLn/nndD/IfRpvOfXdp8k8/LxUCC2fD2xcS/VV/8w6wryV
         Xfz+ULKE+MUDnadR30iXcbD6B1gQuRykU2cHyW8xhPr8P7ZaCqO9vzwWczotPKN+/gvz
         nxB1A/z/srIjbkWCTb8vem8Vo1ack1TaFt/SlBuTmuBEnVv9uUIdfymnHIXp+njEm+H4
         N5DmLe+0cHlg1FE6RjliSBwQ9Jmpin1wzNQzwvPCaZTRp10dPgacUsIwTsLHjcoQLMpZ
         0SdcbAd+dfyKca66xDtLpBVw+Mvc3yehYYTtkKLHKYzoVUlMHvBUDLVG7yna+P0T9AWJ
         irwg==
X-Gm-Message-State: AOAM530OgPOOEd1pdvawFrSyOlNlsNrKoOuznU/tQuD3XXftT6yRmhDl
        3rk6v3SGanbccNU3U05/WSHFwGfDm2Ze2Q==
X-Google-Smtp-Source: ABdhPJzxqmbf6CkFfoBcZ9yMJnTQidApexQ1lep0Xyd0X5o6VVrbuQs7uq9MzNvCIlz3gOpDvB20qQ==
X-Received: by 2002:a63:cc4c:: with SMTP id q12mr27686400pgi.361.1608014833029;
        Mon, 14 Dec 2020 22:47:13 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q11sm10855022pgh.16.2020.12.14.22.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 22:47:12 -0800 (PST)
Message-ID: <5fd85bf0.1c69fb81.ae6e0.99f0@mx.google.com>
Date:   Mon, 14 Dec 2020 22:47:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.212-16-gedf392b713523
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 89 runs,
 3 regressions (v4.14.212-16-gedf392b713523)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 89 runs, 3 regressions (v4.14.212-16-gedf392=
b713523)

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

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.212-16-gedf392b713523/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.212-16-gedf392b713523
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      edf392b713523129d804b54fb4c3aaaf37f48a7f =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxm-q200       | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd827974b40fde0e6c94cdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-gedf392b713523/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-gedf392b713523/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd827974b40fde0e6c94=
cdc
        failing since 6 days (last pass: v4.14.210-20-gc32b9f7cbda7, first =
fail: v4.14.210-20-g5ea7913395d3) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd8282d4745696883c94ced

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-gedf392b713523/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-gedf392b713523/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd8282d4745696883c94=
cee
        failing since 31 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd8283cfb1001378ac94ce0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-gedf392b713523/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-16-gedf392b713523/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd8283cfb1001378ac94=
ce1
        failing since 31 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =20
