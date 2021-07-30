Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78EA3DB09E
	for <lists+stable@lfdr.de>; Fri, 30 Jul 2021 03:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233516AbhG3B0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 21:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbhG3B0p (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Jul 2021 21:26:45 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C813C061765
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 18:26:42 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id m10-20020a17090a34cab0290176b52c60ddso12069374pjf.4
        for <stable@vger.kernel.org>; Thu, 29 Jul 2021 18:26:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=F+pZEY1DKIqngc3SfIGGc3iG950h2I1BrHWQD9Sgrhc=;
        b=yJO4tMyIIL5pvRx5/P+tV77slUCIOH4s0zMK9YFiAkbzSZFTsCuAe/vwffO8OPC1IV
         Itf1G5M+jU2knNfyyhhZ42jk16IvOiMHq/migjPKVdMYPpr+i5qE77kSL3KQnvtaM+1m
         3/g8dhYvt/USVjuVnX5BHpxifqKVCs3zdwegjNDV+cBYzCy5sxB/jtrcS9VipvirqUgv
         a6L1nNfTziox8Hq/JxU4wP1x+RDMWNOWaEx/KwZNyO7pcf81jsTi8Sm5KM8bU3sXPrPj
         Hs+SEXxVVmVWCSBFASxNo07AbaOwxvRCkGyspYJMFm/O0GPcYlN/u19XzuZugDDP7sCW
         XC7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=F+pZEY1DKIqngc3SfIGGc3iG950h2I1BrHWQD9Sgrhc=;
        b=ME8HcIToE+I4oyGJo/d1KaPqANFqYCD3ssWwa2dEholz1hewQ5RdRFXkEG82tLKYUZ
         MEy7p1vWF5/rExnwaMyQ5HqVsOWPWyb2JS0sFRXSs1wPDL0/7XOMqqFJ3Kbm6Tr5mxzw
         NAhDsJ4HxaIcw5vp0ZuT0VeFqmvAO1Osm9YbAy9zNN9zBqyrehEWswLOHfTcUpOxFDA9
         7NFUe83hBmB7lDQjpkMGK37Ve4w7yONrtmi56kkdl89xYQmAE5xq9q0bIEw7pE/LEQUn
         5yUOAEIAV8DN71KPoAcKNzPWDwLo2c1Am3MDqjwgpl+NX5Wa7ixeRH8GWyJc75aUNyX3
         9BJw==
X-Gm-Message-State: AOAM532sxGiP8LYKFqO2pgV6WAOmtT45SBNBdmenFd9Rf44i1mYuUIPa
        9XORzOyvNPuMbMFVnFIuW9jP5QGPDxIC50+R
X-Google-Smtp-Source: ABdhPJy1CkQHuwtAFRebFCyaO8dpfPr2sq0E1QIMCgj1shozG/sTzG4TtbKLrzx0mD+3Upa88nYkbA==
X-Received: by 2002:a17:903:31d1:b029:120:2863:cba2 with SMTP id v17-20020a17090331d1b02901202863cba2mr328505ple.28.1627608401586;
        Thu, 29 Jul 2021 18:26:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j19sm76572pfr.82.2021.07.29.18.26.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 18:26:41 -0700 (PDT)
Message-ID: <61035551.1c69fb81.eebce.0596@mx.google.com>
Date:   Thu, 29 Jul 2021 18:26:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.199-18-g3b0f6d777e85
Subject: stable-rc/linux-4.19.y baseline: 133 runs,
 3 regressions (v4.19.199-18-g3b0f6d777e85)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 133 runs, 3 regressions (v4.19.199-18-g3b0=
f6d777e85)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.199-18-g3b0f6d777e85/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.199-18-g3b0f6d777e85
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3b0f6d777e8545324198eca00a5758c7b287aee7 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61031add67217fb29e501936

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
99-18-g3b0f6d777e85/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
99-18-g3b0f6d777e85/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61031add67217fb29e501=
937
        failing since 253 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61031b2ef14abd43855018c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
99-18-g3b0f6d777e85/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
99-18-g3b0f6d777e85/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61031b2ef14abd4385501=
8c3
        failing since 253 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61031af43bcbebbc0c5018e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
99-18-g3b0f6d777e85/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
99-18-g3b0f6d777e85/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61031af43bcbebbc0c501=
8e7
        failing since 253 days (last pass: v4.19.157-26-ga8e7fec1fea1, firs=
t fail: v4.19.157-102-g1d674327c1b7) =

 =20
