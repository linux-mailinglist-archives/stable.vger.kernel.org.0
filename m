Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8CF938706B
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 05:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbhEREA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 00:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhEREA4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 00:00:56 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FA6C061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 20:59:39 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id j12so6075417pgh.7
        for <stable@vger.kernel.org>; Mon, 17 May 2021 20:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2H7nA5GX6ucqQLo92wxE3cDKXuagWyHeuhcAgvav1N8=;
        b=oet996OhW0lwr0lb9iUOODmYJdaQTuXXrYS4Oyyhh4SceQBxfy5n+Y58XHvxBt9Otk
         W4dBiMd13UtqR6vlYC7IwnYMeHbZcunsWG/yVtz1+tCqlG37gExPwNGECqvUPlCqAbMC
         TNyYT77xRhhYCU3uISgKeK0DaE0QtLtpmuFaJId0MTRZf3b+quP16IJdvksyHUcn0nrP
         tm+RHnFxP/DrpT3f6LBi0VHKVTmcKyx8xDxmEBBJNKgUES9EIjxaddQytczsQ8XfbF0+
         vj7Qjg7UPznconI5j8nFOqNIqc6WyKYTIiwcMBnzclhf6YWUV5xk35De2u/nPRCCXeht
         ddPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2H7nA5GX6ucqQLo92wxE3cDKXuagWyHeuhcAgvav1N8=;
        b=Bi4a1JM9Ai6Yv4NQky5n+RN3E/AuaTeZpu0Ln9Bs0wt5KX23FVUKzrsM10ywQrCQvp
         /HYpQPKAdz7Zjzz9px/qrZ9a5jNQ4y5t8YyOp2OHHCqDZ+aJhLd/+KyGM31lx5az1bHH
         8nE47GzNU4nMd7Vo5Pui72b0Uf5pDUjmT8OIK7cm8qZ6ZmNHRRuDjzsKtw03rN3/BXRN
         zcMQWaBcaM7OCv4ByRb+8kmUdHs6XJro87GKbwA7OxR6H/oJRrvhvfCWJG1guo5zlxjk
         Pi+ikot1DD10+hI/jAIHeqPUH8xIV4mr6/IrH4F1swbiFrHSIjx9JwjohD2BI1XChAUP
         ublw==
X-Gm-Message-State: AOAM533cxXJRPPV8OiLWIYQasMWJ+/Xwss3mSgEvvIxGCeeeGTX6ZSZY
        MKqgf8weOFMSD1zHv51BwHEZMuH2ZmCGV9cp
X-Google-Smtp-Source: ABdhPJzYDBkc8rwum0Mow/4h5URBUM3NyiLfzvLo0/3i7xjnaByl2rJ5euvn+rheI8FLFuwieMC0Pw==
X-Received: by 2002:a65:6a08:: with SMTP id m8mr2942446pgu.146.1621310378388;
        Mon, 17 May 2021 20:59:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gj21sm681375pjb.49.2021.05.17.20.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 20:59:38 -0700 (PDT)
Message-ID: <60a33baa.1c69fb81.5bdc5.364e@mx.google.com>
Date:   Mon, 17 May 2021 20:59:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.119-142-gd406e11dbc13
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 129 runs,
 4 regressions (v5.4.119-142-gd406e11dbc13)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 129 runs, 4 regressions (v5.4.119-142-gd406=
e11dbc13)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.119-142-gd406e11dbc13/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.119-142-gd406e11dbc13
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d406e11dbc1324e375ab1f7c4669abc3cbd994f4 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/60a30862eb59d390a7b3afa2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.119=
-142-gd406e11dbc13/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unlea=
shed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.119=
-142-gd406e11dbc13/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unlea=
shed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a30862eb59d390a7b3a=
fa3
        failing since 178 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a30707fde5acb21cb3afaa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.119=
-142-gd406e11dbc13/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.119=
-142-gd406e11dbc13/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a30707fde5acb21cb3a=
fab
        failing since 184 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a306d5b9b2d3a8d4b3afaa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.119=
-142-gd406e11dbc13/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.119=
-142-gd406e11dbc13/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a306d5b9b2d3a8d4b3a=
fab
        failing since 184 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60a306f32a094259a1b3afba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.119=
-142-gd406e11dbc13/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.119=
-142-gd406e11dbc13/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a306f32a094259a1b3a=
fbb
        failing since 184 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
