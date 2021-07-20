Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40AE33CF44C
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 08:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238787AbhGTFcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 01:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238703AbhGTFcH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 01:32:07 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21D1C061574
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 23:12:38 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id p36so18672131pfw.11
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 23:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3F5xzPEfdzmaXDrpzlrkNpwjdFBsKW02DzTloPrh2xc=;
        b=cS2kI8ZELbeGdo3LFoQQqhOwj9mZZdL//fAh/IcOM0mmZkk76yEehz49IcIm74iMiE
         BNs1s12lTn3jWWw9vBEas5Mr6klJG7ENveIPArgZfJUmyxBrlYfBYwNcomLbj4agvFE4
         lLVfw0RJ3w/07EbHMcBoJZNp6iWXaKs5M6iIweiU+wvAgoxUVlYIZlmAqoSnhgRHbDm5
         XyuoYgdPFKEIdNIGRvg3OQEEiwtBq6UVpsb/jc5B1vgdwHpRxme527eBoz8TGGr68KIZ
         vGNWkWfh07KTcKJMc/STTEc2JDE2P06SZfrofe/JtTcM17gtYcv9hI0dnhhvSO+Rc1gA
         4cAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3F5xzPEfdzmaXDrpzlrkNpwjdFBsKW02DzTloPrh2xc=;
        b=rREDUWTfwjvc3HCAIuTYQgGKjDh29dsa59VyzNpM8ejsdds2Nb/dOI76gqDGjygrKh
         tu2bPFd1pRyQ/pi35nuW99G1PDL1I9ZAVJwTVDMFi/OpBT6ZIlOS/qFCGAHOaO1OJt8o
         uRmA6AYP5cAFsK9unkB6C29ZrDMYpkV40N1gUWpI/dU5czJ5e/bpD3gltT33kNrwcIEF
         scQOI1YhnjXa6F7YaNpeA2jHefjFVtCBRjhJJJ2a02JJpFeSQMdmFf7Yecdqb1p8T4Ss
         lnvuE76VOG9LSKWixFXGRmuMb1sfQWYyDJrMv8dGq4Y391zPGHW1AdJmr/0XIf8fFIyX
         LQkA==
X-Gm-Message-State: AOAM532JWUndy0m1G9x5f2nvR+X3+nL38jYZ04sbWE0TyFhqc0Lcz+vG
        NcX0CVOrC/eJ8O5SzFbtR7Kh+wk0Ng2xXg==
X-Google-Smtp-Source: ABdhPJwYZl3TS6sIRVqCXQxXcKZ2S1WWDcJTD008RNnZOGFj4utFW/jyIhxQhs+q5RrPbr9SyEhr+w==
X-Received: by 2002:a65:64c4:: with SMTP id t4mr29152872pgv.222.1626761558062;
        Mon, 19 Jul 2021 23:12:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m13sm21536585pfc.119.2021.07.19.23.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 23:12:37 -0700 (PDT)
Message-ID: <60f66955.1c69fb81.ffa48.1247@mx.google.com>
Date:   Mon, 19 Jul 2021 23:12:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.133-149-g0274752daa493
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 166 runs,
 7 regressions (v5.4.133-149-g0274752daa493)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 166 runs, 7 regressions (v5.4.133-149-g0274=
752daa493)

Regressions Summary
-------------------

platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
at91-sama5d4_xplained | arm    | lab-baylibre  | gcc-8    | sama5_defconfig=
     | 1          =

d2500cc               | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfi=
g    | 1          =

hifive-unleashed-a00  | riscv  | lab-baylibre  | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb  | arm    | lab-baylibre  | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb  | arm    | lab-broonie   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb  | arm    | lab-cip       | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb  | arm    | lab-collabora | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.133-149-g0274752daa493/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.133-149-g0274752daa493
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0274752daa4930914969a68f54289bfb81b6dfdd =



Test Regressions
---------------- =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
at91-sama5d4_xplained | arm    | lab-baylibre  | gcc-8    | sama5_defconfig=
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60f6335d427347f63e1160b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-149-g0274752daa493/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-149-g0274752daa493/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f6335d427347f63e116=
0b3
        failing since 464 days (last pass: v5.4.30-54-g6f04e8ca5355, first =
fail: v5.4.30-81-gf163418797b9) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
d2500cc               | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfi=
g    | 1          =


  Details:     https://kernelci.org/test/plan/id/60f630a2075d392cb9116129

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-149-g0274752daa493/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500=
cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-149-g0274752daa493/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500=
cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f630a2075d392cb9116=
12a
        new failure (last pass: v5.4.131) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
hifive-unleashed-a00  | riscv  | lab-baylibre  | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60f62c92d03c09b61a11619c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-149-g0274752daa493/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unle=
ashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-149-g0274752daa493/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unle=
ashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f62c92d03c09b61a116=
19d
        failing since 241 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
qemu_arm-versatilepb  | arm    | lab-baylibre  | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f62d2ab7ce2fcf3711609f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-149-g0274752daa493/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-149-g0274752daa493/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f62d2ab7ce2fcf37116=
0a0
        failing since 247 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
qemu_arm-versatilepb  | arm    | lab-broonie   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f62d34b7ce2fcf371160a7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-149-g0274752daa493/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-149-g0274752daa493/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f62d34b7ce2fcf37116=
0a8
        failing since 247 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
qemu_arm-versatilepb  | arm    | lab-cip       | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f62d20f69deb7ac21160ad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-149-g0274752daa493/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-149-g0274752daa493/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f62d20f69deb7ac2116=
0ae
        failing since 247 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform              | arch   | lab           | compiler | defconfig      =
     | regressions
----------------------+--------+---------------+----------+----------------=
-----+------------
qemu_arm-versatilepb  | arm    | lab-collabora | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60f62ce0aeb77ee8221160b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-149-g0274752daa493/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.133=
-149-g0274752daa493/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f62ce0aeb77ee822116=
0b3
        failing since 247 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
