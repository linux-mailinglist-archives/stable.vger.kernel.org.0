Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48BCF376940
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 19:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238477AbhEGRG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 13:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhEGRG1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 13:06:27 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43FDAC061574
        for <stable@vger.kernel.org>; Fri,  7 May 2021 10:05:27 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id t2-20020a17090ae502b029015b0fbfbc50so5574013pjy.3
        for <stable@vger.kernel.org>; Fri, 07 May 2021 10:05:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lsAuSMQ9BY1BQlXYZyIsL+gCqk5nZhlxNlMtz3BaKCo=;
        b=O9H0kQ5uoN5MdrmO2Z+uMaKCJKim4MafV1jYBzupb8FJFHGK42mRfwCzVf9BYF1AIX
         1xaJaE+VKkeyasbrNzgUP8wAHxufuPdjwPRbpXiA6LaFDfk4gdq/+stILooN1GbaCvv+
         hnGwrIVgRTw3joMK2diuVtD3giSy8/s6t7nf3AkWQLDle4D9UvyiDdgrNs2ChWLifjIo
         Aildub0kKybH6SW/vvtqG4hBcbwZ8C1b12t/cq7/1W/UoIGwQwbRRCp0stliYAJQv5+S
         hUEAYqiWTyLpZDGpOrvoMpWuWLTBMjdmTgbUW/Qd8bWHVY/wPyW77sM+cu49Gl2+Lz0N
         jumw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lsAuSMQ9BY1BQlXYZyIsL+gCqk5nZhlxNlMtz3BaKCo=;
        b=JaGvlVL37HuUEPOCwaEgUfYK0uAnnI4AKZOR1p6dscQGwQMXXahijM1V2cPxncbcYg
         jKKlMhjUWCTfrIrj0kQ/NnPT1kfsBbPLmWHy18E8/LDyV2XDwzucdzSFZgbV125sYfaq
         OGY20bXTs+nehUsSTERrgAy31okSyUtbBOQsjbPImf2/SbxJrAyS4b5bHgcbGAM9PPcM
         YuORFe1KlMRAm6Td0GnLaJzFSo9Z36b0Z9SzeSDfNKTdhYed/UE5K9MhNRspNg9BH6NU
         j3kAd/3eJUvfkSicbdHVUk/Ijwsc+slvhaAmk6x8NqjtXIMG9tlbE5aOVubiygAHDHn8
         gO1w==
X-Gm-Message-State: AOAM533ztr7JC8D2ROwOCrZUy7BkYCEmnSuF7WsBt6t+aHXsb0HOxJ8S
        1eKZ7xPG04k2TlCrW6PezqRRNel9BFlkuPIY
X-Google-Smtp-Source: ABdhPJxAOfXxZ7wRCgXPVl0um/EyCcEelpmi420doxS30clfr+lKTKYBJP1CJGfbKuoVVC5ZbQ+eXw==
X-Received: by 2002:a17:90a:a404:: with SMTP id y4mr23905036pjp.228.1620407126494;
        Fri, 07 May 2021 10:05:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i126sm4989085pfc.20.2021.05.07.10.05.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 10:05:26 -0700 (PDT)
Message-ID: <60957356.1c69fb81.d7d8c.ecbc@mx.google.com>
Date:   Fri, 07 May 2021 10:05:26 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.232-16-g69bcbe08449af
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 95 runs,
 5 regressions (v4.14.232-16-g69bcbe08449af)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 95 runs, 5 regressions (v4.14.232-16-g69bcbe=
08449af)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.232-16-g69bcbe08449af/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.232-16-g69bcbe08449af
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      69bcbe08449af935c773bebcd408e69cd0c5af15 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6095460dc778df99d96f547d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g69bcbe08449af/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g69bcbe08449af/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6095460dc778df99d96f5=
47e
        failing since 67 days (last pass: v4.14.222-11-g13b8482a0f700, firs=
t fail: v4.14.222-120-gdc8887cba23e) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60953da14eea67ef8b6f5483

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g69bcbe08449af/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g69bcbe08449af/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60953da14eea67ef8b6f5=
484
        failing since 174 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60953dad585a3796176f547c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g69bcbe08449af/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g69bcbe08449af/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60953dad585a3796176f5=
47d
        failing since 174 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60953dbdd1943adde96f555c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g69bcbe08449af/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g69bcbe08449af/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60953dbdd1943adde96f5=
55d
        failing since 174 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60954f16dc20fd7c246f5491

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g69bcbe08449af/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.232=
-16-g69bcbe08449af/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60954f16dc20fd7c246f5=
492
        failing since 174 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
