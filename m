Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F103FB4B4
	for <lists+stable@lfdr.de>; Mon, 30 Aug 2021 13:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236597AbhH3Ljs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Aug 2021 07:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236434AbhH3Ljr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Aug 2021 07:39:47 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE074C061575
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 04:38:53 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id s11so13113041pgr.11
        for <stable@vger.kernel.org>; Mon, 30 Aug 2021 04:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=w04ir3tds4SV5OnAbnn5DKqiOMxi9ZCQBwX2BtOkB8A=;
        b=d8rqWrb6g245xI+1oO+FlvOEnvEy968kXz8RQwofwhnOkdrLLVE2aY3hh9uWjEEgMW
         RRr1FHzy5TQuhq0OxrSiujfm5vBOX+CI75fQeDZsvDP/EPkjSoWxIYyhlynevchqTAH5
         +Ph6ZVv9/J9/NGAvY8YY8fALzAfj5UZzGVOeydk/xvT0zbySMeu387zXb2zWnYHpb+Di
         OUJnHrLd12kYzQQyyuTxm4MUxEBgtUXueWRvC5PJb5lkVe9pk01JEHDGZOhth+6CXiEO
         2TeZWMdWHjlrdQSNdJsJDmH1w3y7yp9bFgTOD4ojBYAajY/FZ9XjMjHM4Q3UUOdTRxUq
         /Png==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=w04ir3tds4SV5OnAbnn5DKqiOMxi9ZCQBwX2BtOkB8A=;
        b=t5vTvhlYqWLRYzPyaylCY9tdvwPdA+FP6ND2j02C8eEHdL7VO27L/yyHyi/NcPoKXr
         p1YNqJpFfa87znRzM4uXQlal0EBPa6K2SG7GyWUC3iVb/HzhxW6unbJizeVxFSy5Vjvn
         3LLEXlg0YoajBq2pESP51QUwPYRJsFWjiH6imy7EXUywq6maStYoCYTITw2N6T2V1Q30
         UnRcgfxcOZPnRFDrrqam8YisJB1lfKDCkCovw2QDb+9DLFGmNJuM3BfrEg4cHoT8HBLN
         MoMe6c9rswOO9D1+BzX/16WXYXn3fOJZiua7LqyVS0jpw1RKNEgssM59Yg2MugivNnw0
         +ntQ==
X-Gm-Message-State: AOAM5304y3JbgmSSfK0NyzaJCWGC8qDdM7hm2MdOh8JPhBhPTEURVo2V
        JYsKjYWG8xkqE2Pgt+2S3xyOtOVVEzjwQkQO
X-Google-Smtp-Source: ABdhPJwptM3iuDrY4eCAaaE3lGihiQ4Vfps5aZzZ2SZMcS5oGfgYWum5pD5BEuYRch5JKv7qyOjOGA==
X-Received: by 2002:a63:7405:: with SMTP id p5mr21235439pgc.426.1630323533025;
        Mon, 30 Aug 2021 04:38:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k190sm6221908pfd.211.2021.08.30.04.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 04:38:52 -0700 (PDT)
Message-ID: <612cc34c.1c69fb81.d8a99.dc60@mx.google.com>
Date:   Mon, 30 Aug 2021 04:38:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.281-10-g68fa8d648bfb
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 104 runs,
 4 regressions (v4.9.281-10-g68fa8d648bfb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 104 runs, 4 regressions (v4.9.281-10-g68fa8=
d648bfb)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =

r8a7795-salvator-x   | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.281-10-g68fa8d648bfb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.281-10-g68fa8d648bfb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      68fa8d648bfb471ab81317b7273edae4fc833c55 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612c8dd6b27b5732fc8e2c77

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
-10-g68fa8d648bfb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
-10-g68fa8d648bfb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612c8dd6b27b5732fc8e2=
c78
        failing since 288 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612c8dfb71b7a5c1a68e2c97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
-10-g68fa8d648bfb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
-10-g68fa8d648bfb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612c8dfb71b7a5c1a68e2=
c98
        failing since 288 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612c8dc5d20d53e8f38e2ca6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
-10-g68fa8d648bfb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
-10-g68fa8d648bfb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612c8dc5d20d53e8f38e2=
ca7
        failing since 288 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
r8a7795-salvator-x   | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/612c8e9a54a774b7b08e2c91

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
-10-g68fa8d648bfb/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.281=
-10-g68fa8d648bfb/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salva=
tor-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612c8e9a54a774b7b08e2=
c92
        failing since 285 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-79-gd3e70b39d31a) =

 =20
