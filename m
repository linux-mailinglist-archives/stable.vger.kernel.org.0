Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3E234BBE5
	for <lists+stable@lfdr.de>; Sun, 28 Mar 2021 12:04:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbhC1KDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Mar 2021 06:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhC1KC5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Mar 2021 06:02:57 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D491C061762
        for <stable@vger.kernel.org>; Sun, 28 Mar 2021 03:02:57 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id v8so3007461plz.10
        for <stable@vger.kernel.org>; Sun, 28 Mar 2021 03:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=beUPKuw1Q47D8vFJS/WzqT40LH2Oj7dr+ieoq8899ZE=;
        b=F+wg2lONLkij3fwQrsUE8T1caD2CRKRHJcPy6WvQBMOCvAH2m7fKtD59oNAG9EyXWJ
         WqpfQB7OIQk6LItGPpOY7QLwCRkRCgGpKZVlok6MqhTfaBI490Dud2XDXVEhdrbj1a9Q
         TIoL7vN/brRkeIb0L6W7NmjPgxZxMPTJznuy3mgqfq7YaqrRFV2s6o4SWkmFF2gqSlCU
         10h/SySsK6pnUrxbjO3iT/s2+2AXS5bXXsKKG1Rqj9pizqGHRSo+MjXEsgFTMPYoR9fq
         4RMAdmQFvb3rOMheiDGKrcoTTcrB2OQEO2hhWnFof27MQSKHCgYDNseSAlAvZks8NxZ2
         YNfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=beUPKuw1Q47D8vFJS/WzqT40LH2Oj7dr+ieoq8899ZE=;
        b=Us9ZE6HWEXjv4AOubNI3i3utXPlAS/YlpUSXTkuvUgO0A9RDtyXNhDoOOlCG02peMw
         2gaVQOzJVvMfK26sZhZ6jiowb72XPZXaerGwHgRM4Q3N2cRLiZW4aSLKwXlJccOpKZiq
         A2NDo/OC0WFwxJAwdWEZkD04F/3+nqEW2/UjWYKRSiZsiW5/WyEGHI28SLyGkuTmvIEq
         US7fXmIzR/jPWVoaP9JR6BA2s4Kp3fwATi28toEpNbc2gxWG8l/uvqhbCXZmBepB7eV8
         qJR7JNcx8M+/TBR/lTRjdOfdn/sx9ze086CtyELKTJvt09XIAuX93c/ix5IgUg2pDava
         ahFg==
X-Gm-Message-State: AOAM533eMI8RAj9ascCJA6sKJHhVgJBfltXAm/qNHb8ey7KU6EI21CYx
        rXwbCckBZ68XGREP1Eabf/FrAZpsJd5oNQ==
X-Google-Smtp-Source: ABdhPJyN+7Ew5PsdMZ/JFoTUNYy8ztb9sxY6kjbONysjxDOPz1Qn0Vfm+Xo9dAsNU21eojLQ4AZhCQ==
X-Received: by 2002:a17:90a:c004:: with SMTP id p4mr21736516pjt.202.1616925776413;
        Sun, 28 Mar 2021 03:02:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t125sm13425114pgt.71.2021.03.28.03.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 03:02:56 -0700 (PDT)
Message-ID: <60605450.1c69fb81.daa71.0852@mx.google.com>
Date:   Sun, 28 Mar 2021 03:02:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.227-47-g288d6b37d6f3
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 52 runs,
 4 regressions (v4.14.227-47-g288d6b37d6f3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 52 runs, 4 regressions (v4.14.227-47-g288d6b=
37d6f3)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.227-47-g288d6b37d6f3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.227-47-g288d6b37d6f3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      288d6b37d6f3bedd379885e15f453b330f89f802 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60601a149e4a04b84daf02c3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.227=
-47-g288d6b37d6f3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.227=
-47-g288d6b37d6f3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60601a149e4a04b84daf0=
2c4
        failing since 134 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60601a22023f0b026daf02de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.227=
-47-g288d6b37d6f3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.227=
-47-g288d6b37d6f3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60601a22023f0b026daf0=
2df
        failing since 134 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606035389745957d35af02b9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.227=
-47-g288d6b37d6f3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.227=
-47-g288d6b37d6f3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606035389745957d35af0=
2ba
        failing since 134 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/606019d0f06c70e091af02e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.227=
-47-g288d6b37d6f3/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.227=
-47-g288d6b37d6f3/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/606019d0f06c70e091af0=
2e3
        failing since 134 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
