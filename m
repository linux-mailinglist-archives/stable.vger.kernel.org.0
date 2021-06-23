Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3612C3B2232
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 23:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhFWVHf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 17:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhFWVHe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 17:07:34 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07BDC061574
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 14:05:15 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id h1so1824483plt.1
        for <stable@vger.kernel.org>; Wed, 23 Jun 2021 14:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5id3MZhO5wlHjqRjtcxzy3iJxoCEjrazVnfM8CC67eM=;
        b=dX9H7lDXppLXVcusJY8upTyJOx5Gn8z40tmuxgVCsKbkIqhlTxycULIL9PCY28hCGU
         4+lzHmPGus1/gr/k6dXy/HRoPbBlOB1ICyvDbLHTVihXc+ATI8CSx3DtuImm7UWLKlgO
         DuKTMS/CL3fvXMWQkh47ygW1WPxr0Nb84ftAm82vUagjpirg79nKUnJ8bBx2LEUSh4UU
         lLhA1MlyiMJt7nva8b8uNKUKe/p0/TlQqedSg00YQ/VVO0nKmPZcwRrVj7iov5+jqgvm
         M/gJnLAYFQ0rGq5h5KGFZJjB8pNeZGqpTaNN/cfOmKgRnSD8tmdO5wa0y7HNyinSyY6o
         xHJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5id3MZhO5wlHjqRjtcxzy3iJxoCEjrazVnfM8CC67eM=;
        b=f8bkiRS4CT92i2LtI1SY/EYj8NH09jsHNNwXrphEQ1KID0/8sYeT6nrjQ8Mzxch/HD
         pt4lRqxIYRyFwJa2RFWsFXl4zhmyefDQ3eJre8r8u3M6Q/d9FqyCUjJIxch0ju9FsSVI
         57nI6I9aZQJOVltLZt3/tWQkRBotWwk6eCfs46+ro/L55bblktyS7EWyQ/iVRcyInRjB
         qpGfsy8ES74RYBnli+hIVCXYQktYfY9XZF9y8ddP/8X/ay1+nw5vaxPO0EzF3XPA5xHC
         a6oGwEjmusQhMSsoKzew+DXFj5v0fIyzn1ePsS3uJES76xqwS0s4hitFTF25NQ2mERPp
         VWPg==
X-Gm-Message-State: AOAM533GQKinJQxkISYbsvgWwIZVVnd2WUeIyCNdWAVreHW/VuQviJKf
        IAWyZ5jSlGmBzpLb/+RUULIGMF0a3la1CbdM
X-Google-Smtp-Source: ABdhPJwPDhZ2WQEIUntmMyp65CchOvi/mDEDF3P++YHbLYt6HySGTrm3vQQ0IdkwXSUEuGIdiBku6A==
X-Received: by 2002:a17:90b:1509:: with SMTP id le9mr11330849pjb.35.1624482315113;
        Wed, 23 Jun 2021 14:05:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p9sm675929pfo.106.2021.06.23.14.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 14:05:14 -0700 (PDT)
Message-ID: <60d3a20a.1c69fb81.dcd7f.27b2@mx.google.com>
Date:   Wed, 23 Jun 2021 14:05:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.195-82-gac2cbdc0a2a3
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 158 runs,
 6 regressions (v4.19.195-82-gac2cbdc0a2a3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 158 runs, 6 regressions (v4.19.195-82-gac2cb=
dc0a2a3)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
bcm2837-rpi-3-b      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.195-82-gac2cbdc0a2a3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.195-82-gac2cbdc0a2a3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ac2cbdc0a2a33a0487aef42077b1b1a20a044c1e =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
bcm2837-rpi-3-b      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60d3715cd4291d1f16413287

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-82-gac2cbdc0a2a3/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-82-gac2cbdc0a2a3/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/60d3715cd4291d1f=
1641328a
        new failure (last pass: v4.19.195-81-g76ed23702abb)
        1 lines

    2021-06-23T17:36:56.588559  / # =

    2021-06-23T17:36:56.599298  =

    2021-06-23T17:36:56.702675  / # #
    2021-06-23T17:36:56.711040  #
    2021-06-23T17:36:57.971769  / # export SHELL=3D/bin/sh
    2021-06-23T17:36:57.982257  export SHELL=3D/bin/sh
    2021-06-23T17:36:59.603003  / # . /lava-480961/environment
    2021-06-23T17:36:59.618706  . /lava-480961/environment
    2021-06-23T17:37:02.566534  / # /lava-480961/bin/lava-test-runner /lava=
-480961/0
    2021-06-23T17:37:02.577825  /lava-480961/bin/lava-test-runner /lava-480=
961/0 =

    ... (9 line(s) more)  =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d3745a9cdae39e8b413282

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-82-gac2cbdc0a2a3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-82-gac2cbdc0a2a3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d3745a9cdae39e8b413=
283
        failing since 221 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d378f039306f9e05413283

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-82-gac2cbdc0a2a3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-82-gac2cbdc0a2a3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d378f039306f9e05413=
284
        failing since 221 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d371fb7f6614e53e41326f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-82-gac2cbdc0a2a3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-82-gac2cbdc0a2a3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d371fb7f6614e53e413=
270
        failing since 221 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d38710a2a900132b413270

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-82-gac2cbdc0a2a3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-82-gac2cbdc0a2a3/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d38710a2a900132b413=
271
        failing since 221 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60d36a0e0261e41ba7413268

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-82-gac2cbdc0a2a3/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.195=
-82-gac2cbdc0a2a3/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60d36a0e0261e41ba7413=
269
        failing since 221 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
