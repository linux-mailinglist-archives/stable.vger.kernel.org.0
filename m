Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6090132F22B
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 19:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbhCESJe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 13:09:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbhCESJ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Mar 2021 13:09:27 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E18CC061574
        for <stable@vger.kernel.org>; Fri,  5 Mar 2021 10:09:27 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id c16so1824616ply.0
        for <stable@vger.kernel.org>; Fri, 05 Mar 2021 10:09:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GJPkKpLIp0PpJ5LWb9xsPRHl2RxFmt8i1M8834hm7kU=;
        b=U335hKqe53VSydmyzuu58T5LzJNzFSYoCCQy0cOIQqWb5VavtYvmMup8X89fzZto7l
         d36v7HutCx9EGknEsvUDtvwfP90lSl1WCpF2RV0DQcd9j3XPr3laIDh14Q7zI1+sfCj0
         EUvLVkqATYybyH4X1GM4SNFrcoq32kfMWskiSb1i9M8lPLCuVvCCFZDwiPIh0mfYcA/6
         dn09g+KvCWp9nvGwgOJZB5Jtjr236kgpL7VhgiZ0MdRqOr+U+s3UahIjMoz68fvwQ4Rq
         tHexCw5cmAprBxBVmr5/hzz+iTguHOjtT8hWcJR0njBWXHuFNiB1WkHLhsuC8IZW6XIF
         cXxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GJPkKpLIp0PpJ5LWb9xsPRHl2RxFmt8i1M8834hm7kU=;
        b=inO3VL+FvFbyrBMMv6RhwiY/syNHcq3GZ9MugOT4NKVubp69fGHrHcwF75KO4k43B+
         FEWyOG7XLjssyVWoVVI1XZrGSxwLYG2fFIptV+askYNaQQTRaELmsqa7KRX0fsfb3+T7
         /0fMRKjC4ppsGyRtR9552eC+nCJ86MqDD/Z1R1UiDsMF4hn6oKPnP9AcewZHdlVofA/k
         QL6Zag1YR6kHm65xv2fZyMmKU3vSLpvo8b2tnRVjDmCcNJWAQB/Sqq/us84pR+GYfQMI
         VvCJVVmRPfQ8WM8mNjAZWU7+ONWvZnhO3q4tjKu2DPbMYUbt5rx5akT+Aw0Mrv/z6836
         KoTw==
X-Gm-Message-State: AOAM530aSuwd/JYGM6ryJYMOdZNTRYqEvJ+jJ4l9FlL/qcL/rLHsSMLs
        GiafNDeX/px/bmMlfif1WsKi1MHy2/T+PFEw
X-Google-Smtp-Source: ABdhPJxOCpuf9rNJoV0qXbfNuStTiMyJTgOyOMmQ5paWeTvTBc3OEGXgO+K0XbNc8fUcz4SwnYd69Q==
X-Received: by 2002:a17:90a:a596:: with SMTP id b22mr11782874pjq.33.1614967766551;
        Fri, 05 Mar 2021 10:09:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y15sm3868368pgi.31.2021.03.05.10.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 10:09:26 -0800 (PST)
Message-ID: <604273d6.1c69fb81.5506f.9ffb@mx.google.com>
Date:   Fri, 05 Mar 2021 10:09:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.102-73-g2e10dba9fe0e6
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 164 runs,
 6 regressions (v5.4.102-73-g2e10dba9fe0e6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 164 runs, 6 regressions (v5.4.102-73-g2e10d=
ba9fe0e6)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.102-73-g2e10dba9fe0e6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.102-73-g2e10dba9fe0e6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2e10dba9fe0e67740146f3b3be42ed9403a7636e =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/604240f48a5b935105addcd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.102=
-73-g2e10dba9fe0e6/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unlea=
shed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.102=
-73-g2e10dba9fe0e6/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unlea=
shed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604240f48a5b935105add=
cd9
        failing since 105 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/604244a3383f4754c5addcbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.102=
-73-g2e10dba9fe0e6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.102=
-73-g2e10dba9fe0e6/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s9=
05d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604244a3383f4754c5add=
cbd
        new failure (last pass: v5.4.101-338-g44433bdfc6fdb) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60423faedf2e165a08addcd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.102=
-73-g2e10dba9fe0e6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.102=
-73-g2e10dba9fe0e6/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60423faedf2e165a08add=
cd3
        failing since 110 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60425bd602172f3813addcd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.102=
-73-g2e10dba9fe0e6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.102=
-73-g2e10dba9fe0e6/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60425bd602172f3813add=
cd4
        failing since 110 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/604266e56924771168adddb6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.102=
-73-g2e10dba9fe0e6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.102=
-73-g2e10dba9fe0e6/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/604266e56924771168add=
db7
        failing since 110 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/60423f570071bf3ad6addcb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.102=
-73-g2e10dba9fe0e6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.102=
-73-g2e10dba9fe0e6/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60423f570071bf3ad6add=
cba
        failing since 110 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
