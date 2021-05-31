Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E59395A33
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 14:13:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231370AbhEaMPa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 08:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbhEaMP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 08:15:29 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F681C061574
        for <stable@vger.kernel.org>; Mon, 31 May 2021 05:13:49 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id v14so8227962pgi.6
        for <stable@vger.kernel.org>; Mon, 31 May 2021 05:13:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ADi//ub8dTYBRx/wxsjPRysHOF8FP2MJwvPHkJqRDB0=;
        b=ocGgsQJu7McwP46TDzTsIsCvm+GlYmEQDQmMUc/LZ47caE3gAZk1pHHE6rBq2dakXG
         IXyRjMZjU+SFmXcPeb/5cHHMmNcSgmkY0AsdhhCKdRbvAVdwlj0yZQR6kvyLE6ozxRxK
         XrtwawMV6WlrOY+qJHk+3mnPmBnV86ujc0ThvR9+ThxiUvbSHKPDGkXU6klpP2oSycNT
         HTFrudIJ6mKmS9spOFoKuVKcQCdEwy5HSghHPH8lgq7jr2bb04VJRjIQcovDySLp3yvV
         +qxRnFgk5lrLNuy9HNMqTnVWSZqJy39eZ0dZzjwqyVgMYfOE37m/2b2b0Cq6Ntm09MOY
         W9CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ADi//ub8dTYBRx/wxsjPRysHOF8FP2MJwvPHkJqRDB0=;
        b=LqH9KWSf0udVPcqMc5ADAwG/7PTGNAZRnFCaazAOqsjbHvL5VSMzK49afFV192nwsx
         cDaGlZC8VDIRfvYi73OyxhC+6xIAQQGs9HALCau0/4YEMNr8nCval3Ml6QhcXAkOuhDj
         V7eYbW+BTfCtwQX+dt1yYz85AJY6y/Ldg1K5DvDBgYtb64SLRi7txe6wpxO6Gb8cbD0B
         ZL8pq1kcxcs2hfCHyTy9R6a8x6IyzevpkuRq5soSqaNcNbELnThLVZUd8q3/RHgJ5Vya
         BobcDK68RQ8SWrvn3pC1nFNGzSZ3BbcG3ivbHCF7X9c6iR73+TfzxrU22b2tAN68Zby5
         b7lA==
X-Gm-Message-State: AOAM530HS7I9Mms7ZBfrhDKFXjqXMurVurag0QzXzGMEkCR1pQ+cdfIt
        cKr7mnt/ddi1TK6wf2uYPV0qagnX3EfAeb9A
X-Google-Smtp-Source: ABdhPJz3VyAs+ovAbqb2urWiAE7gU7b3Db8MGgsw7e1ihNqY4NVdrfI3/PK8V7bgf5WB17HIjWHEdw==
X-Received: by 2002:a63:5158:: with SMTP id r24mr22529942pgl.41.1622463228729;
        Mon, 31 May 2021 05:13:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n9sm10902771pfd.4.2021.05.31.05.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 05:13:48 -0700 (PDT)
Message-ID: <60b4d2fc.1c69fb81.a2ab7.22ec@mx.google.com>
Date:   Mon, 31 May 2021 05:13:48 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.192-115-ge9e813bb42b8
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 140 runs,
 5 regressions (v4.19.192-115-ge9e813bb42b8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 140 runs, 5 regressions (v4.19.192-115-ge9e8=
13bb42b8)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
meson-gxm-khadas-vim2 | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =

qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.192-115-ge9e813bb42b8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.192-115-ge9e813bb42b8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e9e813bb42b86543f2a5634e84dc44f45f084170 =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
meson-gxm-khadas-vim2 | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/60b499734b78e3056eb3afb6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-115-ge9e813bb42b8/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-kh=
adas-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-115-ge9e813bb42b8/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-kh=
adas-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b499734b78e3056eb3a=
fb7
        new failure (last pass: v4.19.192-97-gbcb6e5399a5d) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b4993087cd76a171b3afa1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-115-ge9e813bb42b8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-115-ge9e813bb42b8/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b4993087cd76a171b3a=
fa2
        failing since 198 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b4993b7e5b040411b3afad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-115-ge9e813bb42b8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-115-ge9e813bb42b8/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b4993b7e5b040411b3a=
fae
        failing since 198 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b499301b1e9b9928b3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-115-ge9e813bb42b8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-115-ge9e813bb42b8/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b499301b1e9b9928b3a=
f98
        failing since 198 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60b498d5652dce2eb7b3af9c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-115-ge9e813bb42b8/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.192=
-115-ge9e813bb42b8/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60b498d5652dce2eb7b3a=
f9d
        failing since 198 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
