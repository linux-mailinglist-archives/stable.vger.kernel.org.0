Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08EF62F80DC
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 17:34:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbhAOQds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 11:33:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbhAOQds (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 11:33:48 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 110D2C061757
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 08:33:08 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id 11so5810402pfu.4
        for <stable@vger.kernel.org>; Fri, 15 Jan 2021 08:33:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Shgoxx9EYv/ot5ZdiPjRnuG8hZ7AoRb+SmmBH7LBaRU=;
        b=dnzhgKviDRGSg8pQc8ruS47RLDWe4Sj7gDJiJkzEbD99SkhQxcA0jGMCjXUKPt2mWh
         7tp8W70b2BKIHp4NyCiUEILzaLoVI3lbz+jTTQCVab9BB1jJ/s3G+soVFrFBnFEG7hpO
         EwHN+8qRZ96abA16fwHiHBU8MT9xl3n4+/6z7S5v4Fl3hzuPPERBnkmEC5/pycXXHE+x
         9CuRFBFy6iThi44Dj0+sCSgn14REnEhuaI2ydvdtajfhvBarZ7Nm8GqPmGAjJBfnNQG3
         yC2vWvKZidjr29kSHqQzDz8K3D2HFUzP17mxONKmNShhkCaRMASf3cnzG4c6ME+sp6Iw
         ZZ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Shgoxx9EYv/ot5ZdiPjRnuG8hZ7AoRb+SmmBH7LBaRU=;
        b=r0w6t/0JVdeC5d55Bst93ZlWhJFmKBMeEitYOOE7FqneYogt0j7K1X70PHQp8+2SRp
         20fDu4q7W0wssZk8EUxqZTvoqXC0ft5esjDQJN72i3jJ4QC3blQz5P5l/EnmRZWGDrHp
         gTEfl7kFrX2XuykAk6Kjl9NKI6vc3Dk3boE4xGtcQntNPY405SHWdjhoC72m4JivU26Z
         ikmXm69ppeqld9D5zJov+AwvAhtpE7HS/JlngnY5d5QuSaImfctaDkMFspa6dgR6yTI/
         /iyCILQ25E5gCv1nVvIQNgtTxqPo2Fw5pVTnlbPS7KNqIMHUdLxg66EfJFinEjAXF26h
         b8Fg==
X-Gm-Message-State: AOAM530Sl5GGAlNj5fFaaN42NI9BH/GOj6L7PpVvyaAVV134ehk4JsCO
        cIuSt7ondIUScvGtkBDrn6GbfGqjc0e8dg==
X-Google-Smtp-Source: ABdhPJw2A3Tg8vKD5SLqmrjiDex0UdPjj9erAiWVuUsa0ERoq+4MGtpUfDAllbw+CTtjMKiVvglJvg==
X-Received: by 2002:a63:520e:: with SMTP id g14mr13081885pgb.378.1610728387273;
        Fri, 15 Jan 2021 08:33:07 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id me5sm3109171pjb.19.2021.01.15.08.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 08:33:06 -0800 (PST)
Message-ID: <6001c3c2.1c69fb81.6566.8846@mx.google.com>
Date:   Fri, 15 Jan 2021 08:33:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.167-43-g5a52ae31885b0
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 142 runs,
 5 regressions (v4.19.167-43-g5a52ae31885b0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 142 runs, 5 regressions (v4.19.167-43-g5a5=
2ae31885b0)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.167-43-g5a52ae31885b0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.167-43-g5a52ae31885b0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5a52ae31885b08ee4390f298439994445b562c9c =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6001988438c8796147c94ccb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
67-43-g5a52ae31885b0/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-=
s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
67-43-g5a52ae31885b0/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-=
s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001988438c8796147c94=
ccc
        new failure (last pass: v4.19.167) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/600189a2324b5c773ac94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
67-43-g5a52ae31885b0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
67-43-g5a52ae31885b0/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/600189a2324b5c773ac94=
cc3
        failing since 58 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6001899e4d1e1befeac94cd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
67-43-g5a52ae31885b0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
67-43-g5a52ae31885b0/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001899e4d1e1befeac94=
cd5
        failing since 58 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6001898f2f1f8b3ad4c94cce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
67-43-g5a52ae31885b0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
67-43-g5a52ae31885b0/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6001898f2f1f8b3ad4c94=
ccf
        failing since 58 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60019fd37d29c1bb91c94cba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
67-43-g5a52ae31885b0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
67-43-g5a52ae31885b0/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-q=
emu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60019fd37d29c1bb91c94=
cbb
        failing since 58 days (last pass: v4.19.157-26-ga8e7fec1fea1, first=
 fail: v4.19.157-102-g1d674327c1b7) =

 =20
