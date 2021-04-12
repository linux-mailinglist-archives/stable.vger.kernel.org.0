Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1808435C789
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 15:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239054AbhDLN2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 09:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238431AbhDLN2j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Apr 2021 09:28:39 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C560C061574
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 06:28:21 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id n38so9216506pfv.2
        for <stable@vger.kernel.org>; Mon, 12 Apr 2021 06:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9e6JsTE9tKCRvxqxWNJrvwSWDiEHdtrnmuZ4QEd5uLs=;
        b=yKZ+2FzeRgRNAn+BP9ElIef06Dhus0zGA1AB/j9Q+TJS67Z88AVJJh0nzbfJu5uv7b
         dSn02/F1eeTcuodDHMMsrtle/Q+SLcLeJxpEsiat42oYwr0Dq3vtMIBsXaksZD2teaRk
         7WllSODEJhsCpUAzPW6LRGg7I6C5mw6u/48LOu3cnPEd1hdvt426wGUtySJeZPHHEf2U
         Vs3FHxjKYS2hlbQXTxEIHKR+FIGNE7+XRzavb4+axQxxhcEP2rksd9WIlDdYJFXt0eHu
         DTPcAV7mf+9Ho2edkjYOezwIS+wBqldgli+8uyyGkM1QIaf3SNSH2gU6jB98xBhUVuhI
         7Z1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9e6JsTE9tKCRvxqxWNJrvwSWDiEHdtrnmuZ4QEd5uLs=;
        b=QzX/tqCCQjV+DEDkPbO/Kcg6RLWm7BMAhNHMkYApb1MYskGkQy76vm+n9L52Ij/97O
         DUqzn4sqn4JneGx1E4bd8UGre5fIdF5C1Flrv0bg5TX21PWjRN6h1MAQYGbPRSUkiI70
         1QpaU//441o0P7eMfekxBJr9DCBefUbaNhksIkVTz2qYDg86s+c9GD0V27UgvKqeaOZP
         RH9VVSxcZbV7hkaPyZgPJRORycF7VkA1F1GNTW5ulWgrQ8b/FLIDBpubPQsDt6cCFNsO
         gWgeERZVYqhdrBIQ4qFNQ9v1P5r75n1TMyRmn9O+Zv1FMm+R/oFFb0fAAfgLWUibTKQX
         ckWA==
X-Gm-Message-State: AOAM532TtdhK/tUrw7q2TEGEMmtQIgkSLtH3isvtRtA7/sR1EDFV0piN
        olizh1ydtFB/mGQoDFmpUaxzY9gvI4IJ1Ix3
X-Google-Smtp-Source: ABdhPJyM9fiY95+2giR+XUGdD3BIlIKA5IT3zB580CEgzVCQX0n+afWw3fibY3LsFp7ezBXUk7mxFQ==
X-Received: by 2002:a63:fc58:: with SMTP id r24mr26965007pgk.368.1618234100939;
        Mon, 12 Apr 2021 06:28:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h21sm11270936pgi.60.2021.04.12.06.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Apr 2021 06:28:20 -0700 (PDT)
Message-ID: <60744af4.1c69fb81.7cb3f.ae1c@mx.google.com>
Date:   Mon, 12 Apr 2021 06:28:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.111-112-gf9b2de2cddd46
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 128 runs,
 5 regressions (v5.4.111-112-gf9b2de2cddd46)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 128 runs, 5 regressions (v5.4.111-112-gf9b2=
de2cddd46)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.111-112-gf9b2de2cddd46/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.111-112-gf9b2de2cddd46
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f9b2de2cddd4601c5d2f2947fc5cebb7dbecd266 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6074140816e63aa42bdac6c7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.111=
-112-gf9b2de2cddd46/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unle=
ashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.111=
-112-gf9b2de2cddd46/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unle=
ashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6074140816e63aa42bdac=
6c8
        failing since 143 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6074174dad5ab4490cdac6b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.111=
-112-gf9b2de2cddd46/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.111=
-112-gf9b2de2cddd46/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6074174dad5ab4490cdac=
6b3
        new failure (last pass: v5.4.111) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/607414afd6e0436100dac704

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.111=
-112-gf9b2de2cddd46/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.111=
-112-gf9b2de2cddd46/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607414afd6e0436100dac=
705
        failing since 148 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/607414b0d6e0436100dac707

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.111=
-112-gf9b2de2cddd46/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.111=
-112-gf9b2de2cddd46/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/607414b0d6e0436100dac=
708
        failing since 148 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6074143c2935f51b5cdac6ce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.111=
-112-gf9b2de2cddd46/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.111=
-112-gf9b2de2cddd46/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6074143c2935f51b5cdac=
6cf
        failing since 148 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
