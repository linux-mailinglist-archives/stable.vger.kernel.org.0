Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E260E376AA4
	for <lists+stable@lfdr.de>; Fri,  7 May 2021 21:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbhEGTXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 15:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbhEGTXb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 15:23:31 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD40C061574
        for <stable@vger.kernel.org>; Fri,  7 May 2021 12:22:29 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id h11so8696942pfn.0
        for <stable@vger.kernel.org>; Fri, 07 May 2021 12:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MWPJgM1RQ1evnPAmq3lhDuoBh+sobnBJ1me6ZC0ZJkI=;
        b=GQWn4BcK0p559sWmzd1FOmKoSwYB8pAJj4XEH7JcWEhrMAVW9ABsS8k6LanPHabS1O
         N2s7SsQICOfzq+gAf+cmnKS8n/m+PHtffv5HGDAhCzNVPSsUyOA+XasPBc66hNEu49Qb
         sx0vMR2msxRdKrvE17gwGCXJwWpwNRqyqaypIof0HYVzSWQK/E/GM2WIBLx2qGVT12/u
         cgyrTGoo/0/gS3C/jaY0sCG8jWxG60NIpXblqfGyvcsdJ7dkBqd3Q4+28NSg2qzYU4dx
         tn7XqSKFDSMFLwXGpGuU+vo3J0D6O8lAu8C/SNmKvFzuA+a/0LCWsn7t5B8unY8CSsq8
         PX4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MWPJgM1RQ1evnPAmq3lhDuoBh+sobnBJ1me6ZC0ZJkI=;
        b=L8ZXr+leL0TVq5bshh2+HKyiXfaRpeWBimK69lkmTJ9xZ+/LUEX/ybD9Dfo0d/xFlx
         EjoGiQ23rQpqGh45nG6vxvl7tKz4nJGg75kgQ4kTLixiqYMqizgmfUxnJ+egcXIe/fJC
         Roae0Li119mDsCZjsCLwz+MOzpGUt45xHSX1p/gFr//f7tb56gtHTBTk7vv4WrBNs8WW
         N4ntPEsl5dtMlXiSikshwxUs9CAlduD2uVjhJvGyIDrt8iFOjQIDLz+No0xo292hMgiV
         QCcor46JFcCnWCBj0WO4w8e1ULF9VBtHDfETpZJD5/jXtHRwvqn9qSY+PRXxGlyLEmNw
         oVbQ==
X-Gm-Message-State: AOAM5336peprnmE5bltqfa9b4XSfhlq64kfunWwhMfPn1NZJtgCr7D40
        I3Hfu0Yc6e5iL2ECnWdxSIPtoy3EVZPMnmkC
X-Google-Smtp-Source: ABdhPJx/XzjrbiMoU1n7q4n2tEiiHwl7kW7tZhsBsrT8Xjw9jE2Hr/tbYFEe9lN9mokNXQtplDVfDQ==
X-Received: by 2002:a62:7f84:0:b029:25f:b701:38e5 with SMTP id a126-20020a627f840000b029025fb70138e5mr11849912pfd.5.1620415348641;
        Fri, 07 May 2021 12:22:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w2sm5536352pfb.174.2021.05.07.12.22.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 12:22:28 -0700 (PDT)
Message-ID: <60959374.1c69fb81.260f9.0da0@mx.google.com>
Date:   Fri, 07 May 2021 12:22:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.268-13-g4e1de7e3cc618
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 88 runs,
 5 regressions (v4.9.268-13-g4e1de7e3cc618)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 88 runs, 5 regressions (v4.9.268-13-g4e1de7e3=
cc618)

Regressions Summary
-------------------

platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =

qemu_x86_64          | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.268-13-g4e1de7e3cc618/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.268-13-g4e1de7e3cc618
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4e1de7e3cc61803ad44bb1628d97075ce165eb47 =



Test Regressions
---------------- =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60955fbae4457de5ca6f5467

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
3-g4e1de7e3cc618/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
3-g4e1de7e3cc618/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60955fbae4457de5ca6f5=
468
        failing since 174 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60955fc49fca819b3d6f5491

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
3-g4e1de7e3cc618/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
3-g4e1de7e3cc618/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60955fc49fca819b3d6f5=
492
        failing since 174 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60955fce9fca819b3d6f54a4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
3-g4e1de7e3cc618/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
3-g4e1de7e3cc618/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60955fce9fca819b3d6f5=
4a5
        failing since 174 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/60955f51e18cb97acb6f5467

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
3-g4e1de7e3cc618/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
3-g4e1de7e3cc618/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60955f51e18cb97acb6f5=
468
        failing since 174 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_x86_64          | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:     https://kernelci.org/test/plan/id/6095607d8fac7adf6e6f547b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
3-g4e1de7e3cc618/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x8=
6_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-1=
3-g4e1de7e3cc618/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x8=
6_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6095607d8fac7adf6e6f5=
47c
        new failure (last pass: v4.9.268-6-gad06dd89e8208) =

 =20
